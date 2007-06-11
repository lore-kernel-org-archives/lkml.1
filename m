Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbXFKPKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbXFKPKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXFKPJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:09:55 -0400
Received: from smtp3.nextra.sk ([195.168.1.142]:4416 "EHLO mailhub3.nextra.sk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751472AbXFKPJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:09:54 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: daniel.ritz@gmx.ch
Subject: [PATCH] Fix broken ifdefs in usbtouchscreen
Date: Mon, 11 Jun 2007 17:09:50 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_+WWbGAQsbnfr+4j"
Message-Id: <200706111709.50605.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_+WWbGAQsbnfr+4j
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,
this patch fixes ifdefs in usbtouchscreen that got broken by Kconfig changes, 
resulting in non-working module with empty device table.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

-- 
Ondrej Zary

--Boundary-00=_+WWbGAQsbnfr+4j
Content-Type: text/x-diff;
  charset="us-ascii";
  name="usbtouchscreen-ifdef.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="usbtouchscreen-ifdef.patch"

--- linux-2.6.22-rc4-orig/drivers/input/touchscreen/usbtouchscreen.c	2007-06-05 02:57:25.000000000 +0200
+++ linux-2.6.22-rc4/drivers/input/touchscreen/usbtouchscreen.c	2007-06-11 14:07:40.000000000 +0200
@@ -91,7 +91,7 @@
 };
 
 
-#if defined(CONFIG_USB_TOUCHSCREEN_EGALAX) || defined(CONFIG_USB_TOUCHSCREEN_ETURBO)
+#if defined(CONFIG_TOUCHSCREEN_USB_EGALAX) || defined(CONFIG_TOUCHSCREEN_USB_ETURBO)
 #define MULTI_PACKET
 #endif
 
