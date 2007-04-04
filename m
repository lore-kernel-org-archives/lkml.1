Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbXDDS2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbXDDS2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934069AbXDDS1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:27:50 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:38366 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934066AbXDDSLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:11:15 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 51/90] ARM: OMAP: osk+mistral backlight, power, board specific
Date: Wed,  4 Apr 2007 14:05:30 -0400
Message-Id: <11757101072553-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1175710103340-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Mistral-specific:

  - Add PWL-driven LCD backlight device

  - Apply power to the board even when the LCD isn't configured; things
    like EEPROM, temperature sensor, and wakeup switch depend on it.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-osk.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index 253c539..df9681d 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -293,6 +293,18 @@ static struct platform_device osk5912_kp_device = {
 	.resource	= osk5912_kp_resources,
 };
 
+static struct omap_backlight_config mistral_bl_data = {
+	.default_intensity	= 0xa0,
+};
+
+static struct platform_device mistral_bl_device = {
+	.name		= "omap-bl",
+	.id		= -1,
+	.dev		= {
+		.platform_data = &mistral_bl_data,
+	},
+};
+
 static struct platform_device osk5912_lcd_device = {
 	.name		= "lcd_osk",
 	.id		= -1,
@@ -300,6 +312,7 @@ static struct platform_device osk5912_lcd_device = {
 
 static struct platform_device *mistral_devices[] __initdata = {
 	&osk5912_kp_device,
+	&mistral_bl_device,
 	&osk5912_lcd_device,
 };
 
@@ -373,6 +386,15 @@ static void __init osk_mistral_init(void)
 	} else
 		printk(KERN_ERR "OSK+Mistral: wakeup button is awol\n");
 
+	/* LCD:  backlight, and power; power controls other devices on the
+	 * board, like the touchscreen, EEPROM, and wakeup (!) switch.
+	 */
+	omap_cfg_reg(PWL);
+	if (omap_request_gpio(2) == 0) {
+		omap_set_gpio_direction(2, 0 /* out */);
+		omap_set_gpio_dataout(2, 1 /* on */);
+	}
+
 	platform_add_devices(mistral_devices, ARRAY_SIZE(mistral_devices));
 }
 #else
-- 
1.4.4.2

