Return-Path: <linux-kernel-owner+w=401wt.eu-S934403AbXICCl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403AbXICCl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934210AbXICCfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:35:03 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:58306 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760217AbXICCe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:34:59 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 29/32] Unionfs: assorted comment and style updates
Date: Sun,  2 Sep 2007 22:20:52 -0400
Message-Id: <11887860594104-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/dirhelper.c |    2 --
 fs/unionfs/fanout.h    |    9 +++------
 fs/unionfs/file.c      |    6 ------
 fs/unionfs/inode.c     |    2 +-
 fs/unionfs/lookup.c    |    2 +-
 fs/unionfs/main.c      |    7 +++----
 fs/unionfs/rename.c    |    8 ++++----
 fs/unionfs/super.c     |    7 ++++++-
 fs/unionfs/union.h     |   14 +++++++-------
 fs/unionfs/unlink.c    |    1 -
 10 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/fs/unionfs/dirhelper.c b/fs/unionfs/dirhelper.c
index 24bd327..a72f711 100644
--- a/fs/unionfs/dirhelper.c
+++ b/fs/unionfs/dirhelper.c
@@ -31,7 +31,6 @@ int do_delete_whiteouts(struct dentry *dentry, int bindex,
 	struct dentry *lower_dentry;
 	char *name = NULL, *p;
 	struct inode *lower_dir;
-
 	int i;
 	struct list_head *pos;
 	struct filldir_node *cursor;
@@ -95,7 +94,6 @@ int delete_whiteouts(struct dentry *dentry, int bindex,
 	struct super_block *sb;
 	struct dentry *lower_dir_dentry;
 	struct inode *lower_dir;
-
 	struct sioq_args args;
 
 	sb = dentry->d_sb;
diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index 5908bc7..c5bf454 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -65,9 +65,9 @@ static inline void new_branch_id(struct super_block *sb, int index)
 }
 
 /*
- * Find new index of matching branch with an existing superblock a a known
+ * Find new index of matching branch with an existing superblock of a known
  * (possibly old) id.  This is needed because branches could have been
- * added/deleted causing the branchs of any open files to shift.
+ * added/deleted causing the branches of any open files to shift.
  *
  * @sb: the new superblock which may have new/different branch IDs
  * @id: the old/existing id we're looking for
@@ -80,10 +80,7 @@ static inline int branch_id_to_idx(struct super_block *sb, int id)
 		if (branch_id(sb, i) == id)
 			return i;
 	}
-	/*
-	 * XXX: maybe we should BUG_ON if not found new branch index?
-	 * (really that should never happen).
-	 */
+	/* in the non-ODF code, this should really never happen */
 	printk(KERN_WARNING "unionfs: cannot find branch with id %d\n", id);
 	return -1;
 }
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index b55da4f..b33f44f 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -18,17 +18,12 @@
 
 #include "union.h"
 
-/*******************
- * File Operations *
- *******************/
-
 static ssize_t unionfs_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
 	int err;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
 
@@ -50,7 +45,6 @@ static ssize_t unionfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	struct file *file = iocb->ki_filp;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
 
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 4574fbe..218320e 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -781,7 +781,6 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		if (err) {
 			if (!IS_COPYUP_ERR(err))
 				goto out;
-
 			bstart--;
 		} else
 			whiteout_unlinked = 1;
