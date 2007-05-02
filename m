Return-Path: <linux-kernel-owner+w=401wt.eu-S2993307AbXEBPEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993307AbXEBPEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993306AbXEBPEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:04:25 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37348 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993307AbXEBPEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:04:24 -0400
Date: Wed, 2 May 2007 17:03:05 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] [RFC] Added USB_DEVICE_INTERFACE_PROTOCOL
Message-ID: <Pine.LNX.4.64.0705021702040.13550@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The USB_DEVICE_INTERFACE_PROTOCOL will allow to match one interface
protocol of vendor specific device.
This macro is used in patch adding support for xbox360 to xpad.c

Signed-off-by: Jan Kratochvil <honza@jikos.cz>
---
 include/linux/usb.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/usb.h b/include/linux/usb.h
index cfbd2bb..84e2330 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -729,6 +729,21 @@ static inline int usb_endpoint_is_isoc_out(const struct usb_endpoint_descriptor
 	.bcdDevice_lo = (lo), .bcdDevice_hi = (hi)
 
 /**
+ * USB_DEVICE_INTERFACE_PROTOCOL - macro used to describe a usb 
+ *		device with a specific interface protocol
+ * @vend: the 16 bit USB Vendor ID
+ * @prod: the 16 bit USB Product ID
+ * @pr: bInterfaceProtocol value
+ *
+ * This macro is used to create a struct usb_device_id that matches a
+ * specific interface protocol of devices.
+ */
+#define USB_DEVICE_INTERFACE_PROTOCOL(vend,prod,pr) \
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_PROTOCOL, \
+	.idVendor = (vend), \
+	.idProduct = (prod), \
+	.bInterfaceProtocol = (pr)
+/**
  * USB_DEVICE_INFO - macro used to describe a class of usb devices
  * @cl: bDeviceClass value
  * @sc: bDeviceSubClass value
-- 
1.5.0.6


