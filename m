Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbYFDOrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbYFDOrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYFDOrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:47:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:55898 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751575AbYFDOrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:47:04 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/Otw9oE2vOFynaRxcO5rHqGWCKBaODu/2LzOKS4j
	7e68/BJlIAHW8D
Date: Wed, 4 Jun 2008 16:47:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: dbrownell@users.sourceforge.net
cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [PATCH] pxa2xx_spi.c: remove redundant initialization, spelling fix,
 more verbose error
Message-ID: <Pine.LNX.4.64.0806041645070.32657@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor fixes: remove redundant local variable initialization, fix "can not" to
what I _think_ is a preferred spelling, output IRQ number if requesting it
failed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

Nothing urgent, just, please, queue it for 2.6.27. Thanks

diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
index 0c452c4..4cf72e9 100644
--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -1342,9 +1342,9 @@ static int __init pxa2xx_spi_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct pxa2xx_spi_master *platform_info;
 	struct spi_master *master;
-	struct driver_data *drv_data = NULL;
+	struct driver_data *drv_data;
 	struct ssp_device *ssp;
-	int status = 0;
+	int status;
 
 	platform_info = dev->platform_data;
 
@@ -1357,7 +1357,7 @@ static int __init pxa2xx_spi_probe(struct platform_device *pdev)
 	/* Allocate master with space for drv_data and null dma buffer */
 	master = spi_alloc_master(dev, sizeof(struct driver_data) + 16);
 	if (!master) {
-		dev_err(&pdev->dev, "can not alloc spi_master\n");
+		dev_err(&pdev->dev, "cannot alloc spi_master\n");
 		ssp_free(ssp);
 		return -ENOMEM;
 	}
@@ -1393,7 +1393,7 @@ static int __init pxa2xx_spi_probe(struct platform_device *pdev)
 
 	status = request_irq(ssp->irq, ssp_int, 0, dev->bus_id, drv_data);
 	if (status < 0) {
-		dev_err(&pdev->dev, "can not get IRQ\n");
+		dev_err(&pdev->dev, "cannot get IRQ %d\n", ssp->irq);
 		goto out_error_master_alloc;
 	}
 
