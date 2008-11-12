Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYKLXfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYKLXfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbYKLXd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:33:59 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48431 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbYKLXd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:33:56 -0500
Message-Id: <20081112232300.510951002@polymtl.ca>
References: <20081112231551.473569400@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 18:16:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 14/17] MIPS : export hpt frequency for trace_clock.
Content-Disposition: inline; filename=mips-export-hpt-frequency-for-trace-clock.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 12 Nov 2008 23:33:03 +0000
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
--- linux.trees.git.orig/arch/mips/include/asm/timex.h	2008-11-12 18:03:16.000000000 -0500
+++ linux.trees.git/arch/mips/include/asm/timex.h	2008-11-12 18:03:33.000000000 -0500
@@ -89,6 +89,8 @@ static inline void write_tsc(u32 val1, u
 	write_c0_compare(read_c0_count() + DELAY_INTERRUPT);
 }
 
+extern unsigned int mips_hpt_frequency;
+
 #endif /* __KERNEL__ */
 
 #endif /*  _ASM_TIMEX_H */
Index: linux.trees.git/arch/mips/kernel/time.c
===================================================================
--- linux.trees.git.orig/arch/mips/kernel/time.c	2008-11-07 00:34:10.000000000 -0500
+++ linux.trees.git/arch/mips/kernel/time.c	2008-11-12 18:03:33.000000000 -0500
@@ -70,6 +70,7 @@ EXPORT_SYMBOL(perf_irq);
  */
 
 unsigned int mips_hpt_frequency;
+EXPORT_SYMBOL(mips_hpt_frequency);
 
 void __init clocksource_set_clock(struct clocksource *cs, unsigned int clock)
 {

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
