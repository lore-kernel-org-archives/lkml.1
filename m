Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676Ab0AIOKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0AIOKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 09:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662Ab0AIOKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 09:10:52 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:57901 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab0AIOKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 09:10:49 -0500
Message-ID: <4B488E60.4070604@freemail.hu>
Date: Sat, 09 Jan 2010 15:10:40 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-mtd@lists.infradead.org, Julia Lawall <julia@diku.dk>, cocci@diku.dk,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] nand: make USB device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=5 Fuz1=5
	Fuz2=13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct usb_device_id is constant in <linux/usb.h>
so it is worth to make alauda_table also constant.

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
diff -u -p a/drivers/mtd/nand/alauda.c b/drivers/mtd/nand/alauda.c
--- a/drivers/mtd/nand/alauda.c 2010-01-07 19:08:42.000000000 +0100
+++ b/drivers/mtd/nand/alauda.c 2010-01-08 04:26:29.000000000 +0100
@@ -49,7 +49,7 @@

 #define TIMEOUT HZ

-static struct usb_device_id alauda_table [] = {
+static const struct usb_device_id alauda_table[] = {
 	{ USB_DEVICE(0x0584, 0x0008) },	/* Fujifilm DPC-R1 */
 	{ USB_DEVICE(0x07b4, 0x010a) },	/* Olympus MAUSB-10 */
 	{ }
