Return-Path: <linux-kernel-owner+w=401wt.eu-S1163326AbXD1SGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163326AbXD1SGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163320AbXD1SBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:01:02 -0400
Received: from ns2.suse.de ([195.135.220.15]:38977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163344AbXD1R67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:58:59 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [11/22] x86_64: wakeup.S rename registers to reflect right names
Message-Id: <20070428175858.3F825151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:58:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


o Use appropriate names for 64bit regsiters.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/acpi/wakeup.S |   36 ++++++++++++++++++------------------
 include/asm-x86_64/suspend.h     |   12 ++++++------
 2 files changed, 24 insertions(+), 24 deletions(-)

Index: linux/arch/x86_64/kernel/acpi/wakeup.S
===================================================================
--- linux.orig/arch/x86_64/kernel/acpi/wakeup.S
+++ linux/arch/x86_64/kernel/acpi/wakeup.S
@@ -211,16 +211,16 @@ wakeup_long64:
 	movw	%ax, %es
 	movw	%ax, %fs
 	movw	%ax, %gs
-	movq	saved_esp, %rsp
+	movq	saved_rsp, %rsp
 
 	movw	$0x0e00 + 'x', %ds:(0xb8018)
-	movq	saved_ebx, %rbx
-	movq	saved_edi, %rdi
-	movq	saved_esi, %rsi
-	movq	saved_ebp, %rbp
+	movq	saved_rbx, %rbx
+	movq	saved_rdi, %rdi
+	movq	saved_rsi, %rsi
+	movq	saved_rbp, %rbp
 
 	movw	$0x0e00 + '!', %ds:(0xb801a)
-	movq	saved_eip, %rax
+	movq	saved_rip, %rax
 	jmp	*%rax
 
 .code32
@@ -408,13 +408,13 @@ do_suspend_lowlevel:
 	movq %r15, saved_context_r15(%rip)
 	pushfq ; popq saved_context_eflags(%rip)
 
-	movq	$.L97, saved_eip(%rip)
+	movq	$.L97, saved_rip(%rip)
 
-	movq %rsp,saved_esp
-	movq %rbp,saved_ebp
-	movq %rbx,saved_ebx
-	movq %rdi,saved_edi
-	movq %rsi,saved_esi
+	movq %rsp,saved_rsp
+	movq %rbp,saved_rbp
+	movq %rbx,saved_rbx
+	movq %rdi,saved_rdi
+	movq %rsi,saved_rsi
 
 	addq	$8, %rsp
 	movl	$3, %edi
@@ -461,12 +461,12 @@ do_suspend_lowlevel:
 	
 .data
 ALIGN
-ENTRY(saved_ebp)	.quad	0
-ENTRY(saved_esi)	.quad	0
-ENTRY(saved_edi)	.quad	0
-ENTRY(saved_ebx)	.quad	0
+ENTRY(saved_rbp)	.quad	0
+ENTRY(saved_rsi)	.quad	0
+ENTRY(saved_rdi)	.quad	0
+ENTRY(saved_rbx)	.quad	0
 
-ENTRY(saved_eip)	.quad	0
-ENTRY(saved_esp)	.quad	0
+ENTRY(saved_rip)	.quad	0
+ENTRY(saved_rsp)	.quad	0
 
 ENTRY(saved_magic)	.quad	0
Index: linux/include/asm-x86_64/suspend.h
===================================================================
--- linux.orig/include/asm-x86_64/suspend.h
+++ linux/include/asm-x86_64/suspend.h
@@ -45,12 +45,12 @@ extern unsigned long saved_context_eflag
 extern void fix_processor_context(void);
 
 #ifdef CONFIG_ACPI_SLEEP
-extern unsigned long saved_eip;
-extern unsigned long saved_esp;
-extern unsigned long saved_ebp;
-extern unsigned long saved_ebx;
-extern unsigned long saved_esi;
-extern unsigned long saved_edi;
+extern unsigned long saved_rip;
+extern unsigned long saved_rsp;
+extern unsigned long saved_rbp;
+extern unsigned long saved_rbx;
+extern unsigned long saved_rsi;
+extern unsigned long saved_rdi;
 
 /* routines for saving/restoring kernel state */
 extern int acpi_save_state_mem(void);
