Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbZAWNRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbZAWNRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbZAWNQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:16:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:45911 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755427AbZAWNQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:16:56 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+wRrIHXaCwXiw1x9Fe09CwcUEVrfsDLoq1VhfTKa
	cADpu/OTlWzG0M
Subject: [patch] fix section mismatch warning in
	perf_counter.c::perf_counters_lapic_init()
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 14:16:53 +0100
Message-Id: <1232716613.8750.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix section mismatch in perf_counter.c::perf_counters_lapic_init()

WARNING: arch/x86/kernel/built-in.o(.text+0xdd0f): Section mismatch in reference from the function pmc_generic_enable() to the function .cpuinit.text:perf_counters_lapic_init()
The function pmc_generic_enable() references
the function __cpuinit perf_counters_lapic_init().
This is often because pmc_generic_enable lacks a __cpuinit
annotation or the annotation of perf_counters_lapic_init is wrong.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 arch/x86/kernel/cpu/perf_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -605,7 +605,7 @@ void perf_counter_notify(struct pt_regs
 	local_irq_restore(flags);
 }
 
-void __cpuinit perf_counters_lapic_init(int nmi)
+void perf_counters_lapic_init(int nmi)
 {
 	u32 apic_val;
 


