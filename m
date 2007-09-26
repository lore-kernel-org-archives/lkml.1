Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbXIZDba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbXIZDba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbXIZDai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:30:38 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35275 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247AbXIZDaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:30:35 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 06/25] Unionfs: minor coding style updates
Date: Tue, 25 Sep 2007 23:09:45 -0400
Message-Id: <11907762072031-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/debug.c  |    6 ++++--
 fs/unionfs/dentry.c |    2 +-
 fs/unionfs/inode.c  |   14 ++++++++------
 fs/unionfs/main.c   |    4 ++--
 fs/unionfs/union.h  |    2 +-
 5 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index f678534..2d15fb0 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -467,7 +467,8 @@ void __show_dinode_times(const struct dentry *dentry,
 		lower_inode = unionfs_lower_inode_idx(inode, bindex);
 		if (!lower_inode)
 			continue;
-		printk("DT(%s:%lu:%d): ", dentry->d_name.name, inode->i_ino, bindex);
+		printk("DT(%s:%lu:%d): ", dentry->d_name.name, inode->i_ino,
+		       bindex);
 		printk("%s:%s:%d ",file,fxn,line);
 		printk("um=%lu/%lu lm=%lu/%lu ",
 		       inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
@@ -490,7 +491,8 @@ void __show_inode_counts(const struct inode *inode,
 		printk("SiC: Null inode\n");
 		return;
 	}
-	for (bindex=sbstart(inode->i_sb); bindex <= sbend(inode->i_sb); bindex++) {
+	for (bindex=sbstart(inode->i_sb); bindex <= sbend(inode->i_sb);
+	     bindex++) {
 		lower_inode = unionfs_lower_inode_idx(inode, bindex);
 		if (!lower_inode)
 			continue;
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 08b5722..d9bb199 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -26,7 +26,7 @@
  * Returns true if valid, false otherwise.
  */
 static bool __unionfs_d_revalidate_one(struct dentry *dentry,
-				      struct nameidata *nd)
+				       struct nameidata *nd)
 {
 	bool valid = true;	/* default is valid */
 	struct dentry *lower_dentry;
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 9638b64..de78e26 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -99,7 +99,8 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 		 * if lower_dentry is NULL, create the entire
 		 * dentry directory structure in branch 0.
 		 */
-		lower_dentry = create_parents(parent, dentry, dentry->d_name.name, 0);
+		lower_dentry = create_parents(parent, dentry,
+					      dentry->d_name.name, 0);
 		if (IS_ERR(lower_dentry)) {
 			err = PTR_ERR(lower_dentry);
 			goto out;
@@ -447,9 +448,8 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 
 		if (!(err = is_robranch_super(dentry->d_sb, bindex))) {
 			mode = S_IALLUGO;
-			err =
-				vfs_symlink(lower_dir_dentry->d_inode,
-					    lower_dentry, symname, mode);
+			err = vfs_symlink(lower_dir_dentry->d_inode,
+					  lower_dentry, symname, mode);
 		}
 		unlock_dir(lower_dir_dentry);
 
@@ -884,9 +884,11 @@ static void unionfs_put_link(struct dentry *dentry, struct nameidata *nd,
  *       readonly, to allow copyup to work.
  *   (3) we do call security_inode_permission, and therefore security inside
  *       SELinux, etc. are performed.
+ *
+ * @inode: the lower inode we're checking permission on
  */
-static int inode_permission(struct super_block *sb, struct inode *inode, int mask,
-			    struct nameidata *nd, int bindex)
+static int inode_permission(struct super_block *sb, struct inode *inode,
+			    int mask, struct nameidata *nd, int bindex)
 {
 	int retval, submask;
 
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 4faae44..8595750 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -275,14 +275,14 @@ int __parse_branch_mode(const char *name)
  */
 int parse_branch_mode(const char *name)
 {
-	int perms =  __parse_branch_mode(name);
+	int perms = __parse_branch_mode(name);
 
 	if (perms == 0)
 		perms = MAY_READ | MAY_WRITE;
 	return perms;
 }
 
-/* 
+/*
  * parse the dirs= mount argument
  *
  * We don't need to lock the superblock private data's rwsem, as we get
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 5e9843b..755bc25 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -549,7 +549,7 @@ extern void __show_inode_counts(const struct inode *inode,
 
 /* we leave useful hooks for these check functions throughout the code */
 #define unionfs_check_inode(i)		do { } while(0)
-#define unionfs_check_dentry(d)	do { } while(0)
+#define unionfs_check_dentry(d)		do { } while(0)
 #define unionfs_check_file(f)		do { } while(0)
 #define show_branch_counts(sb)		do { } while(0)
 #define show_inode_times(i)		do { } while(0)
-- 
1.5.2.2

