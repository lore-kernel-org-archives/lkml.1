Return-Path: <linux-kernel-owner+w=401wt.eu-S1764472AbXEXAl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764472AbXEXAl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761810AbXEXAhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:37:07 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40254 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343AbXEXAhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:37:00 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 12/21] Unionfs: Prefix external functions with 'extern' properly
Date: Wed, 23 May 2007 20:36:02 -0400
Message-Id: <117996697398-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/sioq.h  |    1 +
 fs/unionfs/union.h |   50 +++++++++++++++++++++++++-------------------------
 2 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/unionfs/sioq.h b/fs/unionfs/sioq.h
index 5a96f66..55b781e 100644
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -74,6 +74,7 @@ struct sioq_args {
 	};
 };
 
+/* Extern definitions for SIOQ functions */
 extern int __init init_sioq(void);
 extern __exit void stop_sioq(void);
 extern void run_sioq(work_func_t func, struct sioq_args *args);
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index dab408f..5376b76 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -183,26 +183,26 @@ struct unionfs_dir_state {
 #include "fanout.h"
 #include "sioq.h"
 
-/* Cache creation/deletion routines. */
-void unionfs_destroy_filldir_cache(void);
-int unionfs_init_filldir_cache(void);
-int unionfs_init_inode_cache(void);
-void unionfs_destroy_inode_cache(void);
-int unionfs_init_dentry_cache(void);
-void unionfs_destroy_dentry_cache(void);
+/* externs for cache creation/deletion routines */
+extern void unionfs_destroy_filldir_cache(void);
+extern int unionfs_init_filldir_cache(void);
+extern int unionfs_init_inode_cache(void);
+extern void unionfs_destroy_inode_cache(void);
+extern int unionfs_init_dentry_cache(void);
+extern void unionfs_destroy_dentry_cache(void);
 
 /* Initialize and free readdir-specific  state. */
-int init_rdstate(struct file *file);
-struct unionfs_dir_state *alloc_rdstate(struct inode *inode, int bindex);
-struct unionfs_dir_state *find_rdstate(struct inode *inode, loff_t fpos);
-void free_rdstate(struct unionfs_dir_state *state);
-int add_filldir_node(struct unionfs_dir_state *rdstate, const char *name,
-		     int namelen, int bindex, int whiteout);
-struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
-				       const char *name, int namelen);
-
-struct dentry **alloc_new_dentries(int objs);
-struct unionfs_data *alloc_new_data(int objs);
+extern int init_rdstate(struct file *file);
+extern struct unionfs_dir_state *alloc_rdstate(struct inode *inode, int bindex);
+extern struct unionfs_dir_state *find_rdstate(struct inode *inode, loff_t fpos);
+extern void free_rdstate(struct unionfs_dir_state *state);
+extern int add_filldir_node(struct unionfs_dir_state *rdstate, const char *name,
+			    int namelen, int bindex, int whiteout);
+extern struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
+					      const char *name, int namelen);
+
+extern struct dentry **alloc_new_dentries(int objs);
+extern struct unionfs_data *alloc_new_data(int objs);
 
 /* We can only use 32-bits of offset for rdstate --- blech! */
 #define DIREOF (0xfffff)
@@ -236,8 +236,8 @@ static inline void unionfs_double_lock_dentry(struct dentry *d1,
 }
 
 extern int new_dentry_private_data(struct dentry *dentry);
-void free_dentry_private_data(struct unionfs_dentry_info *udi);
-void update_bstart(struct dentry *dentry);
+extern void free_dentry_private_data(struct unionfs_dentry_info *udi);
+extern void update_bstart(struct dentry *dentry);
 
 /*
  * EXTERNALS:
@@ -246,6 +246,7 @@ void update_bstart(struct dentry *dentry);
 /* replicates the directory structure up to given dentry in given branch */
 extern struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
 				     int bindex);
+extern int make_dir_opaque(struct dentry *dir, int bindex);
 
 /* partial lookup */
 extern int unionfs_partial_lookup(struct dentry *dentry);
@@ -304,10 +305,11 @@ extern long unionfs_ioctl(struct file *file, unsigned int cmd,
 /* Inode operations */
 extern int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry);
-int unionfs_unlink(struct inode *dir, struct dentry *dentry);
-int unionfs_rmdir(struct inode *dir, struct dentry *dentry);
+extern int unionfs_unlink(struct inode *dir, struct dentry *dentry);
+extern int unionfs_rmdir(struct inode *dir, struct dentry *dentry);
 
-int __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd);
+extern int __unionfs_d_revalidate_chain(struct dentry *dentry,
+					struct nameidata *nd);
 
 /* The values for unionfs_interpose's flag. */
 #define INTERPOSE_DEFAULT	0
@@ -454,8 +456,6 @@ static inline void unlock_dir(struct dentry *dir)
 	dput(dir);
 }
 
-extern int make_dir_opaque(struct dentry *dir, int bindex);
-
 static inline struct vfsmount *unionfs_mntget(struct dentry *dentry,
 					      int bindex)
 {
-- 
1.5.2.rc1.165.gaf9b

