Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbZCWKLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbZCWKLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbZCWKKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:10:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:48558 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757553AbZCWKKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:10:51 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18gKw8CJ4QgL+LmnmwuGV8Laca9SmkLpCzqh5GPvb
	7aCkW6CSIGL79t
Date: Mon, 23 Mar 2009 11:10:56 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/3 v2] dma: improve section assignment in i.MX31 IPU DMA
 driver
In-Reply-To: <Pine.LNX.4.64.0903231106060.4871@axis700.grange>
Message-ID: <Pine.LNX.4.64.0903231109020.4871@axis700.grange>
References: <Pine.LNX.4.64.0903130837040.4653@axis700.grange>
 <e9c3a7c20903161459n8ad3c6qd705d146703b28a1@mail.gmail.com>
 <Pine.LNX.4.64.0903231106060.4871@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i.MX31 IPU DMA driver is a platform driver, but doesn't need hotplug, so we
can use __init and __exit function attributes.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 drivers/dma/ipu/ipu_idmac.c |    8 ++++----
 drivers/dma/ipu/ipu_irq.c   |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index e929ef3..1040730 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1576,7 +1576,7 @@ static int __init ipu_idmac_init(struct ipu *ipu)
 	return dma_async_device_register(&idmac->dma);
 }
 
-static void ipu_idmac_exit(struct ipu *ipu)
+static void __exit ipu_idmac_exit(struct ipu *ipu)
 {
 	int i;
 	struct idmac *idmac = &ipu->idmac;
@@ -1595,7 +1595,7 @@ static void ipu_idmac_exit(struct ipu *ipu)
  * IPU common probe / remove
  */
 
-static int ipu_probe(struct platform_device *pdev)
+static int __init ipu_probe(struct platform_device *pdev)
 {
 	struct ipu_platform_data *pdata = pdev->dev.platform_data;
 	struct resource *mem_ipu, *mem_ic;
@@ -1695,7 +1695,7 @@ err_noirq:
 	return ret;
 }
 
-static int ipu_remove(struct platform_device *pdev)
+static int __exit ipu_remove(struct platform_device *pdev)
 {
 	struct ipu *ipu = platform_get_drvdata(pdev);
 
@@ -1720,7 +1720,7 @@ static struct platform_driver ipu_platform_driver = {
 		.name	= "ipu-core",
 		.owner	= THIS_MODULE,
 	},
-	.remove		= ipu_remove,
+	.remove		= __exit_p(ipu_remove),
 };
 
 static int __init ipu_init(void)
diff --git a/drivers/dma/ipu/ipu_irq.c b/drivers/dma/ipu/ipu_irq.c
index 83f532c..dd8ebc7 100644
--- a/drivers/dma/ipu/ipu_irq.c
+++ b/drivers/dma/ipu/ipu_irq.c
@@ -352,7 +352,7 @@ static struct irq_chip ipu_irq_chip = {
 };
 
 /* Install the IRQ handler */
-int ipu_irq_attach_irq(struct ipu *ipu, struct platform_device *dev)
+int __init ipu_irq_attach_irq(struct ipu *ipu, struct platform_device *dev)
 {
 	struct ipu_platform_data *pdata = dev->dev.platform_data;
 	unsigned int irq, irq_base, i;
-- 
1.5.4

