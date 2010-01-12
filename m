Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563Ab0ALH4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0ALH4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 02:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530Ab0ALH4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 02:56:19 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:54186 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab0ALH4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 02:56:18 -0500
X-Authuid: nmarci
Message-ID: <4B4C2B1D.9030401@freemail.hu>
Date: Tue, 12 Jan 2010 08:56:13 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: linux-pcmcia@lists.infradead.org
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH] pcmcia: make Open Firmware device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32711; Body=4 Fuz1=4
	Fuz2=4
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
diff -u -p a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
--- a/drivers/pcmcia/electra_cf.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/pcmcia/electra_cf.c 2010-01-08 14:35:41.000000000 +0100
@@ -347,7 +347,7 @@ static int __devexit electra_cf_remove(s
 	return 0;
 }

-static struct of_device_id electra_cf_match[] = {
+static const struct of_device_id electra_cf_match[] = {
 	{
 		.compatible   = "electra-cf",
 	},
diff -u -p a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
--- a/drivers/pcmcia/m8xx_pcmcia.c 2010-01-07 19:08:44.000000000 +0100
+++ b/drivers/pcmcia/m8xx_pcmcia.c 2010-01-08 14:36:19.000000000 +0100
@@ -1303,7 +1303,7 @@ static int m8xx_resume(struct platform_d
 #define m8xx_resume NULL
 #endif

-static struct of_device_id m8xx_pcmcia_match[] = {
+static const struct of_device_id m8xx_pcmcia_match[] = {
 	{
 	 .type = "pcmcia",
 	 .compatible = "fsl,pq-pcmcia",
