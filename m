Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835Ab0AJRAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0AJRAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 12:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525Ab0AJQ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 11:59:44 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:58141 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab0AJQ7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 11:59:43 -0500
X-Authuid: nmarci
Message-ID: <4B4A0778.2000508@freemail.hu>
Date: Sun, 10 Jan 2010 17:59:36 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: linux-serial@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH 2/3] serial: make dio device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32711; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct dio_driver is constant in <linux/dio.h>
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
diff -u -p a/drivers/serial/8250_hp300.c b/drivers/serial/8250_hp300.c
--- a/drivers/serial/8250_hp300.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/serial/8250_hp300.c 2010-01-08 18:52:23.000000000 +0100
@@ -39,7 +39,7 @@ static int __devinit hpdca_init_one(stru
 					const struct dio_device_id *ent);
 static void __devexit hpdca_remove_one(struct dio_dev *d);

-static struct dio_device_id hpdca_dio_tbl[] = {
+static const struct dio_device_id hpdca_dio_tbl[] = {
 	{ DIO_ID_DCA0 },
 	{ DIO_ID_DCA0REM },
 	{ DIO_ID_DCA1 },
