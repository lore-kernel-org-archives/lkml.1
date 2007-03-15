Return-Path: <linux-kernel-owner+w=401wt.eu-S965389AbXCOFXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965389AbXCOFXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965365AbXCOFXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:23:10 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:35421 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345AbXCOFR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:17:27 -0400
Message-Id: <20070315051531.695939835@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 12/20] mtrr directory switch
Content-Disposition: inline; filename=13-mtrr.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the mtrr directory over to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/cpu/Makefile b/arch/i386/kernel/cpu/Makefile
index 010aecf..f8eaef8 100644
--- a/arch/i386/kernel/cpu/Makefile
+++ b/arch/i386/kernel/cpu/Makefile
@@ -15,5 +15,4 @@ obj-y	+=	umc.o
 
 obj-$(CONFIG_X86_MCE)	+=	mcheck/
 
-obj-$(CONFIG_MTRR)	+= 	mtrr/
 obj-$(CONFIG_CPU_FREQ)	+=	cpufreq/
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 3e15c9e..c1a2b58 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -1,5 +1,7 @@
 obj-y				+= bootflag.o quirks.o i8237.o topology.o alternative.o
 
+obj-y				+= cpu/
+
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
new file mode 100644
index 0000000..3e59ae7
--- /dev/null
+++ b/arch/x86/kernel/cpu/Makefile
@@ -0,0 +1,2 @@
+
+obj-$(CONFIG_MTRR)	+= 	mtrr/
diff --git a/arch/i386/kernel/cpu/mtrr/Makefile b/arch/x86/kernel/cpu/mtrr/Makefile
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/Makefile
rename to arch/x86/kernel/cpu/mtrr/Makefile
diff --git a/arch/i386/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/amd.c
rename to arch/x86/kernel/cpu/mtrr/amd.c
diff --git a/arch/i386/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/centaur.c
rename to arch/x86/kernel/cpu/mtrr/centaur.c
diff --git a/arch/i386/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/cyrix.c
rename to arch/x86/kernel/cpu/mtrr/cyrix.c
diff --git a/arch/i386/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/generic.c
rename to arch/x86/kernel/cpu/mtrr/generic.c
diff --git a/arch/i386/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/if.c
rename to arch/x86/kernel/cpu/mtrr/if.c
diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/main.c
rename to arch/x86/kernel/cpu/mtrr/main.c
diff --git a/arch/i386/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/mtrr.h
rename to arch/x86/kernel/cpu/mtrr/mtrr.h
diff --git a/arch/i386/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/state.c
rename to arch/x86/kernel/cpu/mtrr/state.c
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index 3fae694..60918ad 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -14,7 +14,6 @@ obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd.o
-obj-$(CONFIG_MTRR)		+= ../../i386/kernel/cpu/mtrr/
 obj-$(CONFIG_ACPI)		+= acpi/
 obj-$(CONFIG_SMP)		+= smp.o smpboot.o trampoline.o
 obj-y				+= apic.o  nmi.o

--
