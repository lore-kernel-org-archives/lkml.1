Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZBAKxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZBAKxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZBAKxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:53:40 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:19381 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZBAKxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:53:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=SdaDq1T8FZZcrMdCGCEeheHOIX4y50PDz9xtXBoq0KiLhI94ls58Ow5xrSAQJ/9w4p
         n5V1Q/i7aPFswgYNUKYejNgDwtPclyWILswelLrB0caXZJ1D5A2d91YZSC9P8kxwfdRl
         3nySwuzTKX9UfAJ62cvSpEcrJwdSqe+bBLUMY=
Message-ID: <49857F23.3090208@gmail.com>
Date: Sun, 01 Feb 2009 18:53:23 +0800
From: Dave Young <hidave.darkstar@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081010)
MIME-Version: 1.0
To: wgreathouse@smva.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] usb-serial : fix the nousb oops
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In case with "nousb" booting, serial drivers will trigger kernel oops.

Here add usb_disabled() check in usb_serial_init and usb_serial_register

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
drivers/usb/serial/usb-serial.c |    6 ++++++
1 file changed, 6 insertions(+)

diff -uprN a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c	2009-02-01 13:11:11.000000000 +0800
+++ b/drivers/usb/serial/usb-serial.c	2009-02-01 13:24:32.000000000 +0800
@@ -1113,6 +1113,9 @@ static int __init usb_serial_init(void)
 	int i;
 	int result;
 
+	if (usb_disabled())
+		return -ENODEV;
+
 	usb_serial_tty_driver = alloc_tty_driver(SERIAL_TTY_MINORS);
 	if (!usb_serial_tty_driver)
 		return -ENOMEM;
@@ -1230,6 +1233,9 @@ int usb_serial_register(struct usb_seria
 	/* must be called with BKL held */
 	int retval;
 
+	if (usb_disabled())
+		return -ENODEV;
+
 	fixup_generic(driver);
 
 	if (!driver->description)
