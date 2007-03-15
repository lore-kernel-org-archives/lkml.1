Return-Path: <linux-kernel-owner+w=401wt.eu-S965263AbXCOFR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263AbXCOFR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965259AbXCOFRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:17:48 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:45096 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965263AbXCOFQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:16:51 -0400
Message-Id: <20070315051532.752975404@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 18/20] stacktrace.c switch
Content-Disposition: inline; filename=19-stacktrace.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the stacktrace.c to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index 72e11f7..a5cf2e7 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -9,7 +9,6 @@ obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		pci-dma.o i386_ksyms.o i387.o e820.o\
 		i8253.o tsc.o
 
-obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
 obj-$(CONFIG_X86_BIOS_REBOOT)	+= reboot.o
@@ -77,5 +76,3 @@ $(obj)/vsyscall-syms.o: $(src)/vsyscall.lds \
 			$(obj)/vsyscall-sysenter.o $(obj)/vsyscall-note.o FORCE
 	$(call if_changed,syscall)
 
-stacktrace-y		  += ../../x86_64/kernel/stacktrace.o
-
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 06c335d..297cde9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -1,5 +1,7 @@
 obj-y				+= bootflag.o quirks.o i8237.o topology.o alternative.o
 
+obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
+
 obj-y				+= cpu/
 obj-$(CONFIG_ACPI)		+= acpi/
 
diff --git a/arch/x86_64/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
similarity index 100%
rename from arch/x86_64/kernel/stacktrace.c
rename to arch/x86/kernel/stacktrace.c
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index 0510887..7477cb1 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -10,7 +10,6 @@ obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		setup64.o e820.o reboot.o \
 		pci-dma.o pci-nommu.o hpet.o tsc.o
 
-obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_X86_MCE)		+= mce.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd.o

--
