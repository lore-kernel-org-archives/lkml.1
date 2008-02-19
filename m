Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYBSSx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYBSSx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYBSSxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:53:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:46428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbYBSSxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:53:48 -0500
Subject: patch debugfs-fix-sparse-warnings.patch added to gregkh-2.6 tree
To: harvey.harrison@gmail.com, akpm@linux-foundation.org, greg@kroah.com,
       gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Tue, 19 Feb 2008 10:50:40 -0800
In-Reply-To: <1202951296.18204.39.camel@brick>
Message-ID: <1203447040988@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: debugfs: fix sparse warnings

to my gregkh-2.6 tree.  Its filename is

     debugfs-fix-sparse-warnings.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From harvey.harrison@gmail.com Wed Feb 13 17:08:21 2008
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Wed, 13 Feb 2008 17:08:16 -0800
Subject: debugfs: fix sparse warnings
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <1202951296.18204.39.camel@brick>


extern does not belong in C files, move declaration to linux/debugfs.h
fs/debugfs/file.c:42:30: warning: symbol 'debugfs_file_operations' was not declared. Should it be static?
fs/debugfs/file.c:54:31: warning: symbol 'debugfs_link_operations' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/debugfs/inode.c      |    4 ----
 include/linux/debugfs.h |    5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -29,10 +29,6 @@
 
 #define DEBUGFS_MAGIC	0x64626720
 
-/* declared over in file.c */
-extern struct file_operations debugfs_file_operations;
-extern struct inode_operations debugfs_link_operations;
-
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
 
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -27,6 +27,11 @@ struct debugfs_blob_wrapper {
 };
 
 #if defined(CONFIG_DEBUG_FS)
+
+/* declared over in file.c */
+extern const struct file_operations debugfs_file_operations;
+extern const struct inode_operations debugfs_link_operations;
+
 struct dentry *debugfs_create_file(const char *name, mode_t mode,
 				   struct dentry *parent, void *data,
 				   const struct file_operations *fops);


Patches currently in gregkh-2.6 which might be from harvey.harrison@gmail.com are

driver/debugfs-fix-sparse-warnings.patch
