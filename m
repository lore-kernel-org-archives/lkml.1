Return-Path: <linux-kernel-owner+w=401wt.eu-S934520AbZLGAaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934520AbZLGAaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934442AbZLGA3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:29:46 -0500
Received: from kroah.org ([198.145.64.141]:34372 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758325AbZLGANC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:02 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:47 2009
Message-Id: <20091207000647.288211308@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhang Le <r0bertz@gentoo.org>
Subject: [043/119] USB: option.c: add support for D-Link DWM-162-U5
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=usb-option.c-add-support-for-d-link-dwm-162-u5.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhang Le <r0bertz@gentoo.org>

commit ff854ce0b17161a86b5ae444c6cb0aa221720fab upstream.

Add D-Link DWM-162-U5 device id 1e0e:ce16 into option driver. The device
has 4 interfaces, of which 1 is handled by storage and the other 3 by
option driver.

The device appears first as CD-only 05c6:2100 device and must be
switched to 1e0e:ce16 mode either by using "eject CD" or usb_modeswitch.

The MessageContent for usb_modeswitch.conf is:
"55534243e0c26a85000000000000061b000000020000000000000000000000"

Signed-off-by: Zhang Le <r0bertz@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -309,6 +309,7 @@ static int  option_resume(struct usb_ser
 
 #define DLINK_VENDOR_ID				0x1186
 #define DLINK_PRODUCT_DWM_652			0x3e04
+#define DLINK_PRODUCT_DWM_652_U5		0xce16
 
 #define QISDA_VENDOR_ID				0x1da5
 #define QISDA_PRODUCT_H21_4512			0x4512
@@ -587,6 +588,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
+	{ USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5) }, /* Yes, ALINK_VENDOR_ID */
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4512) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4523) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H20_4515) },


