Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbYCJIN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbYCJIN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYCJINv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:13:51 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:29930 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYCJINu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:13:50 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kvm: provide kvm.h for all architecture: fixes headers_install
Date: Mon, 10 Mar 2008 09:13:46 +0100
User-Agent: KMail/1.9.7
Cc: David Woodhouse <dwmw2@infradead.org>, Avi Kivity <avi@qumranet.com>,
       Sam Ravnborg <sam@ravnborg.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <200803071326.06682.borntraeger@de.ibm.com> <1204933418.2495.14.camel@shinybook.infradead.org>
In-Reply-To: <1204933418.2495.14.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803100913.46422.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Avi is away, can you apply this patch for 2.6.25?


[PATCH] kvm: provide kvm.h for all architecture: fixes headers_install

Currently include/linux/kvm.h is not considered by make headers_install, 
because Kbuild cannot handle " unifdef-$(CONFIG_FOO) += foo.h. 
This problem was introduced by 040922c04cf2c8ac70be2e88a8a9614ecdb41d2e, 
which makes this an 2.6.25 regression.

One way of solving the issue is to enhance Kbuild, but Avi and David 
conviced me, that changing headers_install is not the way to go. This patch 
changes the definition for linux/kvm.h to unifdef-y.

If  unifdef-y is used for linux/kvm.h "make headers_check" will fail on all
architectures without asm/kvm.h. Therefore, this patch also provides 
asm/kvm.h on all architectures.


Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Avi Kivity <avi@qumranet.com>
CCed: Sam Ravnborg <sam@ravnborg.org
CCed: David Woodhouse <dwmw2@infradead.org>
---
 include/asm-alpha/Kbuild     |    1 +
 include/asm-alpha/kvm.h      |    6 ++++++
 include/asm-arm/Kbuild       |    2 ++
 include/asm-arm/kvm.h        |    6 ++++++
 include/asm-avr32/Kbuild     |    1 +
 include/asm-avr32/kvm.h      |    6 ++++++
 include/asm-blackfin/Kbuild  |    1 +
 include/asm-blackfin/kvm.h   |    6 ++++++
 include/asm-cris/Kbuild      |    1 +
 include/asm-cris/kvm.h       |    6 ++++++
 include/asm-frv/Kbuild       |    1 +
 include/asm-frv/kvm.h        |    6 ++++++
 include/asm-h8300/Kbuild     |    2 ++
 include/asm-h8300/kvm.h      |    6 ++++++
 include/asm-ia64/Kbuild      |    1 +
 include/asm-ia64/kvm.h       |    6 ++++++
 include/asm-m32r/Kbuild      |    2 ++
 include/asm-m32r/kvm.h       |    6 ++++++
 include/asm-m68k/Kbuild      |    1 +
 include/asm-m68k/kvm.h       |    6 ++++++
 include/asm-m68knommu/Kbuild |    2 ++
 include/asm-m68knommu/kvm.h  |    7 +++++++
 include/asm-mips/Kbuild      |    2 +-
 include/asm-mips/kvm.h       |    6 ++++++
 include/asm-mn10300/Kbuild   |    2 ++
 include/asm-mn10300/kvm.h    |    6 ++++++
 include/asm-parisc/Kbuild    |    2 ++
 include/asm-parisc/kvm.h     |    6 ++++++
 include/asm-powerpc/Kbuild   |    1 +
 include/asm-powerpc/kvm.h    |    6 ++++++
 include/asm-s390/Kbuild      |    1 +
 include/asm-s390/kvm.h       |    6 ++++++
 include/asm-sh/Kbuild        |    1 +
 include/asm-sh/kvm.h         |    6 ++++++
 include/asm-sparc/Kbuild     |    1 +
 include/asm-sparc/kvm.h      |    6 ++++++
 include/asm-sparc64/Kbuild   |    1 +
 include/asm-sparc64/kvm.h    |    6 ++++++
 include/asm-v850/Kbuild      |    2 ++
 include/asm-v850/kvm.h       |    6 ++++++
 include/asm-xtensa/Kbuild    |    2 ++
 include/asm-xtensa/kvm.h     |    6 ++++++
 include/linux/Kbuild         |    2 +-
 43 files changed, 157 insertions(+), 2 deletions(-)

Index: linux-2.6/include/asm-alpha/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-alpha/Kbuild
+++ linux-2.6/include/asm-alpha/Kbuild
@@ -1,6 +1,7 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += gentrap.h
+header-y += kvm.h
 header-y += regdef.h
 header-y += pal.h
 header-y += reg.h
