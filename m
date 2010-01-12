Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300Ab0ALH6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0ALH6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 02:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619Ab0ALH6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 02:58:50 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:64973 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0ALH6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 02:58:49 -0500
X-Authuid: nmarci
Message-ID: <4B4C2BB2.5050308@freemail.hu>
Date: Tue, 12 Jan 2010 08:58:42 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH] dma: make Open Firmware device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=5 Fuz1=5
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
diff -u -p a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
--- a/drivers/dma/ppc4xx/adma.c 2010-01-07 19:08:39.000000000 +0100
+++ b/drivers/dma/ppc4xx/adma.c 2010-01-08 14:22:37.000000000 +0100
@@ -4940,7 +4940,7 @@ out_free:
 	return ret;
 }

-static struct of_device_id __devinitdata ppc440spe_adma_of_match[] = {
+static const struct of_device_id ppc440spe_adma_of_match[] __devinitconst = {
 	{ .compatible	= "ibm,dma-440spe", },
 	{ .compatible	= "amcc,xor-accelerator", },
 	{},
diff -u -p a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
--- a/drivers/dma/fsldma.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/dma/fsldma.c 2010-01-08 14:22:49.000000000 +0100
@@ -1274,7 +1274,7 @@ static int of_fsl_dma_remove(struct of_d
 	return 0;
 }

-static struct of_device_id of_fsl_dma_ids[] = {
+static const struct of_device_id of_fsl_dma_ids[] = {
 	{ .compatible = "fsl,eloplus-dma", },
 	{ .compatible = "fsl,elo-dma", },
 	{}
