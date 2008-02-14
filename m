Return-Path: <linux-kernel-owner+w=401wt.eu-S934396AbYBNBIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934396AbYBNBIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762094AbYBNBIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:08:22 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:20493 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758945AbYBNBIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:08:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=v3YCPLwZllVflh94WTAA/H0Dfrbi+uPdhD9oq5Q8L6CkrybyvMXZiqda3T+1ykOtjhQqIWJgdQelTcrxCF6em2AZ7qElzWnsPOv0RJ2Rd3yqkxOtuKYDYc2/zDcFYRAobWiY1x7jGlG4uv9n6AjcsrHTFtWXpMQEOEwtmFyiGlk=
Subject: [PATCH] debugfs: fix sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 17:08:16 -0800
Message-Id: <1202951296.18204.39.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

extern does not belong in C files, move declaration to linux/debugfs.h
fs/debugfs/file.c:42:30: warning: symbol 'debugfs_file_operations' was not declared. Should it be static?
fs/debugfs/file.c:54:31: warning: symbol 'debugfs_link_operations' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
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
1.5.4.1.1278.gc75be



