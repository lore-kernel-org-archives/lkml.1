Return-Path: <linux-kernel-owner+w=401wt.eu-S1765196AbYD1GCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765196AbYD1GCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763228AbYD1GA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:00:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43551 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765525AbYD1GA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:00:26 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] usb input endianness annotations and fixes
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, dmitry.torokhov@gmail.com
Message-Id: <E1JqMPa-0004qN-0C@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 28 Apr 2008 07:00:26 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/input/joystick/iforce/iforce-usb.c |    2 +-
 drivers/input/tablet/gtco.c                |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/input/joystick/iforce/iforce-usb.c b/drivers/input/joystick/iforce/iforce-usb.c
index 1457b73..7fb3cf8 100644
--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -159,7 +159,7 @@ static int iforce_usb_probe(struct usb_interface *intf,
 
 	iforce->cr.bRequestType = USB_TYPE_VENDOR | USB_DIR_IN | USB_RECIP_INTERFACE;
 	iforce->cr.wIndex = 0;
-	iforce->cr.wLength = 16;
+	iforce->cr.wLength = cpu_to_le16(16);
 
 	usb_fill_int_urb(iforce->irq, dev, usb_rcvintpipe(dev, epirq->bEndpointAddress),
 			iforce->data, 16, iforce_usb_irq, iforce, epirq->bInterval);
diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index d2c6da2..f66ca21 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -897,7 +897,7 @@ static int gtco_probe(struct usb_interface *usbinterface,
 	dbg("Extra descriptor success: type:%d  len:%d",
 	    hid_desc->bDescriptorType,  hid_desc->wDescriptorLength);
 
-	report = kzalloc(hid_desc->wDescriptorLength, GFP_KERNEL);
+	report = kzalloc(le16_to_cpu(hid_desc->wDescriptorLength), GFP_KERNEL);
 	if (!report) {
 		err("No more memory for report");
 		error = -ENOMEM;
@@ -913,16 +913,16 @@ static int gtco_probe(struct usb_interface *usbinterface,
 					 REPORT_DEVICE_TYPE << 8,
 					 0, /* interface */
 					 report,
-					 hid_desc->wDescriptorLength,
+					 le16_to_cpu(hid_desc->wDescriptorLength),
 					 5000); /* 5 secs */
 
-		if (result == hid_desc->wDescriptorLength)
+		if (result == le16_to_cpu(hid_desc->wDescriptorLength))
 			break;
 	}
 
 	/* If we didn't get the report, fail */
 	dbg("usb_control_msg result: :%d", result);
-	if (result != hid_desc->wDescriptorLength) {
+	if (result != le16_to_cpu(hid_desc->wDescriptorLength)) {
 		err("Failed to get HID Report Descriptor of size: %d",
 		    hid_desc->wDescriptorLength);
 		error = -EIO;
-- 
1.5.3.GIT

