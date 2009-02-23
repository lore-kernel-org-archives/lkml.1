Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZBWUDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZBWUDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZBWUCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:02:21 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:47676 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbZBWUCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:02:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=j8BhO/NNwe+/DQT9UaU2XyfH4heThrR0X+MVlIyriP/CLerQGJtFt6xqxIAk+orgrI
         LwYS/k7I1+hQSXf5T6qA5OoqAwCrDtk3ln76MacMzzMmt6hb51OjirQGJ3mDFDYB4tGS
         oNlBr2Pn2bgdbbahxyA/F6BUDz2eEWiCvctNA=
Message-Id: <20090223200227.322325459@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 23 Feb 2009 22:57:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: heukelum@fastmail.fm, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 5/6] x86: head_64.S - use GLOBAL macro
References: <20090223195656.512422509@openvz.org>
Content-Disposition: inline; filename=x86-entry-add-GLOBAL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/entry_64.S |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6.git/arch/x86/kernel/entry_64.S
@@ -77,20 +77,17 @@ ENTRY(ftrace_caller)
 	movq 8(%rbp), %rsi
 	subq $MCOUNT_INSN_SIZE, %rdi
 
-.globl ftrace_call
-ftrace_call:
+GLOBAL(ftrace_call)
 	call ftrace_stub
 
 	MCOUNT_RESTORE_FRAME
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-.globl ftrace_graph_call
-ftrace_graph_call:
+GLOBAL(ftrace_graph_call)
 	jmp ftrace_stub
 #endif
 
-.globl ftrace_stub
-ftrace_stub:
+GLOBAL(ftrace_stub)
 	retq
 END(ftrace_caller)
 
@@ -110,8 +107,7 @@ ENTRY(mcount)
 	jnz ftrace_graph_caller
 #endif
 
-.globl ftrace_stub
-ftrace_stub:
+GLOBAL(ftrace_stub)
 	retq
 
 trace:
@@ -148,9 +144,7 @@ ENTRY(ftrace_graph_caller)
 	retq
 END(ftrace_graph_caller)
 
-
-.globl return_to_handler
-return_to_handler:
+GLOBAL(return_to_handler)
 	subq  $80, %rsp
 
 	movq %rax, (%rsp)
@@ -634,16 +628,14 @@ tracesys:
  * Syscall return path ending with IRET.
  * Has correct top of stack, but partial stack frame.
  */
-	.globl int_ret_from_sys_call
-	.globl int_with_check
-int_ret_from_sys_call:
+GLOBAL(int_ret_from_sys_call)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl $3,CS-ARGOFFSET(%rsp)
 	je retint_restore_args
 	movl $_TIF_ALLWORK_MASK,%edi
 	/* edi:	mask to check */
-int_with_check:
+GLOBAL(int_with_check)
 	LOCKDEP_SYS_EXIT_IRQ
 	GET_THREAD_INFO(%rcx)
 	movl TI_flags(%rcx),%edx

