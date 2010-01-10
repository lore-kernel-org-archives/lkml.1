Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984Ab0AJLnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab0AJLnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 06:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344Ab0AJLnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 06:43:21 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:57777 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0AJLnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 06:43:20 -0500
X-Authuid: nmarci
Message-ID: <4B49BD52.4080109@freemail.hu>
Date: Sun, 10 Jan 2010 12:43:14 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH] macintosh: make Open Firmware device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02a.mail.t-online.hu 32711; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The match_table field of the struct of_device_id is constant in <linux/of_platform.h>
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
diff -u -p a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
--- a/drivers/macintosh/therm_windtunnel.c 2010-01-07 19:08:40.000000000 +0100
+++ b/drivers/macintosh/therm_windtunnel.c 2010-01-08 04:47:10.000000000 +0100
@@ -457,7 +457,7 @@ therm_of_remove( struct of_device *dev )
 	return 0;
 }

-static struct of_device_id therm_of_match[] = {{
+static const struct of_device_id therm_of_match[] = {{
 	.name		= "fan",
 	.compatible	= "adm1030"
     }, {}
diff -u -p a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
--- a/drivers/macintosh/smu.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/macintosh/smu.c 2010-01-08 04:47:28.000000000 +0100
@@ -660,7 +660,7 @@ static int smu_platform_probe(struct of_
 	return 0;
 }

-static struct of_device_id smu_platform_match[] =
+static const struct of_device_id smu_platform_match[] =
 {
 	{
 		.type		= "smu",
diff -u -p a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
--- a/drivers/macintosh/therm_pm72.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/macintosh/therm_pm72.c 2010-01-08 04:50:17.000000000 +0100
@@ -2211,7 +2211,7 @@ static int fcu_of_remove(struct of_devic
 	return 0;
 }

-static struct of_device_id fcu_match[] =
+static const struct of_device_id fcu_match[] =
 {
 	{
 	.type		= "fcu",
