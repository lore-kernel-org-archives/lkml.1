Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbXITILt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbXITILt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbXITIGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:41325 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbXITIF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=dTSEC1Gsm0wGnRGGiNs763Rs1k26gRwpwxNrU7bUgBtY3OV5aBAojg+WY0SdR3ETyqL5jZPSevGbaoQJ6ybbT12l1leOV8uv5cPxeUdTvV0oo3CbP/6XeVsIfHmdtit8IdSfvQR35T7VutNq+8sjOHwBYvslQjxdVK7TCpAfc1Q=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 09/22] sysfs: rename internal function sysfs_add_file()
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:40 +0900
Message-Id: <11902755403992-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The function name sysfs_add_file() will be used for sd-based file
interface.  Rename the internal function to __sysfs_add_file().  Note
that the internal function will be removed once the new interface is
in place, so double underscore prefix should do it for the time being.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c   |    2 +-
 fs/sysfs/file.c  |    6 +++---
 fs/sysfs/group.c |    2 +-
 fs/sysfs/sysfs.h |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 91e573f..20c2e78 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -234,7 +234,7 @@ int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr)
 {
 	BUG_ON(!kobj || !kobj->sd || !attr);
 
-	return sysfs_add_file(kobj->sd, &attr->attr, SYSFS_KOBJ_BIN_ATTR);
+	return __sysfs_add_file(kobj->sd, &attr->attr, SYSFS_KOBJ_BIN_ATTR);
 }
 
 EXPORT_SYMBOL_GPL(sysfs_create_bin_file);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 8154fbb..3b74912 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -568,7 +568,7 @@ const struct file_operations sysfs_file_operations = {
 };
 
 
-int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
+int __sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 		   int type)
 {
 	umode_t mode = attr->mode & S_IALLUGO;
@@ -602,7 +602,7 @@ int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
 {
 	BUG_ON(!kobj || !kobj->sd || !attr);
 
-	return sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
+	return __sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
 
 }
 
@@ -623,7 +623,7 @@ int sysfs_add_file_to_group(struct kobject *kobj,
 	if (!dir_sd)
 		return -ENOENT;
 
-	error = sysfs_add_file(dir_sd, attr, SYSFS_KOBJ_ATTR);
+	error = __sysfs_add_file(dir_sd, attr, SYSFS_KOBJ_ATTR);
 	sysfs_put(dir_sd);
 
 	return error;
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index e4993fd..5c5aab0 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -32,7 +32,7 @@ static int create_files(struct sysfs_dirent *dir_sd,
 	int error = 0;
 
 	for (attr = grp->attrs; *attr && !error; attr++)
-		error = sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
+		error = __sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
 	if (error)
 		remove_files(dir_sd, grp);
 	return error;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 82ade38..c57b2dc 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -142,8 +142,8 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 extern const struct file_operations sysfs_file_operations;
 
 void sysfs_file_check_suicide(struct sysfs_dirent *sd);
-int sysfs_add_file(struct sysfs_dirent *dir_sd,
-		   const struct attribute *attr, int type);
+int __sysfs_add_file(struct sysfs_dirent *dir_sd,
+		     const struct attribute *attr, int type);
 
 /*
  * bin.c
-- 
1.5.0.3


