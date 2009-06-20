Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbZFTT3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbZFTT3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 15:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZFTT3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 15:29:45 -0400
Received: from verein.lst.de ([213.95.11.210]:58807 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZFTT3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 15:29:45 -0400
Date: Sat, 20 Jun 2009 21:29:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] virtio_blk: ioctl return value fix
Message-ID: <20090620192941.GA26873@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block driver ioctl methods must return ENOTTY and not -ENOIOCTLCMD if
they expect the block layer to handle generic ioctls.

This triggered a BLKROSET failure in xfsqa #200.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2009-06-20 21:21:20.252930284 +0200
+++ linux-2.6/drivers/block/virtio_blk.c	2009-06-20 21:22:48.364932365 +0200
@@ -213,7 +213,7 @@ static int virtblk_ioctl(struct block_de
 	 * Only allow the generic SCSI ioctls if the host can support it.
 	 */
 	if (!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_SCSI))
-		return -ENOIOCTLCMD;
+		return -ENOTTY;
 
 	return scsi_cmd_ioctl(disk->queue, disk, mode, cmd, argp);
 }
