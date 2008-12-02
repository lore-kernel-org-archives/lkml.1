Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbYLBSgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbYLBSgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYLBSgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:36:39 -0500
Received: from mailout05.t-online.de ([194.25.134.82]:56011 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbYLBSgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:36:38 -0500
Message-ID: <49358017.7080009@t-online.de>
Date: Tue, 02 Dec 2008 19:36:07 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.27.7 built for Geode: Clock drift
Content-Type: multipart/mixed;
 boundary="------------030900030605000200050105"
X-ID: Tzg-a+ZbghjzL2ACVDRgrOKrNs05tIka+B0I4d0Pnjeic3BA7YuNCy9SiF9NEKQZKi
X-TOI-MSGID: dfd373a5-2e19-4e4c-be60-9818ffa63742
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030900030605000200050105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi folks,

If I build a kernel for AMD Geode, then I see a clock drift of appr.
30 min. to 1 hour per day. If I build the same kernel for i486, then
the clock drift is gone. Running ntp makes no difference.

Hardware is a Linutop PC. /proc/cpuinfo says

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 5
model           : 10
model name      : Geode(TM) Integrated Processor by AMD PCS
stepping        : 2
cpu MHz         : 0.000
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx mmxext 3dnowext 3dnow
bogomips        : 429.05
clflush size    : 32
power management:

BTW, the CPU is running with 500 MHz (AFAIK). 0.000 MHz is surely not
correct. /proc/cpuinfo reports the same for both kernels.

Attached is the diff of the config files. Please mail if you are
interested in the complete config files, or if I can help to track
this down.


Regards

Harri

--------------030900030605000200050105
Content-Type: text/x-diff;
 name="config.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="config.diff"

--- config-2.6.27.7-486	2008-12-02 03:36:11.000000000 +0100
+++ config-2.6.27.7-geode	2008-11-23 10:46:54.000000000 +0100
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.27.7
-# Mon Dec  1 22:42:26 2008
+# Sun Nov 23 05:01:04 2008
 #
 # CONFIG_64BIT is not set
 CONFIG_X86_32=y
@@ -56,7 +56,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-CONFIG_LOCALVERSION="-486"
+CONFIG_LOCALVERSION="-geode"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
@@ -197,7 +197,7 @@
 # CONFIG_PARAVIRT_DEBUG is not set
 # CONFIG_MEMTEST is not set
 # CONFIG_M386 is not set
-CONFIG_M486=y
+# CONFIG_M486 is not set
 # CONFIG_M586 is not set
 # CONFIG_M586TSC is not set
 # CONFIG_M586MMX is not set
@@ -215,7 +215,7 @@
 # CONFIG_MWINCHIP2 is not set
 # CONFIG_MWINCHIP3D is not set
 # CONFIG_MGEODEGX1 is not set
-# CONFIG_MGEODE_LX is not set
+CONFIG_MGEODE_LX=y
 # CONFIG_MCYRIXIII is not set
 # CONFIG_MVIAC3_2 is not set
 # CONFIG_MVIAC7 is not set
@@ -227,15 +227,16 @@
 CONFIG_X86_CMPXCHG=y
 CONFIG_X86_L1_CACHE_SHIFT=7
 CONFIG_X86_XADD=y
-# CONFIG_X86_PPRO_FENCE is not set
-CONFIG_X86_F00F_BUG=y
 CONFIG_X86_WP_WORKS_OK=y
 CONFIG_X86_INVLPG=y
 CONFIG_X86_BSWAP=y
 CONFIG_X86_POPAD_OK=y
-CONFIG_X86_ALIGNMENT_16=y
 CONFIG_X86_INTEL_USERCOPY=y
+CONFIG_X86_USE_PPRO_CHECKSUM=y
+CONFIG_X86_USE_3DNOW=y
+CONFIG_X86_TSC=y
 CONFIG_X86_MINIMUM_CPU_FAMILY=4
+CONFIG_X86_DEBUGCTLMSR=y
 CONFIG_HPET_TIMER=y
 CONFIG_HPET_EMULATE_RTC=y
 CONFIG_DMI=y
@@ -423,6 +424,7 @@
 # CONFIG_MCA_PROC_FS is not set
 CONFIG_SCx200=m
 CONFIG_SCx200HR_TIMER=m
+CONFIG_GEODE_MFGPT_TIMER=y
 # CONFIG_OLPC is not set
 CONFIG_K8_NB=y
 # CONFIG_PCCARD is not set
@@ -1919,6 +1921,7 @@
 CONFIG_ADVANTECH_WDT=m
 CONFIG_ALIM1535_WDT=m
 CONFIG_ALIM7101_WDT=m
+CONFIG_GEODE_WDT=m
 CONFIG_SC520_WDT=m
 CONFIG_EUROTECH_WDT=m
 CONFIG_IB700_WDT=m

--------------030900030605000200050105--
