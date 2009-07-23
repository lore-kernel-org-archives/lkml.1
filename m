Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZGWQUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZGWQUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbZGWQUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:20:19 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52668 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbZGWQUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FHNSDtMuN1qGypE9TAah3j/gaDCYmcLi8zQ05mufzebq+byR0ibLrblemew9bcTJV0
         ugRE0oh0Xxj441092H7wI/+93fZafqlo35vwN3WVx5i/6yLW4dKLbFX+SLDLYbdvUzHh
         n+qgUPRbtmuYA4Lfh327xCQBJLuxzHeFBAEgs=
Subject: [PATCH] USB: option.c to support Alcatel X060S/X200 broadband
 modems
From: Javier Martin <jmartinj@iname.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 23 Jul 2009 18:20:09 +0200
Message-Id: <1248366009.24563.0.camel@eee>
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




