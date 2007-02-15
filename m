Return-Path: <linux-kernel-owner+w=401wt.eu-S1161347AbXBOVTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161347AbXBOVTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161340AbXBOVTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:19:14 -0500
Received: from gw.goop.org ([64.81.55.164]:35979 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161347AbXBOVTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:19:13 -0500
Message-ID: <45D4CE50.9020604@goop.org>
Date: Thu, 15 Feb 2007 13:19:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] No need to use -traditional for processing asm in i386/kernel/
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No need to use -traditional for processing asm in i386/kernel/

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

diff -r 2d901729b314 arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile	Thu Feb 15 13:00:50 2007 -0800
+++ b/arch/i386/kernel/Makefile	Thu Feb 15 13:10:49 2007 -0800
@@ -44,8 +44,6 @@ obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-y				+= pcspeaker.o
 
-EXTRA_AFLAGS   := -traditional
-
 obj-$(CONFIG_SCx200)		+= scx200.o
 
 # vsyscall.o contains the vsyscall DSO images as __initdata.
diff -r 2d901729b314 arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S	Thu Feb 15 13:00:50 2007 -0800
+++ b/arch/i386/kernel/entry.S	Thu Feb 15 13:10:49 2007 -0800
@@ -635,7 +635,7 @@ ENTRY(name)				\
 	SAVE_ALL;			\
 	TRACE_IRQS_OFF			\
 	movl %esp,%eax;			\
-	call smp_/**/name;		\
+	call smp_##name;		\
 	jmp ret_from_intr;		\
 	CFI_ENDPROC;			\
 ENDPROC(name)
diff -r 2d901729b314 include/asm-i386/percpu.h
--- a/include/asm-i386/percpu.h	Thu Feb 15 13:00:50 2007 -0800
+++ b/include/asm-i386/percpu.h	Thu Feb 15 13:10:49 2007 -0800
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


