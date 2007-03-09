Return-Path: <linux-kernel-owner+w=401wt.eu-S964953AbXCILzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953AbXCILzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965654AbXCILzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:55:10 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37471 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964953AbXCILzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:55:07 -0500
Date: Fri, 9 Mar 2007 13:55:06 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: alan@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] revoke: consolidate revoked file operations
Message-ID: <Pine.LNX.4.64.0703091353450.13990@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Return EBADF for all revoked file operations except for read(2) which
returns zero for special files as the BSDs do and close(2) which is 
always zero.

Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoked_inode.c |  367 +++++------------------------------------------------
 1 file changed, 38 insertions(+), 329 deletions(-)

Index: uml-2.6/fs/revoked_inode.c
===================================================================
--- uml-2.6.orig/fs/revoked_inode.c	2007-03-09 13:26:30.000000000 +0200
+++ uml-2.6/fs/revoked_inode.c	2007-03-09 13:47:54.000000000 +0200
@@ -29,6 +29,12 @@
 	return -EBADF;
 }
 
+static ssize_t revoked_special_file_read(struct file *filp, char __user * buf,
+					 size_t size, loff_t * ppos)
+{
+	return 0;
+}
+
 static ssize_t revoked_file_write(struct file *filp, const char __user * buf,
 				  size_t siz, loff_t * ppos)
 {
@@ -200,6 +206,35 @@
 	.splice_read = revoked_file_splice_read,
 };
 
+static const struct file_operations revoked_special_file_ops = {
+	.llseek = revoked_file_llseek,
+	.read = revoked_special_file_read,
+	.write = revoked_file_write,
+	.aio_read = revoked_file_aio_read,
+	.aio_write = revoked_file_aio_write,
+	.readdir = revoked_file_readdir,
+	.poll = revoked_file_poll,
+	.ioctl = revoked_file_ioctl,
+	.unlocked_ioctl = revoked_file_unlocked_ioctl,
+	.compat_ioctl = revoked_file_compat_ioctl,
+	.mmap = revoked_file_mmap,
+	.open = revoked_file_open,
+	.flush = revoked_file_flush,
+	.release = revoked_file_release,
+	.fsync = revoked_file_fsync,
+	.aio_fsync = revoked_file_aio_fsync,
+	.fasync = revoked_file_fasync,
+	.lock = revoked_file_lock,
+	.sendfile = revoked_file_sendfile,
+	.sendpage = revoked_file_sendpage,
+	.get_unmapped_area = revoked_file_get_unmapped_area,
+	.check_flags = revoked_file_check_flags,
+	.dir_notify = revoked_file_dir_notify,
+	.flock = revoked_file_flock,
+	.splice_write = revoked_file_splice_write,
+	.splice_read = revoked_file_splice_read,
+};
+
 static int revoked_inode_create(struct inode *dir, struct dentry *dentry,
 				int mode, struct nameidata *nd)
 {
@@ -326,330 +361,6 @@
 	/* truncate_range returns void */
 };
 
