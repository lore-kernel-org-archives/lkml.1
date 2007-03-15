Return-Path: <linux-kernel-owner+w=401wt.eu-S965310AbXCOFVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310AbXCOFVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965349AbXCOFVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:21:45 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:35456 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242AbXCOFRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:17:36 -0400
Message-Id: <20070315051532.220959455@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 15/20] cpufreq files switched
Content-Disposition: inline; filename=16-cpufreq.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Moved the shared files that were in the arch/i386/kernel/cpu/cpufreq to
the common area.  Since the speedstep-lib.h file was used by files that
were moved as well as files that were not moved, a new directory was
created to hold this shared header, called include/asm-x86.  Since this
directory is not full featured yet (no x86 arch fully defined) all references
to this file must be of #include <asm-x86/speedstep-lib.h>

But this allows for a stepping stone approach to a generic x86 arch and
a place to put more asm-x86 headers.

The Kconfig for cpufreq in the x86_64 arch directory is not moved
to simplify this patch.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Chris Wright <chrisw@sous-sol.org>

diff --git a/arch/i386/kernel/cpu/cpufreq/Makefile b/arch/i386/kernel/cpu/cpufreq/Makefile
index 560f776..49c4ca4 100644
--- a/arch/i386/kernel/cpu/cpufreq/Makefile
+++ b/arch/i386/kernel/cpu/cpufreq/Makefile
@@ -1,6 +1,6 @@
+# See also arch/x86/kernel/cpu/cpufreq/Makefile
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
 obj-$(CONFIG_X86_POWERNOW_K7)		+= powernow-k7.o
-obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
 obj-$(CONFIG_X86_LONGHAUL)		+= longhaul.o
 obj-$(CONFIG_X86_E_POWERSAVER)		+= e_powersaver.o
 obj-$(CONFIG_ELAN_CPUFREQ)		+= elanfreq.o
@@ -8,9 +8,5 @@ obj-$(CONFIG_SC520_CPUFREQ)		+= sc520_freq.o
 obj-$(CONFIG_X86_LONGRUN)		+= longrun.o  
 obj-$(CONFIG_X86_GX_SUSPMOD)		+= gx-suspmod.o
 obj-$(CONFIG_X86_SPEEDSTEP_ICH)		+= speedstep-ich.o
-obj-$(CONFIG_X86_SPEEDSTEP_LIB)		+= speedstep-lib.o
 obj-$(CONFIG_X86_SPEEDSTEP_SMI)		+= speedstep-smi.o
-obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o
-obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO)	+= speedstep-centrino.o
-obj-$(CONFIG_X86_P4_CLOCKMOD)		+= p4-clockmod.o
 obj-$(CONFIG_X86_CPUFREQ_NFORCE2)	+= cpufreq-nforce2.o
diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-ich.c b/arch/i386/kernel/cpu/cpufreq/speedstep-ich.c
index b425cd3..97c14b3 100644
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/i386/kernel/cpu/cpufreq/speedstep-ich.c
@@ -25,7 +25,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 
-#include "speedstep-lib.h"
+#include <asm-x86/speedstep-lib.h>
 
 
 /* speedstep_chipset:
diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-smi.c b/arch/i386/kernel/cpu/cpufreq/speedstep-smi.c
index ff0d898..093d7d0 100644
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-smi.c
+++ b/arch/i386/kernel/cpu/cpufreq/speedstep-smi.c
@@ -22,7 +22,7 @@
 #include <linux/delay.h>
 #include <asm/ist.h>
 
-#include "speedstep-lib.h"
+#include <asm-x86/speedstep-lib.h>
 
 /* speedstep system management interface port/command.
  *
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6557e4a..4728c89 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -2,3 +2,4 @@ obj-y			+=	intel_cacheinfo.o
 
 obj-$(CONFIG_X86_MCE)	+=	mcheck/
 obj-$(CONFIG_MTRR)	+= 	mtrr/
+obj-$(CONFIG_CPU_FREQ)	+=	cpufreq/
diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile b/arch/x86/kernel/cpu/cpufreq/Makefile
new file mode 100644
index 0000000..883fae4
--- /dev/null
+++ b/arch/x86/kernel/cpu/cpufreq/Makefile
@@ -0,0 +1,6 @@
+
+obj-$(CONFIG_X86_POWERNOW_K8) += powernow-k8.o
+obj-$(CONFIG_X86_SPEEDSTEP_LIB) += speedstep-lib.o
+obj-$(CONFIG_X86_ACPI_CPUFREQ) += acpi-cpufreq.o
+obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO) += speedstep-centrino.o
+obj-$(CONFIG_X86_P4_CLOCKMOD) += p4-clockmod.o
diff --git a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
rename to arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
diff --git a/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
rename to arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index 4786fed..5024ea8 100644
--- a/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -33,7 +33,7 @@
 #include <asm/msr.h>
 #include <asm/timex.h>
 
-#include "speedstep-lib.h"
+#include <asm-x86/speedstep-lib.h>
 
 #define PFX	"p4-clockmod: "
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "p4-clockmod", msg)
diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/powernow-k8.c
rename to arch/x86/kernel/cpu/cpufreq/powernow-k8.c
diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/powernow-k8.h
rename to arch/x86/kernel/cpu/cpufreq/powernow-k8.h
diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
rename to arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-lib.c b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/speedstep-lib.c
rename to arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
index d59277c..2de6a69 100644
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-lib.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 
 #include <asm/msr.h>
-#include "speedstep-lib.h"
+#include <asm-x86/speedstep-lib.h>
 
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-lib", msg)
 
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index 0a33b03..3d90462 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -23,7 +23,6 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_PM)		+= suspend.o
 obj-$(CONFIG_SOFTWARE_SUSPEND)	+= suspend_asm.o
-obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_IOMMU)		+= pci-gart.o aperture.o
 obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary.o tce.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
diff --git a/arch/x86_64/kernel/cpufreq/Makefile b/arch/x86_64/kernel/cpufreq/Makefile
deleted file mode 100644
index 753ce1d..0000000
--- a/arch/x86_64/kernel/cpufreq/Makefile
+++ /dev/null
@@ -1,17 +0,0 @@
-#
-# Reuse the i386 cpufreq drivers
-#
-
-SRCDIR := ../../../i386/kernel/cpu/cpufreq
-
-obj-$(CONFIG_X86_POWERNOW_K8) += powernow-k8.o
-obj-$(CONFIG_X86_ACPI_CPUFREQ) += acpi-cpufreq.o
-obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO) += speedstep-centrino.o
-obj-$(CONFIG_X86_P4_CLOCKMOD) += p4-clockmod.o
-obj-$(CONFIG_X86_SPEEDSTEP_LIB) += speedstep-lib.o
-
-powernow-k8-objs := ${SRCDIR}/powernow-k8.o
-speedstep-centrino-objs := ${SRCDIR}/speedstep-centrino.o
-acpi-cpufreq-objs := ${SRCDIR}/acpi-cpufreq.o
-p4-clockmod-objs := ${SRCDIR}/p4-clockmod.o
-speedstep-lib-objs := ${SRCDIR}/speedstep-lib.o
diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-lib.h b/include/asm-x86/speedstep-lib.h
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/speedstep-lib.h
rename to include/asm-x86/speedstep-lib.h

--
