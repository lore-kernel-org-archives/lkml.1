Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbXFNKBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbXFNKBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXFNKBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:01:38 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:63399 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbXFNKBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:01:38 -0400
Message-Id: <20070614100136.038869779@fluff.org.uk>
References: <20070614100109.192172553@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 11:01:12 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Ben Dooks <ben-linux@fluff.org>
Subject: [patch 3/6] SM501: Fix sm501_init_reg() mask/set order
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