@@ -882,6 +881,7 @@ static int unionfs_readlink(struct dentry *dentry, char __user *buf,
 out:
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
+
 	return err;
 }
 
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 38ee21f..7fa6310 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -197,7 +197,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 
 		/* check if whiteout exists in this branch: lookup .wh.foo */
 		wh_lower_dentry = lookup_one_len(whname, lower_dir_dentry,
-						  namelen + UNIONFS_WHLEN);
+						 namelen + UNIONFS_WHLEN);
 		if (IS_ERR(wh_lower_dentry)) {
 			dput(first_lower_dentry);
 			unionfs_mntput(first_dentry, first_dentry_offset);
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index ce08d96..4faae44 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -226,6 +226,7 @@ void unionfs_reinterpose(struct dentry *dentry)
  */
 int check_branch(struct nameidata *nd)
 {
+	/* XXX: remove in ODF code -- stacking unions allowed there */
 	if (!strcmp(nd->dentry->d_sb->s_type->name, "unionfs"))
 		return -EINVAL;
 	if (!nd->dentry->d_inode)
@@ -298,7 +299,6 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 	int bindex = 0;
 	int i = 0;
 	int j = 0;
-
 	struct dentry *dent1;
 	struct dentry *dent2;
 
@@ -449,8 +449,8 @@ out:
  * We want to mount our stackable file system on top of that lower directory.
  */
 static struct unionfs_dentry_info *unionfs_parse_options(
-					struct super_block *sb,
-					char *options)
+					 struct super_block *sb,
+					 char *options)
 {
 	struct unionfs_dentry_info *lower_root_info;
 	char *optname;
@@ -584,7 +584,6 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 			      int silent)
 {
 	int err = 0;
-
 	struct unionfs_dentry_info *lower_root_info = NULL;
 	int bindex, bstart, bend;
 
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index a02d678..7aa7e57 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -56,8 +56,8 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	lower_wh_dentry = lookup_one_len(wh_name, lower_new_dentry->d_parent,
-					  new_dentry->d_name.len +
-					  UNIONFS_WHLEN);
+					 new_dentry->d_name.len +
+					 UNIONFS_WHLEN);
 	if (IS_ERR(lower_wh_dentry)) {
 		err = PTR_ERR(lower_wh_dentry);
 		goto out;
@@ -143,8 +143,8 @@ out:
 }
 
 /*
- * Main rename code.  This is sufficienly complex, that it's documented in
- * Docmentation/filesystems/unionfs/rename.txt.  This routine calls
+ * Main rename code.  This is sufficiently complex, that it's documented in
+ * Documentation/filesystems/unionfs/rename.txt.  This routine calls
  * __unionfs_rename() above to perform some of the work.
  */
 static int do_unionfs_rename(struct inode *old_dir,
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 339afab..3f972df 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -136,13 +136,18 @@ static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 	/* set return buf to our f/s to avoid confusing user-level utils */
 	buf->f_type = UNIONFS_SUPER_MAGIC;
-
 	/*
 	 * Our maximum file name can is shorter by a few bytes because every
 	 * file name could potentially be whited-out.
+	 *
+	 * XXX: this restriction goes away with ODF.
 	 */
 	buf->f_namelen -= UNIONFS_WHLEN;
 
+	/*
+	 * reset two fields to avoid confusing user-land.
+	 * XXX: is this still necessary?
+	 */
 	memset(&buf->f_fsid, 0, sizeof(__kernel_fsid_t));
 	memset(&buf->f_spare, 0, sizeof(buf->f_spare));
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index d1232ac..ce43a50 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -203,11 +203,14 @@ extern void unionfs_destroy_dentry_cache(void);
 
 /* Initialize and free readdir-specific  state. */
 extern int init_rdstate(struct file *file);
-extern struct unionfs_dir_state *alloc_rdstate(struct inode *inode, int bindex);
-extern struct unionfs_dir_state *find_rdstate(struct inode *inode, loff_t fpos);
+extern struct unionfs_dir_state *alloc_rdstate(struct inode *inode,
+					       int bindex);
+extern struct unionfs_dir_state *find_rdstate(struct inode *inode,
+					      loff_t fpos);
 extern void free_rdstate(struct unionfs_dir_state *state);
-extern int add_filldir_node(struct unionfs_dir_state *rdstate, const char *name,
-			    int namelen, int bindex, int whiteout);
+extern int add_filldir_node(struct unionfs_dir_state *rdstate,
+			    const char *name, int namelen, int bindex,
+			    int whiteout);
 extern struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
 					      const char *name, int namelen);
 
@@ -373,16 +376,13 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 static inline int branchperms(const struct super_block *sb, int index)
 {
 	BUG_ON(index < 0);
-
 	return UNIONFS_SB(sb)->data[index].branchperms;
 }
 
 static inline int set_branchperms(struct super_block *sb, int index, int perms)
 {
 	BUG_ON(index < 0);
-
 	UNIONFS_SB(sb)->data[index].branchperms = perms;
-
 	return perms;
 }
 
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index 1e5bfce..50ed351 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -54,7 +54,6 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 	if (err) {
 		if (dbstart(dentry) == 0)
 			goto out;
-
 		err = create_whiteout(dentry, dbstart(dentry) - 1);
 	} else if (dbopaque(dentry) != -1)
 		/* There is a lower lower-priority file with the same name. */
-- 
1.5.2.2.238.g7cbf2f2

