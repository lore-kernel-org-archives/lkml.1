Return-Path: <linux-kernel-owner+w=401wt.eu-S965291AbXCOFR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965291AbXCOFR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965338AbXCOFRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:17:25 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:52115 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965291AbXCOFQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:16:57 -0400
Message-Id: <20070315051529.702919481@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 03/20] bootflag.c switch
Content-Disposition: inline; filename=03-bootflag.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the bootflag.c to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index c8fe439..4622355 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -6,7 +6,7 @@ extra-y := head.o init_task.o vmlinux.lds
 
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_i386.o \
-		pci-dma.o i386_ksyms.o i387.o bootflag.o e820.o\
+		pci-dma.o i386_ksyms.o i387.o e820.o\
 		quirks.o i8237.o topology.o alternative.o i8253.o tsc.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index bd548e6..fe2e4ea 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -1,3 +1,4 @@
+obj-y				+= bootflag.o
 
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
diff --git a/arch/i386/kernel/bootflag.c b/arch/x86/kernel/bootflag.c
similarity index 100%
rename from arch/i386/kernel/bootflag.c
rename to arch/x86/kernel/bootflag.c
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index 54fe500..1ffc4ea 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -7,7 +7,7 @@ EXTRA_AFLAGS	:= -traditional
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_x86_64.o \
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
-		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
+		setup64.o e820.o reboot.o quirks.o i8237.o \
 		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
@@ -47,7 +47,6 @@ obj-y				+= pcspeaker.o
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
 
 therm_throt-y                   += ../../i386/kernel/cpu/mcheck/therm_throt.o
-bootflag-y			+= ../../i386/kernel/bootflag.o
 cpuid-$(subst m,y,$(CONFIG_X86_CPUID))  += ../../i386/kernel/cpuid.o
 topology-y                     += ../../i386/kernel/topology.o
 microcode-$(subst m,y,$(CONFIG_MICROCODE))  += ../../i386/kernel/microcode.o

--
