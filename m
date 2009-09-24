Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZIXOoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZIXOoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZIXOoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:44:38 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48091 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbZIXOmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:42:47 -0400
X-Greylist: delayed 2108 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 10:42:44 EDT
Message-Id: <20090924133359.061055984@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Sep 2009 09:26:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@redhat.com>
Subject: [patch 01/12] x86: text_poke_early non static
Content-Disposition: inline; filename=x86-text-poke-early-non-static.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 24 Sep 2009 14:07:31 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed by immediate.c.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/include/asm/alternative.h |    5 +++++
 arch/x86/kernel/alternative.c      |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux.trees.git/arch/x86/kernel/alternative.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/alternative.c	2009-09-24 09:13:59.000000000 -0400
+++ linux.trees.git/arch/x86/kernel/alternative.c	2009-09-24 09:15:01.000000000 -0400
@@ -193,7 +193,7 @@ static void __init_or_module add_nops(vo
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
-static void *text_poke_early(void *addr, const void *opcode, size_t len);
+void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
@@ -492,7 +492,7 @@ void __init alternative_instructions(voi
  * instructions. And on the local CPU you need to be protected again NMI or MCE
  * handlers seeing an inconsistent instruction while you patch.
  */
-static void *__init_or_module text_poke_early(void *addr, const void *opcode,
+void *__init_or_module text_poke_early(void *addr, const void *opcode,
 					      size_t len)
 {
 	unsigned long flags;
Index: linux.trees.git/arch/x86/include/asm/alternative.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/alternative.h	2009-09-24 09:15:22.000000000 -0400
+++ linux.trees.git/arch/x86/include/asm/alternative.h	2009-09-24 09:15:56.000000000 -0400
@@ -160,4 +160,9 @@ static inline void apply_paravirt(struct
  */
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 
+/*
+ * text_poke for early boot
+ */
+extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+
 #endif /* _ASM_X86_ALTERNATIVE_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
