Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbXEXAkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbXEXAkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761128AbXEXAgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:45 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40233 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760725AbXEXAgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:32 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 09/21] Unionfs: Rename our "do_rename" to __unionfs_rename
Date: Wed, 23 May 2007 20:35:59 -0400
Message-Id: <1179966973293-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

To avoid confusion with the VFS function do_rename, and to help ctags,
rename our utility (static) function do_rename to __unionfs_rename.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/rename.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 0e1e71a..edc5a5c 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -18,9 +18,9 @@
 
 #include "union.h"
 
-static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
-		     struct inode *new_dir, struct dentry *new_dentry,
-		     int bindex, struct dentry **wh_old)
+static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			    struct inode *new_dir, struct dentry *new_dentry,
+			    int bindex, struct dentry **wh_old)
 {
 	int err = 0;
 	struct dentry *hidden_old_dentry;
@@ -144,7 +144,7 @@ out:
 /*
  * Main rename code.  This is sufficienly complex, that it's documented in
  * Docmentation/filesystems/unionfs/rename.txt.  This routine calls
- * do_rename() above to perform some of the work.
+ * __unionfs_rename() above to perform some of the work.
  */
 static int do_unionfs_rename(struct inode *old_dir,
 			     struct dentry *old_dentry,
@@ -171,8 +171,8 @@ static int do_unionfs_rename(struct inode *old_dir,
 	new_bend = dbend(new_dentry);
 
 	/* Rename source to destination. */
-	err = do_rename(old_dir, old_dentry, new_dir, new_dentry, old_bstart,
-			&wh_old);
+	err = __unionfs_rename(old_dir, old_dentry, new_dir, new_dentry,
+			       old_bstart, &wh_old);
 	if (err) {
 		if (!IS_COPYUP_ERR(err))
 			goto out;
@@ -230,8 +230,9 @@ static int do_unionfs_rename(struct inode *old_dir,
 			if (!err) {
 				dput(wh_old);
 				bwh_old = bindex;
-				err = do_rename(old_dir, old_dentry, new_dir,
-						new_dentry, bindex, &wh_old);
+				err = __unionfs_rename(old_dir, old_dentry,
+						       new_dir, new_dentry,
+						       bindex, &wh_old);
 				break;
 			}
 		}
@@ -306,8 +307,8 @@ revert:
 		goto revert_out;
 	}
 
-	local_err = do_rename(new_dir, new_dentry,
-			      old_dir, old_dentry, old_bstart, NULL);
+	local_err = __unionfs_rename(new_dir, new_dentry,
+				     old_dir, old_dentry, old_bstart, NULL);
 
 	/* If we can't fix it, then we cop-out with -EIO. */
 	if (local_err) {
-- 
1.5.2.rc1.165.gaf9b

