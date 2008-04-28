Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbYD1GBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbYD1GBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763414AbYD1GAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:00:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43536 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbYD1GAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:00:08 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] usbhid endianness annotations and fixes
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, gregkh@suse.de
Message-Id: <E1JqMPF-0004oO-W8@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 28 Apr 2008 07:00:05 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


usb_control_msg() converts arguments to little-endian itself,
doing that in caller means breakage on big-endian boxen.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/hid/usbhid/hid-core.c |    2 +-
 include/linux/hid.h           |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index e0d805f..01427c5 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -654,7 +654,7 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
 	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 		HID_REQ_SET_REPORT,
 		USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-		cpu_to_le16(((HID_OUTPUT_REPORT + 1) << 8) | *buf),
+		((HID_OUTPUT_REPORT + 1) << 8) | *buf,
 		interface->desc.bInterfaceNumber, buf + 1, count - 1,
 		USB_CTRL_SET_TIMEOUT);
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index d951ec4..4ce3b7a 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -498,13 +498,13 @@ struct hid_parser {
 
 struct hid_class_descriptor {
 	__u8  bDescriptorType;
-	__u16 wDescriptorLength;
+	__le16 wDescriptorLength;
 } __attribute__ ((packed));
 
 struct hid_descriptor {
 	__u8  bLength;
 	__u8  bDescriptorType;
-	__u16 bcdHID;
+	__le16 bcdHID;
 	__u8  bCountryCode;
 	__u8  bNumDescriptors;
 
-- 
1.5.3.GIT


