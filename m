Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbYBFQmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbYBFQmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYBFQmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:42:42 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:47758 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbYBFQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:x-mailer:reply-to:x-priority:message-id:to:subject:mime-version:content-type:content-transfer-encoding:from;
        b=xxxEYtz2Qx/PN2xjkFm5NHZFkuuwsu0Tea/3VqLjLpsSdhQXItkcv8P38EtPVgfyBHOE3mBO8zD9+HyL7CXuuw9EbzuIa3z4X8n6agDnTRAlJJLUwV8oq47ABesvoBg0DUapELEhyv7ZoikwqN+AKI4YubyMpJeM3Ei/uydJUYg=
Date: Wed, 6 Feb 2008 18:42:41 +0200
X-Mailer: The Bat! (v3.71.04) Home
Reply-To: Dmitry Shapin <shapin@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <405295915.20080206184241@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] cypress_m8: added UPS Powercom (0d9f:0002)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Dmitry Shapin <shapin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support for UPS Powercom USB interface (0d9f:0002) in chip CY7C63723.
In my case, this Powercom BNT800AP.

Signed-off-by: Dmitry Shapin <shapin@gmail.com>

--- linux.orig/drivers/usb/serial/cypress_m8.h  2008-01-25 00:58:37.000000000 +0200
+++ linux/drivers/usb/serial/cypress_m8.h       2008-02-06 17:07:08.000000000 +0200
@@ -19,6 +19,10 @@
 #define VENDOR_ID_CYPRESS               0x04b4
 #define PRODUCT_ID_CYPHIDCOM            0x5500
 
+/* Powercom UPS, chip CY7C63723 */
+#define VENDOR_ID_POWERCOM              0x0d9f
+#define PRODUCT_ID_UPS                  0x0002
+
 /* Nokia CA-42 USB to serial cable */
 #define VENDOR_ID_DAZZLE               0x07d0
 #define PRODUCT_ID_CA42                        0x4101
--- linux.orig/drivers/usb/serial/cypress_m8.c  2008-02-06 13:44:45.000000000 +0200
+++ linux/drivers/usb/serial/cypress_m8.c       2008-02-06 17:47:25.000000000 +0200
@@ -94,6 +94,7 @@
 
 static struct usb_device_id id_table_cyphidcomrs232 [] = {
        { USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
+       { USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
        { }                                             /* Terminating entry */
 };
 
@@ -106,6 +107,7 @@
        { USB_DEVICE(VENDOR_ID_DELORME, PRODUCT_ID_EARTHMATEUSB) },
        { USB_DEVICE(VENDOR_ID_DELORME, PRODUCT_ID_EARTHMATEUSB_LT20) },
        { USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
+       { USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
        { USB_DEVICE(VENDOR_ID_DAZZLE, PRODUCT_ID_CA42) },
        { }                                             /* Terminating entry */
 };

