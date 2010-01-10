Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271Ab0AJMOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0AJMOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 07:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207Ab0AJMOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 07:14:20 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:50928 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0AJMOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 07:14:19 -0500
X-Authuid: nmarci
Message-ID: <4B49C496.2090507@freemail.hu>
Date: Sun, 10 Jan 2010 13:14:14 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
CC: spi-devel-general@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH] spi: make Open Firmware device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=6 Fuz1=6
	Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The match_table field of the struct of_device_id is constant in <linux/of_platform.h>
so it is worth to make the initialization data constant.

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
diff -u -p a/drivers/spi/xilinx_spi_of.c b/drivers/spi/xilinx_spi_of.c
--- a/drivers/spi/xilinx_spi_of.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/spi/xilinx_spi_of.c 2010-01-08 09:11:27.000000000 +0100
@@ -99,7 +99,7 @@ static int __exit xilinx_spi_of_remove(s
 	return xilinx_spi_remove(op);
 }

-static struct of_device_id xilinx_spi_of_match[] = {
+static const struct of_device_id xilinx_spi_of_match[] = {
 	{ .compatible = "xlnx,xps-spi-2.00.a", },
 	{ .compatible = "xlnx,xps-spi-2.00.b", },
 	{}
diff -u -p a/drivers/spi/mpc52xx_spi.c b/drivers/spi/mpc52xx_spi.c
--- a/drivers/spi/mpc52xx_spi.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/spi/mpc52xx_spi.c 2010-01-08 09:11:55.000000000 +0100
@@ -550,7 +550,7 @@ static int __devexit mpc52xx_spi_remove(
 	return 0;
 }

-static struct of_device_id mpc52xx_spi_match[] __devinitdata = {
+static const struct of_device_id mpc52xx_spi_match[] __devinitconst = {
 	{ .compatible = "fsl,mpc5200-spi", },
 	{}
 };
diff -u -p a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/spi/mpc52xx_psc_spi.c 2010-01-08 09:13:23.000000000 +0100
@@ -503,7 +503,7 @@ static int __exit mpc52xx_psc_spi_of_rem
 	return mpc52xx_psc_spi_do_remove(&op->dev);
 }

-static struct of_device_id mpc52xx_psc_spi_of_match[] = {
+static const struct of_device_id mpc52xx_psc_spi_of_match[] = {
 	{ .compatible = "fsl,mpc5200-psc-spi", },
 	{ .compatible = "mpc5200-psc-spi", }, /* old */
 	{}
diff -u -p a/drivers/spi/spi_ppc4xx.c b/drivers/spi/spi_ppc4xx.c
--- a/drivers/spi/spi_ppc4xx.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/spi/spi_ppc4xx.c 2010-01-08 09:13:36.000000000 +0100
@@ -578,7 +578,7 @@ static int __exit spi_ppc4xx_of_remove(s
 	return 0;
 }

-static struct of_device_id spi_ppc4xx_of_match[] = {
+static const struct of_device_id spi_ppc4xx_of_match[] = {
 	{ .compatible = "ibm,ppc4xx-spi", },
 	{},
 };
