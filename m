Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbZIWHTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbZIWHTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZIWHTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:19:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59387 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZIWHTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:19:06 -0400
From: Anuj Aggarwal <anuj.aggarwal@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: [PATCH] SDMA: Fixing bug in omap_dma_set_global_params()
Date: Wed, 23 Sep 2009 12:49:06 +0530
Message-Id: <1253690346-17865-1-git-send-email-anuj.aggarwal@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argument tparams was not being used to program
global register GCR.HI_THREAD_RESERVED. This patch fixes the same.

Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
---
 arch/arm/plat-omap/dma.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index bf08634..7a7b6df 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -829,10 +829,10 @@ EXPORT_SYMBOL(omap_free_dma);
  *
  * @param arb_rate
  * @param max_fifo_depth
- * @param tparams - Number of thereads to reserve : DMA_THREAD_RESERVE_NORM
- * 						    DMA_THREAD_RESERVE_ONET
- * 						    DMA_THREAD_RESERVE_TWOT
- * 						    DMA_THREAD_RESERVE_THREET
+ * @param tparams - Number of threads to reserve : DMA_THREAD_RESERVE_NORM
+ * 						   DMA_THREAD_RESERVE_ONET
+ * 						   DMA_THREAD_RESERVE_TWOT
+ * 						   DMA_THREAD_RESERVE_THREET
  */
 void
 omap_dma_set_global_params(int arb_rate, int max_fifo_depth, int tparams)
@@ -847,8 +847,9 @@ omap_dma_set_global_params(int arb_rate, int max_fifo_depth, int tparams)
 	if (arb_rate == 0)
 		arb_rate = 1;
 
-	reg = (arb_rate & 0xff) << 16;
-	reg |= (0xff & max_fifo_depth);
+	reg = 0xff & max_fifo_depth;
+	reg |= (0x3 & tparams) << 12;
+	reg |= (arb_rate & 0xff) << 16;
 
 	dma_write(reg, GCR);
 }
-- 
1.6.2.4

