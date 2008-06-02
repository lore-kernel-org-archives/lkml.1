Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYFBKBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYFBKBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYFBJ7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:59:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32971 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYFBJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:59:05 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] mpc52xx_gpio iomem annotations
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <E1K36og-0007Yp-He@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 02 Jun 2008 10:59:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c b/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
index 48da5df..8a455eb 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
@@ -100,7 +100,7 @@ static int mpc52xx_wkup_gpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct mpc52xx_gpiochip *chip = container_of(mm_gc,
 			struct mpc52xx_gpiochip, mmchip);
-	struct mpc52xx_gpio_wkup *regs = mm_gc->regs;
+	struct mpc52xx_gpio_wkup __iomem *regs = mm_gc->regs;
 	unsigned long flags;
 
 	spin_lock_irqsave(&gpio_lock, flags);
@@ -122,7 +122,7 @@ static int
 mpc52xx_wkup_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 {
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
-	struct mpc52xx_gpio_wkup *regs = mm_gc->regs;
+	struct mpc52xx_gpio_wkup __iomem *regs = mm_gc->regs;
 	struct mpc52xx_gpiochip *chip = container_of(mm_gc,
 			struct mpc52xx_gpiochip, mmchip);
 	unsigned long flags;
@@ -150,7 +150,7 @@ static int __devinit mpc52xx_wkup_gpiochip_probe(struct of_device *ofdev,
 					const struct of_device_id *match)
 {
 	struct mpc52xx_gpiochip *chip;
-	struct mpc52xx_gpio_wkup *regs;
+	struct mpc52xx_gpio_wkup __iomem *regs;
 	struct of_gpio_chip *ofchip;
 	int ret;
 
@@ -260,7 +260,7 @@ static int mpc52xx_simple_gpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct mpc52xx_gpiochip *chip = container_of(mm_gc,
 			struct mpc52xx_gpiochip, mmchip);
-	struct mpc52xx_gpio *regs = mm_gc->regs;
+	struct mpc52xx_gpio __iomem *regs = mm_gc->regs;
 	unsigned long flags;
 
 	spin_lock_irqsave(&gpio_lock, flags);
@@ -284,7 +284,7 @@ mpc52xx_simple_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct mpc52xx_gpiochip *chip = container_of(mm_gc,
 			struct mpc52xx_gpiochip, mmchip);
-	struct mpc52xx_gpio *regs = mm_gc->regs;
+	struct mpc52xx_gpio __iomem *regs = mm_gc->regs;
 	unsigned long flags;
 
 	spin_lock_irqsave(&gpio_lock, flags);
@@ -312,7 +312,7 @@ static int __devinit mpc52xx_simple_gpiochip_probe(struct of_device *ofdev,
 {
 	struct mpc52xx_gpiochip *chip;
 	struct of_gpio_chip *ofchip;
-	struct mpc52xx_gpio *regs;
+	struct mpc52xx_gpio __iomem *regs;
 	int ret;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
@@ -387,7 +387,7 @@ mpc52xx_gpt_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 static int mpc52xx_gpt_gpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 {
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
-	struct mpc52xx_gpt *regs = mm_gc->regs;
+	struct mpc52xx_gpt __iomem *regs = mm_gc->regs;
 
 	out_be32(&regs->mode, 0x04);
 
