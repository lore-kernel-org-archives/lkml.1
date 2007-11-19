Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbXKSPCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbXKSPCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbXKSPC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:02:28 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:44223 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbXKSPC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:02:27 -0500
Date: Tue, 20 Nov 2007 00:00:42 +0900
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: kill deprecated virt_to_bus
From: FUJITA Tomonori <tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071120000238O.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pci-noop.c doesn't use DMA mappings.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/alpha/kernel/pci-noop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/pci-noop.c b/arch/alpha/kernel/pci-noop.c
index 468b76c..8ac0831 100644
--- a/arch/alpha/kernel/pci-noop.c
+++ b/arch/alpha/kernel/pci-noop.c
@@ -165,7 +165,7 @@ dma_alloc_coherent(struct device *dev, size_t size,
 	ret = (void *)__get_free_pages(gfp, get_order(size));
 	if (ret) {
 		memset(ret, 0, size);
-		*dma_handle = virt_to_bus(ret);
+		*dma_handle = virt_to_phys(ret);
 	}
 	return ret;
 }
@@ -184,7 +184,7 @@ dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 
 		BUG_ON(!sg_page(sg));
 		va = sg_virt(sg);
-		sg_dma_address(sg) = (dma_addr_t)virt_to_bus(va);
+		sg_dma_address(sg) = (dma_addr_t)virt_to_phys(va);
 		sg_dma_len(sg) = sg->length;
 	}
 
-- 
1.5.3.4

