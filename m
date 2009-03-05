Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZCEA4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZCEA4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 19:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZCEAzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 19:55:53 -0500
Received: from wa4ehsobe001.messaging.microsoft.com ([216.32.181.11]:23115
	"EHLO WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750752AbZCEAzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 19:55:52 -0500
X-BigFish: VPS1(zzzzzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KG0D8J-04-G4C-01
From: Robert Richter <robert.richter@amd.com>
To: Greg KH <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Axel Wachtler <axel.wachtler@atmel.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] usb/serial: adding FTDI USB/Serial converter devices
Date: Thu, 5 Mar 2009 01:54:39 +0100
Message-ID: <1236214479-28555-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
X-OriginalArrivalTime: 05 Mar 2009 00:55:39.0757 (UTC) FILETIME=[1A53F9D0:01C99D2D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Wachtler <axel.wachtler@atmel.com>

This patch adds the following devices to the USB FTDI SIO device
table:

 Bus 001 Device 009: ID 03eb:2109 Atmel Corp.
 http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4187

 Bus 001 Device 008: ID 1cf1:0001
 http://www.dresden-elektronik.de/shop/prod75.html

 Bus 001 Device 007: ID 1c1f:0004
 http://www.dresden-elektronik.de/shop/prod64.html

Signed-off-by: Axel Wachtler <axel.wachtler@atmel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/usb/serial/ftdi_sio.c |    3 +++
 drivers/usb/serial/ftdi_sio.h |   13 +++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index f92f4d7..f773392 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -663,6 +663,9 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(ALTI2_VID, ALTI2_N3_PID) },
 	{ USB_DEVICE(FTDI_VID, DIEBOLD_BCS_SE923_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NDI_HUC_PID) },
+	{ USB_DEVICE(ATMEL_VID, STK541_PID) },
+	{ USB_DEVICE(DE_VID, STB_PID) },
+	{ USB_DEVICE(DE_VID, WHT_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index e300c84..f2745ed 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -893,6 +893,19 @@
 #define DIEBOLD_BCS_SE923_PID	0xfb99
 
 /*
+ * Atmel STK541
+ */
+#define ATMEL_VID		0x03eb /* Vendor ID */
+#define STK541_PID		0x2109 /* Zigbee Controller */
+
+/*
+ * Dresden Elektronic Sensor Terminal Board
+ */
+#define DE_VID			0x1cf1 /* Vendor ID */
+#define STB_PID			0x0001 /* Sensor Terminal Board */
+#define WHT_PID			0x0004 /* Wireless Handheld Terminal */
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0
-- 
1.6.1.3


