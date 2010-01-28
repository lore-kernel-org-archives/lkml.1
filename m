Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262Ab0A1XUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab0A1XUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212Ab0A1XUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:20:49 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:60951 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab0A1XUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:20:45 -0500
Subject: [PATCHv3 1/2] sched: enable ARCH_POWER
From: Joel Schopp <jschopp@austin.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: ego@in.ibm.com, linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       jschopp@austin.ibm.com
In-Reply-To: <1264548486.12239.55.camel@jschopp-laptop>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017764.5717.127.camel@jschopp-laptop>
	 <1264548486.12239.55.camel@jschopp-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 17:20:33 -0600
Message-ID: <1264720833.9660.21.camel@jschopp-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the scheduler feature that allows use of arch_scale_smt_power.  Stub out
the broken x86 implementation.

Signed-off-by: Joel Schopp <jschopp@austin.ibm.com>
---
Index: linux-2.6.git/kernel/sched_features.h
===================================================================
--- linux-2.6.git.orig/kernel/sched_features.h
+++ linux-2.6.git/kernel/sched_features.h
@@ -102,7 +102,7 @@ SCHED_FEAT(CACHE_HOT_BUDDY, 1)
 /*
  * Use arch dependent cpu power functions
  */
-SCHED_FEAT(ARCH_POWER, 0)
+SCHED_FEAT(ARCH_POWER, 1)
 
 SCHED_FEAT(HRTICK, 0)
 SCHED_FEAT(DOUBLE_TICK, 0)
Index: linux-2.6.git/arch/x86/kernel/cpu/sched.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/sched.c
+++ linux-2.6.git/arch/x86/kernel/cpu/sched.c
@@ -44,11 +44,9 @@ unsigned long arch_scale_freq_power(stru
 unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
 {
 	/*
-	 * aperf/mperf already includes the smt gain
+	 * aperf/mperf already includes the smt gain, but represents capacity
+	 * as 0 when idle.  So for now just return default.
 	 */
-	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
-		return SCHED_LOAD_SCALE;
-
 	return default_scale_smt_power(sd, cpu);
 }



