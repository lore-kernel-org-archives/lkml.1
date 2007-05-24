Return-Path: <linux-kernel-owner+w=401wt.eu-S1763947AbXEXAnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763947AbXEXAnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761775AbXEXAhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:37:20 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40261 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761674AbXEXAhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:37:01 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 05/21] Unionfs: Cleanup of strings and comments
Date: Wed, 23 May 2007 20:35:55 -0400
Message-Id: <11799669722136-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Includes:
	- consistent style for multi-line comments
	- spell-check of all strings and comments

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/stack.c               |    6 ++++--
 fs/unionfs/branchman.c   |    3 ++-
 fs/unionfs/commonfops.c  |   26 +++++++++++++++++---------
 fs/unionfs/copyup.c      |   46 +++++++++++++++++++++++++++++-----------------
 fs/unionfs/dentry.c      |    6 ++++--
 fs/unionfs/dirfops.c     |    6 ++++--
 fs/unionfs/dirhelper.c   |    3 ++-
 fs/unionfs/file.c        |    2 +-
 fs/unionfs/inode.c       |   45 +++++++++++++++++++++++++++++----------------
 fs/unionfs/lookup.c      |   39 +++++++++++++++++++++++++--------------
 fs/unionfs/main.c        |   24 ++++++++++++++++--------
 fs/unionfs/rdstate.c     |   15 ++++++++++-----
 fs/unionfs/rename.c      |   27 +++++++++++++++++----------
 fs/unionfs/sioq.c        |    3 ++-
 fs/unionfs/sioq.h        |    2 +-
 fs/unionfs/subr.c        |   15 ++++++++++-----
 fs/unionfs/super.c       |   21 +++++++++++++--------
 fs/unionfs/union.h       |   17 +++++++++++------
 fs/unionfs/xattr.c       |   12 ++++++++----
 include/linux/fs_stack.h |    3 ++-
 20 files changed, 207 insertions(+), 114 deletions(-)

diff --git a/fs/stack.c b/fs/stack.c
index 1f5b161..4368d4b 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -13,7 +13,8 @@
 #include <linux/fs.h>
 #include <linux/fs_stack.h>
 
-/* does _NOT_ require i_mutex to be held.
+/*
+ * does _NOT_ require i_mutex to be held.
  *
  * This function cannot be inlined since i_size_{read,write} is rather
  * heavy-weight on 32-bit systems
@@ -25,7 +26,8 @@ void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 
-/* copy all attributes; get_nlinks is optional way to override the i_nlink
+/*
+ * copy all attributes; get_nlinks is optional way to override the i_nlink
  * copying
  */
 void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
diff --git a/fs/unionfs/branchman.c b/fs/unionfs/branchman.c
index eba2221..4545e18 100644
--- a/fs/unionfs/branchman.c
+++ b/fs/unionfs/branchman.c
@@ -18,7 +18,8 @@
 
 #include "union.h"
 
-/* return to userspace the branch indices containing the file in question
+/*
+ * return to user-space the branch indices containing the file in question
  *
  * We use fd_set and therefore we are limited to the number of the branches
  * to FD_SETSIZE, which is currently 1024 - plenty for most people
diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 778901f..666b3c7 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -18,7 +18,8 @@
 
 #include "union.h"
 
-/* 1) Copyup the file
+/*
+ * 1) Copyup the file
  * 2) Rename the file to '.unionfs<original inode#><counter>' - obviously
  * stolen from NFS's silly rename
  */
@@ -111,7 +112,8 @@ static int find_new_branch_index(struct file *file, int bindex,
 	return -1;
 }
 
-/* put all references held by upper struct file and free lower file pointer
+/*
+ * put all references held by upper struct file and free lower file pointer
  * array
  */
 static void cleanup_file(struct file *file)
@@ -129,7 +131,7 @@ static void cleanup_file(struct file *file)
 			int i;	/* holds (possibly) updated branch index */
 			i = find_new_branch_index(file, bindex, sb);
 			if (i < 0)
