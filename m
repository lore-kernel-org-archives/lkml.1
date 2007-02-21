Return-Path: <linux-kernel-owner+w=401wt.eu-S1161242AbXBUNiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161242AbXBUNiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161243AbXBUNiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:38:55 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:54999 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161240AbXBUNis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:38:48 -0500
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Organization: IBM
To: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       linux-s390@vger.kernel.org, hpa@zytor.com
Subject: [RFC] [PATCH 2/2] s390: SCSI dump kernel and userspace application
Date: Wed, 21 Feb 2007 14:40:07 +0100
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702211440.08117.holzheu@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace part of the s390 SCSI dumper.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>

---
 arch/s390/Makefile                    |    4 
 arch/s390/zfcpdump/Makefile           |    5 
 arch/s390/zfcpdump/defconfig.zfcpdump |  467 ++++++++++++++++
 arch/s390/zfcpdump/initramfs.txt      |    6 
 arch/s390/zfcpdump/zfcpdump.c         |  953 ++++++++++++++++++++++++++++++++++
 arch/s390/zfcpdump/zfcpdump.h         |  214 +++++++
 6 files changed, 1649 insertions(+)

Index: git-linux-2.6/arch/s390/Makefile
===================================================================
--- git-linux-2.6.orig/arch/s390/Makefile	2007-02-21 13:09:01.000000000 +0100
+++ git-linux-2.6/arch/s390/Makefile	2007-02-21 13:09:06.000000000 +0100
@@ -94,6 +94,7 @@ drivers-$(CONFIG_MATHEMU) += arch/$(ARCH
 drivers-$(CONFIG_OPROFILE)	+= arch/s390/oprofile/
 
 boot		:= arch/$(ARCH)/boot
+zfcpdump	:= arch/s390/zfcpdump
 
 all: image
 
@@ -103,6 +104,9 @@ install: vmlinux
 image: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
+zfcpdump:
+	$(Q)$(MAKE) $(build)=$(zfcpdump) $(zfcpdump)/$@
+
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 
Index: git-linux-2.6/arch/s390/zfcpdump/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-linux-2.6/arch/s390/zfcpdump/Makefile	2007-02-21 13:09:06.000000000 +0100
@@ -0,0 +1,5 @@
+targets := zfcpdump
+
+$(obj)/zfcpdump: arch/s390/zfcpdump/zfcpdump.c arch/s390/zfcpdump/zfcpdump.h
+	$(CC) -Wall -o $(obj)/zfcpdump $(obj)/zfcpdump.c -static
+
Index: git-linux-2.6/arch/s390/zfcpdump/defconfig.zfcpdump
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-linux-2.6/arch/s390/zfcpdump/defconfig.zfcpdump	2007-02-21 13:09:06.000000000 +0100
@@ -0,0 +1,467 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.20
+# Tue Feb 20 12:54:03 2007
+#
+CONFIG_MMU=y
+CONFIG_LOCKDEP_SUPPORT=y
+CONFIG_STACKTRACE_SUPPORT=y
+CONFIG_RWSEM_XCHGADD_ALGORITHM=y
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_TIME=y
+CONFIG_S390=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+
+#
+# Code maturity level options
+#
+# CONFIG_EXPERIMENTAL is not set
+CONFIG_LOCK_KERNEL=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+
+#
+# General setup
+#
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+CONFIG_SWAP=y
+# CONFIG_SYSVIPC is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
+# CONFIG_AUDIT is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+# CONFIG_CPUSETS is not set
+# CONFIG_SYSFS_DEPRECATED is not set
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE="arch/s390/zfcpdump/initramfs.txt"
+CONFIG_INITRAMFS_ROOT_UID=0
+CONFIG_INITRAMFS_ROOT_GID=0
+CONFIG_SYSCTL=y
+# CONFIG_EMBEDDED is not set
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_ALL is not set
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_EPOLL=y
+CONFIG_SHMEM=y
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_RT_MUTEXES=y
+# CONFIG_TINY_SHMEM is not set
+CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
+
+#
+# Loadable module support
+#
+# CONFIG_MODULES is not set
+
+#
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+CONFIG_IOSCHED_AS=y
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+CONFIG_DEFAULT_DEADLINE=y
+# CONFIG_DEFAULT_CFQ is not set
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="deadline"
+
+#
+# Base setup
+#
+
+#
+# Processor type and features
+#
+CONFIG_64BIT=y
+CONFIG_SMP=y
+CONFIG_NR_CPUS=32
+# CONFIG_HOTPLUG_CPU is not set
+CONFIG_DEFAULT_MIGRATION_COST=1000000
+# CONFIG_COMPAT is not set
+CONFIG_AUDIT_ARCH=y
+CONFIG_S390_SWITCH_AMODE=y
+CONFIG_S390_EXEC_PROTECT=y
+
+#
+# Code generation options
+#
+# CONFIG_MARCH_G5 is not set
+CONFIG_MARCH_Z900=y
+# CONFIG_MARCH_Z990 is not set
+# CONFIG_MARCH_Z9_109 is not set
+CONFIG_PACK_STACK=y
+# CONFIG_SMALL_STACK is not set
+CONFIG_CHECK_STACK=y
+CONFIG_STACK_GUARD=256
+# CONFIG_WARN_STACK is not set
+CONFIG_ARCH_POPULATES_NODE_MAP=y
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+CONFIG_RESOURCES_64BIT=y
+CONFIG_HOLES_IN_ZONE=y
+
+#
+# I/O subsystem configuration
+#
+CONFIG_MACHCHK_WARNING=y
+CONFIG_QDIO=y
+# CONFIG_QDIO_DEBUG is not set
+
+#
+# Misc
+#
+CONFIG_PREEMPT=y
+CONFIG_IPL=y
+# CONFIG_IPL_TAPE is not set
+CONFIG_IPL_VM=y
+CONFIG_BINFMT_ELF=y
+# CONFIG_BINFMT_MISC is not set
+# CONFIG_PROCESS_DEBUG is not set
+CONFIG_PFAULT=y
+# CONFIG_SHARED_KERNEL is not set
+# CONFIG_CMM is not set
+CONFIG_VIRT_TIMER=y
+CONFIG_VIRT_CPU_ACCOUNTING=y
+# CONFIG_APPLDATA_BASE is not set
+CONFIG_NO_IDLE_HZ=y
+CONFIG_NO_IDLE_HZ_INIT=y
+# CONFIG_S390_HYPFS_FS is not set
+# CONFIG_KEXEC is not set
+CONFIG_S390_ZFCPDUMP=y
+
+#
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+# CONFIG_PACKET is not set
+# CONFIG_UNIX is not set
+# CONFIG_NET_KEY is not set
+# CONFIG_IUCV is not set
+# CONFIG_INET is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+# CONFIG_PCMCIA is not set
+
+#
+# Generic Driver Options
+#
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+# CONFIG_FW_LOADER is not set
+# CONFIG_DEBUG_DRIVER is not set
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
+
+#
+# SCSI device support
+#
+# CONFIG_RAID_ATTRS is not set
+CONFIG_SCSI=y
+CONFIG_SCSI_NETLINK=y
+CONFIG_SCSI_PROC_FS=y
+
+#
+# SCSI support type (disk, tape, CD-ROM)
+#
+CONFIG_BLK_DEV_SD=y
+# CONFIG_CHR_DEV_ST is not set
+# CONFIG_CHR_DEV_OSST is not set
+# CONFIG_BLK_DEV_SR is not set
+# CONFIG_CHR_DEV_SG is not set
+# CONFIG_CHR_DEV_SCH is not set
+
+#
+# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
+#
+CONFIG_SCSI_MULTI_LUN=y
+CONFIG_SCSI_CONSTANTS=y
+CONFIG_SCSI_LOGGING=y
+# CONFIG_SCSI_SCAN_ASYNC is not set
+
+#
+# SCSI Transports
+#
+# CONFIG_SCSI_SPI_ATTRS is not set
+CONFIG_SCSI_FC_ATTRS=y
+# CONFIG_SCSI_ISCSI_ATTRS is not set
+# CONFIG_SCSI_SAS_ATTRS is not set
+# CONFIG_SCSI_SAS_LIBSAS is not set
+
+#
+# SCSI low-level drivers
+#
+# CONFIG_SCSI_DEBUG is not set
+CONFIG_ZFCP=y
+CONFIG_CCW=y
+
+#
+# Block devices
+#
+# CONFIG_BLK_DEV_COW_COMMON is not set
+# CONFIG_BLK_DEV_LOOP is not set
+# CONFIG_BLK_DEV_NBD is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+CONFIG_BLK_DEV_INITRD=y
+# CONFIG_CDROM_PKTCDVD is not set
+
+#
+# S/390 block device drivers
+#
+# CONFIG_BLK_DEV_XPRAM is not set
+# CONFIG_DCSSBLK is not set
+# CONFIG_DASD is not set
+# CONFIG_ATA_OVER_ETH is not set
+
+#
+# Multi-device support (RAID and LVM)
+#
+# CONFIG_MD is not set
+
+#
+# Character device drivers
+#
+# CONFIG_UNIX98_PTYS is not set
+# CONFIG_HANGCHECK_TIMER is not set
+
+#
+# Watchdog Cards
+#
+# CONFIG_WATCHDOG is not set
+
+#
+# S/390 character device drivers
+#
+CONFIG_TN3270=y
+CONFIG_TN3270_TTY=y
+CONFIG_TN3270_FS=y
+CONFIG_TN3270_CONSOLE=y
+CONFIG_TN3215=y
+CONFIG_TN3215_CONSOLE=y
+CONFIG_CCW_CONSOLE=y
+CONFIG_SCLP_TTY=y
+CONFIG_SCLP_CONSOLE=y
+CONFIG_SCLP_VT220_TTY=y
+CONFIG_SCLP_VT220_CONSOLE=y
+# CONFIG_SCLP_CPI is not set
+# CONFIG_S390_TAPE is not set
+# CONFIG_VMCP is not set
+# CONFIG_MONWRITER is not set
+
+#
+# Cryptographic devices
+#
+# CONFIG_ZCRYPT is not set
+
+#
+# Network device support
+#
+# CONFIG_NETDEVICES is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+
+#
+# File systems
+#
+CONFIG_EXT2_FS=y
+# CONFIG_EXT2_FS_XATTR is not set
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
+CONFIG_EXT3_FS_XATTR=y
+# CONFIG_EXT3_FS_POSIX_ACL is not set
+# CONFIG_EXT3_FS_SECURITY is not set
+CONFIG_JBD=y
+# CONFIG_JBD_DEBUG is not set
+CONFIG_FS_MBCACHE=y
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_FS_POSIX_ACL is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_ROMFS_FS is not set
+# CONFIG_INOTIFY is not set
+# CONFIG_QUOTA is not set
+CONFIG_DNOTIFY=y
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# CD-ROM/DVD Filesystems
+#
+# CONFIG_ISO9660_FS is not set
+# CONFIG_UDF_FS is not set
+
+#
+# DOS/FAT/NT Filesystems
+#
+# CONFIG_MSDOS_FS is not set
+# CONFIG_VFAT_FS is not set
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+# CONFIG_TMPFS is not set
+# CONFIG_HUGETLB_PAGE is not set
+CONFIG_RAMFS=y
+
+#
+# Miscellaneous filesystems
+#
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_CRAMFS is not set
+# CONFIG_VXFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+
+#
+# Network File Systems
+#
+
+#
+# Partition Types
+#
+CONFIG_PARTITION_ADVANCED=y
+# CONFIG_ACORN_PARTITION is not set
+# CONFIG_OSF_PARTITION is not set
+# CONFIG_AMIGA_PARTITION is not set
+# CONFIG_ATARI_PARTITION is not set
+CONFIG_IBM_PARTITION=y
+# CONFIG_MAC_PARTITION is not set
+CONFIG_MSDOS_PARTITION=y
+# CONFIG_BSD_DISKLABEL is not set
+# CONFIG_MINIX_SUBPARTITION is not set
+# CONFIG_SOLARIS_X86_PARTITION is not set
+# CONFIG_UNIXWARE_DISKLABEL is not set
+# CONFIG_LDM_PARTITION is not set
+# CONFIG_SGI_PARTITION is not set
+# CONFIG_ULTRIX_PARTITION is not set
+# CONFIG_SUN_PARTITION is not set
+# CONFIG_KARMA_PARTITION is not set
+# CONFIG_EFI_PARTITION is not set
+
+#
+# Native Language Support
+#
+# CONFIG_NLS is not set
+
+#
+# Instrumentation Support
+#
+# CONFIG_PROFILING is not set
+# CONFIG_STATISTICS is not set
+
+#
+# Kernel hacking
+#
+CONFIG_TRACE_IRQFLAGS_SUPPORT=y
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+CONFIG_DEBUG_FS=y
+# CONFIG_HEADERS_CHECK is not set
+CONFIG_DEBUG_KERNEL=y
+CONFIG_LOG_BUF_SHIFT=17
+# CONFIG_SCHEDSTATS is not set
+# CONFIG_DEBUG_SLAB is not set
+CONFIG_DEBUG_PREEMPT=y
+# CONFIG_DEBUG_RT_MUTEXES is not set
+# CONFIG_RT_MUTEX_TESTER is not set
+CONFIG_DEBUG_SPINLOCK=y
+CONFIG_DEBUG_MUTEXES=y
+# CONFIG_DEBUG_RWSEMS is not set
+# CONFIG_DEBUG_LOCK_ALLOC is not set
+# CONFIG_PROVE_LOCKING is not set
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
+# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
+# CONFIG_DEBUG_KOBJECT is not set
+# CONFIG_DEBUG_INFO is not set
+# CONFIG_DEBUG_VM is not set
+# CONFIG_DEBUG_LIST is not set
+# CONFIG_FRAME_POINTER is not set
+CONFIG_FORCED_INLINING=y
+# CONFIG_RCU_TORTURE_TEST is not set
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY is not set
+
+#
+# Cryptographic options
+#
+# CONFIG_CRYPTO is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+CONFIG_CRC32=y
+# CONFIG_LIBCRC32C is not set
+CONFIG_PLIST=y
+CONFIG_IOMAP_COPY=y
Index: git-linux-2.6/arch/s390/zfcpdump/initramfs.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-linux-2.6/arch/s390/zfcpdump/initramfs.txt	2007-02-21 13:09:06.000000000 +0100
@@ -0,0 +1,6 @@
+dir /dev 755 0 0
+nod /dev/console 644 0 0 c 5 1
+file /init arch/s390/zfcpdump/zfcpdump 755 0 0
+dir /proc 755 0 0
+dir /sys 755 0 0
+dir /mnt 755 0 0
Index: git-linux-2.6/arch/s390/zfcpdump/zfcpdump.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-linux-2.6/arch/s390/zfcpdump/zfcpdump.c	2007-02-21 13:09:06.000000000 +0100
@@ -0,0 +1,953 @@
+/*
+ * zfcp dump userspace tool
+ *
+ * This tool should be used in an intitramfs together with a kernel with
+ * enabled S390_ZFCPDUMP kernel build option. The tool is able to write
+ * standalone system dumps on SCSI disks.
+ *
+ * To build a zfcpdump enabled kernel you have to do the following:
+ * - Use defconfig.zfcpdump for kernel build
+ * - "make zfcpdump" from the toplevel directory of the Linux tree. This step
+ *   has a dependency on glibc and libz.
+ * - "make image" to build the zfcpdump image
+ *
+ * See Documentation/s390/zfcpdump.txt for more information!
+ *
+ * Copyright IBM Corp. 2003,2007
+ * Author(s): Michael Holzheu
+ */
+
+#ifdef GZIP_SUPPORT
+#include <zlib.h>
+#endif
+#include <errno.h>
+#include <string.h>
+#include <dirent.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <time.h>
+#include <fcntl.h>
+#include <sys/reboot.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/stat.h>
+#include <sys/mount.h>
+#include <sys/time.h>
+#include <linux/reboot.h>
+#include <asm/types.h>
+#include "zfcpdump.h"
+
+static struct globals g;
+
+/*
+ * parse one kernel parameter in the form keyword=value
+ */
+static int parse_parameter(char *parameter)
+{
+	char *token;
+	token = strtok(parameter, "=");
+	if (token == NULL)
+		return 0;
+
+	if (strcmp(token, PARM_DIR) == 0) {
+		/* Dump Dir */
+		g.parm_dir = strtok(NULL, "=");
+		if (g.parm_dir == NULL) {
+			PRINT_WARN("No value for '%s' parameter specified\n",
+				    PARM_DIR);
+			PRINT_WARN("Using default: %s\n", PARM_DIR_DFLT);
+			g.parm_dir = PARM_DIR_DFLT;
+		}
+	} else if (strcmp(token, PARM_PART) == 0) {
+		/* Dump Partition */
+		g.parm_part = strtok(NULL, "=");
+		if (g.parm_part == NULL) {
+			PRINT_ERR("No value for '%s' parameter "
+				  "specified\n", PARM_PART);
+			goto fail;
+		}
+	} else if (strcmp(token, PARM_MEM) == 0) {
+		/* Dump mem */
+		char *mem_str = strtok(NULL,"=");
+		if (mem_str == NULL) {
+			PRINT_ERR("No value for '%s' parameter "
+				  "specified\n", PARM_MEM);
+			goto fail;
+		}
+		g.parm_mem = strtoll(mem_str, NULL, 0);
+	} else if (strcmp(token, PARM_COMP) == 0) {
+		/* Dump Compression */
+		g.parm_compress = strtok(NULL, "=");
+		if (g.parm_compress == NULL) {
+			PRINT_WARN("No value for '%s' parameter "
+				   "specified\n", PARM_COMP);
+			PRINT_WARN("Using default: %s\n",
+				   PARM_COMP_DFLT);
+			g.parm_compress = PARM_COMP_DFLT;
+		} else if ((strcmp(g.parm_compress,
+				PARM_COMP_GZIP) != 0) &&
+				(strcmp(g.parm_compress,
+				PARM_COMP_NONE) != 0)) {
+			PRINT_WARN("Unknown dump compression '%s' "
+				"specified!\n",g.parm_compress);
+			PRINT_WARN("Using default: %s\n", PARM_COMP_DFLT);
+			g.parm_compress = PARM_COMP_DFLT;
+		}
+	} else if (strcmp(token, PARM_DEBUG) == 0) {
+		/* Dump Debug */
+		char *s = strtok(NULL, "=");
+		if (s == NULL) {
+			PRINT_WARN("No value for '%s' parameter "
+				"specified\n", PARM_DEBUG);
+			PRINT_WARN("Using default: %d\n", PARM_DEBUG_DFLT);
+		} else {
+			g.parm_debug = atoi(s);
+			if ((g.parm_debug < PARM_DEBUG_MIN) ||
+			    (g.parm_debug > PARM_DEBUG_MAX)) {
+				PRINT_WARN("Invalid value (%i) for %s "
+				"parameter specified (allowed range is "
+				"%i - %i)\n",g.parm_debug,
+				PARM_DEBUG, PARM_DEBUG_MIN,
+				PARM_DEBUG_MAX);
+				PRINT_WARN("Using default: %i\n",
+				PARM_DEBUG_DFLT);
+				g.parm_debug = PARM_DEBUG_DFLT;
+			}
+		}
+	} else if (strcmp(token, PARM_MODE) == 0) {
+		/* Dump Mode */
+		char *s = strtok(NULL,"=");
+		if (s == NULL) {
+			PRINT_WARN("No value for '%s' parameter "
+				"specified\n", PARM_MODE);
+			PRINT_WARN("Using default: %s\n",
+				PARM_MODE_DFLT);
+		} else if (strcmp(s,PARM_MODE_INTERACT) == 0) {
+			g.parm_mode = PARM_MODE_INTERACT_NUM;
+		} else if (strcmp(s,PARM_MODE_AUTO) == 0) {
+			g.parm_mode = PARM_MODE_AUTO_NUM;
+		} else {
+			PRINT_WARN("Unknown dump mode: %s\n",s);
+			PRINT_WARN("Using default: %s\n",
+				PARM_MODE_DFLT);
+		}
+	}
+	return 0;
+fail:
+	return -1;
+}
+
+/*
+ * Get dump parameters from /proc/cmdline
+ * Return: 0       - ok
+ *         (!= 0)  - error
+ */
+static int parse_parmline(void) {
+	int fh, i, count, token_cnt;
+	char *token;
+	char *parms[KERN_PARM_MAX];
+
+	/* setting defaults */
+
+	g.parm_compress = PARM_COMP_DFLT;
+	g.parm_dir      = PARM_DIR_DFLT;
+	g.parm_part     = PARM_PART_DFLT;
+	g.parm_debug    = PARM_DEBUG_DFLT;
+	g.parm_mode     = PARM_MODE_NUM_DFLT;
+	g.parm_mem      = PARM_MEM_DFLT;
+
+	fh = open(PROC_CMDLINE, O_RDONLY);
+	if (fh == -1) {
+		PRINT_PERR("open %s failed\n", PROC_CMDLINE);
+		return -1;
+	}
+	if ((count = read(fh, g.parmline, CMDLINE_MAX_LEN)) == -1) {
+		PRINT_PERR("read %s failed\n", PROC_CMDLINE);
+		close(fh);
+		return -1;
+	}
+	g.parmline[count-1] = '\0'; /* remove \n */
+	token = strtok(g.parmline, " \t\n");
+	token_cnt = 0;
+	while (token != NULL) {
+		parms[token_cnt] = token;
+		token = strtok(NULL," \t\n");
+		token_cnt++;
+		if (token_cnt >= KERN_PARM_MAX) {
+			PRINT_WARN("More than %i kernel parmameters specified\n",
+				   KERN_PARM_MAX);
+			break;
+		}
+	}
+	for (i = 0; i < token_cnt; i++) {
+		if (parse_parameter(parms[i])) {
+			close(fh);
+			return -1;
+		}
+	}
+	PRINT_TRACE("dump dir  : %s\n", g.parm_dir);
+	PRINT_TRACE("dump part : %s\n", g.parm_part);
+	PRINT_TRACE("dump comp : %s\n", g.parm_compress);
+	PRINT_TRACE("dump debug: %d\n", g.parm_debug);
+	PRINT_TRACE("dump mem:   %llx\n", (unsigned long long) g.parm_mem);
+
+	if (g.parm_mode == PARM_MODE_AUTO_NUM)
+		PRINT_TRACE("dump mode : %s\n", PARM_MODE_AUTO);
+	if (g.parm_mode == PARM_MODE_INTERACT_NUM)
+		PRINT_TRACE("dump mode : %s\n", PARM_MODE_INTERACT);
+
+	sprintf(g.dump_dir, "%s/%s", DUMP_DIR, g.parm_dir);
+	close(fh);
+	return 0;
+}
+
+static int write_to_file(const char *file, const char *command)
+{
+	int fh;
+
+	fh = open(file, O_WRONLY);
+	if (fh == -1) {
+		PRINT_PERR("Could not open %s", file);
+		return -1;
+	}
+	if (write(fh, command, strlen(command)) != strlen(command)) {
+		PRINT_PERR("Write to %s failed", file);
+		close(fh);
+		return -1;
+	};
+	close(fh);
+	return 0;
+}
+
+static int read_file(const char *file, char *buf, int size)
+{
+	int fh;
+
+	PRINT_TRACE("Read: %s:", file);
+	fh = open(file, O_RDONLY);
+	if (fh == -1) {
+		PRINT_PERR("open %s failed", file);
+		return -1;
+	}
+	if (read(fh, buf, size) < 0) {
+		PRINT_PERR("read %s failed", file);
+		close(fh);
+		return -1;
+	}
+	if (buf[strlen(buf) - 1] == '\n')
+		buf[strlen(buf) - 1] = 0; /* strip newline */
+	close(fh);
+	PRINT_TRACE("'%s'\n", buf);
+	return 0;
+}
+
+/*
+ * Enable the scsi disk for dumping
+ * Return:    0 - ok
+ *         != 0 - error
+ */
+static int enable_zfcp_device(void)
+{
+	char command[1024], file[1024];
+
+	/* device */
+	read_file("/sys/firmware/ipl/device", g.dump_devno,
+		sizeof(g.dump_devno));
+	sprintf(file, "/sys/bus/ccw/drivers/zfcp/%s/online", g.dump_devno);
+	if (write_to_file(file, "1\n"))
+		return -1;
+
+	/* wwpn */
+	read_file("/sys/firmware/ipl/wwpn", g.dump_wwpn, sizeof(g.dump_wwpn));
+	sprintf(file, "/sys/bus/ccw/drivers/zfcp/%s/port_add", g.dump_devno);
+	sprintf(command, "%s\n", g.dump_wwpn);
+	if (write_to_file(file, command))
+		return -1;
+
+	/* lun */
+	read_file("/sys/firmware/ipl/lun", g.dump_lun, sizeof(g.dump_lun));
+	sprintf(file, "/sys/bus/ccw/drivers/zfcp/%s/%s/unit_add", g.dump_devno,
+		g.dump_wwpn);
+	sprintf(command, "%s\n", g.dump_lun);
+	if (write_to_file(file, command))
+		return -1;
+
+	/* bootprog */
+	read_file("/sys/firmware/ipl/bootprog", g.dump_bootprog,
+		sizeof(g.dump_bootprog));
+
+	return 0;
+}
+
+/*
+ * Mount the dump device
+ * Return:    0 - ok
+ *         != 0 - error
+ */
+static int mount_dump_device(void)
+{
+	int pid;
+
+	PRINT_TRACE("e2fsck\n");
+	pid = fork();
+	if (pid < 0) {
+		PRINT_PERR("fork failed\n");
+		return -1;
+	} else if (pid == 0) {
+		execl("/sbin/e2fsck", "e2fsck", DEV_SCSI, "-y", NULL);
+	} else {
+		waitpid (pid, NULL, 0);
+	}
+
+	PRINT_TRACE("mount\n");
+	if (mount(DEV_SCSI, DUMP_DIR, "ext3", 0, NULL) == 0)
+		return 0;
+	if (mount(DEV_SCSI, DUMP_DIR, "ext2", 0, NULL) != 0) {
+		PRINT_PERR("mount failed\n");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * unmount the dump device
+ * Return:    0 - ok
+ *         != 0 - error
+ */
+static int umount_dump_device(void)
+{
+	if (umount(DUMP_DIR) != 0) {
+		PRINT_PERR("umount failed");
+		return -1;
+	}
+	return 0;
+}
+
+static int get_zcore_dev(dev_t *dev)
+{
+	char buf[4096], *token;
+	char *line = buf;
+	int fh, minor;
+
+	fh = open("/proc/misc", O_RDONLY);
+	if (fh == -1)
+		return -1;
+	if (read(fh, buf, 4096) < 0)
+		goto failed;
+	token = strtok(line, " \n");
+
+	while (token) {
+		if (strcmp(token, "zcore") == 0)
+			goto found;
+		minor = atoi(token);
+		token = strtok(NULL, " \n");
+	}
+failed:
+	close(fh);
+	return -1;
+found:
+	close(fh);
+	*dev = makedev(10, minor);
+	return 0;
+}
+
+/*
+ * Terminate the system dumper
+ */
+static void terminate(void)
+{
+	sleep(WAIT_TIME_END); /* give the messages time to be displayed */
+	reboot(LINUX_REBOOT_CMD_POWER_OFF);
+}
+
+/*
+ * Signal handler for zfcp_dumper
+ */
+static __sighandler_t dump_sig_handler(int sig, siginfo_t *sip, void*p)
+{
+	PRINT_ERR("Got signal: %i\n", sig);
+	PRINT_ERR("Dump failed!\n");
+	terminate();
+	return 0;
+}
+
+/*
+ * Setup the Signal handler for zfcp_dumper
+ * Return:   0 - ok
+ *         !=0 - error
+ */
+static int init_sig(void)
+{
+	g.sigact.sa_flags = (SA_NODEFER | SA_SIGINFO | SA_RESETHAND);
+	g.sigact.sa_handler = (__sighandler_t)dump_sig_handler;
+	if (sigemptyset(&g.sigact.sa_mask) < 0)
+		return -1;
+	if (sigaction(SIGINT, &g.sigact, NULL) < 0)
+		return -1;
+	if (sigaction(SIGTERM, &g.sigact, NULL) < 0)
+		return -1;
+	if (sigaction(SIGPIPE, &g.sigact, NULL) < 0)
+		return -1;
+	if (sigaction(SIGABRT, &g.sigact, NULL) < 0)
+		return -1;
+	if (sigaction(SIGSEGV, &g.sigact, NULL) < 0)
+		return -1;
+	if (sigaction(SIGBUS, &g.sigact, NULL) < 0)
+		return -1;
+
+	return 0;
+}
+
+/*
+ * Set memory management parameters: Ensure that dirty pages are written
+ * early enough! See "Documentation/filesystems/proc.txt"
+ * Return:   0 - ok
+ *         !=0 - error
+ */
+static int tune_vm(void)
+{
+	char *sysctl_names[] = {"/proc/sys/vm/dirty_ratio",
+				"/proc/sys/vm/dirty_background_ratio",
+				"/proc/sys/vm/dirty_writeback_centisecs",
+				"/proc/sys/vm/dirty_expire_centisecs",
+				"/proc/sys/vm/vfs_cache_pressure",
+				"/proc/sys/vm/lowmem_reserve_ratio",
+				NULL};
+	char *sysctl_values[] = {"2", "5", "50", "50", "500", "32", NULL};
+	int fh, i;
+
+	i = 0;
+	while (sysctl_names[i]) {
+		fh = open(sysctl_names[i], O_RDWR);
+		if (fh == -1)
+			return -1;
+		if (write(fh, sysctl_values[i], strlen(sysctl_values[i])) !=
+			  strlen(sysctl_values[i])) {
+			close(fh);
+			return -1;
+		}
+		i++;
+	}
+	close(fh);
+	return 0;
+}
+
+/*
+ * Get dump number
+ * Parameter: dumpdir - dump directory (absolute path)
+ *            mode    - DUMP_FIRST: Find first dump number in directory
+ *                    - DUMP_LAST:  Find last dump number in directory
+ * Return: >= 0 - dump number
+ *         -1   - no dump found in directory
+ *         <-1  - error
+ */
+static int get_dump_num(const char *dumpdir, int mode)
+{
+	DIR* dir = NULL;
+	struct dirent *dir_ent;
+	int dump_found, rc;
+
+	rc = 0;
+	dump_found = 0;
+	dir = opendir(dumpdir);
+	if (!dir) {
+		PRINT_PERR("Cannot evalute dump number\n");
+		return -2;
+	}
+
+	while ((dir_ent = readdir(dir))) {
+		int num;
+		if (sscanf(dir_ent->d_name, "dump.%ui", &num) == 1) {
+			/* check if we have something like dump.001 */
+			/* this is not treated as dump (leading zeros are */
+			/* not allowed) */
+			char suffix1[1024] = {};
+			char suffix2[1024] = {};
+
+			sscanf(dir_ent->d_name, "dump.%s", suffix1);
+			sprintf(suffix2, "%i", num);
+			if (strcmp(suffix1, suffix2) != 0)
+				continue;
+			if (num < 0) {
+				/* In the unlikely case of 'dump.-1',
+				   'dump.-10' etc */
+				continue;
+			}
+			if (!dump_found) {
+				dump_found = 1;
+				rc = num;
+			} else if (mode == DUMP_LAST) {
+				rc = MAX(num, rc);
+			} else if (mode == DUMP_FIRST) {
+				rc = MIN(num, rc);
+			} else {
+				PRINT_ERR("Unknown mode: %d\n", mode);
+				rc = -3;
+				goto out;
+			}
+		}
+	}
+	if (!dump_found)
+		rc = -1;
+out:
+	closedir(dir);
+
+	return rc;
+}
+
+/*
+ * Erase oldest dump in dump directory
+ * Return:    0 - ok
+ *          !=0 - error
+ */
+static int erase_oldest_dump(void)
+{
+	int dump_nr;
+	char dname[1024] = {0};
+	char answ[1024] = {0};
+
+	dump_nr = get_dump_num(g.dump_dir, DUMP_FIRST);
+	sprintf(dname, "dump.%i", dump_nr);
+	if (dump_nr < 0) {
+		PRINT_ERR("Internal error: dump number cannot be evaluated\n");
+		return -1;
+	}
+	PRINT_ERR("No space left on device!\n");
+	if (dump_nr == g.dump_nr) {
+		PRINT_ERR("Sorry, cannot delete any more dumps!\n");
+		return -1;
+	}
+	if (g.parm_mode == PARM_MODE_AUTO_NUM) {
+		PRINT("Removing oldest dump: '%s'\n", dname);
+	} else {
+		while ((strcmp(answ, "y") != 0) && (strcmp(answ, "n") != 0)) {
+			PRINT("Remove oldest dump: '%s' (y/n)? ", dname);
+			scanf("%s", answ);
+		}
+		if (strcmp(answ,"n") == 0)
+			return -1;
+	}
+	sprintf(dname, "%s/dump.%i", g.dump_dir, dump_nr);
+	if (unlink(dname) == -1) {
+		PRINT_PERR("Could not remove dump\n");
+		return -1;
+	}
+	sync();
+	/* Wait in order to give ext3 time to discover that file has been */
+	/* removed.  */
+	sleep(WAIT_TIME_ERASE);
+	PRINT("Dump removed!\n");
+	return 0;
+}
+
+/*
+ * write buffer to dump. In case of ENOSPC try to remove oldest dump
+ * Parameter: fd    - filedescriptor of dump file
+ *            buf   - buffer to write
+ *            count - nr of bytes to write
+ *
+ * Return:    size  - written bytes
+ *            <0    - error
+ */
+static ssize_t dump_write(int fd, const void *buf, size_t count)
+{
+	ssize_t written;
+
+	written = 0;
+	while (written != count) {
+		ssize_t rc;
+		rc = write(fd, buf + written, count - written);
+		if ((rc == -1) && (errno == ENOSPC)) {
+			/* Try to erase old dump */
+			if (erase_oldest_dump() != 0)
+				return -1;
+			continue;
+		} else if (rc == -1) {
+			/* Write failed somehow */
+			return -1;
+		}
+		written += rc;
+	}
+	return written;
+}
+
+#ifdef GZIP_SUPPORT
+/*
+ * Wrapper to gzip compress routine
+ * Parameter: old      - buffer to compress (in)
+ *            old_size - size of old buffer in bytes (in)
+ *            new      - buffer for compressed data (out)
+ *            new_size - size of 'new' buffer in bytes (in)
+ * Return:    >=0 - Size of compressed buffer
+ *            < 0 - error
+ */
+
+static int compress_gzip(const unsigned char *old, __u32 old_size,
+			 unsigned char *new, __u32 new_size)
+{
+	int rc;
+	unsigned long len;
+
+	len = old_size;
+	rc = compress(new, &len, old, new_size);
+	switch (rc) {
+	case Z_OK:
+		return len;
+	case Z_MEM_ERROR:
+		PRINT_ERR("Z_MEM_ERROR (not enough memory)!\n");
+		return -1;
+	case Z_BUF_ERROR:
+		/* In this case the compressed output is bigger than
+		   the uncompressed */
+		return -1;
+	case Z_DATA_ERROR:
+		PRINT_ERR("Z_DATA_ERROR (input data corrupted)!\n");
+		return -1;
+	default:
+		PRINT_ERR("Z_UNKNOWN_ERROR (rc 0x%x unknown)!\n", rc);
+		return -1;
+	}
+}
+#endif
+/*
+ * Do nothing! - No compression
+ */
+static int compress_none(const unsigned char *old, __u32 old_size,
+			 unsigned char *new, __u32 new_size)
+{
+	return -1;
+}
+
+/*
+ * Copy info from s390sa header to reg lkcd header
+ * Parameter: s390_dh - s390 dump header (in)
+ *            dh        - lkcd dump header (out)
+ */
+static void s390_to_lkcd_hdr(struct dump_hdr_s390* s390_dh,
+			     struct dump_hdr_lkcd* dh)
+{
+	struct timeval h_time;
+
+	/* adjust todclock to 1970 */
+	__u64 tod = s390_dh->tod;
+	tod -= 0x8126d60e46000000LL - (0x3c26700LL * 1000000 * 4096);
+	tod >>= 12;
+	h_time.tv_sec  = tod / 1000000;
+	h_time.tv_usec = tod % 1000000;
+
+	dh->memory_size    = s390_dh->memory_size;
+	dh->memory_start   = s390_dh->memory_start;
+	dh->memory_end     = s390_dh->memory_end;
+	dh->num_dump_pages = s390_dh->num_pages;
+	dh->page_size      = s390_dh->page_size;
+	dh->dump_level     = s390_dh->dump_level;
+
+	sprintf(dh->panic_string, "zSeries-dump (CPUID = %16llx)",
+		(unsigned long long) s390_dh->cpu_id);
+
+	if (s390_dh->arch_id == DH_ARCH_ID_S390)
+		strcpy(dh->utsname_machine,"s390");
+	else if (s390_dh->arch_id == DH_ARCH_ID_S390X)
+		strcpy(dh->utsname_machine,"s390x");
+	else
+		strcpy(dh->utsname_machine,"unknown");
+
+	dh->magic_number   = DUMP_MAGIC_NUMBER;
+	dh->version        = DUMP_VERSION_NUMBER;
+	dh->header_size    = sizeof(struct dump_hdr_lkcd);
+	dh->time.tv_sec    = h_time.tv_sec;
+	dh->time.tv_usec   = h_time.tv_usec;
+}
+
+/*
+ * Write progress information to screen
+ * Parameter: written - So many bytes have been written to the dump
+ *            max     - This is the whole memory to be written
+ */
+static void show_progress(unsigned long long written, unsigned long long max)
+{
+	int    time;
+	struct timeval t;
+	double percent;
+
+	gettimeofday(&t, NULL);
+	time = t.tv_sec;
+	if ((time < g.last_progress) && (written != max) && (written != 0))
+		return;
+	g.last_progress = time + 10;
+	percent = ((double) written / (double) max) * 100.0;
+	PRINT(" %4lli MB of %4lli MB (%5.1f%% )\n", written >> 20, max >> 20,
+		percent);
+	fflush(stdout);
+}
+
+/*
+ * create dump
+ *
+ * Return:   0  - ok
+ *         !=0  - error
+ */
+static int create_dump(char *src_dev, char *dumpdir)
+{
+	struct stat stat_buf;
+	struct dump_hdr_lkcd dh;
+	struct dump_hdr_s390 s390_dh;
+	compress_fn_t compress_fn;
+	struct dump_page dp;
+	char page_buf[DUMP_BUF_SIZE], buf[PAGE_SIZE], dpcpage[PAGE_SIZE];
+	char dump_name[1024];
+	__u64 mem_loc;
+	__u32 buf_loc = 0, dp_size, dp_flags;
+	int size, fin, fout;
+
+	if (stat(dumpdir, &stat_buf) < 0) {
+		PRINT_ERR("Specified dump dir '%s' not found!\n",dumpdir);
+		return -1;
+	} else if (!S_ISDIR(stat_buf.st_mode)) {
+		PRINT_ERR("Specified dump dir '%s' is not a directory!\n",
+			dumpdir);
+		return -1;
+	}
+
+	/* initialize progress time */
+	g.last_progress = 0;
+
+	/* get dump number */
+	g.dump_nr = get_dump_num(dumpdir, DUMP_LAST);
+	if (g.dump_nr == -1)
+		g.dump_nr = 0;
+	else
+		g.dump_nr += 1;
+
+	/* try to open the source device */
+	fin = open(src_dev, O_RDONLY, 0);
+	if (fin == -1) {
+		PRINT_ERR("open() source device '%s' failed!\n", src_dev);
+		return -1;
+	}
+
+	/* make the new filename */
+	sprintf(dump_name, "%s/dump.%d", dumpdir, g.dump_nr);
+	if ((fout = open(dump_name, DUMP_FLAGS, DUMP_MODE)) < 0) {
+		PRINT_ERR("open() of dump file \"%s\" failed!\n", dump_name);
+		goto failed_close_in;
+	}
+
+	PRINT("dump file: dump.%d\n", g.dump_nr);
+	memset(&dh, 0, sizeof(dh));
+
+	/* get the dump header */
+	if (lseek(fin, 0, SEEK_SET) < 0) {
+		PRINT_ERR("Cannot lseek() to get the dump header from the "
+			"dump file!\n");
+		goto failed_close_out;
+	}
+	if (read(fin, &s390_dh, sizeof(s390_dh)) != sizeof(s390_dh)) {
+		PRINT_ERR("Cannot read() dump header from dump file!\n");
+		goto failed_close_out;
+	}
+
+	s390_to_lkcd_hdr(&s390_dh,&dh);
+
+	if (strcmp(g.parm_compress, PARM_COMP_GZIP) == 0) {
+#ifdef GZIP_SUPPORT
+		dh.dump_compress = DUMP_COMPRESS_GZIP;
+		compress_fn = compress_gzip;
+#else
+		PRINT_WARN("Dumper has no gzip support."
+			   " Compression disabled!\n");
+		dh.dump_compress = DUMP_COMPRESS_NONE;
+		compress_fn = compress_none;
+#endif
+	} else {
+		dh.dump_compress = DUMP_COMPRESS_NONE;
+		compress_fn = compress_none;
+	}
+
+	if (g.parm_mem < dh.memory_size) {
+		/* dump_mem parameter specified: Adjust memory size */
+		dh.memory_size = g.parm_mem;
+		dh.memory_end  = g.parm_mem;
+		dh.num_dump_pages = g.parm_mem / dh.page_size;
+	}
+
+	memset(page_buf, 0, DUMP_BUF_SIZE);
+	memcpy(page_buf, &dh, sizeof(dh));
+	if (lseek(fout, 0L, SEEK_SET) < 0) {
+		PRINT_ERR("lseek() failed\n");
+		goto failed_close_out;
+	}
+	if (dump_write(fout, page_buf, DUMP_BUF_SIZE) != DUMP_BUF_SIZE) {
+		PRINT_ERR("Error: Write dump header failed\n");
+		goto failed_close_out;
+	}
+
+	/* write dump */
+
+	mem_loc = 0;
+	if (lseek(fin, DUMP_HEADER_SZ_S390SA, SEEK_SET) < 0) {
+		PRINT_ERR("lseek() failed\n");
+		goto failed_close_out;
+	}
+	while (mem_loc < dh.memory_size) {
+		if (read(fin, buf, PAGE_SIZE) != PAGE_SIZE) {
+			if (errno == EFAULT) {
+				/* probably memory hole. Skip page */
+				mem_loc += PAGE_SIZE;
+				continue;
+			}
+			PRINT_PERR("read error\n");
+			goto failed_close_out;
+		}
+		memset(dpcpage, 0, PAGE_SIZE);
+		/* get the new compressed page size */
+
+		size = compress_fn((unsigned char *)buf, PAGE_SIZE,
+			(unsigned char *)dpcpage, PAGE_SIZE);
+
+		/* if compression failed or compressed was ineffective,
+		 * we write an uncompressed page */
+		if (size < 0) {
+			dp_flags = DUMP_DH_RAW;
+			dp_size = PAGE_SIZE;
+		} else {
+			dp_flags = DUMP_DH_COMPRESSED;
+			dp_size = size;
+		}
+		dp.address = mem_loc;
+		dp.size    = dp_size;
+		dp.flags   = dp_flags;
+		memcpy(page_buf + buf_loc, &dp, sizeof(dp));
+		buf_loc += sizeof(struct dump_page);
+		/* copy the page of memory */
+		if (dp_flags & DUMP_DH_COMPRESSED)
+			/* copy the compressed page */
+			memcpy(page_buf + buf_loc, dpcpage, dp_size);
+		else
+			/* copy directly from memory */
+			memcpy(page_buf + buf_loc, buf, dp_size);
+		buf_loc += dp_size;
+		if (dump_write(fout, page_buf, buf_loc) != buf_loc) {
+			PRINT_ERR("write error\n");
+			goto failed_close_out;
+		}
+		buf_loc = 0;
+		mem_loc += PAGE_SIZE;
+		show_progress(mem_loc, dh.memory_size);
+	}
+
+	/* write end marker */
+
+	dp.address = 0x0;
+	dp.size    = DUMP_DH_END;
+	dp.flags   = 0x0;
+	dump_write(fout, &dp, sizeof(dp));
+	close(fin);
+	close(fout);
+	return 0;
+
+failed_close_out:
+	close(fout);
+failed_close_in:
+	close(fin);
+	return -1;
+}
+
+/*
+ * main routine of the zfcp_dumper
+ */
+int main(int argc, char *argv[])
+{
+	dev_t zcore_dev;
+
+#ifdef __s390x__
+	PRINT("Linux for zSeries System Dumper starting\n");
+	PRINT("Version %s (64 bit)\n", ZFCPDUMP_VERSION);
+#else
+	PRINT("Linux for zSeries System Dumper starting\n");
+	PRINT("Version %s (32 bit)\n", ZFCPDUMP_VERSION);
+#endif
+	if (init_sig()) {
+		PRINT_ERR("Init Signals failed!\n");
+		goto fail;
+	}
+	if (mount("proc", "/proc", "proc", 0, NULL)) {
+		PRINT_PERR("Unable to mount proc\n");
+		goto fail;
+	}
+	if (tune_vm()) {
+		PRINT_PERR("Unable to set VM settings\n");
+		goto fail;
+	}
+	if (mount("sysfs", "/sys", "sysfs", 0, NULL)) {
+		PRINT_PERR("Unable to mount sysfs\n");
+		goto fail;
+	}
+	if (parse_parmline()) {
+		PRINT_ERR("Could not parse parmline\n");
+		goto fail;
+	}
+	if (mknod(DEV_NULL, S_IFCHR | 0600,
+		makedev(DEV_NULL_MAJOR, DEV_NULL_MINOR))) {
+		PRINT_ERR("Could not create: %s\n", DEV_NULL);
+		goto fail;
+	}
+	if (get_zcore_dev(&zcore_dev)) {
+		PRINT_ERR("Could not get minor for zcore\n");
+		goto fail;
+	}
+	if (mknod(DEV_ZCORE, S_IFCHR | 0600, zcore_dev)) {
+		PRINT_ERR("Could not create: zcore\n");
+		goto fail;
+	}
+	if (mknod(DEV_SCSI, S_IFBLK | 0600,
+		makedev(DEV_SCSI_MAJOR, atoi(g.parm_part)))) {
+		PRINT_ERR("Could not create: scsi node\n");
+		goto fail;
+	}
+
+	if (enable_zfcp_device()) {
+		PRINT_ERR("Could not enable dump device\n");
+		goto fail;
+	}
+	PRINT(" \n"); /* leading blank is needed that sclp console prints */
+                      /* the newline */
+	PRINT("DUMP PARAMETERS:\n");
+	PRINT("================\n");
+	PRINT("devno    : %s\n", g.dump_devno);
+	PRINT("wwpn     : %s\n", g.dump_wwpn);
+	PRINT("lun      : %s\n", g.dump_lun);
+	PRINT("conf     : %s\n", g.dump_bootprog);
+	PRINT("partition: %s\n", g.parm_part);
+	PRINT("directory: %s\n", g.parm_dir);
+	PRINT("compress : %s\n", g.parm_compress);
+	PRINT(" \n");
+	PRINT("MOUNT DUMP PARTITION:\n");
+	PRINT("=====================\n");
+	if (mount_dump_device()) {
+		PRINT_ERR("Could not mount dump device\n");
+		goto fail;
+	}
+	PRINT(" \n");
+	PRINT("DUMP PROCESS STARTED:\n");
+	PRINT("=====================\n");
+	if (create_dump(DEV_ZCORE, g.dump_dir)) {
+		umount_dump_device();
+		goto fail;
+	}
+	if (umount_dump_device()) {
+		PRINT_ERR("Could not umount dump device\n");
+		goto fail;
+	}
+	PRINT(" \n");
+	PRINT("DUMP 'dump.%i' COMPLETE\n", g.dump_nr);
+	fflush(stdout);
+	terminate();
+	return 0;
+fail:
+	PRINT("DUMP 'dump.%i' FAILED\n",g.dump_nr);
+	fflush(stdout);
+	terminate();
+	return 1;
+}
+
Index: git-linux-2.6/arch/s390/zfcpdump/zfcpdump.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-linux-2.6/arch/s390/zfcpdump/zfcpdump.h	2007-02-21 13:09:06.000000000 +0100
@@ -0,0 +1,214 @@
+/*
+ * zfcp dump userspace tool
+ *
+ * Copyright IBM Corp. 2003,2007
+ * Author(s): Michael Holzheu
+ */
+
+#ifndef __zfcp_dumper_h
+#define __zfcp_dumper_h
+
+#include <stdio.h>
+#include <signal.h>
+#include <stdint.h>
+
+#define ZFCPDUMP_VERSION "1.0"
+
+#define PRINT_TRACE(x...) \
+	if (g.parm_debug >= 3) { \
+		fprintf(stderr, "TRACE: "); \
+		fprintf(stderr, ##x); \
+	}
+
+#define PRINT_ERR(x...) do { \
+	fprintf(stderr, "ERROR: "); \
+	fprintf(stderr, ##x); \
+	} while (0)
+
+#define PRINT_WARN(x...) do { \
+	fprintf(stderr, "WARNING: "); \
+	fprintf(stderr, ##x); \
+	} while (0)
+
+#define PRINT_PERR(x...) do { \
+	fprintf(stderr, "ERROR: "); \
+	fprintf(stderr, ##x); \
+	perror(""); \
+	} while (0)
+
+#define PRINT(x...) fprintf(stderr, ##x)
+
+#define CMDLINE_MAX_LEN 1024
+#define KERN_PARM_MAX 200
+
+#define DUMP_FLAGS (O_CREAT | O_RDWR | O_TRUNC)
+#define DUMP_MODE (S_IRUSR | S_IWUSR| S_IRGRP| S_IROTH)
+
+struct globals {
+	char	*parm_compress;
+	char	*parm_dir;
+	char	*parm_part;
+	int	parm_debug;
+	int	parm_mode;
+	__u64	parm_mem;
+	char	parmline[CMDLINE_MAX_LEN];
+	char	dump_dir[1024];
+	int	dump_nr;
+	int	last_progress;
+	struct	sigaction sigact;
+	char	dump_devno[16];
+	char	dump_wwpn[32];
+	char	dump_lun[32];
+	char	dump_bootprog[32];
+};
+
+#ifndef MIN
+#define MIN(x,y) ((x) < (y) ? (x) : (y))
+#endif
+#ifndef MAX
+#define MAX(x,y) ((x) > (y) ? (x) : (y))
+#endif
+
+#define PROC_CMDLINE	"/proc/cmdline"
+#define DEV_ZCORE	"/dev/zcore"
+#define DEV_SCSI	"/dev/scsidev"
+#define DEV_SCSI_MAJOR	8
+#define DEV_NULL	"/dev/null"
+#define DEV_NULL_MAJOR	1
+#define DEV_NULL_MINOR	3
+#define DUMP_DIR	"/mnt"
+
+#define PARM_DIR	"dump_dir"
+#define PARM_DIR_DFLT	"/"
+
+#define PARM_PART	"dump_part"
+#define PARM_PART_DFLT	"1"
+
+#define PARM_COMP	"dump_compress"
+#define PARM_COMP_GZIP	"gzip"
+#define PARM_COMP_NONE	"none"
+#define PARM_COMP_DFLT	PARM_COMP_NONE
+
+#define PARM_MEM	"dump_mem"
+#ifdef __s390x__
+#define PARM_MEM_DFLT	0xffffffffffffffff
+#else
+#define PARM_MEM_DFLT	0xffffffff
+#endif
+
+#define PARM_DEBUG	"dump_debug"
+#define PARM_DEBUG_DFLT	2
+#define PARM_DEBUG_MIN	1
+#define PARM_DEBUG_MAX	6
+
+#define PARM_MODE		"dump_mode"
+#define PARM_MODE_INTERACT	"interactive"
+#define PARM_MODE_INTERACT_NUM	0
+#define PARM_MODE_AUTO		"auto"
+#define PARM_MODE_AUTO_NUM	1
+#define PARM_MODE_DFLT		PARM_MODE_INTERACT
+#define PARM_MODE_NUM_DFLT	PARM_MODE_INTERACT_NUM
+
+#define DUMP_FIRST	0
+#define DUMP_LAST	1
+
+#define WAIT_TIME_ERASE	5 /* seconds */
+#define WAIT_TIME_END	3 /* seconds */
+
+#define UTS_LEN		65
+
+#define DUMP_BUF_SIZE	(64 * 1024)
+
+/* header definitions for dumps from s390 standalone dump tools */
+#define DUMP_MAGIC_S390SA	0xa8190173618f23fdULL /* s390sa magic number */
+#define DUMP_HEADER_SZ_S390SA	4096
+
+/* standard header definitions */
+#define DUMP_MAGIC_NUMBER	0xa8190173618f23edULL  /* dump magic number  */
+#define DUMP_VERSION_NUMBER	0x8      /* dump version number             */
+#define DUMP_PANIC_LEN		0x100    /* dump panic string length        */
+
+/* dump compression options -- add as necessary */
+#define DUMP_COMPRESS_NONE	0x0   /* don't compress this dump      */
+#define DUMP_COMPRESS_RLE	0x1   /* use RLE compression           */
+#define DUMP_COMPRESS_GZIP	0x2   /* use GZIP compression          */
+
+/* dump flags - any dump-type specific flags -- add as necessary */
+#define DUMP_FLAGS_NONE		0x0   /* no flags are set for this dump   */
+#define DUMP_FLAGS_NONDISRUPT	0x1   /* try to keep running after dump   */
+
+/* dump header flags -- add as necessary */
+#define DUMP_DH_RAW		0x1   /* raw page (no compression)        */
+#define DUMP_DH_COMPRESSED	0x2   /* page is compressed               */
+#define DUMP_DH_END		0x4   /* end marker on a full dump        */
+
+#define PAGE_SIZE		4096
+
+/*
+ * This is the header dumped at the top of every valid crash dump.
+ */
+struct dump_hdr_lkcd {
+	__u64 magic_number;
+	__u32 version;
+	__u32 header_size;
+	__u32 dump_level;
+	__u32 page_size;
+	__u64 memory_size;
+	__u64 memory_start;
+	__u64 memory_end;
+	__u32 num_dump_pages;
+	char panic_string[DUMP_PANIC_LEN];
+	struct {
+		__u64 tv_sec;
+		__u64 tv_usec;
+	} time;
+	char utsname_sysname[UTS_LEN];
+	char utsname_nodename[UTS_LEN];
+	char utsname_release[UTS_LEN];
+	char utsname_version[UTS_LEN];
+	char utsname_machine[UTS_LEN];
+	char utsname_domainname[UTS_LEN];
+	__u64 current_task;
+	__u32 dump_compress;
+	__u32 dump_flags;
+	__u32 dump_device;
+} __attribute__((packed));
+
+#define DH_ARCH_ID_S390X 2
+#define DH_ARCH_ID_S390  1
+
+/*
+ * This is the header used by zcore
+ */
+struct dump_hdr_s390 {
+	__u64 magic_number;
+	__u32 version;
+	__u32 header_size;
+	__u32 dump_level;
+	__u32 page_size;
+	__u64 memory_size;
+	__u64 memory_start;
+	__u64 memory_end;
+	__u32 num_pages;
+	__u32 pad;
+	__u64 tod;
+	__u64 cpu_id;
+	__u32 arch_id;
+	__u32 build_arch_id;
+} __attribute__((packed));
+
+/*
+ * Header associated to each physical page of memory saved in the system
+ * crash dump.
+ */
+struct dump_page {
+	__u64 address; /* the address of this dump page */
+	__u32 size;    /* the size of this dump page */
+	__u32 flags;   /* flags (DUMP_COMPRESSED, DUMP_RAW or DUMP_END) */
+} __attribute__((packed));
+
+/* Compression function */
+typedef int (*compress_fn_t)(const unsigned char *old, __u32 old_size,
+			     unsigned char *new, __u32 size);
+
+#endif /* __zfcp_dumper_h */

