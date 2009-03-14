Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbZCNAzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbZCNAzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZCNAz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:55:26 -0400
Received: from n15.bullet.mail.mud.yahoo.com ([68.142.206.42]:29229 "HELO
	n15.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752165AbZCNAzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:55:24 -0400
X-Yahoo-Newman-Id: 307581.34537.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=f5ZwXm5wdpeNz639FiJCrjB7h6aBPilLJVMHwTgRBqN8CJ48x0MrUAcRhgPdmN5o50BWGjibWk3Y4Ho7X11HPLJDCGFY4STD7+VQn6Yh/KstoWoo4ckR4eimgYQs4MyT4EP1g0L5rXJ4fmryTuD/qDQGHePj2D6De2Rv5+Ugfac=  ;
X-YMail-OSG: sSEBL.MVM1kDn_ZDxa824vl.KVC1nj.LDfwZy1FediemdiHU8scHVcsbXfHtmfrMufJFbtO9r8O34_PV0cDQv2SqeWJSoQ.38izIYCVDjd24h2JJoe1IwSYdNa9KA1WvlkoRDvbANXqwalEfMaorIJZwz_PUry9KhCwDVYE4C300Qa2rePbY_Qe5IgjIJwLWOw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [patch] twl4030-regulator: expose VPLL2
Date: Fri, 13 Mar 2009 17:54:54 -0700
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@sirena.org.uk>, OMAP <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903131754.54997.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add VPLL2 to the set of twl4030-family regulators exposed for
use by various drivers.  It's commonly used to power the digital
video outputs (e.g. LCD or DVI displays) on OMAP3 systems.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Please apply to regulator-next and linux-omap ... I'll send
some patches configuring various OMAP boards to use this.

 drivers/mfd/twl4030-core.c            |    2 --
 drivers/regulator/twl4030-regulator.c |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -613,11 +613,9 @@ add_children(struct twl4030_platform_dat
 
 	/* maybe add LDOs that are omitted on cost-reduced parts */
 	if (twl_has_regulator() && !(features & TPS_SUBSET)) {
-		/*
 		child = add_regulator(TWL4030_REG_VPLL2, pdata->vpll2);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
-		*/
 
 		child = add_regulator(TWL4030_REG_VMMC2, pdata->vmmc2);
 		if (IS_ERR(child))
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -404,8 +404,8 @@ static struct twlreg_info twl4030_regs[]
 	TWL_ADJUSTABLE_LDO(VMMC2, 0x2b, 6),
 	/*
 	TWL_ADJUSTABLE_LDO(VPLL1, 0x2f, 7),
-	TWL_ADJUSTABLE_LDO(VPLL2, 0x33, 8),
 	*/
+	TWL_ADJUSTABLE_LDO(VPLL2, 0x33, 8),
 	TWL_ADJUSTABLE_LDO(VSIM, 0x37, 9),
 	TWL_ADJUSTABLE_LDO(VDAC, 0x3b, 10),
 	/*

