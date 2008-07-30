Return-Path: <linux-kernel-owner+w=401wt.eu-S1762118AbYG3NK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762118AbYG3NK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 09:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760509AbYG3NJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 09:09:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57682 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606AbYG3NJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:09:25 -0400
Message-Id: <20080730130915.714685009@szeredi.hu>
References: <20080730130845.905327725@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 30 Jul 2008 15:08:48 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 3/4] vfs: remove unused nameidata argument of may_create()
Content-Disposition: inline; filename=may_create_remove_nameidata.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-07-30 13:52:36.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-07-30 13:52:40.000000000 +0200
@@ -1431,8 +1431,7 @@ static int may_delete(struct inode *dir,
  *  3. We should have write and exec permissions on dir
  *  4. We can't do it if dir is immutable (done in permission())
  */
-static inline int may_create(struct inode *dir, struct dentry *child,
-			     struct nameidata *nd)
+static inline int may_create(struct inode *dir, struct dentry *child)
 {
 	if (child->d_inode)
 		return -EEXIST;
@@ -1504,7 +1503,7 @@ void unlock_rename(struct dentry *p1, st
 int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		struct nameidata *nd)
 {
-	int error = may_create(dir, dentry, nd);
+	int error = may_create(dir, dentry);
 
 	if (error)
 		return error;
@@ -1948,7 +1947,7 @@ EXPORT_SYMBOL_GPL(lookup_create);
 
 int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
-	int error = may_create(dir, dentry, NULL);
+	int error = may_create(dir, dentry);
 
 	if (error)
 		return error;
@@ -2049,7 +2048,7 @@ asmlinkage long sys_mknod(const char __u
 
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-	int error = may_create(dir, dentry, NULL);
+	int error = may_create(dir, dentry);
 
 	if (error)
 		return error;
@@ -2316,7 +2315,7 @@ asmlinkage long sys_unlink(const char __
 
 int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
 {
-	int error = may_create(dir, dentry, NULL);
+	int error = may_create(dir, dentry);
 
 	if (error)
 		return error;
@@ -2386,7 +2385,7 @@ int vfs_link(struct dentry *old_dentry, 
 	if (!inode)
 		return -ENOENT;
 
-	error = may_create(dir, new_dentry, NULL);
+	error = may_create(dir, new_dentry);
 	if (error)
 		return error;
 
@@ -2595,7 +2594,7 @@ int vfs_rename(struct inode *old_dir, st
 		return error;
 
 	if (!new_dentry->d_inode)
-		error = may_create(new_dir, new_dentry, NULL);
+		error = may_create(new_dir, new_dentry);
 	else
 		error = may_delete(new_dir, new_dentry, is_dir);
 	if (error)

--
