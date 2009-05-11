Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZEKJE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZEKJE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbZEKJEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:04:46 -0400
Received: from araneidae.co.uk ([62.3.233.233]:4333 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbZEKJEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:04:44 -0400
Date: Mon, 11 May 2009 10:04:42 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: linux-arm-kernel@lists.arm.linux.org.uk
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] XCEP PXA255 Processor Board
Message-ID: <Pine.LNX.4.64.0905110928410.10720@venus.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update of a new architecture patch submitted last week.  
Although this is mailed to the linux-arm-kernel mailing list, my 
subscription seems to be stuck pending moderator approval, so this won't 
actually make it to the list for a bit.  If anybody on that list fancys 
forwarding this mail, that might be helpful.

The main change to this version of the patch is that I've now eliminated 
the obsolescent pxa gpio interface in favour of pxa2xx_mfp_config.  I've 
also added a suitable _defconfig file.

I've also rebased the patch onto current git (at least, as of last 
Friday).

Please cc any replies to me.


Date: Wed, 18 Mar 2009 13:42:08 +0000
Subject: [PATCH] XCEP PXA255 Processor Board

Adds support for the XCEP processor from IskraTel.  This is a small
single board computer with an ARM XScale PXA255 processor, 32M flash,
64M RAM and an SMSC LAN91C111 network device.

This board is used in a series of electron beam position monitors used
in synchrotron light sources world wide.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
---
 arch/arm/configs/xcep_defconfig | 1089 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-pxa/Kconfig       |    6 +
 arch/arm/mach-pxa/Makefile      |    1 +
 arch/arm/mach-pxa/xcep.c        |  200 +++++++
 drivers/net/smc91x.h            |    5 +
 5 files changed, 1301 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/configs/xcep_defconfig
 create mode 100644 arch/arm/mach-pxa/xcep.c

