Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYFLGTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYFLGTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYFLGT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:19:27 -0400
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:65333 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYFLGTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:19:22 -0400
Message-ID: <4850BFE1.7080603@freemail.hu>
Date: Thu, 12 Jun 2008 08:19:13 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression][bisected] ~90,000 wakeups as of 2.6.26-rc3
References: <4844D414.7010402@freemail.hu> <20080609114132.GA5028@elte.hu>
In-Reply-To: <20080609114132.GA5028@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------060901040904040705010506"
X-DCC--Metrics: mail01a.mail.t-online.hu 0; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060901040904040705010506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Ingo Molnar wrote:
> * Németh Márton <nm127@freemail.hu> wrote:
> 
>> Hi,
>>
>> there is a problem in 2.6.26-rc3 which was not there in case of 
>> 2.6.25: the CPU wakes up ~90,000 times per sec instead of ~60 per sec.
>>
>> I also "git bisected" the problem, the result is:
>>
>> 6e908947b4995bc0e551a8257c586d5c3e428201 is first bad commit
>> commit 6e908947b4995bc0e551a8257c586d5c3e428201
>> Author: Ingo Molnar <mingo@elte.hu>
>> Date:   Fri Mar 21 14:32:36 2008 +0100
>>
>>     x86: fix ioapic bug again
> 
> thanks for tracking this down. Could you check whether the problem is 
> also fixed in latest -tip? In particular the tip/x86/apic branch should 
> properly solve this. You can pick up -tip via:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> but those tip/x86/apic fixes are too intrusive for v2.6.26, so i've 
> queued up your revert into tip/x86/urgent, for v2.6.26 merging. Would be 
> nice if you could check -tip though, to make sure we dont reintroduce 
> the same problem again in v2.6.27.

I tested 2.6.26-rc5-00996-gb7d80d3 with the attached .config. I get ~50
wakeups per second which I guess is caused by the lack of hardware. I
also attached the full dmesg. Passed.

	Márton Németh


--------------060901040904040705010506
Content-Type: text/plain;
 name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.26-rc5
# Thu Jun 12 07:35:34 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
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
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
# CONFIG_NAMESPACES is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
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
CONFIG_PROFILING=y
# CONFIG_MARKERS is not set
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_HAVE_IMMEDIATE=y
CONFIG_IMMEDIATE=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

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
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
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
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_WMI is not set
CONFIG_ACPI_ASUS=m
CONFIG_ACPI_TOSHIBA=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
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
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

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
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
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
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
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
# CONFIG_NET_SCHED is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set

#
# Selecting 'y' for an algorithm will
#

#
# build the algorithm into mac80211.
#
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
# CONFIG_MAC80211_DEBUG is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=m
CONFIG_IEEE80211_CRYPT_CCMP=m
CONFIG_IEEE80211_CRYPT_TKIP=m
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y
CONFIG_IDE_MAX_HWIFS=4
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_BLK_DEV_HD_ONLY is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

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
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=m
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=m
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CORGI=m
CONFIG_BACKLIGHT_PROGEAR=m

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
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
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

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
# CONFIG_MINIX_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="iso8859-2"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
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
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_LKDTM is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_TRACING=y
# CONFIG_FTRACE is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_NONPROMISC_DEVMEM is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_MMIOTRACE_HOOKS=y
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_MANAGER=m
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=m
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=m
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--------------060901040904040705010506
Content-Type: text/plain;
 name="dmesg-2.6.26-rc5-00996-gb7d80d3.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-2.6.26-rc5-00996-gb7d80d3.txt"

