Return-Path: <linux-kernel-owner+w=401wt.eu-S1759704AbZCXLf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbZCXLf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758461AbZCXLfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:35:16 -0400
Received: from relay.atmel.no ([80.232.32.139]:63499 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757209AbZCXLfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:35:15 -0400
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: maciej.sosnowski@intel.com
Cc: linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [PATCH 1/2] dw_dmac: set CAP_PRIVATE capability for DW DMA controller
Date: Tue, 24 Mar 2009 12:35:05 +0100
Message-Id: <1237894506-11622-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the private capability for the DW DMA controller. This
allows the DMA controller to do other DMA transfers than
memory-to-memory. For example when the DMA controller is used by
peripherals to transfer data between memory and peripheral.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 drivers/dma/dw_dmac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index a97c07e..1c5e31d 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -994,6 +994,7 @@ static int __init dw_probe(struct platform_device *pdev)
 	channel_clear_bit(dw, MASK.DST_TRAN, dw->all_chan_mask);
 	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);
 
+	dma_cap_set(DMA_PRIVATE, dw->dma.cap_mask);
 	dma_cap_set(DMA_MEMCPY, dw->dma.cap_mask);
 	dma_cap_set(DMA_SLAVE, dw->dma.cap_mask);
 	dw->dma.dev = &pdev->dev;
-- 
1.5.6.3

