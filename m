Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYJPXzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYJPXzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYJPXzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:55:24 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48735 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbYJPXzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:55:23 -0400
Message-Id: <20081016234656.889753679@polymtl.ca>
References: <20081016232729.699004293@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 19:27:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [RFC patch 09/15] LTTng mips export hpt frequency
Content-Disposition: inline; filename=lttng-mips-export-hpt-frequency.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 16 Oct 2008 23:54:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng needs it from modules.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/kernel/time.c  |    1 +
 include/asm-mips/timex.h |    2 ++
 2 files changed, 3 insertions(+)

Index: linux-2.6-lttng/include/asm-mips/timex.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-mips/timex.h	2008-10-16 18:16:37.000000000 -0400
+++ linux-2.6-lttng/include/asm-mips/timex.h	2008-10-16 18:16:44.000000000 -0400
@@ -63,6 +63,8 @@ static inline cycles_t get_cycles(void)
 }
 #endif
 
+extern unsigned int mips_hpt_frequency;
+
 #endif /* __KERNEL__ */
 
 #endif /*  _ASM_TIMEX_H */
Index: linux-2.6-lttng/arch/mips/kernel/time.c
===================================================================
--- linux-2.6-lttng.orig/arch/mips/kernel/time.c	2008-10-16 18:16:32.000000000 -0400
+++ linux-2.6-lttng/arch/mips/kernel/time.c	2008-10-16 18:16:44.000000000 -0400
@@ -70,6 +70,7 @@ EXPORT_SYMBOL(perf_irq);
  */
 
 unsigned int mips_hpt_frequency;
+EXPORT_SYMBOL(mips_hpt_frequency);
 
 void __init clocksource_set_clock(struct clocksource *cs, unsigned int clock)
 {

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
