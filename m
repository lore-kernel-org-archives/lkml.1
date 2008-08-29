Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYH2LsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYH2LsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbYH2Lrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:47:55 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:13774 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbYH2Lry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:47:54 -0400
Message-Id: <48B7FE53.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 12:49:07 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Roman Zippel" <zippel@linux-m68k.org>, <sam@ravnborg.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <tony.luck@intel.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] eliminate "def_bool n" constructs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using "def_bool n" is pointless, simply using bool here appears more
appropriate.

Further, retaining such options that don't have a prompt and aren't
selected by anything seems also at least questionable.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>

---
 arch/Kconfig        |   18 +++++++++---------
 arch/ia64/Kconfig   |    8 --------
 arch/x86/Kconfig    |   23 +++++------------------
 drivers/ide/Kconfig |    2 +-
 kernel/time/Kconfig |    1 -
 lib/Kconfig         |    4 ++--
 mm/Kconfig          |    4 ++--
 7 files changed, 19 insertions(+), 41 deletions(-)

--- linux-2.6.27-rc5/arch/Kconfig	2008-08-21 14:37:27.000000000 +0200
+++ 2.6.27-rc5-kconfig-cleanup/arch/Kconfig	2008-08-19 12:45:21.000000000 +0200
@@ -14,7 +14,7 @@ config OPROFILE
 	  If unsure, say N.
 
 config HAVE_OPROFILE
-	def_bool n
+	bool
 
 config KPROBES
 	bool "Kprobes"
@@ -28,7 +28,7 @@ config KPROBES
 	  If in doubt, say "N".
 
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
-	def_bool n
+	bool
 	help
 	  Some architectures are unable to perform unaligned accesses
 	  without the use of get_unaligned/put_unaligned. Others are
@@ -51,13 +51,13 @@ config KRETPROBES
 	depends on KPROBES && HAVE_KRETPROBES
 
 config HAVE_IOREMAP_PROT
-	def_bool n
+	bool
 
 config HAVE_KPROBES
-	def_bool n
+	bool
 
 config HAVE_KRETPROBES
-	def_bool n
+	bool
 
 #
 # An arch should select this if it provides all these things:
@@ -75,16 +75,16 @@ config HAVE_KRETPROBES
 #	signal delivery		calls tracehook_signal_handler()
 #
 config HAVE_ARCH_TRACEHOOK
-	def_bool n
+	bool
 
 config HAVE_DMA_ATTRS
-	def_bool n
+	bool
 
 config USE_GENERIC_SMP_HELPERS
-	def_bool n
+	bool
 
 config HAVE_CLK
-	def_bool n
+	bool
 	help
 	  The <linux/clk.h> calls support software clock gating and
 	  thus are a key power management tool on many systems.
--- linux-2.6.27-rc5/arch/ia64/Kconfig	2008-08-21 14:37:27.000000000 +0200
+++ 2.6.27-rc5-kconfig-cleanup/arch/ia64/Kconfig	2008-08-19 12:43:54.000000000 +0200
@@ -60,14 +60,6 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
 
-config ARCH_HAS_ILOG2_U32
-	bool
-	default n
-
-config ARCH_HAS_ILOG2_U64
-	bool
-	default n
-
 config HUGETLB_PAGE_SIZE_VARIABLE
 	bool
 	depends on HUGETLB_PAGE
--- linux-2.6.27-rc5/arch/x86/Kconfig	2008-08-29 10:55:12.000000000 +0200
+++ 2.6.27-rc5-kconfig-cleanup/arch/x86/Kconfig	2008-08-20 14:25:50.000000000 +0200
@@ -37,10 +37,6 @@ config ARCH_DEFCONFIG
 	default "arch/x86/configs/i386_defconfig" if X86_32
 	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
-
-config GENERIC_LOCKBREAK
-	def_bool n
-
 config GENERIC_TIME
 	def_bool y
 
