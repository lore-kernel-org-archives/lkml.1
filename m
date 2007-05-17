Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbXEQVFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbXEQVFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbXEQVFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:05:47 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:32962 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417AbXEQVFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:05:46 -0400
Date: Thu, 17 May 2007 23:05:38 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Rob Landley <rob@landley.net>
Cc: LKML <linux-kernel@vger.kernel.org>, jdike@karaya.com
Subject: Re: UML doesn't compile in 2.6.21
Message-ID: <20070517210538.GO12319@pengutronix.de>
References: <20070516224938.GN12319@pengutronix.de> <200705162111.19123.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200705162111.19123.rob@landley.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

On Wed, May 16, 2007 at 09:11:18PM -0400, Rob Landley wrote:
> 2.6.21.1 built for me:
> 
> tar xvjf linux-2.6.21.1.tar.bz2 &&
> cd linux-2.6.21.1 &&
> cat > mini.conf << EOF
> CONFIG_MODE_SKAS=y
> CONFIG_BINFMT_ELF=y
> CONFIG_HOSTFS=y
> CONFIG_SYSCTL=y
> CONFIG_STDERR_CONSOLE=y
> CONFIG_UNIX98_PTYS=y
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_LBD=y
> CONFIG_EXT2_FS=y
> CONFIG_PROC_FS=y
> EOF
> make ARCH=um allnoconfig KCONFIG_ALLCONFIG=mini.conf &&
> make ARCH=um &&
> ./linux rootfstype=hostfs rw init=/bin/sh
> 
> Does this not work for you?

Yes, this compiles - with this warning, btw:

WARNING: vmlinux - Section mismatch: reference to .init.text:lpj_setup from .got after '_GLOBAL_OFFSET_TABLE_' (at offset 0x814de34)
WARNING: vmlinux - Section mismatch: reference to .init.text:set_reset_devices from .bss between 'stdout@@GLIBC_2.0' (at offset 0x814de40) and 'stderr@@GLIBC_2.0'

So it must be something with my configuration. I've tried to build a
minimized configuration, see below. You can trigger the bug here by
changing "Enable loadable module support.

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.21
# Thu May 17 23:01:31 2007
#
CONFIG_DEFCONFIG_LIST="arch/$ARCH/defconfig"
CONFIG_GENERIC_HARDIRQS=y
CONFIG_UML=y
CONFIG_MMU=y
CONFIG_NO_IOMEM=y
# CONFIG_TRACE_IRQFLAGS_SUPPORT is not set
CONFIG_LOCKDEP_SUPPORT=y
# CONFIG_STACKTRACE_SUPPORT is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_BUG=y
CONFIG_IRQ_RELEASE_METHOD=y

#
# UML-specific options
#
# CONFIG_STATIC_LINK is not set
CONFIG_MODE_SKAS=y

#
# Host processor type and features
#
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_UML_X86=y
# CONFIG_64BIT is not set
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_HOST_VMSPLIT_3G=y
# CONFIG_HOST_VMSPLIT_3G_OPT is not set
# CONFIG_HOST_VMSPLIT_2G is not set
# CONFIG_HOST_VMSPLIT_1G is not set
CONFIG_TOP_ADDR=0xC0000000
# CONFIG_3_LEVEL_PGTABLES is not set
CONFIG_STUB_CODE=0xbfffe000
CONFIG_STUB_DATA=0xbffff000
CONFIG_STUB_START=0xbfffe000
CONFIG_ARCH_HAS_SC_SIGNALS=y
CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_LD_SCRIPT_DYN=y
# CONFIG_NET is not set
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_MISC=y
CONFIG_HOSTFS=y
# CONFIG_HPPFS is not set
CONFIG_MCONSOLE=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_NEST_LEVEL=0
CONFIG_HIGHMEM=y
CONFIG_KERNEL_STACK_ORDER=2
CONFIG_UML_REAL_TIME_CLOCK=y

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=128

#
# General setup
#
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_UTS_NS is not set
# CONFIG_IKCONFIG is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_SLOB is not set

#
# Loadable module support
#
CONFIG_MODULES=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_KMOD is not set

#
# Block layer
#
# CONFIG_BLOCK is not set
# CONFIG_MMAPPER is not set

#
# Character Devices
#
# CONFIG_STDERR_CONSOLE is not set
CONFIG_STDIO_CONSOLE=y
# CONFIG_SSL is not set
# CONFIG_NULL_CHAN is not set
# CONFIG_PORT_CHAN is not set
# CONFIG_PTY_CHAN is not set
# CONFIG_TTY_CHAN is not set
# CONFIG_XTERM_CHAN is not set
CONFIG_NOCONFIG_CHAN=y
CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
CONFIG_CON_CHAN="port"
CONFIG_SSL_CHAN="port"
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_WATCHDOG is not set
# CONFIG_UML_SOUND is not set
# CONFIG_SOUND is not set
# CONFIG_HOSTAUDIO is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_UML_RANDOM is not set

#
# Generic Driver Options
#
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
# CONFIG_FW_LOADER is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Networking
#

#
# Connector - unified userspace <-> kernelspace linker
#

#
# File systems
#
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_DNOTIFY is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
# CONFIG_SYSFS is not set
# CONFIG_TMPFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y

#
# Miscellaneous filesystems
#

#
# Native Language Support
#
# CONFIG_NLS is not set

#
# Security options
#
# CONFIG_KEYS is not set

#
# Cryptographic options
#
# CONFIG_CRYPTO is not set

#
# Library routines
#
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC32 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
# CONFIG_INPUT is not set

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_DEBUG_BUGVERBOSE is not set