diff --git a/arch/arm/configs/xcep_defconfig b/arch/arm/configs/xcep_defconfig
new file mode 100644
index 0000000..ccb3157
--- /dev/null
+++ b/arch/arm/configs/xcep_defconfig
@@ -0,0 +1,1089 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.30-rc4
+# Mon May 11 09:43:09 2009
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
+CONFIG_HAVE_LATENCYTOP_SUPPORT=y
+CONFIG_LOCKDEP_SUPPORT=y
+CONFIG_TRACE_IRQFLAGS_SUPPORT=y
+CONFIG_HARDIRQS_SW_RESEND=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_ARCH_MTD_XIP=y
+CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
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
+CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
+# CONFIG_POSIX_MQUEUE is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_AUDIT is not set
+
+#
+# RCU Subsystem
+#
+CONFIG_CLASSIC_RCU=y
+# CONFIG_TREE_RCU is not set
+# CONFIG_PREEMPT_RCU is not set
+# CONFIG_TREE_RCU_TRACE is not set
+# CONFIG_PREEMPT_RCU_TRACE is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_GROUP_SCHED is not set
+# CONFIG_CGROUPS is not set
+# CONFIG_SYSFS_DEPRECATED_V2 is not set
+# CONFIG_RELAY is not set
+# CONFIG_NAMESPACES is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE=""
+CONFIG_RD_GZIP=y
+# CONFIG_RD_BZIP2 is not set
+# CONFIG_RD_LZMA is not set
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_SYSCTL=y
+CONFIG_ANON_INODES=y
+CONFIG_EMBEDDED=y
+# CONFIG_UID16 is not set
+# CONFIG_SYSCTL_SYSCALL is not set
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+# CONFIG_STRIP_ASM_SYMS is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
+CONFIG_EVENTFD=y
+# CONFIG_SHMEM is not set
+CONFIG_AIO=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_COMPAT_BRK=y
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+# CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set
+CONFIG_HAVE_OPROFILE=y
+# CONFIG_KPROBES is not set
+CONFIG_HAVE_KPROBES=y
+CONFIG_HAVE_KRETPROBES=y
+CONFIG_HAVE_CLK=y
+# CONFIG_SLOW_WORK is not set
+CONFIG_HAVE_GENERIC_DMA_COHERENT=y
+CONFIG_SLABINFO=y
+CONFIG_RT_MUTEXES=y
+CONFIG_BASE_SMALL=0
+CONFIG_MODULES=y
+# CONFIG_MODULE_FORCE_LOAD is not set
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_MODULE_FORCE_UNLOAD is not set
+CONFIG_MODVERSIONS=y
+CONFIG_MODULE_SRCVERSION_ALL=y
+# CONFIG_BLOCK is not set
+# CONFIG_FREEZER is not set
+
+#
+# System Type
+#
+# CONFIG_ARCH_AAEC2000 is not set
+# CONFIG_ARCH_INTEGRATOR is not set
+# CONFIG_ARCH_REALVIEW is not set
+# CONFIG_ARCH_VERSATILE is not set
+# CONFIG_ARCH_AT91 is not set
+# CONFIG_ARCH_CLPS711X is not set
+# CONFIG_ARCH_EBSA110 is not set
+# CONFIG_ARCH_EP93XX is not set
+# CONFIG_ARCH_GEMINI is not set
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
+# CONFIG_ARCH_KIRKWOOD is not set
+# CONFIG_ARCH_KS8695 is not set
+# CONFIG_ARCH_NS9XXX is not set
+# CONFIG_ARCH_LOKI is not set
+# CONFIG_ARCH_MV78XX0 is not set
+# CONFIG_ARCH_MXC is not set
+# CONFIG_ARCH_ORION5X is not set
+# CONFIG_ARCH_PNX4008 is not set
+CONFIG_ARCH_PXA=y
+# CONFIG_ARCH_MMP is not set
+# CONFIG_ARCH_RPC is not set
+# CONFIG_ARCH_SA1100 is not set
+# CONFIG_ARCH_S3C2410 is not set
+# CONFIG_ARCH_S3C64XX is not set
+# CONFIG_ARCH_SHARK is not set
+# CONFIG_ARCH_LH7A40X is not set
+# CONFIG_ARCH_DAVINCI is not set
+# CONFIG_ARCH_OMAP is not set
+# CONFIG_ARCH_MSM is not set
+# CONFIG_ARCH_W90X900 is not set
+
+#
+# Intel PXA2xx/PXA3xx Implementations
+#
+# CONFIG_ARCH_GUMSTIX is not set
+# CONFIG_MACH_INTELMOTE2 is not set
+# CONFIG_ARCH_LUBBOCK is not set
+# CONFIG_MACH_LOGICPD_PXA270 is not set
+# CONFIG_MACH_MAINSTONE is not set
+# CONFIG_MACH_MP900C is not set
+# CONFIG_ARCH_PXA_IDP is not set
+# CONFIG_PXA_SHARPSL is not set
+# CONFIG_ARCH_VIPER is not set
+# CONFIG_ARCH_PXA_ESERIES is not set
+# CONFIG_TRIZEPS_PXA is not set
+# CONFIG_MACH_H5000 is not set
+# CONFIG_MACH_EM_X270 is not set
+# CONFIG_MACH_EXEDA is not set
+# CONFIG_MACH_COLIBRI is not set
+# CONFIG_MACH_COLIBRI300 is not set
+# CONFIG_MACH_COLIBRI320 is not set
+# CONFIG_MACH_ZYLONITE is not set
+# CONFIG_MACH_LITTLETON is not set
+# CONFIG_MACH_TAVOREVB is not set
+# CONFIG_MACH_SAAR is not set
+# CONFIG_MACH_ARMCORE is not set
+# CONFIG_MACH_CM_X300 is not set
+# CONFIG_MACH_MAGICIAN is not set
+# CONFIG_MACH_HIMALAYA is not set
+# CONFIG_MACH_MIOA701 is not set
+# CONFIG_MACH_PCM027 is not set
+# CONFIG_ARCH_PXA_PALM is not set
+# CONFIG_MACH_CSB726 is not set
+# CONFIG_PXA_EZX is not set
+CONFIG_MACH_XCEP=y
+CONFIG_PXA25x=y
+CONFIG_PXA_SSP=y
+# CONFIG_PXA_PWM is not set
+CONFIG_PLAT_PXA=y
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
+CONFIG_COMMON_CLKDEV=y
+
+#
+# Bus support
+#
+# CONFIG_PCI_SYSCALL is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
+# CONFIG_PCCARD is not set
+
+#
+# Kernel Features
+#
+CONFIG_TICK_ONESHOT=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+CONFIG_VMSPLIT_3G=y
+# CONFIG_VMSPLIT_2G is not set
+# CONFIG_VMSPLIT_1G is not set
+CONFIG_PAGE_OFFSET=0xC0000000
+# CONFIG_PREEMPT is not set
+CONFIG_HZ=100
+CONFIG_AEABI=y
+CONFIG_OABI_COMPAT=y
+CONFIG_ARCH_FLATMEM_HAS_HOLES=y
+# CONFIG_ARCH_SPARSEMEM_DEFAULT is not set
+# CONFIG_ARCH_SELECT_MEMORY_MODEL is not set
+# CONFIG_HIGHMEM is not set
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_PAGEFLAGS_EXTENDED=y
+CONFIG_SPLIT_PTLOCK_CPUS=4096
+# CONFIG_PHYS_ADDR_T_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=0
+CONFIG_VIRT_TO_BUS=y
+CONFIG_UNEVICTABLE_LRU=y
+CONFIG_HAVE_MLOCK=y
+CONFIG_HAVE_MLOCKED_PAGE_BIT=y
+CONFIG_ALIGNMENT_TRAP=y
+
+#
+# Boot options
+#
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_CMDLINE=""
+# CONFIG_XIP_KERNEL is not set
+# CONFIG_KEXEC is not set
+
+#
+# CPU Power Management
+#
+# CONFIG_CPU_FREQ is not set
+# CONFIG_CPU_IDLE is not set
+
+#
+# Floating point emulation
+#
+
+#
+# At least one emulation must be selected
+#
+# CONFIG_FPE_NWFPE is not set
+# CONFIG_FPE_FASTFPE is not set
+
+#
+# Userspace binary formats
+#
+CONFIG_BINFMT_ELF=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+CONFIG_HAVE_AOUT=y
+# CONFIG_BINFMT_AOUT is not set
+# CONFIG_BINFMT_MISC is not set
+
+#
+# Power management options
+#
+# CONFIG_PM is not set
+CONFIG_ARCH_SUSPEND_POSSIBLE=y
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_PACKET=y
+CONFIG_PACKET_MMAP=y
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
+# CONFIG_XFRM_STATISTICS is not set
+CONFIG_NET_KEY=y
+# CONFIG_NET_KEY_MIGRATE is not set
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+CONFIG_IP_PNP_BOOTP=y
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_IP_MROUTE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+CONFIG_INET_LRO=y
+# CONFIG_INET_DIAG is not set
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
+# CONFIG_NET_DSA is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+# CONFIG_PHONET is not set
+# CONFIG_NET_SCHED is not set
+# CONFIG_DCB is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_CAN is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+# CONFIG_WIRELESS is not set
+# CONFIG_WIMAX is not set
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
+# CONFIG_FW_LOADER is not set
+# CONFIG_SYS_HYPERVISOR is not set
+# CONFIG_CONNECTOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+CONFIG_MTD_CONCAT=y
+CONFIG_MTD_PARTITIONS=y
+# CONFIG_MTD_TESTS is not set
+# CONFIG_MTD_REDBOOT_PARTS is not set
+# CONFIG_MTD_CMDLINE_PARTS is not set
+# CONFIG_MTD_AFS_PARTS is not set
+# CONFIG_MTD_AR7_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+CONFIG_MTD_CHAR=y
+# CONFIG_MTD_OOPS is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+CONFIG_MTD_CFI=y
+# CONFIG_MTD_JEDECPROBE is not set
+CONFIG_MTD_GEN_PROBE=y
+# CONFIG_MTD_CFI_ADV_OPTIONS is not set
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+CONFIG_MTD_MAP_BANK_WIDTH_4=y
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+CONFIG_MTD_CFI_I2=y
+# CONFIG_MTD_CFI_I4 is not set
+# CONFIG_MTD_CFI_I8 is not set
+CONFIG_MTD_CFI_INTELEXT=y
+# CONFIG_MTD_CFI_AMDSTD is not set
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_CFI_UTIL=y
+# CONFIG_MTD_RAM is not set
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+# CONFIG_MTD_XIP is not set
+
+#
+# Mapping drivers for chip access
+#
+CONFIG_MTD_COMPLEX_MAPPINGS=y
+CONFIG_MTD_PHYSMAP=y
+# CONFIG_MTD_PHYSMAP_COMPAT is not set
+# CONFIG_MTD_PXA2XX is not set
+# CONFIG_MTD_ARM_INTEGRATOR is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
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
+# LPDDR flash memory drivers
+#
+# CONFIG_MTD_LPDDR is not set
+
+#
+# UBI - Unsorted block images
+#
+# CONFIG_MTD_UBI is not set
+# CONFIG_PARPORT is not set
+# CONFIG_MISC_DEVICES is not set
+CONFIG_HAVE_IDE=y
+
+#
+# SCSI device support
+#
+# CONFIG_SCSI_DMA is not set
+# CONFIG_SCSI_NETLINK is not set
+CONFIG_NETDEVICES=y
+CONFIG_COMPAT_NET_DEV_OPS=y
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+# CONFIG_VETH is not set
+# CONFIG_PHYLIB is not set
+CONFIG_NET_ETHERNET=y
+CONFIG_MII=y
+# CONFIG_AX88796 is not set
+CONFIG_SMC91X=y
+# CONFIG_DM9000 is not set
+# CONFIG_ETHOC is not set
+# CONFIG_SMC911X is not set
+# CONFIG_SMSC911X is not set
+# CONFIG_DNET is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
+# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
+# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+
+#
+# Enable WiMAX (Networking options) to see the WiMAX drivers
+#
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
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
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_INPUT_JOYDEV is not set
+# CONFIG_INPUT_EVDEV is not set
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+# CONFIG_INPUT_MISC is not set
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
+# CONFIG_VT is not set
+# CONFIG_DEVKMEM is not set
+# CONFIG_SERIAL_NONSTANDARD is not set
+
+#
+# Serial drivers
+#
+# CONFIG_SERIAL_8250 is not set
+
+#
+# Non-8250 serial port support
+#
+CONFIG_SERIAL_PXA=y
+CONFIG_SERIAL_PXA_CONSOLE=y
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+CONFIG_UNIX98_PTYS=y
+# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_IPMI_HANDLER is not set
+CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM_TIMERIOMEM is not set
+# CONFIG_R3964 is not set
+# CONFIG_TCG_TPM is not set
+CONFIG_I2C=y
+CONFIG_I2C_BOARDINFO=y
+CONFIG_I2C_CHARDEV=y
+CONFIG_I2C_HELPER_AUTO=y
+
+#
+# I2C Hardware Bus support
+#
+
+#
+# I2C system bus drivers (mostly embedded / system-on-chip)
+#
+# CONFIG_I2C_GPIO is not set
+# CONFIG_I2C_OCORES is not set
+CONFIG_I2C_PXA=y
+# CONFIG_I2C_PXA_SLAVE is not set
+# CONFIG_I2C_SIMTEC is not set
+
+#
+# External I2C/SMBus adapter drivers
+#
+# CONFIG_I2C_PARPORT_LIGHT is not set
+# CONFIG_I2C_TAOS_EVM is not set
+
+#
+# Other I2C/SMBus bus drivers
+#
+# CONFIG_I2C_PCA_PLATFORM is not set
+# CONFIG_I2C_STUB is not set
+
+#
+# Miscellaneous I2C Chip support
+#
+# CONFIG_DS1682 is not set
+# CONFIG_SENSORS_PCF8574 is not set
+# CONFIG_PCF8575 is not set
+# CONFIG_SENSORS_PCA9539 is not set
+# CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_SENSORS_TSL2550 is not set
+# CONFIG_I2C_DEBUG_CORE is not set
+# CONFIG_I2C_DEBUG_ALGO is not set
+# CONFIG_I2C_DEBUG_BUS is not set
+# CONFIG_I2C_DEBUG_CHIP is not set
+# CONFIG_SPI is not set
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
+CONFIG_GPIOLIB=y
+# CONFIG_GPIO_SYSFS is not set
+
+#
+# Memory mapped GPIO expanders:
+#
+
+#
+# I2C GPIO expanders:
+#
+# CONFIG_GPIO_MAX732X is not set
+# CONFIG_GPIO_PCA953X is not set
+# CONFIG_GPIO_PCF857X is not set
+
+#
+# PCI GPIO expanders:
+#
+
+#
+# SPI GPIO expanders:
+#
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_AD7414 is not set
+# CONFIG_SENSORS_AD7418 is not set
+CONFIG_SENSORS_ADM1021=y
+# CONFIG_SENSORS_ADM1025 is not set
+# CONFIG_SENSORS_ADM1026 is not set
+# CONFIG_SENSORS_ADM1029 is not set
+# CONFIG_SENSORS_ADM1031 is not set
+# CONFIG_SENSORS_ADM9240 is not set
+# CONFIG_SENSORS_ADT7462 is not set
+# CONFIG_SENSORS_ADT7470 is not set
+# CONFIG_SENSORS_ADT7473 is not set
+# CONFIG_SENSORS_ADT7475 is not set
+# CONFIG_SENSORS_ATXP1 is not set
+# CONFIG_SENSORS_DS1621 is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_F75375S is not set
+# CONFIG_SENSORS_G760A is not set
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
+# CONFIG_SENSORS_LTC4215 is not set
+# CONFIG_SENSORS_LTC4245 is not set
+# CONFIG_SENSORS_LM95241 is not set
+# CONFIG_SENSORS_MAX1619 is not set
+CONFIG_SENSORS_MAX6650=y
+# CONFIG_SENSORS_PC87360 is not set
+# CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_PCF8591 is not set
+# CONFIG_SENSORS_SHT15 is not set
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
+# CONFIG_THERMAL is not set
+# CONFIG_THERMAL_HWMON is not set
+# CONFIG_WATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_CORE is not set
+# CONFIG_MFD_SM501 is not set
+# CONFIG_MFD_ASIC3 is not set
+# CONFIG_HTC_EGPIO is not set
+# CONFIG_HTC_PASIC3 is not set
+# CONFIG_TPS65010 is not set
+# CONFIG_TWL4030_CORE is not set
+# CONFIG_MFD_TMIO is not set
+# CONFIG_MFD_T7L66XB is not set
+# CONFIG_MFD_TC6387XB is not set
+# CONFIG_MFD_TC6393XB is not set
+# CONFIG_PMIC_DA903X is not set
+# CONFIG_MFD_WM8400 is not set
+# CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_MFD_PCF50633 is not set
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
+# CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+# CONFIG_SOUND is not set
+# CONFIG_HID_SUPPORT is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_MMC is not set
+# CONFIG_MEMSTICK is not set
+# CONFIG_ACCESSIBILITY is not set
+# CONFIG_NEW_LEDS is not set
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=y
+# CONFIG_RTC_HCTOSYS is not set
+# CONFIG_RTC_DEBUG is not set
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
+# CONFIG_RTC_DRV_DS1307 is not set
+# CONFIG_RTC_DRV_DS1374 is not set
+# CONFIG_RTC_DRV_DS1672 is not set
+# CONFIG_RTC_DRV_MAX6900 is not set
+# CONFIG_RTC_DRV_RS5C372 is not set
+# CONFIG_RTC_DRV_ISL1208 is not set
+# CONFIG_RTC_DRV_X1205 is not set
+# CONFIG_RTC_DRV_PCF8563 is not set
+# CONFIG_RTC_DRV_PCF8583 is not set
+# CONFIG_RTC_DRV_M41T80 is not set
+# CONFIG_RTC_DRV_S35390A is not set
+# CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
+
+#
+# SPI RTC drivers
+#
+
+#
+# Platform RTC drivers
+#
+# CONFIG_RTC_DRV_CMOS is not set
+# CONFIG_RTC_DRV_DS1286 is not set
+# CONFIG_RTC_DRV_DS1511 is not set
+# CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
+# CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T35 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
+# CONFIG_RTC_DRV_BQ4802 is not set
+# CONFIG_RTC_DRV_V3020 is not set
+
+#
+# on-CPU RTC drivers
+#
+CONFIG_RTC_DRV_SA1100=y
+# CONFIG_RTC_DRV_PXA is not set
+# CONFIG_DMADEVICES is not set
+# CONFIG_AUXDISPLAY is not set
+# CONFIG_REGULATOR is not set
+# CONFIG_UIO is not set
+# CONFIG_STAGING is not set
+
+#
+# File systems
+#
+# CONFIG_DNOTIFY is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# Caches
+#
+# CONFIG_FSCACHE is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
+# CONFIG_HUGETLB_PAGE is not set
+# CONFIG_CONFIGFS_FS is not set
+CONFIG_MISC_FILESYSTEMS=y
+CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_FS_DEBUG=0
+CONFIG_JFFS2_FS_WRITEBUFFER=y
+CONFIG_JFFS2_FS_WBUF_VERIFY=y
+# CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
+# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
+CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
+CONFIG_JFFS2_RTIME=y
+# CONFIG_JFFS2_RUBIN is not set
+# CONFIG_ROMFS_FS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+CONFIG_ROOT_NFS=y
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+# CONFIG_SMB_FS is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+CONFIG_NLS=y
+CONFIG_NLS_DEFAULT="utf8"
+# CONFIG_NLS_CODEPAGE_437 is not set
+# CONFIG_NLS_CODEPAGE_737 is not set
+# CONFIG_NLS_CODEPAGE_775 is not set
+# CONFIG_NLS_CODEPAGE_850 is not set
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
+# CONFIG_NLS_ISO8859_1 is not set
+# CONFIG_NLS_ISO8859_2 is not set
+# CONFIG_NLS_ISO8859_3 is not set
+# CONFIG_NLS_ISO8859_4 is not set
+# CONFIG_NLS_ISO8859_5 is not set
+# CONFIG_NLS_ISO8859_6 is not set
+# CONFIG_NLS_ISO8859_7 is not set
+# CONFIG_NLS_ISO8859_9 is not set
+# CONFIG_NLS_ISO8859_13 is not set
+# CONFIG_NLS_ISO8859_14 is not set
+# CONFIG_NLS_ISO8859_15 is not set
+# CONFIG_NLS_KOI8_R is not set
+# CONFIG_NLS_KOI8_U is not set
+CONFIG_NLS_UTF8=y
+# CONFIG_DLM is not set
+
+#
+# Kernel hacking
+#
+CONFIG_PRINTK_TIME=y
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+CONFIG_FRAME_WARN=1024
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_KERNEL is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_MEMORY_INIT is not set
+# CONFIG_RCU_CPU_STALL_DETECTOR is not set
+# CONFIG_LATENCYTOP is not set
+CONFIG_HAVE_FUNCTION_TRACER=y
+CONFIG_TRACING_SUPPORT=y
+
+#
+# Tracers
+#
+# CONFIG_FUNCTION_TRACER is not set
+# CONFIG_IRQSOFF_TRACER is not set
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_EVENT_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
+# CONFIG_TRACE_BRANCH_PROFILING is not set
+# CONFIG_STACK_TRACER is not set
+# CONFIG_KMEMTRACE is not set
+# CONFIG_WORKQUEUE_TRACER is not set
+# CONFIG_SAMPLES is not set
+CONFIG_HAVE_ARCH_KGDB=y
+CONFIG_ARM_UNWIND=y
+CONFIG_DEBUG_USER=y
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY is not set
+# CONFIG_SECURITYFS is not set
+# CONFIG_SECURITY_FILE_CAPABILITIES is not set
+CONFIG_CRYPTO=y
+
+#
+# Crypto core or helper
+#
+# CONFIG_CRYPTO_FIPS is not set
+CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_ALGAPI2=y
+CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_HASH2=y
+# CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
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
+# CONFIG_CRYPTO_ECB is not set
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
+CONFIG_CRYPTO_CRC32C=y
+# CONFIG_CRYPTO_MD4 is not set
+# CONFIG_CRYPTO_MD5 is not set
+# CONFIG_CRYPTO_MICHAEL_MIC is not set
+# CONFIG_CRYPTO_RMD128 is not set
+# CONFIG_CRYPTO_RMD160 is not set
+# CONFIG_CRYPTO_RMD256 is not set
+# CONFIG_CRYPTO_RMD320 is not set
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
+# CONFIG_CRYPTO_ARC4 is not set
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
+# CONFIG_CRYPTO_ZLIB is not set
+# CONFIG_CRYPTO_LZO is not set
+
+#
+# Random Number Generation
+#
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
+# CONFIG_CRYPTO_HW is not set
+# CONFIG_BINARY_PRINTF is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+CONFIG_GENERIC_FIND_LAST_BIT=y
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_T10DIF is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+CONFIG_LIBCRC32C=y
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=y
+CONFIG_DECOMPRESS_GZIP=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
+CONFIG_NLATTR=y
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 17d3fbd..47e1dd5 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -460,6 +460,12 @@ config MACH_EZX_E2
 	default y
 	depends on PXA_EZX
 
