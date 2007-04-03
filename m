Return-Path: <linux-kernel-owner+w=401wt.eu-S1161062AbXDCSZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161062AbXDCSZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161093AbXDCSZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:25:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22330 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161062AbXDCSZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:25:09 -0400
Date: Tue, 3 Apr 2007 11:26:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, sam@ravnborg.org, davem@davemloft.net
Subject: [PATCH] make csum_partial obj-y
Message-Id: <20070403112604.129610b1.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fixes kernel bugzilla #8242:

Move csum_partial() from lib-y to obj-$(CONFIG_CSUM_PARTIAL)
so that modules can use it.

CONFIG_BLK_DEV_MD (md/raid driver) needs csum_partial(),
even when CONFIG_NET=n and BLK_DEV_MD=m, so build it as an
object to force it being built and available.

REISERFS with XATTR=y also needs csum_partial(), so that
is enforced here.

powerpc, ppc, & um use obj-, not lib-, so they don't need any
Makefile changes.  s390 uses a header file for csum_partial(),
so it doesn't need any changes.

CONFIG_CSUM_PARTIAL is boolean since lib/ obj-m is not
supported.

Built on i386, sparc, sparc64, alpha, ia64, ppc64, x86_64, arm, um,
with many config varieties on x86_64.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/alpha/Kconfig              |    3 +++
 arch/alpha/lib/Makefile         |    3 ++-
 arch/arm/Kconfig                |    3 +++
 arch/arm/lib/Makefile           |    4 +++-
 arch/arm26/Kconfig              |    3 +++
 arch/arm26/lib/Makefile         |    4 +++-
 arch/avr32/Kconfig              |    3 +++
 arch/avr32/lib/Makefile         |    4 +++-
 arch/cris/Kconfig               |    3 +++
 arch/cris/arch-v10/lib/Makefile |    3 +++
 arch/cris/arch-v32/lib/Makefile |    3 +++
 arch/frv/Kconfig                |    3 +++
 arch/frv/lib/Makefile           |    4 +++-
 arch/h8300/Kconfig              |    3 +++
 arch/h8300/lib/Makefile         |    4 +++-
 arch/i386/Kconfig               |    3 +++
 arch/i386/lib/Makefile          |    4 ++--
 arch/ia64/Kconfig               |    3 +++
 arch/ia64/lib/Makefile          |    3 ++-
 arch/m32r/Kconfig               |    3 +++
 arch/m32r/lib/Makefile          |    3 ++-
 arch/m68k/Kconfig               |    3 +++
 arch/m68k/lib/Makefile          |    4 +++-
 arch/m68knommu/Kconfig          |    3 +++
 arch/m68knommu/lib/Makefile     |    4 +++-
 arch/mips/Kconfig               |    3 +++
 arch/mips/lib/Makefile          |    3 ++-
 arch/parisc/Kconfig             |    3 +++
 arch/parisc/lib/Makefile        |    3 ++-
 arch/powerpc/Kconfig            |    3 +++
 arch/ppc/Kconfig                |    3 +++
 arch/sh/Kconfig                 |    3 +++
 arch/sh/lib/Makefile            |    3 ++-
 arch/sh64/Kconfig               |    3 +++
 arch/sh64/lib/Makefile          |    3 ++-
 arch/sparc/Kconfig              |    3 +++
 arch/sparc/lib/Makefile         |    4 ++--
 arch/sparc64/Kconfig            |    3 +++
 arch/sparc64/lib/Makefile       |    3 ++-
 arch/um/Kconfig                 |    3 +++
 arch/v850/Kconfig               |    3 +++
 arch/v850/lib/Makefile          |    4 +++-
 arch/x86_64/Kconfig             |    3 +++
 arch/x86_64/lib/Makefile        |    3 ++-
 arch/xtensa/Kconfig             |    3 +++
 arch/xtensa/lib/Makefile        |    4 +++-
 drivers/md/Kconfig              |    1 +
 fs/Kconfig                      |    1 +
 net/Kconfig                     |    1 +
 49 files changed, 130 insertions(+), 22 deletions(-)

--- linux-2621-rc4g7-csum.orig/arch/x86_64/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/x86_64/lib/Makefile
@@ -6,8 +6,9 @@ CFLAGS_csum-partial.o := -funroll-loops
 
 obj-y := io.o iomap_copy.o
 obj-$(CONFIG_SMP)	+= msr-on-cpu.o
