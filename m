Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbYFYMJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbYFYMJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYFYMIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:08:52 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:41834 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbYFYMIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:08:52 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] dmaengine: Couple DMA channels to their physical DMA device
Date: Wed, 25 Jun 2008 14:08:43 +0200
Message-Id: <1214395723-5657-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 25 Jun 2008 12:08:24.0943 (UTC) FILETIME=[2B57CFF0:01C8D6BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Set the 'parent' field of channel class devices to point to the
physical DMA device initialized by the DMA engine driver.

This allows drivers to use chan->dev.parent for syncing DMA buffers
and adds a 'device' symlink to the real device in
/sys/class/dma/dmaXchanY.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/dma/dmaengine.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 97b329e..99c22b4 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -378,7 +378,7 @@ int dma_async_device_register(struct dma_device *device)
 
 		chan->chan_id = chancnt++;
 		chan->dev.class = &dma_devclass;
-		chan->dev.parent = NULL;
+		chan->dev.parent = device->dev;
 		snprintf(chan->dev.bus_id, BUS_ID_SIZE, "dma%dchan%d",
 		         device->dev_id, chan->chan_id);
 
-- 
1.5.5.4

