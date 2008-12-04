Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYLDXd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYLDXd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYLDXdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:33:19 -0500
Received: from host44-35-static.37-85-b.business.telecomitalia.it ([85.37.35.44]:50432
	"EHLO mail.sineo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYLDXdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:33:18 -0500
X-Greylist: delayed 1860 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Dec 2008 18:33:18 EST
From: Luca Santarelli <hrk@users.sourceforge.net>
To: marcel@holtmann.org
Subject: [PATCH] bluetooth usb hci: ISSC usb dongle with buggy SCO support
Date: Fri, 5 Dec 2008 00:02:13 +0100
User-Agent: KMail/1.9.9
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812050002.13560.hrk@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luca Santarelli <hrk <t> users.sourceforge.net>

As reported at:
http://bugs.gentoo.org/show_bug.cgi?id=249523
and in reference of similar patches such as:
http://thread.gmane.org/gmane.linux.bluez.devel/15067

This patch changes the blacklist entry for the ISSC bluetooth USB
dongle fixing the issue of the repeatedly appearing message

  hci_scodata_packet: hci0 SCO packet for unknown connection handle 92

in the kernel logs.

Sighed-off-by: Luca Santarelli <hrk <at> users.sourceforge.net>
---
This is my first kernel patch ever, I read the docs, but please notify
me if I made any mistake. Thank you all for your work, I'm happy to have
been able to contribute to this!

The patch has been run against 2.6.27.7 and has been tested on three x86
machines, showing no issues. In my own tests, the dongle has been then
used to connect to devices and everything worked fine.

--- linux-2.6.27.7/drivers/bluetooth/hci_usb.c.orig	2008-12-04 20:18:38.000000000 +0100
+++ linux-2.6.27.7/drivers/bluetooth/hci_usb.c	2008-12-04 20:19:37.000000000 +0100
@@ -148,8 +148,8 @@ static struct usb_device_id blacklist_id
 	{ USB_DEVICE(0x047d, 0x105d), .driver_info = HCI_RESET },
 	{ USB_DEVICE(0x047d, 0x105e), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
 
-	/* ISSC Bluetooth Adapter v3.1 */
-	{ USB_DEVICE(0x1131, 0x1001), .driver_info = HCI_RESET },
+	/* ISSC Bluetooth Adapter v3.1 with buggy SCO support */
+	{ USB_DEVICE(0x1131, 0x1001), .driver_info = HCI_RESET | HCI_BROKEN_ISOC },
 
 	/* RTX Telecom based adapters with buggy SCO support */
 	{ USB_DEVICE(0x0400, 0x0807), .driver_info = HCI_BROKEN_ISOC },
