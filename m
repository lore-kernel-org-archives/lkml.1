Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbXFTSgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbXFTSgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759290AbXFTSa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:30:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54800 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757426AbXFTSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:11 -0400
Message-Id: <20070620183011.103124771@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:29 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [22/37] Use page_cache_xxx in drivers/block/rd.c
Content-Disposition: inline; filename=vps_drivers_block_rd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 drivers/block/rd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: vps/drivers/block/rd.c
===================================================================
--- vps.orig/drivers/block/rd.c	2007-06-14 21:49:09.000000000 -0700
+++ vps/drivers/block/rd.c	2007-06-14 21:50:28.000000000 -0700
@@ -121,7 +121,7 @@ static void make_page_uptodate(struct pa
 			}
 		} while ((bh = bh->b_this_page) != head);
 	} else {
-		memset(page_address(page), 0, PAGE_CACHE_SIZE);
+		memset(page_address(page), 0, page_cache_size(page_mapping(page)));
 	}
 	flush_dcache_page(page);
 	SetPageUptodate(page);
@@ -201,9 +201,9 @@ static const struct address_space_operat
 static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t sector,
 				struct address_space *mapping)
 {
-	pgoff_t index = sector >> (PAGE_CACHE_SHIFT - 9);
+	pgoff_t index = sector >> (page_cache_size(mapping) - 9);
 	unsigned int vec_offset = vec->bv_offset;
-	int offset = (sector << 9) & ~PAGE_CACHE_MASK;
+	int offset = page_cache_offset(mapping, (sector << 9));
 	int size = vec->bv_len;
 	int err = 0;
 
@@ -213,7 +213,7 @@ static int rd_blkdev_pagecache_IO(int rw
 		char *src;
 		char *dst;
 
-		count = PAGE_CACHE_SIZE - offset;
+		count = page_cache_size(mapping) - offset;
 		if (count > size)
 			count = size;
 		size -= count;

-- 
