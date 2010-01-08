Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082Ab0AHIBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0AHIBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015Ab0AHIBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:01:35 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54980 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab0AHIBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:01:34 -0500
Message-Id: <20100108075920.554998528@vergenet.net>
User-Agent: quilt/0.48-1
Date: Fri, 08 Jan 2010 18:57:49 +1100
From: horms@vergenet.net
Subject: [patch 1/6] otus: dont mix declarations and code
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Peter Huewe <PeterHuewe@gmx.de>
References: <20100108075748.059645106@vergenet.net>
Content-Disposition: inline; filename=otus-c99.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ gcc (Debian 4.4.2-8) 4.4.2
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ make
...
drivers/staging/otus/ioctl.c: In function 'usbdrv_wpa_ioctl':
drivers/staging/otus/ioctl.c:2253: warning: ISO C90 forbids mixed declarations and code
...

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/drivers/staging/otus/ioctl.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/ioctl.c	2010-01-08 16:52:19.000000000 +1100
+++ linux-2.6/drivers/staging/otus/ioctl.c	2010-01-08 17:07:55.000000000 +1100
@@ -2227,7 +2227,8 @@ int usbdrv_wpa_ioctl(struct net_device *
 	case ZD_CMD_SCAN_REQ:
 		printk(KERN_ERR "usbdrv_wpa_ioctl: ZD_CMD_SCAN_REQ\n");
 		break;
-	case ZD_CMD_SET_GENERIC_ELEMENT:
+	case ZD_CMD_SET_GENERIC_ELEMENT: {
+		u8_t len, *wpaie;
 		printk(KERN_ERR "usbdrv_wpa_ioctl:"
 					" ZD_CMD_SET_GENERIC_ELEMENT\n");
 
@@ -2250,8 +2251,8 @@ int usbdrv_wpa_ioctl(struct net_device *
 		/* zfiWlanSetWpaIe(dev, zdparm->u.generic_elem.data,
 		* zdparm->u.generic_elem.len);
 		*/
-		u8_t len = zdparm->u.generic_elem.len;
-		u8_t *wpaie = (u8_t *)zdparm->u.generic_elem.data;
+		len = zdparm->u.generic_elem.len;
+		wpaie = zdparm->u.generic_elem.data;
 
 		printk(KERN_ERR "wd->ap.wpaLen : % d\n", len);
 
@@ -2273,6 +2274,7 @@ int usbdrv_wpa_ioctl(struct net_device *
 		* #endif
 		*/
 		break;
+	}
 
 	/* #ifdef ZM_HOSTAPD_SUPPORT */
 	case ZD_CMD_GET_TSC:

