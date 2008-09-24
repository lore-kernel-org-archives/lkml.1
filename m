Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbYIXCS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbYIXCS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 22:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYIXCSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 22:18:15 -0400
Received: from usaga01-in.huawei.com ([206.16.17.211]:61859 "EHLO
	usaga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYIXCSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 22:18:14 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2008 22:18:14 EDT
Date: Wed, 24 Sep 2008 10:07:31 +0800
From: fangxiaozhi 00110321 <huananhu@huawei.com>
Subject: [PATCH 10/4]linux-usb: To support more Huawei data card product IDs,
 fix kernel 2.6.26.5
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, zihan@huawei.com, Lin.Lei@huawei.com,
       zhangqianchun@huawei.com, greg@kroah.com
Message-id: <faf7c9cb3c6f0.3c6f0faf7c9cb@huawei.com>
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

1. This patch is based on the kernel of 2.6.26.5
2. To declare the unusual device for new Huawei data card devices in unusual_devs.h
3. To modify the data value and length in the function of usb_stor_huawei_e220_init in initializers.c
4. To declare more new product IDs in option.c.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
---------------------------------------------------------------------------------
 
diff -urN -X linux-2.6.26.5/Documentation/dontdiff linux-2.6.26.5/drivers/usb/serial/option.c linux-2.6.26.5-vanilla/drivers/usb/serial/option.c
--- linux-2.6.26.5/drivers/usb/serial/option.c	2008-09-09 01:40:20.000000000 +0800
+++ linux-2.6.26.5-vanilla/drivers/usb/serial/option.c	2008-09-24 04:26:24.000000000 +0800
@@ -110,11 +110,20 @@
 #define HUAWEI_PRODUCT_E220			0x1003
 #define HUAWEI_PRODUCT_E220BIS			0x1004
 #define HUAWEI_PRODUCT_E1401			0x1401
+#define HUAWEI_PRODUCT_E1402			0x1402
 #define HUAWEI_PRODUCT_E1403			0x1403
+#define HUAWEI_PRODUCT_E1404			0x1404
 #define HUAWEI_PRODUCT_E1405			0x1405
 #define HUAWEI_PRODUCT_E1406			0x1406
+#define HUAWEI_PRODUCT_E1407			0x1407
 #define HUAWEI_PRODUCT_E1408			0x1408
 #define HUAWEI_PRODUCT_E1409			0x1409
+#define HUAWEI_PRODUCT_E140A			0x140A
+#define HUAWEI_PRODUCT_E140B			0x140B
+#define HUAWEI_PRODUCT_E140C			0x140C
+#define HUAWEI_PRODUCT_E140D			0x140D
+#define HUAWEI_PRODUCT_E140E			0x140E
+#define HUAWEI_PRODUCT_E140F			0x140F
 #define HUAWEI_PRODUCT_E1410			0x1410
 #define HUAWEI_PRODUCT_E1411			0x1411
 #define HUAWEI_PRODUCT_E1412			0x1412
@@ -125,6 +134,44 @@
 #define HUAWEI_PRODUCT_E1417			0x1417
 #define HUAWEI_PRODUCT_E1418			0x1418
 #define HUAWEI_PRODUCT_E1419			0x1419
+#define HUAWEI_PRODUCT_E141A			0x141A
+#define HUAWEI_PRODUCT_E141B			0x141B
+#define HUAWEI_PRODUCT_E141C			0x141C
+#define HUAWEI_PRODUCT_E141D			0x141D
+#define HUAWEI_PRODUCT_E141E			0x141E
+#define HUAWEI_PRODUCT_E141F			0x141F
+#define HUAWEI_PRODUCT_E1420			0x1420
+#define HUAWEI_PRODUCT_E1421			0x1421
+#define HUAWEI_PRODUCT_E1422			0x1422
+#define HUAWEI_PRODUCT_E1423			0x1423
+#define HUAWEI_PRODUCT_E1424			0x1424
+#define HUAWEI_PRODUCT_E1425			0x1425
+#define HUAWEI_PRODUCT_E1426			0x1426
+#define HUAWEI_PRODUCT_E1427			0x1427
+#define HUAWEI_PRODUCT_E1428			0x1428
+#define HUAWEI_PRODUCT_E1429			0x1429
+#define HUAWEI_PRODUCT_E142A			0x142A
+#define HUAWEI_PRODUCT_E142B			0x142B
+#define HUAWEI_PRODUCT_E142C			0x142C
+#define HUAWEI_PRODUCT_E142D			0x142D
+#define HUAWEI_PRODUCT_E142E			0x142E
+#define HUAWEI_PRODUCT_E142F			0x142F
+#define HUAWEI_PRODUCT_E1430			0x1430
+#define HUAWEI_PRODUCT_E1431			0x1431
+#define HUAWEI_PRODUCT_E1432			0x1432
+#define HUAWEI_PRODUCT_E1433			0x1433
+#define HUAWEI_PRODUCT_E1434			0x1434
+#define HUAWEI_PRODUCT_E1435			0x1435
+#define HUAWEI_PRODUCT_E1436			0x1436
+#define HUAWEI_PRODUCT_E1437			0x1437
+#define HUAWEI_PRODUCT_E1438			0x1438
+#define HUAWEI_PRODUCT_E1439			0x1439
+#define HUAWEI_PRODUCT_E143A			0x143A
+#define HUAWEI_PRODUCT_E143B			0x143B
+#define HUAWEI_PRODUCT_E143C			0x143C
+#define HUAWEI_PRODUCT_E143D			0x143D
+#define HUAWEI_PRODUCT_E143E			0x143E
+#define HUAWEI_PRODUCT_E143F			0x143F
 
 #define NOVATELWIRELESS_VENDOR_ID		0x1410
 
@@ -240,11 +287,20 @@
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1401, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1402, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1403, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1404, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1405, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1406, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1407, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1408, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1409, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E140A, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E140B, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E140C, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E140D, 0xff, 0xff, 0xff) }, 
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E140E, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E140F, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1410, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1411, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1412, 0xff, 0xff, 0xff) },
@@ -255,6 +311,44 @@
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1417, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1418, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1419, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E141A, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E141B, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E141C, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E141D, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E141E, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E141F, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1420, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1421, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1422, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1423, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1424, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1425, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1426, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1427, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1428, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1429, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E142A, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E142B, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E142C, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E142D, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E142E, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E142F, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1430, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1431, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1432, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1433, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1434, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1435, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1436, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1437, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1438, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1439, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143A, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143B, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143C, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143D, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143E, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143F, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) }, /* Novatel Merlin V640/XV620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) }, /* Novatel Merlin V620/S620 */
diff -urN -X linux-2.6.26.5/Documentation/dontdiff linux-2.6.26.5/drivers/usb/storage/initializers.c linux-2.6.26.5-vanilla/drivers/usb/storage/initializers.c
--- linux-2.6.26.5/drivers/usb/storage/initializers.c	2008-09-09 01:40:20.000000000 +0800
+++ linux-2.6.26.5-vanilla/drivers/usb/storage/initializers.c	2008-09-24 04:18:29.000000000 +0800
@@ -97,11 +97,11 @@
 {
 	int result;
 
-	us->iobuf[0] = 0x1;
+	us->iobuf[0] = 0x0;
 	result = usb_stor_control_msg(us, us->send_ctrl_pipe,
 				      USB_REQ_SET_FEATURE,
 				      USB_TYPE_STANDARD | USB_RECIP_DEVICE,
-				      0x01, 0x0, us->iobuf, 0x1, 1000);
+				      0x01, 0x0, us->iobuf, 0x0, 1000);
 	US_DEBUGP("usb_control_msg performing result is %d\n", result);
 	return (result ? 0 : -1);
 }
