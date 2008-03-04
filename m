Return-Path: <linux-kernel-owner+w=401wt.eu-S933979AbYCDX2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979AbYCDX2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934977AbYCDXT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:19:26 -0500
Received: from mail.suse.de ([195.135.220.2]:49242 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935026AbYCDXTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:19:24 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 8/8] debugfs: fix sparse warnings
Date: Tue,  4 Mar 2008 15:18:52 -0800
Message-Id: <1204672732-3127-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080304231519.GC3073@suse.de>
References: <20080304231519.GC3073@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

extern does not belong in C files, move declaration to linux/debugfs.h
fs/debugfs/file.c:42:30: warning: symbol 'debugfs_file_operations' was not declared. Should it be static?
fs/debugfs/file.c:54:31: warning: symbol 'debugfs_link_operations' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/inode.c      |    4 ----
 include/linux/debugfs.h |    5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index d26e282..e9602d8 100644
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
 
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index f592d6d..7266124 100644
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
-- 
1.5.4.3

