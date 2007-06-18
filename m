Return-Path: <linux-kernel-owner+w=401wt.eu-S1763308AbXFRVDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308AbXFRVDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760279AbXFRVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:03:44 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:52770 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715AbXFRVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:03:44 -0400
Message-Id: <20070618210341.967108783@fluff.org.uk>
References: <20070618205620.284044146@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 21:56:23 +0100
From: ben@fluff.org.uk
To: ben@fluff.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sm5xx-devel@lists.berlios.de
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [patch #2 3/6] SM501: Fix sm501_init_reg() mask/set order
Content-Disposition: inline; filename=simtec-drivers-mfd-sm501-reginitfix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The order of the set and mask operation in sm501_init_reg()
was setting and then masking the bits set. Correct the order
so that we do not end up with 288MHz SDRAM clocks on certain
systems.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.21-quilt8/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.21-quilt8.orig/drivers/mfd/sm501.c	2007-06-07 12:13:03.000000000 +0100
+++ linux-2.6.21-quilt8/drivers/mfd/sm501.c	2007-06-07 12:13:06.000000000 +0100
@@ -803,6 +803,9 @@ static DEVICE_ATTR(dbg_regs, 0666, sm501
 /* sm501_init_reg
  *
  * Helper function for the init code to setup a register
+ *
+ * clear the bits which are set in r->mask, and then set
+ * the bits set in r->set.
 */
 
 static inline void sm501_init_reg(struct sm501_devdata *sm,
@@ -812,8 +815,8 @@ static inline void sm501_init_reg(struct
 	unsigned long tmp;
 
 	tmp = readl(sm->regs + reg);
-	tmp |= r->set;
 	tmp &= ~r->mask;
+	tmp |= r->set;
 	writel(tmp, sm->regs + reg);
 }
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
