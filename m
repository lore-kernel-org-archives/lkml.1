Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbYGDNuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbYGDNuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYGDNul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:50:41 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:55409 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753478AbYGDNug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:50:36 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jul 2008 09:50:33 EDT
Message-ID: <486E284F.3080007@misterjones.org>
Date: Fri, 04 Jul 2008 15:40:31 +0200
From: Marc Zyngier <maz@misterjones.org>
Organization: Metropolis -- Nowhere
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-arm@vger.kernel.org
CC: amit.walambe@eurotech-ltd.co.uk
Subject: [PATCH][RFC] Arcom Viper support for 2.6.26-rc8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 81.255.32.141
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-arm@vger.kernel.org, amit.walambe@eurotech-ltd.co.uk
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The enclosed patch (against Linus latest GIT) adds support for the
Arcom Viper platform (Xscale PXA255 based):
http://www.arcom.com/pc104-xscale-viper.htm

It is based on the old 2.6.16.28 from Arcom, with updates to fit 2.6.26.
It's been heavily tested for the last month or so, and I'm quite happy
with it.

Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>

---
  arch/arm/configs/viper_defconfig | 1600
++++++++++++++++++++++++++++++++++++++
  arch/arm/mach-pxa/Kconfig        |    6 +
  arch/arm/mach-pxa/Makefile       |    1 +
  arch/arm/mach-pxa/viper.c        |  777 ++++++++++++++++++
  drivers/mtd/maps/Kconfig         |   25 +
  drivers/mtd/maps/Makefile        |    1 +
  drivers/mtd/maps/viper_flash.c   |  203 +++++
  drivers/net/smc91x.h             |   19 +
  drivers/pcmcia/Kconfig           |    2 +-
  drivers/pcmcia/Makefile          |    1 +
  drivers/pcmcia/pxa2xx_base.c     |   20 +-
  drivers/pcmcia/pxa2xx_base.h     |    7 +
  drivers/pcmcia/pxa2xx_viper.c    |  154 ++++
  drivers/pcmcia/soc_common.h      |    2 +
  include/asm-arm/arch-pxa/irqs.h  |   23 +
  include/asm-arm/arch-pxa/viper.h |   73 ++
  16 files changed, 2911 insertions(+), 3 deletions(-)

