Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbYASNUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbYASNUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 08:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYASNUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 08:20:09 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54556 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbYASNUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 08:20:06 -0500
Date: Sat, 19 Jan 2008 15:18:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: chas@cmf.nrl.navy.mil, jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] atm/suni.c: fix section mismatch
Message-ID: <20080119131851.GB8669@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL'ed code mustn't be __*init.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/drivers/atm/suni.c.old	2008-01-19 12:16:41.000000000 +0200
+++ linux-2.6/drivers/atm/suni.c	2008-01-19 12:17:23.000000000 +0200
@@ -275,35 +275,35 @@ static int suni_stop(struct atm_dev *dev
 	*walk = PRIV((*walk)->dev)->next;
 	if (!sunis) del_timer_sync(&poll_timer);
 	spin_unlock_irqrestore(&sunis_lock,flags);
 	kfree(PRIV(dev));
 
 	return 0;
 }
 
 
 static const struct atmphy_ops suni_ops = {
 	.start		= suni_start,
 	.ioctl		= suni_ioctl,
 	.interrupt	= suni_int,
 	.stop		= suni_stop,
 };
 
 
-int __devinit suni_init(struct atm_dev *dev)
+int suni_init(struct atm_dev *dev)
 {
 	unsigned char mri;
 
 	mri = GET(MRI); /* reset SUNI */
 	PUT(mri | SUNI_MRI_RESET,MRI);
 	PUT(mri,MRI);
 	PUT((GET(MT) & SUNI_MT_DS27_53),MT); /* disable all tests */
 	REG_CHANGE(SUNI_TPOP_APM_S,SUNI_TPOP_APM_S_SHIFT,SUNI_TPOP_S_SONET,
 	    TPOP_APM); /* use SONET */
 	REG_CHANGE(SUNI_TACP_IUCHP_CLP,0,SUNI_TACP_IUCHP_CLP,
 	    TACP_IUCHP); /* idle cells */
 	PUT(SUNI_IDLE_PATTERN,TACP_IUCPOP);
 	dev->phy = &suni_ops;
 	return 0;
 }
 
 EXPORT_SYMBOL(suni_init);