[    0.000000] Linux version 2.6.26-rc5-00996-gb7d80d3 (nmarci@europa) (gcc version 4.2.3 (Debian 4.2.3-2)) #1 PREEMPT Thu Jun 12 07:49:44 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003bf70000 (usable)
[    0.000000]  BIOS-e820: 000000003bf70000 - 000000003bf7a000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003bf7a000 - 000000003bf80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003bf80000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 245616) 1 entries of 256 used
[    0.000000] last_pfn = 245616 max_arch_pfn = 1048576
[    0.000000] 63MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 00c00000
[    0.000000]   low ram: 0065c000 - 38000000
[    0.000000]   bootmap 0065c000 - 00663000
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [100000-65824f] TEXT DATA BSS
[    0.000000]   early res: 2 [659000-65bfff] INIT_PG_TABLE
[    0.000000]   early res: 3 [9f800-fffff] BIOS reserved
[    0.000000]   early res: 4 [65c000-662fff] BOOTMAP
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f6870] 000f6870
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 245616) 1 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   245616
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   245616
[    0.000000] On node 0 totalpages: 245519
[    0.000000] free_area_init_node: node 0, pgdat c03bcae0, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 127 pages used for memmap
[    0.000000]   HighMem zone: 16113 pages, LIFO batch:3
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F68D0, 0014 (r0 PTLTD )
[    0.000000] ACPI: RSDT 3BF7600B, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
[    0.000000] ACPI: FACP 3BF79E87, 0074 (r1 AMDK8  PTLTW     6040000 PTL_    F4240)
[    0.000000] ACPI: DSDT 3BF7603B, 3E4C (r1  VIA   PTL_ACPI  6040000 MSFT  100000E)
[    0.000000] ACPI: FACS 3BF7AFC0, 0040
[    0.000000] ACPI: SSDT 3BF79EFB, 00B5 (r1 PTLTD  POWERNOW  6040000  LTP        1)
[    0.000000] ACPI: APIC 3BF79FB0, 0050 (r1 PTLTD  	 APIC    6040000  LTP        0)
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bffe0000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 243600
[    0.000000] Kernel command line: root=/dev/hda3 ro clocksource=acpi_pm log_buf_len=128M
[    0.000000] log_buf_len: 134217728
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1603.756 MHz processor.
[    0.010000] Console: colour VGA+ 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.010000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.010000] ... MAX_LOCK_DEPTH:          48
[    0.010000] ... MAX_LOCKDEP_KEYS:        2048
[    0.010000] ... CLASSHASH_SIZE:           1024
[    0.010000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.010000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.010000] ... CHAINHASH_SIZE:          8192
[    0.010000]  memory used by lock dependency info: 992 kB
[    0.010000]  per task-struct memory footprint: 1920 bytes
[    0.010000] ------------------------
[    0.010000] | Locking API testsuite:
[    0.010000] ----------------------------------------------------------------------------
[    0.010000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.010000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.010000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.010000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.010000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.010000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.010000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.010000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.010000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.010000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.010000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.010000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.010000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq read-recursion/123:  ok  |
[    0.010000]       soft-irq read-recursion/123:  ok  |
[    0.010000]       hard-irq read-recursion/132:  ok  |
[    0.010000]       soft-irq read-recursion/132:  ok  |
[    0.010000]       hard-irq read-recursion/213:  ok  |
[    0.010000]       soft-irq read-recursion/213:  ok  |
[    0.010000]       hard-irq read-recursion/231:  ok  |
[    0.010000]       soft-irq read-recursion/231:  ok  |
[    0.010000]       hard-irq read-recursion/312:  ok  |
[    0.010000]       soft-irq read-recursion/312:  ok  |
[    0.010000]       hard-irq read-recursion/321:  ok  |
[    0.010000]       soft-irq read-recursion/321:  ok  |
[    0.010000] -------------------------------------------------------
[    0.010000] Good, all 218 testcases passed! |
[    0.010000] ---------------------------------
[    0.010000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.010000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.010000] Memory: 836864k/982464k available (2025k kernel code, 145080k reserved, 867k data, 200k init, 64960k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
[    0.010000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.010000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.010000]       .init : 0xc03d6000 - 0xc0408000   ( 200 kB)
[    0.010000]       .data : 0xc02fa575 - 0xc03d3370   ( 867 kB)
[    0.010000]       .text : 0xc0100000 - 0xc02fa575   (2025 kB)
[    0.010000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.010000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.160354] Calibrating delay using timer specific routine.. 3211.15 BogoMIPS (lpj=16055782)
[    0.161496] Mount-cache hash table entries: 512
[    0.162447] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.162508] CPU: L2 Cache: 128K (64 bytes/line)
[    0.162571] CPU: AMD Mobile AMD Sempron(tm) Processor 2600+ stepping 00
[    0.162757] Checking 'hlt' instruction... OK.
[    0.200665] Freeing SMP alternatives: 0k freed
[    0.200720] ACPI: Core revision 20080321
[    0.209045] Parsing all Control Methods:
[    0.209436] Table [DSDT](id 0001) - 480 Objects with 49 Devices 147 Methods 13 Regions
[    0.209642] Parsing all Control Methods:
[    0.210000] Table [SSDT](id 0002) - 3 Objects with 0 Devices 0 Methods 0 Regions
[    0.210000]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
[    0.211696] evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
[    0.212704] ENABLING IO-APIC IRQs
[    0.213094] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
[    0.320000] net_namespace: 256 bytes
[    0.320000] NET: Registered protocol family 16
[    0.320000] ACPI: bus type pci registered
[    0.320000] PCI: PCI BIOS revision 2.10 entry at 0xfd88c, last bus=1
[    0.320000] PCI: Using configuration type 1 for base access
[    0.320000] Setting up standard PCI resources
[    0.325736] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs on int 0xA
[    0.326023] ACPI: EC: Look up EC in DSDT
[    0.329869] Completing Region/Field/Buffer/Package initialization:.............................................................
[    0.337094] Initialized 11/13 Regions 1/1 Fields 23/24 Buffers 26/26 Packages (492 nodes)
[    0.337212] Initializing Device/Processor/Thermal objects by executing _INI methods:.
[    0.337563] Executed 1 _INI methods requiring 1 _STA executions (examined 53 objects)
[    0.337881] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 4 Wake, Enabled 0 Runtime GPEs in this block
[    0.338099] ACPI: Interpreter enabled
[    0.338152] ACPI: (supports S0 S5)
[    0.338299] ACPI: Using IOAPIC for interrupt routing
[    0.351726] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.850041] ACPI: EC: missing confirmations, switch off interrupt mode.
[    0.853907] ACPI: EC: GPE = 0xb, I/O: command/status = 0x66, data = 0x62
[    0.853971] ACPI: EC: driver started in poll mode
[    0.854262] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.855655] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.855720] pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
[    0.855780] pci 0000:00:11.0: quirk: region 8100-810f claimed by vt8235 SMB
[    0.856385] bus 00 -> node 0
[    0.856404] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.878732] ACPI: PCI Interrupt Link [ALKA] (IRQs 16 17 18 19 20 21 22 23) *9, disabled.
[    0.879442] ACPI: PCI Interrupt Link [ALKB] (IRQs 16 17 18 19 20 21 22 23) *11, disabled.
[    0.880266] ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *10, disabled.
[    0.880685] ACPI: PCI Interrupt Link [ALKD] (IRQs 21) *5, disabled.
[    0.881214] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *9 12 14 15)
[    0.881903] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 12 14 15) *11
[    0.882629] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 11 12 14 15) *10
[    0.883353] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.884449] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.884636] pnp: PnP ACPI init
[    0.884731] ACPI: bus type pnp registered
[    0.884888] pnp 00:00: parse allocated resources
[    0.886763] pnp 00:00:   add io  0xcf8-0xcff flags 0x1
[    0.887010] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.887655] pnp 00:01: parse allocated resources
[    0.887670] pnp 00:01:   add dma 4 flags 0x4
[    0.887673] pnp 00:01:   add io  0x0-0xf flags 0x1
[    0.887676] pnp 00:01:   add io  0x81-0x8f flags 0x1
[    0.887678] pnp 00:01:   add io  0xc0-0xdf flags 0x1
[    0.887681] pnp 00:01:   add io  0x92-0x92 flags 0x1
[    0.887684] pnp 00:01:   add io  0xa8-0xa9 flags 0x1
[    0.887897] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.887973] pnp 00:02: parse allocated resources
[    0.887984] pnp 00:02:   add io  0x70-0x75 flags 0x0
[    0.887998] pnp 00:02:   add irq 8 flags 0x1
[    0.888180] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.888294] pnp 00:03: parse allocated resources
[    0.888305] pnp 00:03:   add io  0xf0-0xff flags 0x1
[    0.888314] pnp 00:03:   add irq 13 flags 0x1
[    0.888495] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.888618] pnp 00:04: parse allocated resources
[    0.888628] pnp 00:04:   add io  0x61-0x61 flags 0x1
[    0.888818] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.888890] pnp 00:05: parse allocated resources
[    0.888965] pnp 00:05:   add mem 0x0-0x9ffff flags 0x1
[    0.888968] pnp 00:05:   add mem 0xe0000-0xfffff flags 0x0
[    0.888972] pnp 00:05:   add mem 0xfff00000-0xffffffff flags 0x0
[    0.888975] pnp 00:05:   add mem 0xffee0000-0xffefffff flags 0x0
[    0.888978] pnp 00:05:   add mem 0xfec00000-0xfec00fff flags 0x0
[    0.888981] pnp 00:05:   add mem 0xfee00000-0xfee00fff flags 0x0
[    0.888985] pnp 00:05: PNP0c01: calling quirk_system_pci_resources+0x0/0x1b0
[    0.889265] pnp 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.889346] pnp 00:06: parse allocated resources
[    0.889603] pnp 00:06:   add io  0x80-0x80 flags 0x1
[    0.889607] pnp 00:06:   add io  0x4d0-0x4d1 flags 0x1
[    0.889610] pnp 00:06:   add io  0xfe10-0xfe11 flags 0x1
[    0.889613] pnp 00:06:   add io  0xfe00-0xfe00 flags 0x1
[    0.889616] pnp 00:06:   add io  0x4000-0x407f flags 0x1
[    0.889618] pnp 00:06:   add io  0x8100-0x811f flags 0x1
[    0.889621] pnp 00:06:   add io  0x2e-0x2f flags 0x1
[    0.889626] pnp 00:06: PNP0c02: calling quirk_system_pci_resources+0x0/0x1b0
[    0.889917] pnp 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.890027] pnp 00:07: parse allocated resources
[    0.890051] pnp 00:07:   add irq 12 flags 0x1
[    0.890249] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.890327] pnp 00:08: parse allocated resources
[    0.890339] pnp 00:08:   add io  0x60-0x60 flags 0x1
[    0.890342] pnp 00:08:   add io  0x64-0x64 flags 0x1
[    0.890351] pnp 00:08:   add irq 1 flags 0x1
[    0.890542] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.890792] pnp 00:09: parse allocated resources
[    0.891439] pnp 00:09:   add io  0x3f8-0x3ff flags 0x1
[    0.891449] pnp 00:09:   add irq 4 flags 0x1
[    0.891452] pnp 00:09: parse resource options
[    0.891455] pnp 00:09: new independent option
[    0.891475] pnp 00:09: new dependent option (priority 0x0)
[    0.891479] pnp 00:09:   io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
[    0.891486] pnp 00:09:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000010 flags 0x1
[    0.891490] pnp 00:09: new dependent option (priority 0x1)
[    0.891494] pnp 00:09:   io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
[    0.891499] pnp 00:09:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000008 flags 0x1
[    0.891503] pnp 00:09: new dependent option (priority 0x1)
[    0.891507] pnp 00:09:   io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1
[    0.891513] pnp 00:09:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000010 flags 0x1
[    0.891516] pnp 00:09: new dependent option (priority 0x1)
[    0.891520] pnp 00:09:   io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1
[    0.891525] pnp 00:09:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000008 flags 0x1
[    0.891529] pnp 00:09: new dependent option (priority 0x2)
[    0.891533] pnp 00:09:   io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
[    0.891538] pnp 00:09:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000008 flags 0x1
[    0.891542] pnp 00:09: new dependent option (priority 0x2)
[    0.891546] pnp 00:09:   io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
[    0.891551] pnp 00:09:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000010 flags 0x1
[    0.891555] pnp 00:09: new dependent option (priority 0x2)
[    0.891559] pnp 00:09:   io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1
[    0.891572] pnp 00:09:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000008 flags 0x1
[    0.891576] pnp 00:09: new dependent option (priority 0x2)
[    0.891580] pnp 00:09:   io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1
[    0.891585] pnp 00:09:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000010 flags 0x1
[    0.891589] pnp 00:09: end dependent options
[    0.891829] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.892338] pnp 00:0a: parse allocated resources
[    0.892864] pnp 00:0a:   add io  0x378-0x37f flags 0x1
[    0.892867] pnp 00:0a:   add io  0x778-0x77b flags 0x1
[    0.892879] pnp 00:0a:   add irq 7 flags 0x1
[    0.892883] pnp 00:0a:   add dma 1 flags 0x0
[    0.892885] pnp 00:0a: parse resource options
[    0.892888] pnp 00:0a: new independent option
[    0.892903] pnp 00:0a: new dependent option (priority 0x1)
[    0.892907] pnp 00:0a:   io  min 0x378 max 0x378 align 8 size 8 flags 0x1
[    0.892911] pnp 00:0a:   io  min 0x778 max 0x778 align 4 size 4 flags 0x1
[    0.892917] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000080 flags 0x1
[    0.892921] pnp 00:0a:   dma bitmask 0xa flags 0x0
[    0.892924] pnp 00:0a: new dependent option (priority 0x1)
[    0.892928] pnp 00:0a:   io  min 0x278 max 0x278 align 8 size 8 flags 0x1
[    0.892931] pnp 00:0a:   io  min 0x678 max 0x678 align 4 size 4 flags 0x1
[    0.892937] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000020 flags 0x1
[    0.892942] pnp 00:0a:   dma bitmask 0xa flags 0x0
[    0.892945] pnp 00:0a: new dependent option (priority 0x1)
[    0.892948] pnp 00:0a:   io  min 0x3bc max 0x3bc align 4 size 4 flags 0x1
[    0.892952] pnp 00:0a:   io  min 0x7bc max 0x7bc align 4 size 4 flags 0x1
[    0.892958] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000080 flags 0x1
[    0.892962] pnp 00:0a:   dma bitmask 0xa flags 0x0
[    0.892964] pnp 00:0a: end dependent options
[    0.893190] pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.894266] pnp: PnP ACPI: found 11 devices
[    0.894327] ACPI: ACPI bus type pnp unregistered
[    0.895135] PCI: Using ACPI for IRQ routing
[    0.896448] tracer: 772 pages allocated for 65536<6> entries of 48 bytes
[    0.896552]    actual entries 65620
[    0.897175] pnp: the driver 'system' has been registered
[    0.897220] system 00:05: iomem range 0x0-0x9ffff could not be reserved
[    0.897283] system 00:05: iomem range 0xe0000-0xfffff could not be reserved
[    0.897344] system 00:05: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.897414] system 00:05: iomem range 0xffee0000-0xffefffff has been reserved
[    0.897474] system 00:05: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.897533] system 00:05: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.897592] system 00:05: driver attached
[    0.897609] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    0.897668] system 00:06: ioport range 0xfe10-0xfe11 has been reserved
[    0.897727] system 00:06: ioport range 0xfe00-0xfe00 has been reserved
[    0.897786] system 00:06: ioport range 0x4000-0x407f has been reserved
[    0.897846] system 00:06: ioport range 0x8100-0x811f could not be reserved
[    0.897905] system 00:06: driver attached
[    0.929853] PCI: Failed to allocate mem resource #6:10000@f4000000 for 0000:01:00.0
[    0.929927] PCI: Bridge: 0000:00:01.0
[    0.929980]   IO window: disabled.
[    0.930090] Switched to high resolution mode on CPU 0
[    0.930098]   MEM window: 0xd1000000-0xd1ffffff
[    0.930155]   PREFETCH window: 0x00000000f0000000-0x00000000f3ffffff
[    0.930217] PCI: Bus 2, cardbus bridge: 0000:00:0c.0
[    0.930272]   IO window: 0x00002000-0x000020ff
[    0.930330]   IO window: 0x00002400-0x000024ff
[    0.930387]   PREFETCH window: 0x50000000-0x53ffffff
[    0.930444]   MEM window: 0x54000000-0x57ffffff
[    0.930530] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.930544] pci 0000:00:0c.0: enabling device (0000 -> 0003)
[    0.930611] ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.930724] Int: type 0, pol 3, trig 3, bus 00, IRQ 30, APIC ID 1, APIC INT 10
[    0.930797] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.930857] NET: Registered protocol family 2
[    0.931274] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.931841] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.933099] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.939518] TCP: Hash tables configured (established 131072 bind 65536)
[    0.939620] TCP reno registered
[    0.939856] NET: Registered protocol family 1
[    0.942468] audit: initializing netlink socket (disabled)
[    0.942605] type=2000 audit(1213257623.940:1): initialized
[    0.942665] audit: cannot initialize inotify handle
[    0.945339] highmem bounce pool size: 64 pages
[    0.945812] msgmni has been set to 1507
[    0.946030] io scheduler noop registered
[    0.946102] io scheduler cfq registered (default)
[    0.946193] PCI: VIA PCI bridge detected.Disabling DAC.
[    0.946356] pci 0000:01:00.0: Boot video device
[    1.044854] Uniform Multi-Platform E-IDE driver
[    1.044918] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    1.045376] VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:11.1
[    1.045705] ACPI: PCI Interrupt Link [ALKA] disabled and referenced, BIOS bug
[    1.045878] ACPI: PCI Interrupt Link [ALKA] BIOS reported IRQ 0, using IRQ 23
[    1.045938] ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 23
[    1.046003] ACPI: PCI Interrupt 0000:00:11.1[A] -> Link [ALKA] -> GSI 23 (level, low) -> IRQ 23
[    1.046156] Int: type 0, pol 3, trig 3, bus 00, IRQ 44, APIC ID 1, APIC INT 17
[    1.046236] VP_IDE: not 100% native mode: will probe irqs later
[    1.046362] VP_IDE: VIA vt8235 (rev 00) IDE UDMA133 controller on pci0000:00:11.1
[    1.046440]     ide0: BM-DMA at 0x1c60-0x1c67
[    1.046503]     ide1: BM-DMA at 0x1c68-0x1c6f
[    1.046559] Probing IDE interface ide0...
[    1.490109] hda: SAMSUNG MP0804H, ATA DISK drive
[    2.210263] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    2.210335] hda: UDMA/100 mode selected
[    2.210448] Probing IDE interface ide1...
[    3.130108] hdc: Optiarc DVD RW AD-7543A, ATAPI CD/DVD-ROM drive
[    3.850196] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    3.850375] hdc: UDMA/33 mode selected
[    3.850700] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    3.947700] ide1 at 0x170-0x177,0x376 on irq 15
[    3.947700] ide_generic: I/O resource 0x1F0-0x1F7 not free.
[    3.947700] ide_generic: I/O resource 0x170-0x177 not free.
[    3.947700] pnp: the driver 'ide' has been registered
[    3.950172] hda: max request size: 512KiB
[    3.950339] hda: 156368016 sectors (80060 MB) w/8192KiB Cache, CHS=16383/255/63
[    3.950889] hda: cache flushes supported
[    3.951212]  hda: hda1 hda2 hda3
[    3.960380] pnp: the driver 'i8042 kbd' has been registered
[    3.960421] i8042 kbd 00:08: driver attached
[    3.960554] pnp: the driver 'i8042 aux' has been registered
[    3.960589] i8042 aux 00:07: driver attached
[    3.960723] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.963255] i8042.c: Detected active multiplexing controller, rev 1.1.
[    3.964693] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.964782] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    3.964855] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    3.964913] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    3.964970] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    3.965439] cpuidle: using governor ladder
[    3.965496] cpuidle: using governor menu
[    3.965572] TCP cubic registered
[    3.965628] NET: Registered protocol family 17
[    3.965712] Using IPI Shortcut mode
[    3.976768] input: AT Translated Set 2 keyboard as /class/input/input0
[    4.193506] ReiserFS: hda3: found reiserfs format "3.6" with standard journal
[    4.193506] ReiserFS: hda3: using ordered data mode
[    4.200006] ReiserFS: hda3: journal params: device hda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[    4.200006] ReiserFS: hda3: checking transaction log (hda3)
[    4.210006] ReiserFS: hda3: Using r5 hash to sort names
[    4.210006] VFS: Mounted root (reiserfs filesystem) readonly.
[    4.210006] Freeing unused kernel memory: 200k freed
[    4.210006] Write protecting the kernel text: 2028k
[    4.210006] Write protecting the kernel read-only data: 712k
[    9.483337] input: Power Button (FF) as /class/input/input1
[    9.550313] ACPI: Power Button (FF) [PWRF]
[    9.550628] input: Power Button (CM) as /class/input/input2
[    9.590330] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    9.590724] ACPI: ACPI0007:00 is registered as cooling_device0
[    9.600256] ACPI: Power Button (CM) [PWB]
[    9.601416] input: Sleep Button (CM) as /class/input/input3
[    9.670182] ACPI: Sleep Button (CM) [SLPB]
[    9.670600] input: Lid Switch as /class/input/input4
[    9.690941] ACPI: Lid Switch [LID]
[    9.692012] ACPI: AC Adapter [AC] (on-line)
[    9.772029] ACPI: Battery Slot [BAT0] (battery present)
[    9.775880] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    9.777061] ACPI: Thermal Zone [THRM] (54 C)
[    9.949586] hdc: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
[    9.949888] Uniform CD-ROM driver Revision: 3.20
[   10.062481] 8139too Fast Ethernet driver 0.9.28
[   10.062625] ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 19 (level, low) -> IRQ 19
[   10.062738] Int: type 0, pol 3, trig 3, bus 00, IRQ 20, APIC ID 1, APIC INT 13
[   10.063456] eth0: RealTek RTL8139 at 0xf88e8000, 00:90:f5:3e:5a:ca, IRQ 19
[   10.063515] eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
[   10.129942] Marking TSC unstable due to: TSC halts in idle.
[   10.666477] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   10.667171] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   11.190054] input: PS/2 Generic Mouse as /class/input/input5
[   11.255829] mice: PS/2 mouse device common for all mice
[   11.303206] pnp: the driver 'serial' has been registered
[   11.303206] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   11.303206] serial 00:09: driver attached
[   11.507666] input: PS/2 Mouse as /class/input/input6
[   11.564794] input: AlpsPS/2 ALPS GlidePoint as /class/input/input7
[   12.617618] Adding 1951888k swap on /dev/hda2.  Priority:-1 extents:1 across:1951888k
[   22.925258] powernow-k8: Found 1 Mobile AMD Sempron(tm) Processor 2600+ processors (1 cpu cores) (version 2.20.00)
[   22.926335] powernow-k8:    0 : fid 0x8 (1600 MHz), vid 0x6
[   22.926393] powernow-k8:    1 : fid 0x0 (800 MHz), vid 0x18
[   22.928719] powernow-k8: ph2 null fid transition 0x8
[   33.124034] ReiserFS: hda1: found reiserfs format "3.6" with standard journal
[   33.124034] ReiserFS: hda1: using ordered data mode
[   33.130027] ReiserFS: hda1: journal params: device hda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   33.131449] ReiserFS: hda1: checking transaction log (hda1)
[   33.186811] ReiserFS: hda1: Using r5 hash to sort names
[   46.420045] Clocksource tsc unstable (delta = -250000016 ns)
[   61.249801] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)

--------------060901040904040705010506--
