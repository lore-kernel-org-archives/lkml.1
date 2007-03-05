Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbXCEXG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbXCEXG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbXCEXG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:06:27 -0500
Received: from reserv6.univ-lille1.fr ([193.49.225.20]:46311 "EHLO
	reserv6.univ-lille1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXCEXG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:06:26 -0500
Message-ID: <45ECA23A.5010503@tremplin-utc.net>
Date: Tue, 06 Mar 2007 00:05:30 +0100
From: Eric Piel <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070215)
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com
CC: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org
Subject: [PATCH] Wistron button support for TravelMate 610
Content-Type: multipart/mixed;
 boundary="------------080805080306090406040705"
X-Greylist: Sender DNS name whitelisted, not delayed by milter-greylist-2.0.2 (reserv6.univ-lille1.fr [193.49.225.20]); Tue, 06 Mar 2007 00:05:36 +0100 (CET)
X-USTL-MailScanner-Information: Please contact the ISP for more information
X-USTL-MailScanner: Found to be clean
X-USTL-MailScanner-From: eric.piel@tremplin-utc.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080805080306090406040705
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

Here is a patch adding support to wistron button for Acer TravelMate 
610. This is tested and works fine with the exception of the leds which 
cannot be controlled (yet, that would require writing a led interface 
for them when I've got time ;-) )

I'm sending just this one for now (as I can test it) but if you like it, 
I would like to try to add all the database of keyboards available in 
acerhk (that Olaf has written).

See you,
Eric

---
From: Eric Piel <eric.piel@tremplin-utc.net>

TM610 support for wistron_btns.

Adds support for Acer TravelMate 610 to wistron_btns, coming from info 
of acer_hk. All special keys are detected, but the 2 leds are not 
handled (yet).

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---


--------------080805080306090406040705
Content-Type: text/x-patch;
 name="wistron_btns-tm610-from-acerhk-2.6.21.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wistron_btns-tm610-from-acerhk-2.6.21.patch"

diff -urpN -X linux-2.6.21/Documentation/dontdiff linux-2.6.21-rc2.bak/drivers/input/misc/wistron_btns.c linux-2.6.21/drivers/input/misc/wistron_btns.c
--- linux-2.6.21-rc2.bak/drivers/input/misc/wistron_btns.c	2007-03-03 12:33:41.000000000 +0100
+++ linux-2.6.21/drivers/input/misc/wistron_btns.c	2007-03-03 12:35:53.000000000 +0100
@@ -324,6 +324,21 @@ static struct key_entry keymap_acer_trav
 	{ KE_END, 0 }
 };
 
+/* Wifi subsystem only activate the led. Therefore we need to pass
+ * wifi event as a normal key, then userspace can really change the wifi state.
+ * TODO we need to export led state to userspace (wifi and mail) */
+static struct key_entry keymap_acer_travelmate_610[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_KEY, 0x14, KEY_MAIL },
+	{ KE_KEY, 0x15, KEY_WWW },
+	{ KE_KEY, 0x40, KEY_XFER }, /* Wifi */
+	{ KE_END, 0 }
+};
+
 static struct key_entry keymap_aopen_1559as[] = {
 	{ KE_KEY,  0x01, KEY_HELP },
 	{ KE_KEY,  0x06, KEY_PROG3 },
@@ -408,6 +423,15 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Acer TravelMate 610",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ACER"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 610"),
+		},
+		.driver_data = keymap_acer_travelmate_610
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "AOpen 1559AS",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "E2U"),

--------------080805080306090406040705--
