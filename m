Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbZE2Xv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbZE2Xv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 19:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZE2XvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 19:51:21 -0400
Received: from jack.hrz.tu-chemnitz.de ([134.109.132.46]:52399 "EHLO
	jack.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZE2XvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 19:51:21 -0400
X-Greylist: delayed 2364 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 May 2009 19:51:20 EDT
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>
Subject: [PATCH] x86: add specific support for Intel Atom architecture
Date: Sat, 30 May 2009 01:11:39 +0200
Message-Id: <1243638699-15194-1-git-send-email-tobias.doerffel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 3610d579dd28009a7f55c56a8782bfc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds another option when selecting CPU family so the kernel can
be optimized for Intel Atom CPUs. If GCC supports tuning options for
Intel Atom they will be used.
---
 arch/x86/Kconfig.cpu          |   17 +++++++++++++----
 arch/x86/Makefile             |    2 ++
 arch/x86/Makefile_32.cpu      |    2 ++
 arch/x86/include/asm/module.h |    2 ++
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 8130334..f88a7f6 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -262,6 +262,15 @@ config MCORE2
 	  family in /proc/cpuinfo. Newer ones have 6 and older ones 15
 	  (not a typo)
 
+config MATOM
+	bool "Intel Atom"
+	---help---
+
+	  Select this for Intel Atom platform. Intel Atom CPUs have an in-order
+	  pipelining architecture and thus can benefit from in-order optimized
+	  code. Use a recent GCC with specific Intel Atom support in order to
+	  fully benefit from selecting this option.
+
 config GENERIC_CPU
 	bool "Generic-x86-64"
 	depends on X86_64
@@ -310,7 +319,7 @@ config X86_L1_CACHE_SHIFT
 	default "7" if MPENTIUM4 || MPSC
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
-	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7 || X86_GENERIC || GENERIC_CPU
+	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
 
 config X86_XADD
 	def_bool y
@@ -359,7 +368,7 @@ config X86_INTEL_USERCOPY
 
 config X86_USE_PPRO_CHECKSUM
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
 
 config X86_USE_3DNOW
 	def_bool y
@@ -387,7 +396,7 @@ config X86_P6_NOP
 
 config X86_TSC
 	def_bool y
-	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
+	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2 || MATOM) && !X86_NUMAQ) || X86_64
 
 config X86_CMPXCHG64
 	def_bool y
@@ -397,7 +406,7 @@ config X86_CMPXCHG64
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 8c86b72..c989eec 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -57,6 +57,8 @@ else
 
         cflags-$(CONFIG_MCORE2) += \
                 $(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
+	cflags-$(CONFIG_MATOM) += $(call cc-option,-march=atom) \
+		$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
         cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
         KBUILD_CFLAGS += $(cflags-y)
 
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 80177ec..30e9a26 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -33,6 +33,8 @@ cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-f
 cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
 cflags-$(CONFIG_MVIAC7)		+= -march=i686
 cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call tune,core2)
+cflags-$(CONFIG_MATOM)		+= $(call cc-option,-march=atom,$(call cc-option,-march=core2,-march=i686)) \
+	$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
 
 # AMD Elan support
 cflags-$(CONFIG_X86_ELAN)	+= -march=i486
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 47d6274..e959c4a 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -28,6 +28,8 @@ struct mod_arch_specific {};
 #define MODULE_PROC_FAMILY "586MMX "
 #elif defined CONFIG_MCORE2
 #define MODULE_PROC_FAMILY "CORE2 "
+#elif defined CONFIG_MATOM
+#define MODULE_PROC_FAMILY "ATOM "
 #elif defined CONFIG_M686
 #define MODULE_PROC_FAMILY "686 "
 #elif defined CONFIG_MPENTIUMII
-- 
1.6.3.1

