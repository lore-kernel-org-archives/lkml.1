Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbZKRWnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbZKRWnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZKRWnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:43:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbZKRWnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:43:52 -0500
Date: Wed, 18 Nov 2009 17:43:28 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Message-Id: <4c5f9d065f44db7879021b108f455c68292f1440.1258580048.git.jbaron@redhat.com>
In-Reply-To: <cover.1258580048.git.jbaron@redhat.com>
References: <cover.1258580048.git.jbaron@redhat.com>
Subject: [RFC PATCH 1/6] jump label v3 - kprobes/x86: Cleanup RELATIVEJUMP_INSTRUCTION to RELATIVEJUMP_OPCODE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change RELATIVEJUMP_INSTRUCTION macro to RELATIVEJUMP_OPCODE since it
represents just the opcode byte.


Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/x86/include/asm/kprobes.h |    2 +-
 arch/x86/kernel/kprobes.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 4fe681d..eaec8ea 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -32,7 +32,7 @@ struct kprobe;
 
 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
-#define RELATIVEJUMP_INSTRUCTION 0xe9
+#define RELATIVEJUMP_OPCODE 0xe9
 #define MAX_INSN_SIZE 16
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR)					       \
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 1f3186c..b6b75f1 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -115,7 +115,7 @@ static void __kprobes set_jmp_op(void *from, void *to)
 	} __attribute__((packed)) * jop;
 	jop = (struct __arch_jmp_op *)from;
 	jop->raddr = (s32)((long)(to) - ((long)(from) + 5));
-	jop->op = RELATIVEJUMP_INSTRUCTION;
+	jop->op = RELATIVEJUMP_OPCODE;
 }
 
 /*
-- 
1.6.5.1