diff --git a/arch/arm/configs/viper_defconfig
b/arch/arm/configs/viper_defconfig
new file mode 100644
index 0000000..d2956bf
--- /dev/null
+++ b/arch/arm/configs/viper_defconfig
@@ -0,0 +1,1600 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.26-rc8
+# Mon Jun 30 13:49:31 2008
+#
+CONFIG_ARM=y
+CONFIG_SYS_SUPPORTS_APM_EMULATION=y
+CONFIG_GENERIC_GPIO=y
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_MMU=y
+# CONFIG_NO_IOPORT is not set
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_STACKTRACE_SUPPORT=y
+CONFIG_LOCKDEP_SUPPORT=y
+CONFIG_TRACE_IRQFLAGS_SUPPORT=y
+CONFIG_HARDIRQS_SW_RESEND=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_ARCH_SUPPORTS_AOUT=y
+CONFIG_ZONE_DMA=y
+CONFIG_ARCH_MTD_XIP=y
+CONFIG_VECTORS_BASE=0xffff0000
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+
+#
+# General setup
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+# CONFIG_SWAP is not set
+CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
+# CONFIG_POSIX_MQUEUE is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_AUDIT is not set
+# CONFIG_IKCONFIG is not set
+CONFIG_LOG_BUF_SHIFT=13
+# CONFIG_CGROUPS is not set
+# CONFIG_GROUP_SCHED is not set
+CONFIG_SYSFS_DEPRECATED=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+# CONFIG_RELAY is not set
+# CONFIG_NAMESPACES is not set
+# CONFIG_BLK_DEV_INITRD is not set
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_SYSCTL=y
+CONFIG_EMBEDDED=y
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_SYSCTL_SYSCALL_CHECK=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_ALL is not set
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+# CONFIG_ELF_CORE is not set
+CONFIG_COMPAT_BRK=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
+CONFIG_EVENTFD=y
+# CONFIG_SHMEM is not set
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+# CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set
+CONFIG_HAVE_OPROFILE=y
+# CONFIG_KPROBES is not set
+CONFIG_HAVE_KPROBES=y
+CONFIG_HAVE_KRETPROBES=y
+# CONFIG_HAVE_DMA_ATTRS is not set
+CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_SLABINFO=y
+CONFIG_RT_MUTEXES=y
+CONFIG_TINY_SHMEM=y
+CONFIG_BASE_SMALL=0
+CONFIG_MODULES=y
+# CONFIG_MODULE_FORCE_LOAD is not set
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_MODULE_FORCE_UNLOAD is not set
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+CONFIG_KMOD=y
+CONFIG_BLOCK=y
+# CONFIG_LBD is not set
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+# CONFIG_IOSCHED_CFQ is not set
+# CONFIG_DEFAULT_AS is not set
+CONFIG_DEFAULT_DEADLINE=y
+# CONFIG_DEFAULT_CFQ is not set
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="deadline"
+CONFIG_CLASSIC_RCU=y
+
+#
+# System Type
+#
+# CONFIG_ARCH_AAEC2000 is not set
+# CONFIG_ARCH_INTEGRATOR is not set
+# CONFIG_ARCH_REALVIEW is not set
+# CONFIG_ARCH_VERSATILE is not set
+# CONFIG_ARCH_AT91 is not set
+# CONFIG_ARCH_CLPS7500 is not set
+# CONFIG_ARCH_CLPS711X is not set
+# CONFIG_ARCH_CO285 is not set
+# CONFIG_ARCH_EBSA110 is not set
+# CONFIG_ARCH_EP93XX is not set
+# CONFIG_ARCH_FOOTBRIDGE is not set
+# CONFIG_ARCH_NETX is not set
+# CONFIG_ARCH_H720X is not set
+# CONFIG_ARCH_IMX is not set
+# CONFIG_ARCH_IOP13XX is not set
+# CONFIG_ARCH_IOP32X is not set
+# CONFIG_ARCH_IOP33X is not set
+# CONFIG_ARCH_IXP23XX is not set
+# CONFIG_ARCH_IXP2000 is not set
+# CONFIG_ARCH_IXP4XX is not set
+# CONFIG_ARCH_L7200 is not set
+# CONFIG_ARCH_KS8695 is not set
+# CONFIG_ARCH_NS9XXX is not set
+# CONFIG_ARCH_MXC is not set
+# CONFIG_ARCH_ORION5X is not set
+# CONFIG_ARCH_PNX4008 is not set
+CONFIG_ARCH_PXA=y
+# CONFIG_ARCH_RPC is not set
+# CONFIG_ARCH_SA1100 is not set
+# CONFIG_ARCH_S3C2410 is not set
+# CONFIG_ARCH_SHARK is not set
+# CONFIG_ARCH_LH7A40X is not set
+# CONFIG_ARCH_DAVINCI is not set
+# CONFIG_ARCH_OMAP is not set
+# CONFIG_ARCH_MSM7X00A is not set
+
+#
+# Intel PXA2xx/PXA3xx Implementations
+#
+# CONFIG_ARCH_GUMSTIX is not set
+# CONFIG_ARCH_LUBBOCK is not set
+# CONFIG_MACH_LOGICPD_PXA270 is not set
+# CONFIG_MACH_MAINSTONE is not set
+# CONFIG_ARCH_PXA_IDP is not set
+# CONFIG_PXA_SHARPSL is not set
+CONFIG_ARCH_VIPER=y
+# CONFIG_ARCH_PXA_ESERIES is not set
+# CONFIG_MACH_TRIZEPS4 is not set
+# CONFIG_MACH_EM_X270 is not set
+# CONFIG_MACH_COLIBRI is not set
+# CONFIG_MACH_ZYLONITE is not set
+# CONFIG_MACH_LITTLETON is not set
+# CONFIG_MACH_ARMCORE is not set
+# CONFIG_MACH_MAGICIAN is not set
+# CONFIG_MACH_PCM027 is not set
+CONFIG_PXA25x=y
+
+#
+# Boot options
+#
+
+#
+# Power management
+#
+
+#
+# Processor Type
+#
+CONFIG_CPU_32=y
+CONFIG_CPU_XSCALE=y
+CONFIG_CPU_32v5=y
+CONFIG_CPU_ABRT_EV5T=y
+CONFIG_CPU_PABRT_NOIFAR=y
+CONFIG_CPU_CACHE_VIVT=y
+CONFIG_CPU_TLB_V4WBI=y
+CONFIG_CPU_CP15=y
+CONFIG_CPU_CP15_MMU=y
+
+#
+# Processor Features
+#
+CONFIG_ARM_THUMB=y
+# CONFIG_CPU_DCACHE_DISABLE is not set
+# CONFIG_OUTER_CACHE is not set
+CONFIG_IWMMXT=y
+CONFIG_XSCALE_PMU=y
+
+#
+# Bus support
+#
+CONFIG_ISA=y
+# CONFIG_PCI_SYSCALL is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
+CONFIG_PCCARD=m
+# CONFIG_PCMCIA_DEBUG is not set
+CONFIG_PCMCIA=m
+CONFIG_PCMCIA_LOAD_CIS=y
+CONFIG_PCMCIA_IOCTL=y
+
+#
+# PC-card bridges
+#
+# CONFIG_I82365 is not set
+# CONFIG_TCIC is not set
+CONFIG_PCMCIA_PXA2XX=m
+CONFIG_PCMCIA_PROBE=y
+
+#
+# Kernel Features
+#
+CONFIG_TICK_ONESHOT=y
+# CONFIG_NO_HZ is not set
+# CONFIG_HIGH_RES_TIMERS is not set
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+# CONFIG_PREEMPT is not set
+CONFIG_HZ=100
+CONFIG_AEABI=y
+CONFIG_OABI_COMPAT=y
+# CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
+CONFIG_PAGEFLAGS_EXTENDED=y
+CONFIG_SPLIT_PTLOCK_CPUS=4096
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
+CONFIG_BOUNCE=y
+CONFIG_VIRT_TO_BUS=y
+CONFIG_ALIGNMENT_TRAP=y
+
+#
+# Boot options
+#
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_CMDLINE="root=31:02 rootfstype=jffs2 ro console=ttyS0,115200"
+# CONFIG_XIP_KERNEL is not set
+# CONFIG_KEXEC is not set
+
+#
+# CPU Frequency scaling
+#
+CONFIG_CPU_FREQ=y
+CONFIG_CPU_FREQ_TABLE=y
+# CONFIG_CPU_FREQ_DEBUG is not set
+CONFIG_CPU_FREQ_STAT=y
+# CONFIG_CPU_FREQ_STAT_DETAILS is not set
+CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
+# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
+# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
+# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
+# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
+CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
+CONFIG_CPU_FREQ_GOV_POWERSAVE=m
+CONFIG_CPU_FREQ_GOV_USERSPACE=m
+CONFIG_CPU_FREQ_GOV_ONDEMAND=m
+CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
+CONFIG_CPU_FREQ_PXA=y
+
+#
+# Floating point emulation
+#
+
+#
+# At least one emulation must be selected
+#
+# CONFIG_FPE_NWFPE is not set
+CONFIG_FPE_FASTFPE=y
+
+#
+# Userspace binary formats
+#
+CONFIG_BINFMT_ELF=y
+# CONFIG_BINFMT_AOUT is not set
+# CONFIG_BINFMT_MISC is not set
+
+#
+# Power management options
+#
+CONFIG_PM=y
+# CONFIG_PM_DEBUG is not set
+CONFIG_PM_SLEEP=y
+CONFIG_SUSPEND=y
+CONFIG_SUSPEND_FREEZER=y
+# CONFIG_APM_EMULATION is not set
+CONFIG_ARCH_SUSPEND_POSSIBLE=y
+
+#
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
+# CONFIG_XFRM_STATISTICS is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+CONFIG_SYN_COOKIES=y
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_LRO is not set
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_IP_DCCP is not set
+# CONFIG_IP_SCTP is not set
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_CAN is not set
+# CONFIG_IRDA is not set
+CONFIG_BT=m
+CONFIG_BT_L2CAP=m
+# CONFIG_BT_SCO is not set
+CONFIG_BT_RFCOMM=m
+CONFIG_BT_RFCOMM_TTY=y
+CONFIG_BT_BNEP=m
+# CONFIG_BT_BNEP_MC_FILTER is not set
+# CONFIG_BT_BNEP_PROTO_FILTER is not set
+# CONFIG_BT_HIDP is not set
+
+#
+# Bluetooth device drivers
+#
+CONFIG_BT_HCIUSB=m
+# CONFIG_BT_HCIUSB_SCO is not set
+CONFIG_BT_HCIUART=m
+CONFIG_BT_HCIUART_H4=y
+CONFIG_BT_HCIUART_BCSP=y
+# CONFIG_BT_HCIUART_LL is not set
+# CONFIG_BT_HCIBCM203X is not set
+# CONFIG_BT_HCIBPA10X is not set
+# CONFIG_BT_HCIBFUSB is not set
+# CONFIG_BT_HCIDTL1 is not set
+# CONFIG_BT_HCIBT3C is not set
+# CONFIG_BT_HCIBLUECARD is not set
+# CONFIG_BT_HCIBTUART is not set
+# CONFIG_BT_HCIVHCI is not set
+# CONFIG_AF_RXRPC is not set
+
+#
+# Wireless
+#
+# CONFIG_CFG80211 is not set
+# CONFIG_WIRELESS_EXT is not set
+# CONFIG_MAC80211 is not set
+CONFIG_IEEE80211=m
+# CONFIG_IEEE80211_DEBUG is not set
+CONFIG_IEEE80211_CRYPT_WEP=m
+# CONFIG_IEEE80211_CRYPT_CCMP is not set
+# CONFIG_IEEE80211_CRYPT_TKIP is not set
+# CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+CONFIG_FW_LOADER=m
+# CONFIG_DEBUG_DRIVER is not set
+# CONFIG_DEBUG_DEVRES is not set
+# CONFIG_SYS_HYPERVISOR is not set
+# CONFIG_CONNECTOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_REDBOOT_PARTS=y
+CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=0
+# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
+CONFIG_MTD_REDBOOT_PARTS_READONLY=y
+# CONFIG_MTD_CMDLINE_PARTS is not set
+# CONFIG_MTD_AFS_PARTS is not set
+# CONFIG_MTD_AR7_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=y
+CONFIG_MTD_BLOCK=y
+# CONFIG_FTL is not set
+# CONFIG_NFTL is not set
+# CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+CONFIG_MTD_CFI=y
+CONFIG_MTD_JEDECPROBE=m
+CONFIG_MTD_GEN_PROBE=y
+CONFIG_MTD_CFI_ADV_OPTIONS=y
+CONFIG_MTD_CFI_NOSWAP=y
+# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
+# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
+CONFIG_MTD_CFI_GEOMETRY=y
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+# CONFIG_MTD_CFI_I2 is not set
+# CONFIG_MTD_CFI_I4 is not set
+# CONFIG_MTD_CFI_I8 is not set
+# CONFIG_MTD_OTP is not set
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_CFI_AMDSTD=m
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_CFI_UTIL=y
+CONFIG_MTD_RAM=m
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+# CONFIG_MTD_XIP is not set
+
+#
+# Mapping drivers for chip access
+#
+CONFIG_MTD_COMPLEX_MAPPINGS=y
+# CONFIG_MTD_PHYSMAP is not set
+CONFIG_MTD_PXA2XX=y
+CONFIG_MTD_VIPER=y
+# CONFIG_MTD_ARM_INTEGRATOR is not set
+# CONFIG_MTD_IMPA7 is not set
+# CONFIG_MTD_SHARP_SL is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
+# CONFIG_MTD_BLOCK2MTD is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOC2001PLUS is not set
+# CONFIG_MTD_NAND is not set
+# CONFIG_MTD_ONENAND is not set
+
+#
+# UBI - Unsorted block images
+#
+# CONFIG_MTD_UBI is not set
+# CONFIG_PARPORT is not set
+# CONFIG_PNP is not set
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_COW_COMMON is not set
+CONFIG_BLK_DEV_LOOP=m
+# CONFIG_BLK_DEV_CRYPTOLOOP is not set
+# CONFIG_BLK_DEV_NBD is not set
+# CONFIG_BLK_DEV_UB is not set
+# CONFIG_BLK_DEV_RAM is not set
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
+# CONFIG_ENCLOSURE_SERVICES is not set
+CONFIG_HAVE_IDE=y
+# CONFIG_IDE is not set
+
+#
+# SCSI device support
+#
+# CONFIG_RAID_ATTRS is not set
+CONFIG_SCSI=m
+CONFIG_SCSI_DMA=y
+# CONFIG_SCSI_TGT is not set
+# CONFIG_SCSI_NETLINK is not set
+# CONFIG_SCSI_PROC_FS is not set
+
+#
+# SCSI support type (disk, tape, CD-ROM)
+#
+CONFIG_BLK_DEV_SD=m
+# CONFIG_CHR_DEV_ST is not set
+# CONFIG_CHR_DEV_OSST is not set
+# CONFIG_BLK_DEV_SR is not set
+# CONFIG_CHR_DEV_SG is not set
+# CONFIG_CHR_DEV_SCH is not set
+
+#
+# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
+#
+# CONFIG_SCSI_MULTI_LUN is not set
+# CONFIG_SCSI_CONSTANTS is not set
+# CONFIG_SCSI_LOGGING is not set
+# CONFIG_SCSI_SCAN_ASYNC is not set
+CONFIG_SCSI_WAIT_SCAN=m
+
+#
+# SCSI Transports
+#
+# CONFIG_SCSI_SPI_ATTRS is not set
+# CONFIG_SCSI_FC_ATTRS is not set
+# CONFIG_SCSI_ISCSI_ATTRS is not set
+# CONFIG_SCSI_SAS_LIBSAS is not set
+# CONFIG_SCSI_SRP_ATTRS is not set
+CONFIG_SCSI_LOWLEVEL=y
+# CONFIG_ISCSI_TCP is not set
+# CONFIG_SCSI_AHA152X is not set
+# CONFIG_SCSI_AIC7XXX_OLD is not set
+# CONFIG_SCSI_ADVANSYS is not set
+# CONFIG_SCSI_IN2000 is not set
+# CONFIG_SCSI_DTC3280 is not set
+# CONFIG_SCSI_FUTURE_DOMAIN is not set
+# CONFIG_SCSI_GENERIC_NCR5380 is not set
+# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
+# CONFIG_SCSI_NCR53C406A is not set
+# CONFIG_SCSI_PAS16 is not set
+# CONFIG_SCSI_QLOGIC_FAS is not set
+# CONFIG_SCSI_SYM53C416 is not set
+# CONFIG_SCSI_T128 is not set
+# CONFIG_SCSI_DEBUG is not set
+# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
+CONFIG_ATA=m
+# CONFIG_ATA_NONSTANDARD is not set
+# CONFIG_SATA_PMP is not set
+CONFIG_ATA_SFF=y
+# CONFIG_SATA_MV is not set
+# CONFIG_PATA_LEGACY is not set
+CONFIG_PATA_PCMCIA=m
+# CONFIG_PATA_QDI is not set
+# CONFIG_PATA_WINBOND_VLB is not set
+# CONFIG_PATA_PLATFORM is not set
+# CONFIG_MD is not set
+CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+# CONFIG_VETH is not set
+# CONFIG_ARCNET is not set
+# CONFIG_PHYLIB is not set
+CONFIG_NET_ETHERNET=y
+CONFIG_MII=y
+# CONFIG_AX88796 is not set
+# CONFIG_NET_VENDOR_3COM is not set
+# CONFIG_NET_VENDOR_SMC is not set
+CONFIG_SMC91X=y
+# CONFIG_DM9000 is not set
+# CONFIG_SMC911X is not set
+# CONFIG_NET_VENDOR_RACAL is not set
+# CONFIG_AT1700 is not set
+# CONFIG_DEPCA is not set
+# CONFIG_HP100 is not set
+# CONFIG_NET_ISA is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_NET_PCI is not set
+# CONFIG_B44 is not set
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+# CONFIG_TR is not set
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+# CONFIG_IWLWIFI_LEDS is not set
+
+#
+# USB Network Adapters
+#
+# CONFIG_USB_CATC is not set
+# CONFIG_USB_KAWETH is not set
+CONFIG_USB_PEGASUS=m
+# CONFIG_USB_RTL8150 is not set
+CONFIG_USB_USBNET=m
+CONFIG_USB_NET_AX8817X=m
+CONFIG_USB_NET_CDCETHER=m
+# CONFIG_USB_NET_DM9601 is not set
+# CONFIG_USB_NET_GL620A is not set
+CONFIG_USB_NET_NET1080=m
+# CONFIG_USB_NET_PLUSB is not set
+# CONFIG_USB_NET_MCS7830 is not set
+# CONFIG_USB_NET_RNDIS_HOST is not set
+# CONFIG_USB_NET_CDC_SUBSET is not set
+CONFIG_USB_NET_ZAURUS=m
+CONFIG_NET_PCMCIA=y
+# CONFIG_PCMCIA_3C589 is not set
+# CONFIG_PCMCIA_3C574 is not set
+# CONFIG_PCMCIA_FMVJ18X is not set
+# CONFIG_PCMCIA_PCNET is not set
+# CONFIG_PCMCIA_NMCLAN is not set
+# CONFIG_PCMCIA_SMC91C92 is not set
+# CONFIG_PCMCIA_XIRC2PS is not set
+# CONFIG_PCMCIA_AXNET is not set
+# CONFIG_WAN is not set
+CONFIG_PPP=m
+# CONFIG_PPP_MULTILINK is not set
+# CONFIG_PPP_FILTER is not set
+CONFIG_PPP_ASYNC=m
+# CONFIG_PPP_SYNC_TTY is not set
+CONFIG_PPP_DEFLATE=m
+CONFIG_PPP_BSDCOMP=m
+# CONFIG_PPP_MPPE is not set
+# CONFIG_PPPOE is not set
+# CONFIG_PPPOL2TP is not set
+# CONFIG_SLIP is not set
+CONFIG_SLHC=m
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_ISDN is not set
+
+#
+# Input device support
+#
+CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
+# CONFIG_INPUT_POLLDEV is not set
+
+#
+# Userland interfaces
+#
+CONFIG_INPUT_MOUSEDEV=m
+# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
+CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
+CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
+# CONFIG_INPUT_JOYDEV is not set
+CONFIG_INPUT_EVDEV=m
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
+CONFIG_INPUT_TOUCHSCREEN=y
+CONFIG_TOUCHSCREEN_FUJITSU=m
+# CONFIG_TOUCHSCREEN_GUNZE is not set
+CONFIG_TOUCHSCREEN_ELO=m
+CONFIG_TOUCHSCREEN_MTOUCH=m
+# CONFIG_TOUCHSCREEN_MK712 is not set
+CONFIG_TOUCHSCREEN_PENMOUNT=m
+CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
+CONFIG_TOUCHSCREEN_TOUCHWIN=m
+# CONFIG_TOUCHSCREEN_UCB1400 is not set
+# CONFIG_TOUCHSCREEN_WM97XX is not set
+# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
+CONFIG_INPUT_MISC=y
+# CONFIG_INPUT_ATI_REMOTE is not set
+# CONFIG_INPUT_ATI_REMOTE2 is not set
+# CONFIG_INPUT_KEYSPAN_REMOTE is not set
+# CONFIG_INPUT_POWERMATE is not set
+# CONFIG_INPUT_YEALINK is not set
+CONFIG_INPUT_UINPUT=m
+
+#
+# Hardware I/O ports
+#
+CONFIG_SERIO=y
+CONFIG_SERIO_SERPORT=y
+# CONFIG_SERIO_LIBPS2 is not set
+# CONFIG_SERIO_RAW is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+CONFIG_VT=y
+# CONFIG_VT_CONSOLE is not set
+CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
+CONFIG_DEVKMEM=y
+# CONFIG_SERIAL_NONSTANDARD is not set
+
+#
+# Serial drivers
+#
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_CS=m
+CONFIG_SERIAL_8250_NR_UARTS=64
+CONFIG_SERIAL_8250_RUNTIME_UARTS=64
+CONFIG_SERIAL_8250_EXTENDED=y
+# CONFIG_SERIAL_8250_MANY_PORTS is not set
+CONFIG_SERIAL_8250_SHARE_IRQ=y
+# CONFIG_SERIAL_8250_DETECT_IRQ is not set
+# CONFIG_SERIAL_8250_RSA is not set
+
+#
+# Non-8250 serial port support
+#
+# CONFIG_SERIAL_PXA is not set
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+CONFIG_UNIX98_PTYS=y
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_IPMI_HANDLER is not set
+CONFIG_HW_RANDOM=m
+# CONFIG_NVRAM is not set
+# CONFIG_DTLK is not set
+# CONFIG_R3964 is not set
+
+#
+# PCMCIA character devices
+#
+# CONFIG_SYNCLINK_CS is not set
+# CONFIG_CARDMAN_4000 is not set
+# CONFIG_CARDMAN_4040 is not set
+# CONFIG_IPWIRELESS is not set
+# CONFIG_RAW_DRIVER is not set
+# CONFIG_TCG_TPM is not set
+CONFIG_DEVPORT=y
+CONFIG_I2C=y
+CONFIG_I2C_BOARDINFO=y
+CONFIG_I2C_CHARDEV=y
+CONFIG_I2C_ALGOBIT=y
+
+#
+# I2C Hardware Bus support
+#
+# CONFIG_I2C_ELEKTOR is not set
+CONFIG_I2C_GPIO=y
+CONFIG_I2C_PXA=y
+# CONFIG_I2C_PXA_SLAVE is not set
+# CONFIG_I2C_OCORES is not set
+# CONFIG_I2C_PARPORT_LIGHT is not set
+# CONFIG_I2C_SIMTEC is not set
+# CONFIG_I2C_TAOS_EVM is not set
+# CONFIG_I2C_STUB is not set
+# CONFIG_I2C_TINY_USB is not set
+# CONFIG_I2C_PCA_ISA is not set
+# CONFIG_I2C_PCA_PLATFORM is not set
+
+#
+# Miscellaneous I2C Chip support
+#
+# CONFIG_DS1682 is not set
+# CONFIG_SENSORS_EEPROM is not set
+# CONFIG_SENSORS_PCF8574 is not set
+# CONFIG_PCF8575 is not set
+# CONFIG_SENSORS_PCF8591 is not set
+# CONFIG_TPS65010 is not set
+# CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_SENSORS_TSL2550 is not set
+# CONFIG_I2C_DEBUG_CORE is not set
+# CONFIG_I2C_DEBUG_ALGO is not set
+# CONFIG_I2C_DEBUG_BUS is not set
+# CONFIG_I2C_DEBUG_CHIP is not set
+# CONFIG_SPI is not set
+CONFIG_HAVE_GPIO_LIB=y
+
+#
+# GPIO Support
+#
+# CONFIG_DEBUG_GPIO is not set
+
+#
+# I2C GPIO expanders:
+#
+# CONFIG_GPIO_PCA953X is not set
+# CONFIG_GPIO_PCF857X is not set
+
+#
+# SPI GPIO expanders:
+#
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_AD7418 is not set
+# CONFIG_SENSORS_ADM1021 is not set
+# CONFIG_SENSORS_ADM1025 is not set
+# CONFIG_SENSORS_ADM1026 is not set
+# CONFIG_SENSORS_ADM1029 is not set
+# CONFIG_SENSORS_ADM1031 is not set
+# CONFIG_SENSORS_ADM9240 is not set
+# CONFIG_SENSORS_ADT7470 is not set
+# CONFIG_SENSORS_ADT7473 is not set
+# CONFIG_SENSORS_ATXP1 is not set
+# CONFIG_SENSORS_DS1621 is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_F75375S is not set
+# CONFIG_SENSORS_GL518SM is not set
+# CONFIG_SENSORS_GL520SM is not set
+# CONFIG_SENSORS_IT87 is not set
+# CONFIG_SENSORS_LM63 is not set
+# CONFIG_SENSORS_LM75 is not set
+# CONFIG_SENSORS_LM77 is not set
+# CONFIG_SENSORS_LM78 is not set
+# CONFIG_SENSORS_LM80 is not set
+# CONFIG_SENSORS_LM83 is not set
+# CONFIG_SENSORS_LM85 is not set
+# CONFIG_SENSORS_LM87 is not set
+# CONFIG_SENSORS_LM90 is not set
+# CONFIG_SENSORS_LM92 is not set
+# CONFIG_SENSORS_LM93 is not set
+# CONFIG_SENSORS_MAX1619 is not set
+# CONFIG_SENSORS_MAX6650 is not set
+# CONFIG_SENSORS_PC87360 is not set
+# CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_DME1737 is not set
+# CONFIG_SENSORS_SMSC47M1 is not set
+# CONFIG_SENSORS_SMSC47M192 is not set
+# CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_ADS7828 is not set
+# CONFIG_SENSORS_THMC50 is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_SENSORS_W83781D is not set
+# CONFIG_SENSORS_W83791D is not set
+# CONFIG_SENSORS_W83792D is not set
+# CONFIG_SENSORS_W83793 is not set
+# CONFIG_SENSORS_W83L785TS is not set
+# CONFIG_SENSORS_W83L786NG is not set
+# CONFIG_SENSORS_W83627HF is not set
+# CONFIG_SENSORS_W83627EHF is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_SA1100_WATCHDOG=m
+
+#
+# ISA-based Watchdog Cards
+#
+# CONFIG_PCWATCHDOG is not set
+# CONFIG_MIXCOMWD is not set
+# CONFIG_WDT is not set
+
+#
+# USB-based Watchdog Cards
+#
+# CONFIG_USBPCWATCHDOG is not set
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+# CONFIG_MFD_ASIC3 is not set
+# CONFIG_HTC_EGPIO is not set
+# CONFIG_HTC_PASIC3 is not set
+
+#
+# Multimedia devices
+#
+
+#
+# Multimedia core support
+#
+# CONFIG_VIDEO_DEV is not set
+# CONFIG_DVB_CORE is not set
+# CONFIG_VIDEO_MEDIA is not set
+
+#
+# Multimedia drivers
+#
+# CONFIG_DAB is not set
+
+#
+# Graphics support
+#
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+CONFIG_FB=y
+# CONFIG_FIRMWARE_EDID is not set
+# CONFIG_FB_DDC is not set
+CONFIG_FB_CFB_FILLRECT=m
+CONFIG_FB_CFB_COPYAREA=m
+CONFIG_FB_CFB_IMAGEBLIT=m
+# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
+# CONFIG_FB_SYS_FILLRECT is not set
+# CONFIG_FB_SYS_COPYAREA is not set
+# CONFIG_FB_SYS_IMAGEBLIT is not set
+# CONFIG_FB_FOREIGN_ENDIAN is not set
+# CONFIG_FB_SYS_FOPS is not set
+# CONFIG_FB_SVGALIB is not set
+# CONFIG_FB_MACMODES is not set
+# CONFIG_FB_BACKLIGHT is not set
+# CONFIG_FB_MODE_HELPERS is not set
+# CONFIG_FB_TILEBLITTING is not set
+
+#
+# Frame buffer hardware drivers
+#
+# CONFIG_FB_S1D13XXX is not set
+CONFIG_FB_PXA=m
+CONFIG_FB_PXA_SMARTPANEL=y
+CONFIG_FB_PXA_PARAMETERS=y
+# CONFIG_FB_MBX is not set
+# CONFIG_FB_AM200EPD is not set
+# CONFIG_FB_VIRTUAL is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+
+#
+# Console display driver support
+#
+# CONFIG_VGA_CONSOLE is not set
+# CONFIG_MDA_CONSOLE is not set
+CONFIG_DUMMY_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE=m
+# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
+# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
+# CONFIG_FONTS is not set
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+CONFIG_LOGO=y
+CONFIG_LOGO_LINUX_MONO=y
+CONFIG_LOGO_LINUX_VGA16=y
+CONFIG_LOGO_LINUX_CLUT224=y
+
+#
+# Sound
+#
+CONFIG_SOUND=m
+
+#
+# Advanced Linux Sound Architecture
+#
+CONFIG_SND=m
+CONFIG_SND_TIMER=m
+CONFIG_SND_PCM=m
+# CONFIG_SND_SEQUENCER is not set
+CONFIG_SND_OSSEMUL=y
+CONFIG_SND_MIXER_OSS=m
+CONFIG_SND_PCM_OSS=m
+CONFIG_SND_PCM_OSS_PLUGINS=y
+# CONFIG_SND_DYNAMIC_MINORS is not set
+CONFIG_SND_SUPPORT_OLD_API=y
+CONFIG_SND_VERBOSE_PROCFS=y
+# CONFIG_SND_VERBOSE_PRINTK is not set
+# CONFIG_SND_DEBUG is not set
+
+#
+# Generic devices
+#
+CONFIG_SND_AC97_CODEC=m
+# CONFIG_SND_DUMMY is not set
+# CONFIG_SND_MTPAV is not set
+# CONFIG_SND_SERIAL_U16550 is not set
+# CONFIG_SND_MPU401 is not set
+
+#
+# ALSA ARM devices
+#
+CONFIG_SND_PXA2XX_PCM=m
+CONFIG_SND_PXA2XX_AC97=m
+
+#
+# USB devices
+#
+# CONFIG_SND_USB_AUDIO is not set
+# CONFIG_SND_USB_CAIAQ is not set
+
+#
+# PCMCIA devices
+#
+# CONFIG_SND_VXPOCKET is not set
+# CONFIG_SND_PDAUDIOCF is not set
+
+#
+# System on Chip audio support
+#
+# CONFIG_SND_SOC is not set
+
+#
+# ALSA SoC audio for Freescale SOCs
+#
+
+#
+# SoC Audio for the Texas Instruments OMAP
+#
+
+#
+# Open Sound System
+#
+# CONFIG_SOUND_PRIME is not set
+CONFIG_AC97_BUS=m
+CONFIG_HID_SUPPORT=y
+CONFIG_HID=y
+# CONFIG_HID_DEBUG is not set
+# CONFIG_HIDRAW is not set
+
+#
+# USB Input Devices
+#
+CONFIG_USB_HID=m
+# CONFIG_USB_HIDINPUT_POWERBOOK is not set
+# CONFIG_HID_FF is not set
+# CONFIG_USB_HIDDEV is not set
+
+#
+# USB HID Boot Protocol drivers
+#
+# CONFIG_USB_KBD is not set
+# CONFIG_USB_MOUSE is not set
+CONFIG_USB_SUPPORT=y
+CONFIG_USB_ARCH_HAS_HCD=y
+# CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+CONFIG_USB=m
+# CONFIG_USB_DEBUG is not set
+# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
+
+#
+# Miscellaneous USB options
+#
+CONFIG_USB_DEVICEFS=y
+CONFIG_USB_DEVICE_CLASS=y
+# CONFIG_USB_DYNAMIC_MINORS is not set
+# CONFIG_USB_SUSPEND is not set
+# CONFIG_USB_OTG is not set
+# CONFIG_USB_OTG_WHITELIST is not set
+# CONFIG_USB_OTG_BLACKLIST_HUB is not set
+
+#
+# USB Host Controller Drivers
+#
+# CONFIG_USB_C67X00_HCD is not set
+CONFIG_USB_ISP116X_HCD=m
+# CONFIG_USB_ISP1760_HCD is not set
+# CONFIG_USB_SL811_HCD is not set
+# CONFIG_USB_R8A66597_HCD is not set
+
+#
+# USB Device Class drivers
+#
+CONFIG_USB_ACM=m
+# CONFIG_USB_PRINTER is not set
+# CONFIG_USB_WDM is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
+
+#
+# may also be needed; see USB_STORAGE Help for more information
+#
+CONFIG_USB_STORAGE=m
+# CONFIG_USB_STORAGE_DEBUG is not set
+# CONFIG_USB_STORAGE_DATAFAB is not set
+# CONFIG_USB_STORAGE_FREECOM is not set
+# CONFIG_USB_STORAGE_ISD200 is not set
+# CONFIG_USB_STORAGE_DPCM is not set
+# CONFIG_USB_STORAGE_USBAT is not set
+# CONFIG_USB_STORAGE_SDDR09 is not set
+# CONFIG_USB_STORAGE_SDDR55 is not set
+# CONFIG_USB_STORAGE_JUMPSHOT is not set
+# CONFIG_USB_STORAGE_ALAUDA is not set
+# CONFIG_USB_STORAGE_ONETOUCH is not set
+# CONFIG_USB_STORAGE_KARMA is not set
+# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
+# CONFIG_USB_LIBUSUAL is not set
+
+#
+# USB Imaging devices
+#
+# CONFIG_USB_MDC800 is not set
+# CONFIG_USB_MICROTEK is not set
+CONFIG_USB_MON=y
+
+#
+# USB port drivers
+#
+CONFIG_USB_SERIAL=m
+# CONFIG_USB_EZUSB is not set
+CONFIG_USB_SERIAL_GENERIC=y
+# CONFIG_USB_SERIAL_AIRCABLE is not set
+# CONFIG_USB_SERIAL_AIRPRIME is not set
+# CONFIG_USB_SERIAL_ARK3116 is not set
+# CONFIG_USB_SERIAL_BELKIN is not set
+# CONFIG_USB_SERIAL_CH341 is not set
+# CONFIG_USB_SERIAL_WHITEHEAT is not set
+# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
+# CONFIG_USB_SERIAL_CP2101 is not set
+# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
+# CONFIG_USB_SERIAL_EMPEG is not set
+# CONFIG_USB_SERIAL_FTDI_SIO is not set
+# CONFIG_USB_SERIAL_FUNSOFT is not set
+# CONFIG_USB_SERIAL_VISOR is not set
+# CONFIG_USB_SERIAL_IPAQ is not set
+# CONFIG_USB_SERIAL_IR is not set
+# CONFIG_USB_SERIAL_EDGEPORT is not set
+# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
+# CONFIG_USB_SERIAL_GARMIN is not set
+# CONFIG_USB_SERIAL_IPW is not set
+# CONFIG_USB_SERIAL_IUU is not set
+# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
+# CONFIG_USB_SERIAL_KEYSPAN is not set
+# CONFIG_USB_SERIAL_KLSI is not set
+# CONFIG_USB_SERIAL_KOBIL_SCT is not set
+CONFIG_USB_SERIAL_MCT_U232=m
+# CONFIG_USB_SERIAL_MOS7720 is not set
+# CONFIG_USB_SERIAL_MOS7840 is not set
+# CONFIG_USB_SERIAL_MOTOROLA is not set
+# CONFIG_USB_SERIAL_NAVMAN is not set
+# CONFIG_USB_SERIAL_PL2303 is not set
+# CONFIG_USB_SERIAL_OTI6858 is not set
+# CONFIG_USB_SERIAL_SPCP8X5 is not set
+# CONFIG_USB_SERIAL_HP4X is not set
+# CONFIG_USB_SERIAL_SAFE is not set
+# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
+# CONFIG_USB_SERIAL_TI is not set
+# CONFIG_USB_SERIAL_CYBERJACK is not set
+# CONFIG_USB_SERIAL_XIRCOM is not set
+# CONFIG_USB_SERIAL_OPTION is not set
+# CONFIG_USB_SERIAL_OMNINET is not set
+# CONFIG_USB_SERIAL_DEBUG is not set
+
+#
+# USB Miscellaneous drivers
+#
+# CONFIG_USB_EMI62 is not set
+# CONFIG_USB_EMI26 is not set
+# CONFIG_USB_ADUTUX is not set
+# CONFIG_USB_AUERSWALD is not set
+# CONFIG_USB_RIO500 is not set
+# CONFIG_USB_LEGOTOWER is not set
+# CONFIG_USB_LCD is not set
+# CONFIG_USB_BERRY_CHARGE is not set
+# CONFIG_USB_LED is not set
+# CONFIG_USB_CYPRESS_CY7C63 is not set
+# CONFIG_USB_CYTHERM is not set
+# CONFIG_USB_PHIDGET is not set
+# CONFIG_USB_IDMOUSE is not set
+# CONFIG_USB_FTDI_ELAN is not set
+# CONFIG_USB_APPLEDISPLAY is not set
+# CONFIG_USB_LD is not set
+# CONFIG_USB_TRANCEVIBRATOR is not set
+# CONFIG_USB_IOWARRIOR is not set
+# CONFIG_USB_TEST is not set
+# CONFIG_USB_ISIGHTFW is not set
+# CONFIG_USB_GADGET is not set
+# CONFIG_MMC is not set
+# CONFIG_NEW_LEDS is not set
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=m
+
+#
+# RTC interfaces
+#
+CONFIG_RTC_INTF_SYSFS=y
+CONFIG_RTC_INTF_PROC=y
+CONFIG_RTC_INTF_DEV=y
+# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
+# CONFIG_RTC_DRV_TEST is not set
+
+#
+# I2C RTC drivers
+#
+CONFIG_RTC_DRV_DS1307=m
+CONFIG_RTC_DRV_DS1374=m
+CONFIG_RTC_DRV_DS1672=m
+CONFIG_RTC_DRV_MAX6900=m
+CONFIG_RTC_DRV_RS5C372=m
+CONFIG_RTC_DRV_ISL1208=m
+CONFIG_RTC_DRV_X1205=m
+CONFIG_RTC_DRV_PCF8563=m
+CONFIG_RTC_DRV_PCF8583=m
+CONFIG_RTC_DRV_M41T80=m
+# CONFIG_RTC_DRV_M41T80_WDT is not set
+CONFIG_RTC_DRV_S35390A=m
+CONFIG_RTC_DRV_FM3130=m
+
+#
+# SPI RTC drivers
+#
+
+#
+# Platform RTC drivers
+#
+# CONFIG_RTC_DRV_CMOS is not set
+# CONFIG_RTC_DRV_DS1511 is not set
+# CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
+# CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
+# CONFIG_RTC_DRV_V3020 is not set
+
+#
+# on-CPU RTC drivers
+#
+CONFIG_RTC_DRV_SA1100=m
+# CONFIG_UIO is not set
+
+#
+# File systems
+#
+CONFIG_EXT2_FS=m
+# CONFIG_EXT2_FS_XATTR is not set
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=m
+# CONFIG_EXT3_FS_XATTR is not set
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_JBD=m
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_FS_POSIX_ACL is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_DNOTIFY is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
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
+CONFIG_FAT_FS=m
+# CONFIG_MSDOS_FS is not set
+CONFIG_VFAT_FS=m
+CONFIG_FAT_DEFAULT_CODEPAGE=437
+CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
+# CONFIG_HUGETLB_PAGE is not set
+# CONFIG_CONFIGFS_FS is not set
+
+#
+# Miscellaneous filesystems
+#
+# CONFIG_ADFS_FS is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_BEFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_EFS_FS is not set
+CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_FS_DEBUG=0
+CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
+# CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
+# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
+CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
+CONFIG_JFFS2_RTIME=y
+# CONFIG_JFFS2_RUBIN is not set
+# CONFIG_CRAMFS is not set
+# CONFIG_VXFS_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_ROMFS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+CONFIG_NFSD=m
+CONFIG_NFSD_V3=y
+# CONFIG_NFSD_V3_ACL is not set
+# CONFIG_NFSD_V4 is not set
+CONFIG_ROOT_NFS=y
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_EXPORTFS=m
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_BIND34 is not set
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+# CONFIG_SMB_FS is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+
+#
+# Partition Types
+#
+CONFIG_PARTITION_ADVANCED=y
+# CONFIG_ACORN_PARTITION is not set
+# CONFIG_OSF_PARTITION is not set
+# CONFIG_AMIGA_PARTITION is not set
+# CONFIG_ATARI_PARTITION is not set
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
+# CONFIG_SYSV68_PARTITION is not set
+CONFIG_NLS=m
+CONFIG_NLS_DEFAULT="iso8859-1"
+CONFIG_NLS_CODEPAGE_437=m
+# CONFIG_NLS_CODEPAGE_737 is not set
+# CONFIG_NLS_CODEPAGE_775 is not set
+CONFIG_NLS_CODEPAGE_850=m
+# CONFIG_NLS_CODEPAGE_852 is not set
+# CONFIG_NLS_CODEPAGE_855 is not set
+# CONFIG_NLS_CODEPAGE_857 is not set
+# CONFIG_NLS_CODEPAGE_860 is not set
+# CONFIG_NLS_CODEPAGE_861 is not set
+# CONFIG_NLS_CODEPAGE_862 is not set
+# CONFIG_NLS_CODEPAGE_863 is not set
+# CONFIG_NLS_CODEPAGE_864 is not set
+# CONFIG_NLS_CODEPAGE_865 is not set
+# CONFIG_NLS_CODEPAGE_866 is not set
+# CONFIG_NLS_CODEPAGE_869 is not set
+# CONFIG_NLS_CODEPAGE_936 is not set
+# CONFIG_NLS_CODEPAGE_950 is not set
+# CONFIG_NLS_CODEPAGE_932 is not set
+# CONFIG_NLS_CODEPAGE_949 is not set
+# CONFIG_NLS_CODEPAGE_874 is not set
+# CONFIG_NLS_ISO8859_8 is not set
+# CONFIG_NLS_CODEPAGE_1250 is not set
+# CONFIG_NLS_CODEPAGE_1251 is not set
+# CONFIG_NLS_ASCII is not set
+CONFIG_NLS_ISO8859_1=m
+# CONFIG_NLS_ISO8859_2 is not set
+# CONFIG_NLS_ISO8859_3 is not set
+# CONFIG_NLS_ISO8859_4 is not set
+# CONFIG_NLS_ISO8859_5 is not set
+# CONFIG_NLS_ISO8859_6 is not set
+# CONFIG_NLS_ISO8859_7 is not set
+# CONFIG_NLS_ISO8859_9 is not set
+# CONFIG_NLS_ISO8859_13 is not set
+# CONFIG_NLS_ISO8859_14 is not set
+CONFIG_NLS_ISO8859_15=m
+# CONFIG_NLS_KOI8_R is not set
+# CONFIG_NLS_KOI8_U is not set
+CONFIG_NLS_UTF8=m
+# CONFIG_DLM is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+CONFIG_FRAME_WARN=1024
+CONFIG_MAGIC_SYSRQ=y
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
+CONFIG_DEBUG_KERNEL=y
+# CONFIG_DEBUG_SHIRQ is not set
+CONFIG_DETECT_SOFTLOCKUP=y
+CONFIG_SCHED_DEBUG=y
+# CONFIG_SCHEDSTATS is not set
+# CONFIG_TIMER_STATS is not set
+# CONFIG_DEBUG_OBJECTS is not set
+# CONFIG_DEBUG_SLAB is not set
+# CONFIG_DEBUG_RT_MUTEXES is not set
+# CONFIG_RT_MUTEX_TESTER is not set
+# CONFIG_DEBUG_SPINLOCK is not set
+CONFIG_DEBUG_MUTEXES=y
+# CONFIG_DEBUG_LOCK_ALLOC is not set
+# CONFIG_PROVE_LOCKING is not set
+# CONFIG_LOCK_STAT is not set
+# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
+# CONFIG_DEBUG_KOBJECT is not set
+CONFIG_DEBUG_BUGVERBOSE=y
+# CONFIG_DEBUG_INFO is not set
+# CONFIG_DEBUG_VM is not set
+# CONFIG_DEBUG_WRITECOUNT is not set
+# CONFIG_DEBUG_LIST is not set
+# CONFIG_DEBUG_SG is not set
+CONFIG_FRAME_POINTER=y
+# CONFIG_BOOT_PRINTK_DELAY is not set
+# CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_BACKTRACE_SELF_TEST is not set
+# CONFIG_FAULT_INJECTION is not set
+# CONFIG_SAMPLES is not set
+# CONFIG_DEBUG_USER is not set
+CONFIG_DEBUG_ERRORS=y
+# CONFIG_DEBUG_STACK_USAGE is not set
+# CONFIG_DEBUG_LL is not set
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY is not set
+# CONFIG_SECURITY_FILE_CAPABILITIES is not set
+CONFIG_CRYPTO=y
+
+#
+# Crypto core or helper
+#
+CONFIG_CRYPTO_ALGAPI=m
+CONFIG_CRYPTO_BLKCIPHER=m
+CONFIG_CRYPTO_MANAGER=m
+# CONFIG_CRYPTO_GF128MUL is not set
+# CONFIG_CRYPTO_NULL is not set
+# CONFIG_CRYPTO_CRYPTD is not set
+# CONFIG_CRYPTO_AUTHENC is not set
+# CONFIG_CRYPTO_TEST is not set
+
+#
+# Authenticated Encryption with Associated Data
+#
+# CONFIG_CRYPTO_CCM is not set
+# CONFIG_CRYPTO_GCM is not set
+# CONFIG_CRYPTO_SEQIV is not set
+
+#
+# Block modes
+#
+# CONFIG_CRYPTO_CBC is not set
+# CONFIG_CRYPTO_CTR is not set
+# CONFIG_CRYPTO_CTS is not set
+CONFIG_CRYPTO_ECB=m
+# CONFIG_CRYPTO_LRW is not set
+# CONFIG_CRYPTO_PCBC is not set
+# CONFIG_CRYPTO_XTS is not set
+
+#
+# Hash modes
+#
+# CONFIG_CRYPTO_HMAC is not set
+# CONFIG_CRYPTO_XCBC is not set
+
+#
+# Digest
+#
+# CONFIG_CRYPTO_CRC32C is not set
+# CONFIG_CRYPTO_MD4 is not set
+# CONFIG_CRYPTO_MD5 is not set
+# CONFIG_CRYPTO_MICHAEL_MIC is not set
+# CONFIG_CRYPTO_SHA1 is not set
+# CONFIG_CRYPTO_SHA256 is not set
+# CONFIG_CRYPTO_SHA512 is not set
+# CONFIG_CRYPTO_TGR192 is not set
+# CONFIG_CRYPTO_WP512 is not set
+
+#
+# Ciphers
+#
+# CONFIG_CRYPTO_AES is not set
+# CONFIG_CRYPTO_ANUBIS is not set
+CONFIG_CRYPTO_ARC4=m
+# CONFIG_CRYPTO_BLOWFISH is not set
+# CONFIG_CRYPTO_CAMELLIA is not set
+# CONFIG_CRYPTO_CAST5 is not set
+# CONFIG_CRYPTO_CAST6 is not set
+# CONFIG_CRYPTO_DES is not set
+# CONFIG_CRYPTO_FCRYPT is not set
+# CONFIG_CRYPTO_KHAZAD is not set
+# CONFIG_CRYPTO_SALSA20 is not set
+# CONFIG_CRYPTO_SEED is not set
+# CONFIG_CRYPTO_SERPENT is not set
+# CONFIG_CRYPTO_TEA is not set
+# CONFIG_CRYPTO_TWOFISH is not set
+
+#
+# Compression
+#
+# CONFIG_CRYPTO_DEFLATE is not set
+# CONFIG_CRYPTO_LZO is not set
+CONFIG_CRYPTO_HW=y
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+# CONFIG_GENERIC_FIND_FIRST_BIT is not set
+# CONFIG_GENERIC_FIND_NEXT_BIT is not set
+CONFIG_CRC_CCITT=m
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 5da7a68..ecb2b4f 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -57,6 +57,12 @@ config PXA_SHARPSL
  	  SL-C3000 (Spitz), SL-C3100 (Borzoi) or SL-C6000x (Tosa)
  	  handheld computer.

