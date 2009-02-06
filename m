Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZBFHQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZBFHQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZBFHL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:27 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:44045 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbZBFHLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:20 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422019"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 14/20] Blackfin SPI Driver: tweak magic spi dma sequence to get it working on BF54x
Date: Fri,  6 Feb 2009 15:13:02 +0800
Message-Id: <1233904388-5765-15-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Without this changes, SPI DMA is not reliably under stress tests.
Obiviously it's a hardware issue which is not addressed by any document.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 748e98f..d8c4be1 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -862,8 +862,9 @@ static void pump_transfers(unsigned long data)
 		set_dma_start_addr(drv_data->dma_channel, dma_start_addr);
 		set_dma_config(drv_data->dma_channel, dma_config);
 		local_irq_save(flags);
-		enable_dma(drv_data->dma_channel);
+		SSYNC();
 		write_CTRL(drv_data, cr);
+		enable_dma(drv_data->dma_channel);
 		dma_enable_irq(drv_data->dma_channel);
 		local_irq_restore(flags);
 
-- 
1.5.6.3
