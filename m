Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691Ab0AIOK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0AIOK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 09:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678Ab0AIOK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 09:10:56 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:53175 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab0AIOKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 09:10:55 -0500
X-Authuid: nmarci
Message-ID: <4B488E66.6080107@freemail.hu>
Date: Sat, 09 Jan 2010 15:10:46 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, Joern Engel <joern@logfs.org>
CC: linux-mtd@lists.infradead.org, Julia Lawall <julia@diku.dk>, cocci@diku.dk,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] nand: make Open Firmware device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32721; Body=6 Fuz1=6
	Fuz2=6
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
diff -u -p a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
--- a/drivers/mtd/nand/pasemi_nand.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/mtd/nand/pasemi_nand.c 2010-01-08 04:26:40.000000000 +0100
@@ -209,7 +209,7 @@ static int __devexit pasemi_nand_remove(
 	return 0;
 }

-static struct of_device_id pasemi_nand_match[] =
+static const struct of_device_id pasemi_nand_match[] =
 {
 	{
 		.compatible   = "pasemi,localbus-nand",
diff -u -p a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
--- a/drivers/mtd/nand/fsl_upm.c 2010-01-07 19:08:42.000000000 +0100
+++ b/drivers/mtd/nand/fsl_upm.c 2010-01-08 04:28:52.000000000 +0100
@@ -349,7 +349,7 @@ static int __devexit fun_remove(struct o
 	return 0;
 }

-static struct of_device_id of_fun_match[] = {
+static const struct of_device_id of_fun_match[] = {
 	{ .compatible = "fsl,upm-nand" },
 	{},
 };
diff -u -p a/drivers/mtd/nand/socrates_nand.c b/drivers/mtd/nand/socrates_nand.c
--- a/drivers/mtd/nand/socrates_nand.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/mtd/nand/socrates_nand.c 2010-01-08 04:29:01.000000000 +0100
@@ -290,7 +290,7 @@ static int __devexit socrates_nand_remov
 	return 0;
 }

-static struct of_device_id socrates_nand_match[] =
+static const struct of_device_id socrates_nand_match[] =
 {
 	{
 		.compatible   = "abb,socrates-nand",
