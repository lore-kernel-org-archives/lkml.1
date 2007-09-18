Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXIRVJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXIRVJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbXIRVIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:08:24 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54446 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493AbXIRVIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:08:22 -0400
Message-Id: <20070918210737.520958751@polymtl.ca>
References: <20070918210601.028313546@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 17:06:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 09/11] Text Edit Lock - kprobes x86_64
Content-Disposition: inline; filename=text-edit-lock-kprobes-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 18 Sep 2007 21:07:37 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make kprobes use INIT_ARRAY().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Tested-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 arch/x86_64/kernel/kprobes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/x86_64/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/kernel/kprobes.c	2007-09-11 15:22:35.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/kernel/kprobes.c	2007-09-11 15:49:51.000000000 -0400
@@ -216,12 +216,13 @@ static void __kprobes arch_copy_kprobe(s
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+	text_poke(p->addr, INIT_ARRAY(unsigned char, BREAKPOINT_INSTRUCTION, 1),
+			1);
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, &p->opcode, 1);
+	text_poke(p->addr, INIT_ARRAY(unsigned char, p->opcode, 1), 1);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
