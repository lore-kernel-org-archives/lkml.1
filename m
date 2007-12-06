Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbXLGDkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbXLGDkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 22:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbXLGDkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 22:40:05 -0500
Received: from smtp121.plus.mail.mud.yahoo.com ([209.191.106.152]:27518 "HELO
	smtp121.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752970AbXLGDkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 22:40:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
  b=H/v2o15j2FWD7PfMGkbEFxoR+raDGBs+golQ9chR2VxMWHZW2zSWXmGH5v4SwAhc5RkW2eQoxA5+N1v7qcn/ywfzOLtPV24Yq49e0fSj4uP39oiXz60DcZTFz5b2zPfIHAj7RZKlGe9Rw7rHlDOA5y7D0yf6DhbMqOGkoPFLxnQ=  ;
X-YMail-OSG: lrB3KJUVM1lT1qqydEYO_0FnZe2r9O78MTvXpeurze2HrKgBLSCGYr1b49_7FZW5cKZYxNfpqQ--
Message-ID: <475851DA.2020708@yahoo.fr>
Date: Thu, 06 Dec 2007 20:47:38 +0100
From: =?UTF-8?B?UsOpbWkgSMOpcmlsaWVy?= <rherilier@yahoo.fr>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@mail.ru>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH]  adding wistron_btns support for fujitsu-siemens amilo pro
 edition v3505
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A little patch to make my laptop linux-compliant. It is based on Linux
2.4.24-rc4.

This laptop has 2 keys, so Wi-Fi and Bluetooth can be activated singly.
I know all others laptop entries use the 0x30 "keycode" for Wi-Fi but I
prefer having this key outside the keyboard to avoid killing it
accidentally.

So...


Wistron button support for Fujitsu-Siemens Amilo Pro Edition V3505.

Signed-off-by: Remi Herilier <rherilier@yahoo.fr>


diff --git a/drivers/input/misc/wistron_btns.c b/drivers/input/misc/wistron_btns.c
index b438d99..7df3328 100644
--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -277,6 +277,16 @@ static struct key_entry keymap_fs_amilo_pro_v2000[] __initdata = {
 	{ KE_END,  0 }
 };
 
+static struct key_entry keymap_fs_amilo_pro_v3505[] __initdata = {
+	{ KE_KEY,       0x01, {KEY_HELP} },          /* Fn+F1 */
+	{ KE_KEY,       0x06, {KEY_DISPLAYTOGGLE} }, /* Fn+F4 */
+	{ KE_BLUETOOTH, 0x30 },                      /* Fn+F10 */
+	{ KE_KEY,       0x31, {KEY_MAIL} },          /* mail button */
+	{ KE_KEY,       0x36, {KEY_WWW} },           /* www button */
+	{ KE_WIFI,      0x78 },                      /* satelite dish button */
+	{ KE_END,       0 }
+};
+
 static struct key_entry keymap_fujitsu_n3510[] __initdata = {
 	{ KE_KEY, 0x11, {KEY_PROG1} },
 	{ KE_KEY, 0x12, {KEY_PROG2} },
@@ -618,6 +628,15 @@ static struct dmi_system_id dmi_ids[] __initdata = {
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Fujitsu-Siemens Amilo Pro Edition V3505",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro Edition V3505"),
+		},
+		.driver_data = keymap_fs_amilo_pro_v3505
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Fujitsu-Siemens Amilo M7400",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),


--
Best regards

Rémi Hérilier

