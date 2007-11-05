Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXKEHVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXKEHVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 02:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbXKEHVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 02:21:12 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:42728 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXKEHVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 02:21:11 -0500
Subject: [PATCH 1/2 -mm] sis FB driver: *_ioctl32_conversion functions do
	not exist in recent kernels
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, akpm@linux-foundation.org, gregkh@suse.de
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Mon, 05 Nov 2007 16:21:10 +0900
Message-Id: <1194247270.13121.32.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dead code while at it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.24-rc1-git13-orig/drivers/usb/misc/sisusbvga/sisusb.c linux-2.6.24-rc1-git13/drivers/usb/misc/sisusbvga/sisusb.c
--- linux-2.6.24-rc1-git13-orig/drivers/usb/misc/sisusbvga/sisusb.c	2007-11-05 10:22:15.000000000 +0900
+++ linux-2.6.24-rc1-git13/drivers/usb/misc/sisusbvga/sisusb.c	2007-11-05 15:25:51.000000000 +0900
@@ -3195,20 +3195,6 @@ static int sisusb_probe(struct usb_inter
 
 	sisusb->present = 1;
 
-#ifdef SISUSB_OLD_CONFIG_COMPAT
-	{
-	int ret;
-	/* Our ioctls are all "32/64bit compatible" */
-	ret =  register_ioctl32_conversion(SISUSB_GET_CONFIG_SIZE, NULL);
-	ret |= register_ioctl32_conversion(SISUSB_GET_CONFIG,      NULL);
-	ret |= register_ioctl32_conversion(SISUSB_COMMAND,         NULL);
-	if (ret)
-		dev_err(&sisusb->sisusb_dev->dev, "Error registering ioctl32 translations\n");
-	else
-		sisusb->ioctl32registered = 1;
-	}
-#endif
-
 	if (dev->speed == USB_SPEED_HIGH) {
 		int initscreen = 1;
 #ifdef INCL_SISUSB_CON
@@ -3271,19 +3257,6 @@ static void sisusb_disconnect(struct usb
 
 	usb_set_intfdata(intf, NULL);
 
-#ifdef SISUSB_OLD_CONFIG_COMPAT
-	if (sisusb->ioctl32registered) {
-		int ret;
-		sisusb->ioctl32registered = 0;
-		ret =  unregister_ioctl32_conversion(SISUSB_GET_CONFIG_SIZE);
-		ret |= unregister_ioctl32_conversion(SISUSB_GET_CONFIG);
-		ret |= unregister_ioctl32_conversion(SISUSB_COMMAND);
-		if (ret) {
-			dev_err(&sisusb->sisusb_dev->dev, "Error unregistering ioctl32 translations\n");
-		}
-	}
-#endif
-
 	sisusb->present = 0;
 	sisusb->ready = 0;
 
diff -urNp linux-2.6.24-rc1-git13-orig/drivers/usb/misc/sisusbvga/sisusb.h linux-2.6.24-rc1-git13/drivers/usb/misc/sisusbvga/sisusb.h
--- linux-2.6.24-rc1-git13-orig/drivers/usb/misc/sisusbvga/sisusb.h	2007-11-05 10:22:15.000000000 +0900
+++ linux-2.6.24-rc1-git13/drivers/usb/misc/sisusbvga/sisusb.h	2007-11-05 15:20:23.000000000 +0900
@@ -120,9 +120,6 @@ struct sisusb_usb_data {
 	int isopen;		/* !=0 if open */
 	int present;		/* !=0 if device is present on the bus */
 	int ready;		/* !=0 if device is ready for userland */
-#ifdef SISUSB_OLD_CONFIG_COMPAT
-	int ioctl32registered;
-#endif
 	int numobufs;		/* number of obufs = number of out urbs */
 	char *obuf[NUMOBUFS], *ibuf;	/* transfer buffers */
 	int obufsize, ibufsize;


