Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYBWPxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYBWPxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYBWPx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:53:28 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:57512 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYBWPxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:53:24 -0500
Date: Sat, 23 Feb 2008 07:52:41 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc2 rcupreempt WARN after suspend to ram
Message-ID: <20080223155241.GA12351@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200802231341.02597.fzu@wemgehoertderstaat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802231341.02597.fzu@wemgehoertderstaat.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 01:41:02PM +0100, Karsten Wiese wrote:
> Hi,
> 
> This appeared in dmesg after
> 	$ echo core > /sys/power/pm_test
> followed by 3 cycles of
> 	$ echo mem > /sys/power/state
> . .config attached.
> 
> dmesg excerpt (, full ~1MByte available):

Does this tree have http://lkml.org/lkml/2008/1/29/208 applied?

If not, could you please check it out?

						Thanx, Paul

> [  525.137575] SMP alternatives: switching to SMP code
> [  525.137591] Booting processor 1/2 APIC 0x1
> [  530.612383] Initializing CPU#1
> [  530.612383] Calibrating delay using timer specific routine.. 3990.37 BogoMIPS (lpj=7980742)
> [  530.612383] CPU: L1 I cache: 32K, L1 D cache: 32K
> [  530.612383] CPU: L2 cache: 4096K
> [  530.612383] CPU: Physical Processor ID: 0
> [  530.612383] CPU: Processor Core ID: 1
> [  530.612383] Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz stepping 0a
> [  525.230956] CPU0 attaching sched-domain:
> [  525.230963]  domain 0: span 3
> [  525.230966]   groups: 1 2
> [  525.230974] CPU1 attaching sched-domain:
> [  525.230977]  domain 0: span 3
> [  525.230981]   groups: 2 1
> [  525.231945] CPU1 is up
> [  530.612400] Switched to high resolution mode on CPU 1
> [  530.612423] ------------[ cut here ]------------
> [  530.612428] WARNING: at /home/ka/q/kernel/linux-2.6./git/linux-2.6/kernel/rcupreempt.c:534 rcu_irq_exit+0xa3/0xa8()
> [  530.612432] Modules linked in: i915 drm ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge llc autofs4 sunrpc ipv6 acpi_cpufreq arc4 snd_hda_intel snd_seq_dummy pcmcia snd_seq_oss snd_seq_midi_event snd_seq fan ecb crypto_blkcipher snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer thermal snd_page_alloc snd_hwdep snd soundcore button battery processor iwl3945 mac80211 ac yenta_socket rsrc_nonstatic pcmcia_core iTCO_wdt iTCO_vendor_support pcspkr rtc_cmos serio_raw cfg80211 joydev tg3 sg sr_mod cdrom usb_storage ata_piix ahci libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
> [  530.612524] Pid: 0, comm: swapper Not tainted 2.6.25-rc2 #18
> [  530.612527] 
> [  530.612529] Call Trace:
> [  530.612532]  <IRQ>  [<ffffffff81032f47>] warn_on_slowpath+0x58/0x6b
> [  530.612560]  [<ffffffff81048940>] ? enqueue_hrtimer+0xe4/0xf2
> [  530.612571]  [<ffffffff8104925f>] ? hrtimer_start+0x108/0x11a
> [  530.612591]  [<ffffffff8106b95d>] rcu_irq_exit+0xa3/0xa8
> [  530.612600]  [<ffffffff81038296>] irq_exit+0x83/0x94
> [  530.612607]  [<ffffffff8101cc15>] smp_apic_timer_interrupt+0x3f/0x52
> [  530.612617]  [<ffffffff8100cca6>] apic_timer_interrupt+0x66/0x70
> [  530.612621]  <EOI>  [<ffffffff881b08ee>] ? :processor:acpi_safe_halt+0x2b/0x3d
> [  530.612670]  [<ffffffff881b0937>] ? :processor:acpi_idle_enter_c1+0x37/0x10a
> [  530.612688]  [<ffffffff881b0aaf>] ? :processor:acpi_idle_enter_bm+0x43/0x2a3
> [  530.612703]  [<ffffffff811c20da>] ? cpuidle_idle_call+0x70/0x9e
> [  530.612709]  [<ffffffff811c206a>] ? cpuidle_idle_call+0x0/0x9e
> [  530.612717]  [<ffffffff8100ae50>] ? cpu_idle+0x97/0xdf
> [  530.612727]  [<ffffffff81255a7a>] ? start_secondary+0x3d2/0x3df
> [  530.612752] 
> [  530.612755] ---[ end trace 0a4cc108f3488c17 ]---
> [  530.616384] ------------[ cut here ]------------
> [  530.616384] WARNING: at /home/ka/q/kernel/linux-2.6./git/linux-2.6/include/linux/rcupreempt.h:99 tick_nohz_restart_sched_tick+0x76/0x166()
> [  530.616384] Modules linked in: i915 drm ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge llc autofs4 sunrpc ipv6 acpi_cpufreq arc4 snd_hda_intel snd_seq_dummy pcmcia snd_seq_oss snd_seq_midi_event snd_seq fan ecb crypto_blkcipher snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer thermal snd_page_alloc snd_hwdep snd soundcore button battery processor iwl3945 mac80211 ac yenta_socket rsrc_nonstatic pcmcia_core iTCO_wdt iTCO_vendor_support pcspkr rtc_cmos serio_raw cfg80211 joydev tg3 sg sr_mod cdrom usb_storage ata_piix ahci libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
> [  530.616384] Pid: 0, comm: swapper Not tainted 2.6.25-rc2 #18
> [  530.616384] 
> [  530.616384] Call Trace:
> [  530.616384]  [<ffffffff81032f47>] warn_on_slowpath+0x58/0x6b
> [  530.616384]  [<ffffffff8111a716>] ? __rb_erase_color+0xc3/0x18c
> [  530.616384]  [<ffffffff8104af55>] ? getnstimeofday+0x31/0x88
> [  530.616384]  [<ffffffff8104945e>] ? ktime_get_ts+0x46/0x4b
> [  530.616384]  [<ffffffff81049474>] ? ktime_get+0x11/0x42
> [  530.616384]  [<ffffffff8104edda>] tick_nohz_restart_sched_tick+0x76/0x166
> [  530.616384]  [<ffffffff811c206a>] ? cpuidle_idle_call+0x0/0x9e
> [  530.616384]  [<ffffffff8100ae70>] cpu_idle+0xb7/0xdf
> [  530.616384]  [<ffffffff81255a7a>] start_secondary+0x3d2/0x3df
> [  530.616384] 
> [  530.616384] ---[ end trace 0a4cc108f3488c17 ]---
> [  530.620401] ------------[ cut here ]------------
> [  530.620405] WARNING: at /home/ka/q/kernel/linux-2.6./git/linux-2.6/include/linux/rcupreempt.h:91 tick_nohz_stop_sched_tick+0x1cc/0x2b6()
> [  530.620410] Modules linked in: i915 drm ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge llc autofs4 sunrpc ipv6 acpi_cpufreq arc4 snd_hda_intel snd_seq_dummy pcmcia snd_seq_oss snd_seq_midi_event snd_seq fan ecb crypto_blkcipher snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer thermal snd_page_alloc snd_hwdep snd soundcore button battery processor iwl3945 mac80211 ac yenta_socket rsrc_nonstatic pcmcia_core iTCO_wdt iTCO_vendor_support pcspkr rtc_cmos serio_raw cfg80211 joydev tg3 sg sr_mod cdrom usb_storage ata_piix ahci libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
> [  530.620487] Pid: 0, comm: swapper Not tainted 2.6.25-rc2 #18
> [  530.620490] 
> [  530.620491] Call Trace:
> [  530.620501]  [<ffffffff81032f47>] warn_on_slowpath+0x58/0x6b
> [  530.620518]  [<ffffffff810496db>] ? hrtimer_get_next_event+0xa3/0xb3
> [  530.620530]  [<ffffffff8103c1fb>] ? cmp_next_hrtimer_event+0x16/0x87
> [  530.620542]  [<ffffffff8103c2bb>] ? get_next_timer_interrupt+0x4f/0x5e
> [  530.620552]  [<ffffffff8104ec7a>] tick_nohz_stop_sched_tick+0x1cc/0x2b6
> [  530.620564]  [<ffffffff811c206a>] ? cpuidle_idle_call+0x0/0x9e
> [  530.620573]  [<ffffffff8100add7>] cpu_idle+0x1e/0xdf
> [  530.620582]  [<ffffffff81255a7a>] start_secondary+0x3d2/0x3df
> [  530.620606] 
> [  530.620609] ---[ end trace 0a4cc108f3488c17 ]---
> 
> 
> regards,
>       Karsten

> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.25-rc2
> # Fri Feb 22 20:35:34 2008
> #
> CONFIG_64BIT=y
> # CONFIG_X86_32 is not set
> CONFIG_X86_64=y
> CONFIG_X86=y
> # CONFIG_GENERIC_LOCKBREAK is not set
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_SEMAPHORE_SLEEPERS=y
> CONFIG_FAST_CMPXCHG_LOCAL=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> # CONFIG_QUICKLIST is not set
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> # CONFIG_GENERIC_GPIO is not set
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_DMI=y
> CONFIG_RWSEM_GENERIC_SPINLOCK=y
> # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
> # CONFIG_ARCH_HAS_ILOG2_U32 is not set
> # CONFIG_ARCH_HAS_ILOG2_U64 is not set
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ZONE_DMA32=y
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_AOUT=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_X86_SMP=y
> CONFIG_X86_64_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_TRAMPOLINE=y
> # CONFIG_KTIME_SCALAR is not set
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> 
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_BSD_PROCESS_ACCT=y
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> CONFIG_TASK_XACCT=y
> CONFIG_TASK_IO_ACCOUNTING=y
> CONFIG_AUDIT=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_AUDIT_TREE=y
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=20
> # CONFIG_CGROUPS is not set
> # CONFIG_GROUP_SCHED is not set
> CONFIG_SYSFS_DEPRECATED=y
> CONFIG_RELAY=y
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> # CONFIG_IPC_NS is not set
> # CONFIG_USER_NS is not set
> # CONFIG_PID_NS is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> # CONFIG_EMBEDDED is not set
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_KALLSYMS_EXTRA_PASS=y
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> # CONFIG_COMPAT_BRK is not set
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_ANON_INODES=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> CONFIG_PROFILING=y
> # CONFIG_MARKERS is not set
> CONFIG_OPROFILE=m
> CONFIG_HAVE_OPROFILE=y
> CONFIG_KPROBES=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> # CONFIG_TINY_SHMEM is not set
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> CONFIG_MODVERSIONS=y
> CONFIG_MODULE_SRCVERSION_ALL=y
> CONFIG_KMOD=y
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_IO_TRACE=y
> # CONFIG_BLK_DEV_BSG is not set
> CONFIG_BLOCK_COMPAT=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_AS=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_AS is not set
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> # CONFIG_CLASSIC_RCU is not set
> CONFIG_PREEMPT_RCU=y
> 
> #
> # Processor type and features
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_SMP=y
> CONFIG_X86_PC=y
> # CONFIG_X86_ELAN is not set
> # CONFIG_X86_VOYAGER is not set
> # CONFIG_X86_NUMAQ is not set
> # CONFIG_X86_SUMMIT is not set
> # CONFIG_X86_BIGSMP is not set
> # CONFIG_X86_VISWS is not set
> # CONFIG_X86_GENERICARCH is not set
> # CONFIG_X86_ES7000 is not set
> # CONFIG_X86_RDC321X is not set
> # CONFIG_X86_VSMP is not set
> # CONFIG_PARAVIRT_GUEST is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP2 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MPSC is not set
> CONFIG_MCORE2=y
> # CONFIG_GENERIC_CPU is not set
> CONFIG_X86_L1_CACHE_BYTES=64
> CONFIG_X86_INTERNODE_CACHE_BYTES=64
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_GOOD_APIC=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_GART_IOMMU=y
> # CONFIG_CALGARY_IOMMU is not set
> CONFIG_IOMMU_HELPER=y
> CONFIG_SWIOTLB=y
> CONFIG_NR_CPUS=2
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> # CONFIG_RCU_TRACE is not set
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> # CONFIG_X86_MCE_AMD is not set
> # CONFIG_I8K is not set
> CONFIG_MICROCODE=m
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> # CONFIG_NUMA is not set
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_SELECT_MEMORY_MODEL=y
> # CONFIG_FLATMEM_MANUAL is not set
> # CONFIG_DISCONTIGMEM_MANUAL is not set
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> # CONFIG_SPARSEMEM_STATIC is not set
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> 
> #
> # Memory hotplug is currently incompatible with Software Suspend
> #
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_RESOURCES_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MTRR=y
> # CONFIG_EFI is not set
> # CONFIG_SECCOMP is not set
> # CONFIG_CC_STACKPROTECTOR is not set
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_HOTPLUG_CPU=y
> CONFIG_COMPAT_VDSO=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management options
> #
> CONFIG_ARCH_HIBERNATION_HEADER=y
> CONFIG_PM=y
> # CONFIG_PM_LEGACY is not set
> CONFIG_PM_DEBUG=y
> CONFIG_PM_VERBOSE=y
> CONFIG_CAN_PM_TRACE=y
> # CONFIG_PM_TRACE_RTC is not set
> CONFIG_PM_SLEEP_SMP=y
> CONFIG_PM_SLEEP=y
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_PROCFS_POWER is not set
> CONFIG_ACPI_SYSFS_POWER=y
> # CONFIG_ACPI_PROC_EVENT is not set
> CONFIG_ACPI_AC=m
> CONFIG_ACPI_BATTERY=m
> CONFIG_ACPI_BUTTON=m
> CONFIG_ACPI_VIDEO=m
> CONFIG_ACPI_FAN=m
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=m
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_THERMAL=m
> # CONFIG_ACPI_WMI is not set
> # CONFIG_ACPI_ASUS is not set
> # CONFIG_ACPI_TOSHIBA is not set
> CONFIG_ACPI_CUSTOM_DSDT_INITRD=y
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> CONFIG_ACPI_SBS=m
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_DEBUG=y
> CONFIG_CPU_FREQ_STAT=m
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
> CONFIG_CPU_FREQ_GOV_USERSPACE=m
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
> 
> #
> # CPUFreq processor drivers
> #
> CONFIG_X86_ACPI_CPUFREQ=m
> # CONFIG_X86_POWERNOW_K8 is not set
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> # CONFIG_X86_P4_CLOCKMOD is not set
> 
> #
> # shared options
> #
> # CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
> # CONFIG_X86_SPEEDSTEP_LIB is not set
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_DMAR is not set
> CONFIG_PCIEPORTBUS=y
> CONFIG_PCIEAER=y
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_LEGACY is not set
> # CONFIG_PCI_DEBUG is not set
> CONFIG_HT_IRQ=y
> CONFIG_ISA_DMA_API=y
> CONFIG_K8_NB=y
> CONFIG_PCCARD=m
> # CONFIG_PCMCIA_DEBUG is not set
> CONFIG_PCMCIA=m
> CONFIG_PCMCIA_LOAD_CIS=y
> CONFIG_PCMCIA_IOCTL=y
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> CONFIG_YENTA=m
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> CONFIG_YENTA_TI=y
> CONFIG_YENTA_ENE_TUNE=y
> CONFIG_YENTA_TOSHIBA=y
> # CONFIG_PD6729 is not set
> # CONFIG_I82092 is not set
> CONFIG_PCCARD_NONSTATIC=m
> # CONFIG_HOTPLUG_PCI is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_COMPAT_BINFMT_ELF=y
> CONFIG_BINFMT_MISC=y
> CONFIG_IA32_EMULATION=y
> CONFIG_IA32_AOUT=m
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_SYSVIPC_COMPAT=y
> 
> #
> # Networking
> #
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_MMAP=y
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> CONFIG_XFRM_USER=y
> CONFIG_XFRM_SUB_POLICY=y
> CONFIG_XFRM_MIGRATE=y
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_NET_KEY=m
> CONFIG_NET_KEY_MIGRATE=y
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> # CONFIG_IP_FIB_TRIE is not set
> CONFIG_IP_FIB_HASH=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=m
> CONFIG_NET_IPGRE=m
> CONFIG_NET_IPGRE_BROADCAST=y
> CONFIG_IP_MROUTE=y
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> CONFIG_INET_AH=m
> CONFIG_INET_ESP=m
> CONFIG_INET_IPCOMP=m
> CONFIG_INET_XFRM_TUNNEL=m
> CONFIG_INET_TUNNEL=m
> CONFIG_INET_XFRM_MODE_TRANSPORT=m
> CONFIG_INET_XFRM_MODE_TUNNEL=m
> CONFIG_INET_XFRM_MODE_BEET=m
> # CONFIG_INET_LRO is not set
> CONFIG_INET_DIAG=m
> CONFIG_INET_TCP_DIAG=m
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=m
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_TCP_CONG_WESTWOOD=m
> CONFIG_TCP_CONG_HTCP=m
> CONFIG_TCP_CONG_HSTCP=m
> CONFIG_TCP_CONG_HYBLA=m
> CONFIG_TCP_CONG_VEGAS=m
> CONFIG_TCP_CONG_SCALABLE=m
> CONFIG_TCP_CONG_LP=m
> CONFIG_TCP_CONG_VENO=m
> CONFIG_TCP_CONG_YEAH=m
> CONFIG_TCP_CONG_ILLINOIS=m
> # CONFIG_DEFAULT_BIC is not set
> CONFIG_DEFAULT_CUBIC=y
> # CONFIG_DEFAULT_HTCP is not set
> # CONFIG_DEFAULT_VEGAS is not set
> # CONFIG_DEFAULT_WESTWOOD is not set
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> CONFIG_IP_VS=m
> # CONFIG_IP_VS_DEBUG is not set
> CONFIG_IP_VS_TAB_BITS=12
> 
> #
> # IPVS transport protocol load balancing support
> #
> CONFIG_IP_VS_PROTO_TCP=y
> CONFIG_IP_VS_PROTO_UDP=y
> CONFIG_IP_VS_PROTO_ESP=y
> CONFIG_IP_VS_PROTO_AH=y
> 
> #
> # IPVS scheduler
> #
> CONFIG_IP_VS_RR=m
> CONFIG_IP_VS_WRR=m
> CONFIG_IP_VS_LC=m
> CONFIG_IP_VS_WLC=m
> CONFIG_IP_VS_LBLC=m
> CONFIG_IP_VS_LBLCR=m
> CONFIG_IP_VS_DH=m
> CONFIG_IP_VS_SH=m
> CONFIG_IP_VS_SED=m
> CONFIG_IP_VS_NQ=m
> 
> #
> # IPVS application helper
> #
> CONFIG_IP_VS_FTP=m
> CONFIG_IPV6=m
> CONFIG_IPV6_PRIVACY=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> CONFIG_IPV6_OPTIMISTIC_DAD=y
> CONFIG_INET6_AH=m
> CONFIG_INET6_ESP=m
> CONFIG_INET6_IPCOMP=m
> CONFIG_IPV6_MIP6=m
> CONFIG_INET6_XFRM_TUNNEL=m
> CONFIG_INET6_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
> CONFIG_INET6_XFRM_MODE_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_BEET=m
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
> CONFIG_IPV6_SIT=m
> CONFIG_IPV6_TUNNEL=m
> CONFIG_IPV6_MULTIPLE_TABLES=y
> CONFIG_IPV6_SUBTREES=y
> CONFIG_NETLABEL=y
> CONFIG_NETWORK_SECMARK=y
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> # CONFIG_NETFILTER_ADVANCED is not set
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK=m
> CONFIG_NF_CONNTRACK_SECMARK=y
> CONFIG_NF_CONNTRACK_FTP=m
> CONFIG_NF_CONNTRACK_IRC=m
> CONFIG_NF_CONNTRACK_SIP=m
> CONFIG_NF_CT_NETLINK=m
> CONFIG_NETFILTER_XTABLES=m
> CONFIG_NETFILTER_XT_TARGET_MARK=m
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_SECMARK=m
> CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
> CONFIG_NETFILTER_XT_MATCH_MARK=m
> CONFIG_NETFILTER_XT_MATCH_POLICY=m
> CONFIG_NETFILTER_XT_MATCH_STATE=m
> 
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_CONNTRACK_IPV4=m
> # CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> CONFIG_IP_NF_TARGET_LOG=m
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_NF_NAT=m
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_IP_NF_TARGET_MASQUERADE=m
> CONFIG_NF_NAT_FTP=m
> CONFIG_NF_NAT_IRC=m
> # CONFIG_NF_NAT_TFTP is not set
> # CONFIG_NF_NAT_AMANDA is not set
> # CONFIG_NF_NAT_PPTP is not set
> # CONFIG_NF_NAT_H323 is not set
> CONFIG_NF_NAT_SIP=m
> CONFIG_IP_NF_MANGLE=m
> 
> #
> # IPv6: Netfilter Configuration
> #
> CONFIG_NF_CONNTRACK_IPV6=m
> CONFIG_IP6_NF_IPTABLES=m
> CONFIG_IP6_NF_MATCH_IPV6HEADER=m
> CONFIG_IP6_NF_FILTER=m
> CONFIG_IP6_NF_TARGET_LOG=m
> CONFIG_IP6_NF_TARGET_REJECT=m
> CONFIG_IP6_NF_MANGLE=m
> CONFIG_IP_DCCP=m
> CONFIG_INET_DCCP_DIAG=m
> CONFIG_IP_DCCP_ACKVEC=y
> 
> #
> # DCCP CCIDs Configuration (EXPERIMENTAL)
> #
> CONFIG_IP_DCCP_CCID2=m
> # CONFIG_IP_DCCP_CCID2_DEBUG is not set
> CONFIG_IP_DCCP_CCID3=m
> # CONFIG_IP_DCCP_CCID3_DEBUG is not set
> CONFIG_IP_DCCP_CCID3_RTO=100
> CONFIG_IP_DCCP_TFRC_LIB=m
> 
> #
> # DCCP Kernel Hacking
> #
> # CONFIG_IP_DCCP_DEBUG is not set
> # CONFIG_NET_DCCPPROBE is not set
> CONFIG_IP_SCTP=m
> # CONFIG_SCTP_DBG_MSG is not set
> # CONFIG_SCTP_DBG_OBJCNT is not set
> # CONFIG_SCTP_HMAC_NONE is not set
> # CONFIG_SCTP_HMAC_SHA1 is not set
> CONFIG_SCTP_HMAC_MD5=y
> CONFIG_TIPC=m
> # CONFIG_TIPC_ADVANCED is not set
> # CONFIG_TIPC_DEBUG is not set
> # CONFIG_ATM is not set
> CONFIG_BRIDGE=m
> CONFIG_VLAN_8021Q=m
> CONFIG_DECNET=m
> CONFIG_DECNET_ROUTER=y
> CONFIG_LLC=m
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> CONFIG_WAN_ROUTER=m
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=m
> CONFIG_NET_SCH_HTB=m
> CONFIG_NET_SCH_HFSC=m
> CONFIG_NET_SCH_PRIO=m
> # CONFIG_NET_SCH_RR is not set
> CONFIG_NET_SCH_RED=m
> CONFIG_NET_SCH_SFQ=m
> CONFIG_NET_SCH_TEQL=m
> CONFIG_NET_SCH_TBF=m
> CONFIG_NET_SCH_GRED=m
> CONFIG_NET_SCH_DSMARK=m
> CONFIG_NET_SCH_NETEM=m
> CONFIG_NET_SCH_INGRESS=m
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=m
> CONFIG_NET_CLS_TCINDEX=m
> CONFIG_NET_CLS_ROUTE4=m
> CONFIG_NET_CLS_ROUTE=y
> CONFIG_NET_CLS_FW=m
> CONFIG_NET_CLS_U32=m
> CONFIG_CLS_U32_PERF=y
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=m
> CONFIG_NET_CLS_RSVP6=m
> # CONFIG_NET_CLS_FLOW is not set
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=m
> CONFIG_NET_EMATCH_NBYTE=m
> CONFIG_NET_EMATCH_U32=m
> CONFIG_NET_EMATCH_META=m
> CONFIG_NET_EMATCH_TEXT=m
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=m
> CONFIG_NET_ACT_GACT=m
> CONFIG_GACT_PROB=y
> CONFIG_NET_ACT_MIRRED=m
> CONFIG_NET_ACT_IPT=m
> # CONFIG_NET_ACT_NAT is not set
> CONFIG_NET_ACT_PEDIT=m
> CONFIG_NET_ACT_SIMP=m
> CONFIG_NET_CLS_IND=y
> CONFIG_NET_SCH_FIFO=y
> 
> #
> # Network testing
> #
> CONFIG_NET_PKTGEN=m
> # CONFIG_NET_TCPPROBE is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> CONFIG_FIB_RULES=y
> 
> #
> # Wireless
> #
> CONFIG_CFG80211=m
> CONFIG_NL80211=y
> CONFIG_WIRELESS_EXT=y
> CONFIG_MAC80211=m
> 
> #
> # Rate control algorithm selection
> #
> CONFIG_MAC80211_RC_DEFAULT_PID=y
> # CONFIG_MAC80211_RC_DEFAULT_SIMPLE is not set
> # CONFIG_MAC80211_RC_DEFAULT_NONE is not set
> 
> #
> # Selecting 'y' for an algorithm will
> #
> 
> #
> # build the algorithm into mac80211.
> #
> CONFIG_MAC80211_RC_DEFAULT="pid"
> CONFIG_MAC80211_RC_PID=y
> # CONFIG_MAC80211_RC_SIMPLE is not set
> # CONFIG_MAC80211_LEDS is not set
> # CONFIG_MAC80211_DEBUGFS is not set
> # CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
> # CONFIG_MAC80211_DEBUG is not set
> CONFIG_IEEE80211=m
> # CONFIG_IEEE80211_DEBUG is not set
> CONFIG_IEEE80211_CRYPT_WEP=m
> CONFIG_IEEE80211_CRYPT_CCMP=m
> CONFIG_IEEE80211_CRYPT_TKIP=m
> CONFIG_IEEE80211_SOFTMAC=m
> # CONFIG_IEEE80211_SOFTMAC_DEBUG is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> CONFIG_CONNECTOR=y
> CONFIG_PROC_EVENTS=y
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG is not set
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=m
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=m
> CONFIG_BLK_DEV_CRYPTOLOOP=m
> CONFIG_BLK_DEV_NBD=m
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=16384
> # CONFIG_BLK_DEV_XIP is not set
> CONFIG_CDROM_PKTCDVD=m
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_MISC_DEVICES is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=m
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=m
> CONFIG_SCSI_NETLINK=y
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=m
> CONFIG_CHR_DEV_ST=m
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=m
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=m
> CONFIG_CHR_DEV_SCH=m
> 
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=m
> CONFIG_SCSI_FC_ATTRS=m
> # CONFIG_SCSI_FC_TGT_ATTRS is not set
> CONFIG_SCSI_ISCSI_ATTRS=m
> CONFIG_SCSI_SAS_ATTRS=m
> CONFIG_SCSI_SAS_LIBSAS=m
> CONFIG_SCSI_SAS_ATA=y
> # CONFIG_SCSI_SAS_HOST_SMP is not set
> # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
> CONFIG_ATA=m
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_AHCI=m
> # CONFIG_SATA_SVW is not set
> CONFIG_ATA_PIIX=m
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_NV is not set
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SX4 is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIL24 is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_PATA_ACPI is not set
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> CONFIG_ATA_GENERIC=m
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_MARVELL is not set
> CONFIG_PATA_MPIIX=m
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PCMCIA is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> # CONFIG_MD is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_IEEE1394 is not set
> CONFIG_I2O=m
> # CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
> CONFIG_I2O_EXT_ADAPTEC=y
> # CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
> CONFIG_I2O_CONFIG=m
> CONFIG_I2O_CONFIG_OLD_IOCTL=y
> CONFIG_I2O_BUS=m
> CONFIG_I2O_BLOCK=m
> CONFIG_I2O_SCSI=m
> CONFIG_I2O_PROC=m
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> # CONFIG_NETDEVICES_MULTIQUEUE is not set
> CONFIG_IFB=m
> CONFIG_DUMMY=m
> CONFIG_BONDING=m
> # CONFIG_MACVLAN is not set
> CONFIG_EQUALIZER=m
> CONFIG_TUN=m
> # CONFIG_VETH is not set
> # CONFIG_NET_SB1000 is not set
> # CONFIG_ARCNET is not set
> # CONFIG_PHYLIB is not set
> CONFIG_NET_ETHERNET=y
> # CONFIG_MII is not set
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NET_VENDOR_3COM is not set
> CONFIG_NET_TULIP=y
> # CONFIG_DE2104X is not set
> CONFIG_TULIP=m
> CONFIG_TULIP_MWI=y
> CONFIG_TULIP_MMIO=y
> CONFIG_TULIP_NAPI=y
> CONFIG_TULIP_NAPI_HW_MITIGATION=y
> # CONFIG_DE4X5 is not set
> # CONFIG_WINBOND_840 is not set
> # CONFIG_DM9102 is not set
> # CONFIG_ULI526X is not set
> CONFIG_PCMCIA_XIRCOM=m
> # CONFIG_HP100 is not set
> # CONFIG_IBM_NEW_EMAC_ZMII is not set
> # CONFIG_IBM_NEW_EMAC_RGMII is not set
> # CONFIG_IBM_NEW_EMAC_TAH is not set
> # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
> # CONFIG_NET_PCI is not set
> # CONFIG_B44 is not set
> CONFIG_NETDEV_1000=y
> # CONFIG_ACENIC is not set
> # CONFIG_DL2K is not set
> # CONFIG_E1000 is not set
> # CONFIG_E1000E is not set
> # CONFIG_E1000E_ENABLED is not set
> # CONFIG_IP1000 is not set
> # CONFIG_IGB is not set
> # CONFIG_NS83820 is not set
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> # CONFIG_R8169 is not set
> # CONFIG_SIS190 is not set
> # CONFIG_SKGE is not set
> # CONFIG_SKY2 is not set
> # CONFIG_SK98LIN is not set
> # CONFIG_VIA_VELOCITY is not set
> CONFIG_TIGON3=m
> # CONFIG_BNX2 is not set
> # CONFIG_QLA3XXX is not set
> # CONFIG_ATL1 is not set
> # CONFIG_NETDEV_10000 is not set
> # CONFIG_TR is not set
> 
> #
> # Wireless LAN
> #
> # CONFIG_WLAN_PRE80211 is not set
> CONFIG_WLAN_80211=y
> # CONFIG_PCMCIA_RAYCS is not set
> # CONFIG_IPW2100 is not set
> # CONFIG_IPW2200 is not set
> # CONFIG_LIBERTAS is not set
> # CONFIG_AIRO is not set
> # CONFIG_HERMES is not set
> # CONFIG_ATMEL is not set
> # CONFIG_AIRO_CS is not set
> # CONFIG_PCMCIA_WL3501 is not set
> # CONFIG_PRISM54 is not set
> # CONFIG_USB_ZD1201 is not set
> # CONFIG_USB_NET_RNDIS_WLAN is not set
> # CONFIG_RTL8180 is not set
> # CONFIG_RTL8187 is not set
> # CONFIG_ADM8211 is not set
> # CONFIG_P54_COMMON is not set
> # CONFIG_ATH5K is not set
> # CONFIG_IWL4965 is not set
> CONFIG_IWL3945=m
> CONFIG_IWL3945_QOS=y
> CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
> CONFIG_IWL3945_DEBUG=y
> # CONFIG_HOSTAP is not set
> # CONFIG_BCM43XX is not set
> # CONFIG_B43 is not set
> # CONFIG_B43LEGACY is not set
> CONFIG_ZD1211RW=m
> # CONFIG_ZD1211RW_DEBUG is not set
> # CONFIG_RT2X00 is not set
> 
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_USBNET is not set
> # CONFIG_NET_PCMCIA is not set
> # CONFIG_WAN is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> CONFIG_PPP=m
> CONFIG_PPP_MULTILINK=y
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_SYNC_TTY=m
> CONFIG_PPP_DEFLATE=m
> # CONFIG_PPP_BSDCOMP is not set
> CONFIG_PPP_MPPE=m
> CONFIG_PPPOE=m
> # CONFIG_PPPOL2TP is not set
> CONFIG_SLIP=m
> CONFIG_SLIP_COMPRESSED=y
> CONFIG_SLHC=m
> CONFIG_SLIP_SMART=y
> # CONFIG_SLIP_MODE_SLIP6 is not set
> # CONFIG_NET_FC is not set
> CONFIG_NETCONSOLE=m
> # CONFIG_NETCONSOLE_DYNAMIC is not set
> CONFIG_NETPOLL=y
> CONFIG_NETPOLL_TRAP=y
> CONFIG_NET_POLL_CONTROLLER=y
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=m
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=m
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> CONFIG_MOUSE_SERIAL=m
> CONFIG_MOUSE_APPLETOUCH=m
> CONFIG_MOUSE_VSXXXAA=m
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_PCSPKR=m
> # CONFIG_INPUT_APANEL is not set
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> CONFIG_INPUT_UINPUT=m
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=m
> CONFIG_GAMEPORT=m
> CONFIG_GAMEPORT_NS558=m
> CONFIG_GAMEPORT_L4=m
> CONFIG_GAMEPORT_EMU10K1=m
> CONFIG_GAMEPORT_FM801=m
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> # CONFIG_SERIAL_8250_CS is not set
> CONFIG_SERIAL_8250_NR_UARTS=32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> CONFIG_SERIAL_8250_DETECT_IRQ=y
> CONFIG_SERIAL_8250_RSA=y
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_JSM=y
> CONFIG_UNIX98_PTYS=y
> # CONFIG_LEGACY_PTYS is not set
> CONFIG_IPMI_HANDLER=m
> # CONFIG_IPMI_PANIC_EVENT is not set
> CONFIG_IPMI_DEVICE_INTERFACE=m
> CONFIG_IPMI_SI=m
> CONFIG_IPMI_WATCHDOG=m
> CONFIG_IPMI_POWEROFF=m
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_INTEL=m
> CONFIG_HW_RANDOM_AMD=m
> CONFIG_NVRAM=y
> CONFIG_RTC=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> 
> #
> # PCMCIA character devices
> #
> # CONFIG_SYNCLINK_CS is not set
> # CONFIG_CARDMAN_4000 is not set
> # CONFIG_CARDMAN_4040 is not set
> # CONFIG_IPWIRELESS is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> CONFIG_HPET=y
> # CONFIG_HPET_RTC_IRQ is not set
> CONFIG_HPET_MMAP=y
> CONFIG_HANGCHECK_TIMER=m
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=m
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_CHARDEV=m
> 
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=m
> CONFIG_I2C_ALGOPCF=m
> CONFIG_I2C_ALGOPCA=m
> 
> #
> # I2C Hardware Bus support
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> CONFIG_I2C_I801=m
> # CONFIG_I2C_I810 is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_PROSAVAGE is not set
> # CONFIG_I2C_SAVAGE4 is not set
> # CONFIG_I2C_SIMTEC is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_TAOS_EVM is not set
> CONFIG_I2C_STUB=m
> # CONFIG_I2C_TINY_USB is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
> # CONFIG_I2C_VOODOO3 is not set
> 
> #
> # Miscellaneous I2C Chip support
> #
> # CONFIG_DS1682 is not set
> CONFIG_SENSORS_EEPROM=m
> CONFIG_SENSORS_PCF8574=m
> # CONFIG_PCF8575 is not set
> CONFIG_SENSORS_PCF8591=m
> # CONFIG_TPS65010 is not set
> CONFIG_SENSORS_MAX6875=m
> # CONFIG_SENSORS_TSL2550 is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_I2C_DEBUG_CHIP is not set
> 
> #
> # SPI support
> #
> # CONFIG_SPI is not set
> # CONFIG_SPI_MASTER is not set
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_BATTERY_DS2760 is not set
> CONFIG_HWMON=m
> CONFIG_HWMON_VID=m
> # CONFIG_SENSORS_ABITUGURU is not set
> # CONFIG_SENSORS_ABITUGURU3 is not set
> # CONFIG_SENSORS_AD7418 is not set
> # CONFIG_SENSORS_ADM1021 is not set
> # CONFIG_SENSORS_ADM1025 is not set
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7473 is not set
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_ASB100 is not set
> # CONFIG_SENSORS_ATXP1 is not set
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_FSCHER is not set
> # CONFIG_SENSORS_FSCPOS is not set
> # CONFIG_SENSORS_FSCHMD is not set
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> # CONFIG_SENSORS_CORETEMP is not set
> # CONFIG_SENSORS_IBMPEX is not set
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_LM63 is not set
> # CONFIG_SENSORS_LM75 is not set
> # CONFIG_SENSORS_LM77 is not set
> # CONFIG_SENSORS_LM78 is not set
> # CONFIG_SENSORS_LM80 is not set
> # CONFIG_SENSORS_LM83 is not set
> # CONFIG_SENSORS_LM85 is not set
> # CONFIG_SENSORS_LM87 is not set
> # CONFIG_SENSORS_LM90 is not set
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> # CONFIG_SENSORS_MAX1619 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> CONFIG_SENSORS_DME1737=m
> CONFIG_SENSORS_SMSC47M1=m
> CONFIG_SENSORS_SMSC47M192=m
> CONFIG_SENSORS_SMSC47B397=m
> # CONFIG_SENSORS_ADS7828 is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> # CONFIG_SENSORS_W83781D is not set
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> # CONFIG_SENSORS_W83793 is not set
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_SENSORS_APPLESMC is not set
> # CONFIG_HWMON_DEBUG_CHIP is not set
> CONFIG_THERMAL=y
> CONFIG_WATCHDOG=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=m
> # CONFIG_ACQUIRE_WDT is not set
> # CONFIG_ADVANTECH_WDT is not set
> CONFIG_ALIM1535_WDT=m
> CONFIG_ALIM7101_WDT=m
> # CONFIG_SC520_WDT is not set
> # CONFIG_EUROTECH_WDT is not set
> # CONFIG_IB700_WDT is not set
> CONFIG_IBMASR=m
> # CONFIG_WAFER_WDT is not set
> CONFIG_I6300ESB_WDT=m
> CONFIG_ITCO_WDT=m
> CONFIG_ITCO_VENDOR_SUPPORT=y
> # CONFIG_IT8712F_WDT is not set
> # CONFIG_HP_WATCHDOG is not set
> # CONFIG_SC1200_WDT is not set
> # CONFIG_PC87413_WDT is not set
> # CONFIG_60XX_WDT is not set
> # CONFIG_SBC8360_WDT is not set
> # CONFIG_CPU5_WDT is not set
> # CONFIG_SMSC37B787_WDT is not set
> CONFIG_W83627HF_WDT=m
> CONFIG_W83697HF_WDT=m
> CONFIG_W83877F_WDT=m
> CONFIG_W83977F_WDT=m
> CONFIG_MACHZ_WDT=m
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> 
> #
> # PCI-based Watchdog Cards
> #
> CONFIG_PCIPCWATCHDOG=m
> CONFIG_WDTPCI=m
> CONFIG_WDT_501_PCI=y
> 
> #
> # USB-based Watchdog Cards
> #
> CONFIG_USBPCWATCHDOG=m
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB_POSSIBLE=y
> # CONFIG_SSB is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_SM501=m
> 
> #
> # Multimedia devices
> #
> CONFIG_VIDEO_DEV=m
> CONFIG_VIDEO_V4L2_COMMON=m
> CONFIG_VIDEO_V4L1=y
> CONFIG_VIDEO_V4L1_COMPAT=y
> CONFIG_VIDEO_V4L2=y
> CONFIG_VIDEO_CAPTURE_DRIVERS=y
> # CONFIG_VIDEO_ADV_DEBUG is not set
> CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
> # CONFIG_VIDEO_VIVI is not set
> # CONFIG_VIDEO_BT848 is not set
> # CONFIG_VIDEO_CPIA is not set
> # CONFIG_VIDEO_CPIA2 is not set
> # CONFIG_VIDEO_SAA5246A is not set
> # CONFIG_VIDEO_SAA5249 is not set
> # CONFIG_TUNER_3036 is not set
> # CONFIG_VIDEO_STRADIS is not set
> # CONFIG_VIDEO_ZORAN is not set
> # CONFIG_VIDEO_SAA7134 is not set
> # CONFIG_VIDEO_MXB is not set
> # CONFIG_VIDEO_DPC is not set
> # CONFIG_VIDEO_HEXIUM_ORION is not set
> # CONFIG_VIDEO_HEXIUM_GEMINI is not set
> # CONFIG_VIDEO_CX88 is not set
> # CONFIG_VIDEO_IVTV is not set
> # CONFIG_VIDEO_CAFE_CCIC is not set
> CONFIG_V4L_USB_DRIVERS=y
> # CONFIG_VIDEO_PVRUSB2 is not set
> # CONFIG_VIDEO_EM28XX is not set
> # CONFIG_VIDEO_USBVISION is not set
> # CONFIG_USB_VICAM is not set
> # CONFIG_USB_IBMCAM is not set
> # CONFIG_USB_KONICAWC is not set
> # CONFIG_USB_QUICKCAM_MESSENGER is not set
> # CONFIG_USB_ET61X251 is not set
> # CONFIG_VIDEO_OVCAMCHIP is not set
> # CONFIG_USB_W9968CF is not set
> # CONFIG_USB_OV511 is not set
> # CONFIG_USB_SE401 is not set
> # CONFIG_USB_SN9C102 is not set
> # CONFIG_USB_STV680 is not set
> # CONFIG_USB_ZC0301 is not set
> CONFIG_USB_PWC=m
> # CONFIG_USB_PWC_DEBUG is not set
> # CONFIG_USB_ZR364XX is not set
> # CONFIG_USB_STKWEBCAM is not set
> # CONFIG_RADIO_ADAPTERS is not set
> # CONFIG_DVB_CORE is not set
> # CONFIG_DAB is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_AMD64=y
> CONFIG_AGP_INTEL=y
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_VIA is not set
> CONFIG_DRM=m
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_I810 is not set
> # CONFIG_DRM_I830 is not set
> CONFIG_DRM_I915=m
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_VGASTATE is not set
> CONFIG_VIDEO_OUTPUT_CONTROL=m
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=m
> CONFIG_FB_CFB_FILLRECT=m
> CONFIG_FB_CFB_COPYAREA=m
> CONFIG_FB_CFB_IMAGEBLIT=m
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> # CONFIG_FB_SYS_FILLRECT is not set
> # CONFIG_FB_SYS_COPYAREA is not set
> # CONFIG_FB_SYS_IMAGEBLIT is not set
> # CONFIG_FB_SYS_FOPS is not set
> CONFIG_FB_DEFERRED_IO=y
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> # CONFIG_FB_ARC is not set
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> # CONFIG_FB_UVESA is not set
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_EFI is not set
> # CONFIG_FB_HECUBA is not set
> # CONFIG_FB_HGA is not set
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_LE80578 is not set
> CONFIG_FB_INTEL=m
> CONFIG_FB_INTEL_DEBUG=y
> CONFIG_FB_INTEL_I2C=y
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_GEODE is not set
> # CONFIG_FB_SM501 is not set
> # CONFIG_FB_VIRTUAL is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=m
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> # CONFIG_BACKLIGHT_CORGI is not set
> CONFIG_BACKLIGHT_PROGEAR=m
> 
> #
> # Display device support
> #
> CONFIG_DISPLAY_SUPPORT=m
> 
> #
> # Display hardware drivers
> #
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> CONFIG_VIDEO_SELECT=y
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> CONFIG_LOGO=y
> # CONFIG_LOGO_LINUX_MONO is not set
> # CONFIG_LOGO_LINUX_VGA16 is not set
> CONFIG_LOGO_LINUX_CLUT224=y
> 
> #
> # Sound
> #
> CONFIG_SOUND=m
> 
> #
> # Advanced Linux Sound Architecture
> #
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_HWDEP=m
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_SEQUENCER=m
> CONFIG_SND_SEQ_DUMMY=m
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=m
> CONFIG_SND_PCM_OSS=m
> CONFIG_SND_PCM_OSS_PLUGINS=y
> CONFIG_SND_SEQUENCER_OSS=y
> # CONFIG_SND_RTCTIMER is not set
> CONFIG_SND_DYNAMIC_MINORS=y
> # CONFIG_SND_SUPPORT_OLD_API is not set
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> 
> #
> # Generic devices
> #
> CONFIG_SND_MPU401_UART=m
> CONFIG_SND_DUMMY=m
> CONFIG_SND_VIRMIDI=m
> CONFIG_SND_MTPAV=m
> # CONFIG_SND_SERIAL_U16550 is not set
> CONFIG_SND_MPU401=m
> 
> #
> # PCI devices
> #
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> CONFIG_SND_HDA_INTEL=m
> CONFIG_SND_HDA_HWDEP=y
> # CONFIG_SND_HDA_CODEC_REALTEK is not set
> CONFIG_SND_HDA_CODEC_ANALOG=y
> # CONFIG_SND_HDA_CODEC_SIGMATEL is not set
> # CONFIG_SND_HDA_CODEC_VIA is not set
> # CONFIG_SND_HDA_CODEC_ATIHDMI is not set
> # CONFIG_SND_HDA_CODEC_CONEXANT is not set
> # CONFIG_SND_HDA_CODEC_CMEDIA is not set
> CONFIG_SND_HDA_CODEC_SI3054=y
> CONFIG_SND_HDA_GENERIC=y
> # CONFIG_SND_HDA_POWER_SAVE is not set
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_HIFIER is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> # CONFIG_SND_INTEL8X0 is not set
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> 
> #
> # USB devices
> #
> CONFIG_SND_USB_AUDIO=m
> CONFIG_SND_USB_USX2Y=m
> CONFIG_SND_USB_CAIAQ=m
> CONFIG_SND_USB_CAIAQ_INPUT=y
> CONFIG_SND_USB_US122L=m
> 
> #
> # PCMCIA devices
> #
> # CONFIG_SND_VXPOCKET is not set
> # CONFIG_SND_PDAUDIOCF is not set
> 
> #
> # System on Chip audio support
> #
> # CONFIG_SND_SOC is not set
> 
> #
> # SoC Audio support for SuperH
> #
> 
> #
> # ALSA SoC audio for Freescale SOCs
> #
> 
> #
> # Open Sound System
> #
> # CONFIG_SOUND_PRIME is not set
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> # CONFIG_HID_DEBUG is not set
> # CONFIG_HIDRAW is not set
> 
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=y
> # CONFIG_USB_HIDINPUT_POWERBOOK is not set
> CONFIG_HID_FF=y
> CONFIG_HID_PID=y
> CONFIG_LOGITECH_FF=y
> CONFIG_PANTHERLORD_FF=y
> CONFIG_THRUSTMASTER_FF=y
> CONFIG_ZEROPLUS_FF=y
> CONFIG_USB_HIDDEV=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> CONFIG_USB_DEBUG=y
> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> CONFIG_USB_DEVICE_CLASS=y
> # CONFIG_USB_DYNAMIC_MINORS is not set
> CONFIG_USB_SUSPEND=y
> CONFIG_USB_PERSIST=y
> # CONFIG_USB_OTG is not set
> 
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_EHCI_HCD=m
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> # CONFIG_USB_ISP116X_HCD is not set
> CONFIG_USB_OHCI_HCD=m
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_UHCI_HCD=m
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> 
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> CONFIG_USB_PRINTER=m
> 
> #
> # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
> #
> 
> #
> # may also be needed; see USB_STORAGE Help for more information
> #
> CONFIG_USB_STORAGE=m
> # CONFIG_USB_STORAGE_DEBUG is not set
> CONFIG_USB_STORAGE_DATAFAB=y
> CONFIG_USB_STORAGE_FREECOM=y
> # CONFIG_USB_STORAGE_ISD200 is not set
> CONFIG_USB_STORAGE_DPCM=y
> CONFIG_USB_STORAGE_USBAT=y
> CONFIG_USB_STORAGE_SDDR09=y
> CONFIG_USB_STORAGE_SDDR55=y
> CONFIG_USB_STORAGE_JUMPSHOT=y
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_KARMA is not set
> # CONFIG_USB_LIBUSUAL is not set
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> CONFIG_USB_MON=y
> 
> #
> # USB port drivers
> #
> # CONFIG_USB_SERIAL is not set
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_AUERSWALD is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_BERRY_CHARGE is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_PHIDGET is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_GADGET is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> # CONFIG_LEDS_CLEVO_MAIL is not set
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=m
> CONFIG_LEDS_TRIGGER_HEARTBEAT=m
> # CONFIG_INFINIBAND is not set
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> 
> #
> # Conflicting RTC option has been selected, check GEN_RTC and RTC
> #
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS1307=m
> # CONFIG_RTC_DRV_DS1374 is not set
> CONFIG_RTC_DRV_DS1672=m
> CONFIG_RTC_DRV_MAX6900=m
> CONFIG_RTC_DRV_RS5C372=m
> CONFIG_RTC_DRV_ISL1208=m
> CONFIG_RTC_DRV_X1205=m
> CONFIG_RTC_DRV_PCF8563=m
> CONFIG_RTC_DRV_PCF8583=m
> # CONFIG_RTC_DRV_M41T80 is not set
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=m
> # CONFIG_RTC_DRV_DS1511 is not set
> CONFIG_RTC_DRV_DS1553=m
> CONFIG_RTC_DRV_DS1742=m
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> CONFIG_RTC_DRV_V3020=m
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> 
> #
> # Userspace I/O
> #
> CONFIG_UIO=m
> # CONFIG_UIO_CIF is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=m
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> CONFIG_DMIID=y
> 
> #
> # File systems
> #
> CONFIG_EXT2_FS=m
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> CONFIG_EXT2_FS_XIP=y
> CONFIG_FS_XIP=y
> CONFIG_EXT3_FS=m
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> # CONFIG_EXT4DEV_FS is not set
> CONFIG_JBD=m
> # CONFIG_JBD_DEBUG is not set
> CONFIG_FS_MBCACHE=m
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> CONFIG_FS_POSIX_ACL=y
> # CONFIG_XFS_FS is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_QUOTA is not set
> CONFIG_AUTOFS_FS=m
> CONFIG_AUTOFS4_FS=m
> CONFIG_FUSE_FS=m
> CONFIG_GENERIC_ACL=y
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> CONFIG_MSDOS_FS=m
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
> CONFIG_NTFS_FS=m
> # CONFIG_NTFS_DEBUG is not set
> # CONFIG_NTFS_RW is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_VMCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=m
> 
> #
> # Miscellaneous filesystems
> #
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_ECRYPT_FS is not set
> CONFIG_HFS_FS=m
> CONFIG_HFSPLUS_FS=m
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> CONFIG_CRAMFS=m
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> CONFIG_ROMFS_FS=m
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=m
> CONFIG_NFS_V3=y
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=y
> CONFIG_NFS_DIRECTIO=y
> CONFIG_NFSD=m
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_NFSD_V4=y
> CONFIG_NFSD_TCP=y
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_EXPORTFS=m
> CONFIG_NFS_ACL_SUPPORT=m
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> CONFIG_SUNRPC_GSS=m
> CONFIG_SUNRPC_BIND34=y
> CONFIG_RPCSEC_GSS_KRB5=m
> CONFIG_RPCSEC_GSS_SPKM3=m
> # CONFIG_SMB_FS is not set
> CONFIG_CIFS=m
> # CONFIG_CIFS_STATS is not set
> CONFIG_CIFS_WEAK_PW_HASH=y
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> # CONFIG_CIFS_DEBUG2 is not set
> # CONFIG_CIFS_EXPERIMENTAL is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> # CONFIG_OSF_PARTITION is not set
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> CONFIG_MAC_PARTITION=y
> CONFIG_MSDOS_PARTITION=y
> CONFIG_BSD_DISKLABEL=y
> CONFIG_MINIX_SUBPARTITION=y
> CONFIG_SOLARIS_X86_PARTITION=y
> CONFIG_UNIXWARE_DISKLABEL=y
> # CONFIG_LDM_PARTITION is not set
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> CONFIG_KARMA_PARTITION=y
> # CONFIG_EFI_PARTITION is not set
> # CONFIG_SYSV68_PARTITION is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="utf8"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=m
> CONFIG_NLS_CODEPAGE_775=m
> CONFIG_NLS_CODEPAGE_850=m
> CONFIG_NLS_CODEPAGE_852=m
> CONFIG_NLS_CODEPAGE_855=m
> CONFIG_NLS_CODEPAGE_857=m
> CONFIG_NLS_CODEPAGE_860=m
> CONFIG_NLS_CODEPAGE_861=m
> CONFIG_NLS_CODEPAGE_862=m
> CONFIG_NLS_CODEPAGE_863=m
> CONFIG_NLS_CODEPAGE_864=m
> CONFIG_NLS_CODEPAGE_865=m
> CONFIG_NLS_CODEPAGE_866=m
> CONFIG_NLS_CODEPAGE_869=m
> CONFIG_NLS_CODEPAGE_936=m
> CONFIG_NLS_CODEPAGE_950=m
> CONFIG_NLS_CODEPAGE_932=m
> CONFIG_NLS_CODEPAGE_949=m
> CONFIG_NLS_CODEPAGE_874=m
> CONFIG_NLS_ISO8859_8=m
> CONFIG_NLS_CODEPAGE_1250=m
> CONFIG_NLS_CODEPAGE_1251=m
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=m
> CONFIG_NLS_ISO8859_2=m
> CONFIG_NLS_ISO8859_3=m
> CONFIG_NLS_ISO8859_4=m
> CONFIG_NLS_ISO8859_5=m
> CONFIG_NLS_ISO8859_6=m
> CONFIG_NLS_ISO8859_7=m
> CONFIG_NLS_ISO8859_9=m
> CONFIG_NLS_ISO8859_13=m
> CONFIG_NLS_ISO8859_14=m
> CONFIG_NLS_ISO8859_15=m
> CONFIG_NLS_KOI8_R=m
> CONFIG_NLS_KOI8_U=m
> CONFIG_NLS_UTF8=m
> CONFIG_DLM=m
> CONFIG_DLM_DEBUG=y
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_SHIRQ is not set
> # CONFIG_DETECT_SOFTLOCKUP is not set
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> # CONFIG_TIMER_STATS is not set
> # CONFIG_DEBUG_SLAB is not set
> # CONFIG_DEBUG_PREEMPT is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_INFO is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_DEBUG_SG is not set
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_KPROBES_SANITY_TEST is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_LKDTM is not set
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_LATENCYTOP=y
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_SAMPLES is not set
> CONFIG_EARLY_PRINTK=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> # CONFIG_DEBUG_RODATA is not set
> # CONFIG_DEBUG_NX_TEST is not set
> CONFIG_X86_MPPARSE=y
> # CONFIG_IOMMU_DEBUG is not set
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> CONFIG_IO_DELAY_NONE=y
> CONFIG_DEFAULT_IO_DELAY_TYPE=3
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> CONFIG_KEYS_DEBUG_PROC_KEYS=y
> CONFIG_SECURITY=y
> CONFIG_SECURITY_NETWORK=y
> CONFIG_SECURITY_NETWORK_XFRM=y
> CONFIG_SECURITY_CAPABILITIES=y
> # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> # CONFIG_SECURITY_ROOTPLUG is not set
> CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=65536
> CONFIG_SECURITY_SELINUX=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
> CONFIG_SECURITY_SELINUX_DISABLE=y
> CONFIG_SECURITY_SELINUX_DEVELOP=y
> CONFIG_SECURITY_SELINUX_AVC_STATS=y
> CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> # CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
> # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
> # CONFIG_SECURITY_SMACK is not set
> CONFIG_CRYPTO=y
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_AEAD=m
> CONFIG_CRYPTO_BLKCIPHER=m
> # CONFIG_CRYPTO_SEQIV is not set
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=m
> CONFIG_CRYPTO_NULL=m
> CONFIG_CRYPTO_MD4=m
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=m
> CONFIG_CRYPTO_SHA512=m
> CONFIG_CRYPTO_WP512=m
> CONFIG_CRYPTO_TGR192=m
> CONFIG_CRYPTO_GF128MUL=m
> CONFIG_CRYPTO_ECB=m
> CONFIG_CRYPTO_CBC=m
> CONFIG_CRYPTO_PCBC=m
> CONFIG_CRYPTO_LRW=m
> # CONFIG_CRYPTO_XTS is not set
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_GCM is not set
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_CRYPTD is not set
> CONFIG_CRYPTO_DES=m
> CONFIG_CRYPTO_FCRYPT=m
> CONFIG_CRYPTO_BLOWFISH=m
> CONFIG_CRYPTO_TWOFISH=m
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_X86_64=m
> CONFIG_CRYPTO_SERPENT=m
> CONFIG_CRYPTO_AES=m
> CONFIG_CRYPTO_AES_X86_64=m
> CONFIG_CRYPTO_CAST5=m
> CONFIG_CRYPTO_CAST6=m
> CONFIG_CRYPTO_TEA=m
> CONFIG_CRYPTO_ARC4=m
> CONFIG_CRYPTO_KHAZAD=m
> CONFIG_CRYPTO_ANUBIS=m
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SALSA20_X86_64 is not set
> CONFIG_CRYPTO_DEFLATE=m
> CONFIG_CRYPTO_MICHAEL_MIC=m
> CONFIG_CRYPTO_CRC32C=m
> CONFIG_CRYPTO_CAMELLIA=m
> # CONFIG_CRYPTO_TEST is not set
> # CONFIG_CRYPTO_AUTHENC is not set
> # CONFIG_CRYPTO_LZO is not set
> # CONFIG_CRYPTO_HW is not set
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_CRC_CCITT=m
> CONFIG_CRC16=m
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=y
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=m
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=m
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=m
> CONFIG_TEXTSEARCH_BM=m
> CONFIG_TEXTSEARCH_FSM=m
> CONFIG_PLIST=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y

