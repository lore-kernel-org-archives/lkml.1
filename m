Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbXITIOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbXITIOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbXITIG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:42005 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092AbXITIGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=T64tHRYP3OTt6hba1Kdpo8oJaO7476TmI70JSnptDdyDVcgroRCqJFGS45MXOKmEzcqwWI9iCj+9DwihvZoje0+BVc9c6g8C84tNULTjj9m5E4sqegfw+26xM1Vngc3XIKMIozrzA3uO6npS9Y6nlTHVWjzCABBBetmESBV3xNk=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 21/22] sysfs: kill sysfs_hash_and_remove()
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:42 +0900
Message-Id: <11902755423413-git-send-email-htejun@gmail.com>
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

Kill now unused sysfs_hash_and_remove().

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/inode.c |   22 ----------------------
 fs/sysfs/sysfs.h |    1 -
 2 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 8df357e..0aeea4b 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -202,25 +202,3 @@ struct inode * sysfs_get_inode(struct sysfs_dirent *sd)
 
 	return inode;
 }
-
-int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
-{
-	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent *sd;
-
-	if (!dir_sd)
-		return -ENOENT;
-
-	sysfs_addrm_start(&acxt);
-
-	sd = sysfs_find_dirent(dir_sd, name);
-	if (sd)
-		sysfs_remove_one(&acxt, sd);
-
-	sysfs_addrm_finish(&acxt);
-
-	if (sd)
-		return 0;
-	else
-		return -ENOENT;
-}
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 62239e3..69e1451 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -137,7 +137,6 @@ static inline void sysfs_put(struct sysfs_dirent *sd)
  */
 struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
-int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 
 /*
  * file.c
-- 
1.5.0.3


