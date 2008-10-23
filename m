Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbYJWCNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbYJWCNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbYJWCIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43366 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754009AbYJWCI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:29 -0400
Message-Id: <20081023020828.685757000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:38 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/35] cpumask: make CONFIG_NR_CPUS always valid. From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:CONFIG_NR_CPUS-always.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have NR_CPUS, which is 1 on UP, and CONFIG_NR_CPUS on
SMP.  If we make CONFIG_NR_CPUS always valid (and always 1 on !SMP),
we can skip the middleman.

This also allows us to find and check all the remaining NR_CPUS users.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/alpha/Kconfig      |   10 +++++-----
 arch/arm/Kconfig        |    6 +++---
 arch/ia64/Kconfig       |    8 ++++----
 arch/m32r/Kconfig       |    8 ++++----
 arch/mips/Kconfig       |    4 ++--
 arch/parisc/Kconfig     |    8 ++++----
 arch/s390/Kconfig       |   10 +++++-----
 arch/sh/Kconfig         |   10 +++++-----
 arch/sparc/Kconfig      |    8 ++++----
 arch/sparc64/Kconfig    |    8 ++++----
 arch/um/Kconfig         |    8 ++++----
 arch/x86/Kconfig        |    6 +++---
 include/linux/threads.h |   10 ++--------
 13 files changed, 49 insertions(+), 55 deletions(-)

--- linux-2.6.28.orig/arch/alpha/Kconfig
+++ linux-2.6.28/arch/alpha/Kconfig
@@ -544,11 +544,11 @@ config HAVE_DEC_LOCK
 	default y
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-32)"
-	range 2 32
-	depends on SMP
-	default "32" if ALPHA_GENERIC || ALPHA_MARVEL
-	default "4" if !ALPHA_GENERIC && !ALPHA_MARVEL
+	int "Maximum number of CPUs (2-32)" if SMP
+	range 2 32 if SMP
+	default "1" if !SMP
+	default "32" if SMP && (ALPHA_GENERIC || ALPHA_MARVEL)
+	default "4" if SMP && (!ALPHA_GENERIC && !ALPHA_MARVEL)
 	help
 	  MARVEL support can handle a maximum of 32 CPUs, all the others
           with working support have a maximum of 4 CPUs.
--- linux-2.6.28.orig/arch/arm/Kconfig
+++ linux-2.6.28/arch/arm/Kconfig
@@ -769,9 +769,9 @@ config PAGE_OFFSET
 	default 0xC0000000
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-32)"
-	range 2 32
-	depends on SMP
+	int "Maximum number of CPUs (2-32)" if SMP
+	range 2 32 if SMP
+	default "1" if !SMP
 	default "4"
 
 config HOTPLUG_CPU
--- linux-2.6.28.orig/arch/ia64/Kconfig
+++ linux-2.6.28/arch/ia64/Kconfig
@@ -315,10 +315,10 @@ config SMP
 	  If you don't know what to do here, say N.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-4096)"
-	range 2 4096
-	depends on SMP
-	default "4096"
+	int "Maximum number of CPUs (2-4096)" if SMP
+	range 2 4096 if SMP
+	default "1" if !SMP
+	default "4096" if SMP
 	help
 	  You should set this to the number of CPUs in your system, but
 	  keep in mind that a kernel compiled for, e.g., 2 CPUs will boot but
--- linux-2.6.28.orig/arch/m32r/Kconfig
+++ linux-2.6.28/arch/m32r/Kconfig
@@ -319,10 +319,10 @@ config CHIP_M32700_TS1
 	default n
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-32)"
-	range 2 32
-	depends on SMP
-	default "2"
+	int "Maximum number of CPUs (2-32)" if SMP
+	range 2 32 if SMP
+	default "1" if !SMP
+	default "2" if SMP
 	help
 	  This allows you to specify the maximum number of CPUs which this
 	  kernel will support.  The maximum supported value is 32 and the
--- linux-2.6.28.orig/arch/mips/Kconfig
+++ linux-2.6.28/arch/mips/Kconfig
@@ -1719,9 +1719,9 @@ config NR_CPUS_DEFAULT_64
 	bool
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-64)"
+	int "Maximum number of CPUs (2-64)" if SMP
 	range 1 64 if NR_CPUS_DEFAULT_1
-	depends on SMP
+	default "1" if !SMP
 	default "1" if NR_CPUS_DEFAULT_1
 	default "2" if NR_CPUS_DEFAULT_2
 	default "4" if NR_CPUS_DEFAULT_4
