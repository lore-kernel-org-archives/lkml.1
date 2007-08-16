Return-Path: <linux-kernel-owner+w=401wt.eu-S1763663AbXHQBrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663AbXHQBrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 21:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXHQBrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 21:47:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbXHQBrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 21:47:09 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH] remove STR() macros
Date: Thu, 16 Aug 2007 20:00:41 -0300
Message-Id: <11873052413300-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the __STR() and STR() macros from x86_64 header files.
They seem to be legacy, and has no more users. Even if there were users,
they should use __stringify() instead.

In fact, there were one third place in which this macro was defined
(ia32_binfmt.c), and used just below. In this file, usage was properly
converted to __stringify()

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86_64/ia32/ia32_binfmt.c |    5 +----
 include/asm-x86_64/hw_irq.h    |    3 ---
 include/asm-x86_64/system.h    |    3 ---
 3 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/arch/x86_64/ia32/ia32_binfmt.c b/arch/x86_64/ia32/ia32_binfmt.c
index dffd2ac..e9a3d7b 100644
--- a/arch/x86_64/ia32/ia32_binfmt.c
+++ b/arch/x86_64/ia32/ia32_binfmt.c
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
diff --git a/include/asm-x86_64/hw_irq.h b/include/asm-x86_64/hw_irq.h
index 09dfc18..dc0a953 100644
--- a/include/asm-x86_64/hw_irq.h
+++ b/include/asm-x86_64/hw_irq.h
@@ -148,9 +148,6 @@ extern atomic_t irq_mis_count;
 
 #define IO_APIC_IRQ(x) (((x) >= 16) || ((1<<(x)) & io_apic_irqs))
 
-#define __STR(x) #x
-#define STR(x) __STR(x)
-
 #include <asm/ptrace.h>
 
 #define IRQ_NAME2(nr) nr##_interrupt(void)
diff --git a/include/asm-x86_64/system.h b/include/asm-x86_64/system.h
index 20ed9df..7e98eeb 100644
--- a/include/asm-x86_64/system.h
+++ b/include/asm-x86_64/system.h
@@ -7,9 +7,6 @@
 
 #ifdef __KERNEL__
 
-#define __STR(x) #x
-#define STR(x) __STR(x)
-
 #define __SAVE(reg,offset) "movq %%" #reg ",(14-" #offset ")*8(%%rsp)\n\t"
 #define __RESTORE(reg,offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
 
-- 
1.4.4.2

