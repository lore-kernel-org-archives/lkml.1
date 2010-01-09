Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063Ab0AIXSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab0AIXSu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509Ab0AIXSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:18:49 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:60119 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0AIXSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:18:46 -0500
Message-ID: <4B490ECA.6040108@freemail.hu>
Date: Sun, 10 Jan 2010 00:18:34 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH 2/3] staging: make USB device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32711; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct usb_device_id is constant in <linux/usb.h>
so it is worth to make the initialization data also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y = {
	  .x = E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] = ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
--- a/drivers/staging/serqt_usb2/serqt_usb2.c 2010-01-07 19:08:46.000000000 +0100
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c 2010-01-08 09:53:37.000000000 +0100
@@ -126,7 +126,7 @@ static int debug;
 #define MODEM_CTRL          0x40
 #define RS232_MODE          0x00

-static struct usb_device_id serqt_id_table[] = {
+static const struct usb_device_id serqt_id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_SSU100)},
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_SSU200)},
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_DSU100)},
diff -u -p a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
--- a/drivers/staging/line6/driver.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/staging/line6/driver.c 2010-01-08 09:56:21.000000000 +0100
@@ -33,7 +33,7 @@


 /* table of devices that work with this driver */
-static struct usb_device_id line6_id_table[] = {
+static const struct usb_device_id line6_id_table[] = {
 	{ USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXT) },
 	{ USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXTLIVE) },
 	{ USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXTPRO) },