Index: linux-2.6/include/asm-alpha/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-alpha/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_ALPHA_H
+#define __LINUX_KVM_ALPHA_H
+
+/* alpha does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-arm/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-arm/Kbuild
+++ linux-2.6/include/asm-arm/Kbuild
@@ -1,3 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
+header-y += kvm.h
+
 unifdef-y += hwcap.h
Index: linux-2.6/include/asm-arm/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-arm/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_ARM_H
+#define __LINUX_KVM_ARM_H
+
+/* arm does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-avr32/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-avr32/Kbuild
+++ linux-2.6/include/asm-avr32/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 header-y	+= cachectl.h
+header-y 	+= kvm.h
Index: linux-2.6/include/asm-avr32/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-avr32/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_AVR32_H
+#define __LINUX_KVM_AVR32_H
+
+/* avr32 does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-blackfin/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-blackfin/Kbuild
+++ linux-2.6/include/asm-blackfin/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += fixed_code.h
+header-y += kvm.h
Index: linux-2.6/include/asm-blackfin/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-blackfin/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_BLACKFIN_H
+#define __LINUX_KVM_BLACKFIN_H
+
+/* blackfin does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-cris/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-cris/Kbuild
+++ linux-2.6/include/asm-cris/Kbuild
@@ -4,6 +4,7 @@ header-$(CONFIG_ETRAX_ARCH_V10) += arch-
 header-$(CONFIG_ETRAX_ARCH_V32) += arch-v32/
 
 header-y += ethernet.h
+header-y += kvm.h
 header-y += rtc.h
 header-y += sync_serial.h
 
Index: linux-2.6/include/asm-cris/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-cris/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_CRIS_H
+#define __LINUX_KVM_CRIS_H
+
+/* cris does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-frv/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-frv/Kbuild
+++ linux-2.6/include/asm-frv/Kbuild
@@ -1,5 +1,6 @@
 include include/asm-generic/Kbuild.asm
 
+header-y += kvm.h
 header-y += registers.h
 
 unifdef-y += termios.h
Index: linux-2.6/include/asm-frv/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-frv/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_FRV_H
+#define __LINUX_KVM_FRV_H
+
+/* cris does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-h8300/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-h8300/Kbuild
+++ linux-2.6/include/asm-h8300/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+header-y += kvm.h
Index: linux-2.6/include/asm-h8300/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-h8300/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_H8300_H
+#define __LINUX_KVM_H8300_H
+
+/* h8300 does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-ia64/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-ia64/Kbuild
+++ linux-2.6/include/asm-ia64/Kbuild
@@ -6,6 +6,7 @@ header-y += fpswa.h
 header-y += ia64regs.h
 header-y += intel_intrin.h
 header-y += intrinsics.h
+header-y += kvm.h
 header-y += perfmon_default_smpl.h
 header-y += ptrace_offsets.h
 header-y += rse.h
Index: linux-2.6/include/asm-ia64/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-ia64/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_IA64_H
+#define __LINUX_KVM_IA64_H
+
+/* ia64 does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-m32r/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-m32r/Kbuild
+++ linux-2.6/include/asm-m32r/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+header-y += kvm.h
Index: linux-2.6/include/asm-m32r/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-m32r/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_M32R_H
+#define __LINUX_KVM_M32R_H
+
+/* m32r does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-m68k/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-m68k/Kbuild
+++ linux-2.6/include/asm-m68k/Kbuild
@@ -1,2 +1,3 @@
 include include/asm-generic/Kbuild.asm
 header-y += cachectl.h
+header-y += kvm.h
Index: linux-2.6/include/asm-m68k/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-m68k/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_M68K_H
+#define __LINUX_KVM_M68K_H
+
+/* m68k does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-m68knommu/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-m68knommu/Kbuild
+++ linux-2.6/include/asm-m68knommu/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+header-y += kvm.h
Index: linux-2.6/include/asm-m68knommu/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-m68knommu/kvm.h
@@ -0,0 +1,7 @@
+#ifndef __LINUX_KVM_M68KNOMMU_H
+#define __LINUX_KVM_M68KNOMMU_H
+
+/* m68knommu does not support KVM */
+
+#endif
+
Index: linux-2.6/include/asm-mips/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-mips/Kbuild
+++ linux-2.6/include/asm-mips/Kbuild
@@ -1,3 +1,3 @@
 include include/asm-generic/Kbuild.asm
 
