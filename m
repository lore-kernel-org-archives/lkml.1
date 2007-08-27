Return-Path: <linux-kernel-owner+w=401wt.eu-S1759917AbXH0QGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbXH0QGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758684AbXH0P7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:59:16 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43210 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758677AbXH0P7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:59:13 -0400
Message-Id: <20070827155852.564626187@polymtl.ca>
References: <20070827155601.360241608@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:56:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 08/10] Text Edit Lock - kprobes x86_64
Content-Disposition: inline; filename=text-edit-lock-kprobes-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 15:58:53 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make kprobes use text_set instead of text_poke.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 arch/x86_64/kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/x86_64/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/kernel/kprobes.c	2007-08-19 21:56:42.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/kernel/kprobes.c	2007-08-19 22:27:54.000000000 -0400
@@ -209,12 +209,12 @@ static void __kprobes arch_copy_kprobe(s
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+	text_set(p->addr, BREAKPOINT_INSTRUCTION, 1);
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, &p->opcode, 1);
+	text_set(p->addr, p->opcode, 1);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
