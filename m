Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbXLSF1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbXLSF1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbXLSF1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:27:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:33223 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXLSF1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:27:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Mii8DMvK1oxHfvcpu7eUeKkhKHDRNrqn49u7jWQGfFrmAbTzVVO4ujJvU5c62bBCh+ep16Y40pt4eJM0Ts4cLbZKJcrNA/7N26BeSg0mqmQhQNconb7SsjQXjaP/mxwMyUI0qTObI6ZolfCMiX8hNEEhmdOAyxNL9i8q5xuCey8=
Subject: [PATCH] x86: __kprobes annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4767D02C.6030704@redhat.com>
References: <1197930464.23402.112.camel@brick>
	 <20071218112936.GE9002@elte.hu> <1197978160.7734.31.camel@brick>
	 <4767D02C.6030704@redhat.com>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 21:27:05 -0800
Message-Id: <1198042025.10357.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__always_inline on some static functions was to ensure they ended
up in the .kprobes.text section. Mark this explicitly.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index c7a26be..521a469 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -159,7 +159,7 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 
 /* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
-static void set_jmp_op(void *from, void *to)
+static void __kprobes set_jmp_op(void *from, void *to)
 {
 	struct __arch_jmp_op {
 		char op;
@@ -174,7 +174,7 @@ static void set_jmp_op(void *from, void *to)
  * Returns non-zero if opcode is boostable.
  * RIP relative instructions are adjusted at copying time in 64 bits mode
  */
-static int can_boost(kprobe_opcode_t *opcodes)
+static int __kprobes can_boost(kprobe_opcode_t *opcodes)
 {
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
@@ -392,13 +392,13 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 		kcb->kprobe_saved_flags &= ~X86_EFLAGS_IF;
 }
 
-static void clear_btf(void)
+static void __kprobes clear_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
 		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
 }
 
-static void restore_btf(void)
+static void __kprobes restore_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
 		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);
-- 
1.5.4.rc0.1143.g1a8a



