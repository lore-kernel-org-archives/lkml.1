Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXJWPAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXJWPAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXJWPAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:00:23 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:39998 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751294AbXJWPAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:00:23 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2007 11:00:22 EDT
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 23 Oct 2007 07:53:01 -0700
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [POWERPC] Fix fallout from sg_page changes
Message-ID: <20071023145300.GA18989@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 include/asm-powerpc/dma-mapping.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/asm-powerpc/dma-mapping.h b/include/asm-powerpc/dma-mapping.h
index 65be95d..43b4f3b 100644
--- a/include/asm-powerpc/dma-mapping.h
+++ b/include/asm-powerpc/dma-mapping.h
@@ -285,9 +285,9 @@ dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 	BUG_ON(direction == DMA_NONE);
 
 	for_each_sg(sgl, sg, nents, i) {
-		BUG_ON(!sg->page);
-		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
-		sg->dma_address = page_to_bus(sg->page) + sg->offset;
+		BUG_ON(!sg_page(sg));
+		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
+		sg->dma_address = virt_to_bus(sg_virt(sg));
 	}
 
 	return nents;
@@ -328,7 +328,7 @@ static inline void dma_sync_sg_for_cpu(struct device *dev,
 	BUG_ON(direction == DMA_NONE);
 
 	for_each_sg(sgl, sg, nents, i)
-		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
+		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
 }
 
 static inline void dma_sync_sg_for_device(struct device *dev,
@@ -341,7 +341,7 @@ static inline void dma_sync_sg_for_device(struct device *dev,
 	BUG_ON(direction == DMA_NONE);
 
 	for_each_sg(sgl, sg, nents, i)
-		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
+		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
 }
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
-- 
1.5.3.4