-				printk(KERN_ERR "unionfs: no supberlock for "
+				printk(KERN_ERR "unionfs: no superblock for "
 				       "file %p\n", file);
 			else {
 				unionfs_read_lock(sb);
@@ -308,7 +310,8 @@ int unionfs_file_revalidate(struct file *file, int willwrite)
 
 	BUG_ON(sbgen > dgen);
 
-	/* There are two cases we are interested in.  The first is if the
+	/*
+	 * There are two cases we are interested in.  The first is if the
 	 * generation is lower than the super-block.  The second is if someone
 	 * has copied up this file from underneath us, we also need to refresh
 	 * things.
@@ -397,7 +400,8 @@ static int __open_dir(struct inode *inode, struct file *file)
 
 		unionfs_set_lower_file_idx(file, bindex, hidden_file);
 
-		/* The branchget goes after the open, because otherwise
+		/*
+		 * The branchget goes after the open, because otherwise
 		 * we would miss the reference on release.
 		 */
 		unionfs_read_lock(inode->i_sb);
@@ -422,11 +426,13 @@ static int __open_file(struct inode *inode, struct file *file)
 	bstart = fbstart(file) = dbstart(file->f_dentry);
 	bend = fbend(file) = dbend(file->f_dentry);
 
-	/* check for the permission for hidden file.  If the error is
+	/*
+	 * check for the permission for hidden file.  If the error is
 	 * COPYUP_ERR, copyup the file.
 	 */
 	if (hidden_dentry->d_inode && is_robranch(file->f_dentry)) {
-		/* if the open will change the file, copy it up otherwise
+		/*
+		 * if the open will change the file, copy it up otherwise
 		 * defer it.
 		 */
 		if (hidden_flags & O_TRUNC) {
@@ -448,7 +454,8 @@ static int __open_file(struct inode *inode, struct file *file)
 
 	dget(hidden_dentry);
 
-	/* dentry_open will decrement mnt refcnt if err.
+	/*
+	 * dentry_open will decrement mnt refcnt if err.
 	 * otherwise fput() will do an mntput() for us upon file close.
 	 */
 	unionfs_mntget(file->f_dentry, bstart);
@@ -509,7 +516,8 @@ int unionfs_open(struct inode *inode, struct file *file)
 	/* increment, so that we can flush appropriately */
 	atomic_inc(&UNIONFS_I(dentry->d_inode)->totalopens);
 
-	/* open all directories and make the unionfs file struct point to
+	/*
+	 * open all directories and make the unionfs file struct point to
 	 * these hidden file structs
 	 */
 	if (S_ISDIR(inode->i_mode))
diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 8fae308..1495778 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -26,7 +26,8 @@ static struct dentry *create_parents_named(struct inode *dir,
 					   struct dentry *dentry,
 					   const char *name, int bindex);
 
-/* For detailed explanation of copyup see:
+/*
+ * For detailed explanation of copyup see:
  * Documentation/filesystems/unionfs/concepts.txt
  */
 
@@ -135,7 +136,8 @@ int copyup_dentry(struct inode *dir, struct dentry *dentry,
 				   dentry->d_name.len, copyup_file, len);
 }
 
-/* create the new device/file/directory - use copyup_permission to copyup
+/*
+ * create the new device/file/directory - use copyup_permission to copyup
  * times, and mode
  *
  * if the object being copied up is a regular file, the file is only created,
@@ -314,7 +316,8 @@ out:
 	return err;
 }
 
-/* dput the lower references for old and new dentry & clear a lower dentry
+/*
+ * dput the lower references for old and new dentry & clear a lower dentry
  * pointer
  */
 static void __clear(struct dentry *dentry, struct dentry *old_hidden_dentry,
@@ -434,15 +437,15 @@ static int copyup_named_dentry(struct inode *dir, struct dentry *dentry,
 		goto out_unlink;
 #endif
 
-	/* do not allow files getting deleted to be reinterposed */
+	/* do not allow files getting deleted to be re-interposed */
 	if (!d_deleted(dentry))
 		unionfs_reinterpose(dentry);
 
 	goto out_unlock;
-	/****/
 
 out_unlink:
-	/* copyup failed, because we possibly ran out of space or
+	/*
+	 * copyup failed, because we possibly ran out of space or
 	 * quota, or something else happened so let's unlink; we don't
 	 * really care about the return value of vfs_unlink
 	 */
@@ -460,7 +463,7 @@ out_unlink:
 	/*
 	 * TODO: should we reset the error to something like -EIO?
 	 *
-	 * If we don't reset, the user may get some non-sensical errors, but
+	 * If we don't reset, the user may get some nonsensical errors, but
 	 * on the other hand, if we reset to EIO, we guarantee that the user
 	 * will get a "confusing" error message.
 	 */
@@ -472,7 +475,7 @@ out_free:
 	/*
 	 * If old_hidden_dentry was a directory, we need to dput it.  If it
 	 * was a file, then it was already dput indirectly by other
-	 * functions we call ablve which operate on regular files.
+	 * functions we call above which operate on regular files.
 	 */
 	if (old_hidden_dentry && old_hidden_dentry->d_inode &&
 	    S_ISDIR(old_hidden_dentry->d_inode->i_mode))
@@ -483,7 +486,8 @@ out:
 	return err;
 }
 
-/* This function creates a copy of a file represented by 'file' which currently
+/*
+ * This function creates a copy of a file represented by 'file' which currently
  * resides in branch 'bstart' to branch 'new_bindex.'  The copy will be named
  * "name".
  */
@@ -504,7 +508,8 @@ int copyup_named_file(struct inode *dir, struct file *file, char *name,
 	return err;
 }
 
-/* This function creates a copy of a file represented by 'file' which currently
+/*
+ * This function creates a copy of a file represented by 'file' which currently
  * resides in branch 'bstart' to branch 'new_bindex'.
  */
 int copyup_file(struct inode *dir, struct file *file, int bstart,
@@ -523,7 +528,8 @@ int copyup_file(struct inode *dir, struct file *file, int bstart,
 	return err;
 }
 
-/* This function replicates the directory structure upto given dentry in the
+/*
+ * This function replicates the directory structure up-to given dentry in the
  * bindex branch. Can create directory structure recursively to the right
  * also.
  */
@@ -545,7 +551,8 @@ static void __cleanup_dentry(struct dentry * dentry, int bindex,
 	loop_start = min(old_bstart, bindex);
 	loop_end = max(old_bend, bindex);
 
-	/* This loop sets the bstart and bend for the new dentry by
+	/*
+	 * This loop sets the bstart and bend for the new dentry by
 	 * traversing from left to right.  It also dputs all negative
 	 * dentries except bindex
 	 */
@@ -606,7 +613,8 @@ static void __set_dentry(struct dentry * upper, struct dentry * lower,
 		set_dbend(upper, bindex);
 }
 
-/* This function replicates the directory structure upto given dentry
+/*
+ * This function replicates the directory structure up-to given dentry
  * in the bindex branch.
  */
 static struct dentry *create_parents_named(struct inode *dir,
@@ -651,7 +659,8 @@ static struct dentry *create_parents_named(struct inode *dir,
 	parent_dentry = dentry;
 
 	count = 0;
-	/* This loop finds the first parent that exists in the given branch.
+	/*
+	 * This loop finds the first parent that exists in the given branch.
 	 * We start building the directory structure from there.  At the end
 	 * of the loop, the following should hold:
 	 *  - child_dentry is the first nonexistent child
@@ -690,7 +699,8 @@ static struct dentry *create_parents_named(struct inode *dir,
 
 	sb = dentry->d_sb;
 
-	/* This is basically while(child_dentry != dentry).  This loop is
+	/*
+	 * This is basically while(child_dentry != dentry).  This loop is
 	 * horrible to follow and should be replaced with cleaner code.
 	 */
 	while (1) {
@@ -712,7 +722,8 @@ static struct dentry *create_parents_named(struct inode *dir,
 				goto out;
 		} else {
 
-			/* is the name a whiteout of the childname ?
+			/*
+			 * is the name a whiteout of the child name ?
 			 * lookup the whiteout child in the underlying file
 			 * system
 			 */
@@ -735,7 +746,8 @@ static struct dentry *create_parents_named(struct inode *dir,
 		}
 
 		if (hidden_dentry->d_inode) {
-			/* since this already exists we dput to avoid
+			/*
+			 * since this already exists we dput to avoid
 			 * multiple references on the same dentry
 			 */
 			dput(hidden_dentry);
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 463cf4c..46a52f7 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -59,7 +59,8 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry,
 		positive = 1;
 	dgen = atomic_read(&UNIONFS_D(dentry)->generation);
 	sbgen = atomic_read(&UNIONFS_SB(dentry->d_sb)->generation);
-	/* If we are working on an unconnected dentry, then there is no
+	/*
+	 * If we are working on an unconnected dentry, then there is no
 	 * revalidation to be done, because this file does not exist within the
 	 * namespace, and Unionfs operates on the namespace, not data.
 	 */
@@ -131,7 +132,8 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry,
 				valid = 0;
 				goto out;
 			}
-			/* current unionfs_lookup_backend() doesn't return
+			/*
+			 * current unionfs_lookup_backend() doesn't return
 			 * a valid dentry
 			 */
 			dput(dentry);
diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index cab7b6d..7306b3f 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -183,7 +183,8 @@ out:
 	return err;
 }
 
-/* This is not meant to be a generic repositioning function.  If you do
+/*
+ * This is not meant to be a generic repositioning function.  If you do
  * things that aren't supported, then we return EINVAL.
  *
  * What is allowed:
@@ -258,7 +259,8 @@ out:
 	return err;
 }
 
-/* Trimmed directory options, we shouldn't pass everything down since
+/*
+ * Trimmed directory options, we shouldn't pass everything down since
  * we don't want to operate on partial directories.
  */
 struct file_operations unionfs_dir_fops = {
diff --git a/fs/unionfs/dirhelper.c b/fs/unionfs/dirhelper.c
index cbea6c1..975d6fe 100644
--- a/fs/unionfs/dirhelper.c
+++ b/fs/unionfs/dirhelper.c
@@ -18,7 +18,8 @@
 
 #include "union.h"
 
-/* Delete all of the whiteouts in a given directory for rmdir.
+/*
+ * Delete all of the whiteouts in a given directory for rmdir.
  *
  * hidden directory inode should be locked
  */
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 430cb43..47ce5ce 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -151,7 +151,7 @@ static unsigned int unionfs_poll(struct file *file, poll_table * wait)
 
 	unionfs_read_lock(file->f_dentry->d_sb);
 	if (unionfs_file_revalidate(file, 0)) {
-		/* We should pretend an error happend. */
+		/* We should pretend an error happened. */
 		mask = POLLERR | POLLIN | POLLOUT;
 		goto out;
 	}
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index f0616ed..2d0822a 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -80,8 +80,9 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	}
 
 	if (wh_dentry->d_inode) {
-		/* .wh.foo has been found. */
-		/* First truncate it and then rename it to foo (hence having
+		/*
+		 * .wh.foo has been found.
+		 * First truncate it and then rename it to foo (hence having
 		 * the same overall effect as a normal create.
 		 */
 		struct dentry *hidden_dir_dentry;
@@ -141,13 +142,15 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 			/* exit if the error returned was NOT -EROFS */
 			if (!IS_COPYUP_ERR(err))
 				goto out;
-			/* We were not able to create the file in this
+			/*
+			 * We were not able to create the file in this
 			 * branch, so, we try to create it in one branch to
 			 * left
 			 */
 			bstart--;
 		} else {
-			/* reset the unionfs dentry to point to the .wh.foo
+			/*
+			 * reset the unionfs dentry to point to the .wh.foo
 			 * entry.
 			 */
 
@@ -167,11 +170,13 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	for (bindex = bstart; bindex >= 0; bindex--) {
 		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
 		if (!hidden_dentry) {
-			/* if hidden_dentry is NULL, create the entire
+			/*
+			 * if hidden_dentry is NULL, create the entire
 			 * dentry directory structure in branch 'bindex'.
 			 * hidden_dentry will NOT be null when bindex == bstart
 			 * because lookup passed as a negative unionfs dentry
-			 * pointing to a lone negative underlying dentry */
+			 * pointing to a lone negative underlying dentry.
+			 */
 			hidden_dentry = create_parents(parent, dentry, bindex);
 			if (!hidden_dentry || IS_ERR(hidden_dentry)) {
 				if (IS_ERR(hidden_dentry))
@@ -264,7 +269,8 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 
 	hidden_new_dentry = unionfs_lower_dentry(new_dentry);
 
-	/* check if whiteout exists in the branch of new dentry, i.e. lookup
+	/*
+	 * check if whiteout exists in the branch of new dentry, i.e. lookup
 	 * .wh.foo first. If present, delete it
 	 */
 	name = alloc_whname(new_dentry->d_name.name, new_dentry->d_name.len);
@@ -395,7 +401,8 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 
 	hidden_dentry = unionfs_lower_dentry(dentry);
 
-	/* check if whiteout exists in this branch, i.e. lookup .wh.foo
+	/*
+	 * check if whiteout exists in this branch, i.e. lookup .wh.foo
 	 * first. If present, delete it
 	 */
 	name = alloc_whname(dentry->d_name.name, dentry->d_name.len);
@@ -445,13 +452,15 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
-	/* deleted whiteout if it was present, now do a normal vfs_symlink()
+	/*
+	 * deleted whiteout if it was present, now do a normal vfs_symlink()
 	 * with possible recursive directory creation
 	 */
 	for (bindex = bstart; bindex >= 0; bindex--) {
 		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
 		if (!hidden_dentry) {
-			/* if hidden_dentry is NULL, create the entire
+			/*
+			 * if hidden_dentry is NULL, create the entire
 			 * dentry directory structure in branch 'bindex'.
 			 * hidden_dentry will NOT be null when bindex ==
 			 * bstart because lookup passed as a negative
@@ -604,7 +613,7 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 
 		unlock_dir(hidden_parent_dentry);
 
-		/* did the mkdir suceed? */
+		/* did the mkdir succeed? */
 		if (err)
 			break;
 
@@ -827,7 +836,8 @@ static void unionfs_put_link(struct dentry *dentry, struct nameidata *nd,
 	kfree(nd_get_link(nd));
 }
 
-/* Basically copied from the kernel vfs permission(), but we've changed
+/*
+ * Basically copied from the kernel vfs permission(), but we've changed
  * the following:
  *   (1) the IS_RDONLY check is skipped, and
  *   (2) if you set the mount option `mode=nfsro', we assume that -EACCES
@@ -912,19 +922,22 @@ static int unionfs_permission(struct inode *inode, int mask,
 		if (!hidden_inode)
 			continue;
 
-		/* check the condition for D-F-D underlying files/directories,
-		 * we dont have to check for files, if we are checking for
+		/*
+		 * check the condition for D-F-D underlying files/directories,
+		 * we don't have to check for files, if we are checking for
 		 * directories.
 		 */
 		if (!is_file && !S_ISDIR(hidden_inode->i_mode))
 			continue;
 
-		/* We use our own special version of permission, such that
+		/*
+		 * We use our own special version of permission, such that
 		 * only the first branch returns -EROFS.
 		 */
 		err = inode_permission(hidden_inode, mask, nd, bindex);
 
-		/* The permissions are an intersection of the overall directory
+		/*
+		 * The permissions are an intersection of the overall directory
 		 * permissions, so we fail if one fails.
 		 */
 		if (err)
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 8e5f419..6ea5aea 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -93,7 +93,8 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 	const char *name;
 	int namelen;
 
-	/* We should already have a lock on this dentry in the case of a
+	/*
+	 * We should already have a lock on this dentry in the case of a
 	 * partial lookup, or a revalidation. Otherwise it is returned from
 	 * new_dentry_private_data already locked.
 	 */
@@ -138,7 +139,8 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 	bopaque = dbopaque(parent_dentry);
 	BUG_ON(bstart < 0);
 
-	/* It would be ideal if we could convert partial lookups to only have
+	/*
+	 * It would be ideal if we could convert partial lookups to only have
 	 * to do this work when they really need to.  It could probably improve
 	 * performance quite a bit, and maybe simplify the rest of the code.
 	 */
@@ -219,14 +221,16 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 			goto out_free;
 		}
 
-		/* Store the first negative dentry specially, because if they
+		/*
+		 * Store the first negative dentry specially, because if they
 		 * are all negative we need this for future creates.
 		 */
 		if (!hidden_dentry->d_inode) {
 			if (!first_hidden_dentry && (dbstart(dentry) == -1)) {
 				first_hidden_dentry = hidden_dentry;
-				/* FIXME: following line needs to be changed
-				 * to allow mountpoint crossing
+				/*
+				 * FIXME: following line needs to be changed
+				 * to allow mount-point crossing
 				 */
 				first_dentry = parent_dentry;
 				first_hidden_mnt =
@@ -245,8 +249,9 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 		if (dbstart(dentry) == -1)
 			set_dbstart(dentry, bindex);
 		unionfs_set_lower_dentry_idx(dentry, bindex, hidden_dentry);
-		/* FIXME: the following line needs to get fixed to allow
-		 * mountpoint crossing
+		/*
+		 * FIXME: the following line needs to get fixed to allow
+		 * mount-point crossing
 		 */
 		unionfs_set_lower_mnt_idx(dentry, bindex,
 					  unionfs_mntget(parent_dentry,
@@ -313,8 +318,9 @@ out_negative:
 			goto out;
 		}
 
-		/* FIXME: the following line needs to be changed to allow
-		 * mountpoint crossing
+		/*
+		 * FIXME: the following line needs to be changed to allow
+		 * mount-point crossing
 		 */
 		first_dentry = dentry;
 		first_hidden_mnt = unionfs_mntget(dentry, bindex);
@@ -336,20 +342,22 @@ out_negative:
 out_positive:
 	BUG_ON(dentry_count <= 0);
 
-	/* If we're holding onto the first negative dentry & corresponding
+	/*
+	 * If we're holding onto the first negative dentry & corresponding
 	 * vfsmount - throw it out.
 	 */
 	dput(first_hidden_dentry);
 	unionfs_mntput(first_dentry, first_dentry_offset);
 
-	/* Partial lookups need to reinterpose, or throw away older negs. */
+	/* Partial lookups need to re-interpose, or throw away older negs. */
 	if (lookupmode == INTERPOSE_PARTIAL) {
 		if (dentry->d_inode) {
 			unionfs_reinterpose(dentry);
 			goto out;
 		}
 
-		/* This somehow turned positive, so it is as if we had a
+		/*
+		 * This somehow turned positive, so it is as if we had a
 		 * negative revalidation.
 		 */
 		lookupmode = INTERPOSE_REVAL_NEG;
@@ -474,7 +482,9 @@ int new_dentry_private_data(struct dentry *dentry)
 
 	new_size = sizeof(struct path) * sbmax(dentry->d_sb);
 
-	/* Don't reallocate when we already have enough space. */
+	/*
+	 * Don't reallocate when we already have enough space.
+	 */
 	if (new_size > size) {
 		void *p;
 
@@ -502,7 +512,8 @@ out:
 	return -ENOMEM;
 }
 
-/* scan through the lower dentry objects, and set bstart to reflect the
+/*
+ * scan through the lower dentry objects, and set bstart to reflect the
  * starting branch
  */
 void update_bstart(struct dentry *dentry)
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index cdfe96a..a72e844 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -45,12 +45,14 @@ int unionfs_interpose(struct dentry *dentry, struct super_block *sb, int flag)
 	}
 	BUG_ON(is_negative_dentry);
 
-	/* We allocate our new inode below, by calling iget.
+	/*
+	 * We allocate our new inode below, by calling iget.
 	 * iget will call our read_inode which will initialize some
 	 * of the new inode's fields
 	 */
 
-	/* On revalidate we've already got our own inode and just need
+	/*
+	 * On revalidate we've already got our own inode and just need
 	 * to fix it up.
 	 */
 	if (flag == INTERPOSE_REVAL) {
@@ -114,7 +116,8 @@ int unionfs_interpose(struct dentry *dentry, struct super_block *sb, int flag)
 	    S_ISFIFO(hidden_inode->i_mode) || S_ISSOCK(hidden_inode->i_mode))
 		init_special_inode(inode, hidden_inode->i_mode,
 				   hidden_inode->i_rdev);
-	/* Fix our inode's address operations to that of the lower inode
+	/*
+	 * Fix our inode's address operations to that of the lower inode
 	 * (Unionfs is FiST-Lite)
 	 */
 	if (inode->i_mapping->a_ops != hidden_inode->i_mapping->a_ops)
@@ -175,7 +178,8 @@ void unionfs_reinterpose(struct dentry *dentry)
 	ibend(inode) = dbend(dentry);
 }
 
-/* make sure the branch we just looked up (nd) makes sense:
+/*
+ * make sure the branch we just looked up (nd) makes sense:
  *
  * 1) we're not trying to stack unionfs on top of unionfs
  * 2) it exists
@@ -259,7 +263,8 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 		goto out;
 	}
 
-	/* Each colon means we have a separator, this is really just a rough
+	/*
+	 * Each colon means we have a separator, this is really just a rough
 	 * guess, since strsep will handle empty fields for us.
 	 */
 	for (i = 0; options[i]; i++)
@@ -367,7 +372,8 @@ out:
 		kfree(hidden_root_info->lower_paths);
 		kfree(UNIONFS_SB(sb)->data);
 
-		/* MUST clear the pointers to prevent potential double free if
+		/*
+		 * MUST clear the pointers to prevent potential double free if
 		 * the caller dies later on
 		 */
 		hidden_root_info->lower_paths = NULL;
@@ -414,7 +420,8 @@ static struct unionfs_dentry_info *unionfs_parse_options(
 		if (optarg)
 			*optarg++ = '\0';
 
-		/* All of our options take an argument now. Insert ones that
+		/*
+		 * All of our options take an argument now. Insert ones that
 		 * don't, above this check.
 		 */
 		if (!optarg) {
@@ -486,7 +493,8 @@ out:
 	return hidden_root_info;
 }
 
-/* our custom d_alloc_root workalike
+/*
+ * our custom d_alloc_root work-alike
  *
  * we can't use d_alloc_root if we want to use our own interpose function
  * unchanged, so we simply call our own "fake" d_alloc_root
diff --git a/fs/unionfs/rdstate.c b/fs/unionfs/rdstate.c
index e84161d..f0525ff 100644
--- a/fs/unionfs/rdstate.c
+++ b/fs/unionfs/rdstate.c
@@ -20,11 +20,13 @@
 
 /* This file contains the routines for maintaining readdir state. */
 
-/* There are two structures here, rdstate which is a hash table
+/*
+ * There are two structures here, rdstate which is a hash table
  * of the second structure which is a filldir_node.
  */
 
-/* This is a struct kmem_cache for filldir nodes, because we allocate a lot
+/*
+ * This is a struct kmem_cache for filldir nodes, because we allocate a lot
  * of them and they shouldn't waste memory.  If the node has a small name
  * (as defined by the dentry structure), then we use an inline name to
  * preserve kmalloc space.
@@ -47,7 +49,8 @@ void unionfs_destroy_filldir_cache(void)
 		kmem_cache_destroy(unionfs_filldir_cachep);
 }
 
-/* This is a tuning parameter that tells us roughly how big to make the
+/*
+ * This is a tuning parameter that tells us roughly how big to make the
  * hash table in directory entries per page.  This isn't perfect, but
  * at least we get a hash table size that shouldn't be too overloaded.
  * The following averages are based on my home directory.
@@ -204,12 +207,14 @@ struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
 
 		if (cursor->namelen == namelen && cursor->hash == hash &&
 		    !strncmp(cursor->name, name, namelen)) {
-			/* a duplicate exists, and hence no need to create
+			/*
+			 * a duplicate exists, and hence no need to create
 			 * entry to the list
 			 */
 			found = 1;
 
-			/* if the duplicate is in this branch, then the file
+			/*
+			 * if the duplicate is in this branch, then the file
 			 * system is corrupted.
 			 */
 			if (cursor->bindex == rdstate->bindex) {
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 224ce5c..f71bba6 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -95,7 +95,8 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (err)
 		goto out_unlock;
 
-	/* ready to whiteout for old_dentry. caller will create the actual
+	/*
+	 * ready to whiteout for old_dentry. caller will create the actual
 	 * whiteout, and must dput(*wh_old)
 	 */
 	if (wh_old) {
@@ -128,7 +129,7 @@ out_unlock:
 
 out:
 	if (!err) {
-		/* Fixup the newdentry. */
+		/* Fixup the new_dentry. */
 		if (bindex < dbstart(new_dentry))
 			set_dbstart(new_dentry, bindex);
 		else if (bindex > dbend(new_dentry))
@@ -174,7 +175,8 @@ static int do_unionfs_rename(struct inode *old_dir,
 	} else
 		revert = 1;
 
-	/* Unlink all instances of destination that exist to the left of
+	/*
+	 * Unlink all instances of destination that exist to the left of
 	 * bstart of source. On error, revert back, goto out.
 	 */
 	for (bindex = old_bstart - 1; bindex >= new_bstart; bindex--) {
@@ -213,7 +215,8 @@ static int do_unionfs_rename(struct inode *old_dir,
 
 	if (do_copyup != -1) {
 		for (bindex = do_copyup; bindex >= 0; bindex--) {
-			/* copyup the file into some left directory, so that
+			/*
+			 * copyup the file into some left directory, so that
 			 * you can rename it
 			 */
 			err = copyup_dentry(old_dentry->d_parent->d_inode,
@@ -236,7 +239,8 @@ static int do_unionfs_rename(struct inode *old_dir,
 			goto revert;
 	}
 
-	/* Create whiteout for source, only if:
+	/*
+	 * Create whiteout for source, only if:
 	 * (1) There is more than one underlying instance of source.
 	 * (2) We did a copy_up
 	 */
@@ -353,9 +357,10 @@ static struct dentry *lookup_whiteout(struct dentry *dentry)
 	return wh_dentry;
 }
 
-/* We can't copyup a directory, because it may involve huge
+/*
+ * We can't copyup a directory, because it may involve huge
  * numbers of children, etc.  Doing that in the kernel would
- * be bad, so instead we let the userspace recurse and ask us
+ * be bad, so instead we let the user-space recurse and ask us
  * to copy up each file separately
  */
 static int may_rename_dir(struct dentry *dentry)
@@ -406,7 +411,7 @@ int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	/*
 	 * if new_dentry is already hidden because of whiteout,
-	 * simply override it even if the whiteouted dir is not empty.
+	 * simply override it even if the whited-out dir is not empty.
 	 */
 	wh_dentry = lookup_whiteout(new_dentry);
 	if (!IS_ERR(wh_dentry))
@@ -444,8 +449,10 @@ out:
 		/* clear the new_dentry stuff created */
 		d_drop(new_dentry);
 	else
-		/* force re-lookup since the dir on ro branch is not renamed,
-		   and hidden dentries still indicate the un-renamed ones. */
+		/*
+		 * force re-lookup since the dir on ro branch is not renamed,
+		 * and hidden dentries still indicate the un-renamed ones.
+		 */
 		if (S_ISDIR(old_dentry->d_inode->i_mode))
 			atomic_dec(&UNIONFS_D(old_dentry)->generation);
 
diff --git a/fs/unionfs/sioq.c b/fs/unionfs/sioq.c
index 34e25b0..575f08d 100644
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -13,7 +13,8 @@
 
 #include "union.h"
 
-/* Super-user IO work Queue - sometimes we need to perform actions which
+/*
+ * Super-user IO work Queue - sometimes we need to perform actions which
  * would fail due to the unix permissions on the parent directory (e.g.,
  * rmdir a directory which appears empty, but in reality contains
  * whiteouts).
diff --git a/fs/unionfs/sioq.h b/fs/unionfs/sioq.h
index dd6c44b..5a96f66 100644
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -78,7 +78,7 @@ extern int __init init_sioq(void);
 extern __exit void stop_sioq(void);
 extern void run_sioq(work_func_t func, struct sioq_args *args);
 
-/* Extern definitions for our privlege escalation helpers */
+/* Extern definitions for our privilege escalation helpers */
 extern void __unionfs_create(struct work_struct *work);
 extern void __unionfs_mkdir(struct work_struct *work);
 extern void __unionfs_mknod(struct work_struct *work);
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index f77101b..fb769ba 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -18,7 +18,8 @@
 
 #include "union.h"
 
-/* Pass an unionfs dentry and an index.  It will try to create a whiteout
+/*
+ * Pass an unionfs dentry and an index.  It will try to create a whiteout
  * for the filename in dentry, and will try in branch 'index'.  On error,
  * it will proceed to a branch to the left.
  */
@@ -47,7 +48,8 @@ int create_whiteout(struct dentry *dentry, int start)
 		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
 
 		if (!hidden_dentry) {
-			/* if hidden dentry is not present, create the entire
+			/*
+			 * if hidden dentry is not present, create the entire
 			 * hidden dentry directory structure and go ahead.
 			 * Since we want to just create whiteout, we only want
 			 * the parent dentry, and hence get rid of this dentry.
@@ -67,7 +69,8 @@ int create_whiteout(struct dentry *dentry, int start)
 		if (IS_ERR(hidden_wh_dentry))
 			continue;
 
-		/* The whiteout already exists. This used to be impossible, but
+		/*
+		 * The whiteout already exists. This used to be impossible, but
 		 * now is possible because of opaqueness.
 		 */
 		if (hidden_wh_dentry->d_inode) {
@@ -98,7 +101,8 @@ out:
 	return err;
 }
 
-/* This is a helper function for rename, which ends up with hosed over dentries
+/*
+ * This is a helper function for rename, which ends up with hosed over dentries
  * when it needs to revert.
  */
 int unionfs_refresh_hidden_dentry(struct dentry *dentry, int bindex)
@@ -170,7 +174,8 @@ out:
 	return err;
 }
 
-/* returns the sum of the n_link values of all the underlying inodes of the
+/*
+ * returns the sum of the n_link values of all the underlying inodes of the
  * passed inode
  */
 int unionfs_get_nlinks(struct inode *inode)
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index eab844e..7813ea8 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -18,7 +18,8 @@
 
 #include "union.h"
 
-/* The inode cache is used with alloc_inode for both our inode info and the
+/*
+ * The inode cache is used with alloc_inode for both our inode info and the
  * vfs inode.
  */
 static struct kmem_cache *unionfs_inode_cachep;
@@ -120,7 +121,8 @@ static void unionfs_put_super(struct super_block *sb)
 	sb->s_fs_info = NULL;
 }
 
-/* Since people use this to answer the "How big of a file can I write?"
+/*
+ * Since people use this to answer the "How big of a file can I write?"
  * question, we report the size of the highest priority branch as the size of
  * the union.
  */
@@ -627,7 +629,7 @@ out_no_change:
 	 * WE'RE ALMOST DONE: see if we need to allocate a small-sized new
 	 * vector, copy the vectors to their correct place, release the
 	 * refcnt of the older ones, and return.
-	 * Also handle invalidating any pgaes that will have to be re-read.
+	 * Also handle invalidating any pages that will have to be re-read.
 	 *******************************************************************/
 
 	/*
@@ -690,7 +692,7 @@ out_no_change:
 	 * super.  This function calls invalidate_inode_pages(mapping),
 	 * which calls invalidate_mapping_pages(): the latter, however, will
 	 * not invalidate pages which are dirty, locked, under writeback, or
-	 * mapped into pagetables.  We shouldn't have to worry about dirty
+	 * mapped into page tables.  We shouldn't have to worry about dirty
 	 * or under-writeback pages, because do_remount_sb() called
 	 * fsync_super() which would not have returned until all dirty pages
 	 * were flushed.
@@ -780,7 +782,8 @@ static void unionfs_clear_inode(struct inode *inode)
 		free_rdstate(rdstate);
 	}
 
-	/* Decrement a reference to a hidden_inode, which was incremented
+	/*
+	 * Decrement a reference to a hidden_inode, which was incremented
 	 * by our read_inode when it was created initially.
 	 */
 	bstart = ibstart(inode);
@@ -845,7 +848,8 @@ void unionfs_destroy_inode_cache(void)
 		kmem_cache_destroy(unionfs_inode_cachep);
 }
 
-/* Called when we have a dirty inode, right here we only throw out
+/*
+ * Called when we have a dirty inode, right here we only throw out
  * parts of our readdir list that are too old.
  */
 static int unionfs_write_inode(struct inode *inode, int sync)
@@ -879,8 +883,9 @@ static void unionfs_umount_begin(struct vfsmount *mnt, int flags)
 	int bindex, bstart, bend;
 
 	if (!(flags & MNT_FORCE))
-		/* we are not being MNT_FORCEd, therefore we should emulate
-		 * old behaviour
+		/*
+		 * we are not being MNT_FORCE'd, therefore we should emulate
+		 * old behavior
 		 */
 		return;
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 034b1b2..0ce3a27 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -109,7 +109,8 @@ struct unionfs_inode_info {
 
 /* unionfs dentry data in memory */
 struct unionfs_dentry_info {
-	/* The semaphore is used to lock the dentry as soon as we get into a
+	/*
+	 * The semaphore is used to lock the dentry as soon as we get into a
 	 * unionfs function from the VFS.  Our lock ordering is that children
 	 * go before their parents.
 	 */
@@ -150,7 +151,8 @@ struct filldir_node {
 	int hash;		/* name hash */
 	int namelen;		/* name len since name is not 0 terminated */
 
-	/* we can check for duplicate whiteouts and files in the same branch
+	/*
+	 * we can check for duplicate whiteouts and files in the same branch
 	 * in order to return -EIO.
 	 */
 	int bindex;
@@ -240,14 +242,15 @@ void update_bstart(struct dentry *dentry);
  * EXTERNALS:
  */
 
-/* replicates the directory structure upto given dentry in given branch */
+/* replicates the directory structure up to given dentry in given branch */
 extern struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
 				     int bindex);
 
 /* partial lookup */
 extern int unionfs_partial_lookup(struct dentry *dentry);
 
-/* Pass an unionfs dentry and an index and it will try to create a whiteout
+/*
+ * Pass an unionfs dentry and an index and it will try to create a whiteout
  * in branch 'index'.
  *
  * On error, it will proceed to a branch to the left
@@ -419,7 +422,8 @@ static inline int is_valid_dentry(struct dentry *dentry)
 /* What do we use for whiteouts. */
 #define UNIONFS_WHPFX ".wh."
 #define UNIONFS_WHLEN 4
-/* If a directory contains this file, then it is opaque.  We start with the
+/*
+ * If a directory contains this file, then it is opaque.  We start with the
  * .wh. flag so that it is blocked by lookup.
  */
 #define UNIONFS_DIR_OPAQUE_NAME "__dir_opaque"
@@ -437,7 +441,8 @@ extern int check_branch(struct nameidata *nd);
 extern int __parse_branch_mode(const char *name);
 extern int parse_branch_mode(const char *name);
 
-/* These two functions are here because it is kind of daft to copy and paste
+/*
+ * These two functions are here because it is kind of daft to copy and paste
  * the contents of the two functions to 32+ places in unionfs
  */
 static inline struct dentry *lock_parent(struct dentry *dentry)
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 9d3073b..4dc8ada 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -47,7 +47,8 @@ void unionfs_xattr_free(void *ptr, size_t size)
 		vfree(ptr);
 }
 
-/* BKL held by caller.
+/*
+ * BKL held by caller.
  * dentry->d_inode->i_mutex locked
  */
 ssize_t unionfs_getxattr(struct dentry * dentry, const char *name, void *value,
@@ -68,7 +69,8 @@ ssize_t unionfs_getxattr(struct dentry * dentry, const char *name, void *value,
 	return err;
 }
 
-/* BKL held by caller.
+/*
+ * BKL held by caller.
  * dentry->d_inode->i_mutex locked
  */
 int unionfs_setxattr(struct dentry *dentry, const char *name,
@@ -89,7 +91,8 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 	return err;
 }
 
-/* BKL held by caller.
+/*
+ * BKL held by caller.
  * dentry->d_inode->i_mutex locked
  */
 int unionfs_removexattr(struct dentry *dentry, const char *name)
@@ -108,7 +111,8 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 	return err;
 }
 
-/* BKL held by caller.
+/*
+ * BKL held by caller.
  * dentry->d_inode->i_mutex locked
  */
 ssize_t unionfs_listxattr(struct dentry * dentry, char *list, size_t size)
diff --git a/include/linux/fs_stack.h b/include/linux/fs_stack.h
index 9a896d6..f3cd7f4 100644
--- a/include/linux/fs_stack.h
+++ b/include/linux/fs_stack.h
@@ -12,7 +12,8 @@
 #ifndef _LINUX_FS_STACK_H
 #define _LINUX_FS_STACK_H
 
-/* This file defines generic functions used primarily by stackable
+/*
+ * This file defines generic functions used primarily by stackable
  * filesystems; none of these functions require i_mutex to be held.
  */
 
-- 
1.5.2.rc1.165.gaf9b

