Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZKRWo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZKRWo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbZKRWo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:44:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674AbZKRWoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:44:13 -0500
Date: Wed, 18 Nov 2009 17:43:36 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Message-Id: <a13bca1c010e50a1aa016c1e304e92c198edf6a7.1258580048.git.jbaron@redhat.com>
In-Reply-To: <cover.1258580048.git.jbaron@redhat.com>
References: <cover.1258580048.git.jbaron@redhat.com>
Subject: [RFC PATCH 3/6] jump label v3 - move opcode defs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move x86 opcode macros from arch/x86/include/asm/kprobes.h to
arch/x86/include/asm/alternative.h so they are useful outside of kprobes.


Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/include/asm/alternative.h |    5 +++++
 arch/x86/include/asm/kprobes.h     |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 03843a8..6a22696 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -160,6 +160,11 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
  */
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 
+#define BREAKPOINT_INSTRUCTION  0xcc
+#define RELATIVEJUMP_OPCODE 0xe9
+#define RELATIVEJUMP_SIZE 5
+#define MAX_INSN_SIZE 16
+
 /*
  * Setup int3 trap and fixup execution for cross-modifying on SMP case.
  * If the other cpus execute modifying instruction, it will hit int3
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index febab97..15b1b12 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -31,10 +31,6 @@ struct pt_regs;
 struct kprobe;
 
 typedef u8 kprobe_opcode_t;
-#define BREAKPOINT_INSTRUCTION	0xcc
-#define RELATIVEJUMP_OPCODE 0xe9
-#define RELATIVEJUMP_SIZE 5
-#define MAX_INSN_SIZE 16
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR)					       \
 	(((MAX_STACK_SIZE) < (((unsigned long)current_thread_info()) + \
-- 
1.6.5.1

