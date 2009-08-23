Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZHWJWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZHWJWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbZHWJWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:22:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:38015 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918AbZHWJWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:22:06 -0400
Date: Sun, 23 Aug 2009 09:21:38 GMT
From: tip-bot for Tobias Doerffel <tobias.doerffel@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tobias.doerffel@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tobias.doerffel@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1251018457-19157-1-git-send-email-tobias.doerffel@gmail.com>
References: <1251018457-19157-1-git-send-email-tobias.doerffel@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: add specific support for Intel Atom architecture
Message-ID: <tip-366d19e181be873c70f4aafca3931d77d781ccd7@git.kernel.org>
Git-Commit-ID: 366d19e181be873c70f4aafca3931d77d781ccd7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 23 Aug 2009 09:21:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  366d19e181be873c70f4aafca3931d77d781ccd7
Gitweb:     http://git.kernel.org/tip/366d19e181be873c70f4aafca3931d77d781ccd7
Author:     Tobias Doerffel <tobias.doerffel@gmail.com>
AuthorDate: Fri, 21 Aug 2009 23:06:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 23 Aug 2009 11:20:02 +0200

x86: add specific support for Intel Atom architecture

Add another option when selecting CPU family so the kernel can be
optimized for Intel Atom CPUs. If GCC supports tuning options for
Intel Atom they will be used.

Signed-off-by: Tobias Doerffel <tobias.doerffel@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <1251018457-19157-1-git-send-email-tobias.doerffel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig.cpu          |   19 ++++++++++++++-----
 arch/x86/Makefile             |    2 ++
 arch/x86/Makefile_32.cpu      |    2 ++
 arch/x86/include/asm/module.h |    2 ++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 8130334..527519b 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -262,6 +262,15 @@ config MCORE2
 	  family in /proc/cpuinfo. Newer ones have 6 and older ones 15
 	  (not a typo)
 
+config MATOM
+	bool "Intel Atom"
+	---help---
+
+	  Select this for the Intel Atom platform. Intel Atom CPUs have an
+	  in-order pipelining architecture and thus can benefit from
+	  accordingly optimized code. Use a recent GCC with specific Atom
+	  support in order to fully benefit from selecting this option.
+
 config GENERIC_CPU
 	bool "Generic-x86-64"
 	depends on X86_64
@@ -295,7 +304,7 @@ config X86_CPU
 config X86_L1_CACHE_BYTES
 	int
 	default "128" if MPSC
-	default "64" if GENERIC_CPU || MK8 || MCORE2 || X86_32
+	default "64" if GENERIC_CPU || MK8 || MCORE2 || MATOM || X86_32
 
 config X86_INTERNODE_CACHE_BYTES
 	int
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
index 1b68659..8a4c24c 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -55,6 +55,8 @@ else
 
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
