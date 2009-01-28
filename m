Return-Path: <linux-kernel-owner+w=401wt.eu-S1761429AbZA2A14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429AbZA2A14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758708AbZA1Xr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:53446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758464AbZA1XrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:25 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 110/114] x86: move non-standard 32-bit platform Kconfig entries
Date: Wed, 28 Jan 2009 23:42:56 +0000
Message-Id: <1233186180-29883-111-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:47:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- make X86_GENERICARCH depend X86_NON_STANDARD

- move X86_SUMMIT, X86_ES7000 and X86_BIGSMP out of the subarchitecture
  menu and under this option

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |   88 ++++++++++++++++++++++++++---------------------------
 1 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 207dc95..2fe2982 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -271,51 +271,6 @@ config X86_PC
 	help
 	  Choose this option if your computer is a standard PC or compatible.
 
-config X86_GENERICARCH
-       bool "Generic architecture"
-	depends on X86_32
-       help
-          This option compiles in the NUMAQ, Summit, bigsmp, ES7000, default
-	  subarchitectures.  It is intended for a generic binary kernel.
-	  if you select them all, kernel will probe it one by one. and will
-	  fallback to default.
-
-if X86_GENERICARCH
-
-config X86_NUMAQ
-	bool "NUMAQ (IBM/Sequent)"
-	depends on SMP && X86_32 && PCI && X86_MPPARSE
-	select NUMA
-	help
-	  This option is used for getting Linux to run on a NUMAQ (IBM/Sequent)
-	  NUMA multiquad box. This changes the way that processors are
-	  bootstrapped, and uses Clustered Logical APIC addressing mode instead
-	  of Flat Logical.  You will need a new lynxer.elf file to flash your
-	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
-
-config X86_SUMMIT
-	bool "Summit/EXA (IBM x440)"
-	depends on X86_32 && SMP
-	help
-	  This option is needed for IBM systems that use the Summit/EXA chipset.
-	  In particular, it is needed for the x440.
-
-config X86_ES7000
-	bool "Support for Unisys ES7000 IA32 series"
-	depends on X86_32 && SMP
-	help
-	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
-	  supposed to run on an IA32-based Unisys ES7000 system.
-
-config X86_BIGSMP
-	bool "Support for big SMP systems with more than 8 CPUs"
-	depends on X86_32 && SMP
-	help
-	  This option is needed for the systems that have more than 8 CPUs
-	  and if the system is not of any sub-arch type above.
-
-endif
-
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
 	select PARAVIRT
@@ -396,6 +351,49 @@ config X86_VOYAGER
 	  If you do not specifically know you have a Voyager based machine,
 	  say N here, otherwise the kernel you build will not be bootable.
 
+config X86_GENERICARCH
+	bool "Support non-standard 32-bit SMP architectures"
+	depends on X86_32 && SMP
+	depends on X86_NON_STANDARD
+	help
+          This option compiles in the NUMAQ, Summit, bigsmp, ES7000, default
+	  subarchitectures.  It is intended for a generic binary kernel.
+	  if you select them all, kernel will probe it one by one. and will
+	  fallback to default.
+
+config X86_NUMAQ
+	bool "NUMAQ (IBM/Sequent)"
+	depends on X86_GENERICARCH
+	select NUMA
+	select X86_MPPARSE
+	help
+	  This option is used for getting Linux to run on a NUMAQ (IBM/Sequent)
+	  NUMA multiquad box. This changes the way that processors are
+	  bootstrapped, and uses Clustered Logical APIC addressing mode instead
+	  of Flat Logical.  You will need a new lynxer.elf file to flash your
+	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
+
+config X86_SUMMIT
+	bool "Summit/EXA (IBM x440)"
+	depends on X86_GENERICARCH
+	help
+	  This option is needed for IBM systems that use the Summit/EXA chipset.
+	  In particular, it is needed for the x440.
+
+config X86_ES7000
+	bool "Support for Unisys ES7000 IA32 series"
+	depends on X86_GENERICARCH
+	help
+	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
+	  supposed to run on an IA32-based Unisys ES7000 system.
+
+config X86_BIGSMP
+	bool "Support for big SMP systems with more than 8 CPUs"
+	depends on X86_GENERICARCH
+	help
+	  This option is needed for the systems that have more than 8 CPUs
+	  and if the system is not of any sub-arch type above.
+
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
-- 
1.6.0.2

