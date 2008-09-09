Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYIIMHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYIIMHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYIIMHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:07:13 -0400
Received: from mailsender00.ifrance.com ([82.196.5.120]:39432 "EHLO
	mailsender00.ifrance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYIIMHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:07:12 -0400
X-Greylist: delayed 1708 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2008 08:07:12 EDT
From: gcpatch@gmail.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.26.5] USB: ftdi_sio: add support for Domintell devices
Message-Id: <20080909113355.521F71405D@smtp.ifrance.com>
Date: Tue,  9 Sep 2008 13:33:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for Domintell devices (FTDI FT232BM based) : DGQG and DUSB01 module.
PIDs were missing.

Signed-off-by: Gaetan Carlier <gcpatch@gmail.com>
---

diff -uNr linux.vanilla/drivers/usb/serial/ftdi_sio.c linux/drivers/usb/serial/ftdi_sio.c
--- linux.vanilla/drivers/usb/serial/ftdi_sio.c	2008-09-08 19:40:20.000000000 +0200
+++ linux/drivers/usb/serial/ftdi_sio.c	2008-09-09 11:26:33.000000000 +0200
@@ -643,6 +643,8 @@
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(FTDI_VID, FTDI_REU_TINY_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DGQG_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff -uNr linux.vanilla/drivers/usb/serial/ftdi_sio.h linux/drivers/usb/serial/ftdi_sio.h
--- linux.vanilla/drivers/usb/serial/ftdi_sio.h	2008-09-08 19:40:20.000000000 +0200
+++ linux/drivers/usb/serial/ftdi_sio.h	2008-09-09 11:27:52.000000000 +0200
@@ -837,6 +837,10 @@
 /* Rig Expert Ukraine devices */
 #define FTDI_REU_TINY_PID		0xED22	/* RigExpert Tiny */
 
+/* Domintell products  http://www.domintell.com */
+#define FTDI_DOMINTELL_DGQG_PID	0xEF50	/* Master */
+#define FTDI_DOMINTELL_DUSB_PID	0xEF51	/* DUSB01 module */
+
 /* Commands */
 #define FTDI_SIO_RESET 		0 /* Reset the port */
 #define FTDI_SIO_MODEM_CTRL 	1 /* Set the modem control register */

