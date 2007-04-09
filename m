Return-Path: <linux-kernel-owner+w=401wt.eu-S965965AbXDIV3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965965AbXDIV3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030266AbXDIV3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:29:39 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:31759 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030263AbXDIV3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:29:31 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan McDowell <noodles@earth.li>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 2/14] ARM: OMAP: Add support for Amstrad Delta keypad
Date: Mon,  9 Apr 2007 17:28:27 -0400
Message-Id: <11761541282179-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761541231278-git-send-email-tony@atomide.com>
References: <1176154119123-git-send-email-tony@atomide.com> <11761541231278-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>

This adds support for the keypad on the top of the Amstrad Delta. It's
just a standard omap-keypad so all we need to do is add the keypad
layout and platform data to the board definition file.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-ams-delta.c |  108 +++++++++++++++++++++++++++++++++
 1 files changed, 108 insertions(+), 0 deletions(-)

Index: linux-2.6/arch/arm/mach-omap1/board-ams-delta.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-ams-delta.c	2007-04-09 14:50:28.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-ams-delta.c	2007-04-09 14:52:01.000000000 -0400
@@ -14,6 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/input.h>
 #include <linux/platform_device.h>
 
 #include <asm/hardware.h>
@@ -23,6 +24,7 @@
 
 #include <asm/arch/board-ams-delta.h>
 #include <asm/arch/gpio.h>
+#include <asm/arch/keypad.h>
 #include <asm/arch/mux.h>
 #include <asm/arch/usb.h>
 #include <asm/arch/board.h>
@@ -31,6 +33,86 @@
 static u8 ams_delta_latch1_reg;
 static u16 ams_delta_latch2_reg;
 
+static int ams_delta_keymap[] = {
+	KEY(0, 0, KEY_F1),	/* Advert	*/
+
+	KEY(3, 0, KEY_COFFEE),	/* Games	 */
+	KEY(2, 0, KEY_QUESTION),	/* Directory */
+	KEY(3, 2, KEY_CONNECT),	/* Internet  */
+	KEY(2, 1, KEY_SHOP),	/* Services  */
+	KEY(1, 1, KEY_PHONE),	/* VoiceMail */
+
+	KEY(1, 0, KEY_DELETE),	/* Delete	*/
+	KEY(2, 2, KEY_PLAY),	/* Play	  */
+	KEY(0, 1, KEY_PAGEUP),	/* Up	*/
+	KEY(3, 1, KEY_PAGEDOWN),	/* Down	  */
+	KEY(0, 2, KEY_EMAIL),	/* ReadEmail */
+	KEY(1, 2, KEY_STOP),	/* Stop	  */
+
+	/* Numeric keypad portion */
+	KEY(7, 0, KEY_KP1),
+	KEY(6, 0, KEY_KP2),
+	KEY(5, 0, KEY_KP3),
+	KEY(7, 1, KEY_KP4),
+	KEY(6, 1, KEY_KP5),
+	KEY(5, 1, KEY_KP6),
+	KEY(7, 2, KEY_KP7),
+	KEY(6, 2, KEY_KP8),
+	KEY(5, 2, KEY_KP9),
+	KEY(6, 3, KEY_KP0),
+	KEY(7, 3, KEY_KPASTERISK),
+	KEY(5, 3, KEY_KPDOT),	/* # key	 */
+	KEY(2, 7, KEY_NUMLOCK),	/* Mute	  */
+	KEY(1, 7, KEY_KPMINUS),	/* Recall	*/
+	KEY(1, 6, KEY_KPPLUS),	/* Redial	*/
+	KEY(6, 7, KEY_KPSLASH),	/* Handsfree */
+	KEY(0, 6, KEY_ENTER),	/* Video	 */
+
+	KEY(4, 7, KEY_CAMERA),	/* Photo	 */
+
+	KEY(4, 0, KEY_F2),	/* Home	  */
+	KEY(4, 1, KEY_F3),	/* Office	*/
+	KEY(4, 2, KEY_F4),	/* Mobile	*/
+	KEY(7, 7, KEY_F5),	/* SMS		*/
+	KEY(5, 7, KEY_F6),	/* Email	 */
+
+	/* QWERTY portion of keypad */
+	KEY(4, 3, KEY_Q),
+	KEY(3, 3, KEY_W),
+	KEY(2, 3, KEY_E),
+	KEY(1, 3, KEY_R),
+	KEY(0, 3, KEY_T),
+	KEY(7, 4, KEY_Y),
+	KEY(6, 4, KEY_U),
+	KEY(5, 4, KEY_I),
+	KEY(4, 4, KEY_O),
+	KEY(3, 4, KEY_P),
+
+	KEY(2, 4, KEY_A),
+	KEY(1, 4, KEY_S),
+	KEY(0, 4, KEY_D),
+	KEY(7, 5, KEY_F),
+	KEY(6, 5, KEY_G),
+	KEY(5, 5, KEY_H),
+	KEY(4, 5, KEY_J),
+	KEY(3, 5, KEY_K),
+	KEY(2, 5, KEY_L),
+
+	KEY(1, 5, KEY_Z),
+	KEY(0, 5, KEY_X),
+	KEY(7, 6, KEY_C),
+	KEY(6, 6, KEY_V),
+	KEY(5, 6, KEY_B),
+	KEY(4, 6, KEY_N),
+	KEY(3, 6, KEY_M),
+	KEY(2, 6, KEY_SPACE),
+
+	KEY(0, 7, KEY_LEFTSHIFT),	/* Vol up	*/
+	KEY(3, 7, KEY_LEFTCTRL),	/* Vol down  */
+
+	0
+};
+
 void ams_delta_latch1_write(u8 mask, u8 value)
 {
 	ams_delta_latch1_reg &= ~mask;
@@ -91,12 +173,39 @@ static struct omap_board_config_kernel a
 	{ OMAP_TAG_USB,		&ams_delta_usb_config },
 };
 
+static struct resource ams_delta_kp_resources[] = {
+	[0] = {
+		.start	= INT_KEYBOARD,
+		.end	= INT_KEYBOARD,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct omap_kp_platform_data ams_delta_kp_data = {
+	.rows		= 8,
+	.cols		= 8,
+	.keymap 	= ams_delta_keymap,
+	.keymapsize	= ARRAY_SIZE(ams_delta_keymap),
+	.delay		= 9,
+};
+
+static struct platform_device ams_delta_kp_device = {
+	.name		= "omap-keypad",
+	.id		= -1,
+	.dev		= {
+		.platform_data = &ams_delta_kp_data,
+	},
+	.num_resources	= ARRAY_SIZE(ams_delta_kp_resources),
+	.resource	= ams_delta_kp_resources,
+};
+
 static struct platform_device ams_delta_led_device = {
 	.name	= "ams-delta-led",
 	.id	= -1
 };
 
 static struct platform_device *ams_delta_devices[] __initdata = {
+	&ams_delta_kp_device,
 	&ams_delta_led_device,
 };
 