-header-y += cachectl.h sgidefs.h sysmips.h
+header-y += cachectl.h sgidefs.h sysmips.h kvm.h
Index: linux-2.6/include/asm-mips/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-mips/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_MIPS_H
+#define __LINUX_KVM_MIPS_H
+
+/* mips does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-mn10300/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-mn10300/Kbuild
+++ linux-2.6/include/asm-mn10300/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+header-y += kvm.h
Index: linux-2.6/include/asm-mn10300/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-mn10300/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_MN10300_H
+#define __LINUX_KVM_MN10300_H
+
+/* mn10300 does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-parisc/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-parisc/Kbuild
+++ linux-2.6/include/asm-parisc/Kbuild
@@ -1,3 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
+header-y += kvm.h
+
 unifdef-y += pdc.h
Index: linux-2.6/include/asm-parisc/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-parisc/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_PARISC_H
+#define __LINUX_KVM_PARISC_H
+
+/* parisc does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-powerpc/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-powerpc/Kbuild
+++ linux-2.6/include/asm-powerpc/Kbuild
@@ -8,6 +8,7 @@ header-y += siginfo.h
 header-y += stat.h
 header-y += errno.h
 header-y += ipcbuf.h
+header-y += kvm.h
 header-y += msgbuf.h
 header-y += shmbuf.h
 header-y += socket.h
Index: linux-2.6/include/asm-powerpc/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-powerpc/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_POWERPC_H
+#define __LINUX_KVM_POWERPC_H
+
+/* powerpc does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-s390/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-s390/Kbuild
+++ linux-2.6/include/asm-s390/Kbuild
@@ -1,6 +1,7 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += dasd.h
+header-y += kvm.h
 header-y += monwriter.h
 header-y += qeth.h
 header-y += tape390.h
Index: linux-2.6/include/asm-s390/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-s390/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_S390_H
+#define __LINUX_KVM_S390_H
+
+/* s390 does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-sh/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-sh/Kbuild
+++ linux-2.6/include/asm-sh/Kbuild
@@ -1,6 +1,7 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += cpu-features.h
+header-y += kvm.h
 
 unifdef-y += unistd_32.h
 unifdef-y += unistd_64.h
Index: linux-2.6/include/asm-sh/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-sh/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_SH_H
+#define __LINUX_KVM_SH_H
+
+/* sh does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-sparc/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-sparc/Kbuild
+++ linux-2.6/include/asm-sparc/Kbuild
@@ -4,6 +4,7 @@ header-y += apc.h
 header-y += asi.h
 header-y += bpp.h
 header-y += jsflash.h
+header-y += kvm.h
 header-y += openpromio.h
 header-y += pconf.h
 header-y += reg.h
Index: linux-2.6/include/asm-sparc/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-sparc/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_SPARC_H
+#define __LINUX_KVM_SPARC_H
+
+/* sparc does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-sparc64/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-sparc64/Kbuild
+++ linux-2.6/include/asm-sparc64/Kbuild
@@ -10,6 +10,7 @@ header-y += bbc.h
 header-y += bpp.h
 header-y += display7seg.h
 header-y += envctrl.h
+header-y += kvm.h
 header-y += openprom.h
 header-y += openpromio.h
 header-y += pconf.h
Index: linux-2.6/include/asm-sparc64/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-sparc64/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_SPARC64_H
+#define __LINUX_KVM_SPARC64_H
+
+/* sparc64 does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-v850/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-v850/Kbuild
+++ linux-2.6/include/asm-v850/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+header-y += kvm.h
Index: linux-2.6/include/asm-v850/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-v850/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_V850_H
+#define __LINUX_KVM_V850_H
+
+/* v850 does not support KVM */
+
+#endif
Index: linux-2.6/include/asm-xtensa/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-xtensa/Kbuild
+++ linux-2.6/include/asm-xtensa/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+header-y += kvm.h
Index: linux-2.6/include/asm-xtensa/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-xtensa/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_XTENSA_H
+#define __LINUX_KVM_XTENSA_H
+
+/* xtensa does not support KVM */
+
+#endif
Index: linux-2.6/include/linux/Kbuild
===================================================================
--- linux-2.6.orig/include/linux/Kbuild
+++ linux-2.6/include/linux/Kbuild
@@ -257,7 +257,7 @@ unifdef-y += kd.h
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
-unifdef-$(CONFIG_HAVE_KVM) += kvm.h
+unifdef-y += kvm.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