@@ -113,7 +113,7 @@
 };
 
 static struct usb_device_id usbtouch_devices[] = {
-#ifdef CONFIG_USB_TOUCHSCREEN_EGALAX
+#ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
 	{USB_DEVICE(0x3823, 0x0001), .driver_info = DEVTYPE_EGALAX},
 	{USB_DEVICE(0x3823, 0x0002), .driver_info = DEVTYPE_EGALAX},
 	{USB_DEVICE(0x0123, 0x0001), .driver_info = DEVTYPE_EGALAX},
@@ -123,30 +123,30 @@
 	{USB_DEVICE(0x1234, 0x0002), .driver_info = DEVTYPE_EGALAX},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_PANJIT
+#ifdef CONFIG_TOUCHSCREEN_USB_PANJIT
 	{USB_DEVICE(0x134c, 0x0001), .driver_info = DEVTYPE_PANJIT},
 	{USB_DEVICE(0x134c, 0x0002), .driver_info = DEVTYPE_PANJIT},
 	{USB_DEVICE(0x134c, 0x0003), .driver_info = DEVTYPE_PANJIT},
 	{USB_DEVICE(0x134c, 0x0004), .driver_info = DEVTYPE_PANJIT},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_3M
+#ifdef CONFIG_TOUCHSCREEN_USB_3M
 	{USB_DEVICE(0x0596, 0x0001), .driver_info = DEVTYPE_3M},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_ITM
+#ifdef CONFIG_TOUCHSCREEN_USB_ITM
 	{USB_DEVICE(0x0403, 0xf9e9), .driver_info = DEVTYPE_ITM},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_ETURBO
+#ifdef CONFIG_TOUCHSCREEN_USB_ETURBO
 	{USB_DEVICE(0x1234, 0x5678), .driver_info = DEVTYPE_ETURBO},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_GUNZE
+#ifdef CONFIG_TOUCHSCREEN_USB_GUNZE
 	{USB_DEVICE(0x0637, 0x0001), .driver_info = DEVTYPE_GUNZE},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_DMC_TSC10
+#ifdef CONFIG_TOUCHSCREEN_USB_DMC_TSC10
 	{USB_DEVICE(0x0afa, 0x03e8), .driver_info = DEVTYPE_DMC_TSC10},
 #endif
 
@@ -158,7 +158,7 @@
  * eGalax part
  */
 
-#ifdef CONFIG_USB_TOUCHSCREEN_EGALAX
+#ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
 
 #define EGALAX_PKT_TYPE_MASK		0xFE
 #define EGALAX_PKT_TYPE_REPT		0x80
@@ -197,7 +197,7 @@
 /*****************************************************************************
  * PanJit Part
  */
-#ifdef CONFIG_USB_TOUCHSCREEN_PANJIT
+#ifdef CONFIG_TOUCHSCREEN_USB_PANJIT
 static int panjit_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 {
 	dev->x = ((pkt[2] & 0x0F) << 8) | pkt[1];
@@ -212,7 +212,7 @@
 /*****************************************************************************
  * 3M/Microtouch Part
  */
-#ifdef CONFIG_USB_TOUCHSCREEN_3M
+#ifdef CONFIG_TOUCHSCREEN_USB_3M
 
 #define MTOUCHUSB_ASYNC_REPORT          1
 #define MTOUCHUSB_RESET                 7
@@ -262,7 +262,7 @@
 /*****************************************************************************
  * ITM Part
  */
-#ifdef CONFIG_USB_TOUCHSCREEN_ITM
+#ifdef CONFIG_TOUCHSCREEN_USB_ITM
 static int itm_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 {
 	int touch;
@@ -296,7 +296,7 @@
 /*****************************************************************************
  * eTurboTouch part
  */
-#ifdef CONFIG_USB_TOUCHSCREEN_ETURBO
+#ifdef CONFIG_TOUCHSCREEN_USB_ETURBO
 static int eturbo_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 {
 	unsigned int shift;
@@ -327,7 +327,7 @@
 /*****************************************************************************
  * Gunze part
  */
-#ifdef CONFIG_USB_TOUCHSCREEN_GUNZE
+#ifdef CONFIG_TOUCHSCREEN_USB_GUNZE
 static int gunze_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 {
 	if (!(pkt[0] & 0x80) || ((pkt[1] | pkt[2] | pkt[3]) & 0x80))
@@ -348,7 +348,7 @@
  *   http://www.dmccoltd.com/files/controler/tsc10usb_pi_e.pdf
  *   http://www.dmccoltd.com/files/controler/tsc25_usb_e.pdf
  */
-#ifdef CONFIG_USB_TOUCHSCREEN_DMC_TSC10
+#ifdef CONFIG_TOUCHSCREEN_USB_DMC_TSC10
 
 /* supported data rates. currently using 130 */
 #define TSC10_RATE_POINT	0x50
@@ -419,7 +419,7 @@
  * the different device descriptors
  */
 static struct usbtouch_device_info usbtouch_dev_info[] = {
-#ifdef CONFIG_USB_TOUCHSCREEN_EGALAX
+#ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
 	[DEVTYPE_EGALAX] = {
 		.min_xc		= 0x0,
 		.max_xc		= 0x07ff,
@@ -433,7 +433,7 @@
 	},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_PANJIT
+#ifdef CONFIG_TOUCHSCREEN_USB_PANJIT
 	[DEVTYPE_PANJIT] = {
 		.min_xc		= 0x0,
 		.max_xc		= 0x0fff,
@@ -444,7 +444,7 @@
 	},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_3M
+#ifdef CONFIG_TOUCHSCREEN_USB_3M
 	[DEVTYPE_3M] = {
 		.min_xc		= 0x0,
 		.max_xc		= 0x4000,
@@ -456,7 +456,7 @@
 	},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_ITM
+#ifdef CONFIG_TOUCHSCREEN_USB_ITM
 	[DEVTYPE_ITM] = {
 		.min_xc		= 0x0,
 		.max_xc		= 0x0fff,
@@ -468,7 +468,7 @@
 	},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_ETURBO
+#ifdef CONFIG_TOUCHSCREEN_USB_ETURBO
 	[DEVTYPE_ETURBO] = {
 		.min_xc		= 0x0,
 		.max_xc		= 0x07ff,
@@ -482,7 +482,7 @@
 	},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_GUNZE
+#ifdef CONFIG_TOUCHSCREEN_USB_GUNZE
 	[DEVTYPE_GUNZE] = {
 		.min_xc		= 0x0,
 		.max_xc		= 0x0fff,
@@ -493,7 +493,7 @@
 	},
 #endif
 
-#ifdef CONFIG_USB_TOUCHSCREEN_DMC_TSC10
+#ifdef CONFIG_TOUCHSCREEN_USB_DMC_TSC10
 	[DEVTYPE_DMC_TSC10] = {
 		.min_xc		= 0x0,
 		.max_xc		= 0x03ff,

--Boundary-00=_+WWbGAQsbnfr+4j--