+obj-$(CONFIG_CSUM_PARTIAL)	+= csum-partial.o
 
-lib-y := csum-partial.o csum-copy.o csum-wrappers.o delay.o \
+lib-y := csum-copy.o csum-wrappers.o delay.o \
 	usercopy.o getuser.o putuser.o  \
 	thunk.o clear_page.o copy_page.o bitstr.o bitops.o
 lib-y += memcpy.o memmove.o memset.o copy_user.o rwlock.o copy_user_nocache.o
--- linux-2621-rc4g7-csum.orig/drivers/md/Kconfig
+++ linux-2621-rc4g7-csum/drivers/md/Kconfig
@@ -15,6 +15,7 @@ config MD
 config BLK_DEV_MD
 	tristate "RAID support"
 	depends on MD
+	select CSUM_PARTIAL
 	---help---
 	  This driver lets you combine several hard disk partitions into one
 	  logical block device. This can be used to simply append one
--- linux-2621-rc4g7-csum.orig/arch/x86_64/Kconfig
+++ linux-2621-rc4g7-csum/arch/x86_64/Kconfig
@@ -121,6 +121,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 
--- linux-2621-rc4g7-csum.orig/arch/alpha/Kconfig
+++ linux-2621-rc4g7-csum/arch/alpha/Kconfig
@@ -66,6 +66,9 @@ config AUTO_IRQ_AFFINITY
 	depends on SMP
 	default y
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 
--- linux-2621-rc4g7-csum.orig/arch/alpha/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/alpha/lib/Makefile
@@ -17,7 +17,6 @@ lib-y =	__divqu.o __remqu.o __divlu.o __
 	$(ev6-y)memset.o \
 	$(ev6-y)memcpy.o \
 	memmove.o \
-	checksum.o \
 	csum_partial_copy.o \
 	$(ev67-y)strlen.o \
 	$(ev67-y)strcat.o \
@@ -42,6 +41,8 @@ lib-y =	__divqu.o __remqu.o __divlu.o __
 
 lib-$(CONFIG_SMP) += dec_and_lock.o
 
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
+
 # The division routines are built from single source, with different defines.
 AFLAGS___divqu.o = -DDIV
 AFLAGS___remqu.o =       -DREM
--- linux-2621-rc4g7-csum.orig/arch/frv/Kconfig
+++ linux-2621-rc4g7-csum/arch/frv/Kconfig
@@ -53,6 +53,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y
 
+config CSUM_PARTIAL
+	def_bool n
+
 mainmenu "Fujitsu FR-V Kernel Configuration"
 
 source "init/Kconfig"
--- linux-2621-rc4g7-csum.orig/arch/frv/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/frv/lib/Makefile
@@ -4,5 +4,7 @@
 
 lib-y := \
 	__ashldi3.o __lshrdi3.o __muldi3.o __ashrdi3.o __negdi2.o __ucmpdi2.o \
-	checksum.o memcpy.o memset.o atomic-ops.o \
+	memcpy.o memset.o atomic-ops.o \
 	outsl_ns.o outsl_sw.o insl_ns.o insl_sw.o cache.o
+
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/h8300/Kconfig
+++ linux-2621-rc4g7-csum/arch/h8300/Kconfig
@@ -68,6 +68,9 @@ config PCI
 	bool
 	default n
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 source "arch/h8300/Kconfig.cpu"
--- linux-2621-rc4g7-csum.orig/arch/h8300/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/h8300/lib/Makefile
@@ -5,4 +5,6 @@
 .S.o:
 	$(CC) $(AFLAGS) -D__ASSEMBLY__ -c $< -o $@
 
-lib-y  = ashrdi3.o checksum.o memcpy.o memset.o abs.o romfs.o
+lib-y  = ashrdi3.o memcpy.o memset.o abs.o romfs.o
+
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/m32r/Kconfig
+++ linux-2621-rc4g7-csum/arch/m32r/Kconfig
@@ -31,6 +31,9 @@ config GENERIC_IRQ_PROBE
 config NO_IOPORT
 	def_bool y
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 
--- linux-2621-rc4g7-csum.orig/arch/m32r/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/m32r/lib/Makefile
@@ -2,6 +2,7 @@
 # Makefile for M32R-specific library files..
 #
 
