Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbZLOEE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbZLOEE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758830AbZLOEE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:04:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:45943 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756718AbZLOEE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:04:57 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/t51MNfcTtxwiBGUWjkUNZcFRj4lhnxahxB23DB/
	m8JwHKDSk70LYG
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Jakub Schmidtke <sjakub@gmail.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Andre Haupt <andre@bitwigglers.org>,
       "Kevin A. Granade" <kevin.granade@gmail.com>,
       Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] Add defines for asus vendor_id and device_id to be consistent with hid-ids.h
Date: Tue, 15 Dec 2009 05:04:22 +0100
Message-Id: <1260849862-1505-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This almost trivial patch replaces the hardcoded values for the vendor and
device ids with defines, as they are used in drivers/hid/hid-ids.h

For me this seems to be more consistent, however as drivers/hid/hid-ids.h
is not within the default include directory I had to redefine the defines here
(maybe move the hid-ids.h to include/linux ?)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/asus_oled/asus_oled.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index f4c2657..393d921 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -52,6 +52,10 @@
 #define ASUS_OLED_DISP_HEIGHT		32
 #define ASUS_OLED_PACKET_BUF_SIZE	256
 
+#define USB_VENDOR_ID_ASUS      0x0b05
+#define USB_DEVICE_ID_ASUS_LCM      0x1726
+#define USB_DEVICE_ID_ASUS_LCM2     0x175b
+
 MODULE_AUTHOR("Jakub Schmidtke, sjakub@gmail.com");
 MODULE_DESCRIPTION("Asus OLED Driver v" ASUS_OLED_VERSION);
 MODULE_LICENSE("GPL");
@@ -85,16 +89,18 @@ struct oled_dev_desc_str {
 /* table of devices that work with this driver */
 static struct usb_device_id id_table[] = {
 	/* Asus G1/G2 (and variants)*/
-	{ USB_DEVICE(0x0b05, 0x1726) },
+	{ USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_LCM) },
 	/* Asus G50V (and possibly others - G70? G71?)*/
-	{ USB_DEVICE(0x0b05, 0x175b) },
+	{ USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_LCM2) },
 	{ },
 };
 
 /* parameters of specific devices */
 static struct oled_dev_desc_str oled_dev_desc_table[] = {
-	{ 0x0b05, 0x1726, 128, PACK_MODE_G1, "G1/G2" },
-	{ 0x0b05, 0x175b, 256, PACK_MODE_G50, "G50" },
+	{ USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_LCM, 128, PACK_MODE_G1,
+		"G1/G2" },
+	{ USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_LCM2, 256, PACK_MODE_G50,
+		"G50" },
 	{ },
 };
 
-- 
1.6.4.4

