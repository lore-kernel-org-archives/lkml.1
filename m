Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbZKFWnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbZKFWnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933233AbZKFWmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:42:14 -0500
Received: from www.tglx.de ([62.245.132.106]:54049 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933211AbZKFWmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:42:06 -0500
Message-Id: <20091106223806.762624109@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:41:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: [patch 09/16] powerpc: Replace old style lock initializer
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline; filename=power-replace-old-style-lock-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated. Init the lock array at runtime
instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/platforms/iseries/htab.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/powerpc/platforms/iseries/htab.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/iseries/htab.c
+++ linux-2.6/arch/powerpc/platforms/iseries/htab.c
@@ -19,8 +19,7 @@
 
 #include "call_hpt.h"
 
-static spinlock_t iSeries_hlocks[64] __cacheline_aligned_in_smp =
-	{ [0 ... 63] = SPIN_LOCK_UNLOCKED};
+static spinlock_t iSeries_hlocks[64] __cacheline_aligned_in_smp;
 
 /*
  * Very primitive algorithm for picking up a lock
@@ -245,6 +244,11 @@ static void iSeries_hpte_invalidate(unsi
 
 void __init hpte_init_iSeries(void)
 {
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(iSeries_hlocks); i++)
+		spin_lock_init(&iSeries_hlocks[i]);
+
 	ppc_md.hpte_invalidate	= iSeries_hpte_invalidate;
 	ppc_md.hpte_updatepp	= iSeries_hpte_updatepp;
 	ppc_md.hpte_updateboltedpp = iSeries_hpte_updateboltedpp;


