Return-Path: <linux-kernel-owner+w=401wt.eu-S1762828AbXIKGMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762828AbXIKGMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762443AbXIKGFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:05:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56498 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761202AbXIKGEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:32 -0400
Message-Id: <20070911060429.946061623@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:10 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [20/41] Use page_cache_xxx in drivers/block/rd.c
Content-Disposition: inline; filename=0020-Use-page_cache_xxx-in-drivers-block-rd.c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in drivers/block/rd.c

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 drivers/block/rd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rd.c b/drivers/block/rd.c
index 65150b5..e148b3b 100644
--- a/drivers/block/rd.c
+++ b/drivers/block/rd.c
@@ -121,7 +121,7 @@ static void make_page_uptodate(struct page *page)
 			}
 		} while ((bh = bh->b_this_page) != head);
 	} else {
-		memset(page_address(page), 0, PAGE_CACHE_SIZE);
+		memset(page_address(page), 0, page_cache_size(page_mapping(page)));
 	}
 	flush_dcache_page(page);
 	SetPageUptodate(page);
@@ -201,9 +201,9 @@ static const struct address_space_operations ramdisk_aops = {
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
 
@@ -213,7 +213,7 @@ static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t sector,
 		char *src;
 		char *dst;
 
-		count = PAGE_CACHE_SIZE - offset;
+		count = page_cache_size(mapping) - offset;
 		if (count > size)
 			count = size;
 		size -= count;
-- 
1.5.2.5

-- 
