Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZKPRVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZKPRVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZKPRVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:21:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59939 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753230AbZKPRVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:21:53 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpiolib: Implement gpio_to_irq() for wm831x
Date: Mon, 16 Nov 2009 17:21:56 +0000
Message-Id: <1258392116-31973-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/wm831x-gpio.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/wm831x-gpio.c
index f5e4934..b4468b6 100644
--- a/drivers/gpio/wm831x-gpio.c
+++ b/drivers/gpio/wm831x-gpio.c
@@ -22,6 +22,7 @@
 #include <linux/mfd/wm831x/core.h>
 #include <linux/mfd/wm831x/pdata.h>
 #include <linux/mfd/wm831x/gpio.h>
+#include <linux/mfd/wm831x/irq.h>
 
 struct wm831x_gpio {
 	struct wm831x *wm831x;
@@ -78,6 +79,17 @@ static void wm831x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 			value << offset);
 }
 
+static int wm831x_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
+	struct wm831x *wm831x = wm831x_gpio->wm831x;
+
+	if (!wm831x->irq_base)
+		return -EINVAL;
+
+	return wm831x->irq_base + WM831X_IRQ_GPIO_1 + offset;
+}
+
 #ifdef CONFIG_DEBUG_FS
 static void wm831x_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
@@ -173,6 +185,7 @@ static struct gpio_chip template_chip = {
 	.get			= wm831x_gpio_get,
 	.direction_output	= wm831x_gpio_direction_out,
 	.set			= wm831x_gpio_set,
+	.to_irq			= wm831x_gpio_to_irq,
 	.dbg_show		= wm831x_gpio_dbg_show,
 	.can_sleep		= 1,
 };
-- 
1.6.5.2

