Return-Path: <linux-kernel-owner+w=401wt.eu-S1763131AbYF0ULT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763131AbYF0ULT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759561AbYF0ULF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:11:05 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:40593 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbYF0ULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:11:04 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] HID: fix quirk handling in usbmouse/kbd
Date: Fri, 27 Jun 2008 22:09:25 +0200
Message-Id: <1214597365-21719-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When usbmouse/kbd is set to build, USB_HID is never defined due to
the USB_HID!=y Kconfig rule. Test CONFIG_USB_HID_MODULE in both
drivers instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/usbhid/usbkbd.c   |    2 +-
 drivers/hid/usbhid/usbmouse.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/usbhid/usbkbd.c b/drivers/hid/usbhid/usbkbd.c
index 3cd46d2..695929c 100644
--- a/drivers/hid/usbhid/usbkbd.c
+++ b/drivers/hid/usbhid/usbkbd.c
@@ -233,7 +233,7 @@ static int usb_kbd_probe(struct usb_interface *iface,
 	if (!usb_endpoint_is_int_in(endpoint))
 		return -ENODEV;
 
-#ifdef CONFIG_USB_HID
+#ifdef CONFIG_USB_HID_MODULE
 	if (usbhid_lookup_quirk(le16_to_cpu(dev->descriptor.idVendor),
 				le16_to_cpu(dev->descriptor.idProduct))
 			& HID_QUIRK_IGNORE) {
diff --git a/drivers/hid/usbhid/usbmouse.c b/drivers/hid/usbhid/usbmouse.c
index 703e9d0..f74740f 100644
--- a/drivers/hid/usbhid/usbmouse.c
+++ b/drivers/hid/usbhid/usbmouse.c
@@ -129,7 +129,7 @@ static int usb_mouse_probe(struct usb_interface *intf, const struct usb_device_i
 	if (!usb_endpoint_is_int_in(endpoint))
 		return -ENODEV;
 
-#ifdef CONFIG_USB_HID
+#ifdef CONFIG_USB_HID_MODULE
 	if (usbhid_lookup_quirk(le16_to_cpu(dev->descriptor.idVendor),
 				le16_to_cpu(dev->descriptor.idProduct))
 			& (HID_QUIRK_IGNORE|HID_QUIRK_IGNORE_MOUSE)) {
-- 
1.5.6