-lib-y  := checksum.o ashxdi3.o memset.o memcpy.o \
+lib-y  := ashxdi3.o memset.o memcpy.o \
 	  delay.o strlen.o usercopy.o csum_partial_copy.o
 
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/sh64/Kconfig
+++ linux-2621-rc4g7-csum/arch/sh64/Kconfig
@@ -44,6 +44,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config CSUM_PARTIAL
+	def_bool n
+
 source init/Kconfig
 
 menu "System type"
--- linux-2621-rc4g7-csum.orig/arch/sh64/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/sh64/lib/Makefile
@@ -14,6 +14,7 @@
 #
 
 # Panic should really be compiled as PIC
-lib-y  := udelay.o c-checksum.o dbg.o io.o panic.o memcpy.o copy_user_memcpy.o \
+lib-y  := udelay.o dbg.o io.o panic.o memcpy.o copy_user_memcpy.o \
 		page_copy.o page_clear.o iomap.o
 
+obj-$(CONFIG_CSUM_PARTIAL) += c-checksum.o
--- linux-2621-rc4g7-csum.orig/arch/v850/Kconfig
+++ linux-2621-rc4g7-csum/arch/v850/Kconfig
@@ -49,6 +49,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config CSUM_PARTIAL
+	def_bool n
+
 # Turn off some random 386 crap that can affect device config
 config ISA
 	bool
--- linux-2621-rc4g7-csum.orig/arch/v850/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/v850/lib/Makefile
@@ -3,4 +3,6 @@
 #
 
 lib-y  = ashrdi3.o ashldi3.o lshrdi3.o muldi3.o negdi2.o \
-	 checksum.o memcpy.o memset.o
+	 memcpy.o memset.o
+
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/parisc/Kconfig
+++ linux-2621-rc4g7-csum/arch/parisc/Kconfig
@@ -81,6 +81,9 @@ config ARCH_MAY_HAVE_PC_FDC
 	depends on BROKEN
 	default y
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 
--- linux-2621-rc4g7-csum.orig/arch/parisc/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/parisc/lib/Makefile
@@ -2,6 +2,7 @@
 # Makefile for parisc-specific library files
 #
 
-lib-y	:= lusercopy.o bitops.o checksum.o io.o memset.o fixup.o memcpy.o
+lib-y	:= lusercopy.o bitops.o io.o memset.o fixup.o memcpy.o
 
 obj-y	:= iomap.o
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/ia64/Kconfig
+++ linux-2621-rc4g7-csum/arch/ia64/Kconfig
@@ -85,6 +85,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config CSUM_PARTIAL
+	def_bool n
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
--- linux-2621-rc4g7-csum.orig/arch/ia64/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/ia64/lib/Makefile
@@ -3,10 +3,11 @@
 #
 
 obj-y := io.o
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
 
 lib-y := __divsi3.o __udivsi3.o __modsi3.o __umodsi3.o			\
 	__divdi3.o __udivdi3.o __moddi3.o __umoddi3.o			\
-	checksum.o clear_page.o csum_partial_copy.o			\
+	clear_page.o csum_partial_copy.o				\
 	clear_user.o strncpy_from_user.o strlen_user.o strnlen_user.o	\
 	flush.o ip_fast_csum.o do_csum.o				\
 	memset.o strlen.o xor.o
--- linux-2621-rc4g7-csum.orig/arch/m68k/Kconfig
+++ linux-2621-rc4g7-csum/arch/m68k/Kconfig
@@ -45,6 +45,9 @@ config ARCH_MAY_HAVE_PC_FDC
 config NO_IOPORT
 	def_bool y
 
+config CSUM_PARTIAL
+	def_bool n
+
 mainmenu "Linux/68k Kernel Configuration"
 
 source "init/Kconfig"
--- linux-2621-rc4g7-csum.orig/arch/m68k/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/m68k/lib/Makefile
@@ -5,4 +5,6 @@
 EXTRA_AFLAGS := -traditional
 
 lib-y	:= ashldi3.o ashrdi3.o lshrdi3.o muldi3.o \
-	   checksum.o string.o semaphore.o uaccess.o
+	   string.o semaphore.o uaccess.o
+
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/m68knommu/Kconfig
+++ linux-2621-rc4g7-csum/arch/m68knommu/Kconfig
@@ -56,6 +56,9 @@ config TIME_LOW_RES
 config NO_IOPORT
 	def_bool y
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 menu "Processor type and features"
--- linux-2621-rc4g7-csum.orig/arch/m68knommu/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/m68knommu/lib/Makefile
@@ -4,4 +4,6 @@
 
 lib-y	:= ashldi3.o ashrdi3.o lshrdi3.o \
 	   muldi3.o mulsi3.o divsi3.o udivsi3.o modsi3.o umodsi3.o \
