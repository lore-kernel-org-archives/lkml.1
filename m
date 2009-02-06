Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbZBFHNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbZBFHNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbZBFHLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:23 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:13578 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZBFHLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:19 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422012"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 07/20] Blackfin SPI Driver: drop bogus cast and touchup dma label
Date: Fri,  6 Feb 2009 15:12:55 +0800
Message-Id: <1233904388-5765-8-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Blackfin's related DMA callback API doesn't need void * cast, so drop it.
And this driver is for all Blackfin processors not only for BF53x, we
update the DMA request label for more meaningful information.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/spi/spi_bfin5xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index acb9739..459ec36 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1077,13 +1077,13 @@ static int setup(struct spi_device *spi)
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