diff -urN -X linux-2.6.26.5/Documentation/dontdiff linux-2.6.26.5/drivers/usb/storage/unusual_devs.h linux-2.6.26.5-vanilla/drivers/usb/storage/unusual_devs.h
--- linux-2.6.26.5/drivers/usb/storage/unusual_devs.h	2008-09-09 01:40:20.000000000 +0800
+++ linux-2.6.26.5-vanilla/drivers/usb/storage/unusual_devs.h	2008-09-24 04:18:29.000000000 +0800
@@ -1604,11 +1604,21 @@
 		"Mass Storage",
 		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
 		0),
+UNUSUAL_DEV( 0x12d1, 0x1402, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
 UNUSUAL_DEV( 0x12d1, 0x1403, 0x0000, 0x0000,
 		"HUAWEI MOBILE",
 		"Mass Storage",
 		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
 		0),
+UNUSUAL_DEV( 0x12d1, 0x1404, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),                
 UNUSUAL_DEV( 0x12d1, 0x1405, 0x0000, 0x0000,
 		"HUAWEI MOBILE",
 		"Mass Storage",
@@ -1619,6 +1629,11 @@
 		"Mass Storage",
 		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
 		0),
+UNUSUAL_DEV( 0x12d1, 0x1407, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),                
 UNUSUAL_DEV( 0x12d1, 0x1408, 0x0000, 0x0000,
 		"HUAWEI MOBILE",
 		"Mass Storage",
@@ -1629,6 +1644,36 @@
 		"Mass Storage",
 		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
 		0),
+UNUSUAL_DEV( 0x12d1, 0x140A, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),  
+UNUSUAL_DEV( 0x12d1, 0x140B, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0), 
+UNUSUAL_DEV( 0x12d1, 0x140C, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),  
+UNUSUAL_DEV( 0x12d1, 0x140D, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0), 
+UNUSUAL_DEV( 0x12d1, 0x140E, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0), 
+UNUSUAL_DEV( 0x12d1, 0x140F, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),                                                                                         
 UNUSUAL_DEV( 0x12d1, 0x1410, 0x0000, 0x0000,
 		"HUAWEI MOBILE",
 		"Mass Storage",
@@ -1675,10 +1720,200 @@
 		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
 		0),
 UNUSUAL_DEV( 0x12d1, 0x1419, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
+                "HUAWEI MOBILE",
 		"Mass Storage",
 		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
+                0),
+UNUSUAL_DEV( 0x12d1, 0x141A, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+ UNUSUAL_DEV( 0x12d1, 0x141B, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x141C, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x141D, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x141E, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+ UNUSUAL_DEV( 0x12d1, 0x141F, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1420, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1421, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1422, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+ UNUSUAL_DEV( 0x12d1, 0x1423, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1424, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1425, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1426, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+ UNUSUAL_DEV( 0x12d1, 0x1427, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1428, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1429, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x142A, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x142B, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x142C, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+ UNUSUAL_DEV( 0x12d1, 0x142D, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x142E, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x142F, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1430, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+ UNUSUAL_DEV( 0x12d1, 0x1431, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1432, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1433, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1434, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+ UNUSUAL_DEV( 0x12d1, 0x1435, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1436, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1437, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x1438, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+ UNUSUAL_DEV( 0x12d1, 0x1439, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x143A, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x143B, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x143C, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x143D, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+ UNUSUAL_DEV( 0x12d1, 0x143E, 0x0000, 0x0000,
+                "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
+UNUSUAL_DEV( 0x12d1, 0x143F, 0x0000, 0x0000,
+               "HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
+                0),
 
 /* Reported by Vilius Bilinkevicius <vilisas AT xxx DOT lt) */
 UNUSUAL_DEV(  0x132b, 0x000b, 0x0001, 0x0001,


******************************************************************************************
 This email and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained here in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email
 immediately and delete it!
 *****************************************************************************************
