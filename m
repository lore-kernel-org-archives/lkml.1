Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYGUTeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYGUTeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbYGUTdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:33:47 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46256 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672AbYGUTdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:33:46 -0400
Date: Mon, 21 Jul 2008 22:33:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Christian Limpach <Christian.Limpach@xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] xen-blkfront.c: make blkif_ioctl() static
Message-ID: <20080721193339.GC14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global blkif_ioctl() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
c3e35790145bb28443ccb672fb46318e845c5f05 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9ae05c5..3ca643c 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -154,8 +154,8 @@ static int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
 	return 0;
 }
 
-int blkif_ioctl(struct inode *inode, struct file *filep,
-		unsigned command, unsigned long argument)
+static int blkif_ioctl(struct inode *inode, struct file *filep,
+		       unsigned command, unsigned long argument)
 {
 	struct blkfront_info *info =
 		inode->i_bdev->bd_disk->private_data;