diff -u -p a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
--- a/drivers/staging/winbond/wbusb.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/winbond/wbusb.c 2010-01-08 09:58:45.000000000 +0100
@@ -23,7 +23,7 @@ MODULE_DESCRIPTION("IS89C35 802.11bg WLA
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1");

-static struct usb_device_id wb35_table[] __devinitdata = {
+static const struct usb_device_id wb35_table[] __devinitconst = {
 	{ USB_DEVICE(0x0416, 0x0035) },
 	{ USB_DEVICE(0x18E8, 0x6201) },
 	{ USB_DEVICE(0x18E8, 0x6206) },
diff -u -p a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
--- a/drivers/staging/rtl8192su/r8192U_core.c 2010-01-07 19:08:46.000000000 +0100
+++ b/drivers/staging/rtl8192su/r8192U_core.c 2010-01-08 10:01:12.000000000 +0100
@@ -110,7 +110,7 @@ u32 rt_global_debug_component = \
 #define TOTAL_CAM_ENTRY 32
 #define CAM_CONTENT_COUNT 8

-static struct usb_device_id rtl8192_usb_id_tbl[] = {
+static const struct usb_device_id rtl8192_usb_id_tbl[] = {
 	/* Realtek */
 	{USB_DEVICE(0x0bda, 0x8192)},
 	{USB_DEVICE(0x0bda, 0x8709)},
diff -u -p a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
--- a/drivers/staging/comedi/drivers/dt9812.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/comedi/drivers/dt9812.c 2010-01-08 10:10:15.000000000 +0100
@@ -264,7 +264,7 @@ struct dt9812_usb_cmd {

 static DECLARE_MUTEX(dt9812_mutex);

-static struct usb_device_id dt9812_table[] = {
+static const struct usb_device_id dt9812_table[] = {
 	{USB_DEVICE(0x0867, 0x9812)},
 	{}			/* Terminating entry */
 };
diff -u -p a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
--- a/drivers/staging/comedi/drivers/usbduxfast.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/staging/comedi/drivers/usbduxfast.c 2010-01-08 10:10:57.000000000 +0100
@@ -1769,7 +1769,7 @@ static struct comedi_driver driver_usbdu
 /*
  * Table with the USB-devices: just now only testing IDs
  */
-static struct usb_device_id usbduxfastsub_table[] = {
+static const struct usb_device_id usbduxfastsub_table[] = {
 	/* { USB_DEVICE(0x4b4, 0x8613) }, testing */
 	{USB_DEVICE(0x13d8, 0x0010)},	/* real ID */
 	{USB_DEVICE(0x13d8, 0x0011)},	/* real ID */
diff -u -p a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
--- a/drivers/staging/comedi/drivers/usbdux.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/staging/comedi/drivers/usbdux.c 2010-01-08 10:13:48.000000000 +0100
@@ -2833,7 +2833,7 @@ static struct comedi_driver driver_usbdu
 };

 /* Table with the USB-devices: just now only testing IDs */
-static struct usb_device_id usbduxsub_table[] = {
+static const struct usb_device_id usbduxsub_table[] = {
 	{USB_DEVICE(0x13d8, 0x0001)},
 	{USB_DEVICE(0x13d8, 0x0002)},
 	{}			/* Terminating entry */
diff -u -p a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
--- a/drivers/staging/comedi/drivers/vmk80xx.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/staging/comedi/drivers/vmk80xx.c 2010-01-08 10:14:14.000000000 +0100
@@ -75,7 +75,7 @@ enum {
 	DEVICE_VMK8061
 };

-static struct usb_device_id vmk80xx_id_table[] = {
+static const struct usb_device_id vmk80xx_id_table[] = {
 	{USB_DEVICE(0x10cf, 0x5500), .driver_info = DEVICE_VMK8055},
 	{USB_DEVICE(0x10cf, 0x5501), .driver_info = DEVICE_VMK8055},
 	{USB_DEVICE(0x10cf, 0x5502), .driver_info = DEVICE_VMK8055},
diff -u -p a/drivers/staging/mimio/mimio.c b/drivers/staging/mimio/mimio.c
--- a/drivers/staging/mimio/mimio.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/mimio/mimio.c 2010-01-08 10:33:06.000000000 +0100
@@ -145,7 +145,7 @@ static void mimio_rx_handler(struct mimi
 static int mimio_tx(struct mimio *, const char *, int);

 static char mimio_name[] = "VirtualInk mimio-Xi";
-static struct usb_device_id mimio_table [] = {
+static const struct usb_device_id mimio_table[] = {
 	{ USB_DEVICE(MIMIO_VENDOR_ID, MIMIO_PRODUCT_ID) },
 	{ USB_DEVICE(0x0525, 0xa4a0) }, /* gadget zero firmware */
 	{ }
diff -u -p a/drivers/staging/go7007/go7007-usb.c b/drivers/staging/go7007/go7007-usb.c
--- a/drivers/staging/go7007/go7007-usb.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/staging/go7007/go7007-usb.c 2010-01-08 10:39:47.000000000 +0100
@@ -444,7 +444,7 @@ static struct go7007_usb_board board_sen
 	},
 };

-static struct usb_device_id go7007_usb_id_table[] = {
+static const struct usb_device_id go7007_usb_id_table[] = {
 	{
 		.match_flags	= USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION |
 					USB_DEVICE_ID_MATCH_INT_INFO,
diff -u -p a/drivers/staging/go7007/s2250-loader.c b/drivers/staging/go7007/s2250-loader.c
--- a/drivers/staging/go7007/s2250-loader.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/staging/go7007/s2250-loader.c 2010-01-08 10:42:54.000000000 +0100
@@ -148,7 +148,7 @@ static void s2250loader_disconnect(struc
 	unlock_kernel();
 }

-static struct usb_device_id s2250loader_ids[] = {
+static const struct usb_device_id s2250loader_ids[] = {
 	{USB_DEVICE(0x1943, 0xa250)},
 	{}                          /* Terminating entry */
 };
diff -u -p a/drivers/staging/otus/zdusb.c b/drivers/staging/otus/zdusb.c
--- a/drivers/staging/otus/zdusb.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/otus/zdusb.c 2010-01-08 10:47:44.000000000 +0100
@@ -45,7 +45,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 static const char driver_name[] = "Otus";

 /* table of devices that work with this driver */
-static struct usb_device_id zd1221_ids [] = {
+static const struct usb_device_id zd1221_ids[] = {
 	{ USB_DEVICE(VENDOR_ATHR, PRODUCT_AR9170) },
         { USB_DEVICE(VENDOR_DLINK, PRODUCT_DWA160A) },
 	{ USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WNDA3100) },
diff -u -p a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
--- a/drivers/staging/rtl8192u/r8192U_core.c 2010-01-07 19:08:46.000000000 +0100
+++ b/drivers/staging/rtl8192u/r8192U_core.c 2010-01-08 10:51:26.000000000 +0100
@@ -104,7 +104,7 @@ u32 rt_global_debug_component = \
 #define TOTAL_CAM_ENTRY 32
 #define CAM_CONTENT_COUNT 8

-static struct usb_device_id rtl8192_usb_id_tbl[] = {
+static const struct usb_device_id rtl8192_usb_id_tbl[] = {
 	/* Realtek */
 	{USB_DEVICE(0x0bda, 0x8192)},
 	{USB_DEVICE(0x0bda, 0x8709)},
diff -u -p a/drivers/staging/udlfb/udlfb.c b/drivers/staging/udlfb/udlfb.c
--- a/drivers/staging/udlfb/udlfb.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/udlfb/udlfb.c 2010-01-08 10:54:45.000000000 +0100
@@ -112,7 +112,7 @@ static struct usb_device_id id_table []
 };
 */

-static struct usb_device_id id_table[] = {
+static const struct usb_device_id id_table[] = {
 	{.idVendor = 0x17e9, .match_flags = USB_DEVICE_ID_MATCH_VENDOR,},
 	{},
 };
diff -u -p a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
--- a/drivers/staging/quatech_usb2/quatech_usb2.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c 2010-01-08 11:00:33.000000000 +0100
@@ -116,7 +116,7 @@ static int debug;
 #define FOURTHCHAR	((unsigned char *)(urb->transfer_buffer))[i + 3]
 #define FIFTHCHAR	((unsigned char *)(urb->transfer_buffer))[i + 4]

-static struct usb_device_id quausb2_id_table[] = {
+static const struct usb_device_id quausb2_id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_SSU2_100)},
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_DSU2_100)},
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_DSU2_400)},
diff -u -p a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
--- a/drivers/staging/frontier/tranzport.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/frontier/tranzport.c 2010-01-08 11:03:26.000000000 +0100
@@ -55,7 +55,7 @@
 #endif

 /* table of devices that work with this driver */
-static struct usb_device_id usb_tranzport_table[] = {
+static const struct usb_device_id usb_tranzport_table[] = {
 	{USB_DEVICE(VENDOR_ID, PRODUCT_ID)},
 	{}			/* Terminating entry */
 };
diff -u -p a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
--- a/drivers/staging/frontier/alphatrack.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/frontier/alphatrack.c 2010-01-08 11:03:36.000000000 +0100
@@ -58,7 +58,7 @@
 #endif

 /* table of devices that work with this driver */
-static struct usb_device_id usb_alphatrack_table[] = {
+static const struct usb_device_id usb_alphatrack_table[] = {
 	{USB_DEVICE(VENDOR_ID, PRODUCT_ID)},
 	{}			/* Terminating entry */
 };
diff -u -p a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
--- a/drivers/staging/asus_oled/asus_oled.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/asus_oled/asus_oled.c 2010-01-08 11:16:13.000000000 +0100
@@ -83,7 +83,7 @@ struct oled_dev_desc_str {
 };

 /* table of devices that work with this driver */
-static struct usb_device_id id_table[] = {
+static const struct usb_device_id id_table[] = {
 	/* Asus G1/G2 (and variants)*/
 	{ USB_DEVICE(0x0b05, 0x1726) },
 	/* Asus G50V (and possibly others - G70? G71?)*/

