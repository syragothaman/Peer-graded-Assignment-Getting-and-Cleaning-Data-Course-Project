# Getting and Cleaning Data Course Project
# By: Sowmya Ragothaman


install.packages("dplyr")
library(dplyr)

file <- "Course_Project.zip"

# Check if archive exists
if (!file.exists(file)){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, file, method = "curl")
}  

# Check if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file) 
}

# Assign data frames their names
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("key", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "key")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "key")

# Merge test and train sets into one data set
x <- rbind(xtrain, xtest)
y <- rbind(ytrain, ytest)
Subject <- rbind(subjecttrain, subjecttest)
data <- cbind(Subject, y, x)

# Extract means and stdevs, name the activities
cleaneddata <- data %>% select(subject, key, contains("mean"), contains("std"))
cleaneddata$key <- activities[cleaneddata$key, 2]

# Label w/ variable names
names(cleaneddata)[2] = "Activity"
names(cleaneddata) <- gsub("Acc", "Accelerometer", names(cleaneddata))
names(cleaneddata) <- gsub("Gyro", "Gyroscope", names(cleaneddata))
names(cleaneddata) <- gsub("Mag", "Magnitude", names(cleaneddata))
names(cleaneddata) <- gsub("-mean()", "Mean", names(cleaneddata), ignore.case = TRUE)
names(cleaneddata) <- gsub("-std()", "STD", names(cleaneddata), ignore.case = TRUE)
names(cleaneddata) <- gsub("-freq()", "Frequency", names(cleaneddata), ignore.case = TRUE)
names(cleaneddata) <- gsub("tBody", "TimeBody", names(cleaneddata))
names(cleaneddata) <- gsub("gravity", "Gravity", names(cleaneddata))
names(cleaneddata) <- gsub("angle", "Angle", names(cleaneddata))
names(cleaneddata) <- gsub("^t", "Time", names(cleaneddata))
names(cleaneddata) <- gsub("^f", "Frequency", names(cleaneddata))
names(cleaneddata) <- gsub("BodyBody", "Body", names(cleaneddata))

# Average of each variable in each subject
indeptinydata <- cleaneddata %>% group_by(subject, Activity) %>% summarise_all(funs(mean))
write.table(indeptinydata, "Final_Data_set.txt", row.name = FALSE)

# Check to see how the data sets turned out
str(indeptinydata)
cleaneddata
indeptinydata
