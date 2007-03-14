Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbXCNFL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbXCNFL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933830AbXCNFL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:11:58 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45229 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933827AbXCNFL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:11:58 -0400
Message-Id: <20070314051048.206957645@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 04/18] make the cpu/cpufreq/Makefile
Content-Disposition: inline; filename=cpu-freq-makefile.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create the arch/x86/kernel/cpu/cpufreq/Makefile and update the
i386 and x86_64 accordingly.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile b/arch/x86/kernel/cpu/cpufreq/Makefile
new file mode 100644
index 0000000..51b32fe
--- /dev/null
+++ b/arch/x86/kernel/cpu/cpufreq/Makefile
@@ -0,0 +1,6 @@
+
+obj-$(CONFIG_X86_POWERNOW_K8) += powernow-k8.o
+obj-$(CONFIG_X86_ACPI_CPUFREQ) += acpi-cpufreq.o
+obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO) += speedstep-centrino.o
+obj-$(CONFIG_X86_P4_CLOCKMOD) += p4-clockmod.o
+obj-$(CONFIG_X86_SPEEDSTEP_LIB) += speedstep-lib.o
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

--