-	   checksum.o semaphore.o memcpy.o memset.o delay.o
+	   semaphore.o memcpy.o memset.o delay.o
+
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/i386/Kconfig
+++ linux-2621-rc4g7-csum/arch/i386/Kconfig
@@ -83,6 +83,9 @@ config DMI
 	bool
 	default y
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 menu "Processor type and features"
--- linux-2621-rc4g7-csum.orig/arch/i386/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/i386/lib/Makefile
@@ -2,10 +2,10 @@
 # Makefile for i386-specific library files..
 #
 
-
-lib-y = checksum.o delay.o usercopy.o getuser.o putuser.o memcpy.o strstr.o \
+lib-y = delay.o usercopy.o getuser.o putuser.o memcpy.o strstr.o \
 	bitops.o semaphore.o
 
 lib-$(CONFIG_X86_USE_3DNOW) += mmx.o
 
 obj-$(CONFIG_SMP)	+= msr-on-cpu.o
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/cris/Kconfig
+++ linux-2621-rc4g7-csum/arch/cris/Kconfig
@@ -51,6 +51,9 @@ config CRIS
 	bool
 	default y
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 menu "General setup"
--- linux-2621-rc4g7-csum.orig/arch/cris/arch-v10/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/cris/arch-v10/lib/Makefile
@@ -7,3 +7,6 @@ EXTRA_AFLAGS := -traditional
 
 lib-y  = checksum.o checksumcopy.o string.o usercopy.o memset.o csumcpfruser.o
 
+obj-y  :=
+obj-m  :=
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/cris/arch-v32/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/cris/arch-v32/lib/Makefile
@@ -4,3 +4,6 @@
 
 lib-y  = checksum.o checksumcopy.o string.o usercopy.o memset.o csumcpfruser.o spinlock.o
 
+obj-y  :=
+obj-m  :=
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/sh/Kconfig
+++ linux-2621-rc4g7-csum/arch/sh/Kconfig
@@ -70,6 +70,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 menu "System type"
--- linux-2621-rc4g7-csum.orig/arch/sh/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/sh/lib/Makefile
@@ -3,7 +3,7 @@
 #
 
 lib-y  = delay.o memset.o memmove.o memchr.o \
-	 checksum.o strcasecmp.o strlen.o div64.o udivdi3.o \
+	 strcasecmp.o strlen.o div64.o udivdi3.o \
 	 div64-generic.o
 
 memcpy-y			:= memcpy.o
@@ -11,3 +11,4 @@ memcpy-$(CONFIG_CPU_SH4)	:= memcpy-sh4.o
 
 lib-y	+= $(memcpy-y)
 
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/sparc/Kconfig
+++ linux-2621-rc4g7-csum/arch/sparc/Kconfig
@@ -21,6 +21,9 @@ config GENERIC_ISA_DMA
 	bool
 	default y
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 menu "General machine setup"
--- linux-2621-rc4g7-csum.orig/arch/sparc/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/sparc/lib/Makefile
@@ -5,9 +5,9 @@
 EXTRA_AFLAGS := -ansi -DST_DIV0=0x02
 
 lib-y := mul.o rem.o sdiv.o udiv.o umul.o urem.o ashrdi3.o memcpy.o memset.o \
-         strlen.o checksum.o blockops.o memscan.o memcmp.o strncmp.o \
+         strlen.o blockops.o memscan.o memcmp.o strncmp.o \
 	 strncpy_from_user.o divdi3.o udivdi3.o strlen_user.o \
 	 copy_user.o locks.o atomic.o \
 	 lshrdi3.o ashldi3.o rwsem.o muldi3.o bitext.o
 
-obj-y += iomap.o atomic32.o
+obj-y += iomap.o atomic32.o checksum.o
--- linux-2621-rc4g7-csum.orig/arch/sparc64/Kconfig
+++ linux-2621-rc4g7-csum/arch/sparc64/Kconfig
@@ -98,6 +98,9 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
+config CSUM_PARTIAL
+	def_bool n
+
 source kernel/Kconfig.hz
 
 source "init/Kconfig"
--- linux-2621-rc4g7-csum.orig/arch/sparc64/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/sparc64/lib/Makefile
@@ -6,7 +6,7 @@ EXTRA_AFLAGS := -ansi
 EXTRA_CFLAGS := -Werror
 
 lib-y := PeeCeeI.o copy_page.o clear_page.o strlen.o strncmp.o \
