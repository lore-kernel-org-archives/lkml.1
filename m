Return-Path: <linux-kernel-owner+w=401wt.eu-S934677AbZJJRzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677AbZJJRzr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 13:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933074AbZJJRzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 13:55:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59678 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761791AbZJJRyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 13:54:43 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 4/5] GPIO: adp5520: rename common defines and typos
Date: Sat, 10 Oct 2009 13:54:03 -0400
Message-Id: <1255197244-20121-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1255197244-20121-1-git-send-email-vapier@gentoo.org>
References: <1255197244-20121-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

The common adp5520 mfd defines were namespaced to avoid collisions, so
update the define used in this driver accordingly.  The structs were also
renamed to fix a spelling typo.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/gpio/adp5520-gpio.c |   36 ++++++++++++++++++++----------------
 1 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/adp5520-gpio.c b/drivers/gpio/adp5520-gpio.c
index ad05bbc..0f93105 100644
--- a/drivers/gpio/adp5520-gpio.c
+++ b/drivers/gpio/adp5520-gpio.c
@@ -34,9 +34,9 @@ static int adp5520_gpio_get_value(struct gpio_chip *chip, unsigned off)
 	 */
 
 	if (test_bit(off, &dev->output))
-		adp5520_read(dev->master, GPIO_OUT, &reg_val);
+		adp5520_read(dev->master, ADP5520_GPIO_OUT, &reg_val);
 	else
-		adp5520_read(dev->master, GPIO_IN, &reg_val);
+		adp5520_read(dev->master, ADP5520_GPIO_IN, &reg_val);
 
 	return !!(reg_val & dev->lut[off]);
 }
@@ -48,9 +48,9 @@ static void adp5520_gpio_set_value(struct gpio_chip *chip,
 	dev = container_of(chip, struct adp5520_gpio, gpio_chip);
 
 	if (val)
-		adp5520_set_bits(dev->master, GPIO_OUT, dev->lut[off]);
+		adp5520_set_bits(dev->master, ADP5520_GPIO_OUT, dev->lut[off]);
 	else
-		adp5520_clr_bits(dev->master, GPIO_OUT, dev->lut[off]);
+		adp5520_clr_bits(dev->master, ADP5520_GPIO_OUT, dev->lut[off]);
 }
 
 static int adp5520_gpio_direction_input(struct gpio_chip *chip, unsigned off)
@@ -60,7 +60,8 @@ static int adp5520_gpio_direction_input(struct gpio_chip *chip, unsigned off)
 
 	clear_bit(off, &dev->output);
 
-	return adp5520_clr_bits(dev->master, GPIO_CFG_2, dev->lut[off]);
+	return adp5520_clr_bits(dev->master, ADP5520_GPIO_CFG_2,
+				dev->lut[off]);
 }
 
 static int adp5520_gpio_direction_output(struct gpio_chip *chip,
@@ -73,18 +74,21 @@ static int adp5520_gpio_direction_output(struct gpio_chip *chip,
 	set_bit(off, &dev->output);
 
 	if (val)
-		ret |= adp5520_set_bits(dev->master, GPIO_OUT, dev->lut[off]);
+		ret |= adp5520_set_bits(dev->master, ADP5520_GPIO_OUT,
+					dev->lut[off]);
 	else
-		ret |= adp5520_clr_bits(dev->master, GPIO_OUT, dev->lut[off]);
+		ret |= adp5520_clr_bits(dev->master, ADP5520_GPIO_OUT,
+					dev->lut[off]);
 
-	ret |= adp5520_set_bits(dev->master, GPIO_CFG_2, dev->lut[off]);
+	ret |= adp5520_set_bits(dev->master, ADP5520_GPIO_CFG_2,
+					dev->lut[off]);
 
 	return ret;
 }
 
 static int __devinit adp5520_gpio_probe(struct platform_device *pdev)
 {
-	struct adp5520_gpio_platfrom_data *pdata = pdev->dev.platform_data;
+	struct adp5520_gpio_platform_data *pdata = pdev->dev.platform_data;
 	struct adp5520_gpio *dev;
 	struct gpio_chip *gc;
 	int ret, i, gpios;
@@ -129,20 +133,20 @@ static int __devinit adp5520_gpio_probe(struct platform_device *pdev)
 	gc->label = pdev->name;
 	gc->owner = THIS_MODULE;
 
-	ret = adp5520_clr_bits(dev->master, GPIO_CFG_1,
+	ret = adp5520_clr_bits(dev->master, ADP5520_GPIO_CFG_1,
 		pdata->gpio_en_mask);
 
-	if (pdata->gpio_en_mask & GPIO_C3)
-		ctl_mask |= C3_MODE;
+	if (pdata->gpio_en_mask & ADP5520_GPIO_C3)
+		ctl_mask |= ADP5520_C3_MODE;
 
-	if (pdata->gpio_en_mask & GPIO_R3)
-		ctl_mask |= R3_MODE;
+	if (pdata->gpio_en_mask & ADP5520_GPIO_R3)
+		ctl_mask |= ADP5520_R3_MODE;
 
 	if (ctl_mask)
-		ret = adp5520_set_bits(dev->master, LED_CONTROL,
+		ret = adp5520_set_bits(dev->master, ADP5520_LED_CONTROL,
 			ctl_mask);
 
-	ret |= adp5520_set_bits(dev->master, GPIO_PULLUP,
+	ret |= adp5520_set_bits(dev->master, ADP5520_GPIO_PULLUP,
 		pdata->gpio_pullup_mask);
 
 	if (ret) {
-- 
1.6.5.rc2

