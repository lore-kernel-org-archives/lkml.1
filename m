Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306Ab0AIXSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0AIXSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217Ab0AIXSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:18:52 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:60127 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0AIXSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:18:51 -0500
X-Authuid: nmarci
Message-ID: <4B490ED1.6090705@freemail.hu>
Date: Sun, 10 Jan 2010 00:18:41 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH 3/3] staging: make i2c device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32711; Body=5 Fuz1=5
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
diff -u -p a/drivers/staging/go7007/wis-sony-tuner.c b/drivers/staging/go7007/wis-sony-tuner.c
--- a/drivers/staging/go7007/wis-sony-tuner.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/go7007/wis-sony-tuner.c 2010-01-08 10:41:22.000000000 +0100
@@ -688,7 +688,7 @@ static int wis_sony_tuner_remove(struct
 	return 0;
 }

-static struct i2c_device_id wis_sony_tuner_id[] = {
+static const struct i2c_device_id wis_sony_tuner_id[] = {
 	{ "wis_sony_tuner", 0 },
 	{ }
 };
diff -u -p a/drivers/staging/go7007/wis-ov7640.c b/drivers/staging/go7007/wis-ov7640.c
--- a/drivers/staging/go7007/wis-ov7640.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/go7007/wis-ov7640.c 2010-01-08 10:41:49.000000000 +0100
@@ -77,7 +77,7 @@ static int wis_ov7640_remove(struct i2c_
 	return 0;
 }

-static struct i2c_device_id wis_ov7640_id[] = {
+static const struct i2c_device_id wis_ov7640_id[] = {
 	{ "wis_ov7640", 0 },
 	{ }
 };
diff -u -p a/drivers/staging/go7007/wis-tw9903.c b/drivers/staging/go7007/wis-tw9903.c
--- a/drivers/staging/go7007/wis-tw9903.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/go7007/wis-tw9903.c 2010-01-08 10:41:54.000000000 +0100
@@ -309,7 +309,7 @@ static int wis_tw9903_remove(struct i2c_
 	return 0;
 }

-static struct i2c_device_id wis_tw9903_id[] = {
+static const struct i2c_device_id wis_tw9903_id[] = {
 	{ "wis_tw9903", 0 },
 	{ }
 };
diff -u -p a/drivers/staging/go7007/wis-saa7113.c b/drivers/staging/go7007/wis-saa7113.c
--- a/drivers/staging/go7007/wis-saa7113.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/go7007/wis-saa7113.c 2010-01-08 10:41:59.000000000 +0100
@@ -304,7 +304,7 @@ static int wis_saa7113_remove(struct i2c
 	return 0;
 }

-static struct i2c_device_id wis_saa7113_id[] = {
+static const struct i2c_device_id wis_saa7113_id[] = {
 	{ "wis_saa7113", 0 },
 	{ }
 };
diff -u -p a/drivers/staging/go7007/s2250-board.c b/drivers/staging/go7007/s2250-board.c
--- a/drivers/staging/go7007/s2250-board.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/staging/go7007/s2250-board.c 2010-01-08 10:42:39.000000000 +0100
@@ -667,7 +667,7 @@ static int s2250_remove(struct i2c_clien
 	return 0;
 }

-static struct i2c_device_id s2250_id[] = {
+static const struct i2c_device_id s2250_id[] = {
 	{ "s2250", 0 },
 	{ }
 };
diff -u -p a/drivers/staging/go7007/wis-saa7115.c b/drivers/staging/go7007/wis-saa7115.c
--- a/drivers/staging/go7007/wis-saa7115.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/go7007/wis-saa7115.c 2010-01-08 10:42:45.000000000 +0100
@@ -437,7 +437,7 @@ static int wis_saa7115_remove(struct i2c
 	return 0;
 }

-static struct i2c_device_id wis_saa7115_id[] = {
+static const struct i2c_device_id wis_saa7115_id[] = {
 	{ "wis_saa7115", 0 },
 	{ }
 };
diff -u -p a/drivers/staging/go7007/wis-tw2804.c b/drivers/staging/go7007/wis-tw2804.c
--- a/drivers/staging/go7007/wis-tw2804.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/go7007/wis-tw2804.c 2010-01-08 10:42:50.000000000 +0100
@@ -327,7 +327,7 @@ static int wis_tw2804_remove(struct i2c_
 	return 0;
 }

-static struct i2c_device_id wis_tw2804_id[] = {
+static const struct i2c_device_id wis_tw2804_id[] = {
 	{ "wis_tw2804", 0 },
 	{ }
 };
diff -u -p a/drivers/staging/go7007/wis-uda1342.c b/drivers/staging/go7007/wis-uda1342.c
--- a/drivers/staging/go7007/wis-uda1342.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/staging/go7007/wis-uda1342.c 2010-01-08 10:40:18.000000000 +0100
@@ -82,7 +82,7 @@ static int wis_uda1342_remove(struct i2c
 	return 0;
 }

-static struct i2c_device_id wis_uda1342_id[] = {
+static const struct i2c_device_id wis_uda1342_id[] = {
 	{ "wis_uda1342", 0 },
 	{ }
 };
