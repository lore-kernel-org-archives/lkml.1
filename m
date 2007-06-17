Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbXFQTLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbXFQTLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761033AbXFQTJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:09:52 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36836 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760798AbXFQTJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:09:46 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 14/16] Unionfs: Add BUG_ONs to unionfs_lower_*
Date: Sun, 17 Jun 2007 15:09:21 -0400
Message-Id: <11821073652354-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/fanout.h |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index 0319835..d4933ce 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -42,16 +42,19 @@ static inline struct unionfs_inode_info *UNIONFS_I(const struct inode *inode)
 /* macros to manipulate branch IDs in stored in our superblock */
 static inline int branch_id(struct super_block *sb, int index)
 {
+	BUG_ON(!sb || index < 0);
 	return UNIONFS_SB(sb)->data[index].branch_id;
 }
 
 static inline void set_branch_id(struct super_block *sb, int index, int val)
 {
+	BUG_ON(!sb || index < 0);
 	UNIONFS_SB(sb)->data[index].branch_id = val;
 }
 
 static inline void new_branch_id(struct super_block *sb, int index)
 {
+	BUG_ON(!sb || index < 0);
 	set_branch_id(sb, index, ++UNIONFS_SB(sb)->high_branch_id);
 }
 
@@ -82,18 +85,21 @@ static inline int branch_id_to_idx(struct super_block *sb, int id)
 /* File to lower file. */
 static inline struct file *unionfs_lower_file(const struct file *f)
 {
+	BUG_ON(!f);
 	return UNIONFS_F(f)->lower_files[fbstart(f)];
 }
 
 static inline struct file *unionfs_lower_file_idx(const struct file *f,
 						  int index)
 {
+	BUG_ON(!f || index < 0);
 	return UNIONFS_F(f)->lower_files[index];
 }
 
 static inline void unionfs_set_lower_file_idx(struct file *f, int index,
 					      struct file *val)
 {
+	BUG_ON(!f || index < 0);
 	UNIONFS_F(f)->lower_files[index] = val;
 	/* save branch ID (may be redundant?) */
 	UNIONFS_F(f)->saved_branch_ids[index] =
@@ -102,29 +108,34 @@ static inline void unionfs_set_lower_file_idx(struct file *f, int index,
 
 static inline void unionfs_set_lower_file(struct file *f, struct file *val)
 {
+	BUG_ON(!f);
 	unionfs_set_lower_file_idx((f), fbstart(f), (val));
 }
 
 /* Inode to lower inode. */
 static inline struct inode *unionfs_lower_inode(const struct inode *i)
 {
+	BUG_ON(!i);
 	return UNIONFS_I(i)->lower_inodes[ibstart(i)];
 }
 
 static inline struct inode *unionfs_lower_inode_idx(const struct inode *i,
 						    int index)
 {
+	BUG_ON(!i || index < 0);
 	return UNIONFS_I(i)->lower_inodes[index];
 }
 
 static inline void unionfs_set_lower_inode_idx(struct inode *i, int index,
 					       struct inode *val)
 {
+	BUG_ON(!i || index < 0);
 	UNIONFS_I(i)->lower_inodes[index] = val;
 }
 
 static inline void unionfs_set_lower_inode(struct inode *i, struct inode *val)
 {
+	BUG_ON(!i);
 	UNIONFS_I(i)->lower_inodes[ibstart(i)] = val;
 }
 
@@ -132,6 +143,7 @@ static inline void unionfs_set_lower_inode(struct inode *i, struct inode *val)
 static inline struct super_block *unionfs_lower_super(
 					const struct super_block *sb)
 {
+	BUG_ON(!sb);
 	return UNIONFS_SB(sb)->data[sbstart(sb)].sb;
 }
 
@@ -139,6 +151,7 @@ static inline struct super_block *unionfs_lower_super_idx(
 					const struct super_block *sb,
 					int index)
 {
+	BUG_ON(!sb || index < 0);
 	return UNIONFS_SB(sb)->data[index].sb;
 }
 
@@ -146,75 +159,89 @@ static inline void unionfs_set_lower_super_idx(struct super_block *sb,
 					       int index,
 					       struct super_block *val)
 {
+	BUG_ON(!sb || index < 0);
 	UNIONFS_SB(sb)->data[index].sb = val;
 }
 
 static inline void unionfs_set_lower_super(struct super_block *sb,
 					   struct super_block *val)
 {
+	BUG_ON(!sb);
 	UNIONFS_SB(sb)->data[sbstart(sb)].sb = val;
 }
 
 /* Branch count macros. */
 static inline int branch_count(const struct super_block *sb, int index)
 {
+	BUG_ON(!sb || index < 0);
 	return atomic_read(&UNIONFS_SB(sb)->data[index].open_files);
 }
 
 static inline void set_branch_count(struct super_block *sb, int index, int val)
 {
+	BUG_ON(!sb || index < 0);
 	atomic_set(&UNIONFS_SB(sb)->data[index].open_files, val);
 }
 
 static inline void branchget(struct super_block *sb, int index)
 {
+	BUG_ON(!sb || index < 0);
 	atomic_inc(&UNIONFS_SB(sb)->data[index].open_files);
 }
 
 static inline void branchput(struct super_block *sb, int index)
 {
+	BUG_ON(!sb || index < 0);
 	atomic_dec(&UNIONFS_SB(sb)->data[index].open_files);
 }
 
 /* Dentry macros */
 static inline struct unionfs_dentry_info *UNIONFS_D(const struct dentry *dent)
 {
+	BUG_ON(!dent);
 	return dent->d_fsdata;
 }
 
 static inline int dbstart(const struct dentry *dent)
 {
+	BUG_ON(!dent);
 	return UNIONFS_D(dent)->bstart;
 }
 
 static inline void set_dbstart(struct dentry *dent, int val)
 {
+	BUG_ON(!dent);
 	UNIONFS_D(dent)->bstart = val;
 }
 
 static inline int dbend(const struct dentry *dent)
 {
+	BUG_ON(!dent);
 	return UNIONFS_D(dent)->bend;
 }
 
 static inline void set_dbend(struct dentry *dent, int val)
 {
+	BUG_ON(!dent);
 	UNIONFS_D(dent)->bend = val;
 }
 
 static inline int dbopaque(const struct dentry *dent)
 {
+	BUG_ON(!dent);
 	return UNIONFS_D(dent)->bopaque;
 }
 
 static inline void set_dbopaque(struct dentry *dent, int val)
 {
+	BUG_ON(!dent);
 	UNIONFS_D(dent)->bopaque = val;
 }
 
 static inline void unionfs_set_lower_dentry_idx(struct dentry *dent, int index,
 						struct dentry *val)
 {
+	BUG_ON(!dent || index < 0);
 	UNIONFS_D(dent)->lower_paths[index].dentry = val;
 }
 
@@ -222,17 +249,20 @@ static inline struct dentry *unionfs_lower_dentry_idx(
 				const struct dentry *dent,
 				int index)
 {
+	BUG_ON(!dent || index < 0);
 	return UNIONFS_D(dent)->lower_paths[index].dentry;
 }
 
 static inline struct dentry *unionfs_lower_dentry(const struct dentry *dent)
 {
+	BUG_ON(!dent);
 	return unionfs_lower_dentry_idx(dent, dbstart(dent));
 }
 
 static inline void unionfs_set_lower_mnt_idx(struct dentry *dent, int index,
 					     struct vfsmount *mnt)
 {
+	BUG_ON(!dent || index < 0);
 	UNIONFS_D(dent)->lower_paths[index].mnt = mnt;
 }
 
@@ -240,27 +270,32 @@ static inline struct vfsmount *unionfs_lower_mnt_idx(
 					const struct dentry *dent,
 					int index)
 {
+	BUG_ON(!dent || index < 0);
 	return UNIONFS_D(dent)->lower_paths[index].mnt;
 }
 
 static inline struct vfsmount *unionfs_lower_mnt(const struct dentry *dent)
 {
+	BUG_ON(!dent);
 	return unionfs_lower_mnt_idx(dent, dbstart(dent));
 }
 
 /* Macros for locking a dentry. */
 static inline void unionfs_lock_dentry(struct dentry *d)
 {
+	BUG_ON(!d);
 	mutex_lock(&UNIONFS_D(d)->lock);
 }
 
 static inline void unionfs_unlock_dentry(struct dentry *d)
 {
+	BUG_ON(!d);
 	mutex_unlock(&UNIONFS_D(d)->lock);
 }
 
 static inline void verify_locked(struct dentry *d)
 {
+	BUG_ON(!d);
 	BUG_ON(!mutex_is_locked(&UNIONFS_D(d)->lock));
 }
 
-- 
1.5.2.rc1.165.gaf9b

