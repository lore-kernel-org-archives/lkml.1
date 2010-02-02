Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab0BBPcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:32:19 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:8077 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab0BBPcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:32:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=rPKJTi0WpEfQ8Fx9rDHsMq0p+8Bfrd+Fk1uCJAbgCD+I6DFya/ZssXLTF7+LjKpWS6
         5T9XCspA+Os8WLINiVKNh6b1xJ+PukYj7gxCvZoa4yLHznNA5KlQ6GUcJ33sPPYlZpQS
         JNFLdMtfrNGkddcIST8wX2rm59OuwDODsvKbo=
From: Edward Shishkin <edward.shishkin@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: [patch 3/7] roll back vfs-add-super_operationssync_inodes-2.patch
Date: Tue, 2 Feb 2010 16:24:59 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.i686; KDE/4.3.3; i686; ; )
MIME-Version: 1.0
Message-Id: <201002021624.59119.edward.shishkin@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roll back reiser4-vfs-add-super_operationssync_inodes-2.patch
(wrong stuff)

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
---
 fs/fs-writeback.c  |    5 +----
 include/linux/fs.h |    2 --
 2 files changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6.33-rc5-mm1/fs/fs-writeback.c
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.33-rc5-mm1/fs/fs-writeback.c
@@ -1217,10 +1217,7 @@ EXPORT_SYMBOL(writeback_inodes_sb_if_idl
  */
 void sync_inodes_sb(struct super_block *sb)
 {
-	if (sb->s_op->sync_inodes)
-		sb->s_op->sync_inodes(sb, NULL);
-	else
-		bdi_sync_writeback(sb->s_bdi, sb);
+	bdi_sync_writeback(sb->s_bdi, sb);
 	wait_sb_inodes(sb);
 }
 EXPORT_SYMBOL(sync_inodes_sb);
Index: linux-2.6.33-rc5-mm1/include/linux/fs.h
===================================================================
--- linux-2.6.33-rc5-mm1.orig/include/linux/fs.h
+++ linux-2.6.33-rc5-mm1/include/linux/fs.h
@@ -1566,8 +1566,6 @@ struct super_operations {
 	void (*clear_inode) (struct inode *);
 	void (*umount_begin) (struct super_block *);
 
-	void (*sync_inodes)(struct super_block *sb,
-				struct writeback_control *wbc);
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
 #ifdef CONFIG_QUOTA
