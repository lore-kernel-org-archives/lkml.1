Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbXGVHKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbXGVHKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 03:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXGVHKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 03:10:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53361 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbXGVHKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 03:10:39 -0400
Date: Sun, 22 Jul 2007 08:10:35 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jk@ozlabs.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] ppc64 mismerge
Message-ID: <20070722071035.GS21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Mismerge in
commit 8b6f50ef1d5cc86b278eb42bc91630fad455fb10
Author: Jeremy Kerr <jk@ozlabs.org>
Date:   Sat Jul 21 04:37:51 2007 -0700
    spufs: make signal-notification files readonly for NOSCHED contexts

structs got duplicated.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index c2aaec5..4100ddc 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -941,13 +941,6 @@ static const struct file_operations spufs_signal1_nosched_fops = {
 	.mmap = spufs_signal1_mmap,
 };
 
-static const struct file_operations spufs_signal1_nosched_fops = {
-	.open = spufs_signal1_open,
-	.release = spufs_signal1_release,
-	.write = spufs_signal1_write,
-	.mmap = spufs_signal1_mmap,
-};
-
 static int spufs_signal2_open(struct inode *inode, struct file *file)
 {
 	struct spufs_inode_info *i = SPUFS_I(inode);
@@ -1083,13 +1076,6 @@ static const struct file_operations spufs_signal2_nosched_fops = {
 	.mmap = spufs_signal2_mmap,
 };
 
-static const struct file_operations spufs_signal2_nosched_fops = {
-	.open = spufs_signal2_open,
-	.release = spufs_signal2_release,
-	.write = spufs_signal2_write,
-	.mmap = spufs_signal2_mmap,
-};
-
 static void spufs_signal1_type_set(void *data, u64 val)
 {
 	struct spu_context *ctx = data;
