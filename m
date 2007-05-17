Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXEQNSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXEQNSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 09:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbXEQNSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 09:18:38 -0400
Received: from h182.mvista.com ([63.81.120.155]:23345 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754797AbXEQNSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 09:18:37 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: mingo@elte.hu, tglx@linutronix.de
Subject: [PATCH 2.6.21-rt2] PowerPC: revert fix for threaded fasteoi IRQ handlers
Date: Thu, 17 May 2007 17:20:08 +0400
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, dwalker@mvista.com
References: <200611192243.34850.sshtylyov@ru.mvista.com>
In-Reply-To: <200611192243.34850.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705171719.34968.sshtylyov@ru.mvista.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Revert the change to the "fasteoi" type chips as after handle_fasteoi_irq() had
been fixed, they've become meaningless (and even dangerous -- as was the case
with Celleb that has been fixed earlier)...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch in question wasn't even initially accepted but then was erroneously
restored along with the TOD patch.  I've asked to revert it but to no avail,
so here's the formal patch to revert it at last...

 arch/powerpc/platforms/iseries/irq.c  |    1 -
 arch/powerpc/platforms/pseries/xics.c |    2 --
 arch/powerpc/sysdev/mpic.c            |    1 -
 3 files changed, 4 deletions(-)

Index: linux-2.6/arch/powerpc/platforms/iseries/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/iseries/irq.c
+++ linux-2.6/arch/powerpc/platforms/iseries/irq.c
@@ -279,7 +279,6 @@ static struct irq_chip iseries_pic = {
 	.shutdown	= iseries_shutdown_IRQ,
 	.unmask		= iseries_enable_IRQ,
 	.mask		= iseries_disable_IRQ,
-	.ack		= iseries_end_IRQ,
 	.eoi		= iseries_end_IRQ
 };
 
Index: linux-2.6/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6/arch/powerpc/platforms/pseries/xics.c
@@ -456,7 +456,6 @@ static struct irq_chip xics_pic_direct =
 	.startup = xics_startup,
 	.mask = xics_mask_irq,
 	.unmask = xics_unmask_irq,
-	.ack = xics_eoi_direct,
 	.eoi = xics_eoi_direct,
 	.set_affinity = xics_set_affinity
 };
@@ -467,7 +466,6 @@ static struct irq_chip xics_pic_lpar = {
 	.startup = xics_startup,
 	.mask = xics_mask_irq,
 	.unmask = xics_unmask_irq,
-	.ack = xics_eoi_lpar,
 	.eoi = xics_eoi_lpar,
 	.set_affinity = xics_set_affinity
 };
Index: linux-2.6/arch/powerpc/sysdev/mpic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic.c
+++ linux-2.6/arch/powerpc/sysdev/mpic.c
@@ -776,7 +776,6 @@ static int mpic_set_irq_type(unsigned in
 static struct irq_chip mpic_irq_chip = {
 	.mask		= mpic_mask_irq,
 	.unmask		= mpic_unmask_irq,
-	.ack		= mpic_end_irq,
 	.eoi		= mpic_end_irq,
 	.set_type	= mpic_set_irq_type,
 };

