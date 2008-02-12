Return-Path: <linux-kernel-owner+w=401wt.eu-S1764531AbYBLS6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764531AbYBLS6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762754AbYBLS5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:57:44 -0500
Received: from [198.99.130.12] ([198.99.130.12]:33022 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760816AbYBLS5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:57:42 -0500
Date: Tue, 12 Feb 2008 13:55:27 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Jiri Olsa <olsajiri@gmail.com>
Subject: [PATCH 2/4] UML - Remove unused sigcontext accessors
Message-ID: <20080212185527.GA2069@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macros which extract registers from a struct sigcontext are no
longer needed and can be removed.  They are starting not to build
anyway, given the removal of the 'e' and 'r' from register names
during the x86 merge.

Cc: Jiri Olsa <olsajiri@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/sys-i386/user-offsets.c   |   27 ---------------------------
 arch/um/sys-x86_64/user-offsets.c |   28 ----------------------------
 2 files changed, 55 deletions(-)

Index: linux-2.6.22/arch/um/sys-i386/user-offsets.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/user-offsets.c	2007-11-14 10:33:29.000000000 -0500
+++ linux-2.6.22/arch/um/sys-i386/user-offsets.c	2008-02-11 20:10:56.000000000 -0500
@@ -17,36 +17,9 @@
 
 void foo(void)
 {
-	OFFSET(HOST_SC_IP, sigcontext, eip);
-	OFFSET(HOST_SC_SP, sigcontext, esp);
-	OFFSET(HOST_SC_FS, sigcontext, fs);
-	OFFSET(HOST_SC_GS, sigcontext, gs);
-	OFFSET(HOST_SC_DS, sigcontext, ds);
-	OFFSET(HOST_SC_ES, sigcontext, es);
-	OFFSET(HOST_SC_SS, sigcontext, ss);
-	OFFSET(HOST_SC_CS, sigcontext, cs);
-	OFFSET(HOST_SC_EFLAGS, sigcontext, eflags);
-	OFFSET(HOST_SC_EAX, sigcontext, eax);
-	OFFSET(HOST_SC_EBX, sigcontext, ebx);
-	OFFSET(HOST_SC_ECX, sigcontext, ecx);
-	OFFSET(HOST_SC_EDX, sigcontext, edx);
-	OFFSET(HOST_SC_EDI, sigcontext, edi);
-	OFFSET(HOST_SC_ESI, sigcontext, esi);
-	OFFSET(HOST_SC_EBP, sigcontext, ebp);
 	OFFSET(HOST_SC_TRAPNO, sigcontext, trapno);
 	OFFSET(HOST_SC_ERR, sigcontext, err);
 	OFFSET(HOST_SC_CR2, sigcontext, cr2);
-	OFFSET(HOST_SC_FPSTATE, sigcontext, fpstate);
-	OFFSET(HOST_SC_SIGMASK, sigcontext, oldmask);
-	OFFSET(HOST_SC_FP_CW, _fpstate, cw);
-	OFFSET(HOST_SC_FP_SW, _fpstate, sw);
-	OFFSET(HOST_SC_FP_TAG, _fpstate, tag);
-	OFFSET(HOST_SC_FP_IPOFF, _fpstate, ipoff);
-	OFFSET(HOST_SC_FP_CSSEL, _fpstate, cssel);
-	OFFSET(HOST_SC_FP_DATAOFF, _fpstate, dataoff);
-	OFFSET(HOST_SC_FP_DATASEL, _fpstate, datasel);
-	OFFSET(HOST_SC_FP_ST, _fpstate, _st);
-	OFFSET(HOST_SC_FXSR_ENV, _fpstate, _fxsr_env);
 
 	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_fpregs_struct));
 	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fpxregs_struct));
Index: linux-2.6.22/arch/um/sys-x86_64/user-offsets.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-x86_64/user-offsets.c	2007-11-14 10:33:29.000000000 -0500
+++ linux-2.6.22/arch/um/sys-x86_64/user-offsets.c	2008-02-11 19:21:27.000000000 -0500
@@ -19,37 +19,9 @@
 
 void foo(void)
 {
-	OFFSET(HOST_SC_RBX, sigcontext, rbx);
-	OFFSET(HOST_SC_RCX, sigcontext, rcx);
-	OFFSET(HOST_SC_RDX, sigcontext, rdx);
-	OFFSET(HOST_SC_RSI, sigcontext, rsi);
-	OFFSET(HOST_SC_RDI, sigcontext, rdi);
-	OFFSET(HOST_SC_RBP, sigcontext, rbp);
-	OFFSET(HOST_SC_RAX, sigcontext, rax);
-	OFFSET(HOST_SC_R8, sigcontext, r8);
-	OFFSET(HOST_SC_R9, sigcontext, r9);
-	OFFSET(HOST_SC_R10, sigcontext, r10);
-	OFFSET(HOST_SC_R11, sigcontext, r11);
-	OFFSET(HOST_SC_R12, sigcontext, r12);
-	OFFSET(HOST_SC_R13, sigcontext, r13);
-	OFFSET(HOST_SC_R14, sigcontext, r14);
-	OFFSET(HOST_SC_R15, sigcontext, r15);
-	OFFSET(HOST_SC_IP, sigcontext, rip);
-	OFFSET(HOST_SC_SP, sigcontext, rsp);
 	OFFSET(HOST_SC_CR2, sigcontext, cr2);
 	OFFSET(HOST_SC_ERR, sigcontext, err);
 	OFFSET(HOST_SC_TRAPNO, sigcontext, trapno);
-	OFFSET(HOST_SC_CS, sigcontext, cs);
-	OFFSET(HOST_SC_FS, sigcontext, fs);
-	OFFSET(HOST_SC_GS, sigcontext, gs);
-	OFFSET(HOST_SC_EFLAGS, sigcontext, eflags);
-	OFFSET(HOST_SC_SIGMASK, sigcontext, oldmask);
-#if 0
-	OFFSET(HOST_SC_ORIG_RAX, sigcontext, orig_rax);
-	OFFSET(HOST_SC_DS, sigcontext, ds);
-	OFFSET(HOST_SC_ES, sigcontext, es);
-	OFFSET(HOST_SC_SS, sigcontext, ss);
-#endif
 
 	DEFINE(HOST_FP_SIZE, sizeof(struct _fpstate) / sizeof(unsigned long));
 	DEFINE(HOST_XFP_SIZE, 0);
