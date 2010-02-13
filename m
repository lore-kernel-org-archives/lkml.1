Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab0BMTsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:48:41 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:47287 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab0BMTsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:48:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ZD2zn/dWLgWBw2CCaFmhhg2g4bx17hQqgKGpd6HJlxEBPwtS6rpzU3Eaw6O4acGpO8
         hBkviDbe6ou/J25auzFdHfbD8r3ZyPU4MUrUrAuzi2jBvTN4NaRSv6mQdYwAJ6L/1Jmm
         gGGL0RYA7M8Cp3C3S92F0Ko3HF6Wdff7Ok6uc=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 05/10] ARM: ftrace: add ENDPROC annotations
Date: Sun, 14 Feb 2010 01:18:33 +0530
Message-Id: <1266090518-31120-6-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266090518-31120-1-git-send-email-rabin@rab.in>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building as Thumb-2, the ".type foo, %function" annotation in
ENDPROC seems to be required in order for the assembly routines to be
recognized as Thumb-2 code.  If the ENDPROC annotations are not present,
calls to these routines are generated as BLX instead of BL.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/kernel/entry-common.S |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index c98e3a3..42eb166 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -135,6 +135,7 @@ mcount_call:
 	bl	ftrace_stub
 	ldr	lr, [fp, #-4]			@ restore lr
 	ldmia	sp!, {r0-r3, pc}
+ENDPROC(mcount)
 
 ENTRY(ftrace_caller)
 	stmdb	sp!, {r0-r3, lr}
@@ -147,6 +148,7 @@ ftrace_call:
 	bl	ftrace_stub
 	ldr	lr, [fp, #-4]			@ restore lr
 	ldmia	sp!, {r0-r3, pc}
+ENDPROC(ftrace_caller)
 
 #else
 
@@ -168,6 +170,7 @@ gnu_trace:
 	mov	pc, r2
 	ldmia	sp!, {r0-r3, ip, lr}
 	mov	pc, ip
+ENDPROC(__gnu_mcount_nc)
 
 #ifdef CONFIG_OLD_MCOUNT
 /*
@@ -193,13 +196,15 @@ trace:
 	mov	pc, r2
 	ldr	lr, [fp, #-4]			@ restore lr
 	ldmia	sp!, {r0-r3, pc}
+ENDPROC(mcount)
 #endif
 
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 	.globl ftrace_stub
-ftrace_stub:
+ENTRY(ftrace_stub)
 	mov	pc, lr
+ENDPROC(ftrace_stub)
 
 #endif /* CONFIG_FUNCTION_TRACER */
 
-- 
1.6.6

