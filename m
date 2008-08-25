Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYHYR1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYHYR1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYHYR1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:27:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:38599 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbYHYR1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=uxPxPAtbentQUScsxTXVN1lKMJsMQmeD4farQX01fuOj1z0kx3xSqRpuF1JxWtgdi4
         EL7PyZa1zwAzZAPsPBa1fDEswKK3Hl1vtC+YBd+oXBOUsRNALaY7za+U+YswedC1EYBB
         GWhkREI5yt0Iei3rO2w8QV8FN12sB5DSvXsoU=
Date: Mon, 25 Aug 2008 21:27:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: apic - unify smp_spurious/error_interrupt declaration
Message-ID: <20080825172726.GC7249@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to entry_64.S we do pass pt_regs pointer
into interrupt handlers but don't use them. So we
safetly may merge the declarations.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-08-25 19:46:29.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic.c	2008-08-25 21:04:14.000000000 +0400
@@ -1659,11 +1659,7 @@ int __init APIC_init_uniprocessor(void)
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
-#ifdef CONFIG_X86_64
-asmlinkage void smp_spurious_interrupt(void)
-#else
 void smp_spurious_interrupt(struct pt_regs *regs)
-#endif
 {
 	u32 v;
 
@@ -1694,11 +1690,7 @@ void smp_spurious_interrupt(struct pt_re
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
-#ifdef CONFIG_X86_64
-asmlinkage void smp_error_interrupt(void)
-#else
 void smp_error_interrupt(struct pt_regs *regs)
-#endif
 {
 	u32 v, v1;
 
Index: linux-2.6.git/include/asm-x86/hw_irq.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/hw_irq.h	2008-08-24 12:56:26.000000000 +0400
+++ linux-2.6.git/include/asm-x86/hw_irq.h	2008-08-25 21:05:20.000000000 +0400
@@ -96,13 +96,8 @@ extern asmlinkage void qic_call_function
 
 /* SMP */
 extern void smp_apic_timer_interrupt(struct pt_regs *);
-#ifdef CONFIG_X86_32
 extern void smp_spurious_interrupt(struct pt_regs *);
 extern void smp_error_interrupt(struct pt_regs *);
-#else
-extern asmlinkage void smp_spurious_interrupt(void);
-extern asmlinkage void smp_error_interrupt(void);
-#endif
 #ifdef CONFIG_X86_SMP
 extern void smp_reschedule_interrupt(struct pt_regs *);
 extern void smp_call_function_interrupt(struct pt_regs *);
