Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbXGKWk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbXGKWk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764952AbXGKWkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:40:14 -0400
Received: from knuth.cs.hmc.edu ([134.173.42.100]:51885 "EHLO knuth.cs.hmc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763339AbXGKWkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:40:11 -0400
Message-ID: <469559FD.6030109@cs.hmc.edu>
Date: Wed, 11 Jul 2007 15:30:21 -0700
From: Kevin Lloyd <klloyd@cs.hmc.edu>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: linux-usb-devel@lists.sourceforge.net, gregkh@suse.de
CC: linux-kernel@vger.kernel.org, torvalds@osdl.org, linux@sierrawireless.com
Subject: [PATCH 02/02] Sierra Wireless - Add new devices
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Lloyd <linux@sierrawireless.com>

This patch adds new devices to the sierra wireless driver.

This patch was tested on the 2.6.21.1 kernel source patched with the following patches (found at http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/usb/):
    usb-sierra-cleanup-urb-startup.patch
    usb-sierra-fix-status-usage.patch
    usb-sierra-status.patch

This patch also depends on the recently submitted TRU-Install Patch (patch 01/02).

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>

---

diff -uprN -X dontdiff b/drivers/usb/serial/sierra.c c/drivers/usb/serial/sierra.c
--- b/drivers/usb/serial/sierra.c	2007-07-10 16:35:48.000000000 -0700
+++ c/drivers/usb/serial/sierra.c	2007-07-10 16:51:20.000000000 -0700
@@ -14,7 +14,7 @@
   Whom based his on the Keyspan driver by Hugh Blemings <hugh@blemings.org>
 */
 
-#define DRIVER_VERSION "v.1.2.4"
+#define DRIVER_VERSION "v.1.2.5"
 #define DRIVER_AUTHOR "Kevin Lloyd <linux@sierrawireless.com>"
 #define DRIVER_DESC "USB Driver for Sierra Wireless USB modems"
 
@@ -48,7 +48,7 @@ enum devicetype {
 int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
 {
 	int result;
-	dev_dbg("SET POWER STATE");
+	dev_dbg(udev, "%s", "SET POWER STATE");
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			0x00,			/* __u8 request      */
 			0x40,			/* __u8 request type */
@@ -63,7 +63,7 @@ int sierra_set_power_state(struct usb_de
 int sierra_set_ms_mode(struct usb_device *udev, __u16 eSocMode)
 {
 	int result;
-	dev_dbg("DEVICE MODE SWITCH");
+	dev_dbg(udev, "%s", "DEVICE MODE SWITCH");
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			SWIMS_USB_REQUEST_SetMode,	/* __u8 request      */
 			SWIMS_USB_REQUEST_TYPE_SetMode,	/* __u8 request type */
@@ -84,7 +84,7 @@ int sierra_probe(struct usb_interface *i
 
 	/* Check if in installer mode */
 	if (id->driver_info == DEVICE_INSTALLER){
-		dev_dbg("FOUND DEVICE(SW)\n");
+		dev_dbg(udev, "%s", "FOUND DEVICE(SW)\n");
 		result = sierra_set_ms_mode(udev, SWIMS_SET_MODE_Modem);
 		return 0;
 	}
@@ -95,20 +95,29 @@ int sierra_probe(struct usb_interface *i
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
 	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
+	{ USB_DEVICE(0x0f30, 0x1b1d) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
-	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless AirCard 595U */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
+	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U*/
+	
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6803) },	/* Sierra Wireless MC8765 */
-	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 */
+	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 & AC 875U */
 	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
+	{ USB_DEVICE(0x1199, 0x6832) },	/* Sierra Wireless MC8780*/
+	{ USB_DEVICE(0x1199, 0x6833) },	/* Sierra Wireless MC8781*/
+	{ USB_DEVICE(0x1199, 0x6850) },	/* Sierra Wireless AirCard 880 */
+	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
+	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880 E */
+	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881 E */
 
 	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
-
+	
+	 
 	{ USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},	
 	{ }
 };
@@ -121,21 +130,26 @@ static struct usb_device_id id_table_1po
 };
 
 static struct usb_device_id id_table_3port [] = {
-	/* CDMA Devices */
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
 	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
+	{ USB_DEVICE(0x0f30, 0x1b1d) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
-	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless AirCard 595U */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
-
-	/* GSM/UMTS Devices */
+	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U*/
+	
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6803) },	/* Sierra Wireless MC8765 */
-	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 */
+	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 & AC 875U */
 	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
+	{ USB_DEVICE(0x1199, 0x6832) },	/* Sierra Wireless MC8780*/
+	{ USB_DEVICE(0x1199, 0x6833) },	/* Sierra Wireless MC8781*/
+	{ USB_DEVICE(0x1199, 0x6850) },	/* Sierra Wireless AirCard 880 */
+	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
+	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880E */
+	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881E */
 	{ }
 };


