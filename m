Return-Path: <linux-kernel-owner+w=401wt.eu-S1764758AbXEXAmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764758AbXEXAmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761228AbXEXAhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:37:15 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40259 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761645AbXEXAhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:37:00 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 08/21] Unionfs: Rename Unionfs's double_lock_dentry to avoid confusion
Date: Wed, 23 May 2007 20:35:58 -0400
Message-Id: <11799669722532-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

To avoid potential confusion with a VFS function, rename our version of
double_lock_dentry to unionfs_double_lock_dentry.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/inode.c  |    2 +-
 fs/unionfs/rename.c |    2 +-
 fs/unionfs/union.h  |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index c54b290..627c2a7 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -265,7 +265,7 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 	BUG_ON(!is_valid_dentry(new_dentry));
 	BUG_ON(!is_valid_dentry(old_dentry));
 
-	double_lock_dentry(new_dentry, old_dentry);
+	unionfs_double_lock_dentry(new_dentry, old_dentry);
 
 	hidden_new_dentry = unionfs_lower_dentry(new_dentry);
 
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 231866e..0e1e71a 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -400,7 +400,7 @@ int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	BUG_ON(!is_valid_dentry(old_dentry));
 	BUG_ON(!is_valid_dentry(new_dentry));
 
-	double_lock_dentry(old_dentry, new_dentry);
+	unionfs_double_lock_dentry(old_dentry, new_dentry);
 
 	if (!S_ISDIR(old_dentry->d_inode->i_mode))
 		err = unionfs_partial_lookup(old_dentry);
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 0ce3a27..fee4f88 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -223,7 +223,8 @@ static inline off_t rdstate2offset(struct unionfs_dir_state *buf)
 #define unionfs_write_lock(sb)	 down_write(&UNIONFS_SB(sb)->rwsem)
 #define unionfs_write_unlock(sb) up_write(&UNIONFS_SB(sb)->rwsem)
 
-static inline void double_lock_dentry(struct dentry *d1, struct dentry *d2)
+static inline void unionfs_double_lock_dentry(struct dentry *d1,
+					      struct dentry *d2)
 {
 	if (d2 < d1) {
 		struct dentry *tmp = d1;
-- 
1.5.2.rc1.165.gaf9b

