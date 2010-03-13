Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab0CMG5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 01:57:07 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:60814 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab0CMG5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 01:57:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references:mime-version:content-type:content-transfer-encoding;
        b=ddBHuU6Mdl7LC3AKsXoMCc/Buzewyh98pfrcARm1aZ4EcHdKItR2w+mYaGNRqB98nU
         sX6BnvfS0Egw92xJ/NNyd/dceBzzzNukM5RBm9AD94hb2P8RsPyYkP+iq6YqqTzFcRNE
         uqCb7RqNVGTDY3sPTclyGdwCzBeGLCpYff1gQ=
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
Date: Sat, 13 Mar 2010 12:19:38 +0530
Message-Id: <1268462987-8271-2-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1268462987-8271-1-git-send-email-rabin@rab.in>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mcount implementation currently uses a different indentation style
from the rest of the file (and the rest of the ARM assembly in the
kernel).  Clean it up.

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
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
1.7.0