+config ARCH_VIPER
+	bool "Arcom VIPER SBC"
+	select PXA25x
+	select ISA
+	select I2C_GPIO
+
  config ARCH_PXA_ESERIES
  	bool "PXA based Toshiba e-series PDAs"
  	select PXA25x
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 0e6d05b..76bfa4a 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_MACH_TOSA)		+= tosa.o
  obj-$(CONFIG_MACH_EM_X270)	+= em-x270.o
  obj-$(CONFIG_MACH_MAGICIAN)	+= magician.o
  obj-$(CONFIG_ARCH_PXA_ESERIES)	+= eseries.o
+obj-$(CONFIG_ARCH_VIPER)	+= viper.o

  ifeq ($(CONFIG_MACH_ZYLONITE),y)
    obj-y				+= zylonite.o
diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
new file mode 100644
index 0000000..5b8363f
--- /dev/null
+++ b/arch/arm/mach-pxa/viper.c
@@ -0,0 +1,777 @@
+/*
+ *  linux/arch/arm/mach-pxa/viper.c
+ *
+ *  Support for the Arcom VIPER SBC.
+ *
+ *  Author:	Ian Campbell
+ *  Creayed:    Feb 03, 2003
+ *  Copyright:  Arcom Control Systems
+ *
+ * Based on lubbock.c:
+ *  Author:	Nicolas Pitre
+ *  Created:	Jun 15, 2001
+ *  Copyright:	MontaVista Software Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/memory.h>
+#include <linux/cpu.h>
+#include <linux/cpufreq.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/major.h>
+#include <linux/module.h>
+#include <linux/pm.h>
+#include <linux/sched.h>
+#include <linux/i2c-gpio.h>
+#include <linux/serial_8250.h>
+#include <linux/usb/isp116x.h>
+
+#include <asm/arch/pxa-regs.h>
+#include <asm/arch/bitfield.h>
+#include <asm/arch/audio.h>
+#include <asm/arch/pxafb.h>
+#include <asm/arch/pxa2xx-gpio.h>
+#include <asm/arch/viper.h>
+
+#include <asm/setup.h>
+#include <asm/mach-types.h>
+#include <asm/hardware.h>
+#include <asm/irq.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+
+#include "generic.h"
+
+#if 0
+#define DEBUG_INTR(fmt...)	printk(fmt)
+#else
+#define DEBUG_INTR(fmt...)	do { } while (0)
+#endif
+
+#define VIPER_ICR __VIPER_CPLD_REG(_VIPER_ICR_PHYS)
+static unsigned int icr;
+void viper_icr_set_bit(unsigned int bit)
+{
+	icr |= bit;
+	VIPER_ICR = icr;
+}
+EXPORT_SYMBOL(viper_icr_set_bit);
+
+void viper_icr_clear_bit(unsigned int bit)
+{
+	icr &= ~bit;
+	VIPER_ICR = icr;
+}
+EXPORT_SYMBOL(viper_icr_clear_bit);
+
+/* The CPLD version register was not present on VIPER boards prior to
+ * v2i1. On v1 boards where the version register is not present we
+ * will just read back the previous value from the databus.
+ *
+ * Therefore we do two reads. The first time we write 0 to the
+ * (read-only) register before reading and the second time we write
+ * 0xff first. If the two reads do not match or they read back as 0xff
+ * or 0x00 then we have version 1 hardware.
+ */
+#define VIPER_VERSION	__VIPER_CPLD_REG(_VIPER_VERSION_PHYS)
+u8 viper_hw_version(void)
+{
+	u8 v1, v2;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	VIPER_VERSION = 0;
+	v1 = VIPER_VERSION;
+	VIPER_VERSION = 0xff;
+	v2 = VIPER_VERSION;
+
+	if (v1 != v2) { /* a v1i6 board */
+		v1 = 0;
+	} else if (v1 /* ==v2 */ == 0xff) { /* a v1i6 board */
+		v1 = 0;
+	}
+
+	local_irq_restore(flags);
+	return v1;
+}
+EXPORT_SYMBOL(viper_hw_version);
+
+/* CPU sysdev */
+static int viper_cpu_suspend(struct sys_device *sysdev, pm_message_t state)
+{
+	viper_icr_set_bit(VIPER_ICR_R_DIS);
+	return 0;
+}
+
+static int viper_cpu_resume(struct sys_device *sysdev)
+{
+	viper_icr_clear_bit(VIPER_ICR_R_DIS);
+	return 0;
+}
+
+static struct sysdev_driver viper_cpu_sysdev_driver = {
+	.suspend	= viper_cpu_suspend,
+	.resume		= viper_cpu_resume,
+};
+
+/* Interrupt handling */
+static unsigned long viper_irq_enabled_mask;
+
+static void viper_ack_irq(unsigned int irq)
+{
+	int viper_irq = (irq - VIPER_IRQ(0));
+
+	if (viper_irq < 8) {
+		DEBUG_INTR(KERN_DEBUG "viper_ack_irq: acknowledge lo irq %d "
+			   "(number %d) with 0x%x => %p\n",
+			   irq, viper_irq, 1 << viper_irq,
+			   &VIPER_LO_IRQ_STATUS);
+		VIPER_LO_IRQ_STATUS = 1 << viper_irq;
+	} else {
+		DEBUG_INTR(KERN_DEBUG "viper_ack_irq: acknowledge hi irq %d "
+			   "(number %d) with 0x%x => %p\n",
+			   irq, viper_irq, 1 << (viper_irq - 8),
+			   &VIPER_HI_IRQ_STATUS);
+		VIPER_HI_IRQ_STATUS = 1 << (viper_irq-8);
+	}
+}
+
+static void viper_mask_irq(unsigned int irq)
+{
+	int viper_irq = (irq - VIPER_IRQ(0));
+	viper_irq_enabled_mask &= ~(1 << viper_irq);
+}
+
+static void viper_unmask_irq(unsigned int irq)
+{
+	int viper_irq = (irq - VIPER_IRQ(0));
+	viper_irq_enabled_mask |= (1 << viper_irq);
+}
+
+static inline unsigned long viper_irq_pending(void)
+{
+	u8 hi, lo;
+	unsigned long result;
+
+	hi = VIPER_HI_IRQ_STATUS;
+	lo = VIPER_LO_IRQ_STATUS;
+	result = lo;
+	result |= hi<<8;
+	result &= viper_irq_enabled_mask;
+	return result;
+}
+
+static void viper_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned long pending;
+
+	DEBUG_INTR(KERN_DEBUG "viper_irq_handler: entry\n");
+
+	pending = viper_irq_pending();
+	do {
+		DEBUG_INTR(KERN_DEBUG "viper_irq_handler: pending 0x%lx\n",
+			   pending);
+		GEDR(IRQ_TO_GPIO(VIPER_CPLD_IRQ)) =
GPIO_bit(IRQ_TO_GPIO(VIPER_CPLD_IRQ));
+		if (likely(pending)) {
+			irq = VIPER_IRQ(0) + __ffs(pending);
+			desc = irq_desc + irq;
+			DEBUG_INTR(KERN_DEBUG "viper_irq_handler: dispatching IRQ %d to %p\n",
+			       irq, desc->handle);
+			desc_handle_irq(irq, desc);
+		}
+		pending = viper_irq_pending();
+	} while (pending);
+	DEBUG_INTR(KERN_DEBUG "viper_irq_handler: exit\n");
+}
+
+static unsigned int current_voltage_divisor;
+
+#define PSU_DIN		6
+#define PSU_CLK		11
+#define PSU_LD		19
+
+#define DIN_SET()	GPSR(PSU_DIN) = GPIO_bit(PSU_DIN)
+#define DIN_CLR()	GPCR(PSU_DIN) = GPIO_bit(PSU_DIN)
+
+#define CLK_SET()	GPSR(PSU_CLK) = GPIO_bit(PSU_CLK)
+#define CLK_CLR()	GPCR(PSU_CLK) = GPIO_bit(PSU_CLK)
+
+#define LD_SET()	GPSR(PSU_LD) = GPIO_bit(PSU_LD)
+#define LD_CLR()	GPCR(PSU_LD) = GPIO_bit(PSU_LD)
+
+/* if force is not true then step from existing to new divisor. if
+ * force is true then jump straight to the new divisor. stepping is
+ * used because if the jump in voltage is too large the VCC can dip
+ * too low and the regulator cuts out.
+ *
+ * force can be used to initialize the divisor to a know state by
+ * setting the value for the current clock speed, since we are already
+ * running at that speed we know the voltage should be pretty close so
+ * the jump won't be too large
+ */
+static void viper_set_core_cpu_voltage(unsigned long khz, int force)
+{
+	int i = 0;
+	unsigned int divisor = 0;
+	const char *v;
+
+	if (khz < 200000) {
+		v = "1.0"; divisor = 0xfff;
+	} else if (khz < 300000) {
+		v = "1.1"; divisor = 0xde5;
+	} else {
+		v = "1.3"; divisor = 0x325;
+	}
+
+	printk(KERN_INFO "viper: setting CPU core voltage to %sV at %d.%03dMHz\n",
+	       v, (int)khz / 1000, (int)khz % 1000);
+
+#define STEP 0x100
+	do {
+		int step;
+
+		if (force)
+			step = divisor;
+		else if (current_voltage_divisor < divisor - STEP)
+			step = current_voltage_divisor + STEP;
+		else if (current_voltage_divisor > divisor + STEP)
+			step = current_voltage_divisor - STEP;
+		else
+			step = divisor;
+		force = 0;
+
+		CLK_CLR();
+		LD_CLR();
+
+		for (i = 1 << 11 ; i > 0 ; i >>= 1) {
+			udelay(1);
+			if (step & i)
+				DIN_SET();
+			else
+				DIN_CLR();
+			udelay(1);
+
+			CLK_SET();
+			udelay(1);
+
+			CLK_CLR();
+		}
+		udelay(1);
+
+		LD_SET();
+		udelay(1);
+		LD_CLR();
+
+		current_voltage_divisor = step;
+	} while (current_voltage_divisor != divisor);
+
+}
+
+#ifdef CONFIG_CPU_FREQ
+static int
+viper_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
+		       void *data)
+{
+	struct cpufreq_freqs *freq = data;
+
+	/* TODO: Adjust timings??? */
+
+	switch (val) {
+	case CPUFREQ_PRECHANGE:
+		if (freq->old < freq->new) {
+			/* we are getting faster so raise the voltage
+			 * before we change freq */
+			viper_set_core_cpu_voltage(freq->new, 0);
+		}
+		break;
+	case CPUFREQ_POSTCHANGE:
+		if (freq->old > freq->new) {
+			/* we are slowing down so drop the power
+			 * after we change freq */
+			viper_set_core_cpu_voltage(freq->new, 0);
+		}
+		break;
+	case CPUFREQ_RESUMECHANGE:
+		viper_set_core_cpu_voltage(freq->new, 0);
+		break;
+	default:
+		/* ignore */
+		break;
+	}
+
+	return 0;
+}
+
+static struct notifier_block viper_cpufreq_notifier_block = {
+	.notifier_call  = viper_cpufreq_notifier
+};
+
+static void viper_register_cpufreq(void)
+{
+	cpufreq_register_notifier(&viper_cpufreq_notifier_block,
CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+#else
+#define viper_register_cpufreq()
+#endif
+
+static struct irq_chip viper_irq_chip = {
+	.ack	= viper_ack_irq,
+	.mask	= viper_mask_irq,
+	.unmask	= viper_unmask_irq
+};
+
+static void __init viper_init_irq(void)
+{
+	const int isa_irqs[] = { 3, 4, 5, 6, 7, 10, 11, 12, 9, 14, 15 };
+	int irq;
+
+	pxa25x_init_irq();
+
+	/* setup ISA IRQs */
+	for (irq = VIPER_IRQ(0); irq < VIPER_IRQ(0) + 11; irq++) {
+		printk(KERN_INFO "Map ISA IRQ %d to IRQ %d\n", isa_irqs[irq -
VIPER_IRQ(0)], irq);
+		set_irq_chip(irq, &viper_irq_chip);
+		set_irq_handler(irq, handle_edge_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	}
+	set_irq_chained_handler(VIPER_CPLD_IRQ, viper_irq_handler);
+	set_irq_type(VIPER_CPLD_IRQ, IRQT_BOTHEDGE);
+
+	/* Peripheral IRQs */
+	set_irq_type(VIPER_ETH_IRQ, IRQT_RISING);
+	set_irq_type(VIPER_USB_IRQ, IRQT_RISING);
+	set_irq_type(VIPER_UARTA_IRQ, IRQT_RISING);
+	set_irq_type(VIPER_UARTB_IRQ, IRQT_RISING);
+
+	/* GPIO9 and 10 control FB backlight. Initialise to off */
+	GPCR(9) = GPIO_bit(9);
+	GPCR(10) = GPIO_bit(10);
+	pxa_gpio_mode(9  | GPIO_OUT);
+	pxa_gpio_mode(10 | GPIO_OUT);
+
+	/* Setup Backlight control on PWM0 */
+	pxa_gpio_mode(16 | GPIO_OUT);
+
+	GPCR(16) = 1 << 16;
+	PWM_CTRL1 = 4; /* 1 Msec. */
+
+}
+
+static void viper_power_off(void)
+{
+	printk(KERN_NOTICE "Shutting off UPS\n");
+	local_irq_disable();
+	GPSR(20) = GPIO_bit(20);
+	while (1) /*spin*/ ;
+}
+
+/* Flash */
+static struct platform_device flash_device = {
+	.name           = "flash",
+	.id             = -1,
+};
+
+/* Audio */
+static struct platform_device audio_device = {
+	.name           = "pxa2xx-ac97",
+	.id             = -1,
+};
+
+/* Flat Panel */
+static void viper_lcd_power(int on, struct fb_var_screeninfo *var)
+{
+	/* fb_var_screeninfo is currently unused */
+	if (on)
+		GPSR(10) = GPIO_bit(10);
+	else
+		GPCR(10) = GPIO_bit(10);
+}
+
+static void viper_backlight_power(int on)
+{
+	if (on) {
+		GPSR(9) = GPIO_bit(9);
+		/* Set full brightness */
+		GPCR(16) =  GPIO_bit(16);
+	} else {
+		GPCR(9) = GPIO_bit(9);
+		GPSR(16) =  GPIO_bit(16);
+	}
+}
+
+static struct pxafb_mode_info fb_mode_info = {
+	.pixclock       = 157500,
+
+	.xres	   = 320,
+	.yres	   = 240,
+
+	.bpp	    = 16,
+
+	.hsync_len      = 63,
+	.left_margin    = 7,
+	.right_margin   = 13,
+
+	.vsync_len      = 20,
+	.upper_margin	= 1,
+	.lower_margin	= 1,
+
+	.sync	   = 0,
+};
+
+static struct pxafb_mach_info fb_info = {
+	.modes     = &fb_mode_info,
+	.num_modes = 1,
+	.lccr0	   = LCCR0_Act | LCCR0_Color,
+	.lccr3	   = LCCR3_OutEnH | LCCR3_PixFlEdg | LCCR3_Acb(0xFF),
+
+	.pxafb_lcd_power = viper_lcd_power,
+	.pxafb_backlight_power = viper_backlight_power,
+};
+
+/* Ethernet */
+static struct resource smc91x_resources[] = {
+	[0] = {
+		.name	= "smc91x-regs",
+		.start  = VIPER_ETH_PHYS + 0x300,
+		.end    = VIPER_ETH_PHYS + 0x300 + 0xf,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = VIPER_ETH_IRQ,
+		.end    = VIPER_ETH_IRQ,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[2] = {
+		.name	= "smc91x-data32",
+		.start  = VIPER_ETH_DATA_PHYS,
+		.end    = VIPER_ETH_DATA_PHYS + 3,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device smc91x_device = {
+	.name	   = "smc91x",
+	.id		= -1,
+	.num_resources  = ARRAY_SIZE(smc91x_resources),
+	.resource       = smc91x_resources,
+};
+
+/* i2c */
+static struct i2c_gpio_platform_data i2c_bus_data = {
+	.sda_pin = 83,
+	.scl_pin = 84,
+	.udelay  = 10,
+	.timeout = 100,
+};
+static struct platform_device i2c_bus_device = {
+	.name		= "i2c-gpio",
+	.id		= 0,
+	.dev = {
+		.platform_data = &i2c_bus_data,
+	}
+};
+
+static struct i2c_gpio_platform_data i2c_tpm_data = {
+	.sda_pin = 26,
+	.scl_pin = 27,
+	.udelay  = 10,
+	.timeout = 100,
+};
+
+static struct platform_device i2c_tpm_device = {
+	.name		= "i2c-gpio",
+	.id		= 1,
+	.dev = {
+		.platform_data = &i2c_tpm_data,
+	}
+};
+
+static struct i2c_board_info __initdata viper_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO("ds1307", 0x68),
+	},
+};
+
+/* serial */
+static struct resource viper_serial_resources[] = {
+	{
+		.start	= 0x40100000,
+		.end	= 0x4010001f,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= 0x40200000,
+		.end	= 0x4020001f,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= 0x40700000,
+		.end	= 0x4070001f,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= VIPER_UARTA_PHYS,
+		.end	= VIPER_UARTA_PHYS + 0xf,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= VIPER_UARTB_PHYS,
+		.end	= VIPER_UARTB_PHYS + 0xf,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct plat_serial8250_port serial_platform_data[] = {
+	/* Internal UARTs */
+	{
+		.membase	= (void *)&FFUART,
+		.mapbase	= __PREG(FFUART),
+		.irq		= IRQ_FFUART,
+		.uartclk	= 921600 * 16,
+		.regshift	= 2,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
+		.iotype		= UPIO_MEM,
+	},
+	{
+		.membase	= (void *)&BTUART,
+		.mapbase	= __PREG(BTUART),
+		.irq		= IRQ_BTUART,
+		.uartclk	= 921600 * 16,
+		.regshift	= 2,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
+		.iotype		= UPIO_MEM,
+	},
+	{
+		.membase	= (void *)&STUART,
+		.mapbase	= __PREG(STUART),
+		.irq		= IRQ_STUART,
+		.uartclk	= 921600 * 16,
+		.regshift	= 2,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
+		.iotype		= UPIO_MEM,
+	},
+	/* External UARTs */
+	{
+		.mapbase	= VIPER_UARTA_PHYS,
+		.irq		= VIPER_UARTA_IRQ,
+		.uartclk	= 1843200,
+		.regshift	= 1,
+		.iotype		= UPIO_MEM,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP | UPF_SKIP_TEST,
+	},
+	{
+		.mapbase	= VIPER_UARTB_PHYS,
+		.irq		= VIPER_UARTB_IRQ,
+		.uartclk	= 1843200,
+		.regshift	= 1,
+		.iotype		= UPIO_MEM,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP | UPF_SKIP_TEST,
+	},
+	{ },
+};
+
+static struct platform_device serial_device = {
+	.name			= "serial8250",
+	.id			= 0,
+	.dev			= {
+		.platform_data	= serial_platform_data,
+	},
+	.num_resources		= ARRAY_SIZE(viper_serial_resources),
+	.resource		= viper_serial_resources,
+};
+
+/* USB */
+static void isp116x_delay(struct device *dev, int delay)
+{
+	/* On this platform, we work with 200MHz clock, giving
+	   5 ns per instruction. The cycle below involves 2
+	   instructions and we lose 2 more instruction times due
+	   to pipeline flush at a jump. I.e., we consume 20 ns
+	   per cycle.
+	*/
+	int cyc = delay/20 + 1;
+	cyc <<= 2; /* actually, 400MHz */
+
+	__asm__ volatile ("0:\n"
+			  "     subs  %0, %1, #1\n"
+			  "     bge   0b\n"
+			  : "=r" (cyc)
+			  : "0"  (cyc)
+		);
+}
+
+static struct resource isp116x_resources[] = {
+	[0] = { /* DATA */
+		.start  = VIPER_USB_PHYS + 0,
+		.end    = VIPER_USB_PHYS + 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = { /* ADDR */
+		.start  = VIPER_USB_PHYS + 2,
+		.end    = VIPER_USB_PHYS + 3,
+		.flags  = IORESOURCE_MEM,
+	},
+	[2] = {
+		.start  = VIPER_USB_IRQ,
+		.end    = VIPER_USB_IRQ,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+/*
(DataBusWidth16|AnalogOCEnable|DREQOutputPolarity|DownstreamPort15KRSel ) */
+static struct isp116x_platform_data isp116x_platform_data = {
+	/* Enable internal resistors on downstream ports */
+	.sel15Kres		= 1,
+	/* On-chip overcurrent protection */
+	.oc_enable		= 1,
+	/* INT output polarity */
+	.int_act_high		= 1,
+	/* INT edge or level triggered */
+	.int_edge_triggered	= 0,
+
+	/* WAKEUP pin connected - NOT SUPPORTED  */
+	/* .remote_wakeup_connected = 0, */
+	/* Wakeup by devices on usb bus enabled */
+	.remote_wakeup_enable	= 0,
+	.delay			= isp116x_delay,
+};
+
+static struct platform_device isp116x_device = {
+	.name			= "isp116x-hcd",
+	.id			= -1,
+	.num_resources  	= ARRAY_SIZE(isp116x_resources),
+	.resource       	= isp116x_resources,
+	.dev			= {
+		.platform_data	= &isp116x_platform_data,
+	},
+
+};
+
+static struct resource sram_resource = {
+	.start		= _VIPER_SRAM_BASE,
+	.end		= _VIPER_SRAM_BASE + 256 * 1024 - 1,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device sram_device = {
+	.name		= "pxa2xx-8bit-sram",
+	.id		= 0,
+	.num_resources	= 1,
+	.resource	= &sram_resource,
+};
+
+static struct platform_device *viper_devs[] __initdata = {
+	&flash_device,
+	&smc91x_device,
+	&i2c_bus_device,
+	&serial_device,
+	&isp116x_device,
+	&audio_device,
+	&sram_device,
+};
+
+static int viper_tpm;
+
+static int __init viper_tpm_setup(char *str)
+{
+	viper_tpm = simple_strtoul(str, NULL, 10);
+	return 1;
+}
+
+__setup("tpm=", viper_tpm_setup);
+
+static void __init viper_init(void)
+{
+	u8 version;
+
+	pm_power_off = viper_power_off;
+
+	set_pxa_fb_info(&fb_info);
+
+	/* v1 hardware cannot use the datacs line */
+	if (viper_hw_version() == 0)
+		smc91x_device.num_resources--;
+
+	platform_add_devices(viper_devs, ARRAY_SIZE(viper_devs));
+
+	if (viper_tpm)
+		platform_device_register(&i2c_tpm_device);
+
+	viper_register_cpufreq();
+	/* c/should assume redboot set the correct level ??? */
+	viper_set_core_cpu_voltage(get_clk_frequency_khz(0), 1);
+
+	sysdev_driver_register(&cpu_sysdev_class, &viper_cpu_sysdev_driver);
+
+	version = viper_hw_version();
+	if (version) {
+		printk(KERN_INFO "viper: hardware v%di%d detected. CPLD revision %d.\n",
+		      VIPER_BOARD_VERSION(version), VIPER_BOARD_ISSUE(version),
+		      VIPER_CPLD_REVISION(version));
+	} else {
+		printk(KERN_INFO "viper: this hardware version has no version
register.\n");
+	}
+
+	i2c_register_board_info(0, viper_i2c_devices,
+				ARRAY_SIZE(viper_i2c_devices));
+
+}
+
+static struct map_desc viper_io_desc[] __initdata = {
+	{
+		.virtual = VIPER_CPLD_BASE,
+		.pfn     = __phys_to_pfn(VIPER_CPLD_PHYS),
+		.length  = 0x00300000,
+		.type    = MT_DEVICE,
+	},
+	{
+		.virtual = VIPER_PC104IO_BASE,
+		.pfn     = __phys_to_pfn(_PCMCIA1IO),
+		.length  = 0x00800000,
+		.type    = MT_DEVICE,
+	},
+};
+
+static void __init viper_map_io(void)
+{
+	pxa_map_io();
+
+	iotable_init(viper_io_desc, ARRAY_SIZE(viper_io_desc));
+
+	/* Enable chip selects */
+	pxa_gpio_mode(GPIO78_nCS_2_MD);
+	pxa_gpio_mode(GPIO79_nCS_3_MD);
+	pxa_gpio_mode(GPIO80_nCS_4_MD);
+	pxa_gpio_mode(GPIO33_nCS_5_MD);
+
+	/* setup sleep mode values */
+	PWER  = 0x00000002;
+	PFER  = 0x00000000;
+	PRER  = 0x00000002;
+	PGSR0 = 0x00008000;
+	PGSR1 = 0x003F0202;
+	PGSR2 = 0x0001C000;
+	PCFR |= PCFR_OPDE;
+}
+
+MACHINE_START(VIPER, "Arcom VIPER SBC")
+	/* Maintainer: Arcom Control Systems Ltd. */
+	.phys_io	= 0x40000000,
+	.io_pg_offst	= ((io_p2v(0x40000000) >> 18) & 0xfffc),
+	.boot_params	= 0xa0000100,
+	.map_io		= viper_map_io,
+	.init_irq	= viper_init_irq,
+	.timer          = &pxa_timer,
+	.init_machine	= viper_init,
+MACHINE_END
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 17bc87a..55bf49e 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -166,6 +166,31 @@ config MTD_PXA2XX
  	help
  	  This provides a driver for the NOR flash attached to a PXA2xx chip.

+config MTD_VIPER
+	tristate "Arcom VIPER Primary Flash"
+	depends on ARCH_VIPER && MTD_CFI_INTELEXT
+	select MTD_PARTITIONS
+	help
+	  This provides a driver for the Intel strata flash on the Arcom
+	  VIPER SBC.
+
+config MTD_VIPER_FLASH_CACHED
+	bool "Arcom VIPER Flash Cached"
+	depends on MTD_VIPER
+	default n
+	help
+	  Mapping the flash device as cached causes memory controller
+	  to generate long "burst reads" on the bus (to fill up a cache line).
+	  This takes up the bus (signals were observed to be as long as
+	  900nSec) and causes starvation for LCD DMA; causing screen flicker
+	  in case of LCD or the monitor loosing sync and going blank (when
+	  used through FPIF-CRT).
+	  Solution: Declaring flash device as non-cachable.
+	  - don't enable cache in mtd_probe
+	  - don't provide cache invalidation function
+	  This reduces the flash read/write performance a lot. If display
+	  performance is not a priority, caching should be enabled.
+
  config MTD_OCTAGON
  	tristate "JEDEC Flash device mapped on Octagon 5066 SBC"
  	depends on X86 && MTD_JEDEC && MTD_COMPLEX_MAPPINGS
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 957fb5f..6716daf 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_MTD_ICHXROM)	+= ichxrom.o
  obj-$(CONFIG_MTD_CK804XROM)	+= ck804xrom.o
  obj-$(CONFIG_MTD_TSUNAMI)	+= tsunami_flash.o
  obj-$(CONFIG_MTD_PXA2XX)	+= pxa2xx-flash.o
+obj-$(CONFIG_MTD_VIPER)		+= viper_flash.o
  obj-$(CONFIG_MTD_MBX860)	+= mbx860.o
  obj-$(CONFIG_MTD_CEIVA)		+= ceiva.o
  obj-$(CONFIG_MTD_OCTAGON)	+= octagon-5066.o
diff --git a/drivers/mtd/maps/viper_flash.c b/drivers/mtd/maps/viper_flash.c
new file mode 100644
index 0000000..a580d7a
--- /dev/null
+++ b/drivers/mtd/maps/viper_flash.c
@@ -0,0 +1,203 @@
+/*
+ * Map driver for the VIPER SBC.
+ *
+ * Author:	Ian Campbell
+ * Copyright:	(C) 2003 Arcom.
+ *
+ * Maintainer: Amit Walambe
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/cfi.h>
+#include <asm/hardware.h>
+#include <asm/cacheflush.h>
+
+#include <asm/arch/pxa-regs.h>
+#include <asm/arch/viper.h>
+
+
+/* NOTE:
+ * Mapping the flash device as cached causes memory controller to
generate long
+ * "burst reads" on the bus (to fill up a cache line). This takes up
the bus
+ * (signals were observed to be as long as 900nSec) and causes
starvation for
+ * LCD DMA; causing screen flicker in case of LCD or the monitor
loosing sync
+ * and going blank (when used through FPIF-CRT).
+ * Solution:
+ * Declaring flash device as non-cacheble.
+ * - don't enable cache in mtd_probe
+ * - don't provide cache invalidation function
+ * This reduces the flash read/write performance a lot. If display
performance
+ * is not a priority, caching should be enabled.
+ */
+
+#ifdef CONFIG_MTD_VIPER_FLASH_CACHED
+static void viper_map_inval_cache(struct map_info *map, unsigned long
from, ssize_t len)
+{
+	flush_ioremap_region(map->phys, map->cached, from, len);
+}
+#endif
+
+static struct map_info map = {
+	.name		= "flash",
+	.size		= 64*1024*1024,
+	.phys		= VIPER_FLASH_PHYS,
+	.bankwidth	= 2,
+#ifdef CONFIG_MTD_VIPER_FLASH_CACHED
+	.inval_cache	= viper_map_inval_cache,
+#endif
+};
+
+#ifdef CONFIG_MTD_PARTITIONS
+static struct mtd_partition *mtd_parts;
+static int mtd_parts_nb;
+static const char *part_probes[] = {"cmdlinepart", "RedBoot", NULL};
+#endif
+
+static struct mtd_info *mtd;
+
+static int __init viper_mtd_probe(struct platform_device *dev)
+{
+	struct cfi_private *cfi;
+
+	if (mtd) {
+		printk(KERN_ERR "viper flash device already registered\n");
+		return -EBUSY;
+	}
+
+	printk(KERN_NOTICE "Probing VIPER flash device at physical address
0x%08lx\n",
+	       (long)map.phys);
+	map.virt = ioremap_nocache(map.phys, map.size);
+	if (!map.virt) {
+		printk(KERN_ERR "Failed to ioremap_nocache flash device\n");
+		return -EIO;
+	}
+
+#ifdef CONFIG_MTD_VIPER_FLASH_CACHED
+	map.cached = ioremap_cached(map.phys, map.size);
+	if (!map.cached)
+		printk(KERN_WARNING "Failed to ioremap cached flash device\n");
+#endif
+
+	simple_map_init(&map);
+
+	printk(KERN_NOTICE "Probing flash at physical address 0x%08lx\n",
+	       (long)map.phys);
+
+	mtd = do_map_probe("cfi_probe", &map);
+
+	if (!mtd) {
+		iounmap(map.virt);
+		if (map.cached)
+			iounmap(map.cached);
+		map.virt = NULL;
+		map.cached = NULL;
+		return -ENXIO;
+	}
+
+	mtd->owner = THIS_MODULE;
+
+	/* Unlock the flash device. */
+	cfi = map.fldrv_priv;
+	/* try and skip the unlock on J3 devices, it seems very slow */
+	if (cfi->id != 0x16 && cfi->id != 0x17 && cfi->id != 0x18 && cfi->id
!= 0x1d) {
+		/* TODO: Only unlock writable blocks as specified by the partitioning
code */
+		printk(KERN_INFO "Unlocking VIPER flash device\n");
+		mtd->unlock(mtd, 0, mtd->size);
+		printk(KERN_INFO "VIPER flash unlocked\n");
+	}
+
+#ifdef CONFIG_MTD_PARTITIONS
+	mtd_parts_nb = parse_mtd_partitions(mtd, part_probes,
+					    &mtd_parts, 0);
+
+	if (mtd_parts_nb > 0) {
+		add_mtd_partitions(mtd, mtd_parts, mtd_parts_nb);
+	} else
+#endif
+	{
+		add_mtd_device(mtd);
+	}
+	return 0;
+}
+
+static void __exit viper_mtd_remove(struct platform_device *dev)
+{
+#ifdef CONFIG_MTD_PARTITIONS
+	if (mtd_parts_nb) {
+		del_mtd_partitions(mtd);
+		kfree(mtd_parts);
+	} else
+#endif
+	{
+		del_mtd_device(mtd);
+	}
+	map_destroy(mtd);
+	mtd = NULL;
+
+	iounmap(map.virt);
+	if (map.cached)
+		iounmap(map.cached);
+	map.virt = NULL;
+	map.cached = NULL;
+}
+
+#ifdef CONFIG_PM
+static int viper_mtd_suspend(struct platform_device *dev, pm_message_t
state)
+{
+	int ret = 0;
+
+	if (mtd)
+		ret = mtd->suspend(mtd);
+
+	return ret;
+}
+
+static int viper_mtd_resume(struct platform_device *dev)
+{
+	if (mtd)
+		mtd->resume(mtd);
+	return 0;
+}
+#else
+#define viper_mtd_suspend NULL
+#define viper_mtd_resume  NULL
+#endif
+
+static struct platform_driver viper_mtd_driver = {
+	.probe		= viper_mtd_probe,
+	.remove	 	= __exit_p(viper_mtd_remove),
+	.driver		= {
+		.name	= "flash",
+	},
+	.suspend	= viper_mtd_suspend,
+	.resume	 	= viper_mtd_resume,
+};
+
+static int __init viper_mtd_init(void)
+{
+	return platform_driver_register(&viper_mtd_driver);
+}
+
+static void __exit viper_mtd_exit(void)
+{
+	platform_driver_unregister(&viper_mtd_driver);
+}
+
+module_init(viper_mtd_init);
+module_exit(viper_mtd_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arcom Control Systems Ltd.");
+MODULE_DESCRIPTION("MTD map driver for the Arcom VIPER");
diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index 8606818..0f44156 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -162,6 +162,25 @@

  #define SMC_IRQ_FLAGS		(-1)

+#elif defined(CONFIG_ARCH_VIPER)
+
+/* We can only do 16-bit reads and writes in the static memory space. */
+#define SMC_CAN_USE_8BIT	0
+#define SMC_CAN_USE_16BIT	1
+#define SMC_CAN_USE_32BIT	0
+#define SMC_CAN_USE_DATACS	1
+#define SMC_NOWAIT		1
+
+#define SMC_IO_SHIFT		0
+
+#define SMC_inw(a, r)		readw((a) + (r))
+#define SMC_outw(v, a, r)	writew(v, (a) + (r))
+#define SMC_insw(a, r, p, l)	insw((a) + (r), p, l)
+#define SMC_outsw(a, r, p, l)	outsw((a) + (r), p, l)
+
+#define RPC_LSA_DEFAULT		RPC_LED_100_10
+#define RPC_LSB_DEFAULT		RPC_LED_TX_RX
+
  #elif defined(CONFIG_SA1100_ASSABET)

  #include <asm/arch/neponset.h>
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 1b0eb5a..8f857a3 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -219,7 +219,7 @@ config PCMCIA_SA1111
  config PCMCIA_PXA2XX
  	tristate "PXA2xx support"
  	depends on ARM && ARCH_PXA && PCMCIA
-	depends on ARCH_LUBBOCK || MACH_MAINSTONE || PXA_SHARPSL || MACH_ARMCORE
+	depends on ARCH_LUBBOCK || MACH_MAINSTONE || PXA_SHARPSL ||
MACH_ARMCORE|| ARCH_VIPER
  	help
  	  Say Y here to include support for the PXA2xx PCMCIA controller

diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
index 6f6478b..ed40331 100644
--- a/drivers/pcmcia/Makefile
+++ b/drivers/pcmcia/Makefile
@@ -71,4 +71,5 @@ pxa2xx_cs-$(CONFIG_ARCH_LUBBOCK)		+= pxa2xx_lubbock.o
sa1111_generic.o
  pxa2xx_cs-$(CONFIG_MACH_MAINSTONE)		+= pxa2xx_mainstone.o
  pxa2xx_cs-$(CONFIG_PXA_SHARPSL)			+= pxa2xx_sharpsl.o
  pxa2xx_cs-$(CONFIG_MACH_ARMCORE)		+= pxa2xx_cm_x270.o
+pxa2xx_cs-$(CONFIG_ARCH_VIPER)			+= pxa2xx_viper.o

diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
index 9414163..2c9be50 100644
--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -196,7 +196,7 @@ int __pxa2xx_drv_pcmcia_probe(struct device *dev)
  		MECR |= MECR_CIT;

  		/* Set MECR:NOS (Number Of Sockets) */
-		if (nr > 1)
+		if (nr > 1 || (ops->quirks & PXA2XX_QUIRK_NEEDS_MECR_NOS))
  			MECR |= MECR_NOS;
  		else
  			MECR &= ~MECR_NOS;
@@ -227,7 +227,23 @@ static int pxa2xx_drv_pcmcia_resume(struct
platform_device *dev)
  	struct pcmcia_low_level *ops = dev->dev.platform_data;
  	int nr = ops ? ops->nr : 0;

-	MECR = nr > 1 ? MECR_CIT | MECR_NOS : (nr > 0 ? MECR_CIT : 0);
+	if (nr > 0) {
+		u32 quirks = ops ? ops->quirks : 0;
+		int v;
+
+		/*
+		 * We have at least one socket, so set MECR:CIT
+		 * (Card Is There)
+		 */
+		v = MECR_CIT;
+
+		/* Set MECR:NOS (Number Of Sockets) */
+		if (nr > 1 || (quirks & PXA2XX_QUIRK_NEEDS_MECR_NOS))
+			v |= MECR_NOS;
+
+		MECR = v;
+	} else
+		MECR = 0;

  	return pcmcia_socket_dev_resume(&dev->dev);
  }
diff --git a/drivers/pcmcia/pxa2xx_base.h b/drivers/pcmcia/pxa2xx_base.h
index 235d681..956ee9d 100644
--- a/drivers/pcmcia/pxa2xx_base.h
+++ b/drivers/pcmcia/pxa2xx_base.h
@@ -1,3 +1,10 @@
+#ifndef PXA2XX_BASE
+#define PXA2XX_BASE
+
+#define PXA2XX_QUIRK_NEEDS_MECR_NOS		(1 << 0)
+
  /* temporary measure */
  extern int __pxa2xx_drv_pcmcia_probe(struct device *);

+#endif
+
diff --git a/drivers/pcmcia/pxa2xx_viper.c b/drivers/pcmcia/pxa2xx_viper.c
new file mode 100644
index 0000000..244c24f
--- /dev/null
+++ b/drivers/pcmcia/pxa2xx_viper.c
@@ -0,0 +1,154 @@
+/*
+ * VIPER PCMCIA support
+ *   Copyright 2004 Arcom Control Systems
+ *
+ * Based on:
+ *   iPAQ h2200 PCMCIA support
+ *   Copyright 2004 Koen Kooi <koen@vestingbar.nl>
+ *
+ * This file is subject to the terms and conditions of the GNU General
Public
+ * License.  See the file COPYING in the main directory of this archive for
+ * more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+
+#include <pcmcia/ss.h>
+
+#include <asm/hardware.h>
+#include <asm/irq.h>
+
+#include <asm/arch/pxa-regs.h>
+#include <asm/arch/pxa2xx-gpio.h>
+#include <asm/arch/viper.h>
+
+#include "soc_common.h"
+#include "pxa2xx_base.h"
+
+static void viper_cf_rst(int state)
+{
+	if (state)
+		viper_icr_set_bit(VIPER_ICR_CF_RST);
+	else
+		viper_icr_clear_bit(VIPER_ICR_CF_RST);
+
+}
+
+static struct pcmcia_irqs irqs[] = {
+	{ 0, VIPER_CF_CD_IRQ,  "PCMCIA_CD" }
+};
+
+static int viper_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
+{
+	unsigned long flags;
+
+	skt->irq = VIPER_CF_RDY_IRQ;
+
+	local_irq_save(flags);
+
+	/* GPIO 82 is the CF power enable line. initially off */
+	GPCR(82) = GPIO_bit(82);
+	pxa_gpio_mode(82 | GPIO_OUT);
+	pxa_gpio_mode(VIPER_CF_CD_GPIO | GPIO_IN);
+	pxa_gpio_mode(VIPER_CF_RDY_GPIO | GPIO_IN);
+
+	local_irq_restore(flags);
+
+	return soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
+}
+
+/*
+ * Release all resources.
+ */
+static void viper_pcmcia_hw_shutdown(struct soc_pcmcia_socket *skt)
+{
+	soc_pcmcia_free_irqs(skt, irqs, ARRAY_SIZE(irqs));
+}
+
+static void viper_pcmcia_socket_state(struct soc_pcmcia_socket *skt,
struct pcmcia_state *state)
+{
+	state->detect = (GPLR(VIPER_CF_CD_GPIO) & GPIO_bit(VIPER_CF_CD_GPIO))?0:1;
+	state->ready  = (GPLR(VIPER_CF_RDY_GPIO) &
GPIO_bit(VIPER_CF_RDY_GPIO))?1:0;
+	state->bvd1   = 1;
+	state->bvd2   = 1;
+	state->wrprot = 0;
+	state->vs_3v  = 1; /* Can only apply 3.3V */
+	state->vs_Xv  = 0;
+}
+
+static int viper_pcmcia_configure_socket(struct soc_pcmcia_socket *skt,
const socket_state_t *state)
+{
+	/* Silently ignore Vpp, output enable, speaker enable. */
+	viper_cf_rst(state->flags & SS_RESET);
+
+	/* Apply socket voltage */
+	switch (state->Vcc) {
+	case 0:
+		GPCR(82) = GPIO_bit(82);
+		break;
+	case 33:
+		GPSR(82) = GPIO_bit(82);
+		break;
+	default:
+		printk(KERN_ERR "%s: Unsupported Vcc:%d\n",
+		       __func__, state->Vcc);
+		return -1;
+	}
+
+	return 0;
+}
+
+static void viper_pcmcia_socket_init(struct soc_pcmcia_socket *skt)
+{
+}
+
+static void viper_pcmcia_socket_suspend(struct soc_pcmcia_socket *skt)
+{
+}
+
+static struct pcmcia_low_level viper_pcmcia_ops = {
+	.owner          	= THIS_MODULE,
+	.hw_init        	= viper_pcmcia_hw_init,
+	.hw_shutdown		= viper_pcmcia_hw_shutdown,
+	.socket_state		= viper_pcmcia_socket_state,
+	.configure_socket	= viper_pcmcia_configure_socket,
+	.socket_init		= viper_pcmcia_socket_init,
+	.socket_suspend		= viper_pcmcia_socket_suspend,
+	.nr         		= 1,
+	.quirks			= PXA2XX_QUIRK_NEEDS_MECR_NOS,
+};
+
+static struct platform_device *viper_pcmcia_device;
+
+static int __init viper_pcmcia_init(void)
+{
+	int ret;
+
+	viper_pcmcia_device = platform_device_alloc("pxa2xx-pcmcia", -1);
+	if (!viper_pcmcia_device)
+		return -ENOMEM;
+
+	viper_pcmcia_device->dev.platform_data = &viper_pcmcia_ops;
+
+	ret = platform_device_add(viper_pcmcia_device);
+
+	if (ret)
+		platform_device_put(viper_pcmcia_device);
+
+	return ret;
+}
+
+static void __exit viper_pcmcia_exit(void)
+{
+	platform_device_unregister(viper_pcmcia_device);
+}
+
+module_init(viper_pcmcia_init);
+module_exit(viper_pcmcia_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/pcmcia/soc_common.h b/drivers/pcmcia/soc_common.h
index 1edc1da..61871ae 100644
--- a/drivers/pcmcia/soc_common.h
+++ b/drivers/pcmcia/soc_common.h
@@ -77,6 +77,8 @@ struct pcmcia_low_level {
  	int first;
  	/* nr of sockets */
  	int nr;
+	/* Quirks required by this system, SOC dependant */
+	u32 quirks;

  	int (*hw_init)(struct soc_pcmcia_socket *);
  	void (*hw_shutdown)(struct soc_pcmcia_socket *);
diff --git a/include/asm-arm/arch-pxa/irqs.h
b/include/asm-arm/arch-pxa/irqs.h
index b6c8fe3..8e1ddef 100644
--- a/include/asm-arm/arch-pxa/irqs.h
+++ b/include/asm-arm/arch-pxa/irqs.h
@@ -179,6 +179,7 @@
  #elif defined(CONFIG_SHARP_LOCOMO)
  #define NR_IRQS			(IRQ_LOCOMO_SPI_TEND + 1)
  #elif defined(CONFIG_ARCH_LUBBOCK) || \
+      defined(CONFIG_ARCH_VIPER) || \
        defined(CONFIG_MACH_LOGICPD_PXA270) || \
        defined(CONFIG_MACH_MAINSTONE) || \
        defined(CONFIG_MACH_PCM027) || \
@@ -229,6 +230,28 @@
  #define IRQ_LOCOMO_LT_BASE	(IRQ_BOARD_START + 2)
  #define IRQ_LOCOMO_SPI_BASE	(IRQ_BOARD_START + 3)

+/* ARCOM VIPER */
+#define VIPER_ETH_IRQ		IRQ_GPIO(0)
+#define VIPER_CPLD_IRQ		IRQ_GPIO(1)
+#define VIPER_USB_IRQ		IRQ_GPIO(2)
+
+#define VIPER_UARTA_IRQ	 	IRQ_GPIO(4)
+#define VIPER_UARTB_IRQ	 	IRQ_GPIO(3)
+
+#define VIPER_CF_CD_IRQ	 	IRQ_GPIO(VIPER_CF_CD_GPIO)
+#define VIPER_CF_RDY_IRQ	IRQ_GPIO(VIPER_CF_RDY_GPIO)
+
+#define VIPER_IRQ(x)		(IRQ_BOARD_START + (x))
+
+#define VIPER_ISA_IRQ3		VIPER_IRQ(0)
+#define VIPER_ISA_IRQ4		VIPER_IRQ(1)
+#define VIPER_ISA_IRQ5		VIPER_IRQ(2)
+#define VIPER_ISA_IRQ6		VIPER_IRQ(3)
+#define VIPER_ISA_IRQ7		VIPER_IRQ(4)
+#define VIPER_ISA_IRQ10	 	VIPER_IRQ(5)
+#define VIPER_ISA_IRQ11	 	VIPER_IRQ(6)
+#define VIPER_ISA_IRQ14	 	VIPER_IRQ(7)
+
  /* phyCORE-PXA270 (PCM027) Interrupts */
  #define PCM027_IRQ(x)          (IRQ_BOARD_START + (x))
  #define PCM027_BTDET_IRQ       PCM027_IRQ(0)
diff --git a/include/asm-arm/arch-pxa/viper.h
b/include/asm-arm/arch-pxa/viper.h
new file mode 100644
index 0000000..09fd6eb
--- /dev/null
+++ b/include/asm-arm/arch-pxa/viper.h
@@ -0,0 +1,73 @@
+/*
+ *  linux/include/asm-arm/arch-pxa/viper.h
+ *
+ *  Author:	Ian Campbell
+ *  Created:	Feb 03, 2003
+ *  Copyright:	Arcom Control Systems.
+ *
+ * Created based on lubbock.h:
+ *  Author:	Nicolas Pitre
+ *  Created:	Jun 15, 2001
+ *  Copyright:	MontaVista Software Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef ARCH_VIPER_H
+#define ARCH_VIPER_H
+
+#define VIPER_BOOT_PHYS			PXA_CS0_PHYS
+#define VIPER_FLASH_PHYS		PXA_CS1_PHYS
+#define VIPER_ETH_PHYS			PXA_CS2_PHYS
+#define VIPER_USB_PHYS			PXA_CS3_PHYS
+#define VIPER_ETH_DATA_PHYS		PXA_CS4_PHYS
+#define VIPER_CPLD_PHYS			PXA_CS5_PHYS
+
+#define VIPER_CPLD_BASE			(0xf0000000)
+#define VIPER_PC104IO_BASE		(0xf1000000)
+#define VIPER_USB_BASE			(0xf1800000)
+
+#define VIPER_CF_CD_GPIO		(32)
+#define VIPER_CF_RDY_GPIO		(8)
+
+#define VIPER_CPLD_P2V(x)		((x) - VIPER_CPLD_PHYS + VIPER_CPLD_BASE)
+#define VIPER_CPLD_V2P(x)		((x) - VIPER_CPLD_BASE + VIPER_CPLD_PHYS)
+
+#ifndef __ASSEMBLY__
+#  define __VIPER_CPLD_REG(x)		(*((volatile u16 *)VIPER_CPLD_P2V(x)))
+#endif
+
+/* board level registers in the CPLD: (offsets from CPLD_BASE) ... */
+
+/* ... Physical addresses */
+#define _VIPER_LO_IRQ_STATUS		(VIPER_CPLD_PHYS + 0x100000)
+#define _VIPER_ICR_PHYS			(VIPER_CPLD_PHYS + 0x100002)
+#define _VIPER_HI_IRQ_STATUS		(VIPER_CPLD_PHYS + 0x100004)
+#define _VIPER_VERSION_PHYS		(VIPER_CPLD_PHYS + 0x100006)
+#define VIPER_UARTA_PHYS		(VIPER_CPLD_PHYS + 0x300010)
+#define VIPER_UARTB_PHYS		(VIPER_CPLD_PHYS + 0x300000)
+#define _VIPER_SRAM_BASE		(VIPER_CPLD_PHYS + 0x800000)
+
+/* ... Virtual addresses */
+#define VIPER_LO_IRQ_STATUS		__VIPER_CPLD_REG(_VIPER_LO_IRQ_STATUS)
+#define VIPER_HI_IRQ_STATUS		__VIPER_CPLD_REG(_VIPER_HI_IRQ_STATUS)
+
+/* Decode VIPER_VERSION register */
+extern u8 viper_hw_version(void);
+#define VIPER_CPLD_REVISION(x)		(((x) >> 5) & 0x7)
+#define VIPER_BOARD_VERSION(x)		(((x) >> 3) & 0x3)
+#define VIPER_BOARD_ISSUE(x)		(((x) >> 0) & 0x7)
+
+/* Interrupt and Configuration Register (VIPER_ICR) */
+/* This is a write only register. Only CF_RST is used under Linux */
+extern void viper_icr_set_bit(unsigned int bit);
+extern void viper_icr_clear_bit(unsigned int bit);
+#define VIPER_ICR_RETRIG	(1 << 0)
+#define VIPER_ICR_AUTO_CLR	(1 << 1)
+#define VIPER_ICR_R_DIS		(1 << 2)
+#define VIPER_ICR_CF_RST	(1 << 3)
+
+#endif
+
-- 
A rat a day keeps the plague away.


