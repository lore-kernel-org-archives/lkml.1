Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0BQSpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:45:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56903 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753828Ab0BQSpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:45:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] gpiolib: Force wm831x GPIOs into GPIO mode when requested
Date: Wed, 17 Feb 2010 18:45:26 +0000
Message-Id: <1266432326-13030-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1266432326-13030-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1266432326-13030-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the chip default but it's possible the bootloader or OTP
will have been configured to a different mode (eg, to provide
feedback during startup).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/wm831x-gpio.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/wm831x-gpio.c
index 5b8dc09..d09021f 100644
--- a/drivers/gpio/wm831x-gpio.c
+++ b/drivers/gpio/wm831x-gpio.c
@@ -44,7 +44,8 @@ static int wm831x_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
 		val |= WM831X_GPN_TRI;
 
 	return wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + offset,
-			       WM831X_GPN_DIR | WM831X_GPN_TRI, val);
+			       WM831X_GPN_DIR | WM831X_GPN_TRI |
+			       WM831X_GPN_FN_MASK, val);
 }
 
 static int wm831x_gpio_get(struct gpio_chip *chip, unsigned offset)
@@ -84,7 +85,8 @@ static int wm831x_gpio_direction_out(struct gpio_chip *chip,
 		val |= WM831X_GPN_TRI;
 
 	ret = wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + offset,
-			      WM831X_GPN_DIR | WM831X_GPN_TRI, val);
+			      WM831X_GPN_DIR | WM831X_GPN_TRI |
+			      WM831X_GPN_FN_MASK, val);
 	if (ret < 0)
 		return ret;
 
-- 
1.6.6.1

