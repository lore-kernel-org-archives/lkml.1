Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYBJMzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYBJMzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbYBJMzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:55:00 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:52351 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbYBJMy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:54:59 -0500
Message-ID: <47AEF409.1030800@freemail.hu>
Date: Sun, 10 Feb 2008 13:54:33 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: Andrey Kamenov <akamenov@users.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: add mail LED support for "Clevo D400P"
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The leds-clevo-mail module also works with model "Clevo D400P",
add this model to the white list.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Andrey Kamenov <akamenov@users.sourceforge.net>
---
diff -uprN a/drivers/leds/Kconfig b/drivers/leds/Kconfig
--- a/drivers/leds/Kconfig	2008-02-09 08:02:16.000000000 +0100
+++ b/drivers/leds/Kconfig	2008-02-10 13:47:31.000000000 +0100
@@ -135,6 +135,7 @@ config LEDS_CLEVO_MAIL

 	  This module can drive the mail LED for the following notebooks:

+	  	Clevo D400P
 	  	Clevo D410J
 	  	Clevo D410V
 	  	Clevo D400V/D470V (not tested, but might work)
@@ -142,6 +143,9 @@ config LEDS_CLEVO_MAIL
 	  	Clevo M5x0N (not tested, but might work)
 	  	Positivo Mobile (Clevo M5x0V)

+	  If your model is not listed here you can try the "nodetect"
+	  module paramter.
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-clevo-mail.

diff -uprN a/drivers/leds/leds-clevo-mail.c b/drivers/leds/leds-clevo-mail.c
--- a/drivers/leds/leds-clevo-mail.c	2008-02-09 08:02:16.000000000 +0100
+++ b/drivers/leds/leds-clevo-mail.c	2008-02-10 13:07:51.000000000 +0100
@@ -69,6 +69,16 @@ static struct dmi_system_id __initdata m
 	},
 	{
 		.callback = clevo_mail_led_dmi_callback,
+		.ident = "Clevo D400P",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Clevo"),
+			DMI_MATCH(DMI_BOARD_NAME, "D400P"),
+			DMI_MATCH(DMI_BOARD_VERSION, "Rev.A"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "0106")
+		}
+	},
+	{
+		.callback = clevo_mail_led_dmi_callback,
 		.ident = "Clevo D410V",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Clevo, Co."),
