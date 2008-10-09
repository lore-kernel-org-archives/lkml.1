Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYJIUGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYJIUGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 16:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYJIUGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 16:06:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41906 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbYJIUGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:06:07 -0400
Date: Thu, 9 Oct 2008 17:05:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix Numlock led on two keyboards (Dell SK8115 and Bright)
Message-ID: <20081009170544.4e770dbb@pedra.chehab.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing two new USB keyboards, it was noticed that the NUM LOCK
led were wrong after booting. The led was ON, but the device was working
without numlock.

Adding those two devices to HID quirks table fixed the issue.

The keyboards are:
DELL SK8115 (USB ID 413c:2105); and
Bright keyboard (USB ID 1241:1503).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index b15f882..7204c56 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -101,6 +101,9 @@
 #define USB_VENDOR_ID_BERKSHIRE		0x0c98
 #define USB_DEVICE_ID_BERKSHIRE_PCWD	0x1140
 
+#define USB_VENDOR_ID_BRIGHT		0x1241
+#define USB_DEVICE_ID_BRIGHT_KBD	0x1503
+
 #define USB_VENDOR_ID_CHERRY		0x046a
 #define USB_DEVICE_ID_CHERRY_CYMOTION	0x0023
 
@@ -128,6 +131,7 @@
 
 #define USB_VENDOR_ID_DELL		0x413c
 #define USB_DEVICE_ID_DELL_W7658	0x2005
+#define USB_DEVICE_ID_DELL_SK8115	0x2105
 
 #define USB_VENDOR_ID_DELORME		0x1163
 #define USB_DEVICE_ID_DELORME_EARTHMATE 0x0100
@@ -663,7 +667,9 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
 
+	{ USB_VENDOR_ID_BRIGHT, USB_DEVICE_ID_BRIGHT_KBD, HID_QUIRK_RESET_LEDS },
 	{ USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658, HID_QUIRK_RESET_LEDS },
+	{ USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_SK8115, HID_QUIRK_RESET_LEDS },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KBD, HID_QUIRK_RESET_LEDS },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_HARMONY, HID_QUIRK_IGNORE },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_HARMONY_2, HID_QUIRK_IGNORE },
