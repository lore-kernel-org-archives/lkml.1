Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbXKERRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbXKERRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbXKERIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:22 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59545 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757699AbXKERIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:21 -0500
Date: Mon, 5 Nov 2007 18:07:57 +0100
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] usb/serial/oti6858.c: cleanups
Message-ID: <20071105170757.GY12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch containsthe following cleanups:
- make the needlessly global send_data() static
- an author without anemail address is OK, not a FIXME
- directly put the IDs into the id_table
- remove the now-empty oti6858.h
- kill the pointless driver version number

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/usb/serial/oti6858.c |   11 ++++-------
 drivers/usb/serial/oti6858.h |   15 ---------------
 2 files changed, 4 insertions(+), 22 deletions(-)

5474a38a5cef955b81b342892c2ba5730545cdba 
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index eea226a..8eff5e0 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -2,7 +2,7 @@
  * Ours Technology Inc. OTi-6858 USB to serial adapter driver.
  *
  * Copyleft  (C) 2007 Kees Lemmens (adapted for kernel 2.6.20)
- * Copyright (C) 2006 Tomasz Michal Lukaszewski (FIXME: add e-mail)
+ * Copyright (C) 2006 Tomasz Michal Lukaszewski
  * Copyright (C) 2001-2004 Greg Kroah-Hartman (greg@kroah.com)
  * Copyright (C) 2003 IBM Corp.
  *
@@ -50,15 +50,13 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <asm/uaccess.h>
-#include "oti6858.h"
 
 #define OTI6858_DESCRIPTION \
 	"Ours Technology Inc. OTi-6858 USB to serial adapter driver"
-#define OTI6858_AUTHOR "Tomasz Michal Lukaszewski <FIXME@FIXME>"
-#define OTI6858_VERSION "0.1"
+#define OTI6858_AUTHOR "Tomasz Michal Lukaszewski"
 
 static struct usb_device_id id_table [] = {
-	{ USB_DEVICE(OTI6858_VENDOR_ID, OTI6858_PRODUCT_ID) },
+	{ USB_DEVICE(0x0ea0, 0x6858) },
 	{ }
 };
 
@@ -298,7 +296,7 @@ static void setup_line(struct work_struct *work)
 	}
 }
 
-void send_data(struct work_struct *work)
+static void send_data(struct work_struct *work)
 {
 	struct oti6858_private *priv = container_of(work, struct oti6858_private, delayed_write_work.work);
 	struct usb_serial_port *port = priv->port;
@@ -1317,7 +1315,6 @@ module_exit(oti6858_exit);
 
 MODULE_DESCRIPTION(OTI6858_DESCRIPTION);
 MODULE_AUTHOR(OTI6858_AUTHOR);
-MODULE_VERSION(OTI6858_VERSION);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);
diff --git a/drivers/usb/serial/oti6858.h b/drivers/usb/serial/oti6858.h
deleted file mode 100644
index 704ac3a..0000000
--- a/drivers/usb/serial/oti6858.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Ours Technology Inc. OTi-6858 USB to serial adapter driver.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#ifndef __LINUX_USB_SERIAL_OTI6858_H
-#define __LINUX_USB_SERIAL_OTI6858_H
-
-#define OTI6858_VENDOR_ID	0x0ea0
-#define OTI6858_PRODUCT_ID	0x6858
-
-#endif

