Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbYJPSsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbYJPSsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYJPSr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:47:59 -0400
Received: from 0x55512ece.adsl.cybercity.dk ([85.81.46.206]:22963 "EHLO
	sko.w0.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbYJPSr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:47:58 -0400
Date: Thu, 16 Oct 2008 20:47:55 +0200 (CEST)
From: Hans Schou <linux@schou.dk>
X-X-Sender: linux@sko.w0.dk
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] SiS55x, another x86 CPU
In-Reply-To: <48F6E3DE.10206@zytor.com>
Message-ID: <Pine.LNX.4.64.0810162032040.7314@sko.w0.dk>
References: <Pine.LNX.4.64.0810111143210.23344@sko.w0.dk> <48F6E3DE.10206@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, H. Peter Anvin wrote:

> Hans Schou wrote:
>>
>>  Detected CPU flags in /proc/cpuinfo and in the datasheet:
>>  flags           : fpu tsc cx8 mmx
>>
>>  Instruction and data cache is 8KB each it says in the datasheet. I'm not
>>  sure but it does not look like it is written in dmesg.
>> 
>
> Could you post /proc/cpuinfo from this machine?

Sure. Here it is with a kernel 2.6.25 - not the patch below:

processor	: 0
vendor_id	: SiS SiS SiS 
cpu family	: 5
model		: 0
model name	: 05/00
stepping	: 5
cpu MHz		: 200.008
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu tsc cx8 mmx
bogomips	: 401.32
clflush size	: 32

Please note that the vendor_id has a space in the end:
"SiS SiS SiS "

> P.S. Please send x86 patches to x86@kernel.org as well as LKML.

OK. I had a problem with Pine doing linewrap. I try again.

diff -Naur a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
--- a/arch/x86/Kconfig.cpu	2008-10-11 23:03:47.000000000 +0200
+++ b/arch/x86/Kconfig.cpu	2008-10-12 00:30:08.000000000 +0200
@@ -242,6 +242,13 @@
  	  Select this for a VIA C7.  Selecting this uses the correct cache
  	  shift and tells gcc to treat the CPU as a 686.

+config MSIS55X
+	bool "SiS55x"
+	depends on X86_32
+	help
+	  Select this for a SiS550/551/552 SoC. Selecting this uses the
+	  correct cache shift and tells gcc to treat the CPU as a 586.
+
  config MPSC
  	bool "Intel P4 / older Netburst based Xeon"
  	depends on X86_64
@@ -309,7 +316,7 @@
  	int
  	default "7" if MPENTIUM4 || X86_GENERIC || GENERIC_CPU || MPSC
  	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
-	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
+	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX || MSIS55X
  	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7

  config X86_XADD
@@ -351,7 +358,7 @@

  config X86_ALIGNMENT_16
  	def_bool y
-	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1 || MSIS55X

  config X86_INTEL_USERCOPY
  	def_bool y
@@ -387,7 +394,7 @@

  config X86_TSC
  	def_bool y
-	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
+	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MSIS55X || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64

  config X86_CMPXCHG64
  	def_bool y
@@ -464,6 +471,13 @@
  	help
  	  This enables extended support for UMC processors

+config CPU_SUP_SIS_32
+	default y
+	bool "Support SiS processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for SiS processors
+
  config X86_DS
  	bool "Debug Store support"
  	default y
diff -Naur a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
--- a/arch/x86/kernel/cpu/Makefile	2008-10-11 23:03:47.000000000 +0200
+++ b/arch/x86/kernel/cpu/Makefile	2008-10-03 23:56:53.000000000 +0200
@@ -15,6 +15,7 @@
  obj-$(CONFIG_CPU_SUP_CENTAUR_64)	+= centaur_64.o
  obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
  obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
+obj-$(CONFIG_CPU_SUP_SIS_32)		+= sis.o

  obj-$(CONFIG_X86_MCE)	+= mcheck/
  obj-$(CONFIG_MTRR)	+= mtrr/
diff -Naur a/arch/x86/kernel/cpu/sis.c b/arch/x86/kernel/cpu/sis.c
--- a/arch/x86/kernel/cpu/sis.c	1970-01-01 01:00:00.000000000 +0100
+++ b/arch/x86/kernel/cpu/sis.c	2008-10-11 11:04:23.000000000 +0200
@@ -0,0 +1,25 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <asm/processor.h>
+#include "cpu.h"
+
+static unsigned int __cpuinit sis_size_cache(struct cpuinfo_x86 *c, unsigned int size)
+{
+	return 8;
+}
+
+static struct cpu_dev sis_cpu_dev __cpuinitdata = {
+	.c_vendor	= "SiS",
+	.c_ident 	= { "SiS SiS SiS " },
+	.c_models = {
+		{ .vendor = X86_VENDOR_SIS, .family = 5, .model_names =
+		  { 
+			  [0] = "SiS55x", 
+		  }
+		},
+	},
+	.c_size_cache	= sis_size_cache,
+	.c_x86_vendor	= X86_VENDOR_SIS,
+};
+
+cpu_dev_register(sis_cpu_dev);
diff -Naur a/include/asm-x86/processor.h b/include/asm-x86/processor.h
--- a/include/asm-x86/processor.h	2008-10-11 23:03:47.000000000 +0200
+++ b/include/asm-x86/processor.h	2008-10-03 23:53:00.000000000 +0200
@@ -119,7 +119,8 @@
  #define X86_VENDOR_CENTAUR	5
  #define X86_VENDOR_TRANSMETA	7
  #define X86_VENDOR_NSC		8
-#define X86_VENDOR_NUM		9
+#define X86_VENDOR_SIS		9
+#define X86_VENDOR_NUM		10

  #define X86_VENDOR_UNKNOWN	0xff

