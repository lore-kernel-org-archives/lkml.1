Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbXGXA2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbXGXA2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 20:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXGXA2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 20:28:43 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:37953 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbXGXA2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 20:28:42 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] usbhid: add ASUS LCM to the blacklist
Date: Tue, 24 Jul 2007 02:28:39 +0200
User-Agent: KMail/1.9.7
Cc: chunkeey@web.de, linux-usb-devel@lists.sourceforge.net,
       linux-input@atrey.karlin.mff.cuni.cz
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_3eUpGAAHgsIAcPs"
Message-Id: <200707240228.39421.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+DAyQHlQL5C8heS6w+9q9cZ/lfXRoq6uV45s9f
	Chemt9zaYi783MvCHQXp1GzVvnTeP+Pqc4dTVIlfQ6AGhgruBb
	Rz55S4gA4=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_3eUpGAAHgsIAcPs
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Some of ASUS' notebooks (e.g G Series) include a tiny oled display, which is 
attached to an internal USB bus. Unfortunatly the device reports a wrong
DeviceDescriptor and is therefore identified as a HID device...

Signed-off-by: Christian Lamparter <chunkeey@web.de>
CC: linux-input@atrey.karlin.mff.cuni.cz
CC: linux-usb-devel@lists.sourceforge.net

---
(keep the cc!)
for those who are interested in the userspace display driver:
https://launchpad.net/asusoled  


--Boundary-00=_3eUpGAAHgsIAcPs
Content-Type: text/x-diff;
  charset="utf-8";
  name="asus-lcm-hid-blacklist.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="asus-lcm-hid-blacklist.diff"

diff -up drivers/hid/usbhid/hid-quirks.c.orig drivers/hid/usbhid/hid-quirks.c
--- a/drivers/hid/usbhid/hid-quirks.c.orig	2007-07-24 02:23:36.000000000 +0200
+++ b/drivers/hid/usbhid/hid-quirks.c	2007-07-24 02:25:26.000000000 +0200
@@ -63,6 +63,9 @@
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_IR		0x8240
 
+#define USB_VENDOR_ID_ASUS		0x0b05
+#define USB_DEVICE_ID_ASUS_LCM		0x1726
+
 #define USB_VENDOR_ID_ATEN		0x0557
 #define USB_DEVICE_ID_ATEN_UC100KM	0x2004
 #define USB_DEVICE_ID_ATEN_CS124U	0x2202
@@ -452,6 +455,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1, HID_QUIRK_SWAPPED_MIN_MAX },
 	{ USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2, HID_QUIRK_SWAPPED_MIN_MAX },
 
+	{ USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_LCM, HID_QUIRK_IGNORE},
+
 	{ 0, 0 }
 };
 

--Boundary-00=_3eUpGAAHgsIAcPs--
