Return-Path: <linux-kernel-owner+w=401wt.eu-S965418AbXCOFSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418AbXCOFSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965289AbXCOFRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:17:39 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:52060 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965233AbXCOFQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:16:48 -0400
Message-Id: <20070315051530.063843269@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 05/20] i8237.c switch
Content-Disposition: inline; filename=06-i8237.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the i8237.c to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index c5c62af..1052659 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -7,7 +7,7 @@ extra-y := head.o init_task.o vmlinux.lds
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_i386.o \
 		pci-dma.o i386_ksyms.o i387.o e820.o\
-		i8237.o topology.o alternative.o i8253.o tsc.o
+		topology.o alternative.o i8253.o tsc.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 26feab4..19921b9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -1,4 +1,4 @@
-obj-y				+= bootflag.o quirks.o
+obj-y				+= bootflag.o quirks.o i8237.o
 
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
diff --git a/arch/i386/kernel/i8237.c b/arch/x86/kernel/i8237.c
similarity index 100%
rename from arch/i386/kernel/i8237.c
rename to arch/x86/kernel/i8237.c
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index 533d4bb..c04f7a6 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -7,7 +7,7 @@ EXTRA_AFLAGS	:= -traditional
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_x86_64.o \
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
-		setup64.o e820.o reboot.o i8237.o \
+		setup64.o e820.o reboot.o \
 		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
@@ -51,7 +51,6 @@ cpuid-$(subst m,y,$(CONFIG_X86_CPUID))  += ../../i386/kernel/cpuid.o
 topology-y                     += ../../i386/kernel/topology.o
 microcode-$(subst m,y,$(CONFIG_MICROCODE))  += ../../i386/kernel/microcode.o
 intel_cacheinfo-y		+= ../../i386/kernel/cpu/intel_cacheinfo.o
-i8237-y				+= ../../i386/kernel/i8237.o
 msr-$(subst m,y,$(CONFIG_X86_MSR))  += ../../i386/kernel/msr.o
 alternative-y			+= ../../i386/kernel/alternative.o
 pcspeaker-y			+= ../../i386/kernel/pcspeaker.o

--
