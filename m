Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbYEKRoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbYEKRoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757696AbYEKRnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:43:39 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:50035 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757665AbYEKRni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:43:38 -0400
Message-Id: <20080511174449.950622775@sortiz.org>
References: <20080511173653.869192035@sortiz.org>
User-Agent: quilt/0.46-1
Date: Sun, 11 May 2008 19:36:57 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: [PATCH -mm 4/5] asic3: use dev_* macros
Content-Disposition: inline; filename=asic3-dbg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We replace the various printks, and use the dev_* macros instead.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
---
 drivers/mfd/asic3.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

Index: linux-2.6-htc-asic3/drivers/mfd/asic3.c
===================================================================
--- linux-2.6-htc-asic3.orig/drivers/mfd/asic3.c	2008-05-11 17:57:40.000000000 +0200
+++ linux-2.6-htc-asic3/drivers/mfd/asic3.c	2008-05-11 18:03:52.000000000 +0200
@@ -145,8 +145,7 @@ static void asic3_irq_demux(unsigned int
 	}
 
 	if (iter >= MAX_ASIC_ISR_LOOPS)
-		printk(KERN_ERR "%s: interrupt processing overrun\n",
-		       __func__);
+		dev_err(asic->dev, "interrupt processing overrun\n");
 }
 
 static inline int asic3_irq_to_bank(struct asic3 *asic, int irq)
@@ -282,7 +281,7 @@ static int asic3_gpio_irq_type(unsigned 
 		 * be careful to not unmask them if mask was also called.
 		 * Probably need internal state for mask.
 		 */
-		printk(KERN_NOTICE "asic3: irq type not changed.\n");
+		dev_notice(asic->dev, "irq type not changed\n");
 	}
 	asic3_write_register(asic, bank + ASIC3_GPIO_LevelTrigger,
 			     level);
@@ -376,8 +375,8 @@ static int asic3_gpio_direction(struct g
 	gpio_base = ASIC3_GPIO_TO_BASE(offset);
 
 	if (gpio_base > ASIC3_GPIO_D_Base) {
-		printk(KERN_ERR "Invalid base (0x%x) for gpio %d\n",
-		       gpio_base, offset);
+		dev_err(asic->dev, "Invalid base (0x%x) for gpio %d\n",
+			gpio_base, offset);
 		return -EINVAL;
 	}
 
@@ -422,8 +421,8 @@ static int asic3_gpio_get(struct gpio_ch
 	gpio_base = ASIC3_GPIO_TO_BASE(offset);
 
 	if (gpio_base > ASIC3_GPIO_D_Base) {
-		printk(KERN_ERR "Invalid base (0x%x) for gpio %d\n",
-		       gpio_base, offset);
+		dev_err(asic->dev, "Invalid base (0x%x) for gpio %d\n",
+			gpio_base, offset);
 		return -EINVAL;
 	}
 
@@ -442,8 +441,8 @@ static void asic3_gpio_set(struct gpio_c
 	gpio_base = ASIC3_GPIO_TO_BASE(offset);
 
 	if (gpio_base > ASIC3_GPIO_D_Base) {
-		printk(KERN_ERR "Invalid base (0x%x) for gpio %d\n",
-		       gpio_base, offset);
+		dev_err(asic->dev, "Invalid base (0x%x) for gpio %d\n",
+			gpio_base, offset);
 		return;
 	}
 
@@ -548,7 +547,7 @@ static int asic3_probe(struct platform_d
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem) {
 		ret = -ENOMEM;
-		printk(KERN_ERR "asic3: no MEM resource\n");
+		dev_err(asic->dev, "no MEM resource\n");
 		goto out_free;
 	}
 
@@ -556,7 +555,7 @@ static int asic3_probe(struct platform_d
 	asic->mapping = ioremap(mem->start, PAGE_SIZE);
 	if (!asic->mapping) {
 		ret = -ENOMEM;
-		printk(KERN_ERR "asic3: couldn't ioremap\n");
+		dev_err(asic->dev, "Couldn't ioremap\n");
 		goto out_free;
 	}
 
@@ -572,7 +571,7 @@ static int asic3_probe(struct platform_d
 
 	ret = asic3_irq_probe(pdev);
 	if (ret < 0) {
-		printk(KERN_ERR "asic3: couldn't probe IRQs\n");
+		dev_err(asic->dev, "Couldn't probe IRQs\n");
 		goto out_unmap;
 	}
 
@@ -587,11 +586,11 @@ static int asic3_probe(struct platform_d
 			       pdata->gpio_config,
 			       pdata->gpio_config_num);
 	if (ret < 0) {
-		printk(KERN_ERR "GPIO probe failed\n");
+		dev_err(asic->dev, "GPIO probe failed\n");
 		goto out_irq;
 	}
 
-	printk(KERN_INFO "ASIC3 Core driver\n");
+	dev_info(asic->dev, "ASIC3 Core driver\n");
 
 	return 0;
 

-- 