@@ -93,7 +89,7 @@ config GENERIC_HWEIGHT
 	def_bool y
 
 config GENERIC_GPIO
-	def_bool n
+	bool
 
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
@@ -104,12 +100,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool X86_XADD
 
-config ARCH_HAS_ILOG2_U32
-	def_bool n
-
-config ARCH_HAS_ILOG2_U64
-	def_bool n
-
 config ARCH_HAS_CPU_IDLE_WAIT
 	def_bool y
 
@@ -758,9 +748,8 @@ config I8K
 	  Say N otherwise.
 
 config X86_REBOOTFIXUPS
-	def_bool n
-	prompt "Enable X86 board specific fixups for reboot"
-	depends on X86_32 && X86
+	bool "Enable X86 board specific fixups for reboot"
+	depends on X86_32
 	---help---
 	  This enables chipset and/or board specific fixups to be done
 	  in order to get reboot to work correctly. This is only needed on
@@ -922,8 +911,7 @@ config HIGHMEM
 	depends on X86_32 && (HIGHMEM64G || HIGHMEM4G)
 
 config X86_PAE
-	def_bool n
-	prompt "PAE (Physical Address Extension) Support"
+	bool "PAE (Physical Address Extension) Support"
 	depends on X86_32 && !HIGHMEM4G
 	select RESOURCES_64BIT
 	help
@@ -1166,8 +1154,7 @@ config X86_PAT
 	  If unsure, say Y.
 
 config EFI
-	def_bool n
-	prompt "EFI runtime service support"
+	bool "EFI runtime service support"
 	depends on ACPI
 	---help---
 	This enables the kernel to use EFI runtime services that are
--- linux-2.6.27-rc5/drivers/ide/Kconfig	2008-08-21 14:37:30.000000000 +0200
+++ 2.6.27-rc5-kconfig-cleanup/drivers/ide/Kconfig	2008-08-19 12:43:54.000000000 +0200
@@ -4,7 +4,7 @@
 
 # Select HAVE_IDE if IDE is supported
 config HAVE_IDE
-	def_bool n
+	bool
 
 menuconfig IDE
 	tristate "ATA/ATAPI/MFM/RLL support"
--- linux-2.6.27-rc5/kernel/time/Kconfig	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.27-rc5-kconfig-cleanup/kernel/time/Kconfig	2008-08-19 12:43:54.000000000 +0200
@@ -3,7 +3,6 @@
 #
 config TICK_ONESHOT
 	bool
-	default n
 
 config NO_HZ
 	bool "Tickless System (Dynamic Ticks)"
--- linux-2.6.27-rc5/lib/Kconfig	2008-08-21 14:37:35.000000000 +0200
+++ 2.6.27-rc5-kconfig-cleanup/lib/Kconfig	2008-08-19 12:43:54.000000000 +0200
@@ -8,10 +8,10 @@ config BITREVERSE
 	tristate
 
 config GENERIC_FIND_FIRST_BIT
-	def_bool n
+	bool
 
 config GENERIC_FIND_NEXT_BIT
-	def_bool n
+	bool
 
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
--- linux-2.6.27-rc5/mm/Kconfig	2008-08-21 14:37:35.000000000 +0200
+++ 2.6.27-rc5-kconfig-cleanup/mm/Kconfig	2008-08-19 12:43:54.000000000 +0200
@@ -101,7 +101,7 @@ config HAVE_MEMORY_PRESENT
 # with gcc 3.4 and later.
 #
 config SPARSEMEM_STATIC
-	def_bool n
+	bool
 
 #
 # Architecture platforms which require a two level mem_section in SPARSEMEM
@@ -113,7 +113,7 @@ config SPARSEMEM_EXTREME
 	depends on SPARSEMEM && !SPARSEMEM_STATIC
 
 config SPARSEMEM_VMEMMAP_ENABLE
-	def_bool n
+	bool
 
 config SPARSEMEM_VMEMMAP
 	bool "Sparse Memory virtual memmap"


