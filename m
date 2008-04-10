Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYDJHBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYDJHBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 03:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYDJHBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 03:01:19 -0400
Received: from usaga01-in.huawei.com ([206.16.17.211]:13992 "EHLO
	usaga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbYDJHBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:01:18 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2008 03:01:18 EDT
Date: Thu, 10 Apr 2008 14:51:06 +0800
From: fangxiaozhi 00110321 <huananhu@huawei.com>
Subject: [PATCH 10/4]linux-usb: To support more Huawei data card product IDs,
 fix kernel 2.6.24.4
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, johann.wilhelm@student.tugraz.at,
       zihan@huawei.com, Lin.Lei@huawei.com
Message-id: <f989c26a7a8c3.7a8c3f989c26a@huawei.com>
MIME-version: 1.0
X-Mailer: iPlanet Messenger Express 5.2 HotFix 2.14 (built Aug  8 2006)
Content-type: text/plain; charset=us-ascii
Content-language: zh-CN
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-Accept-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fangxiaozhi <huananhu@huawei.com>

1. This patch is based on the kernel of 2.6.24.4
2. To declare the unusal device for Huawei data card devices in unusual_devs.h
3. To disable the product ID matching for Huawei data card devices in usb_match_device function of driver.c
4. To declare the product IDs in option.c.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
---------------------------------------------------------------------------------

diff -uprN -X linux-2.6.24.4-vanilla/Documentation/dontdiff linux-2.6.24.4-vanilla/drivers/usb/serial/option.c linux-2.6.24.4/drivers/usb/serial/option.c
--- linux-2.6.24.4-vanilla/drivers/usb/serial/option.c	2008-03-25 02:49:18.000000000 +0800
+++ linux-2.6.24.4/drivers/usb/serial/option.c	2008-04-10 11:12:42.000000000 +0800
@@ -109,6 +109,25 @@ static int  option_send_setup(struct usb
 #define HUAWEI_PRODUCT_E600			0x1001
 #define HUAWEI_PRODUCT_E220			0x1003
 #define HUAWEI_PRODUCT_E220BIS			0x1004
+/* Reported by fangxiaozhi <huananhu@huawei.com>
+ * New supported product IDs of HuaWei data card devices
+ */
+#define HUAWEI_PRODUCT_E1401			0x1401
+#define HUAWEI_PRODUCT_E1403			0x1403
+#define HUAWEI_PRODUCT_E1405			0x1405
+#define HUAWEI_PRODUCT_E1406			0x1406
+#define HUAWEI_PRODUCT_E1408			0x1408
+#define HUAWEI_PRODUCT_E1409			0x1409
+#define HUAWEI_PRODUCT_E1410			0x1410
+#define HUAWEI_PRODUCT_E1411			0x1411
+#define HUAWEI_PRODUCT_E1412			0x1412
+#define HUAWEI_PRODUCT_E1413			0x1413
+#define HUAWEI_PRODUCT_E1414			0x1414
+#define HUAWEI_PRODUCT_E1415			0x1415
+#define HUAWEI_PRODUCT_E1416			0x1416
+#define HUAWEI_PRODUCT_E1417			0x1417
+#define HUAWEI_PRODUCT_E1418			0x1418
+#define HUAWEI_PRODUCT_E1419			0x1419
 
 #define NOVATELWIRELESS_VENDOR_ID		0x1410
 #define DELL_VENDOR_ID				0x413C
@@ -160,6 +179,22 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1401) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1403) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1405) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1406) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1408) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1409) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1410) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1411) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1412) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1413) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1414) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1415) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1416) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1417) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1418) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1419) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1100) }, /* Novatel Merlin XS620/S640 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1110) }, /* Novatel Merlin S620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1120) }, /* Novatel Merlin EX720 */
 	
 	
diff -uprN -X linux-2.6.24.4-vanilla/Documentation/dontdiff linux-2.6.24.4-vanilla/drivers/usb/storage/unusual_devs.h linux-2.6.24.4/drivers/usb/storage/unusual_devs.h
--- linux-2.6.24.4-vanilla/drivers/usb/storage/unusual_devs.h	2008-03-25 02:49:18.000000000 +0800
+++ linux-2.6.24.4/drivers/usb/storage/unusual_devs.h	2008-04-10 11:07:36.000000000 +0800
@@ -1498,16 +1498,104 @@ UNUSUAL_DEV(  0x1210, 0x0003, 0x0100, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
-/* Reported by fangxiaozhi <fangxiaozhi60675@huawei.com>
- * and by linlei <linlei83@huawei.com>
- * Patch reworked by Johann Wilhelm <johann.wilhelm@student.tugraz.at>
- * This brings the HUAWEI E220 devices into multi-port mode
+/* Reported by fangxiaozhi <huananhu@huawei.com>
+ * This brings the HUAWEI data card devices into multi-port mode
  */
+UNUSUAL_DEV( 0x12d1, 0x1001, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
 UNUSUAL_DEV( 0x12d1, 0x1003, 0x0000, 0x0000,
 		"HUAWEI MOBILE",
 		"Mass Storage",
 		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
 		0),
+UNUSUAL_DEV( 0x12d1, 0x1004, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1401, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1403, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1405, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1406, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1408, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1409, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1410, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1411, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1412, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1413, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1414, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1415, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1416, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1417, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1418, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV( 0x12d1, 0x1419, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
 
 /* Reported by Vilius Bilinkevicius <vilisas AT xxx DOT lt) */
 UNUSUAL_DEV(  0x132b, 0x000b, 0x0001, 0x0001,

******************************************************************************************
 This email and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender by phone or em
ail immediately and delete it!
 *****************************************************************************************
