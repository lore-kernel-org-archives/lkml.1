Return-Path: <linux-kernel-owner+w=401wt.eu-S1751843Ab0AIM4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab0AIM4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 07:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254Ab0AIMz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 07:55:59 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:65306 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab0AIMz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 07:55:58 -0500
Message-ID: <4B487CD3.3080908@freemail.hu>
Date: Sat, 09 Jan 2010 13:55:47 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Raphael Derosso Pereira <raphaelpereira@gmail.com>,
       Kwangwoo Lee <kwlee@mtekvision.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
CC: Jochen Eisinger <jochen@penguin-breeder.org>, linux-input@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] input: make i2c device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32711; Body=7 Fuz1=7
	Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct i2c_driver is constant in <linux/i2c.h>
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
diff -u -p a/drivers/input/keyboard/qt2160.c b/drivers/input/keyboard/qt2160.c
--- a/drivers/input/keyboard/qt2160.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/input/keyboard/qt2160.c 2010-01-08 19:01:56.000000000 +0100
@@ -362,7 +362,7 @@ static int __devexit qt2160_remove(struc
 	return 0;
 }

-static struct i2c_device_id qt2160_idtable[] = {
+static const struct i2c_device_id qt2160_idtable[] = {
 	{ "qt2160", 0, },
 	{ }
 };
diff -u -p a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
--- a/drivers/input/touchscreen/tsc2007.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/input/touchscreen/tsc2007.c 2010-01-08 19:15:29.000000000 +0100
@@ -358,7 +358,7 @@ static int __devexit tsc2007_remove(stru
 	return 0;
 }

-static struct i2c_device_id tsc2007_idtable[] = {
+static const struct i2c_device_id tsc2007_idtable[] = {
 	{ "tsc2007", 0 },
 	{ }
 };
diff -u -p a/drivers/input/misc/apanel.c b/drivers/input/misc/apanel.c
--- a/drivers/input/misc/apanel.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/input/misc/apanel.c 2010-01-08 19:22:03.000000000 +0100
@@ -149,7 +149,7 @@ static void apanel_shutdown(struct i2c_c
 	apanel_remove(client);
 }

-static struct i2c_device_id apanel_id[] = {
+static const struct i2c_device_id apanel_id[] = {
 	{ "fujitsu_apanel", 0 },
 	{ }
 };
