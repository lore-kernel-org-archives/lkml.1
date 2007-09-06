Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbXIFUC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbXIFUC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758391AbXIFUCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:02:30 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39401 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758380AbXIFUC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:02:29 -0400
Message-Id: <20070906200212.724483035@polymtl.ca>
References: <20070906200124.595238505@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 06 Sep 2007 16:01:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 07/10] Text Edit Lock - kprobes i386
Content-Disposition: inline; filename=text-edit-lock-kprobes-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Sep 2007 20:02:13 +0000
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
 arch/i386/kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/i386/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/kprobes.c	2007-09-04 12:10:34.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/kprobes.c	2007-09-04 12:11:25.000000000 -0400
@@ -177,12 +177,12 @@ int __kprobes arch_prepare_kprobe(struct
 
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
