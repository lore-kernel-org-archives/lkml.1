Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZIQXry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZIQXry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZIQXrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:47:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59090 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZIQXrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:47:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/5] Blackfin SPI: work around anomaly 05000119
Date: Thu, 17 Sep 2009 19:47:50 -0400
Message-Id: <1253231273-16423-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253231273-16423-1-git-send-email-vapier@gentoo.org>
References: <1253231273-16423-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Anomaly 05000119 states that the DMA_RUN bit with peripherals isn't
reliable.  However, the way the driver is currently written (DMA IRQ
callback), we don't need the polling in the first place, so drop it.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/spi/spi_bfin5xx.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 8ec4969..5591bce 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -539,10 +539,6 @@ static irqreturn_t bfin_spi_dma_irq_handler(int irq, void *dev_id)
 
 	clear_dma_irqstat(drv_data->dma_channel);
 
-	/* Wait for DMA to complete */
-	while (get_dma_curr_irqstat(drv_data->dma_channel) & DMA_RUN)
-		cpu_relax();
-
 	/*
 	 * wait for the last transaction shifted out.  HRM states:
 	 * at this point there may still be data in the SPI DMA FIFO waiting
-- 
1.6.5.rc1

