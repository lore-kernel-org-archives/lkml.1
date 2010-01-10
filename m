Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890Ab0AJOeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab0AJOeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792Ab0AJOet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:34:49 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:49237 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab0AJOer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:34:47 -0500
X-Authuid: nmarci
Message-ID: <4B49E57C.5040400@freemail.hu>
Date: Sun, 10 Jan 2010 15:34:36 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH 4/9] USB image: make USB device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02a.mail.t-online.hu 32721; Body=5 Fuz1=5
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
--- linux/drivers/usb/image/mdc800.c.orig	2010-01-10 15:04:28.000000000 +0100
+++ linux/drivers/usb/image/mdc800.c	2010-01-10 15:05:46.000000000 +0100
@@ -967,7 +967,7 @@



-static struct usb_device_id mdc800_table [] = {
+static const struct usb_device_id mdc800_table[] = {
 	{ USB_DEVICE(MDC800_VENDOR_ID, MDC800_PRODUCT_ID) },
 	{ }						/* Terminating entry */
 };
--- linux/drivers/usb/image/microtek.c.orig	2010-01-10 15:04:28.000000000 +0100
+++ linux/drivers/usb/image/microtek.c	2010-01-10 15:10:52.000000000 +0100
@@ -155,7 +155,7 @@
 			 const struct usb_device_id *id);
 static void mts_usb_disconnect(struct usb_interface *intf);

-static struct usb_device_id mts_usb_ids [];
+static const struct usb_device_id mts_usb_ids[];

 static struct usb_driver mts_usb_driver = {
 	.name =		"microtekX6",
@@ -656,7 +656,7 @@
 /* The entries of microtek_table must correspond, line-by-line to
    the entries of mts_supported_products[]. */

-static struct usb_device_id mts_usb_ids [] =
+static const struct usb_device_id mts_usb_ids[] =
 {
 	{ USB_DEVICE(0x4ce, 0x0300) },
 	{ USB_DEVICE(0x5da, 0x0094) },
