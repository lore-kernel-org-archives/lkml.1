Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYJ1H7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYJ1H7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 03:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYJ1H6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 03:58:55 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:38207 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYJ1H6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 03:58:54 -0400
X-Greylist: delayed 2093 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2008 03:58:54 EDT
Message-ID: <4906BE0F.5020202@yucs.org>
Date: Tue, 28 Oct 2008 03:23:59 -0400
From: Shaya Potter <spotter@yucs.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: some sort of x86 build depends on CONFIG_PCI_QUIRKS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[not subscribed to linux-kernel so please cc me]

drivers/pci/quirks.c defines the variable forbid_dac

it's within an #ifdef CONFIG_PCI_QUIRKS block

however, arch/x86/include/asm/iommu.h extern's it

and iommu_setup() in arch/x86/kernel/pci-dma.c uses it

results in a build that fails at the end with

WARNING: modpost: Found 3 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
   GEN     .version
   CHK     include/linux/compile.h
   UPD     include/linux/compile.h
   CC      init/version.o
   LD      init/built-in.o
   LD      .tmp_vmlinux1
arch/x86/kernel/built-in.o: In function `iommu_setup':
pci-dma.c:(.init.text+0x31ed): undefined reference to `forbid_dac'
pci-dma.c:(.init.text+0x320c): undefined reference to `forbid_dac'
pci-dma.c:(.init.text+0x3252): undefined reference to `forbid_dac'
make: *** [.tmp_vmlinux1] Error 1

relevant .config entries (I think)

# Linux kernel version: 2.6.28-rc2
# Tue Oct 28 02:59:45 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
