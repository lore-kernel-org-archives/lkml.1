Return-Path: <linux-kernel-owner+w=401wt.eu-S1763998AbYBLQoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763998AbYBLQoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932105AbYBLQoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:44:12 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:55223 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759975AbYBLQoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:44:09 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC v3 1/7] dmaengine: Couple DMA channels to their physical DMA device
Date: Tue, 12 Feb 2008 17:43:52 +0100
Message-Id: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 2996523..7c7cb4b 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -379,7 +379,7 @@ int dma_async_device_register(struct dma_device *device)
 
 		chan->chan_id = chancnt++;
 		chan->dev.class = &dma_devclass;
-		chan->dev.parent = NULL;
+		chan->dev.parent = device->dev;
 		snprintf(chan->dev.bus_id, BUS_ID_SIZE, "dma%dchan%d",
 		         device->dev_id, chan->chan_id);
 
-- 
1.5.3.8

