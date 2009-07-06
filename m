Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbZGFPSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbZGFPSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZGFPSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:18:21 -0400
Received: from mail.atmel.fr ([81.80.104.162]:62179 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbZGFPSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:18:21 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dan.j.williams@intel.com, maciej.sosnowski@intel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, haavard.skinnemoen@atmel.com
Cc: patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       nicolas.ferre@atmel.com
Subject: [PATCH] dmaengine: dmatest: correct thread_count while using multiple thread per channel
Date: Mon,  6 Jul 2009 18:19:44 +0200
Message-Id: <1246897184-16833-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that thread_count is not properly calculated in dmatest.
In fact the thread count number that is returned from dmatest_add_threads() is
not correctly added to the thread_count and thus not properly printed.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/dmatest.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 4262ff9..921c5f2 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -508,11 +508,11 @@ static int dmatest_add_channel(struct dma_chan *chan)
 
 	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
 		cnt = dmatest_add_threads(dtc, DMA_MEMCPY);
-		thread_count += cnt > 0 ?: 0;
+		thread_count += cnt > 0 ? cnt : 0;
 	}
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
 		cnt = dmatest_add_threads(dtc, DMA_XOR);
-		thread_count += cnt > 0 ?: 0;
+		thread_count += cnt > 0 ? cnt : 0;
 	}
 
 	pr_info("dmatest: Started %u threads using %s\n",
-- 
1.5.3.7