+config MACH_XCEP
+	bool "Iskratel Electronics XCEP"
+	select PXA25x
+	select MTD_PHYSMAP
+	select PXA_SSP
+
 endmenu
 
 config PXA25x
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 682dbf4..ef553a3 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_PXA_EZX)           += ezx.o
 obj-$(CONFIG_MACH_INTELMOTE2)   += imote2.o
 obj-$(CONFIG_MACH_CSB726)	+= csb726.o
 obj-$(CONFIG_CSB726_CSB701)	+= csb701.o
+obj-$(CONFIG_MACH_XCEP)         += xcep.o
 
 # Support for blinky lights
 led-y := leds.o
diff --git a/arch/arm/mach-pxa/xcep.c b/arch/arm/mach-pxa/xcep.c
new file mode 100644
index 0000000..0cb868a
--- /dev/null
+++ b/arch/arm/mach-pxa/xcep.c
@@ -0,0 +1,200 @@
+/*  linux/arch/arm/mach-pxa/xcep.c
+ *
+ *  Support for the Iskratel Electronics XCEP platform.
+ *
+ *  Author:     Ales Bardorfer <ales@i-tech.si>
+ *  Updates by: Matej Kenda <matej.kenda@hermes-softlab.com>
+ *  Created:    June 2006
+ *  Copyright:  (C) 2006 Instrumentation Technologies
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/sysdev.h>
+#include <linux/major.h>
+#include <linux/fb.h>
+#include <linux/interrupt.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+#include <linux/i2c.h>
+
+#include <asm/setup.h>
+#include <asm/memory.h>
+#include <asm/mach-types.h>
+#include <mach/hardware.h>
+#include <asm/irq.h>
+#include <asm/sizes.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/flash.h>
+
+#include <mach/pxa2xx-regs.h>
+#include <mach/mfp-pxa25x.h>
+#include <mach/udc.h>
+#include <mach/irda.h>
+#include <mach/pxafb.h>
+#include <mach/mmc.h>
+#include <mach/i2c.h>
+
+#include "generic.h"
+
+
+#define XCEP_ETH_PHYS	0x0c000300
+#define XCEP_ETH_END    0x0c0fffff
+#define XCEP_ETH_IRQ	0
+
+/*  XCEP CPLD base */
+#define XCEP_CPLD_BASE  0xf0000000
+
+
+/* Flash partitions. */
+
+static struct mtd_partition xcep_partitions[] = {
+	{
+		.name =		"Bootloader",
+		.size =		0x00040000,
+		.offset =	0,
+		.mask_flags =	MTD_WRITEABLE  /* force read-only */
+	}, {
+		.name =		"Bootloader ENV",
+		.size =		0x00040000,
+		.offset =	0x00040000,
+		.mask_flags =	MTD_WRITEABLE  /* force read-only */
+	}, {
+		.name =		"Kernel",
+		.size =		0x00100000,
+		.offset =	0x00080000,
+	}, {
+		.name =		"Rescue fs",
+		.size =		0x00280000,
+		.offset =	0x00180000,
+	}, {
+		.name =		"Filesystem",
+		.size =		MTDPART_SIZ_FULL,
+		.offset =	0x00400000
+	}
+};
+
+static struct physmap_flash_data xcep_flash_data[] = {
+	{
+		.width		= 4,		/* bankwidth in bytes */
+		.parts		= xcep_partitions,
+		.nr_parts	= ARRAY_SIZE(xcep_partitions)
+	}
+};
+
+static struct resource flash_resource = {
+	.start	= PXA_CS0_PHYS,
+	.end	= PXA_CS0_PHYS + SZ_32M - 1,
+	.flags	= IORESOURCE_MEM,
+};
+
+static struct platform_device flash_device = {
+	.name	= "physmap-flash",
+	.id	= 0,
+	.dev 	= {
+		.platform_data = xcep_flash_data,
+	},
+	.resource = &flash_resource,
+	.num_resources = 1,
+};
+
+
+
+/* SMC LAN91C111 network controller. */
+
+static struct resource smc91x_resources[] = {
+	[0] = {
+		.name	= "smc91x-regs",
+		.start	= XCEP_ETH_PHYS,
+		.end	= XCEP_ETH_END,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_GPIO(XCEP_ETH_IRQ),
+		.end	= IRQ_GPIO(XCEP_ETH_IRQ),
+		.flags	= IORESOURCE_IRQ,
+	},
+	[2] = {
+		.name	= "smc91x-attrib",
+		.start	= 0x0e000000,
+		.end	= 0x0e0fffff,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device smc91x_device = {
+	.name		= "smc91x",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(smc91x_resources),
+	.resource	= smc91x_resources,
+};
+
+
+static struct map_desc xcep_io_desc[] __initdata = {
+	{	/* CPLD */
+		.virtual	= XCEP_CPLD_BASE,
+		.pfn		= __phys_to_pfn(0x10000000),
+		.length		= 0x00000100,
+		.type		= MT_DEVICE
+	}
+};
+
+
+static struct platform_device *devices[] __initdata = {
+	&flash_device,
+	&smc91x_device,
+};
+
+
+/* We have to state that there are HWMON devices on the I2C bus on XCEP.
+ * Drivers for HWMON verify capabilities of the adapter when loading and
+ * refuse to attach if the adapter doesn't support HWMON class of devices.
+ * See also Documentation/i2c/porting-clients. */
+static struct i2c_pxa_platform_data xcep_i2c_platform_data  = {
+	.class = I2C_CLASS_HWMON
+};
+
+
+static mfp_cfg_t xcep_pin_config[] __initdata = {
+    GPIO79_nCS_3	/* SMC 91C111 chip select. */
+};
+
+
+static void __init xcep_init(void)
+{
+	/* See Intel XScale Developer's Guide for details */
+	/* Set RDF and RDN to appropriate values (chip select 3 (smc91x)) */
+	MSC1 = (MSC1 & 0xffff) | 0xD5540000;
+	/* Set RDF and RDN to appropriate values (chip select 5 (fpga)) */
+	MSC2 = (MSC2 & 0xffff) | 0x72A00000;
+
+	platform_add_devices(ARRAY_AND_SIZE(devices));
+	pxa_set_i2c_info(&xcep_i2c_platform_data);
+}
+
+static void __init xcep_map_io(void)
+{
+	pxa_map_io();
+	iotable_init(ARRAY_AND_SIZE(xcep_io_desc));
+	pxa2xx_mfp_config(ARRAY_AND_SIZE(xcep_pin_config));
+}
+
+MACHINE_START(XCEP, "Iskratel XCEP")
+	.phys_io	= 0x80000000,
+	.io_pg_offst	= 0xf8000000,
+	.boot_params	= 0xa0000100,
+	.init_machine	= xcep_init,
+	.map_io		= xcep_map_io,
+	.init_irq	= pxa25x_init_irq,
+	.timer		= &pxa_timer,
+MACHINE_END
diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index 329f890..a9d20bc 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -400,6 +400,11 @@ static inline void LPD7_SMC_outsw (unsigned char* a, int r,
 
 #endif
 
+#if defined(CONFIG_MACH_XCEP)
+#define SMC_USE_PXA_DMA		1
+#endif
+
+
 
 /* store this information for the driver.. */
 struct smc_local {
-- 
1.6.1.3

