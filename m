Return-Path: <linux-kernel-owner+w=401wt.eu-S1762153AbYCDGxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762153AbYCDGxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYCDGx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:53:27 -0500
Received: from rex.snapgear.com ([203.143.235.140]:38402 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754061AbYCDGx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:53:26 -0500
Date: Tue, 4 Mar 2008 16:52:01 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200803040652.m246q1SH012800@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix fec driver interrupt races
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FEC driver has a common interrupt handler for all interrupt event
types. It is raised on a number of distinct interrupt vectors.
This handler can't be re-entered while processing an interrupt, so
make sure all requested vectors are flagged as IRQF_DISABLED.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.25-rc3/drivers/net/fec.c linux-2.6.25-rc3.foo/drivers/net/fec.c
--- linux-2.6.25-rc3/drivers/net/fec.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.25-rc3.foo/drivers/net/fec.c	2008-03-04 16:38:31.000000000 +1000
@@ -1253,7 +1253,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(idp->irq, idp->handler, 0, idp->name, dev) != 0)
+		if (request_irq(idp->irq, idp->handler, IRQF_DISABLED, idp->name, dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n", idp->name, idp->irq);
 	}
 
@@ -1382,7 +1382,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(b+idp->irq, fec_enet_interrupt, 0, idp->name, dev) != 0)
+		if (request_irq(b+idp->irq, fec_enet_interrupt, IRQF_DISABLED, idp->name, dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n", idp->name, b+idp->irq);
 	}
 
@@ -1553,7 +1553,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(b+idp->irq,fec_enet_interrupt,0,idp->name,dev)!=0)
+		if (request_irq(b+idp->irq, fec_enet_interrupt, IRQF_DISABLED, idp->name,dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n", idp->name, b+idp->irq);
 	}
 
@@ -1680,7 +1680,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(b+idp->irq,fec_enet_interrupt,0,idp->name,dev)!=0)
+		if (request_irq(b+idp->irq, fec_enet_interrupt, IRQF_DISABLED, idp->name,dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n",
 				idp->name, b+idp->irq);
 	}
