Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYBQISK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYBQISK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbYBQIRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:17:36 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36798 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972AbYBQIRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:17:10 -0500
Date: Sun, 17 Feb 2008 10:16:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make struct def_blk_aops static
Message-ID: <20080217081644.GC3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct def_blk_aops static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/block_dev.c     |    4 +++-
 include/linux/fs.h |    1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

b6975210aef8e29f8d372ea25e4fd6d1d4749e5d diff --git a/fs/block_dev.c b/fs/block_dev.c
index 67fe72c..8335f0e 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -31,6 +31,8 @@ struct bdev_inode {
 	struct inode vfs_inode;
 };
 
+static const struct address_space_operations def_blk_aops;
+
 static inline struct bdev_inode *BDEV_I(struct inode *inode)
 {
 	return container_of(inode, struct bdev_inode, vfs_inode);
@@ -1334,7 +1336,7 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return blkdev_ioctl(file->f_mapping->host, file, cmd, arg);
 }
 
-const struct address_space_operations def_blk_aops = {
+static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
 	.writepage	= blkdev_writepage,
 	.sync_page	= block_sync_page,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 98ffb6e..b84b848 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1590,7 +1590,6 @@ extern void bd_set_size(struct block_device *, loff_t size);
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
 extern struct block_device *open_by_devnum(dev_t, unsigned);
-extern const struct address_space_operations def_blk_aops;
 #else
 static inline void bd_forget(struct inode *inode) {}
 #endif

