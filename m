Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200Ab0ALICH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0ALICH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542Ab0ALICF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:02:05 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:50250 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab0ALICD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:02:03 -0500
X-Authuid: nmarci
Message-ID: <4B4C2C69.9000804@freemail.hu>
Date: Tue, 12 Jan 2010 09:01:45 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
CC: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH] crypto: make Open Firmware device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=6 Fuz1=6
	Fuz2=6
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
diff -u -p a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
--- a/drivers/crypto/talitos.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/crypto/talitos.c 2010-01-08 14:16:24.000000000 +0100
@@ -1958,7 +1958,7 @@ err_out:
 	return err;
 }

-static struct of_device_id talitos_match[] = {
+static const struct of_device_id talitos_match[] = {
 	{
 		.compatible = "fsl,sec2.0",
 	},
diff -u -p a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
--- a/drivers/crypto/amcc/crypto4xx_core.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/crypto/amcc/crypto4xx_core.c 2010-01-08 14:16:45.000000000 +0100
@@ -1274,7 +1274,7 @@ static int __exit crypto4xx_remove(struc
 	return 0;
 }

-static struct of_device_id crypto4xx_match[] = {
+static const struct of_device_id crypto4xx_match[] = {
 	{ .compatible      = "amcc,ppc4xx-crypto",},
 	{ },
 };
