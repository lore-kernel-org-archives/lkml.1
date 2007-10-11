Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbXJKVzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbXJKVzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbXJKVzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:55:05 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48043
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbXJKVzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:55:03 -0400
Content-Disposition: inline
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: User Mode Linux still doesn't build in 2.6.23-final.
Date: Thu, 11 Oct 2007 17:54:46 -0500
User-Agent: KMail/1.9.6
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>
MIME-Version: 1.0
Message-Id: <200710111754.46854.rob@landley.net>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2mqDH0u+YvbCweH"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_2mqDH0u+YvbCweH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

[Second try, without clicking "compress" on the file attachment because then 
sourceforge's spam filter bounces it.]

---

The User Mode Linux build still breaks for me:

> In file included from include/asm/arch/tlb.h:18,
>                  from include/asm/tlb.h:4,
>                  from arch/um/kernel/smp.c:8:
> include/asm-generic/tlb.h: In function ‘tlb_flush_mmu’:
> include/asm-generic/tlb.h:76: error: implicit declaration of function
> ‘release_pages’ include/asm-generic/tlb.h: In function ‘tlb_remove_page’:
> include/asm-generic/tlb.h:105: error: implicit declaration of function
> ‘page_cache_release’ make[1]: *** [arch/um/kernel/smp.o] Error 1
> make: *** [arch/um/kernel] Error 2

I submitted the following patch to fix it to the UML list after 2.6.23-rc3:
http://sourceforge.net/mailarchive/forum.php?thread_name=200708212148.05392.rob%40landley.net&forum_name=user-mode-linux-devel

On september 4, I confirmed that I still needed it to build -rc5:
http://sourceforge.net/mailarchive/message.php?msg_name=200709040737.54516.rob%40landley.net

Guess what?  I still need this patch to build the final 2.6.23, months later.

I know it may not be the right fix, but the build breaks for me without this 
patch. The .config that breaks is attached.  ARCH=um.

----------  Forwarded Message  ----------

Subject: [uml-devel] UML doesn't build in 2.6.23-rc3.
Date: Tuesday 21 August 2007
From: Rob Landley <rob@landley.net>
To: uml-devel <user-mode-linux-devel@lists.sourceforge.net>

I fixed it for me with the following patch, just in case anybody else had this 
problem:

--- linux-2.6.23-rc3/arch/um/kernel/smp.c	2007-08-12 23:25:24.000000000 -0500
+++ linux-2.6.23-new/arch/um/kernel/smp.c	2007-08-21 21:39:00.000000000 -0500
@@ -5,6 +5,7 @@
 
 #include "linux/percpu.h"
 #include "asm/pgalloc.h"
+#include "linux/pagemap.h"
 #include "asm/tlb.h"
 
 /* For some reason, mmu_gathers are referenced when CONFIG_SMP is off. */

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

--Boundary-00=_2mqDH0u+YvbCweH
Content-Type: text/plain;
  charset="utf-8";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23
# Thu Oct 11 16:55:41 2007
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
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_UML_X86=y
# CONFIG_64BIT is not set
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_HOST_VMSPLIT_3G=y
# CONFIG_HOST_VMSPLIT_3G_OPT is not set
# CONFIG_HOST_VMSPLIT_2G is not set
# CONFIG_HOST_VMSPLIT_1G is not set
CONFIG_TOP_ADDR=0xC0000000
CONFIG_STUB_CODE=0xbfffe000
CONFIG_STUB_DATA=0xbffff000
CONFIG_STUB_START=0xbfffe000
CONFIG_ARCH_HAS_SC_SIGNALS=y
CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_LD_SCRIPT_DYN=y
# CONFIG_NET is not set
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
CONFIG_HOSTFS=y
# CONFIG_MCONSOLE is not set
CONFIG_NEST_LEVEL=0
CONFIG_KERNEL_STACK_ORDER=0
# CONFIG_UML_REAL_TIME_CLOCK is not set

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=128
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
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
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_UBD is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_MMAPPER is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_RAM is not set

#
# Character Devices
#
CONFIG_STDERR_CONSOLE=y
CONFIG_STDIO_CONSOLE=y
# CONFIG_SSL is not set
# CONFIG_NULL_CHAN is not set
# CONFIG_PORT_CHAN is not set
# CONFIG_PTY_CHAN is not set
# CONFIG_TTY_CHAN is not set
# CONFIG_XTERM_CHAN is not set
CONFIG_NOCONFIG_CHAN=y
CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
CONFIG_CON_CHAN="xterm"
CONFIG_SSL_CHAN="pty"
CONFIG_UNIX98_PTYS=y
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
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
# CONFIG_FW_LOADER is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Networking
#

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y

#
# Miscellaneous filesystems
#
# CONFIG_HFSPLUS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
# CONFIG_NLS is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_CRYPTO is not set

#
# Library routines
#
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
# CONFIG_CRC32 is not set
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_DMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_MD is not set
# CONFIG_INPUT is not set

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_STACK_USAGE is not set

--Boundary-00=_2mqDH0u+YvbCweH--

