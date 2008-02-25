Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbYBYWbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbYBYWbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757988AbYBYWa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:30:56 -0500
Received: from fs1.baycontrols.com ([38.157.74.15]:53846 "EHLO
	fs1.baycontrols.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723AbYBYWaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:30:55 -0500
Message-ID: <47C3419C.3030402@bay.ws>
Date: Mon, 25 Feb 2008 17:30:52 -0500
From: David Ludlow <dave.ludlow@bay.ws>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 001/001] usb: Add support for the mos7820/7840-based B&B USB/RS485
 converter to mos7840.c
Content-Type: multipart/mixed;
 boundary="------------020900030803070101060900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020900030803070101060900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

From: David Ludlow <dave.ludlow@bay.ws>

Add support for the mos7820/7840-based B&B USOPTL4_2/USOPTL4_4 USB/RS485 converter to mos7840.c
Signed-off-by: Dave Ludlow <dave.ludlow@bay.ws>
---
DTR needs to be set/raised to receive and clear/lowered to send, as per the mos7840 datasheet.

--- linux-2.6.25-rc2/drivers/usb/serial/mos7840.c.orig	2008-02-25 15:13:42.000000000 -0500
+++ linux-2.6.25-rc2/drivers/usb/serial/mos7840.c	2008-02-25 15:20:54.000000000 -0500
@@ -110,11 +110,20 @@
 
 /* vendor id and device id defines */
 
+/* The native mos7840/7820 component */
 #define USB_VENDOR_ID_MOSCHIP           0x9710
 #define MOSCHIP_DEVICE_ID_7840          0x7840
 #define MOSCHIP_DEVICE_ID_7820          0x7820
+/* The native component can have its vendor/device id's overridden
+ * in vendor-specific implementations.  Such devices can be handled
+ * by making a change here, in moschip_port_id_table, and in
+ * moschip_id_table_combined
+ */
+#define USB_VENDOR_ID_BANDB             0x0856
+#define BANDB_DEVICE_ID_USOPTL4_4       0xAC44
+#define BANDB_DEVICE_ID_USOPTL4_2       0xAC42
 
-/* Interrupt Rotinue Defines    */
+/* Interrupt Routine Defines    */
 
 #define SERIAL_IIR_RLS      0x06
 #define SERIAL_IIR_MS       0x00
@@ -159,12 +168,16 @@
 static struct usb_device_id moschip_port_id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{}			/* terminating entry */
 };
 
 static __devinitdata struct usb_device_id moschip_id_table_combined[] = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{}			/* terminating entry */
 };



--------------020900030803070101060900
Content-Type: text/x-vcard; charset=utf-8;
 name="dave_ludlow.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dave_ludlow.vcf"

begin:vcard
fn:David Ludlow
n:Ludlow;David
org:Bay;Research & Development
email;internet:dave.ludlow@bay.ws
title:Software Engineer
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------020900030803070101060900--
