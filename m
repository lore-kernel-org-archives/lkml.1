Return-Path: <linux-kernel-owner+w=401wt.eu-S1765105AbXLMRzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765105AbXLMRzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761810AbXLMRzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:55:33 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:36639 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761786AbXLMRz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:55:26 -0500
Date: Thu, 13 Dec 2007 23:24:23 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: htejun@gmail.com, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
Message-ID: <20071213175423.GA2977@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071213123333.GA16905@linux.vnet.ibm.com> <20071213132326.GC16905@linux.vnet.ibm.com> <20071213151847.GB5676@linux.vnet.ibm.com> <20071213162936.GA7635@suse.de> <20071213164658.GA30865@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213164658.GA30865@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 10:16:58PM +0530, Dhaval Giani wrote:
> On Thu, Dec 13, 2007 at 08:29:36AM -0800, Greg KH wrote:
> > On Thu, Dec 13, 2007 at 08:48:47PM +0530, Dhaval Giani wrote:
> > > On Thu, Dec 13, 2007 at 06:53:26PM +0530, Dhaval Giani wrote:
> > > > On Thu, Dec 13, 2007 at 06:03:33PM +0530, Dhaval Giani wrote:
> > > > > Hi Greg, Tejun,
> > > > > 
> > > > > The following script causes oomkiller to be invoked on my system here.
> > > > > 
> > > > > while echo; do cat /sys/kernel/kexec_crash_loaded; done
> > > > > 
> > > > 
> > > >  while echo; do cat /sys/kernel/uevent_seqnum ; done;
> > > > 
> > > > causes oomkiller to be invoked on 2.6.22-stable, 2.6.23-stable and
> > > > 2.6.24-rc5 as well. It seems not be particularly related to any single
> > > > file in sysfs.
> > > > 
> > > 
> > > And on 2.6.24-rc5-mm1 as well.
> > 
> > How long do you have to run this?  I'm not seeing a problem here with
> > 2.6.24-rc5 using SLUB, but I might not have run things long enough.
> > 
> 
> I hit it reliably under 10 mins. I've seen it with both SLUB and SLAB.
> 
> > I ran slabinfo and don't see anything leaking either, do you?
> 
> Nor could I find anything, at least nothing directly apparent. (But, I
> am not very good at ready slabinfo yet.)
> 
> I've attached the .config if that helps in reproducing it. (Am testing
> with SLUB again on latest -mm).
> 

OK, so it ooms there as well. I am attaching its config and part of the
dmesg (whatever I could capture).

thanks,

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24-rc5-mm1
# Thu Dec 13 23:12:10 2007
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_SUPPORTS_OPROFILE=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
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
CONFIG_AUDIT_TREE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=15
# CONFIG_CGROUPS is not set
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y
# CONFIG_FAIR_CGROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
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
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROFILING=y
# CONFIG_MARKERS is not set
CONFIG_OPROFILE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_KMOD is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"

#
# Processor type and features
#
# CONFIG_TICK_ONESHOT is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
CONFIG_X86_GENERICARCH=y
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_X86_CYCLONE_TIMER=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
CONFIG_MPENTIUM4=y
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
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
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
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_ARCH_SUPPORTS_KVM=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
# CONFIG_NUMA is not set
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
# CONFIG_IRQBALANCE is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=2001
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
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
CONFIG_K8_NB=y
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
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
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
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
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
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
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
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
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
CONFIG_BLK_DEV_PIIX=y
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
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
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
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
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
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_ATA is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#

#
# Texas Instruments PCILynx requires I2C
#
CONFIG_IEEE1394_OHCI1394=y

#
# Protocols
#
# CONFIG_IEEE1394_VIDEO1394 is not set
# CONFIG_IEEE1394_SBP2 is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
CONFIG_IEEE1394_RAWIO=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_DUMMY is not set
CONFIG_BONDING=y
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_IP1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
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
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
CONFIG_BNX2=y
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPPOE is not set
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
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
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
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
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_MOXA_SMARTIO_NEW is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
CONFIG_STALDRV=y
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_HWMON is not set
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
CONFIG_DAB=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
# CONFIG_SND is not set

