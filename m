Return-Path: <linux-kernel-owner+w=401wt.eu-S965749AbXDCMlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965749AbXDCMlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 08:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965769AbXDCMlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 08:41:13 -0400
Received: from rwcrmhc13.comcast.net ([204.127.192.83]:50328 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965749AbXDCMlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 08:41:13 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 08:41:13 EDT
Subject: [PATCH] hid: add QUIRK_HIDDEV for Belkin Flip KVM
From: Dan Engel <dan@sourceharvest.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 08:36:09 -0400
Message-Id: <1175603769.9387.11.camel@monica.engel.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel P. Engel <dengel@sourceharvest.com>

Add HID_QUIRK_HIDDEV for the Belkin Flip USB KVM to the hid-core
blacklist table. The Belkin Flip USB KVM provides for software
control of switching via a HID class interface. It overloads
three HID LED usages, two of which aren't mapped in the ev_dev input
subsection, and which it doesn't make sense to map. In order to
force the creation of a hiddev device for controlling
the Flip, this quirk flag is needed.

Signed-off-by: Daniel P. Engel <dengel@sourceharvest.com>
---

This patch was created against kernel version 2.6.20.4. It patches
only one file, drivers/input/hid-core.c.

--- linux-2.6/drivers/usb/input/hid-core.c.orig	2007-03-30 13:42:01.000000000 -0400
+++ linux-2.6/drivers/usb/input/hid-core.c	2007-03-30 13:43:16.000000000 -0400
@@ -792,6 +792,9 @@ void usbhid_init_reports(struct hid_devi
 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000
 
+#define USB_VENDOR_ID_BELKIN		0x050d
+#define USB_DEVICE_ID_FLIP_KVM		0x3201
+
 /*
  * Alphabetically sorted blacklist by quirk type.
  */
@@ -969,6 +972,8 @@ static const struct hid_blacklist {
 
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_USB_RECEIVER, HID_QUIRK_BAD_RELATIVE_KEYS },
 
+	{ USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM, HID_QUIRK_HIDDEV },
+
 	{ 0, 0 }
 };
 


