Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962Ab0AIM4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab0AIM4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 07:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088Ab0AIM4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 07:56:08 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:62177 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0AIM4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 07:56:07 -0500
Message-ID: <4B487CDC.80303@freemail.hu>
Date: Sat, 09 Jan 2010 13:55:56 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] input: make Open Firmware device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The match_table field of the struct of_device_id is constant in <linux/of_platform.h>
so it is worth to make xps2_of_match also constant.

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
diff -u -p a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
--- a/drivers/input/serio/xilinx_ps2.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/input/serio/xilinx_ps2.c 2010-01-08 19:13:45.000000000 +0100
@@ -354,7 +354,7 @@ static int __devexit xps2_of_remove(stru
 }

 /* Match table for of_platform binding */
-static struct of_device_id xps2_of_match[] __devinitdata = {
+static const struct of_device_id xps2_of_match[] __devinitconst = {
 	{ .compatible = "xlnx,xps-ps2-1.00.a", },
 	{ /* end of list */ },
 };
