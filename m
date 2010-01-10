Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259Ab0AJMjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab0AJMjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 07:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194Ab0AJMjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 07:39:47 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:64486 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0AJMjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 07:39:46 -0500
X-Authuid: nmarci
Message-ID: <4B49CA8B.2020108@freemail.hu>
Date: Sun, 10 Jan 2010 13:39:39 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH 2/5] block: make USB device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=4 Fuz1=4
	Fuz2=9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct usb_device_id is constant in <linux/usb.h>
so it is worth to make ub_usb_ids also constant.

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
diff -u -p a/drivers/block/ub.c b/drivers/block/ub.c
--- a/drivers/block/ub.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/block/ub.c 2010-01-08 09:14:49.000000000 +0100
@@ -393,7 +393,7 @@ static int ub_probe_lun(struct ub_dev *s
 #define ub_usb_ids  usb_storage_usb_ids
 #else

-static struct usb_device_id ub_usb_ids[] = {
+static const struct usb_device_id ub_usb_ids[] = {
 	{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, US_SC_SCSI, US_PR_BULK) },
 	{ }
 };
