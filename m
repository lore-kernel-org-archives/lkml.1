Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbXGaKPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbXGaKPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbXGaKPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:15:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:39291 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbXGaKPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=CUeJAY4c6JKV7gQjmE6TNipSVc+MnZwY2/AgsAzdQA7oLYKJ5Dyqy2ecVu7WVFPvY9Di2wdzDdRIaigZWBoimDLWV8epAb2Ie/uoaHebePvbtFMdcs83HoM62k1R7fNeZbA3GNlwzy7FRENyt1PXquXsybrUyiYhVPIb9ByP7YY=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 3/7] sysfs: cosmetic changes in sysfs_lookup()
In-Reply-To: <11858769082982-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 31 Jul 2007 19:15:08 +0900
Message-Id: <11858769083801-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* remove space between * and symbol name in variable declaration.

* kill unnecessary new line.

* kill 'found' and test 'sd' instead.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 1c3a0dd..026ea70 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -756,24 +756,19 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 				struct nameidata *nd)
 {
 	struct dentry *ret = NULL;
-	struct sysfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
-	struct sysfs_dirent * sd;
+	struct sysfs_dirent *parent_sd = dentry->d_parent->d_fsdata;
+	struct sysfs_dirent *sd;
 	struct bin_attribute *bin_attr;
 	struct inode *inode;
-	int found = 0;
 
 	mutex_lock(&sysfs_mutex);
 
-	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling) {
-		if (sysfs_type(sd) &&
-		    !strcmp(sd->s_name, dentry->d_name.name)) {
-			found = 1;
+	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling)
+		if (sysfs_type(sd) && !strcmp(sd->s_name, dentry->d_name.name))
 			break;
-		}
-	}
 
 	/* no such entry */
-	if (!found)
+	if (!sd)
 		goto out_unlock;
 
 	/* attach dentry and inode */
-- 
1.5.0.3


