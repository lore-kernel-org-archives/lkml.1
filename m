Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266Ab0ALHtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0ALHtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 02:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589Ab0ALHtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 02:49:21 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:50244 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0ALHtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 02:49:21 -0500
Message-ID: <4B4C297A.5090405@freemail.hu>
Date: Tue, 12 Jan 2010 08:49:14 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David Vrabel <david.vrabel@csr.com>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH] uwb: make USB device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32711; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct usb_device_id is constant in <linux/usb.h>
so it is worth to make the initialization data also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y = {
	  .x = E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] = ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/uwb/hwa-rc.c b/drivers/uwb/hwa-rc.c
--- a/drivers/uwb/hwa-rc.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/uwb/hwa-rc.c 2010-01-08 11:17:49.000000000 +0100
@@ -891,7 +891,7 @@ static int hwarc_post_reset(struct usb_i
 }

 /** USB device ID's that we handle */
-static struct usb_device_id hwarc_id_table[] = {
+static const struct usb_device_id hwarc_id_table[] = {
 	/* D-Link DUB-1210 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3d02, 0xe0, 0x01, 0x02),
 	  .driver_info = WUSB_QUIRK_WHCI_CMD_EVT },
diff -u -p a/drivers/uwb/i1480/dfu/usb.c b/drivers/uwb/i1480/dfu/usb.c
--- a/drivers/uwb/i1480/dfu/usb.c 2010-01-07 19:08:47.000000000 +0100
+++ b/drivers/uwb/i1480/dfu/usb.c 2010-01-08 11:18:26.000000000 +0100
@@ -430,7 +430,7 @@ error:


 /** USB device ID's that we handle */
-static struct usb_device_id i1480_usb_id_table[] = {
+static const struct usb_device_id i1480_usb_id_table[] = {
 	i1480_USB_DEV(0x8086, 0xdf3b),
 	i1480_USB_DEV(0x15a9, 0x0005),
 	i1480_USB_DEV(0x07d1, 0x3802),
