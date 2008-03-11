Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYCKEQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYCKEQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYCKEQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:16:37 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:39470 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYCKEQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:16:36 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 1/2] Fix a bug about BUG_ON() on DMA engine capability DMA_INTERRUPT.
Date: Tue, 11 Mar 2008 11:25:16 +0800
Message-Id: <1205205917-21861-1-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 11 Mar 2008 03:27:16.0090 (UTC) FILETIME=[CDDDFDA0:01C88327]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device->device_prep_dma_interrupt function is used by
DMA_INTERRUPT capability, not DMA_ZERO_SUM.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 drivers/dma/dmaengine.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 2996523..8db0e7f 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -357,7 +357,7 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_zero_sum);
 	BUG_ON(dma_has_cap(DMA_MEMSET, device->cap_mask) &&
 		!device->device_prep_dma_memset);
-	BUG_ON(dma_has_cap(DMA_ZERO_SUM, device->cap_mask) &&
+	BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
 		!device->device_prep_dma_interrupt);
 
 	BUG_ON(!device->device_alloc_chan_resources);
-- 
1.5.4

