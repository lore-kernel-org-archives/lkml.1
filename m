Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZGWCJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZGWCJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 22:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZGWCJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 22:09:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:57315 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZGWCJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 22:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=kF69zqlp6l6/P4l8YZDdC9kCMl+QBE3vwsseVkaEJBO+MXyk3guw4yJ4VbJAMVkiQk
         98j5Zu6xZW2xAsMlodyJ5LCR9VkXfs0FGGLYYkv1BkbR0oox0oR6uP3tuGkckV8pRNDZ
         IIi0R0j+u7oyzRiDgcePqxZFncbWQttf8wFy4=
Subject: [PATCH] USB: option.c to support Alcatel X060S/X200 broadband
 modems
From: Javier Martin <jmartinj@iname.com>
To: smurf@smurf.noris.de, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 23 Jul 2009 04:03:43 +0200
Message-Id: <1248314623.12639.28.camel@eee>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support for the Alcatel X060S/X200 broadband modems to the option driver. The device starts in cd-rom emulation mode (1bbb:f000) and requires the use of the usb_modeswitch tool to switch it to modem mode (1bbb:0000).

Signed-off-by: Javier Martin <jmartinj@iname.com>
---
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 98262dd..8946115 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -322,6 +322,11 @@ static int  option_resume(struct usb_serial *serial);
 #define ALINK_VENDOR_ID				0x1e0e
 #define ALINK_PRODUCT_3GU			0x9200
 
+/* ALCATEL PRODUCTS */
+#define ALCATEL_VENDOR_ID			0x1bbb
+#define ALCATEL_PRODUCT_X060S			0x0000
+
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -547,6 +552,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_HSDPA_MINICARD ) }, /* Toshiba 3G HSDPA == Novatel Expedite EU870D MiniCard */
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);



