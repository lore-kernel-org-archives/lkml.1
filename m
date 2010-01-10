Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861Ab0AJOdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0AJOdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619Ab0AJOdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:33:42 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:65183 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab0AJOdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:33:40 -0500
X-Authuid: nmarci
Message-ID: <4B49E53D.5050900@freemail.hu>
Date: Sun, 10 Jan 2010 15:33:33 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH 1/9] USB skeleton: make USB device id constant
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
diff -u -p a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
--- a/drivers/usb/usb-skeleton.c 2010-01-07 19:08:47.000000000 +0100
+++ b/drivers/usb/usb-skeleton.c 2010-01-08 17:04:07.000000000 +0100
@@ -28,7 +28,7 @@
 #define USB_SKEL_PRODUCT_ID	0xfff0

 /* table of devices that work with this driver */
-static struct usb_device_id skel_table[] = {
+static const struct usb_device_id skel_table[] = {
 	{ USB_DEVICE(USB_SKEL_VENDOR_ID, USB_SKEL_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
