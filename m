Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYKRHzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYKRHzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbYKRHvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:31 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:46413 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbYKRHv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:26 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690404"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 14/16] Blackfin SPI Driver: tweak magic spi dma sequence to get it working on BF54x
Date: Tue, 18 Nov 2008 15:52:38 +0800
Message-Id: <1226994760-4301-15-git-send-email-cooloney@kernel.org>
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
 drivers/spi/spi_bfin5xx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index c2fc3a9..9c602ad 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -858,8 +858,9 @@ static void pump_transfers(unsigned long data)
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
