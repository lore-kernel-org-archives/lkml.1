Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXISDlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXISDlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbXISDhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:37:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54951 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752237AbXISDgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:44 -0400
Message-Id: <20070919033643.996885990@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:21 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [16/17] Allow virtual fallback for buffer_heads
Content-Disposition: inline; filename=vcompound_buffer_head
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is in particular useful for large I/Os because it will allow > 100
allocs from the SLUB fast path without having to go to the page allocator.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2007-09-18 15:44:37.000000000 -0700
+++ linux-2.6/fs/buffer.c	2007-09-18 15:44:51.000000000 -0700
@@ -3008,7 +3008,8 @@ void __init buffer_init(void)
 	int nrpages;
 
 	bh_cachep = KMEM_CACHE(buffer_head,
-			SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
+			SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD|
+			SLAB_VFALLBACK);
 
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL

-- 
