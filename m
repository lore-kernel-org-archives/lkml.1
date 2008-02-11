Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYBKU1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYBKU1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYBKU1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:27:14 -0500
Received: from mx1.sierrawireless.com ([208.81.121.7]:19391 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbYBKU1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:27:12 -0500
Message-ID: <47B0B02D.2000906@sierrawireless.com>
Date: Mon, 11 Feb 2008 12:29:33 -0800
From: Kevin Lloyd <klloyd@sierrawireless.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: gregkh@suse.de
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       klloyd@sierrawireless.com
Subject: [PATCH] usb: serial: move zte MF330 from sierra to option
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2008 20:28:44.0048 (UTC) FILETIME=[B25B7900:01C86CEC]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-5.0.1023-15614.002
X-TM-AS-Result: No--6.868700-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Lloyd <linux@sierrawireless.com>

Moves the Onda H600/ZTE MF33 device from the sierra driver to the option driver.

Signed-off-by: Kevin Lloyd <klloyd@sierrawireless.com>

---
 drivers/usb/serial/sierra.c |   1 -
 drivers/usb/serial/option.c |   2 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.25-rc1/drivers/usb/serial/sierra.c.orig	2008-02-11 11:34:06.000000000 -0800
+++ linux-2.6.25-rc1/drivers/usb/serial/sierra.c	2008-02-11 11:34:36.000000000 -0800
@@ -178,7 +178,6 @@ static struct usb_device_id id_table [] 
 
 	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
-	{ USB_DEVICE(0x05C6, 0x6613), .driver_info = DEVICE_1_PORT }, /* Onda H600/ZTE MF330 */
 
 	{ USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},
 	{ }
--- linux-2.6.25-rc1/drivers/usb/serial/option.c.orig	2008-02-11 11:42:10.000000000 -0800
+++ linux-2.6.25-rc1/drivers/usb/serial/option.c	2008-02-11 11:42:18.000000000 -0800
@@ -121,6 +121,8 @@ static int  option_send_setup(struct usb
 #define BANDRICH_PRODUCT_C100_1			0x1002
 #define BANDRICH_PRODUCT_C100_2			0x1003
 
+#define QUALCOMM_VENDOR_ID			0x05C6
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -186,6 +188,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);

