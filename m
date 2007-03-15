Return-Path: <linux-kernel-owner+w=401wt.eu-S965323AbXCOFU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965323AbXCOFU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965312AbXCOFUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:20:32 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:35459 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965396AbXCOFRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:17:37 -0400
Message-Id: <20070315051531.873154829@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 13/20] therm_throt.c switch
Content-Disposition: inline; filename=14-therm_throt.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the therm_throt.c to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/cpu/mcheck/Makefile b/arch/i386/kernel/cpu/mcheck/Makefile
index f1ebe1c..30808f3 100644
--- a/arch/i386/kernel/cpu/mcheck/Makefile
+++ b/arch/i386/kernel/cpu/mcheck/Makefile
@@ -1,2 +1,2 @@
-obj-y	=	mce.o k7.o p4.o p5.o p6.o winchip.o therm_throt.o
+obj-y	=	mce.o k7.o p4.o p5.o p6.o winchip.o
 obj-$(CONFIG_X86_MCE_NONFATAL)	+=	non-fatal.o
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3e59ae7..e439cc1 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -1,2 +1,3 @@
 
+obj-$(CONFIG_X86_MCE)	+=	mcheck/
 obj-$(CONFIG_MTRR)	+= 	mtrr/
diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
new file mode 100644
index 0000000..4018cde
--- /dev/null
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -0,0 +1 @@
+obj-y	= therm_throt.o
diff --git a/arch/i386/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
similarity index 100%
rename from arch/i386/kernel/cpu/mcheck/therm_throt.c
rename to arch/x86/kernel/cpu/mcheck/therm_throt.c
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index 60918ad..ef1585d 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -11,7 +11,7 @@ obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		pci-dma.o pci-nommu.o hpet.o tsc.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
-obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
+obj-$(CONFIG_X86_MCE)		+= mce.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd.o
 obj-$(CONFIG_ACPI)		+= acpi/
@@ -40,5 +40,4 @@ obj-y				+= intel_cacheinfo.o
 
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
 
-therm_throt-y                   += ../../i386/kernel/cpu/mcheck/therm_throt.o
 intel_cacheinfo-y		+= ../../i386/kernel/cpu/intel_cacheinfo.o

--
