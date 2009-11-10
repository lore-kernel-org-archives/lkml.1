Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZKJV7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZKJV7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbZKJV7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:59:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbZKJV7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:59:31 -0500
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, mingo@elte.hu,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20091025223657.5ebc2857@infradead.org>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
	 <1256453725.12138.40.camel@marge.simson.net>
	 <20091025095109.449bac9e@infradead.org>
	 <1256492289.14241.40.camel@marge.simson.net>
	 <20091025123319.2b76bf69@infradead.org>
	 <1256508287.17306.14.camel@marge.simson.net>
	 <1256522035.7356.19.camel@laptop>
	 <1256531907.7117.31.camel@marge.simson.net>
	 <20091025215225.05ac9ac9@infradead.org>
	 <1256533734.7117.45.camel@marge.simson.net>
	 <20091025223657.5ebc2857@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 22:59:29 +0100
Message-ID: <1257890369.4108.490.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 22:36 -0700, Arjan van de Ven wrote:
> 
> if you're a multicore domain you better have a shared cache.. that's
> what it should mean. If it does not we should fix that.

Fully agreed.. I've been dying to do the below for ages :-)

---
 arch/x86/kernel/smpboot.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 213a7a3..297b307 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -433,15 +433,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	/*
-	 * For perf, we return last level cache shared map.
-	 * And for power savings, we return cpu_core_map
-	 */
-	if ((sched_mc_power_savings || sched_smt_power_savings) &&
-	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
-		return cpu_core_mask(cpu);
-	else
-		return c->llc_shared_map;
+	return c->llc_shared_map;
 }
 
 static void impress_friends(void)


