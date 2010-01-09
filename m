Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013Ab0AIM42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0AIM42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 07:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588Ab0AIM4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 07:56:23 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:55926 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab0AIM4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 07:56:21 -0500
X-Authuid: nmarci
Message-ID: <4B487CEB.60003@freemail.hu>
Date: Sat, 09 Jan 2010 13:56:11 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Vojtech Pavlik <vojtech@ucw.cz>
CC: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] input: make pnp device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct pnp_driver is constant in <linux/pnp.h>
so it is worth to make pnp_devids also constant.

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
diff -u -p a/drivers/input/gameport/ns558.c b/drivers/input/gameport/ns558.c
--- a/drivers/input/gameport/ns558.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/input/gameport/ns558.c 2010-01-08 19:23:15.000000000 +0100
@@ -166,7 +166,7 @@ static int ns558_isa_probe(int io)

 #ifdef CONFIG_PNP

-static struct pnp_device_id pnp_devids[] = {
+static const struct pnp_device_id pnp_devids[] = {
 	{ .id = "@P@0001", .driver_data = 0 }, /* ALS 100 */
 	{ .id = "@P@0020", .driver_data = 0 }, /* ALS 200 */
 	{ .id = "@P@1001", .driver_data = 0 }, /* ALS 100+ */