#
# Open Sound System
#
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_TRIDENT is not set
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
# CONFIG_SOUND_OSS is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
# CONFIG_USB is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_VIRTUALIZATION=y
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
CONFIG_DMIID=y

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISER4_FS is not set
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

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
# CONFIG_MINIX_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
CONFIG_SMB_FS=y
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
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
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_PAGE_OWNER is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_PROFILE_LIKELY is not set
CONFIG_FORCED_INLINING=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DEBUG_SYNCHRO_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_CRYPTO is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y


erved
system 00:01: ioport range 0x504-0x507 has been reserved
Clocksource tsc unstable (delta = 273023271 ns)
system 00:01: ioport range 0x500-0x503 has been reserved
Time: jiffies clocksource has been installed.
system 00:01: ioport range 0x520-0x53f has been reserved
system 00:01: ioport range 0x420-0x427 has been reserved
system 00:01: ioport range 0x460-0x461 has been reserved
system 00:0b: ioport range 0x1ec-0x1ef has been reserved
system 00:0b: ioport range 0x400-0x4fe could not be reserved
system 00:0b: ioport range 0x600-0x600 has been reserved
system 00:0b: ioport range 0x800-0x80f has been reserved
system 00:0b: ioport range 0xc00-0xcfe could not be reserved
system 00:0b: ioport range 0xf50-0xf58 has been reserved
system 00:0b: iomem range 0xfec00000-0xffffffff could not be reserved
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 377k freed
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
audit: initializing netlink socket (disabled)
audit(1197587738.684:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:00:07.0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized radeon 1.28.0 20060524 on minor 0
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
brd: module loaded
loop: module loaded
Ethernet Channel Bonding Driver: v3.2.3 (December 6, 2007)
bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
tg3.c:v3.86 (November 9, 2007)
ACPI: PCI Interrupt 0000:09:08.0[A] -> GSI 47 (level, low) -> IRQ 47
eth0: Tigon3 [partno(BCM95703) rev 1002 PHY(5703)] (PCIX:100MHz:64-bit) 10/100/1000Base-T Ethernet 00:02:55:df:b4:13
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[769c4000] dma_mask[64-bit]
PPP generic driver version 2.4.2
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: SAMSUNG CD-ROM SC-148A, ATAPI CD/DVD-ROM drive
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 48X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
PCI: Enabling device 0000:08:0a.0 (0156 -> 0157)
ACPI: PCI Interrupt 0000:08:0a.0[A] -> GSI 44 (level, low) -> IRQ 44
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

PCI: Enabling device 0000:08:0a.1 (0156 -> 0157)
ACPI: PCI Interrupt 0000:08:0a.1[B] -> GSI 45 (level, low) -> IRQ 45
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

scsi 1:0:0:0: Direct-Access     IBM-ESXS DTN036C3UCDY10FN S27Y PQ: 0 ANSI: 3
scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
 target1:0:0: Beginning Domain Validation
 target1:0:0: wide asynchronous
 target1:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:0: Ending Domain Validation
scsi 1:0:1:0: Direct-Access     IBM-ESXS DTN036C3UCDY10FN S27Y PQ: 0 ANSI: 3
scsi1:A:1:0: Tagged Queuing enabled.  Depth 32
 target1:0:1: Beginning Domain Validation
 target1:0:1: wide asynchronous
 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:1: Ending Domain Validation
scsi 1:0:2:0: Direct-Access     IBM-ESXS DTN036C3UCDY10FN S27Y PQ: 0 ANSI: 3
scsi1:A:2:0: Tagged Queuing enabled.  Depth 32
 target1:0:2: Beginning Domain Validation
 target1:0:2: wide asynchronous
 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:2: Ending Domain Validation
scsi 1:0:3:0: Direct-Access     IBM-ESXS DTN036C3UCDY10FN S27Y PQ: 0 ANSI: 3
scsi1:A:3:0: Tagged Queuing enabled.  Depth 32
 target1:0:3: Beginning Domain Validation
 target1:0:3: wide asynchronous
 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:3: Ending Domain Validation
scsi 1:0:4:0: Direct-Access     IBM-ESXS DTN036C3UCDY10FN S27Y PQ: 0 ANSI: 3
scsi1:A:4:0: Tagged Queuing enabled.  Depth 32
 target1:0:4: Beginning Domain Validation
 target1:0:4: wide asynchronous
 target1:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:4: Ending Domain Validation
scsi 1:0:5:0: Direct-Access     IBM-ESXS ST336607LC    FN B25H PQ: 0 ANSI: 3
scsi1:A:5:0: Tagged Queuing enabled.  Depth 32
 target1:0:5: Beginning Domain Validation
 target1:0:5: wide asynchronous
 target1:0:5: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
 target1:0:5: Ending Domain Validation
scsi 1:0:8:0: Processor         IBM      02R0980a S320  1 1    PQ: 0 ANSI: 2
 target1:0:8: Beginning Domain Validation
 target1:0:8: Ending Domain Validation
PCI: Unable to reserve mem region #2:1000@edfff000 for device 0000:08:0a.0
aic7xxx: <Adaptec AIC-7899 Ultra 160/m SCSI host adapter> at PCI 8/10/0
aic7xxx: I/O ports already in use, ignoring.
PCI: Unable to reserve mem region #2:1000@edffe000 for device 0000:08:0a.1
aic7xxx: <Adaptec AIC-7899 Ultra 160/m SCSI host adapter> at PCI 8/10/1
aic7xxx: I/O ports already in use, ignoring.
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.16-rc1 Thu. Nov. 07 10:09:32 PDT 2007
st: Version 20070203, fixed bufsize 32768, s/g segs 256
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
sd 1:0:0:0: [sda] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: cb 00 00 08
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sda] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: cb 00 00 08
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 1:0:0:0: [sda] Attached SCSI disk
sd 1:0:1:0: [sdb] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:1:0: [sdb] Write Protect is off
sd 1:0:1:0: [sdb] Mode Sense: cb 00 00 08
sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:1:0: [sdb] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:1:0: [sdb] Write Protect is off
sd 1:0:1:0: [sdb] Mode Sense: cb 00 00 08
sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 1:0:1:0: [sdb] Attached SCSI disk
sd 1:0:2:0: [sdc] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:2:0: [sdc] Write Protect is off
sd 1:0:2:0: [sdc] Mode Sense: cb 00 00 08
sd 1:0:2:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:2:0: [sdc] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:2:0: [sdc] Write Protect is off
sd 1:0:2:0: [sdc] Mode Sense: cb 00 00 08
sd 1:0:2:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2
sd 1:0:2:0: [sdc] Attached SCSI disk
sd 1:0:3:0: [sdd] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:3:0: [sdd] Write Protect is off
sd 1:0:3:0: [sdd] Mode Sense: cb 00 00 08
sd 1:0:3:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:3:0: [sdd] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:3:0: [sdd] Write Protect is off
sd 1:0:3:0: [sdd] Mode Sense: cb 00 00 08
sd 1:0:3:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 1:0:3:0: [sdd] Attached SCSI disk
sd 1:0:4:0: [sde] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:4:0: [sde] Write Protect is off
sd 1:0:4:0: [sde] Mode Sense: cb 00 00 08
sd 1:0:4:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:4:0: [sde] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:4:0: [sde] Write Protect is off
sd 1:0:4:0: [sde] Mode Sense: cb 00 00 08
sd 1:0:4:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 1:0:4:0: [sde] Attached SCSI disk
sd 1:0:5:0: [sdf] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:5:0: [sdf] Write Protect is off
sd 1:0:5:0: [sdf] Mode Sense: b3 00 10 08
sd 1:0:5:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:5:0: [sdf] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:5:0: [sdf] Write Protect is off
sd 1:0:5:0: [sdf] Mode Sense: b3 00 10 08
sd 1:0:5:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdf: sdf1
sd 1:0:5:0: [sdf] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:1:0: Attached scsi generic sg1 type 0
sd 1:0:2:0: Attached scsi generic sg2 type 0
sd 1:0:3:0: Attached scsi generic sg3 type 0
sd 1:0:4:0: Attached scsi generic sg4 type 0
sd 1:0:5:0: Attached scsi generic sg5 type 0
scsi 1:0:8:0: Attached scsi generic sg6 type 3
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
Fusion MPT FC Host driver 3.04.06
Fusion MPT SAS Host driver 3.04.06
Fusion MPT misc device (ioctl) driver 3.04.06
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
ieee1394: raw1394: /dev/raw1394 device initialized
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x64,0x60 irq 1,12
PNP: PS/2 controller has invalid data port 0x64; using default 0x60
PNP: PS/2 controller has invalid command port 0x60; using default 0x64
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
Testing NMI watchdog ... OK.
Using IPI No-Shortcut mode
Freeing unused kernel memory: 236k freed
sd_mod: version magic '2.6.15.4 SMP PENTIUM4 REGPARM 4KSTACKS gcc-3.4' should be '2.6.24-rc5-mm1 SMP mod_unload PENTIUM4 '
aic7xxx: version magic '2.6.15.4 SMP PENTIUM4 REGPARM 4KSTACKS gcc-3.4' should be '2.6.24-rc5-mm1 SMP mod_unload PENTIUM4 '
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
warning: process `kmodule' used the deprecated sysctl system call with 1.23.
EXT3 FS on sdd1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdd3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdf1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1863532k swap on /dev/sdb3.  Priority:-1 extents:1 across:1863532k
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
bash invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
Pid: 4600, comm: bash Not tainted 2.6.24-rc5-mm1 #4
 [<c010582a>] show_trace_log_lvl+0x12/0x22
 [<c0105847>] show_trace+0xd/0xf
 [<c0105959>] dump_stack+0x57/0x5e
 [<c015790f>] oom_kill_process+0x37/0xdb
 [<c0157b1c>] out_of_memory+0xbd/0xf1
 [<c01590d1>] __alloc_pages+0x23f/0x2bc
 [<c011b6ca>] pte_alloc_one+0x15/0x3e
 [<c0160834>] __pte_alloc+0x15/0xaf
 [<c0160a43>] copy_pte_range+0x43/0x293
 [<c0160daf>] copy_page_range+0x11c/0x154
 [<c01229c5>] dup_mmap+0x1ab/0x20c
 [<c0122d6e>] dup_mm+0x81/0xd1
 [<c0122e26>] copy_mm+0x68/0x98
 [<c0123aca>] copy_process+0x46f/0x9d0
 [<c0124148>] do_fork+0x8d/0x1d2
 [<c0103aba>] sys_clone+0x1f/0x21
 [<c01049fa>] sysenter_past_esp+0x5f/0xa5
 =======================
Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  54
CPU    1: hi:  186, btch:  31 usd: 157
CPU    2: hi:  186, btch:  31 usd:  62
CPU    3: hi:  186, btch:  31 usd: 166
CPU    4: hi:  186, btch:  31 usd:  54
CPU    5: hi:  186, btch:  31 usd: 160
CPU    6: hi:  186, btch:  31 usd:  41
CPU    7: hi:  186, btch:  31 usd: 171
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:  16
CPU    1: hi:  186, btch:  31 usd: 173
CPU    2: hi:  186, btch:  31 usd:   7
CPU    3: hi:  186, btch:  31 usd: 167
CPU    4: hi:  186, btch:  31 usd:   9
CPU    5: hi:  186, btch:  31 usd: 183
CPU    6: hi:  186, btch:  31 usd:  22
CPU    7: hi:  186, btch:  31 usd: 154
Active:2418 inactive:1198 dirty:0 writeback:0 unstable:0
 free:986524 slab:2354 mapped:887 pagetables:124 bounce:0
DMA free:3548kB min:64kB low:80kB high:96kB active:8kB inactive:0kB present:16176kB pages_scanned:398 all_unreclaimable? yes
lowmem_reserve[]: 0 868 5039 5039
Normal free:3956kB min:3736kB low:4668kB high:5604kB active:36kB inactive:0kB present:889680kB pages_scanned:164 all_unreclaimable? yes
lowmem_reserve[]: 0 0 33363 33363
HighMem free:3938592kB min:512kB low:4992kB high:9476kB active:9496kB inactive:4792kB present:4270464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 4*32kB 3*64kB 3*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3548kB
Normal: 37*4kB 5*8kB 0*16kB 0*32kB 0*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3900kB
HighMem: 173*4kB 498*8kB 234*16kB 89*32kB 20*64kB 5*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 958*4096kB = 3938436kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1863532kB
Total swap = 1863532kB
Free swap:       1863532kB
1310720 pages of RAM
1081344 pages of HIGHMEM
127452 reserved pages
4101 pages shared
0 pages swap cached
0 pages dirty
0 pages writeback
887 pages mapped
2354 pages slab
124 pages pagetables
Out of memory: kill process 3963 (slpd) score 897 or a child
Killed process 3963 (slpd)
bash invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
Pid: 4600, comm: bash Not tainted 2.6.24-rc5-mm1 #4
 [<c010582a>] show_trace_log_lvl+0x12/0x22
 [<c0105847>] show_trace+0xd/0xf
 [<c0105959>] dump_stack+0x57/0x5e
 [<c015790f>] oom_kill_process+0x37/0xdb
 [<c0157b1c>] out_of_memory+0xbd/0xf1
 [<c01590d1>] __alloc_pages+0x23f/0x2bc
 [<c011b6ca>] pte_alloc_one+0x15/0x3e
 [<c0160834>] __pte_alloc+0x15/0xaf
 [<c0160a43>] copy_pte_range+0x43/0x293
 [<c0160daf>] copy_page_range+0x11c/0x154
 [<c01229c5>] dup_mmap+0x1ab/0x20c
 [<c0122d6e>] dup_mm+0x81/0xd1
 [<c0122e26>] copy_mm+0x68/0x98
 [<c0123aca>] copy_process+0x46f/0x9d0
 [<c0124148>] do_fork+0x8d/0x1d2
 [<c0103aba>] sys_clone+0x1f/0x21
 [<c01049fa>] sysenter_past_esp+0x5f/0xa5
 =======================
Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  27
CPU    1: hi:  186, btch:  31 usd: 144
CPU    2: hi:  186, btch:  31 usd:  35
CPU    3: hi:  186, btch:  31 usd: 147
CPU    4: hi:  186, btch:  31 usd:  82
CPU    5: hi:  186, btch:  31 usd: 160
CPU    6: hi:  186, btch:  31 usd:  43
CPU    7: hi:  186, btch:  31 usd: 146
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:  24
CPU    1: hi:  186, btch:  31 usd: 156
CPU    2: hi:  186, btch:  31 usd:  12
CPU    3: hi:  186, btch:  31 usd: 172
CPU    4: hi:  186, btch:  31 usd:  67
CPU    5: hi:  186, btch:  31 usd: 154
CPU    6: hi:  186, btch:  31 usd:  15
CPU    7: hi:  186, btch:  31 usd: 152
Active:2491 inactive:1200 dirty:1 writeback:0 unstable:0
 free:986380 slab:2345 mapped:872 pagetables:235 bounce:3
DMA free:3532kB min:64kB low:80kB high:96kB active:0kB inactive:8kB present:16176kB pages_scanned:42 all_unreclaimable? yes
lowmem_reserve[]: 0 868 5039 5039
Normal free:3804kB min:3736kB low:4668kB high:5604kB active:100kB inactive:0kB present:889680kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 33363 33363
HighMem free:3938184kB min:512kB low:4992kB high:9476kB active:9864kB inactive:4832kB present:4270464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 3*4kB 4*8kB 1*16kB 4*32kB 3*64kB 3*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3580kB
Normal: 0*4kB 4*8kB 1*16kB 3*32kB 1*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3792kB
HighMem: 63*4kB 499*8kB 236*16kB 90*32kB 20*64kB 5*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 958*4096kB = 3938068kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1863532kB
Total swap = 1863532kB
Free swap:       1863532kB
1310720 pages of RAM
1081344 pages of HIGHMEM
127452 reserved pages
4476 pages shared
0 pages swap cached
1 pages dirty
0 pages writeback
879 pages mapped
2365 pages slab
209 pages pagetables
Out of memory: kill process 4085 (xfs) score 817 or a child
Killed process 4085 (xfs)
bash invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
Pid: 4600, comm: bash Not tainted 2.6.24-rc5-mm1 #4
 [<c010582a>] show_trace_log_lvl+0x12/0x22
 [<c0105847>] show_trace+0xd/0xf
 [<c0105959>] dump_stack+0x57/0x5e
 [<c015790f>] oom_kill_process+0x37/0xdb
 [<c0157b1c>] out_of_memory+0xbd/0xf1
 [<c01590d1>] __alloc_pages+0x23f/0x2bc
 [<c011b6ca>] pte_alloc_one+0x15/0x3e
 [<c0160834>] __pte_alloc+0x15/0xaf
 [<c0160a43>] copy_pte_range+0x43/0x293
 [<c0160daf>] copy_page_range+0x11c/0x154
 [<c01229c5>] dup_mmap+0x1ab/0x20c
 [<c0122d6e>] dup_mm+0x81/0xd1
 [<c0122e26>] copy_mm+0x68/0x98
 [<c0123aca>] copy_process+0x46f/0x9d0
 [<c0124148>] do_fork+0x8d/0x1d2
 [<c0103aba>] sys_clone+0x1f/0x21
 [<c01049fa>] sysenter_past_esp+0x5f/0xa5
 =======================
Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  15
CPU    1: hi:  186, btch:  31 usd: 175
CPU    2: hi:  186, btch:  31 usd:  39
CPU    3: hi:  186, btch:  31 usd: 170
CPU    4: hi:  186, btch:  31 usd:  36
CPU    5: hi:  186, btch:  31 usd: 159
CPU    6: hi:  186, btch:  31 usd:   8
CPU    7: hi:  186, btch:  31 usd: 174
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:  20
CPU    1: hi:  186, btch:  31 usd: 175
CPU    2: hi:  186, btch:  31 usd:  27
CPU    3: hi:  186, btch:  31 usd: 177
CPU    4: hi:  186, btch:  31 usd:  14
CPU    5: hi:  186, btch:  31 usd: 179
CPU    6: hi:  186, btch:  31 usd:  33
CPU    7: hi:  186, btch:  31 usd: 166
Active:2152 inactive:1232 dirty:1 writeback:0 unstable:0
 free:986600 slab:2350 mapped:787 pagetables:203 bounce:0
DMA free:3508kB min:64kB low:80kB high:96kB active:0kB inactive:8kB present:16176kB pages_scanned:123 all_unreclaimable? yes
lowmem_reserve[]: 0 868 5039 5039
Normal free:3684kB min:3736kB low:4668kB high:5604kB active:48kB inactive:0kB present:889680kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 33363 33363
HighMem free:3939272kB min:512kB low:4992kB high:9476kB active:8624kB inactive:4912kB present:4270464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 2*4kB 4*8kB 1*16kB 4*32kB 3*64kB 3*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3576kB
Normal: 0*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3600kB
HighMem: 108*4kB 503*8kB 243*16kB 94*32kB 24*64kB 6*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 958*4096kB = 3938904kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1863532kB
Total swap = 1863532kB
Free swap:       1863532kB
1310720 pages of RAM
1081344 pages of HIGHMEM
127452 reserved pages
3797 pages shared
0 pages swap cached
1 pages dirty
0 pages writeback
822 pages mapped
2371 pages slab
141 pages pagetables
Out of memory: kill process 3858 (portmap) score 418 or a child
Killed process 3858 (portmap)
bash invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
Pid: 4600, comm: bash Not tainted 2.6.24-rc5-mm1 #4
 [<c010582a>] show_trace_log_lvl+0x12/0x22
 [<c0105847>] show_trace+0xd/0xf
 [<c0105959>] dump_stack+0x57/0x5e
 [<c015790f>] oom_kill_process+0x37/0xdb
 [<c0157b1c>] out_of_memory+0xbd/0xf1
 [<c01590d1>] __alloc_pages+0x23f/0x2bc
 [<c011b6ca>] pte_alloc_one+0x15/0x3e
 [<c0160834>] __pte_alloc+0x15/0xaf
 [<c0160a43>] copy_pte_range+0x43/0x293
 [<c0160daf>] copy_page_range+0x11c/0x154
 [<c01229c5>] dup_mmap+0x1ab/0x20c
 [<c0122d6e>] dup_mm+0x81/0xd1
 [<c0122e26>] copy_mm+0x68/0x98
 [<c0123aca>] copy_process+0x46f/0x9d0
 [<c0124148>] do_fork+0x8d/0x1d2
 [<c0103aba>] sys_clone+0x1f/0x21
 [<c01049fa>] sysenter_past_esp+0x5f/0xa5
 =======================
Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  14
CPU    1: hi:  186, btch:  31 usd:  85
CPU    2: hi:  186, btch:  31 usd:  30
CPU    3: hi:  186, btch:  31 usd:  97
CPU    4: hi:  186, btch:  31 usd:  23
CPU    5: hi:  186, btch:  31 usd:  85
CPU    6: hi:  186, btch:  31 usd:  29
CPU    7: hi:  186, btch:  31 usd:  67
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:  25
CPU    1: hi:  186, btch:  31 usd: 152
CPU    2: hi:  186, btch:  31 usd:   5
CPU    3: hi:  186, btch:  31 usd: 160
CPU    4: hi:  186, btch:  31 usd:  22
CPU    5: hi:  186, btch:  31 usd: 157
CPU    6: hi:  186, btch:  31 usd:   4
CPU    7: hi:  186, btch:  31 usd: 112
Active:2198 inactive:1232 dirty:1 writeback:0 unstable:0
 free:987022 slab:2356 mapped:804 pagetables:107 bounce:0
DMA free:3540kB min:64kB low:80kB high:96kB active:0kB inactive:12kB present:16176kB pages_scanned:6 all_unreclaimable? no
lowmem_reserve[]: 0 868 5039 5039
Normal free:4772kB min:3736kB low:4668kB high:5604kB active:188kB inactive:60kB present:889680kB pages_scanned:384 all_unreclaimable? yes
lowmem_reserve[]: 0 0 33363 33363
HighMem free:3941216kB min:512kB low:4992kB high:9476kB active:8604kB inactive:4856kB present:4270464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 2*4kB 1*8kB 2*16kB 3*32kB 3*64kB 3*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 305*4kB 22*8kB 6*16kB 3*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 5172kB
HighMem: 858*4kB 510*8kB 252*16kB 95*32kB 24*64kB 6*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 958*4096kB = 3942136kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1863532kB
Total swap = 1863532kB
Free swap:       1863532kB
1310720 pages of RAM
1081344 pages of HIGHMEM
127452 reserved pages
3739 pages shared
0 pages swap cached
1 pages dirty
0 pages writeback
804 pages mapped
2356 pages slab
107 pages pagetables
Out of memory: kill process 3984 (sshd) score 174 or a child
Killed process 4584 (sshd)
bash invoked oom-killer: gfp_mask=0x40d0, order=1, oomkilladj=0
Pid: 29704, comm: bash Not tainted 2.6.24-rc5-mm1 #4
 [<c010582a>] show_trace_log_lvl+0x12/0x22
 [<c0105847>] show_trace+0xd/0xf
 [<c0105959>] dump_stack+0x57/0x5e
 [<c015790f>] oom_kill_process+0x37/0xdb
 [<c0157b1c>] out_of_memory+0xbd/0xf1
 [<c01590d1>] __alloc_pages+0x23f/0x2bc
 [<c016ff67>] allocate_slab+0x82/0xbd
 [<c016ffe3>] new_slab+0x22/0xfd
 [<c017044d>] get_new_slab+0x2c/0x9c
 [<c01705a0>] __slab_alloc+0xe3/0x135
 [<c0170624>] kmem_cache_alloc+0x32/0x7f
 [<c011b76a>] pmd_cache_alloc+0x49/0x4d
 [<c011b7e5>] pgd_alloc+0x58/0xab
 [<c0122aea>] mm_init+0xc4/0xea
 [<c0122b43>] mm_alloc+0x33/0x3b
 [<c0178305>] bprm_mm_init+0x12/0x80
 [<c0179432>] do_execve+0x60/0x160
 [<c0103b00>] sys_execve+0x29/0x4d
 [<c01049fa>] sysenter_past_esp+0x5f/0xa5
 =======================
Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   1
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:   0
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:   1
CPU    7: hi:  186, btch:  31 usd:   0
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:   0
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:   0
CPU    7: hi:  186, btch:  31 usd:   0
Active:2050 inactive:1206 dirty:0 writeback:10 unstable:0
 free:987874 slab:2309 mapped:762 pagetables:110 bounce:0
DMA free:3548kB min:64kB low:80kB high:96kB active:12kB inactive:0kB present:16176kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 868 5039 5039
Normal free:5232kB min:3736kB low:4668kB high:5604kB active:220kB inactive:0kB present:889680kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 33363 33363
HighMem free:3942716kB min:512kB low:4992kB high:9476kB active:7968kB inactive:4852kB present:4270464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 3*8kB 2*16kB 3*32kB 3*64kB 3*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3548kB
Normal: 357*4kB 28*8kB 7*16kB 3*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 5444kB
HighMem: 845*4kB 538*8kB 258*16kB 98*32kB 25*64kB 7*128kB 2*256kB 0*512kB 1*1024kB 0*2048kB 958*4096kB = 3942948kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1863532kB
Total swap = 1863532kB
Free swap:       1863532kB
1310720 pages of RAM
1081344 pages of HIGHMEM
127452 reserved pages
2799 pages shared
0 pages swap cached
6 pages dirty
0 pages writeback
761 pages mapped
2330 pages slab
115 pages pagetables
Out of memory: kill process 4598 (sshd) score 148 or a child
Killed process 4600 (bash)
bash invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
Pid: 29705, comm: bash Not tainted 2.6.24-rc5-mm1 #4
 [<c010582a>] show_trace_log_lvl+0x12/0x22
 [<c0105847>] show_trace+0xd/0xf
 [<c0105959>] dump_stack+0x57/0x5e
 [<c015790f>] oom_kill_process+0x37/0xdb
 [<c0157b1c>] out_of_memory+0xbd/0xf1
 [<c01590d1>] __alloc_pages+0x23f/0x2bc
 [<c015918a>] __get_free_pages+0x3c/0x4c
 [<c0122799>] dup_task_struct+0x3c/0xbd
 [<c01236b9>] copy_process+0x5e/0x9d0
 [<c0124148>] do_fork+0x8d/0x1d2
 [<c0103aba>] sys_clone+0x1f/0x21
 [<c01049fa>] sysenter_past_esp+0x5f/0xa5
 =======================
Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:   0
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:   0
CPU    7: hi:  186, btch:  31 usd:   0
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:   0
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:   0
CPU    7: hi:  186, btch:  31 usd:   0
Active:1735 inactive:975 dirty:2 writeback:0 unstable:0
 free:988410 slab:2329 mapped:569 pagetables:84 bounce:9
DMA free:3540kB min:64kB low:80kB high:96kB active:20kB inactive:0kB present:16176kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 868 5039 5039
Normal free:5344kB min:3736kB low:4668kB high:5604kB active:220kB inactive:48kB present:889680kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 33363 33363
HighMem free:3944756kB min:512kB low:4992kB high:9476kB active:6700kB inactive:3852kB present:4270464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 4*4kB 1*8kB 1*16kB 3*32kB 3*64kB 3*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3528kB
Normal: 372*4kB 46*8kB 5*16kB 2*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 5584kB
HighMem: 813*4kB 555*8kB 266*16kB 121*32kB 34*64kB 10*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 958*4096kB = 3945036kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1863532kB
Total swap = 1863532kB
Free swap:       1863532kB
1310720 pages of RAM
1081344 pages of HIGHMEM
127452 reserved pages
2331 pages shared
0 pages swap cached
2 pages dirty
0 pages writeback
566 pages mapped
2292 pages slab
78 pages pagetables
Out of memory: kill process 4059 (crond) score 70 or a child
Killed process 4059 (crond)
-- 
regards,
Dhaval
