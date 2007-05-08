Return-Path: <linux-kernel-owner+w=401wt.eu-S969714AbXEHXLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969714AbXEHXLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968609AbXEHXKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:10:55 -0400
Received: from simq2-srv.bellnexxia.net ([206.47.199.152]:41267 "EHLO
	simq2-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968869AbXEHXKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:10:50 -0400
X-Greylist: delayed 1347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2007 19:10:49 EDT
Message-ID: <4640FE35.2070605@gmail.com>
Date: Tue, 08 May 2007 19:48:21 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
>
>
> - Added the git-battery tree to the -mm lineup (Anton Vorontsov
>   <cbou@mail.ru>).  It presently generates mysterious depmod error messages.
>
> - The staircase CPU scheduler was dropped
>
>
>
>   
x86_64 UP Athlon64 I get a crash on boot using SLUB.  Switching to SLAB 
makes it go away.  I don't have a serial console, so the best I have is 
a digital photo of as many lines as my VGA console was able to get (60 
or so).  Is there a better way to capture the oops output so that the 
full trace canbe seen?

http://picasaweb.google.com/kjwinchester/Linux/photo#5061982383505227842

config and dmesg from working SLAB configuration (broken when switched 
to SLUB):

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.21-mm1
# Mon May  7 21:28:56 2007
#
CONFIG_X86_64=y
CONFIG_64BIT=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ZONE_DMA32=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_NR_QUICK=2
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_CMPXCHG=y
CONFIG_EARLY_PRINTK=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_DMI=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SWAP_PREFETCH=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=19
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
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
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROC_SMAPS=y
CONFIG_PROC_CLEAR_REFS=y
CONFIG_PROC_PAGEMAP=y
CONFIG_PROC_KPAGEMAP=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0

#
# Loadable module support
#
# CONFIG_MODULES is not set

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
CONFIG_X86_PC=y
# CONFIG_X86_VSMP is not set
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_TSC=y
CONFIG_X86_GOOD_APIC=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_MTRR=y
# CONFIG_SMP is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_ADAPTIVE_READAHEAD=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HPET_TIMER=y
# CONFIG_HPET_EMULATE_RTC is not set
CONFIG_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_K8_NB=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_ISA_DMA_API=y
CONFIG_FREEZER=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set
# CONFIG_SOFTWARE_SUSPEND is not set

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SLEEP_PROC_FS=y
# CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_ACPI_CPUFREQ=y

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU idle PM support
#
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
# CONFIG_PCI_DOMAINS is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE=y
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set

#
# DCCP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP is not set

#
# SCTP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_SCTP is not set

#
# TIPC Configuration (EXPERIMENTAL)
#
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Block devices
#
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_BLINK is not set

#
# ATA/ATAPI/MFM/RLL support
#
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_ESP_CORE is not set
# CONFIG_SCSI_SRP is not set

#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACPI=y
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set

#
# Network device support
#
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_NET_SB1000 is not set

#
# ARCnet devices
#
# CONFIG_ARCNET is not set

#
# PHY device support
#
# CONFIG_PHYLIB is not set

#
# Ethernet (10 or 100Mbit)
#
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set

#
# Tulip family network device support
#
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_HP100 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_DGRS is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_VIA_RHINE_NAPI is not set
# CONFIG_SC92031 is not set

#
# Ethernet (1000 Mbit)
#
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
CONFIG_VIA_VELOCITY=y
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set

#
# Ethernet (10000 Mbit)
#
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_MLX4_ETHERNET is not set
# CONFIG_MLX4_CORE is not set
CONFIG_MLX4_DEBUG=y

#
# Token Ring devices
#
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_RTL818X is not set

#
# Wan interfaces
#
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=y
# CONFIG_PPPOE is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set

#
# Watchdog Cards
#
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
CONFIG_AGP_VIA=y
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_ISA=y
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set

#
# External power support
#
# CONFIG_EXTERNAL_POWER is not set

#
# Battery devices
#
# CONFIG_BATTERY is not set

#
# Hardware Monitoring support
#
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# Digital Video Broadcasting Devices
#
# CONFIG_DVB is not set
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_VGASTATE is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set

#
# Logo configuration
#
# CONFIG_LOGO is not set

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_RTCTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
CONFIG_SND_VIA82XX=y
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_AC97_POWER_SAVE=y

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID Devices
#
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
# CONFIG_HIDRAW is not set

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_SPLIT_ISO is not set
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_EHCI_BIG_ENDIAN_MMIO is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Input Devices
#
# CONFIG_USB_AIPTEK is not set
# CONFIG_USB_WACOM is not set
# CONFIG_USB_ACECAD is not set
# CONFIG_USB_KBTAB is not set
# CONFIG_USB_POWERMATE is not set
# CONFIG_USB_TOUCHSCREEN is not set
# CONFIG_USB_YEALINK is not set
# CONFIG_USB_XPAD is not set
# CONFIG_USB_ATI_REMOTE is not set
# CONFIG_USB_ATI_REMOTE2 is not set
# CONFIG_USB_KEYSPAN_REMOTE is not set
# CONFIG_USB_APPLETOUCH is not set
# CONFIG_USB_GTCO is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_GOTEMP is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set

#
# MMC/SD Card support
#
# CONFIG_MMC is not set

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#
# CONFIG_EDAC is not set

#
# Real Time Clock
#
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set

#
# DMA Devices
#

#
# Auxiliary Display support
#

#
# Virtualization
#
# CONFIG_KVM is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISER4_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

#
# Layered filesystems
#
# CONFIG_UNION_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set

#
# Instrumentation Support
#
CONFIG_PROFILING=y
CONFIG_OPROFILE=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_LIST is not set
CONFIG_FRAME_POINTER=y
# CONFIG_FORCED_INLINING is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_INTEGRITY is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set

#
# Cryptographic options
#
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set

#
# Hardware crypto devices
#

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
# CONFIG_CRC16 is not set
CONFIG_CRC32=y
# CONFIG_CRC_ITU_T is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

[    0.000000] Linux version 2.6.21-mm1 (kevin@kevin) (gcc version 4.1.2 
(Gentoo 4.1.2)) #1 PREEMPT Mon May 7 21:37:07 ADT 2007
[    0.000000] Command line: root=/dev/sda3
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
[    0.000000]  BIOS-e820: 000000001fef0000 - 000000001fef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001fef3000 - 000000001ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 130800) 1 entries of 
256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F77D0, 0014 (r0 VIAK8T)
[    0.000000] ACPI: RSDT 1FEF3040, 0034 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: FACP 1FEF30C0, 0074 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: DSDT 1FEF3180, 4F8A (r1 VIAK8T AWRDACPI     1000 
MSFT  100000E)
[    0.000000] ACPI: FACS 1FEF0000, 0040
[    0.000000] ACPI: BOOT 1FEF8180, 0028 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: SSDT 1FEF82C0, 00B5 (r1 PTLTD  POWERNOW        1  
LTP        1)
[    0.000000] ACPI: APIC 1FEF8200, 0068 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 130800) 1 entries of 
256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   130800
[    0.000000] On node 0 totalpages: 130703
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1377 pages reserved
[    0.000000]   DMA zone: 2566 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1732 pages used for memmap
[    0.000000]   DMA32 zone: 124972 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 
1ff00000:ded00000)
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 127538
[    0.000000] Kernel command line: root=/dev/sda3
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 16384 bytes)
[    0.000000] time.c: Detected 1838.852 MHz processor.
[    0.002000] Console: colour VGA+ 80x25
[    0.003000] Dentry cache hash table entries: 65536 (order: 7, 524288 
bytes)
[    0.004000] Inode-cache hash table entries: 32768 (order: 6, 262144 
bytes)
[    0.004000] Checking aperture...
[    0.004000] CPU 0: aperture @ e0000000 size 128 MB
[    0.009000] Memory: 508916k/523200k available (3271k kernel code, 
13560k reserved, 1272k data, 196k init)
[    0.069000] Calibrating delay using timer specific routine.. 3680.30 
BogoMIPS (lpj=1840151)
[    0.069000] Mount-cache hash table entries: 256
[    0.069000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.069000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.069000] CPU: AMD Athlon(tm) 64 Processor 3000+ stepping 00
[    0.069000] ACPI: Core revision 20070126
[    0.082000] Using local APIC timer interrupts.
[    0.082000] result 12769814
[    0.082000] Detected 12.769 MHz APIC timer.
[    0.083030] NET: Registered protocol family 16
[    0.083170] ACPI: bus type pci registered
[    0.083247] PCI: Using configuration type 1
[    0.087896] ACPI: Interpreter enabled
[    0.087971] ACPI: (supports S0 S3 S4 S5)
[    0.088247] ACPI: Using IOAPIC for interrupt routing
[    0.093726] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.094593] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.142294] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12) *5
[    0.142900] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
[    0.143464] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 6 7 10 11 12)
[    0.144016] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) 
*0, disabled.
[    0.144661] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) 
*0, disabled.
[    0.145305] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) 
*0, disabled.
[    0.145961] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 *10 11 12)
[    0.146497] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) 
*0, disabled.
[    0.147171] ACPI: PCI Interrupt Link [ALKA] (IRQs *20)
[    0.147501] ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
[    0.147833] ACPI: PCI Interrupt Link [ALKC] (IRQs *22)
[    0.148188] ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
[    0.148472] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.148555] pnp: PnP ACPI init
[    0.148633] ACPI: bus type pnp registered
[    0.151238] pnp: PnP ACPI: found 8 devices
[    0.151309] ACPI: ACPI bus type pnp unregistered
[    0.151469] SCSI subsystem initialized
[    0.151562] libata version 2.20 loaded.
[    0.151605] usbcore: registered new interface driver usbfs
[    0.151700] usbcore: registered new interface driver hub
[    0.151804] usbcore: registered new device driver usb
[    0.151920] PCI: Using ACPI for IRQ routing
[    0.151992] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[    0.152103] PCI: Cannot allocate resource region 0 of device 0000:00:00.0
[    0.152276] agpgart: Detected AGP bridge 0
[    0.155822] agpgart: AGP aperture is 128M @ 0xe0000000
[    0.155959] pnp: 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.156035] pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
[    0.156110] pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
[    0.156185] pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
[    0.156266] pnp: 00:02: ioport range 0x4000-0x407f has been reserved
[    0.156341] pnp: 00:02: ioport range 0x5000-0x500f has been reserved
[    0.156651] PCI: Bridge: 0000:00:01.0
[    0.156723]   IO window: c000-cfff
[    0.156795] Time: tsc clocksource has been installed.
[    0.156872]   MEM window: f8000000-f80fffff
[    0.156945]   PREFETCH window: e8000000-f7ffffff
[    0.157027] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.157053] NET: Registered protocol family 2
[    0.165752] IP route cache hash table entries: 4096 (order: 3, 32768 
bytes)
[    0.165865] TCP established hash table entries: 16384 (order: 6, 
262144 bytes)
[    0.166080] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[    0.166231] TCP: Hash tables configured (established 16384 bind 16384)
[    0.166306] TCP reno registered
[    0.168850] Simple Boot Flag at 0x37 set to 0x80
[    0.169541] NTFS driver 2.1.28 [Flags: R/O].
[    0.169647] io scheduler noop registered
[    0.169734] io scheduler cfq registered (default)
[    0.169878] Boot video device is 0000:01:00.0
[    0.169962] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    0.170154] radeonfb: Found Intel x86 BIOS ROM Image
[    0.170228] radeonfb: Retrieved PLL infos from BIOS
[    0.170301] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=200.00 
Mhz, System=166.00 MHz
[    0.170404] radeonfb: PLL min 20000 max 40000
[    0.246253] i2c-adapter i2c-1: unable to read EDID block.
[    0.365034] i2c-adapter i2c-1: unable to read EDID block.
[    0.483825] i2c-adapter i2c-1: unable to read EDID block.
[    0.602673] i2c-adapter i2c-3: unable to read EDID block.
[    0.721465] i2c-adapter i2c-3: unable to read EDID block.
[    0.840256] i2c-adapter i2c-3: unable to read EDID block.
[    1.093111] radeonfb: Monitor 1 type CRT found
[    1.093183] radeonfb: EDID probed
[    1.093253] radeonfb: Monitor 2 type no found
[    1.093547] radeonfb (0000:01:00.0): ATI Radeon Yd
[    1.093775] input: Power Button (FF) as 
/devices/acpi_system:00/button_power:00/input/input0
[    1.093879] ACPI: Power Button (FF) [PWRF]
[    1.094015] input: Power Button (CM) as 
/devices/acpi_system:00/device:00/PNP0C0C:00/input/input1
[    1.094127] ACPI: Power Button (CM) [PWRB]
[    1.096205] Real Time Clock Driver v1.12ac
[    1.096304] Software Watchdog Timer: 0.07 initialized. soft_noboot=0 
soft_margin=60 sec (nowayout= 0)
[    1.096410] Linux agpgart interface v0.102 (c) Dave Jones
[    1.096526] [drm] Initialized drm 1.1.0 20060810
[    1.096721] [drm] Initialized radeon 1.25.0 20060524 on minor 0
[    1.096807] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 
seconds, margin is 60 seconds).
[    1.096911] Hangcheck: Using get_cycles().
[    1.096983] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing disabled
[    1.097367] loop: module loaded
[    1.097471] via-rhine: Broken BIOS detected, avoid_D3 enabled.
[    1.097590] VIA Networking Velocity Family Gigabit Ethernet Adapter 
Driver Ver. 1.14
[    1.097693] Copyright (c) 2002, 2003 VIA Networking Technologies, Inc.
[    1.097768] Copyright (c) 2004 Red Hat Inc.
[    1.097854] ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 22 (level, 
low) -> IRQ 22
[    1.098747] eth0: VIA Networking Velocity Family Gigabit Ethernet Adapter
[    1.098823] eth0: Ethernet Address: 00:50:8D:D1:28:BB
[    1.109148] PPP generic driver version 2.4.2
[    1.109273] PPP MPPE Compression module registered
[    1.109434] pata_via 0000:00:0f.1: version 0.3.1
[    1.109668] ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
[    1.109744] ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI 
20 (level, low) -> IRQ 20
[    1.110044] scsi0 : pata_via
[    1.110163] scsi1 : pata_via
[    1.110268] ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 
0x00000000000103f6 bmdma 0x000000000001e300 irq 14
[    1.110376] ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl 
0x0000000000010376 bmdma 0x000000000001e308 irq 15
[    1.568472] ata1.00: ATAPI, max UDMA/33
[    1.568546] ata1.01: ATAPI, max UDMA/33
[    1.725191] ata1.00: configured for UDMA/33
[    1.881916] ata1.01: configured for UDMA/33
[    2.070706] ata2.00: ata_hpa_resize 1: sectors = 156301488, 
hpa_sectors = 156301488
[    2.070809] ata2.00: ATA-6: WDC WD800JB-00JJA0, 05.01C05, max UDMA/100
[    2.070883] ata2.00: 156301488 sectors, multi 16: LBA
[    2.074666] ata2.00: ata_hpa_resize 1: sectors = 156301488, 
hpa_sectors = 156301488
[    2.074771] ata2.00: configured for UDMA/100
[    2.075438] scsi 0:0:0:0: CD-ROM            COMPAQ   DVD-ROM DRD8120B 
1.10 PQ: 0 ANSI: 5
[    2.078745] sr0: scsi3-mmc drive: 0x/40x cd/rw xa/form2 cdda tray
[    2.078820] Uniform CD-ROM driver Revision: 3.20
[    2.078939] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.078983] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.079287] scsi 0:0:1:0: CD-ROM            HL-DT-ST CD-RW GCE-8525B  
1.03 PQ: 0 ANSI: 5
[    2.083058] sr1: scsi3-mmc drive: 40x/52x writer cd/rw xa/form2 cdda tray
[    2.083174] sr 0:0:1:0: Attached scsi CD-ROM sr1
[    2.083214] sr 0:0:1:0: Attached scsi generic sg1 type 5
[    2.083340] scsi 1:0:0:0: Direct-Access     ATA      WDC WD800JB-00JJ 
05.0 PQ: 0 ANSI: 5
[    2.083513] sd 1:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    2.083594] sd 1:0:0:0: [sda] Write Protect is off
[    2.083668] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.083679] sd 1:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.083813] sd 1:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    2.083893] sd 1:0:0:0: [sda] Write Protect is off
[    2.083966] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.083977] sd 1:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.084083]  sda: sda1 sda2 sda3
[    2.091965] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.092080] sd 1:0:0:0: Attached scsi generic sg2 type 0
[    2.092218] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, 
low) -> IRQ 21
[    2.092376] ehci_hcd 0000:00:10.4: EHCI Host Controller
[    2.092487] ehci_hcd 0000:00:10.4: new USB bus registered, assigned 
bus number 1
[    2.092626] ehci_hcd 0000:00:10.4: irq 21, io mem 0xf8120000
[    2.092704] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 
10 Dec 2004
[    2.092829] usb usb1: new device found, idVendor=0000, idProduct=0000
[    2.092902] usb usb1: new device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.092978] usb usb1: Product: EHCI Host Controller
[    2.093050] usb usb1: Manufacturer: Linux 2.6.21-mm1 ehci_hcd
[    2.093123] usb usb1: SerialNumber: 0000:00:10.4
[    2.093292] usb usb1: configuration #1 chosen from 1 choice
[    2.093400] hub 1-0:1.0: USB hub found
[    2.093476] hub 1-0:1.0: 8 ports detected
[    2.194236] USB Universal Host Controller Interface driver v3.0
[    2.194355] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, 
low) -> IRQ 21
[    2.194501] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    2.194596] uhci_hcd 0000:00:10.0: new USB bus registered, assigned 
bus number 2
[    2.194715] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000e400
[    2.194829] usb usb2: new device found, idVendor=0000, idProduct=0000
[    2.194903] usb usb2: new device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.194977] usb usb2: Product: UHCI Host Controller
[    2.195050] usb usb2: Manufacturer: Linux 2.6.21-mm1 uhci_hcd
[    2.195124] usb usb2: SerialNumber: 0000:00:10.0
[    2.195275] usb usb2: configuration #1 chosen from 1 choice
[    2.195379] hub 2-0:1.0: USB hub found
[    2.195453] hub 2-0:1.0: 2 ports detected
[    2.296058] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, 
low) -> IRQ 21
[    2.296202] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    2.296298] uhci_hcd 0000:00:10.1: new USB bus registered, assigned 
bus number 3
[    2.296417] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000e500
[    2.296523] usb usb3: new device found, idVendor=0000, idProduct=0000
[    2.296598] usb usb3: new device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.296673] usb usb3: Product: UHCI Host Controller
[    2.296745] usb usb3: Manufacturer: Linux 2.6.21-mm1 uhci_hcd
[    2.296818] usb usb3: SerialNumber: 0000:00:10.1
[    2.296967] usb usb3: configuration #1 chosen from 1 choice
[    2.297071] hub 3-0:1.0: USB hub found
[    2.297146] hub 3-0:1.0: 2 ports detected
[    2.397878] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, 
low) -> IRQ 21
[    2.398021] uhci_hcd 0000:00:10.2: UHCI Host Controller
[    2.398118] uhci_hcd 0000:00:10.2: new USB bus registered, assigned 
bus number 4
[    2.398235] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e600
[    2.398340] usb usb4: new device found, idVendor=0000, idProduct=0000
[    2.398415] usb usb4: new device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.398490] usb usb4: Product: UHCI Host Controller
[    2.398562] usb usb4: Manufacturer: Linux 2.6.21-mm1 uhci_hcd
[    2.398635] usb usb4: SerialNumber: 0000:00:10.2
[    2.398783] usb usb4: configuration #1 chosen from 1 choice
[    2.398888] hub 4-0:1.0: USB hub found
[    2.398964] hub 4-0:1.0: 2 ports detected
[    2.499704] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, 
low) -> IRQ 21
[    2.499848] uhci_hcd 0000:00:10.3: UHCI Host Controller
[    2.499945] uhci_hcd 0000:00:10.3: new USB bus registered, assigned 
bus number 5
[    2.500063] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000e700
[    2.500172] usb usb5: new device found, idVendor=0000, idProduct=0000
[    2.500246] usb usb5: new device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.500321] usb usb5: Product: UHCI Host Controller
[    2.500393] usb usb5: Manufacturer: Linux 2.6.21-mm1 uhci_hcd
[    2.500466] usb usb5: SerialNumber: 0000:00:10.3
[    2.500623] usb usb5: configuration #1 chosen from 1 choice
[    2.500728] hub 5-0:1.0: USB hub found
[    2.500802] hub 5-0:1.0: 2 ports detected
[    2.601517] Initializing USB Mass Storage driver...
[    2.709278] usb 2-1: new low speed USB device using uhci_hcd and 
address 2
[    2.879618] usb 2-1: new device found, idVendor=045e, idProduct=00b0
[    2.879692] usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
[    2.879767] usb 2-1: Product: Microsoft® Digital Media Pro Keyboard
[    2.879840] usb 2-1: Manufacturer: Microsoft
[    2.879992] usb 2-1: configuration #1 chosen from 1 choice
[    3.087615] usb 2-2: new low speed USB device using uhci_hcd and 
address 3
[    3.247968] usb 2-2: new device found, idVendor=046d, idProduct=c00c
[    3.248042] usb 2-2: new device strings: Mfr=1, Product=2, SerialNumber=0
[    3.248116] usb 2-2: Product: USB Mouse
[    3.248187] usb 2-2: Manufacturer: Logitech
[    3.248344] usb 2-2: configuration #1 chosen from 1 choice
[    3.873251] usbcore: registered new interface driver usb-storage
[    3.873325] USB Mass Storage support registered.
[    3.873477] PNP: No PS/2 controller found. Probing ports directly.
[    3.875613] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.875706] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.875840] mice: PS/2 mouse device common for all mice
[    3.876015] i2c /dev entries driver
[    3.876360] w83627hf: Found W83627HF chip at 0x290
[    4.205354] w83627hf w83627hf.656: Enabling temp2, readings might not 
make sense
[    4.205488] w83627hf w83627hf.656: Enabling temp3, readings might not 
make sense
[    4.226903] abituguru: testing bank1 sensor 0
[    4.247018] abituguru:   alarm not raised during volt sensor test
[    4.297454] abituguru:   found temp sensor
[    4.298069] abituguru: testing bank1 sensor 1
[    4.318867] abituguru:   alarm not raised during volt sensor test
[    4.369332] abituguru:   found temp sensor
[    4.369949] abituguru: testing bank1 sensor 3
[    4.391276] abituguru:   found volt sensor
[    4.391893] abituguru: testing bank1 sensor 4
[    4.412234] abituguru:   found volt sensor
[    4.412852] abituguru: testing bank1 sensor 10
[    4.434236] abituguru:   found volt sensor
[    4.434854] abituguru: testing bank1 sensor 8
[    4.455172] abituguru:   found volt sensor
[    4.455789] abituguru: testing bank1 sensor 14
[    4.477149] abituguru:   found volt sensor
[    4.477766] abituguru: testing bank1 sensor 2
[    4.499050] abituguru:   found volt sensor
[    4.499667] abituguru: testing bank1 sensor 9
[    4.519988] abituguru:   found volt sensor
[    4.520605] abituguru: testing bank1 sensor 6
[    4.540994] abituguru:   found volt sensor
[    4.541611] abituguru: testing bank1 sensor 5
[    4.562013] abituguru:   found volt sensor
[    4.562628] abituguru: testing bank1 sensor 11
[    4.582943] abituguru:   found volt sensor
[    4.583560] abituguru: testing bank1 sensor 15
[    4.603339] abituguru:   alarm not raised during volt sensor test
[    4.653794] abituguru:   found temp sensor
[    4.654408] abituguru: testing bank1 sensor 13
[    4.674717] abituguru:   found volt sensor
[    4.675334] abituguru: testing bank1 sensor 7
[    4.695198] abituguru:   alarm not raised during volt sensor test
[    4.745121] abituguru:   alarm not raised during temp sensor test
[    4.745898] abituguru: testing bank1 sensor 12
[    4.766101] abituguru:   alarm not raised during volt sensor test
[    4.815984] abituguru:   alarm not raised during temp sensor test
[    4.816334] abituguru: detecting number of fan sensors
[    4.816337] abituguru:   bank2 sensor 5 does not seem to be a fan 
sensor: the threshold (0) is below the minimum (5)
[    4.816339] abituguru:  found: 5 fan sensors
[    4.816346] abituguru: detecting number of PWM outputs
[    4.816349] abituguru:   pwm channel 3 does not seem to be a pwm 
channel: settings[0] = C9
[    4.816351] abituguru:  found: 3 PWM outputs
[    4.816357] abituguru: found Abit uGuru
[    4.830382] input: Microsoft Microsoft® Digital Media Pro Keyboard as 
/devices/pci0000:00/0000:00:10.0/usb2/2-1/2-1:1.0/input/input2
[    4.830523] input: USB HID v1.11 Keyboard [Microsoft Microsoft® 
Digital Media Pro Keyboard] on usb-0000:00:10.0-1
[    4.859261] input: Microsoft Microsoft® Digital Media Pro Keyboard as 
/devices/pci0000:00/0000:00:10.0/usb2/2-1/2-1:1.1/input/input3
[    4.859397] input: USB HID v1.11 Device [Microsoft Microsoft® Digital 
Media Pro Keyboard] on usb-0000:00:10.0-1
[    4.874248] input: Logitech USB Mouse as 
/devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.0/input/input4
[    4.874403] input: USB HID v1.10 Mouse [Logitech USB Mouse] on 
usb-0000:00:10.0-2
[    4.874589] usbcore: registered new interface driver usbhid
[    4.874663] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    4.874755] Advanced Linux Sound Architecture Driver Version 
1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).
[    4.875035] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, 
low) -> IRQ 22
[    4.875313] PCI: Setting latency timer of device 0000:00:11.5 to 64
[    5.388169] ALSA device list:
[    5.388241]   #0: VIA 8237 with ALC658D at 0xd800, irq 22
[    5.388337] oprofile: using NMI interrupt.
[    5.388414] GRE over IPv4 tunneling driver
[    5.388577] TCP cubic registered
[    5.388667] NET: Registered protocol family 1
[    5.388740] NET: Registered protocol family 17
[    5.388818] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3000+ 
processors (version 2.00.00)
[    5.388950] powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x6
[    5.389023] powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0x12
[    5.400395] EXT3-fs: INFO: recovery required on readonly filesystem.
[    5.400470] EXT3-fs: write access will be enabled during recovery.
[   11.867629] kjournald starting.  Commit interval 5 seconds
[   11.867717] EXT3-fs: recovery complete.
[   11.868068] EXT3-fs: mounted filesystem with ordered data mode.
[   11.868155] VFS: Mounted root (ext3 filesystem) readonly.
[   11.868243] Freeing unused kernel memory: 196k freed
[   14.296805] EXT3 FS on sda3, internal journal
[   15.453969] Adding 1004052k swap on /dev/sda2.  Priority:-1 extents:1 
across:1004052k
[   25.362182] agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
[   25.362196] agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
[   25.362247] agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
[   25.493979] Velocity is AUTO mode
[   25.648542] [drm] Setting GART location based on new memory map
[   25.648624] [drm] Loading R200 Microcode
[   25.648689] [drm] writeback test succeeded in 1 usecs
[   28.619782] eth0: Link autonegation speed 100M bps full duplex



