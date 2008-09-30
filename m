Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYI3O2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYI3O2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYI3O2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:28:39 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:34225 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbYI3O2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:28:38 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: dan.j.williams@intel.com
Cc: maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] dw_dmac: Fix copy/paste bug in tasklet
Date: Tue, 30 Sep 2008 16:27:59 +0200
Message-Id: <1222784879-14160-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 30 Sep 2008 14:27:44.0326 (UTC) FILETIME=[B3FE2E60:01C92308]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tasklet checks RAW.BLOCK twice, and does not check RAW.XFER. This is
obviously wrong, and could theoretically cause the driver to hang.

Reported-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 94df917..0778d99 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -364,7 +364,7 @@ static void dw_dma_tasklet(unsigned long data)
 	int i;
 
 	status_block = dma_readl(dw, RAW.BLOCK);
-	status_xfer = dma_readl(dw, RAW.BLOCK);
+	status_xfer = dma_readl(dw, RAW.XFER);
 	status_err = dma_readl(dw, RAW.ERROR);
 
 	dev_vdbg(dw->dma.dev, "tasklet: status_block=%x status_err=%x\n",
-- 
1.5.6.5

