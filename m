Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab0BMTsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:48:18 -0500
Received: from mail-yw0-f179.google.com ([209.85.211.179]:46150 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab0BMTsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:48:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=R3Ux+DAqCDPbY6OHG5IA/2Ps8VVrYXFXjh/ReOROhZYrYKYCLeAWvV8PSXJQWF0M23
         pMy5k2+QsO1FjQ0h0ayd7JXvRSmj3Z4yvMYHHyFEpzFSoYvrCMqFoO6xMgNdrj0aV06J
         3Bg7Zp3MD2DX9xckBO/5Y0lcNPyEGd6onJjdM=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 01/10] ARM: ftrace: clean up mcount assembly indentation
Date: Sun, 14 Feb 2010 01:18:29 +0530
Message-Id: <1266090518-31120-2-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266090518-31120-1-git-send-email-rabin@rab.in>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mcount implementation currently uses a different indentation style
from the rest of the file (and the rest of the ARM assembly in the
kernel).  Clean it up.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/kernel/entry-common.S |   88 ++++++++++++++++++++--------------------
 1 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 2c1db77..0b042bd 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -94,73 +94,73 @@ ENDPROC(ret_from_fork)
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
-	stmdb sp!, {r0-r3, lr}
-	mov r0, lr
-	sub r0, r0, #MCOUNT_INSN_SIZE
+	stmdb	sp!, {r0-r3, lr}
+	mov	r0, lr
+	sub	r0, r0, #MCOUNT_INSN_SIZE
 
 	.globl mcount_call
 mcount_call:
-	bl ftrace_stub
-	ldr lr, [fp, #-4]			@ restore lr
-	ldmia sp!, {r0-r3, pc}
+	bl	ftrace_stub
+	ldr	lr, [fp, #-4]			@ restore lr
+	ldmia	sp!, {r0-r3, pc}
 
 ENTRY(ftrace_caller)
-	stmdb sp!, {r0-r3, lr}
-	ldr r1, [fp, #-4]
-	mov r0, lr
-	sub r0, r0, #MCOUNT_INSN_SIZE
+	stmdb	sp!, {r0-r3, lr}
+	ldr	r1, [fp, #-4]
+	mov	r0, lr
+	sub	r0, r0, #MCOUNT_INSN_SIZE
 
 	.globl ftrace_call
 ftrace_call:
-	bl ftrace_stub
-	ldr lr, [fp, #-4]			@ restore lr
-	ldmia sp!, {r0-r3, pc}
+	bl	ftrace_stub
+	ldr	lr, [fp, #-4]			@ restore lr
+	ldmia	sp!, {r0-r3, pc}
 
 #else
 
 ENTRY(__gnu_mcount_nc)
-	stmdb sp!, {r0-r3, lr}
-	ldr r0, =ftrace_trace_function
-	ldr r2, [r0]
-	adr r0, ftrace_stub
-	cmp r0, r2
-	bne gnu_trace
-	ldmia sp!, {r0-r3, ip, lr}
-	mov pc, ip
+	stmdb	sp!, {r0-r3, lr}
+	ldr	r0, =ftrace_trace_function
+	ldr	r2, [r0]
+	adr	r0, ftrace_stub
+	cmp	r0, r2
+	bne	gnu_trace
+	ldmia	sp!, {r0-r3, ip, lr}
+	mov	pc, ip
 
 gnu_trace:
-	ldr r1, [sp, #20]			@ lr of instrumented routine
-	mov r0, lr
-	sub r0, r0, #MCOUNT_INSN_SIZE
-	mov lr, pc
-	mov pc, r2
-	ldmia sp!, {r0-r3, ip, lr}
-	mov pc, ip
+	ldr	r1, [sp, #20]			@ lr of instrumented routine
+	mov	r0, lr
+	sub	r0, r0, #MCOUNT_INSN_SIZE
+	mov	lr, pc
+	mov	pc, r2
+	ldmia	sp!, {r0-r3, ip, lr}
+	mov	pc, ip
 
 ENTRY(mcount)
-	stmdb sp!, {r0-r3, lr}
-	ldr r0, =ftrace_trace_function
-	ldr r2, [r0]
-	adr r0, ftrace_stub
-	cmp r0, r2
-	bne trace
-	ldr lr, [fp, #-4]			@ restore lr
-	ldmia sp!, {r0-r3, pc}
+	stmdb	sp!, {r0-r3, lr}
+	ldr	r0, =ftrace_trace_function
+	ldr	r2, [r0]
+	adr	r0, ftrace_stub
+	cmp	r0, r2
+	bne	trace
+	ldr	lr, [fp, #-4]			@ restore lr
+	ldmia	sp!, {r0-r3, pc}
 
 trace:
-	ldr r1, [fp, #-4]			@ lr of instrumented routine
-	mov r0, lr
-	sub r0, r0, #MCOUNT_INSN_SIZE
-	mov lr, pc
-	mov pc, r2
-	ldr lr, [fp, #-4]			@ restore lr
-	ldmia sp!, {r0-r3, pc}
+	ldr	r1, [fp, #-4]			@ lr of instrumented routine
+	mov	r0, lr
+	sub	r0, r0, #MCOUNT_INSN_SIZE
+	mov	lr, pc
+	mov	pc, r2
+	ldr	lr, [fp, #-4]			@ restore lr
+	ldmia	sp!, {r0-r3, pc}
 
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 	.globl ftrace_stub
 ftrace_stub:
-	mov pc, lr
+	mov	pc, lr
 
 #endif /* CONFIG_FUNCTION_TRACER */
 
-- 
1.6.6

