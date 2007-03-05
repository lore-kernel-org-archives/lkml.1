Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXCEB4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXCEB4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXCEBzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:55:45 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38377 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbXCEBzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:23 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 05/13] fs/unionfs/: Rename unionfs_d_revalidate_wrap
Date: Sun,  4 Mar 2007 20:54:55 -0500
Message-Id: <11730597041625-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the convention of "foo" calling "__foo".

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    2 +-
 fs/unionfs/dentry.c     |    9 ++++-----
 fs/unionfs/union.h      |    2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 66d6ce9..2664be9 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -228,7 +228,7 @@ int unionfs_file_revalidate(struct file *file, int willwrite)
 	unionfs_lock_dentry(dentry);
 	sb = dentry->d_sb;
 	unionfs_read_lock(sb);
-	if (!unionfs_d_revalidate(dentry, NULL) && !d_deleted(dentry)) {
+	if (!__unionfs_d_revalidate(dentry, NULL) && !d_deleted(dentry)) {
 		err = -ESTALE;
 		goto out_nofree;
 	}
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index ac4bf0e..cae4897 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -21,7 +21,7 @@
 /*
  * returns 1 if valid, 0 otherwise.
  */
-int unionfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
+int __unionfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	int valid = 1;		/* default is valid (1); invalid is 0. */
 	struct dentry *hidden_dentry;
@@ -174,13 +174,12 @@ out:
 	return valid;
 }
 
-static int unionfs_d_revalidate_wrap(struct dentry *dentry,
-				     struct nameidata *nd)
+static int unionfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	int err;
 
 	unionfs_lock_dentry(dentry);
-	err = unionfs_d_revalidate(dentry, nd);
+	err = __unionfs_d_revalidate(dentry, nd);
 	unionfs_unlock_dentry(dentry);
 
 	return err;
@@ -226,7 +225,7 @@ out:
 }
 
 struct dentry_operations unionfs_dops = {
-	.d_revalidate	= unionfs_d_revalidate_wrap,
+	.d_revalidate	= unionfs_d_revalidate,
 	.d_release	= unionfs_d_release,
 };
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 60276c7..bae3c76 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -296,7 +296,7 @@ extern int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 int unionfs_unlink(struct inode *dir, struct dentry *dentry);
 int unionfs_rmdir(struct inode *dir, struct dentry *dentry);
 
-int unionfs_d_revalidate(struct dentry *dentry, struct nameidata *nd);
+int __unionfs_d_revalidate(struct dentry *dentry, struct nameidata *nd);
 
 /* The values for unionfs_interpose's flag. */
 #define INTERPOSE_DEFAULT	0
-- 
1.5.0.2.260.g2eb065

