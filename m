Return-Path: <linux-kernel-owner+w=401wt.eu-S965337AbXCOFRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbXCOFRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965236AbXCOFQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:16:47 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:47813 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965233AbXCOFQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:16:46 -0400
Message-Id: <20070315051531.335255998@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 10/20] microcode.c switch
Content-Disposition: inline; filename=11-microcode.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the microcode.c to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index 4437181..ac925bc 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -14,7 +14,6 @@ obj-y				+= cpu/
 obj-y				+= acpi/
 obj-$(CONFIG_X86_BIOS_REBOOT)	+= reboot.o
 obj-$(CONFIG_MCA)		+= mca.o
-obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp.o smpboot.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 912421a..f1c6b2e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -2,6 +2,7 @@ obj-y				+= bootflag.o quirks.o i8237.o topology.o alternative.o
 
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
+obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
 # i386 defines CONFIG_X86_SMP when CONFIG_SMP and !CONFIG_X86_VOYAGER
diff --git a/arch/i386/kernel/microcode.c b/arch/x86/kernel/microcode.c
similarity index 100%
rename from arch/i386/kernel/microcode.c
rename to arch/x86/kernel/microcode.c
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index f5997f3..08795d8 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd.o
 obj-$(CONFIG_MTRR)		+= ../../i386/kernel/cpu/mtrr/
 obj-$(CONFIG_ACPI)		+= acpi/
-obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_SMP)		+= smp.o smpboot.o trampoline.o
 obj-y				+= apic.o  nmi.o
 obj-y				+= io_apic.o mpparse.o \
@@ -44,6 +43,5 @@ obj-y				+= pcspeaker.o
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
 
 therm_throt-y                   += ../../i386/kernel/cpu/mcheck/therm_throt.o
-microcode-$(subst m,y,$(CONFIG_MICROCODE))  += ../../i386/kernel/microcode.o
 intel_cacheinfo-y		+= ../../i386/kernel/cpu/intel_cacheinfo.o
 pcspeaker-y			+= ../../i386/kernel/pcspeaker.o

--
