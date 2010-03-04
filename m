Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0CDOCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:02:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab0CDOB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:01:57 -0500
Message-Id: <20100304140100.923774125@chello.nl>
References: <20100304140046.596569763@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 04 Mar 2010 15:00:59 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 13/14] x86: Move MAX_INSN_SIZE into asm/insn.h
Content-Disposition: inline; filename=x86-collect-max_insn_size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there's now two users for this, place it in a common header.

CC: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/include/asm/insn.h               |    2 ++
 arch/x86/include/asm/kprobes.h            |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    2 --
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/include/asm/insn.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/insn.h
+++ linux-2.6/arch/x86/include/asm/insn.h
@@ -68,6 +68,8 @@ struct insn {
 	const insn_byte_t *next_byte;
 };
 
+#define MAX_INSN_SIZE	16
+
 #define X86_MODRM_MOD(modrm) (((modrm) & 0xc0) >> 6)
 #define X86_MODRM_REG(modrm) (((modrm) & 0x38) >> 3)
 #define X86_MODRM_RM(modrm) ((modrm) & 0x07)
Index: linux-2.6/arch/x86/include/asm/kprobes.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/kprobes.h
+++ linux-2.6/arch/x86/include/asm/kprobes.h
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
+#include <asm/insn.h>
 
 #define  __ARCH_WANT_KPROBES_INSN_SLOT
 
@@ -36,7 +37,6 @@ typedef u8 kprobe_opcode_t;
 #define RELATIVEJUMP_SIZE 5
 #define RELATIVECALL_OPCODE 0xe8
 #define RELATIVE_ADDR_SIZE 4
-#define MAX_INSN_SIZE 16
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR)					       \
 	(((MAX_STACK_SIZE) < (((unsigned long)current_thread_info()) + \
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -379,8 +379,6 @@ static void intel_pmu_pebs_disable_all(v
 
 #include <asm/insn.h>
 
-#define MAX_INSN_SIZE	16
-
 static inline bool kernel_ip(unsigned long ip)
 {
 #ifdef CONFIG_X86_32

-- 

