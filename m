Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZKDPXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZKDPXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbZKDPXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:23:50 -0500
Received: from sitar.i-cable.com ([203.83.115.100]:62536 "HELO
	sitar.i-cable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756657AbZKDPXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:23:48 -0500
From: Zhang Le <r0bertz@gentoo.org>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       smurf@smurf.noris.de, Zhang Le <r0bertz@gentoo.org>
Subject: [PATCH v2] USB: option.c: add support for D-Link DWM-162-U5
Date: Wed,  4 Nov 2009 23:22:59 +0800
Message-Id: <1257348179-20430-1-git-send-email-r0bertz@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add D-Link DWM-162-U5 device id 1e0e:ce16 into option driver. The device
has 4 interfaces, of which 1 is handled by storage and the other 3 by
option driver.

The device appears first as CD-only 05c6:2100 device and must be
switched to 1e0e:ce16 mode either by using "eject CD" or usb_modeswitch.

The MessageContent for usb_modeswitch.conf is:
"55534243e0c26a85000000000000061b000000020000000000000000000000"

Signed-off-by: Zhang Le <r0bertz@gentoo.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index cd44c68..319aaf9 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -308,6 +308,7 @@ static int  option_resume(struct usb_serial *serial);
 
 #define DLINK_VENDOR_ID				0x1186
 #define DLINK_PRODUCT_DWM_652			0x3e04
+#define DLINK_PRODUCT_DWM_652_U5		0xce16
 
 #define QISDA_VENDOR_ID				0x1da5
 #define QISDA_PRODUCT_H21_4512			0x4512
@@ -586,6 +587,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
+	{ USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5) }, /* Yes, ALINK_VENDOR_ID */
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4512) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4523) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H20_4515) },
-- 
1.6.5.1

