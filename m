Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYKRHy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYKRHy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYKRHv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:29 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:46413 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYKRHvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:25 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690394"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 07/16] Blackfin SPI Driver: drop bogus cast and touchup dma label
Date: Tue, 18 Nov 2008 15:52:31 +0800
Message-Id: <1226994760-4301-8-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index df424a2..a7c8976 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1076,13 +1076,13 @@ static int setup(struct spi_device *spi)
 	 */
 	if (chip->enable_dma && !drv_data->dma_requested) {
 		/* register dma irq handler */
-		if (request_dma(drv_data->dma_channel, "BF53x_SPI_DMA") < 0) {
+		if (request_dma(drv_data->dma_channel, "BFIN_SPI_DMA") < 0) {
 			dev_dbg(&spi->dev,
 				"Unable to request BlackFin SPI DMA channel\n");
 			return -ENODEV;
 		}
 		if (set_dma_callback(drv_data->dma_channel,
-			(void *)dma_irq_handler, drv_data) < 0) {
+		    dma_irq_handler, drv_data) < 0) {
 			dev_dbg(&spi->dev, "Unable to set dma callback\n");
 			return -EPERM;
 		}
-- 
1.5.6.3
