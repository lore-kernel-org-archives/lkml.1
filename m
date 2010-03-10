Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0CJNVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:21:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:57494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433Ab0CJNVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:21:06 -0500
Date: Wed, 10 Mar 2010 13:20:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100304140100.923774125@chello.nl>
References: <20100304140100.923774125@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] x86: Move MAX_INSN_SIZE into asm/insn.h
Message-ID: <tip-30a813ae035d3e220a89609adce878e045c49547@git.kernel.org>
Git-Commit-ID: 30a813ae035d3e220a89609adce878e045c49547
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:20:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30a813ae035d3e220a89609adce878e045c49547
Gitweb:     http://git.kernel.org/tip/30a813ae035d3e220a89609adce878e045c49547
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 4 Mar 2010 13:49:21 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:34 +0100

x86: Move MAX_INSN_SIZE into asm/insn.h

Since there's now two users for this, place it in a common header.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <20100304140100.923774125@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/insn.h               |    2 ++
 arch/x86/include/asm/kprobes.h            |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    2 --
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 96c2e0a..88c765e 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -68,6 +68,8 @@ struct insn {
 	const insn_byte_t *next_byte;
 };
 
+#define MAX_INSN_SIZE	16
+
 #define X86_MODRM_MOD(modrm) (((modrm) & 0xc0) >> 6)
 #define X86_MODRM_REG(modrm) (((modrm) & 0x38) >> 3)
 #define X86_MODRM_RM(modrm) ((modrm) & 0x07)
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 4ffa345..5478825 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
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
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ef56f05..72453ac 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -379,8 +379,6 @@ static void intel_pmu_pebs_disable_all(void)
 
 #include <asm/insn.h>
 
-#define MAX_INSN_SIZE	16
-
 static inline bool kernel_ip(unsigned long ip)
 {
 #ifdef CONFIG_X86_32
