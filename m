Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbZFTScb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbZFTScb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZFTScW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:32:22 -0400
Received: from verein.lst.de ([213.95.11.210]:58170 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZFTScW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:32:22 -0400
Date: Sat, 20 Jun 2009 20:32:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: don't bounce highmem requests
Message-ID: <20090620183215.GA24936@lst.de>
References: <20090619182022.GA10999@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619182022.GA10999@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like I sent a patch that doesn't actually compile because qui
decided to apply those fixes to a different one.  Here's the correc
one:

--

Subject: virtio_blk: don't bounce highmem requests
From: Christoph Hellwig <hch@lst.de>

By default a block driver bounces highmem requests, but virtio-blk is
perfectly fine with any request that fit into it's 64 bit addressing scheme,
mapped in the kernel virtual space or not.

Besides improving performance on highmem systems this also makes the
reproducible oops in __bounce_end_io go away (but hiding the real cause).

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2009-06-20 20:11:44.769929544 +0200
+++ linux-2.6/drivers/block/virtio_blk.c	2009-06-20 20:20:29.661804686 +0200
@@ -360,6 +360,9 @@ static int __devinit virtblk_probe(struc
 	blk_queue_max_phys_segments(vblk->disk->queue, vblk->sg_elems-2);
 	blk_queue_max_hw_segments(vblk->disk->queue, vblk->sg_elems-2);
 
+	/* No need to bounce any requests */
+	blk_queue_bounce_limit(vblk->disk->queue, BLK_BOUNCE_ANY);
+
 	/* No real sector limit. */
 	blk_queue_max_sectors(vblk->disk->queue, -1U);
 
