Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbZCPSnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbZCPSnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZCPSnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:43:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53887 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbZCPSnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:43:06 -0400
Date: Mon, 16 Mar 2009 18:42:27 GMT
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, linuxppc-dev@ozlabs.org, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, linuxppc-dev@ozlabs.org, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20090316185256.4a160374.sfr@canb.auug.org.au>
References: <20090316185256.4a160374.sfr@canb.auug.org.au>
Subject: [tip:irq/sparseirq] sparseirq, powerpc/cell: fix unused variable warning in interrupt.c
Message-ID: <tip-a6bc3262c561780d2a6587aa3d5715b1e7d8fa13@git.kernel.org>
Git-Commit-ID: a6bc3262c561780d2a6587aa3d5715b1e7d8fa13
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 18:42:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6bc3262c561780d2a6587aa3d5715b1e7d8fa13
Gitweb:     http://git.kernel.org/tip/a6bc3262c561780d2a6587aa3d5715b1e7d8fa13
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Mon, 16 Mar 2009 18:52:56 +1100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Mar 2009 09:21:57 +0100

sparseirq, powerpc/cell: fix unused variable warning in interrupt.c

This new compiler warning:

   arch/powerpc/platforms/cell/interrupt.c: In function 'handle_iic_irq':
   arch/powerpc/platforms/cell/interrupt.c:240: warning: unused variable 'cpu'

Triggers because the local variable 'cpu' became unused due to commit:

   dee4102: sparseirq: use kstat_irqs_cpu instead

Remove the variable.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: ppc-dev <linuxppc-dev@ozlabs.org>
LKML-Reference: <20090316185256.4a160374.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/platforms/cell/interrupt.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 1f0d774..882e470 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -237,8 +237,6 @@ extern int noirqdebug;
 
 static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
 {
-	const unsigned int cpu = smp_processor_id();
-
 	spin_lock(&desc->lock);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
