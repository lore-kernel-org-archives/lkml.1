Return-Path: <linux-kernel-owner+w=401wt.eu-S1756994AbZC3SS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbZC3SS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZC3SP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:15:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:56605 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbZC3SPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:15:17 -0400
Message-Id: <20090330181012.115651016@suse.com>
User-Agent: quilt/0.47-14.9
Date: Mon, 30 Mar 2009 14:02:37 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 22/35 xattr-rework] reiserfs: remove i_has_xattr_dir
References: <20090330180215.951354436@suse.com>
Content-Disposition: inline; filename=patches.suse/reiserfs-remove-i_has_xattr_dir.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 With the changes to xattr root locking, the i_has_xattr_dir flag
 is no longer needed. This patch removes it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---
 fs/reiserfs/xattr.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -459,10 +459,7 @@ int reiserfs_delete_xattrs(struct inode
 
 	dput(root);
 out:
-	if (!err)
-		REISERFS_I(inode)->i_flags =
-		    REISERFS_I(inode)->i_flags & ~i_has_xattr_dir;
-	else
+	if (err)
 		reiserfs_warning(inode->i_sb, "jdm-20004",
 				 "Couldn't remove all xattrs (%d)\n", err);
 	return err;
@@ -660,7 +657,6 @@ reiserfs_xattr_set(struct inode *inode,
 	down_write(&REISERFS_I(inode)->i_xattr_sem);
 
 	xahash = xattr_hash(buffer, buffer_size);
-	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
 	/* Resize it so we're ok to write there */
 	newattrs.ia_size = buffer_size;
@@ -769,7 +765,6 @@ reiserfs_xattr_get(const struct inode *i
 	down_read(&REISERFS_I(inode)->i_xattr_sem);
 
 	isize = i_size_read(dentry->d_inode);
-	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
 	/* Just return the size needed */
 	if (buffer == NULL) {
@@ -999,8 +994,6 @@ ssize_t reiserfs_listxattr(struct dentry
 	buf.r_pos = 0;
 	buf.r_inode = dentry->d_inode;
 
-	REISERFS_I(dentry->d_inode)->i_flags |= i_has_xattr_dir;
-
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_XATTR);
 	err = xattr_readdir(dir->d_inode, reiserfs_listxattr_filler, &buf);
 	mutex_unlock(&dir->d_inode->i_mutex);