-static loff_t revoked_special_file_llseek(struct file *file, loff_t offset,
-					  int origin)
-{
-	return -ENXIO;
-}
-
-static ssize_t revoked_special_file_read(struct file *filp, char __user * buf,
-					 size_t size, loff_t * ppos)
-{
-	return -ENXIO;
-}
-
-static ssize_t revoked_special_file_write(struct file *filp,
-					  const char __user * buf, size_t siz,
-					  loff_t * ppos)
-{
-	return -ENXIO;
-}
-
-static ssize_t revoked_special_file_aio_read(struct kiocb *iocb,
-					     const struct iovec *iov,
-					     unsigned long nr_segs, loff_t pos)
-{
-	return -ENXIO;
-}
-
-static ssize_t revoked_special_file_aio_write(struct kiocb *iocb,
-					      const struct iovec *iov,
-					      unsigned long nr_segs, loff_t pos)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_file_readdir(struct file *filp, void *dirent,
-					filldir_t filldir)
-{
-	return -ENXIO;
-}
-
-static unsigned int revoked_special_file_poll(struct file *filp,
-					      poll_table * wait)
-{
-	return POLLERR;
-}
-
-static int revoked_special_file_ioctl(struct inode *inode, struct file *filp,
-				      unsigned int cmd, unsigned long arg)
-{
-	return -ENXIO;
-}
-
-static long revoked_special_file_unlocked_ioctl(struct file *file, unsigned cmd,
-						unsigned long arg)
-{
-	return -ENXIO;
-}
-
-static long revoked_special_file_compat_ioctl(struct file *file,
-					      unsigned int cmd,
-					      unsigned long arg)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_file_mmap(struct file *file,
-				     struct vm_area_struct *vma)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_file_open(struct inode *inode, struct file *filp)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_file_flush(struct file *file, fl_owner_t id)
-{
-	return 0;
-}
-
-static int revoked_special_file_release(struct inode *inode, struct file *filp)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_file_fsync(struct file *file, struct dentry *dentry,
-				      int datasync)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_file_aio_fsync(struct kiocb *iocb, int datasync)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_file_fasync(int fd, struct file *filp, int on)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_file_lock(struct file *file, int cmd,
-				     struct file_lock *fl)
-{
-	return -ENXIO;
-}
-
-static ssize_t revoked_special_file_sendfile(struct file *in_file,
-					     loff_t * ppos, size_t count,
-					     read_actor_t actor, void *target)
-{
-	return -ENXIO;
-}
-
-static ssize_t revoked_special_file_sendpage(struct file *file,
-					     struct page *page, int off,
-					     size_t len, loff_t * pos, int more)
-{
-	return -ENXIO;
-}
-
-static unsigned long revoked_special_file_get_unmapped_area(struct file *file,
-							    unsigned long addr,
-							    unsigned long len,
-							    unsigned long pgoff,
-							    unsigned long flags)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_file_check_flags(int flags)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_file_dir_notify(struct file *file, unsigned long arg)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_file_flock(struct file *filp, int cmd,
-				      struct file_lock *fl)
-{
-	return -ENXIO;
-}
-
-static ssize_t revoked_special_file_splice_write(struct pipe_inode_info *pipe,
-						 struct file *out,
-						 loff_t * ppos, size_t len,
-						 unsigned int flags)
-{
-	return -ENXIO;
-}
-
-static ssize_t revoked_special_file_splice_read(struct file *in, loff_t * ppos,
-						struct pipe_inode_info *pipe,
-						size_t len, unsigned int flags)
-{
-	return -ENXIO;
-}
-
-static const struct file_operations revoked_special_file_ops = {
-	.llseek = revoked_special_file_llseek,
-	.read = revoked_special_file_read,
-	.write = revoked_special_file_write,
-	.aio_read = revoked_special_file_aio_read,
-	.aio_write = revoked_special_file_aio_write,
-	.readdir = revoked_special_file_readdir,
-	.poll = revoked_special_file_poll,
-	.ioctl = revoked_special_file_ioctl,
-	.unlocked_ioctl = revoked_special_file_unlocked_ioctl,
-	.compat_ioctl = revoked_special_file_compat_ioctl,
-	.mmap = revoked_special_file_mmap,
-	.open = revoked_special_file_open,
-	.flush = revoked_special_file_flush,
-	.release = revoked_special_file_release,
-	.fsync = revoked_special_file_fsync,
-	.aio_fsync = revoked_special_file_aio_fsync,
-	.fasync = revoked_special_file_fasync,
-	.lock = revoked_special_file_lock,
-	.sendfile = revoked_special_file_sendfile,
-	.sendpage = revoked_special_file_sendpage,
-	.get_unmapped_area = revoked_special_file_get_unmapped_area,
-	.check_flags = revoked_special_file_check_flags,
-	.dir_notify = revoked_special_file_dir_notify,
-	.flock = revoked_special_file_flock,
-	.splice_write = revoked_special_file_splice_write,
-	.splice_read = revoked_special_file_splice_read,
-};
-
-static int revoked_special_inode_create(struct inode *dir,
-					struct dentry *dentry, int mode,
-					struct nameidata *nd)
-{
-	return -ENXIO;
-}
-
-static struct dentry *revoked_special_inode_lookup(struct inode *dir,
-						   struct dentry *dentry,
-						   struct nameidata *nd)
-{
-	return ERR_PTR(-ENXIO);
-}
-
-static int revoked_special_inode_link(struct dentry *old_dentry,
-				      struct inode *dir, struct dentry *dentry)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_unlink(struct inode *dir,
-					struct dentry *dentry)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_symlink(struct inode *dir,
-					 struct dentry *dentry,
-					 const char *symname)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_mkdir(struct inode *dir, struct dentry *dentry,
-				       int mode)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_rmdir(struct inode *dir, struct dentry *dentry)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_mknod(struct inode *dir, struct dentry *dentry,
-				       int mode, dev_t rdev)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_rename(struct inode *old_dir,
-					struct dentry *old_dentry,
-					struct inode *new_dir,
-					struct dentry *new_dentry)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_readlink(struct dentry *dentry,
-					  char __user * buffer, int buflen)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_permission(struct inode *inode, int mask,
-					    struct nameidata *nd)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_getattr(struct vfsmount *mnt,
-					 struct dentry *dentry,
-					 struct kstat *stat)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_setattr(struct dentry *direntry,
-					 struct iattr *attrs)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_setxattr(struct dentry *dentry,
-					  const char *name, const void *value,
-					  size_t size, int flags)
-{
-	return -ENXIO;
-}
-
-static ssize_t revoked_special_inode_getxattr(struct dentry *dentry,
-					      const char *name, void *buffer,
-					      size_t size)
-{
-	return -ENXIO;
-}
-
-static ssize_t revoked_special_inode_listxattr(struct dentry *dentry,
-					       char *buffer, size_t buffer_size)
-{
-	return -ENXIO;
-}
-
-static int revoked_special_inode_removexattr(struct dentry *dentry,
-					     const char *name)
-{
-	return -ENXIO;
-}
-
-static struct inode_operations revoked_special_inode_ops = {
-	.create = revoked_special_inode_create,
-	.lookup = revoked_special_inode_lookup,
-	.link = revoked_special_inode_link,
-	.unlink = revoked_special_inode_unlink,
-	.symlink = revoked_special_inode_symlink,
-	.mkdir = revoked_special_inode_mkdir,
-	.rmdir = revoked_special_inode_rmdir,
-	.mknod = revoked_special_inode_mknod,
-	.rename = revoked_special_inode_rename,
-	.readlink = revoked_special_inode_readlink,
-	/* follow_link must be no-op, otherwise unmounting this inode
-	   won't work */
-	/* put_link returns void */
-	/* truncate returns void */
-	.permission = revoked_special_inode_permission,
-	.getattr = revoked_special_inode_getattr,
-	.setattr = revoked_special_inode_setattr,
-	.setxattr = revoked_special_inode_setxattr,
-	.getxattr = revoked_special_inode_getxattr,
-	.listxattr = revoked_special_inode_listxattr,
-	.removexattr = revoked_special_inode_removexattr,
-	/* truncate_range returns void */
-};
-
 void make_revoked_inode(struct inode *inode, int mode)
 {
 	remove_inode_hash(inode);
@@ -657,12 +368,10 @@
 	inode->i_mode = mode;
 	inode->i_atime = inode->i_mtime = inode->i_ctime =
 	    current_fs_time(inode->i_sb);
+	inode->i_op = &revoked_inode_ops;
 
-	if (special_file(mode)) {
-		inode->i_op = &revoked_special_inode_ops;
+	if (special_file(mode))
 		inode->i_fop = &revoked_special_file_ops;
-	} else {
-		inode->i_op = &revoked_inode_ops;
+	else
 		inode->i_fop = &revoked_file_ops;
-	}
 }
