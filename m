Return-Path: <linux-kernel-owner+w=401wt.eu-S932373AbXLUCDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbXLUCDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759754AbXLUB65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:58:57 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53265 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762364AbXLUB6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:58:52 -0500
Message-Id: <20071221015725.298711912@polymtl.ca>
References: <20071221015438.433195466@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 20:54:47 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 09/24] Text Edit Lock - kprobes x86_64
Content-Disposition: inline; filename=text-edit-lock-kprobes-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 21 Dec 2007 01:57:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make kprobes use INIT_ARRAY().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Tested-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/kprobes_64.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/kprobes_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/kprobes_64.c	2007-11-13 09:45:35.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/kprobes_64.c	2007-11-13 09:45:46.000000000 -0500
@@ -215,12 +215,13 @@ static void __kprobes arch_copy_kprobe(s
 
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
