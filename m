Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbXKBCjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbXKBCjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 22:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbXKBCij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 22:38:39 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:38428 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbXKBCih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 22:38:37 -0400
X-IronPort-AV: i="4.21,361,1188792000"; 
   d="scan'208"; a="42900211:sNHT33067314"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/4] Blackfin SPI driver: use void __iomem * for regs_base
Date: Fri,  2 Nov 2007 10:38:30 +0800
Message-Id: <1193971112-7744-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193971112-7744-1-git-send-email-bryan.wu@analog.com>
References: <1193971112-7744-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index fc0c374..a6f6d5f 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -78,7 +78,7 @@ struct driver_data {
 	struct spi_master *master;
 
 	/* Regs base of SPI controller */
-	u32 regs_base;
+	void __iomem *regs_base;
 
 	/* BFIN hookup */
 	struct bfin5xx_spi_master *master_info;
@@ -1301,9 +1301,8 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 		goto out_error_get_res;
 	}
 
-	drv_data->regs_base = (u32) ioremap(res->start,
-					(res->end - res->start + 1));
-	if (!drv_data->regs_base) {
+	drv_data->regs_base = ioremap(res->start, (res->end - res->start + 1));
+	if (drv_data->regs_base == NULL) {
 		dev_err(dev, "Cannot map IO\n");
 		status = -ENXIO;
 		goto out_error_ioremap;
@@ -1342,7 +1341,7 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 		goto out_error;
 	}
 
-	dev_info(dev, "%s, Version %s, regs_base@0x%08x, dma channel@%d\n",
+	dev_info(dev, "%s, Version %s, regs_base@%p, dma channel@%d\n",
 		DRV_DESC, DRV_VERSION, drv_data->regs_base,
 		drv_data->dma_channel);
 	return status;
-- 
1.5.3.4
