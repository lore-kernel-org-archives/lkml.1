Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbZBFHOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbZBFHOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbZBFHLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:25 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:13578 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZBFHLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:20 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422015"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 10/20] Blackfin SPI Driver: use the properl BIT_CTL_xxx defines
Date: Fri,  6 Feb 2009 15:12:58 +0800
Message-Id: <1233904388-5765-11-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

use the properl BIT_CTL_... defines rather than the internal driv
er CFG_SPI_... defines

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index f7a4b5b..54d8948 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -799,7 +799,7 @@ static void pump_transfers(unsigned long data)
 
 			/* start SPI transfer */
 			write_CTRL(drv_data,
-				(cr | CFG_SPI_DMAWRITE | BIT_CTL_ENABLE));
+				(cr | BIT_CTL_TIMOD_DMA_TX | BIT_CTL_ENABLE));
 
 			/* just return here, there can only be one transfer
 			 * in this mode
@@ -827,7 +827,7 @@ static void pump_transfers(unsigned long data)
 
 			dma_config |= WNR;
 			dma_start_addr = (unsigned long)drv_data->rx;
-			cr |= CFG_SPI_DMAREAD;
+			cr |= BIT_CTL_TIMOD_DMA_RX | BIT_CTL_SENDOPT;
 
 		} else if (drv_data->tx != NULL) {
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
@@ -839,7 +839,7 @@ static void pump_transfers(unsigned long data)
 						drv_data->len_in_bytes));
 
 			dma_start_addr = (unsigned long)drv_data->tx;
-			cr |= CFG_SPI_DMAWRITE;
+			cr |= BIT_CTL_TIMOD_DMA_TX;
 
 		} else
 			BUG();
-- 
1.5.6.3
