Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbZCYAbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbZCYAbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbZCYA3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:38 -0400
Received: from kroah.org ([198.145.64.141]:54042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756106AbZCYA3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, drzeus-mmc@drzeus.cx
Subject: [PATCH 05/61] mmc: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:09 -0700
Message-Id: <1237940825-22904-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: drzeus-mmc@drzeus.cx
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/mmc/host/atmel-mci.c  |    2 +-
 drivers/mmc/host/of_mmc_spi.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 2b1196e..e94e920 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1603,7 +1603,7 @@ static int __init atmci_probe(struct platform_device *pdev)
 
 	tasklet_init(&host->tasklet, atmci_tasklet_func, (unsigned long)host);
 
-	ret = request_irq(irq, atmci_interrupt, 0, pdev->dev.bus_id, host);
+	ret = request_irq(irq, atmci_interrupt, 0, dev_name(&pdev->dev), host);
 	if (ret)
 		goto err_request_irq;
 
diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
index fb2921f..0c44d56 100644
--- a/drivers/mmc/host/of_mmc_spi.c
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -103,7 +103,7 @@ struct mmc_spi_platform_data *mmc_spi_get_pdata(struct spi_device *spi)
 		if (!gpio_is_valid(oms->gpios[i]))
 			continue;
 
-		ret = gpio_request(oms->gpios[i], dev->bus_id);
+		ret = gpio_request(oms->gpios[i], dev_name(dev));
 		if (ret < 0) {
 			oms->gpios[i] = -EINVAL;
 			continue;
-- 
1.6.2

