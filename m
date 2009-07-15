Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZGOPTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZGOPTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbZGOPS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:18:58 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:45272 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbZGOPS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:18:29 -0400
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2009 11:18:29 EDT
From: Christopher SMITH <chris.smith@st.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Smith <chris.smith@st.com>
Subject: [PATCH] oprofile: Move the Kconfig options to a "Profiling" section
Date: Wed, 15 Jul 2009 15:57:24 +0100
Message-Id: <1247669844-22707-1-git-send-email-chris.smith@st.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the oprofile Kconfig options from "General Setup" to
a dedicated "Profiling" section under Kernel Hacking.

Signed-off-by: Chris Smith <chris.smith@st.com>
---
IMHO, it seems a more intuitive place to keep them?
---
 arch/Kconfig             |   31 -----------------------------
 drivers/oprofile/Kconfig |   48 ++++++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig             |    6 -----
 lib/Kconfig.debug        |    1 +
 4 files changed, 49 insertions(+), 37 deletions(-)
 create mode 100644 drivers/oprofile/Kconfig

diff --git a/arch/Kconfig b/arch/Kconfig
index 99193b1..5310913 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -2,37 +2,6 @@
 # General architecture dependent options
 #
 
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	depends on HAVE_OPROFILE
-	depends on TRACING_SUPPORT
-	select TRACING
-	select RING_BUFFER
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config OPROFILE_IBS
-	bool "OProfile AMD IBS support (EXPERIMENTAL)"
-	default n
-	depends on OPROFILE && SMP && X86
-	help
-          Instruction-Based Sampling (IBS) is a new profiling
-          technique that provides rich, precise program performance
-          information. IBS is introduced by AMD Family10h processors
-          (AMD Opteron Quad-Core processor "Barcelona") to overcome
-          the limitations of conventional performance counter
-          sampling.
-
-	  If unsure, say N.
-
-config HAVE_OPROFILE
-	bool
-
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES
diff --git a/drivers/oprofile/Kconfig b/drivers/oprofile/Kconfig
new file mode 100644
index 0000000..59d8dc5
--- /dev/null
+++ b/drivers/oprofile/Kconfig
@@ -0,0 +1,48 @@
+menuconfig PROFILING
+	bool "Profiling support (EXPERIMENTAL)"
+        default y if DEBUG_KERNEL
+	help
+	  Say Y here to enable the extended profiling support mechanisms used
+	  by profilers such as OProfile.
+
+if PROFILING
+
+config OPROFILE
+	tristate "OProfile system profiling (EXPERIMENTAL)"
+	depends on PROFILING
+	depends on HAVE_OPROFILE
+	depends on TRACING_SUPPORT
+	select TRACING
+	select RING_BUFFER
+	help
+	  OProfile is a profiling system capable of profiling the
+	  whole system, include the kernel, kernel modules, libraries,
+	  and applications.
+
+	  If unsure, say N.
+
+config OPROFILE_PWM
+	bool "Use 710x PWM for profiling"
+	depends on OPROFILE
+	depends on CPU_SUBTYPE_STB7100
+	help
+	  Say Y here to use the 710x PWM timer for oprofile sampling.
+
+config OPROFILE_IBS
+	bool "OProfile AMD IBS support (EXPERIMENTAL)"
+	default n
+	depends on OPROFILE && SMP && X86
+	help
+          Instruction-Based Sampling (IBS) is a new profiling
+          technique that provides rich, precise program performance
+          information. IBS is introduced by AMD Family10h processors
+          (AMD Opteron Quad-Core processor "Barcelona") to overcome
+          the limitations of conventional performance counter
+          sampling.
+
+	  If unsure, say N.
+
+config HAVE_OPROFILE
+	bool
+
+endif # PROFILING
diff --git a/init/Kconfig b/init/Kconfig
index 1ce05a4..1954988 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1048,12 +1048,6 @@ config SLOB
 
 endchoice
 
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
 #
 # Place an empty function call at each tracepoint site. Can be
 # dynamically changed for a probe function.
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 12327b2..7067b3b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -881,6 +881,7 @@ config SYSCTL_SYSCALL_CHECK
 
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
+source drivers/oprofile/Kconfig
 
 config PROVIDE_OHCI1394_DMA_INIT
 	bool "Remote debugging over FireWire early on boot"
-- 
1.6.0.6

