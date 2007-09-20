Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbXITIOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbXITIOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759804AbXITIGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:30 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33382 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209AbXITIGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=C8PGjswvRFGoRLUBXE8kRRss+KH9N+knxfJd9WlZWoZNPVRtHaSfHlNalJCSLZC6oZadYrHJxbuAPapwj9kpeOKOx6nrN3M2wHmzPzTph7PasD6J6PQVlKmsYhjTirfB8xtJpRji3ZHO+CCggtoaoOoqKR0Iv7rK9owx14okQ+U=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 20/22] sysfs: kill now unused __sysfs_add_file()
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:42 +0900
Message-Id: <11902755423933-git-send-email-htejun@gmail.com>
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

Kill now unused __sysfs_add_file().

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/file.c  |   23 -----------------------
 fs/sysfs/sysfs.h |    2 --
 2 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4c0e29f..1d93940 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -556,26 +556,3 @@ struct sysfs_dirent *sysfs_add_file(struct sysfs_dirent *parent,
 	return sysfs_insert_one(parent, sd);
 }
 EXPORT_SYMBOL(sysfs_add_file);
-
-int __sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
-		   int type)
-{
-	umode_t mode = attr->mode & S_IALLUGO;
-	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent *sd;
-	int rc;
-
-	sd = sysfs_new_dirent(attr->name, mode, type);
-	if (!sd)
-		return -ENOMEM;
-	sd->s_file.data = (void *)attr;
-
-	sysfs_addrm_start(&acxt);
-	rc = sysfs_add_one(&acxt, dir_sd, sd);
-	sysfs_addrm_finish(&acxt);
-
-	if (rc)
-		sysfs_put(sd);
-
-	return rc;
-}
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 16ecd6a..62239e3 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -145,8 +145,6 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 extern const struct file_operations sysfs_file_operations;
 
 void sysfs_file_check_suicide(struct sysfs_dirent *sd);
-int __sysfs_add_file(struct sysfs_dirent *dir_sd,
-		     const struct attribute *attr, int type);
 
 /*
  * bin.c
-- 
1.5.0.3


