Return-Path: <linux-kernel-owner+w=401wt.eu-S1163433AbXD1SNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163433AbXD1SNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163301AbXD1SNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:13:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163300AbXD1Rwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:42 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [13/35] i386: No need to use -traditional for processing asm in i386/kernel/
Message-Id: <20070428175237.B1AC6151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
No need to use -traditional for processing asm in i386/kernel/

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/Makefile |    2 --
 arch/i386/kernel/entry.S  |    2 +-
 include/asm-i386/percpu.h |    4 ++--
 3 files changed, 3 insertions(+), 5 deletions(-)

Index: linux/arch/i386/kernel/Makefile
===================================================================
--- linux.orig/arch/i386/kernel/Makefile
+++ linux/arch/i386/kernel/Makefile
@@ -43,8 +43,6 @@ obj-$(CONFIG_VMI)		+= vmi.o vmitime.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-y				+= pcspeaker.o
 
-EXTRA_AFLAGS   := -traditional
-
 obj-$(CONFIG_SCx200)		+= scx200.o
 
 # vsyscall.o contains the vsyscall DSO images as __initdata.
Index: linux/arch/i386/kernel/entry.S
===================================================================
--- linux.orig/arch/i386/kernel/entry.S
+++ linux/arch/i386/kernel/entry.S
@@ -635,7 +635,7 @@ ENTRY(name)				\
 	SAVE_ALL;			\
 	TRACE_IRQS_OFF			\
 	movl %esp,%eax;			\
-	call smp_/**/name;		\
+	call smp_##name;		\
 	jmp ret_from_intr;		\
 	CFI_ENDPROC;			\
 ENDPROC(name)
Index: linux/include/asm-i386/percpu.h
===================================================================
--- linux.orig/include/asm-i386/percpu.h
+++ linux/include/asm-i386/percpu.h
@@ -20,10 +20,10 @@
 #ifdef CONFIG_SMP
 #define PER_CPU(var, cpu) \
 	movl __per_cpu_offset(,cpu,4), cpu;	\
-	addl $per_cpu__/**/var, cpu;
+	addl $per_cpu__##var, cpu;
 #else /* ! SMP */
 #define PER_CPU(var, cpu) \
-	movl $per_cpu__/**/var, cpu;
+	movl $per_cpu__##var, cpu;
 #endif	/* SMP */
 
 #endif /* !__ASSEMBLY__ */
