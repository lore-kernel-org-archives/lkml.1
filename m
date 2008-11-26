Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYKZM6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYKZM6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYKZM55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:57:57 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46113 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbYKZM5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:57:54 -0500
Message-Id: <20081126124635.097326795@polymtl.ca>
References: <20081126124246.800751190@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 07:42:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 05/17] MIPS : export hpt frequency for get_cycles
Content-Disposition: inline; filename=mips-export-hpt-frequency-for-get-cycles.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 26 Nov 2008 12:57:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_cycles_rate() needs to export the hpt frequency to modules (e.g. LTTng).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/include/asm/timex.h |    2 ++
 arch/mips/kernel/time.c       |    1 +
 2 files changed, 3 insertions(+)

Index: linux.trees.git/arch/mips/include/asm/timex.h
===================================================================
--- linux.trees.git.orig/arch/mips/include/asm/timex.h	2008-11-12 18:15:48.000000000 -0500
+++ linux.trees.git/arch/mips/include/asm/timex.h	2008-11-26 06:49:19.000000000 -0500
@@ -20,6 +20,8 @@
  */
 #define CLOCK_TICK_RATE 1193182
 
+extern unsigned int mips_hpt_frequency;
+
 /*
  * Standard way to access the cycle counter.
  * Currently only used on SMP for scheduling.
Index: linux.trees.git/arch/mips/kernel/time.c
===================================================================
--- linux.trees.git.orig/arch/mips/kernel/time.c	2008-11-12 18:15:47.000000000 -0500
+++ linux.trees.git/arch/mips/kernel/time.c	2008-11-26 06:49:19.000000000 -0500
@@ -70,6 +70,7 @@ EXPORT_SYMBOL(perf_irq);
  */
 
 unsigned int mips_hpt_frequency;
+EXPORT_SYMBOL(mips_hpt_frequency);
 
 void __init clocksource_set_clock(struct clocksource *cs, unsigned int clock)
 {

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
