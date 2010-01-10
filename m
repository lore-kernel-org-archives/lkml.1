Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447Ab0AJKvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0AJKvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 05:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171Ab0AJKvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 05:51:45 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:57509 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0AJKvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 05:51:43 -0500
Message-ID: <4B49B13B.8070604@freemail.hu>
Date: Sun, 10 Jan 2010 11:51:39 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Daniel Ritz <daniel.ritz@gmx.ch>
CC: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH] input: make USB device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32711; Body=6 Fuz1=6
	Fuz2=6
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
diff -u -p a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
--- a/drivers/input/tablet/gtco.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/input/tablet/gtco.c 2010-01-08 19:11:02.000000000 +0100
@@ -92,7 +92,7 @@ Scott Hill shill@gtcocalcomp.com
 /* DATA STRUCTURES */

 /* Device table */
-static struct usb_device_id gtco_usbid_table [] = {
+static const struct usb_device_id gtco_usbid_table[] = {
 	{ USB_DEVICE(VENDOR_ID_GTCO, PID_400) },
 	{ USB_DEVICE(VENDOR_ID_GTCO, PID_401) },
 	{ USB_DEVICE(VENDOR_ID_GTCO, PID_1000) },
diff -u -p a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c 2010-01-07 19:08:40.000000000 +0100
+++ b/drivers/input/touchscreen/usbtouchscreen.c 2010-01-08 19:17:10.000000000 +0100
@@ -144,7 +144,7 @@ enum {
 	.bInterfaceClass = USB_INTERFACE_CLASS_HID, \
 	.bInterfaceProtocol = USB_INTERFACE_PROTOCOL_MOUSE

-static struct usb_device_id usbtouch_devices[] = {
+static const struct usb_device_id usbtouch_devices[] = {
 #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
 	/* ignore the HID capable devices, handled by usbhid */
 	{USB_DEVICE_HID_CLASS(0x0eef, 0x0001), .driver_info = DEVTYPE_IGNORE},
