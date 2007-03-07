Return-Path: <linux-kernel-owner+w=401wt.eu-S1161259AbXCGHcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161259AbXCGHcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161260AbXCGHbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:31:43 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59678 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161259AbXCGH1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:27:55 -0500
Date: Wed, 7 Mar 2007 12:42:00 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: [PATCH 10/20] x86_64: wakeup.S rename registers to reflect right names
Message-ID: <20070307071200.GK23412@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307065703.GA23412@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



o Use appropriate names for 64bit regsiters.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 arch/x86_64/kernel/acpi/wakeup.S |   36 ++++++++++++++++++------------------
 include/asm-x86_64/suspend.h     |   12 ++++++------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff -puN arch/x86_64/kernel/acpi/wakeup.S~x86_64-wakeup.S-rename-registers-to-reflect-right-names arch/x86_64/kernel/acpi/wakeup.S
--- linux-2.6.21-rc2-reloc/arch/x86_64/kernel/acpi/wakeup.S~x86_64-wakeup.S-rename-registers-to-reflect-right-names	2007-03-07 01:26:55.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/arch/x86_64/kernel/acpi/wakeup.S	2007-03-07 01:26:55.000000000 +0530
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
diff -puN include/asm-x86_64/suspend.h~x86_64-wakeup.S-rename-registers-to-reflect-right-names include/asm-x86_64/suspend.h
--- linux-2.6.21-rc2-reloc/include/asm-x86_64/suspend.h~x86_64-wakeup.S-rename-registers-to-reflect-right-names	2007-03-07 01:26:55.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/include/asm-x86_64/suspend.h	2007-03-07 01:26:55.000000000 +0530
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
_
