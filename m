Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171Ab0AJLUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0AJLUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 06:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308Ab0AJLUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 06:20:33 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:52166 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0AJLUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 06:20:33 -0500
X-Authuid: nmarci
Message-ID: <4B49B7FB.4020402@freemail.hu>
Date: Sun, 10 Jan 2010 12:20:27 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Doug Thompson <dougthompson@xmission.com>,
       Grant Erickson <gerickson@nuovations.com>,
       Dave Jiang <djiang@mvista.com>
CC: bluesmoke-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH] edac: make Open Firmware device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32711; Body=7 Fuz1=7
	Fuz2=7
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
diff -u -p a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
--- a/drivers/edac/ppc4xx_edac.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/edac/ppc4xx_edac.c 2010-01-08 04:46:11.000000000 +0100
@@ -194,7 +194,7 @@ static int ppc4xx_edac_remove(struct of_
  * Device tree node type and compatible tuples this driver can match
  * on.
  */
-static struct of_device_id ppc4xx_edac_match[] = {
+static const struct of_device_id ppc4xx_edac_match[] = {
 	{
 		.compatible	= "ibm,sdram-4xx-ddr2"
 	},
diff -u -p a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/edac/mpc85xx_edac.c 2010-01-08 04:46:17.000000000 +0100
@@ -328,7 +328,7 @@ static int mpc85xx_pci_err_remove(struct
 	return 0;
 }

-static struct of_device_id mpc85xx_pci_err_of_match[] = {
+static const struct of_device_id mpc85xx_pci_err_of_match[] = {
 	{
 	 .compatible = "fsl,mpc8540-pcix",
 	 },
@@ -633,7 +633,7 @@ static int mpc85xx_l2_err_remove(struct
 	return 0;
 }

-static struct of_device_id mpc85xx_l2_err_of_match[] = {
+static const struct of_device_id mpc85xx_l2_err_of_match[] = {
 /* deprecate the fsl,85.. forms in the future, 2.6.30? */
 	{ .compatible = "fsl,8540-l2-cache-controller", },
 	{ .compatible = "fsl,8541-l2-cache-controller", },
@@ -973,7 +973,7 @@ static int mpc85xx_mc_err_remove(struct
 	return 0;
 }

-static struct of_device_id mpc85xx_mc_err_of_match[] = {
+static const struct of_device_id mpc85xx_mc_err_of_match[] = {
 /* deprecate the fsl,85.. forms in the future, 2.6.30? */
 	{ .compatible = "fsl,8540-memory-controller", },
 	{ .compatible = "fsl,8541-memory-controller", },
