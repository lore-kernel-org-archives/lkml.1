Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbXH0R3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbXH0R3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757745AbXH0R1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:27:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760754AbXH0R1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:27:47 -0400
Date: Mon, 27 Aug 2007 13:27:44 -0400
Message-Id: <200708271727.l7RHRi42007270@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 4/4] Documentation: update in-tree fs docs for new function
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This updates the VFS docs under the Documentation/ directory to describe
the new killattr inode operation.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 Documentation/filesystems/Locking |    2 ++
 Documentation/filesystems/vfs.txt |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index fe26cc9..ac377aa 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -51,6 +51,7 @@ ata *);
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
+	void (*killattr) (struct dentry *, struct iattr *);
 
 locking rules:
 	all may block, none have BKL
@@ -74,6 +75,7 @@ setxattr:	yes
 getxattr:	no
 listxattr:	no
 removexattr:	yes
+killattr:	yes
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
 victim.
 	cross-directory ->rename() has (per-superblock) ->s_vfs_rename_sem.
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 05a7b83..ca3a403 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -348,6 +348,7 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	void (*killattr)(struct dentry *, struct iattr *);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -447,6 +448,11 @@ otherwise noted.
   truncate_range: a method provided by the underlying filesystem to truncate a
   	range of blocks , i.e. punch a hole somewhere in a file.
 
+  killattr: called by the VFS when a setuid/setgid inode is modified. This 
+	allows a filesystem to override the standard behavior and handle
+	the ATTR_KILL_SUID and ATTR_KILL_SGID bits in its own way. Should
+	only be defined if the standard method for clearing setuid/setgid
+	bits is not adequate for your filesystem.
 
 The Address Space Object
 ========================
-- 
1.5.2.1

