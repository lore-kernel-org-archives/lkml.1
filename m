Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbYAXUjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbYAXUjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbYAXUev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:34:51 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53075 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258AbYAXUeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:34:50 -0500
Message-Id: <20080124203336.689763652@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 15:27:17 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 11/26] Text Edit Lock - kprobes x86
Content-Disposition: inline; filename=text-edit-lock-kprobes-x86.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Jan 2008 20:33:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make kprobes use INIT_ARRAY().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Tested-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/kprobes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng.mm/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/x86/kernel/kprobes.c	2008-01-24 14:27:04.000000000 -0500
+++ linux-2.6-lttng.mm/arch/x86/kernel/kprobes.c	2008-01-24 14:27:47.000000000 -0500
@@ -366,12 +366,13 @@ int __kprobes arch_prepare_kprobe(struct
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+	text_poke(p->addr, INIT_ARRAY(unsigned char, BREAKPOINT_INSTRUCTION, 1),
+		1);
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