-	 memscan.o strncpy_from_user.o strlen_user.o memcmp.o checksum.o \
+	 memscan.o strncpy_from_user.o strlen_user.o memcmp.o \
 	 bzero.o csum_copy.o csum_copy_from_user.o csum_copy_to_user.o \
 	 VISsave.o atomic.o bitops.o \
 	 U1memcpy.o U1copy_from_user.o U1copy_to_user.o \
@@ -17,3 +17,4 @@ lib-y := PeeCeeI.o copy_page.o clear_pag
 	 mcount.o ipcsum.o rwsem.o xor.o delay.o
 
 obj-y += iomap.o
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/xtensa/Kconfig
+++ linux-2621-rc4g7-csum/arch/xtensa/Kconfig
@@ -49,6 +49,9 @@ config ARCH_HAS_ILOG2_U64
 config NO_IOPORT
 	def_bool y
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 menu "Processor type and features"
--- linux-2621-rc4g7-csum.orig/arch/xtensa/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/xtensa/lib/Makefile
@@ -2,6 +2,8 @@
 # Makefile for Xtensa-specific library files.
 #
 
-lib-y	+= memcopy.o memset.o checksum.o strcasecmp.o \
+lib-y	+= memcopy.o memset.o strcasecmp.o \
 	   usercopy.o strncpy_user.o strnlen_user.o
 lib-$(CONFIG_PCI) += pci-auto.o
+
+obj-$(CONFIG_CSUM_PARTIAL) += checksum.o
--- linux-2621-rc4g7-csum.orig/arch/mips/Kconfig
+++ linux-2621-rc4g7-csum/arch/mips/Kconfig
@@ -12,6 +12,9 @@ config ZONE_DMA
 	bool
 	default y
 
+config CSUM_PARTIAL
+	def_bool n
+
 choice
 	prompt "System type"
 	default SGI_IP22
--- linux-2621-rc4g7-csum.orig/arch/mips/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/mips/lib/Makefile
@@ -2,11 +2,12 @@
 # Makefile for MIPS-specific library files..
 #
 
-lib-y	+= csum_partial.o memcpy.o memcpy-inatomic.o memset.o strlen_user.o \
+lib-y	+= memcpy.o memcpy-inatomic.o memset.o strlen_user.o \
 	   strncpy_user.o strnlen_user.o uncached.o
 
 obj-y			+= iomap.o
 obj-$(CONFIG_PCI)	+= iomap-pci.o
+obj-$(CONFIG_CSUM_PARTIAL) += csum_partial.o
 
 # libgcc-style stuff needed in the kernel
 lib-y += ashldi3.o ashrdi3.o lshrdi3.o
--- linux-2621-rc4g7-csum.orig/arch/avr32/Kconfig
+++ linux-2621-rc4g7-csum/arch/avr32/Kconfig
@@ -68,6 +68,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 menu "System Type and features"
--- linux-2621-rc4g7-csum.orig/arch/avr32/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/avr32/lib/Makefile
@@ -5,7 +5,9 @@
 lib-y	:= copy_user.o clear_user.o
 lib-y	+= strncpy_from_user.o strnlen_user.o
 lib-y	+= delay.o memset.o memcpy.o findbit.o
-lib-y	+= csum_partial.o csum_partial_copy_generic.o
+lib-y	+= csum_partial_copy_generic.o
 lib-y	+= io-readsw.o io-readsl.o io-writesw.o io-writesl.o
 lib-y	+= io-readsb.o io-writesb.o
 lib-y	+= __avr32_lsl64.o __avr32_lsr64.o __avr32_asr64.o
+
+obj-$(CONFIG_CSUM_PARTIAL) += csum_partial.o
--- linux-2621-rc4g7-csum.orig/arch/arm/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/arm/lib/Makefile
@@ -4,7 +4,7 @@
 # Copyright (C) 1995-2000 Russell King
 #
 
-lib-y		:= backtrace.o changebit.o csumipv6.o csumpartial.o   \
+lib-y		:= backtrace.o changebit.o csumipv6.o		      \
 		   csumpartialcopy.o csumpartialcopyuser.o clearbit.o \
 		   delay.o findbit.o memchr.o memcpy.o		      \
 		   memmove.o memset.o memzero.o setbit.o              \
