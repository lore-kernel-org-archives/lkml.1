Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0CNUQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 16:16:20 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44412 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752982Ab0CNUQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 16:16:17 -0400
Date: Sun, 14 Mar 2010 21:16:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: HTC Dream: Hook up LEDs
Message-ID: <20100314201610.GF22059@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook up LEDS on HTC Dream. 

(#ifdef CONFIG_LEDS_GPIO_PLATFORM is actually neccessary, otherwise it
breaks boot if CONFIG_LEDS_GPIO_PLATFORM is not set).

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-msm/board-dream.c b/arch/arm/mach-msm/board-dream.c
index f48c797..9ef7cc8 100644
--- a/arch/arm/mach-msm/board-dream.c
+++ b/arch/arm/mach-msm/board-dream.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/leds.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -153,6 +154,31 @@ static struct platform_device trout_nav_device = {
 };
 #endif
 
+
+static struct gpio_led android_led_list[] = {
+	{
+		.name = "keyboard-backlight",
+		.gpio = TROUT_GPIO_QTKEY_LED_EN,
+	},
+	{
+		.name = "button-backlight",
+		.gpio = TROUT_GPIO_UI_LED_EN,
+	},
+};
+
+static struct gpio_led_platform_data android_leds_data = {
+	.num_leds	= ARRAY_SIZE(android_led_list),
+	.leds		= android_led_list,
+};
+
+static struct platform_device android_leds = {
+	.name		= "leds-gpio",
+	.id		= -1,
+	.dev		= {
+		.platform_data = &android_leds_data,
+	},
+};
+
 /*
  * Core stuff
  */
@@ -168,6 +194,9 @@ static struct platform_device *devices[] __initdata = {
 #ifdef CONFIG_INPUT_GPIO
 	&trout_nav_device,
 #endif
+#ifdef CONFIG_LEDS_GPIO_PLATFORM
+	&android_leds,
+#endif
 };
 
 extern struct sys_timer msm_timer;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
