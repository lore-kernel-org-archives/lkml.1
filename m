Return-Path: <linux-kernel-owner+w=401wt.eu-S965465AbXJPUb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965465AbXJPUb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933970AbXJPUbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:31:50 -0400
Received: from hs-out-0708.google.com ([64.233.178.247]:46068 "EHLO
	hs-out-2021.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934295AbXJPUbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:31:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=l5S3IINwc5B8xk/qwHBrij+SkAA6VpoOwm9zFds1itNQ466RV7EA3XsyBsobK4Ma/xJQMLhT7jDUJ3BYz8hJHvS3fESiB/MUHp9gO5hRp44jq0gex795SKIvgZrGQOS7k1nSlaayTVWl7hOCkegDQtYTKfN+jHyrgbipgWQiOmY=
Message-ID: <19b271a20710161331m35c02a18p6967506ad0a6764c@mail.gmail.com>
Date: Tue, 16 Oct 2007 16:31:46 -0400
From: "Joshua Roys" <roysjosh@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23 hang, unstable clocksource?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am running a vanilla 2.6.23 kernel and am experiencing (seemingly)
random hangs.  Below is a piece of dmesg and my kernel config, along
with a few snippets from /var/log/messages showing a 5 minute hang
(and another hang, but I wasn't at the computer at that time).

This has happened probably over 10 times all told, now.  The first few
times I just hard-booted the machine, today I decided to be patient,
and after 5 minutes it became usable again.

I've run memtest on it, so I don't think it's the memory...  Any help
is greatly appreciated!

As this is my first post, I apologize in advance if I have done
something stupid..!

Thanks,

Joshua Roys


dmesg:
Linux version 2.6.23 (root@orannis) (gcc version 4.2.1 (Gentoo 4.2.1
p1.0)) #1 Fri Oct 12 16:55:58 EDT 2007
ACPI: RSDP 000FEC00, 0014 (r0 DELL  )
ACPI: RSDT 000FCC05, 0040 (r1 DELL    GX280          7 ASL        61)
ACPI: FACP 000FCC45, 0074 (r1 DELL    GX280          7 ASL        61)
ACPI: DSDT FFFD060C, 30BF (r1   DELL    dt_ex     1000 MSFT  100000D)
ACPI: FACS 1F686C00, 0040
ACPI: SSDT FFFD3808, 00BA (r1   DELL    st_ex     1000 MSFT  100000D)
ACPI: APIC 000FCCB9, 0072 (r1 DELL    GX280          7 ASL        61)
ACPI: BOOT 000FCD2B, 0028 (r1 DELL    GX280          7 ASL        61)
ACPI: ASF! 000FCD53, 0067 (r16 DELL    GX280          7 ASL        61)
ACPI: MCFG 000FCDBA, 003E (r1 DELL    GX280          7 ASL        61)
ACPI: HPET 000FCDF8, 0038 (r1 DELL    GX280          7 ASL        61)
ACPI: PM-Timer IO Port: 0x808
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Kernel command line: root=/dev/sda2
Initializing CPU#0
Detected 2660.302 MHz processor.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 5324.67 BogoMIPS (lpj=10649351)
CPU: After generic identify, caps: bfebfbff 00100000 00000000 00000000
0000451d 00000000 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: bfebfbff 00100000 00000000 0000b180
0000451d 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU: Intel(R) Celeron(R) CPU 2.66GHz stepping 01
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin
is 60 seconds).
Hangcheck: Using get_cycles().
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available

- I missed this hang, according to /var/log/messages it occured at
8:14pm last night (Oct 15)
- I ran ntpdate here to fix the time, which was off by 65 seconds.
Oct 16 13:43:01 orannis ntpdate[7326]: step time server 128.10.252.7
offset -65.263313 sec

Clocksource tsc unstable (delta = 299948628229 ns)
Time: hpet clocksource has been installed.
Hangcheck: hangcheck value past margin!

- At work today, it hung again..  alt+sysrq+...

SysRq : Show State
 ... ### if you want this I can attach it - it's over 2000 lines long though.
Sched Debug Version: v0.05-v20, 2.6.23 #1
now at 80245023939357 nsecs

cpu#0, 332.537 MHz
  .nr_running                    : 2
  .load                          : 4145
  .ls.delta_fair                 : 551290
  .ls.delta_exec                 : 4003775
  .nr_switches                   : 6623798
  .nr_load_updates               : 2791244
  .nr_uninterruptible            : 3
  .jiffies                       : 19982367
  .next_balance                  : 0
  .curr->pid                     : 0
  .clock                         : 11165679112678
  .idle_clock                    : 0
  .prev_clock_raw                : 80066836480537
  .clock_warps                   : 0
  .clock_overflows               : 3224618
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 4000249
  .cpu_load[0]                   : 4095
  .cpu_load[1]                   : 4129
  .cpu_load[2]                   : 4134
  .cpu_load[3]                   : 4051
  .cpu_load[4]                   : 3928

cfs_rq
  .fair_clock                    : 2455377800303
  .exec_clock                    : 3086338962623
  .wait_runtime                  : 0
  .wait_runtime_overruns         : 0
  .wait_runtime_underruns        : 0
  .sleeper_bonus                 : 17477810
  .wait_runtime_rq_sum           : 40000000

runnable tasks:
            task   PID        tree-key         delta       waiting
switches  prio        sum-exec        sum-wait       sum-sleep
wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
        events/0     5   2455371238304      -6561999      20000000
64492   115               0               0               0
   0               0
       syslog-ng  3601   2455357800303     -20000000      20000000
  252   120               0               0               0
   0               0

SysRq : Show Memory
SysRq : Show Blocked State
  task                PC stack   pid father
kswapd0       D c14c3efc     0   200      2
       c14c3eec 00000046 c14c2000 c14c3efc 0130e838 00000282 c14c3efc 0130e838
       00000001 c14c3f20 c03f94f6 c14c3efc 00000080 c058eb48 c058eb48 0130e838
       c011c342 df63c570 c058e980 c04e8574 00000019 c03f904f c04e81e4 c0143fa9
Call Trace:
 [<c03f94f6>] schedule_timeout+0x43/0x9f
 [<c011c342>] process_timeout+0x0/0x5
 [<c03f904f>] io_schedule_timeout+0xe/0x16
 [<c0143fa9>] congestion_wait+0x4a/0x5e
 [<c01244a8>] autoremove_wake_function+0x0/0x35
 [<c0143233>] kswapd+0x39c/0x3be
 [<c01244a8>] autoremove_wake_function+0x0/0x35
 [<c0142e97>] kswapd+0x0/0x3be
 [<c01241ed>] kthread+0x33/0x54
 [<c01241ba>] kthread+0x0/0x54
 [<c0102903>] kernel_thread_helper+0x7/0x14
 =======================
gnome-session D c10fc3e0     0  4666   4648
       d3903dbc 00000082 d3902000 c10fc3e0 d3903df4 c13f01e0 d3903dec c10fc3e0
       d3903df4 d3903dc4 c03f92ce c13f01e0 c013b29c c03f95b0 c013b270 d3903dec
       c10fc3e0 d3903e08 00000000 c013b261 00000002 c10fc3e0 00000000 00000001
Call Trace:
 [<c03f92ce>] io_schedule+0xe/0x16
 [<c013b29c>] sync_page+0x2c/0x38
 [<c03f95b0>] __wait_on_bit_lock+0x3c/0x5e
 [<c013b270>] sync_page+0x0/0x38
 [<c013b261>] __lock_page+0x58/0x5f
 [<c01244dd>] wake_bit_function+0x0/0x3c
 [<c013b7d0>] do_generic_mapping_read+0x202/0x48b
 [<c013d08d>] generic_file_aio_read+0x126/0x160
 [<c013b09a>] file_read_actor+0x0/0xe2
 [<c0155c3c>] do_sync_read+0xd1/0x10d
 [<c01244a8>] autoremove_wake_function+0x0/0x35
 [<c0155b6b>] do_sync_read+0x0/0x10d
 [<c0156442>] vfs_read+0xa3/0x120
 [<c0156781>] sys_read+0x41/0x6a
 [<c0102602>] sysenter_past_esp+0x5f/0x85
 [<c03f0000>] svc_recvfrom+0xe5/0x108
 =======================
emerge        D c93afe88     0  8056   4785
       c93afe78 00000082 c93ae000 c93afe88 0130e824 00000282 c93afe88 0130e824
       000a80d2 c93afeac c03f94f6 00000001 cafa8030 cde97e68 c058eaa8 0130e824
       c011c342 cafa8030 c058e980 c04e8574 00000005 c03f904f 00000000 c0143fa9
Call Trace:
 [<c03f94f6>] schedule_timeout+0x43/0x9f
 [<c011c342>] process_timeout+0x0/0x5
 [<c03f904f>] io_schedule_timeout+0xe/0x16
 [<c0143fa9>] congestion_wait+0x4a/0x5e
 [<c01244a8>] autoremove_wake_function+0x0/0x35
 [<c013f3b2>] __alloc_pages+0x1b3/0x30d
 [<c0364929>] netif_receive_skb+0x285/0x2dc
 [<c0146175>] handle_mm_fault+0x34b/0x57c
 [<c03fb776>] do_page_fault+0x406/0x650
 [<c03668ec>] net_rx_action+0x7b/0x145
 [<c01190d5>] __do_softirq+0x3e/0x83
 [<c03fb370>] do_page_fault+0x0/0x650
 [<c03fa252>] error_code+0x6a/0x70
 [<c03f0000>] svc_recvfrom+0xe5/0x108
 =======================
gnome-screens D c050fe40     0  8060      1
       cde97e58 00200082 cde96000 c050fe40 0130e824 00200282 cde97e68 0130e824
       000a00d2 cde97e8c c03f94f6 00000001 cbf92570 c058eaa8 c93afe88 0130e824
       c011c342 cbf92570 c058e980 c04e8574 00000005 c03f904f 00000000 c0143fa9
Call Trace:
 [<c03f94f6>] schedule_timeout+0x43/0x9f
 [<c011c342>] process_timeout+0x0/0x5
 [<c03f904f>] io_schedule_timeout+0xe/0x16
 [<c0143fa9>] congestion_wait+0x4a/0x5e
 [<c01244a8>] autoremove_wake_function+0x0/0x35
 [<c013f3b2>] __alloc_pages+0x1b3/0x30d
 [<c0144fb4>] do_wp_page+0x93/0x3c4
 [<c0146258>] handle_mm_fault+0x42e/0x57c
 [<c03fb776>] do_page_fault+0x406/0x650
 [<c01498a6>] do_mmap_pgoff+0x319/0x33b
 [<c03fb370>] do_page_fault+0x0/0x650
 [<c03fa252>] error_code+0x6a/0x70
 [<c03f0000>] svc_recvfrom+0xe5/0x108
 =======================
Sched Debug Version: v0.05-v20, 2.6.23 #1
now at 80263020499008 nsecs

cpu#0, 332.537 MHz
  .nr_running                    : 2
  .load                          : 4145
  .ls.delta_fair                 : 552493
  .ls.delta_exec                 : 4007278
  .nr_switches                   : 6624405
  .nr_load_updates               : 2791244
  .nr_uninterruptible            : 4
  .jiffies                       : 19982367
  .next_balance                  : 0
  .curr->pid                     : 0
  .clock                         : 11165679116181
  .idle_clock                    : 0
  .prev_clock_raw                : 80084855328142
  .clock_warps                   : 0
  .clock_overflows               : 3228121
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 4000249
  .cpu_load[0]                   : 4095
  .cpu_load[1]                   : 4129
  .cpu_load[2]                   : 4134
  .cpu_load[3]                   : 4051
  .cpu_load[4]                   : 3928

cfs_rq
  .fair_clock                    : 2455377801087
  .exec_clock                    : 3086338966077
  .wait_runtime                  : 0
  .wait_runtime_overruns         : 0
  .wait_runtime_underruns        : 0
  .sleeper_bonus                 : 20948392
  .wait_runtime_rq_sum           : 39999661

runnable tasks:
            task   PID        tree-key         delta       waiting
switches  prio        sum-exec        sum-wait       sum-sleep
wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
        events/0     5   2455371239088      -6561999      20000000
64512   115               0               0               0
   0               0
       syslog-ng  3601   2455357801426     -19999661      19999661
  254   120               0               0               0
   0               0

SysRq : Show Memory
Hangcheck: hangcheck value past margin!


- Now /var/log/messages.  I think the SysRq took a decent amount of
time to show up in /var/log/messages, so the time shown is probably
not correct.
Oct 16 14:39:57 orannis SysRq : Show State
Oct 16 14:40:11 orannis SysRq : Show Memory
Oct 16 14:40:15 orannis SysRq : Show Blocked State
Oct 16 14:40:33 orannis SysRq : Show Memory
- It unfroze and my ctrl+alt+f1 went through, so I logged in
- Notice that time goes backwards?
Oct 16 14:39:51 orannis login[8080]: ROOT LOGIN  on 'tty1'
Oct 16 14:40:25 orannis Hangcheck: hangcheck value past margin!
- I started ntpdate, noticing the time was off
Oct 16 14:50:19 orannis ntpdate[8561]: step time server 66.199.242.154
offset 299.934964 sec


Kernel config:
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
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
CONFIG_SLAB=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_X86_PC=y
CONFIG_MPENTIUM4=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
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
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_VM86=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_DMIID=y
CONFIG_NOHIGHMEM=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
CONFIG_SECCOMP=y
CONFIG_HZ_250=y
CONFIG_HZ=250
CONFIG_PHYSICAL_START=0x100000
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
CONFIG_PM=y
CONFIG_SUSPEND_UP_POSSIBLE=y
CONFIG_HIBERNATION_UP_POSSIBLE=y
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_BLACKLIST_YEAR=2001
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_BINFMT_ELF=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_NET_KEY=m
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_IPV6=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_IPV6_SIT=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_BRIDGE_NETFILTER=y
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK_ENABLED=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_IPRANGE=m
CONFIG_IP_NF_MATCH_TOS=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_OWNER=m
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
CONFIG_LLC=m
CONFIG_LLC2=m
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_PNP=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_MISC_DEVICES=y
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_PROC_FS=y
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_SCSI_WAIT_SCAN=m
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_ATA=y
CONFIG_ATA_ACPI=y
CONFIG_ATA_PIIX=y
CONFIG_NETDEVICES=y
CONFIG_TUN=y
CONFIG_NETDEV_1000=y
CONFIG_TIGON3=y
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_INPUT=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_RTC=y
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_DRM=y
CONFIG_DRM_I915=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_I801=y
CONFIG_I2C_I810=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_SENSORS_EEPROM=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
CONFIG_SENSORS_IT87=m
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_PWC=m
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=y
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_USB_AUDIO=m
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_USB_HID=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEVICEFS=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_STORAGE=m
CONFIG_DMA_ENGINE=y
CONFIG_NET_DMA=y
CONFIG_INTEL_IOATDMA=m
CONFIG_VIRTUALIZATION=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_FS_POSIX_ACL=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_DNOTIFY=y
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_RW=y
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_RAMFS=y
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_CRAMFS=m
CONFIG_UFS_FS=m
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_TCP=y
CONFIG_ROOT_NFS=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SMB_FS=m
CONFIG_CIFS=m
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_UTF8=y
CONFIG_INSTRUMENTATION=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_FORCED_INLINING=y
CONFIG_EARLY_PRINTK=y
CONFIG_DOUBLEFAULT=y
CONFIG_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_CAPABILITIES=y
CONFIG_SECURITY_ROOTPLUG=m
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_HW=y
CONFIG_BITREVERSE=y
CONFIG_CRC32=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
