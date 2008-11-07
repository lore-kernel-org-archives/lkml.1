Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbYKGFo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbYKGFo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYKGFoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:44:05 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:60897 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYKGFoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:44:04 -0500
Message-Id: <20081107053351.008924790@polymtl.ca>
References: <20081107052336.652868737@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 00:23:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [RFC patch 15/18] MIPS : export hpt frequency for trace_clock.
Content-Disposition: inline; filename=mips-export-hpt-frequency-for-trace-clock.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  7 Nov 2008 05:43:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace_clock needs to export the hpt frequency to modules (e.g. LTTng).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/include/asm/timex.h |    2 ++
 arch/mips/kernel/time.c       |    1 +
 2 files changed, 3 insertions(+)

Index: linux.trees.git/arch/mips/include/asm/timex.h
===================================================================
--- linux.trees.git.orig/arch/mips/include/asm/timex.h	2008-11-07 00:16:05.000000000 -0500
+++ linux.trees.git/arch/mips/include/asm/timex.h	2008-11-07 00:16:17.000000000 -0500
@@ -89,6 +89,8 @@ static inline void write_tsc(u32 val1, u
 	write_c0_compare(read_c0_count() + DELAY_INTERRUPT);
 }
 
+extern unsigned int mips_hpt_frequency;
+
 #endif /* __KERNEL__ */
 
 #endif /*  _ASM_TIMEX_H */
Index: linux.trees.git/arch/mips/kernel/time.c
===================================================================
--- linux.trees.git.orig/arch/mips/kernel/time.c	2008-07-19 09:18:07.000000000 -0400
+++ linux.trees.git/arch/mips/kernel/time.c	2008-11-07 00:16:17.000000000 -0500
@@ -70,6 +70,7 @@ EXPORT_SYMBOL(perf_irq);
  */
 
 unsigned int mips_hpt_frequency;
+EXPORT_SYMBOL(mips_hpt_frequency);
 
 void __init clocksource_set_clock(struct clocksource *cs, unsigned int clock)
 {

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