@@ -42,5 +42,7 @@ lib-$(CONFIG_ARCH_CLPS7500)	+= io-acorn.
 lib-$(CONFIG_ARCH_L7200)	+= io-acorn.o
 lib-$(CONFIG_ARCH_SHARK)	+= io-shark.o
 
+obj-$(CONFIG_CSUM_PARTIAL) += csumpartial.o
+
 $(obj)/csumpartialcopy.o:	$(obj)/csumpartialcopygeneric.S
 $(obj)/csumpartialcopyuser.o:	$(obj)/csumpartialcopygeneric.S
--- linux-2621-rc4g7-csum.orig/arch/arm26/Kconfig
+++ linux-2621-rc4g7-csum/arch/arm26/Kconfig
@@ -70,6 +70,9 @@ config GENERIC_ISA_DMA
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
+config CSUM_PARTIAL
+	def_bool n
+
 source "init/Kconfig"
 
 
--- linux-2621-rc4g7-csum.orig/arch/arm26/lib/Makefile
+++ linux-2621-rc4g7-csum/arch/arm26/lib/Makefile
@@ -4,7 +4,7 @@
 # Copyright (C) 1995-2000 Russell King
 #
 
-lib-y		:= backtrace.o changebit.o csumipv6.o csumpartial.o   \
+lib-y		:= backtrace.o changebit.o csumipv6.o		      \
 		   csumpartialcopy.o csumpartialcopyuser.o clearbit.o \
 		   copy_page.o delay.o findbit.o memchr.o memcpy.o    \
 		   memset.o memzero.o setbit.o                        \
@@ -21,6 +21,8 @@ lib-n		:=
 
 lib-$(CONFIG_VT)+= kbd.o
 
+obj-$(CONFIG_CSUM_PARTIAL) += csumpartial.o
+
 csumpartialcopy.o: csumpartialcopygeneric.S
 csumpartialcopyuser.o: csumpartialcopygeneric.S
 
--- linux-2621-rc4g7-csum.orig/arch/powerpc/Kconfig
+++ linux-2621-rc4g7-csum/arch/powerpc/Kconfig
@@ -118,6 +118,9 @@ config DEFAULT_UIMAGE
 	  Used to allow a board to specify it wants a uImage built by default
 	default n
 
+config CSUM_PARTIAL
+	def_bool y
+
 menu "Processor support"
 choice
 	prompt "Processor Type"
--- linux-2621-rc4g7-csum.orig/arch/arm/Kconfig
+++ linux-2621-rc4g7-csum/arch/arm/Kconfig
@@ -129,6 +129,9 @@ config VECTORS_BASE
 	help
 	  The base address of exception vectors.
 
+config CSUM_PARTIAL
+	def_bool y
+
 source "init/Kconfig"
 
 menu "System Type"
--- linux-2621-rc4g7-csum.orig/fs/Kconfig
+++ linux-2621-rc4g7-csum/fs/Kconfig
@@ -326,6 +326,7 @@ config REISERFS_PROC_INFO
 config REISERFS_FS_XATTR
 	bool "ReiserFS extended attributes"
 	depends on REISERFS_FS
+	select CSUM_PARTIAL
 	help
 	  Extended attributes are name:value pairs associated with inodes by
 	  the kernel or by users (see the attr(5) manual page, or visit
--- linux-2621-rc4g7-csum.orig/net/Kconfig
+++ linux-2621-rc4g7-csum/net/Kconfig
@@ -6,6 +6,7 @@ menu "Networking"
 
 config NET
 	bool "Networking support"
+	select CSUM_PARTIAL
 	---help---
 	  Unless you really know what you are doing, you should say Y here.
 	  The reason is that some programs need kernel networking support even
--- linux-2621-rc4g7-csum.orig/arch/ppc/Kconfig
+++ linux-2621-rc4g7-csum/arch/ppc/Kconfig
@@ -43,6 +43,9 @@ config PPC32
 	bool
 	default y
 
+config CSUM_PARTIAL
+	def_bool y
+
 # All PPCs use generic nvram driver through ppc_md
 config GENERIC_NVRAM
 	bool
--- linux-2621-rc4g7-csum.orig/arch/um/Kconfig
+++ linux-2621-rc4g7-csum/arch/um/Kconfig
@@ -60,6 +60,9 @@ config IRQ_RELEASE_METHOD
 	bool
 	default y
 
+config CSUM_PARTIAL
+	def_bool y
+
 menu "UML-specific options"
 
 config MODE_TT
