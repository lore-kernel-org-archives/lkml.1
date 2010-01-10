Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803Ab0AJQ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0AJQ7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 11:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725Ab0AJQ7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 11:59:51 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:65264 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab0AJQ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 11:59:49 -0500
Message-ID: <4B4A076A.8020207@freemail.hu>
Date: Sun, 10 Jan 2010 17:59:22 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH] hid: make USB device id constant
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
diff -u -p a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
--- a/drivers/hid/usbhid/hid-core.c 2010-01-07 19:08:40.000000000 +0100
+++ b/drivers/hid/usbhid/hid-core.c 2010-01-08 18:55:16.000000000 +0100
@@ -1342,7 +1342,7 @@ static int hid_reset_resume(struct usb_i

 #endif /* CONFIG_PM */

-static struct usb_device_id hid_usb_ids [] = {
+static const struct usb_device_id hid_usb_ids[] = {
 	{ .match_flags = USB_DEVICE_ID_MATCH_INT_CLASS,
 		.bInterfaceClass = USB_INTERFACE_CLASS_HID },
 	{ }						/* Terminating entry */
