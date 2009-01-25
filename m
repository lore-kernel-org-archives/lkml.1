Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbZAYWvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbZAYWvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZAYWve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:51:34 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:25405 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZAYWvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:51:33 -0500
Subject: mmc: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: drzeus-mmc@drzeus.cx
Cc: gregkh <gregkh@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 23:50:42 +0100
Message-Id: <1232923842.2924.14.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: mmc: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: drzeus-mmc@drzeus.cx
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/mmc/host/atmel-mci.c  |    2 +-
 drivers/mmc/host/of_mmc_spi.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1602,7 +1602,7 @@ static int __init atmci_probe(struct pla
 
 	tasklet_init(&host->tasklet, atmci_tasklet_func, (unsigned long)host);
 
-	ret = request_irq(irq, atmci_interrupt, 0, pdev->dev.bus_id, host);
+	ret = request_irq(irq, atmci_interrupt, 0, dev_name(&pdev->dev), host);
 	if (ret)
 		goto err_request_irq;
 
--- a/drivers/mmc/host/of_mmc_spi.c
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -103,7 +103,7 @@ struct mmc_spi_platform_data *mmc_spi_ge
 		if (!gpio_is_valid(oms->gpios[i]))
 			continue;
 
-		ret = gpio_request(oms->gpios[i], dev->bus_id);
+		ret = gpio_request(oms->gpios[i], dev_name(dev));
 		if (ret < 0) {
 			oms->gpios[i] = -EINVAL;
 			continue;


