Return-Path: <linux-kernel-owner+w=401wt.eu-S1765968AbXIUWiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765968AbXIUWiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763607AbXIUWcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:57047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763544AbXIUWcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:17 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: gcosta@redhat.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [17/50] x86_64: remove STR() macros
Message-Id: <20070921223216.0002013DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Glauber de Oliveira Costa <gcosta@redhat.com>
This patch removes the __STR() and STR() macros from x86_64 header files.
They seem to be legacy, and has no more users. Even if there were users,
they should use __stringify() instead.

In fact, there were one third place in which this macro was defined
(ia32_binfmt.c), and used just below. In this file, usage was properly
converted to __stringify()

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/ia32/ia32_binfmt.c |    5 +----
 include/asm-x86_64/hw_irq.h    |    3 ---
 include/asm-x86_64/system.h    |    3 ---
 3 files changed, 1 insertion(+), 10 deletions(-)

Index: linux/arch/x86_64/ia32/ia32_binfmt.c
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32_binfmt.c
+++ linux/arch/x86_64/ia32/ia32_binfmt.c
@@ -112,11 +112,8 @@ struct elf_prpsinfo
 	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
 };
 
-#define __STR(x) #x
-#define STR(x) __STR(x)
-
 #define _GET_SEG(x) \
-	({ __u32 seg; asm("movl %%" STR(x) ",%0" : "=r"(seg)); seg; })
+	({ __u32 seg; asm("movl %%" __stringify(x) ",%0" : "=r"(seg)); seg; })
 
 /* Assumes current==process to be dumped */
 #define ELF_CORE_COPY_REGS(pr_reg, regs)       		\
Index: linux/include/asm-x86_64/hw_irq.h
===================================================================
--- linux.orig/include/asm-x86_64/hw_irq.h
+++ linux/include/asm-x86_64/hw_irq.h
@@ -149,9 +149,6 @@ extern atomic_t irq_mis_count;
 
 #define IO_APIC_IRQ(x) (((x) >= 16) || ((1<<(x)) & io_apic_irqs))
 
-#define __STR(x) #x
-#define STR(x) __STR(x)
-
 #include <asm/ptrace.h>
 
 #define IRQ_NAME2(nr) nr##_interrupt(void)
Index: linux/include/asm-x86_64/system.h
===================================================================
--- linux.orig/include/asm-x86_64/system.h
+++ linux/include/asm-x86_64/system.h
@@ -7,9 +7,6 @@
 
 #ifdef __KERNEL__
 
-#define __STR(x) #x
-#define STR(x) __STR(x)
-
 #define __SAVE(reg,offset) "movq %%" #reg ",(14-" #offset ")*8(%%rsp)\n\t"
 #define __RESTORE(reg,offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
 
