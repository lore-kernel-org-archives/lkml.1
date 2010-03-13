Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab0CMGup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 01:50:45 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:64010 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab0CMGuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 01:50:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Qjvz+jcxnZN6YKDiWTCFkoFEe7OYtDko6DTDg0Bi+VCcnCjpwssddbQOS2QrQPyRqs
         zmfYxkGQFb9w7k5uq5QojUy8K7UsWAcxJea/v2FADzYaCcKtzaQNrWAcVZt1xFgJwp4O
         q1DhKrnw/Rhyqw4x4t2oQdCq6J6u4K+HUK32Y=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 05/10] ARM: ftrace: add ENDPROC annotations
Date: Sat, 13 Mar 2010 12:19:42 +0530
Message-Id: <1268462987-8271-6-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1268462987-8271-1-git-send-email-rabin@rab.in>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building as Thumb-2, the ".type foo, %function" annotation in
ENDPROC seems to be required in order for the assembly routines to be
recognized as Thumb-2 code.  If the ENDPROC annotations are not present,
calls to these routines are generated as BLX instead of BL.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/kernel/entry-common.S |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 6805a72..c3bdb05 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -146,6 +146,7 @@ mcount_call:
 	bl	ftrace_stub
 	ldr	lr, [fp, #-4]			@ restore lr
 	ldmia	sp!, {r0-r3, pc}
+ENDPROC(mcount)
 
 ENTRY(ftrace_caller)
 	stmdb	sp!, {r0-r3, lr}
@@ -158,6 +159,7 @@ ftrace_call:
 	bl	ftrace_stub
 	ldr	lr, [fp, #-4]			@ restore lr
 	ldmia	sp!, {r0-r3, pc}
+ENDPROC(ftrace_caller)
 
 #else
 
@@ -179,6 +181,7 @@ gnu_trace:
 	mov	pc, r2
 	ldmia	sp!, {r0-r3, ip, lr}
 	mov	pc, ip
+ENDPROC(__gnu_mcount_nc)
 
 #ifdef CONFIG_OLD_MCOUNT
 /*
@@ -204,13 +207,15 @@ trace:
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
1.7.0