--- linux-2.6.28.orig/arch/parisc/Kconfig
+++ linux-2.6.28/arch/parisc/Kconfig
@@ -256,10 +256,10 @@ config HPUX
 	depends on !64BIT
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-32)"
-	range 2 32
-	depends on SMP
-	default "32"
+	int "Maximum number of CPUs (2-32)" if SMP
+	range 2 32 if SMP
+	default "1" if !SMP
+	default "32" if SMP
 
 endmenu
 
--- linux-2.6.28.orig/arch/s390/Kconfig
+++ linux-2.6.28/arch/s390/Kconfig
@@ -116,11 +116,11 @@ config SMP
 	  Even if you don't know what to do here, say Y.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-64)"
-	range 2 64
-	depends on SMP
-	default "32" if !64BIT
-	default "64" if 64BIT
+	int "Maximum number of CPUs (2-64)" if SMP
+	range 2 64 if SMP
+	default "1" if !SMP
+	default "32" if SMP && !64BIT
+	default "64" if SMP && 64BIT
 	help
 	  This allows you to specify the maximum number of CPUs which this
 	  kernel will support.  The maximum supported value is 64 and the
--- linux-2.6.28.orig/arch/sh/Kconfig
+++ linux-2.6.28/arch/sh/Kconfig
@@ -545,11 +545,11 @@ config SMP
 	  If you don't know what to do here, say N.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-32)"
-	range 2 32
-	depends on SMP
-	default "4" if CPU_SHX3
-	default "2"
+	int "Maximum number of CPUs (2-32)" if SMP
+	range 2 32 if SMP
+	default "1" if !SMP
+	default "4" if SMP && CPU_SHX3
+	default "2" if SMP
 	help
 	  This allows you to specify the maximum number of CPUs which this
 	  kernel will support.  The maximum supported value is 32 and the
--- linux-2.6.28.orig/arch/sparc/Kconfig
+++ linux-2.6.28/arch/sparc/Kconfig
@@ -64,10 +64,10 @@ config SMP
 	  If you don't know what to do here, say N.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-32)"
-	range 2 32
-	depends on SMP
-	default "32"
+	int "Maximum number of CPUs (2-32)" if SMP
+	range 2 32 if SMP
+	default "1" if SMP
+	default "32" if SMP
 
 config SPARC
 	bool
--- linux-2.6.28.orig/arch/sparc64/Kconfig
+++ linux-2.6.28/arch/sparc64/Kconfig
@@ -169,10 +169,10 @@ config SMP
 	  If you don't know what to do here, say N.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-1024)"
-	range 2 1024
-	depends on SMP
-	default "64"
+	int "Maximum number of CPUs (2-1024)" if SMP
+	range 2 1024 if SMP
+	default "1" if !SMP
+	default "64" if SMP
 
 source "drivers/cpufreq/Kconfig"
 
--- linux-2.6.28.orig/arch/um/Kconfig
+++ linux-2.6.28/arch/um/Kconfig
@@ -198,10 +198,10 @@ config SMP
 	  If you don't know what to do, say N.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-32)"
-	range 2 32
-	depends on SMP
-	default "32"
+	int "Maximum number of CPUs (2-32)" if SMP
+	range 2 32 if SMP
+	default "1" if !SMP
+	default "32" if SMP
 
 config HIGHMEM
 	bool "Highmem support (EXPERIMENTAL)"
--- linux-2.6.28.orig/arch/x86/Kconfig
+++ linux-2.6.28/arch/x86/Kconfig
@@ -585,12 +585,12 @@ config MAXSMP
 	  If unsure, say N.
 
 config NR_CPUS
-	depends on SMP
  	int "Maximum number of CPUs" if SMP && !MAXSMP
  	range 2 512 if SMP && !MAXSMP
+	default "1" if !SMP
 	default "4096" if MAXSMP
- 	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
-	default "8"
+	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
+	default "8" if SMP
 	help
 	  This allows you to specify the maximum number of CPUs which this
 	  kernel will support.  The maximum supported value is 512 (4096
--- linux-2.6.28.orig/include/linux/threads.h
+++ linux-2.6.28/include/linux/threads.h
@@ -8,16 +8,10 @@
  */
 
 /*
- * Maximum supported processors that can run under SMP.  This value is
- * set via configure setting.  The maximum is equal to the size of the
- * bitmasks used on that platform, i.e. 32 or 64.  Setting this smaller
- * saves quite a bit of memory.
+ * Maximum supported processors.  Setting this smaller saves quite a
+ * bit of memory.  Use nr_cpu_ids instead of this except for bitmaps.
  */
-#ifdef CONFIG_SMP
 #define NR_CPUS		CONFIG_NR_CPUS
-#else
-#define NR_CPUS		1
-#endif
 
 #define MIN_THREADS_LEFT_FOR_ROOT 4
 

-- 
