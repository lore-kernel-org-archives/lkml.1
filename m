Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbYKRHzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbYKRHzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYKRHvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:31 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:43724 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbYKRHv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:26 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690399"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 10/16] Blackfin SPI Driver: use the properl BIT_CTL_xxx defines
Date: Tue, 18 Nov 2008 15:52:34 +0800
Message-Id: <1226994760-4301-11-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

use the properl BIT_CTL_... defines rather than the internal driv
er CFG_SPI_... defines

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 3f4a603..4343a92 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -798,7 +798,7 @@ static void pump_transfers(unsigned long data)
 
 			/* start SPI transfer */
 			write_CTRL(drv_data,
-				(cr | CFG_SPI_DMAWRITE | BIT_CTL_ENABLE));
+				(cr | BIT_CTL_TIMOD_DMA_TX | BIT_CTL_ENABLE));
 
 			/* just return here, there can only be one transfer
 			 * in this mode
@@ -821,12 +821,9 @@ static void pump_transfers(unsigned long data)
 							(unsigned long) (drv_data->rx +
 							drv_data->len_in_bytes));
 
-			/* clear tx reg soformer data is not shifted out */
-			write_TDBR(drv_data, 0xFFFF);
-
 			dma_config |= WNR;
 			dma_start_addr = (unsigned long)drv_data->rx;
-			cr |= CFG_SPI_DMAREAD;
+			cr |= BIT_CTL_TIMOD_DMA_RX | BIT_CTL_SENDOPT;
 
 		} else if (drv_data->tx != NULL) {
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
@@ -838,7 +835,7 @@ static void pump_transfers(unsigned long data)
 						drv_data->len_in_bytes));
 
 			dma_start_addr = (unsigned long)drv_data->tx;
-			cr |= CFG_SPI_DMAWRITE;
+			cr |= BIT_CTL_TIMOD_DMA_TX;
 
 		} else
 			BUG();
-- 
1.5.6.3
