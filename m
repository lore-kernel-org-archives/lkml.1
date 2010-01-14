Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263Ab0ANCmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0ANCmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500Ab0ANCmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:42:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:61368 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0ANCmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:42:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232534287"
Date: Thu, 14 Jan 2010 10:42:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] cpufreq: dont BUG_ON uninitialized policy cpu
Message-ID: <20100114024217.GA15708@localhost>
References: <20100113051438.GA32519@localhost> <4B4DBFBC.4090400@suse.de> <20100113155905.GA1965@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113155905.GA1965@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 11:59:06PM +0800, Dave Jones wrote:
> On Wed, Jan 13, 2010 at 01:42:36PM +0100, Thomas Renninger wrote:
>  > On 01/13/2010 06:14 AM, Wu Fengguang wrote:
>  > > Remove a BUG_ON which is always triggered here after commit 0b19a310eebb93:
>  > The patch got dropped from -mm.
>  > I hope it did not make it upstream yet, otherwise it should also
>  > get dropped/reverted there without replacement.
>  > There wasn't a real, only a theoretical issue.
>  > Looking at it again, I now think it's not needed at all.
>  
> dropped from cpufreq.git
> 
> I'm still curious how we're calling cpufreq_update_policy with no policy set.
> I suspect cpufreq_stats might be doing something wrong.

Dave, this is the full dmesg. The last lines show the BUG_ON trace.

Thanks,
Fengguang


[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] 16 Processors exceeds NR_CPUS limit of 8
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bcde3000 - 00000000bcffb000
[    0.000000] PM: Registered nosave memory: 00000000bf6bd000 - 00000000bf6bf000
[    0.000000] PM: Registered nosave memory: 00000000bf714000 - 00000000bf7bf000
[    0.000000] PM: Registered nosave memory: 00000000bf7e7000 - 00000000bf7ff000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:38000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880005600000 s1919320 r8192 d22184 u2097152
[    0.000000] pcpu-alloc: s1919320 r8192 d22184 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 772705
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: ramdisk_size=300000 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty0 ip=dhcp nfsroot=192.168.11.2:/croot,tcp,v3,intr,rsize=524288,wsize=524288 panic=10 nmi_watchdog=1 ignore_loglevel sysrq_always_enabled rw selinux=0 log_buf_len=1M hpet=disable debugpat netconsole=6665@192.168.11.3:/eth0,6666@192.168.11.2/00:1c:25:7c:4c:eb BOOT_IMAGE=croot/vmlinuz
[    0.000000] debug: sysrq always enabled.
[    0.000000] log_buf_len: 1048576
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3049852k/3137536k available (7094k kernel code, 3392k absent, 84292k reserved, 3719k data, 2560k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:472
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 31457280 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.004000] Fast TSC calibration using PIT
[    0.008000] Detected 3200.143 MHz processor.
[    0.000023] Calibrating delay loop (skipped), value calculated using timer frequency.. 6400.28 BogoMIPS (lpj=12800572)
[    0.000979] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002668] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003555] Mount-cache hash table entries: 256
[    0.004509] Initializing cgroup subsys debug
[    0.004727] Initializing cgroup subsys ns
[    0.004949] Initializing cgroup subsys cpuacct
[    0.005177] Initializing cgroup subsys memory
[    0.005427] Initializing cgroup subsys devices
[    0.005650] Initializing cgroup subsys freezer
[    0.005925] CPU: Physical Processor ID: 0
[    0.006133] CPU: Processor Core ID: 0
[    0.006331] mce: CPU supports 9 MCE banks
[    0.006544] CPU0: Thermal monitoring enabled (TM1)
[    0.006785] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
[    0.007252] using mwait in idle threads.
[    0.007457] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
[    0.007831] ... version:                3
[    0.008039] ... bit width:              48
[    0.008250] ... generic registers:      4
[    0.008457] ... value mask:             0000ffffffffffff
[    0.008711] ... max period:             000000007fffffff
[    0.008976] ... fixed-purpose events:   3
[    0.009183] ... event mask:             000000070000000f
[    0.010394] ACPI: Core revision 20091214
[    0.010657] reserve_memtype added 0xbf7f8000-0xbf7fd000, track uncached-minus, req uncached-minus, ret uncached-minus
[    0.021030] reserve_memtype added 0xbf7ea000-0xbf7f2000, track uncached-minus, req uncached-minus, ret uncached-minus
[    0.031298] reserve_memtype added 0xbf726000-0xbf727000, track uncached-minus, req uncached-minus, ret uncached-minus
[    0.031784] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.032057] ftrace: allocating 25286 entries in 100 pages
[    0.038392] Setting APIC routing to flat
[    0.038986] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.078905] CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
[    0.184203] APIC timer registered as dummy, due to nmi_watchdog=1!
[    0.184976] lockdep: fixing up alternatives.
[    0.185342] Booting Node   0, Processors  #1
[    0.276323] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.296408] lockdep: fixing up alternatives.
[    0.297106]  #2
[    0.383996] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.404117] lockdep: fixing up alternatives.
[    0.404813]  #3
[    0.495656] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.515813] lockdep: fixing up alternatives.
[    0.516510]  #4
[    0.607318] CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.627425] lockdep: fixing up alternatives.
[    0.628112]  #5
[    0.718977] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.739128] lockdep: fixing up alternatives.
[    0.739814]  #6
[    0.830637] CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.850724] lockdep: fixing up alternatives.
[    0.851409]  #7 Ok.
[    0.942298] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.962282] Brought up 8 CPUs
[    0.962817] Total of 8 processors activated (51204.79 BogoMIPS).
[    0.963220] Testing NMI watchdog ... OK.
[    1.046539] khelper used greatest stack depth: 4936 bytes left
[    1.049215] Time: 10:37:06  Date: 01/14/10
[    1.049627] NET: Registered protocol family 16
[    1.050647] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    1.051129] ACPI: bus type pci registered
[    1.051564] dca service started, version 1.12.1
[    1.051906] reserve_memtype added 0xbf7f5000-0xbf7f6000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.052535] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    1.053081] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    1.054205] reserve_memtype added 0xf8000000-0xfc000000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.054930] PCI: Using configuration type 1 for base access
[    1.062859] bio: create slab <bio-0> at 0
[    1.068158] ACPI: EC: Look up EC in DSDT
[    1.070677] reserve_memtype added 0xfed40000-0xfed41000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.104936] ACPI: Interpreter enabled
[    1.105179] ACPI: (supports S0 S1 S3 S4 S5)
[    1.105667] ACPI: Using IOAPIC for interrupt routing
[    1.119392] reserve_memtype added 0xbf7fd000-0xbf7fe000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.120036] reserve_memtype added 0xbf7f7000-0xbf7f8000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.120677] reserve_memtype added 0xbf7f6000-0xbf7f7000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.121305] reserve_memtype added 0xbf7f4000-0xbf7f5000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.121951] reserve_memtype added 0xbf7e7000-0xbf7e8000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.122596] reserve_memtype added 0xbf7f2000-0xbf7f3000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.123255] reserve_memtype added 0xbf7f3000-0xbf7f4000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.124324] ACPI: No dock devices found.
[    1.125579] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.126024] pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    1.128490] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.128950] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.129407] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.129907] pci_root PNP0A03:00: host bridge window [mem 0x000c4000-0x000cbfff] (ignored)
[    1.130400] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfedfffff] (ignored)
[    1.130891] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xf7ffffff] (ignored)
[    1.131542] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.131904] pci 0000:00:01.0: PME# disabled
[    1.132248] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.132609] pci 0000:00:03.0: PME# disabled
[    1.132957] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.133318] pci 0000:00:07.0: PME# disabled
[    1.133757] IOH bus: [00, 3d]
[    1.133966] IOH bus: 00 index 0 io port: [0, ffff]
[    1.134262] IOH bus: 00 index 1 mmio: [d0000000, f7ffffff]
[    1.134848] pci 0000:00:19.0: reg 10: [mem 0xe0300000-0xe031ffff]
[    1.135212] pci 0000:00:19.0: reg 14: [mem 0xe0323000-0xe0323fff]
[    1.135576] pci 0000:00:19.0: reg 18: [io  0x2100-0x211f]
[    1.135945] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.136851] pci 0000:00:19.0: PME# disabled
[    1.137171] pci 0000:00:1a.0: reg 20: [io  0x20e0-0x20ff]
[    1.137579] pci 0000:00:1a.1: reg 20: [io  0x20c0-0x20df]
[    1.137992] pci 0000:00:1a.2: reg 20: [io  0x20a0-0x20bf]
[    1.138393] pci 0000:00:1a.7: reg 10: [mem 0xe0322000-0xe03223ff]
[    1.138812] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.139174] pci 0000:00:1a.7: PME# disabled
[    1.139479] pci 0000:00:1b.0: reg 10: [mem 0xf7f00000-0xf7f03fff 64bit]
[    1.139916] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.140277] pci 0000:00:1b.0: PME# disabled
[    1.140624] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.140986] pci 0000:00:1c.0: PME# disabled
[    1.141334] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.141702] pci 0000:00:1c.1: PME# disabled
[    1.142056] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.142417] pci 0000:00:1c.4: PME# disabled
[    1.142747] pci 0000:00:1d.0: reg 20: [io  0x2080-0x209f]
[    1.143154] pci 0000:00:1d.1: reg 20: [io  0x2060-0x207f]
[    1.143561] pci 0000:00:1d.2: reg 20: [io  0x2040-0x205f]
[    1.143962] pci 0000:00:1d.7: reg 10: [mem 0xe0321000-0xe03213ff]
[    1.144382] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.144744] pci 0000:00:1d.7: PME# disabled
[    1.145151] reserve_memtype added 0xfed1c000-0xfed20000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.145769] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    1.146135] free_memtype request 0xfed1c000-0xfed20000
[    1.146454] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    1.146935] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    1.147346] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    1.147808] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
[    1.148335] pci 0000:00:1f.2: reg 10: [io  0x2128-0x212f]
[    1.148664] pci 0000:00:1f.2: reg 14: [io  0x2134-0x2137]
[    1.148995] pci 0000:00:1f.2: reg 18: [io  0x2120-0x2127]
[    1.149325] pci 0000:00:1f.2: reg 1c: [io  0x2130-0x2133]
[    1.149663] pci 0000:00:1f.2: reg 20: [io  0x2020-0x203f]
[    1.149993] pci 0000:00:1f.2: reg 24: [mem 0xe0320000-0xe03207ff]
[    1.150386] pci 0000:00:1f.2: PME# supported from D3hot
[    1.150706] pci 0000:00:1f.2: PME# disabled
[    1.151004] pci 0000:00:1f.3: reg 10: [mem 0xf7f04000-0xf7f040ff 64bit]
[    1.151404] pci 0000:00:1f.3: reg 20: [io  0x2000-0x201f]
[    1.151757] PCI: peer root bus 00 res updated from pci conf
[    1.152140] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.152532] pci 0000:02:00.0: reg 10: [mem 0xe0200000-0xe027ffff]
[    1.152897] pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff pref]
[    1.153300] pci 0000:02:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    1.153707] pci 0000:02:00.0: supports D1 D2
[    1.154011] pci 0000:02:00.1: reg 10: [mem 0xe0280000-0xe0283fff]
[    1.154419] pci 0000:02:00.1: supports D1 D2
[    1.154711] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    1.155033] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    1.155431] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.155950] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    1.156330] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    1.156710] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    1.157129] pci 0000:06:00.0: reg 10: [io  0x1018-0x101f]
[    1.157463] pci 0000:06:00.0: reg 14: [io  0x1024-0x1027]
[    1.157804] pci 0000:06:00.0: reg 18: [io  0x1010-0x1017]
[    1.158138] pci 0000:06:00.0: reg 1c: [io  0x1020-0x1023]
[    1.158471] pci 0000:06:00.0: reg 20: [io  0x1000-0x100f]
[    1.158806] pci 0000:06:00.0: reg 24: [mem 0xe0100000-0xe01003ff]
[    1.159224] pci 0000:06:00.0: supports D1
[    1.159482] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
[    1.159828] pci 0000:06:00.0: PME# disabled
[    1.160114] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    1.160434] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    1.160795] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    1.161256] pci 0000:07:03.0: reg 10: [mem 0xe0004000-0xe00047ff]
[    1.161628] pci 0000:07:03.0: reg 14: [mem 0xe0000000-0xe0003fff]
[    1.162040] pci 0000:07:03.0: supports D1 D2
[    1.162310] pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
[    1.162669] pci 0000:07:03.0: PME# disabled
[    1.163009] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    1.163420] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    1.163855] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.165797] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    1.166587] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
[    1.167107] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
[    1.167627] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
[    1.168146] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    1.168665] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    1.169202] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    1.203241] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    1.204303] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    1.205365] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    1.206456] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    1.207515] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    1.208573] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    1.209645] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    1.210705] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    1.212030] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.212525] vgaarb: loaded
[    1.212892] SCSI subsystem initialized
[    1.213329] libata version 3.00 loaded.
[    1.213843] usbcore: registered new interface driver usbfs
[    1.214225] usbcore: registered new interface driver hub
[    1.214612] usbcore: registered new device driver usb
[    1.215252] PCI: Using ACPI for IRQ routing
[    1.215520] PCI: pci_cache_line_size set to 64 bytes
[    1.216618] cfg80211: Calling CRDA to update world regulatory domain
[    1.217284] Switching to clocksource tsc
[    1.245046] pnp: PnP ACPI init
[    1.245289] ACPI: bus type pnp registered
[    1.249250] pnp: PnP ACPI: found 8 devices
[    1.249526] ACPI: ACPI bus type pnp unregistered
[    1.249828] system 00:05: [io  0x0500-0x053f] has been reserved
[    1.250180] system 00:05: [io  0x0400-0x047f] has been reserved
[    1.250532] system 00:05: [io  0x0680-0x06ff] has been reserved
[    1.256294] pci 0000:02:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    1.256872] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.257190] pci 0000:00:01.0:   bridge window [io  disabled]
[    1.257536] pci 0000:00:01.0:   bridge window [mem disabled]
[    1.257877] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    1.258243] pci 0000:02:00.0: BAR 6: assigned [mem 0xe0290000-0xe029ffff pref]
[    1.258688] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    1.259005] pci 0000:00:03.0:   bridge window [io  disabled]
[    1.259346] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    1.259741] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.260215] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    1.260531] pci 0000:00:07.0:   bridge window [io  disabled]
[    1.260871] pci 0000:00:07.0:   bridge window [mem disabled]
[    1.261211] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    1.261578] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    1.261895] pci 0000:00:1c.0:   bridge window [io  disabled]
[    1.262236] pci 0000:00:1c.0:   bridge window [mem disabled]
[    1.262577] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    1.262941] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    1.263259] pci 0000:00:1c.1:   bridge window [io  disabled]
[    1.263600] pci 0000:00:1c.1:   bridge window [mem disabled]
[    1.263940] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    1.264305] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    1.264624] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    1.264987] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    1.265387] pci 0000:00:1c.4:   bridge window [mem pref disabled]
[    1.265751] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    1.266068] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.266410] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    1.266805] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.267185]   alloc irq_desc for 16 on node -1
[    1.267465]   alloc kstat_irqs on node -1
[    1.267727] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.268120] pci 0000:00:01.0: setting latency timer to 64
[    1.268453] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.268844] pci 0000:00:03.0: setting latency timer to 64
[    1.269176] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.269574] pci 0000:00:07.0: setting latency timer to 64
[    1.269908]   alloc irq_desc for 17 on node -1
[    1.270188]   alloc kstat_irqs on node -1
[    1.270449] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.270842] pci 0000:00:1c.0: setting latency timer to 64
[    1.271177] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.271570] pci 0000:00:1c.1: setting latency timer to 64
[    1.271903] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.272294] pci 0000:00:1c.4: setting latency timer to 64
[    1.272625] pci 0000:00:1e.0: setting latency timer to 64
[    1.272953] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    1.273292] pci_bus 0000:00: resource 1 [mem 0xd0000000-0xf7ffffff]
[    1.273660] pci_bus 0000:02: resource 1 [mem 0xe0200000-0xe02fffff]
[    1.274029] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.274474] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    1.274809] pci_bus 0000:06: resource 1 [mem 0xe0100000-0xe01fffff]
[    1.275178] pci_bus 0000:07: resource 1 [mem 0xe0000000-0xe00fffff]
[    1.275546] pci_bus 0000:07: resource 3 [io  0x0000-0xffff]
[    1.275881] pci_bus 0000:07: resource 4 [mem 0xd0000000-0xf7ffffff]
[    1.276839] NET: Registered protocol family 2
[    1.277344] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.278966] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.282015] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    1.285938] TCP: Hash tables configured (established 524288 bind 65536)
[    1.286347] TCP reno registered
[    1.286589] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.287199] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.287971] NET: Registered protocol family 1
[    1.288634] RPC: Registered udp transport module.
[    1.288927] RPC: Registered tcp transport module.
[    1.289219] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.289651] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    1.290032] pci 0000:00:1a.0: Performing full reset
[    1.290349] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    1.290729] pci 0000:00:1a.1: Performing full reset
[    1.291045] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
[    1.291426] pci 0000:00:1a.2: Performing full reset
[    1.291747] reserve_memtype added 0xe0322000-0xe0323000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.292469] free_memtype request 0xe0322000-0xe0323000
[    1.292804] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    1.293186] pci 0000:00:1d.0: Performing full reset
[    1.293508] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    1.293889] pci 0000:00:1d.1: Performing full reset
[    1.294206] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    1.294586] pci 0000:00:1d.2: Performing full reset
[    1.294903] reserve_memtype added 0xe0321000-0xe0322000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.295621] free_memtype request 0xe0321000-0xe0322000
[    1.295956] pci 0000:02:00.0: Boot video device
[    1.296253] PCI: CLS 64 bytes, default 64
[    1.299781] Machine check injector initialized
[    1.301301] microcode: CPU0 sig=0x106a4, pf=0x2, revision=0x6
[    1.301654] microcode: CPU1 sig=0x106a4, pf=0x2, revision=0x6
[    1.302005] microcode: CPU2 sig=0x106a4, pf=0x2, revision=0x6
[    1.302355] microcode: CPU3 sig=0x106a4, pf=0x2, revision=0x6
[    1.302703] microcode: CPU4 sig=0x106a4, pf=0x2, revision=0x6
[    1.303055] microcode: CPU5 sig=0x106a4, pf=0x2, revision=0x6
[    1.303404] microcode: CPU6 sig=0x106a4, pf=0x2, revision=0x6
[    1.303752] microcode: CPU7 sig=0x106a4, pf=0x2, revision=0x6
[    1.304155] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.304676] Scanning for low memory corruption every 60 seconds
[    1.305931] Initializing RT-Tester: OK
[    1.306257] audit: initializing netlink socket (disabled)
[    1.306611] type=2000 audit(1263465426.099:1): initialized
[    1.316375] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.323503] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.324052] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
[    1.325959] SGI XFS Quota Management subsystem
[    1.326579] Btrfs loaded
[    1.326771] msgmni has been set to 5956
[    1.327569] alg: No test for cipher_null (cipher_null-generic)
[    1.327962] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    1.328344] alg: No test for digest_null (digest_null-generic)
[    1.328721] alg: No test for compress_null (compress_null-generic)
[    1.329698] alg: No test for stdrng (krng)
[    1.329983] io scheduler noop registered
[    1.330239] io scheduler deadline registered
[    1.330605] io scheduler cfq registered (default)
[    1.331149] pcieport 0000:00:01.0: setting latency timer to 64
[    1.331540]   alloc irq_desc for 24 on node -1
[    1.331820]   alloc kstat_irqs on node -1
[    1.332086] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.332583] pcieport 0000:00:03.0: setting latency timer to 64
[    1.332964]   alloc irq_desc for 25 on node -1
[    1.333244]   alloc kstat_irqs on node -1
[    1.333512] pcieport 0000:00:03.0: irq 25 for MSI/MSI-X
[    1.333982] pcieport 0000:00:07.0: setting latency timer to 64
[    1.334362]   alloc irq_desc for 26 on node -1
[    1.334641]   alloc kstat_irqs on node -1
[    1.334905] pcieport 0000:00:07.0: irq 26 for MSI/MSI-X
[    1.335382] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.335767]   alloc irq_desc for 27 on node -1
[    1.336046]   alloc kstat_irqs on node -1
[    1.336311] pcieport 0000:00:1c.0: irq 27 for MSI/MSI-X
[    1.336781] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.337171]   alloc irq_desc for 28 on node -1
[    1.337450]   alloc kstat_irqs on node -1
[    1.337715] pcieport 0000:00:1c.1: irq 28 for MSI/MSI-X
[    1.338189] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.338573]   alloc irq_desc for 29 on node -1
[    1.338852]   alloc kstat_irqs on node -1
[    1.339116] pcieport 0000:00:1c.4: irq 29 for MSI/MSI-X
[    1.339647] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    1.340147] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    1.340636] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[    1.342207] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.342890] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    1.343399] ACPI: Sleep Button [SLPB]
[    1.343751] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.344206] ACPI: Power Button [PWRF]
[    1.346179] reserve_memtype added 0xbf7be000-0xbf7bf000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.347014] Monitor-Mwait will be used to enter C-1 state
[    1.347382] Monitor-Mwait will be used to enter C-3 state
[    1.400895] Initializing Nozomi driver 2.1d (build date: Jan 14 2010 09:52:19)
[    1.401673] Non-volatile memory driver v1.3
[    1.402276] Linux agpgart interface v0.103
[    1.402680] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    1.403209] Hangcheck: Using get_cycles().
[    1.403476] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.404261] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    2.046928] Clockevents: could not switch to one-shot mode:
[    2.046933] Clockevents: could not switch to one-shot mode:
[    2.046937] Clockevents: could not switch to one-shot mode:
[    2.046941] Clockevents: could not switch to one-shot mode: lapic is not functional.
[    2.046949] Clockevents: could not switch to one-shot mode:
[    2.046951] Could not switch to high resolution mode on CPU 0
[    2.046952] Clockevents: could not switch to one-shot mode: lapic is not functional.
[    2.046955] Clockevents: could not switch to one-shot mode:
[    2.046957] Could not switch to high resolution mode on CPU 4
[    2.046959]  lapic is not functional.
[    2.046960]  lapic is not functional.
[    2.046962]  lapic is not functional.
[    2.046963] Could not switch to high resolution mode on CPU 1
[    2.046965] Clockevents: could not switch to one-shot mode:
[    2.046967] Could not switch to high resolution mode on CPU 7
[    2.046968] Could not switch to high resolution mode on CPU 6
[    2.046970]  lapic is not functional.
[    2.046972] Could not switch to high resolution mode on CPU 2
[    2.046973]  lapic is not functional.
[    2.046974] Could not switch to high resolution mode on CPU 5
[    2.053497]  lapic is not functional.
[    2.053749] Could not switch to high resolution mode on CPU 3
[    4.411826] floppy0: no floppy controllers found
[    4.415005] brd: module loaded
[    4.416550] loop: module loaded
[    4.417028] Loading iSCSI transport class v2.0-870.
[    4.417705] ahci 0000:00:1f.2: version 3.0
[    4.417983]   alloc irq_desc for 19 on node -1
[    4.418262]   alloc kstat_irqs on node -1
[    4.418525] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    4.418933] reserve_memtype added 0xe0320000-0xe0321000, track uncached-minus, req uncached-minus, ret uncached-minus
[    4.419566]   alloc irq_desc for 30 on node -1
[    4.419847]   alloc kstat_irqs on node -1
[    4.420117] ahci 0000:00:1f.2: irq 30 for MSI/MSI-X
[    4.420508] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    4.421001] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems
[    4.421482] ahci 0000:00:1f.2: setting latency timer to 64
[    4.459688] scsi0 : ahci
[    4.460152] scsi1 : ahci
[    4.460483] scsi2 : ahci
[    4.460812] scsi3 : ahci
[    4.461142] scsi4 : ahci
[    4.461467] scsi5 : ahci
[    4.462194] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 30
[    4.462688] ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 30
[    4.463179] ata3: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320200 irq 30
[    4.463640] ata4: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320280 irq 30
[    4.464094] ata5: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320300 irq 30
[    4.464547] ata6: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320380 irq 30
[    4.465039] ahci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.465443] reserve_memtype added 0xe0100000-0xe0101000, track uncached-minus, req uncached-minus, ret uncached-minus
[    4.466064] ahci 0000:06:00.0: controller can't do NCQ, turning off CAP_NCQ
[    4.466466] ahci 0000:06:00.0: controller can't do PMP, turning off CAP_PMP
[    4.466867] ahci 0000:06:00.0: MV_AHCI HACK: port_map 7 -> 3
[    4.467754] ahci 0000:06:00.0: Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.
[    4.468374] ahci: SSS flag set, parallel bus scan disabled
[    4.468739] ahci 0000:06:00.0: AHCI 0001.0000 32 slots 3 ports 3 Gbps 0x3 impl IDE mode
[    4.469223] ahci 0000:06:00.0: flags: 64bit stag led slum part
[    4.469578] ahci 0000:06:00.0: setting latency timer to 64
[    4.470007] scsi6 : ahci
[    4.470342] scsi7 : ahci
[    4.470667] scsi8 : ahci
[    4.470973] ata7: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100100 irq 16
[    4.471428] ata8: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100180 irq 16
[    4.471885] ata9: DUMMY
[    4.473708] Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
[    4.474084] Copyright (c) 1999-2006 Intel Corporation.
[    4.474465] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    4.474816] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    4.475203]   alloc irq_desc for 20 on node -1
[    4.475481]   alloc kstat_irqs on node -1
[    4.475747] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.476155] e1000e 0000:00:19.0: setting latency timer to 64
[    4.476530] reserve_memtype added 0xe0300000-0xe0320000, track uncached-minus, req uncached-minus, ret uncached-minus
[    4.477144] reserve_memtype added 0xe0323000-0xe0324000, track uncached-minus, req uncached-minus, ret uncached-minus
[    4.477780]   alloc irq_desc for 31 on node -1
[    4.478059]   alloc kstat_irqs on node -1
[    4.478326] e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
[    4.747174] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:c0:79:88:54
[    4.747629] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.748055] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
[    4.749095] netconsole: local port 6665
[    4.749345] netconsole: local IP 192.168.11.40
[    4.749624] netconsole: interface eth0
[    4.749869] netconsole: remote port 6666
[    4.750121] netconsole: remote IP 192.168.11.2
[    4.750400] netconsole: remote ethernet address 00:1c:25:7c:4c:eb
[    4.750765] netconsole: device eth0 not up yet, forcing it
[    4.766920] e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
[    4.782638] ata4: SATA link down (SStatus 0 SControl 300)
[    4.782640] ata6: SATA link down (SStatus 0 SControl 300)
[    4.782660] ata5: SATA link down (SStatus 0 SControl 300)
[    4.783633] ata3: SATA link down (SStatus 0 SControl 300)
[    4.790619] ata7: SATA link down (SStatus 0 SControl 300)
[    4.822554] e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
[    5.185412] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.185413] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.203432] ata2.00: ATAPI: PLEXTOR DVDR   PX-712A, 1.07, max UDMA/33
[    5.203820] ata2.00: applying bridge limits
[    5.205525] ata2.00: configured for UDMA/33
[    5.220412] ata1.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[    5.220757] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.278553] ata1.00: configured for UDMA/133
[    5.293463] scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    5.294601] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.295066] scsi 1:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-712A   1.07 PQ: 0 ANSI: 5
[    5.295160] sd 0:0:0:0: [sda] Write Protect is off
[    5.295162] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.295203] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.295557]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
[    5.400442] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.616108] ata8: SATA link down (SStatus 0 SControl 300)
[    6.294040] async/1 used greatest stack depth: 4920 bytes left
[    6.397721] async/0 used greatest stack depth: 4776 bytes left
[    6.398578] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[    6.399037] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[    6.703138] console [netcon0] enabled
[    6.703381] netconsole: network logging started
[    6.703775] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.704158] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    6.704549]   alloc irq_desc for 18 on node -1
[    6.704832]   alloc kstat_irqs on node -1
[    6.705100] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.705519] reserve_memtype added 0xe0322000-0xe0323000, track uncached-minus, req uncached-minus, ret uncached-minus
[    6.706138] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.707033] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.707583] drivers/usb/core/inode.c: creating file 'devices'
[    6.707982] drivers/usb/core/inode.c: creating file '001'
[    6.708331] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    6.708796] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    6.709330] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    6.709866] ehci_hcd 0000:00:1a.7: debug port 1
[    6.710153] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.714567] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    6.714962] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    6.715327] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0322000
[    6.715668] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.720069] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    6.728727] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.729201] usb usb1: default language 0x0409
[    6.729492] usb usb1: udev 1, busnum 1, minor = 0
[    6.729785] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.730180] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.730626] usb usb1: Product: EHCI Host Controller
[    6.730927] usb usb1: Manufacturer: Linux 2.6.33-rc3-next-20100112 ehci_hcd
[    6.731330] usb usb1: SerialNumber: 0000:00:1a.7
[    6.731804] usb usb1: uevent
[    6.732107] usb usb1: usb_probe_device
[    6.732355] usb usb1: configuration #1 chosen from 1 choice
[    6.732845] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    6.733216] usb 1-0:1.0: uevent
[    6.733513] hub 1-0:1.0: usb_probe_interface
[    6.733786] hub 1-0:1.0: usb_probe_interface - got id
[    6.734098] hub 1-0:1.0: USB hub found
[    6.734364] hub 1-0:1.0: 6 ports detected
[    6.734624] hub 1-0:1.0: standalone hub
[    6.734874] hub 1-0:1.0: no power switching (usb 1.0)
[    6.735186] hub 1-0:1.0: individual port over-current protection
[    6.735543] hub 1-0:1.0: power on to power good time: 20ms
[    6.735975] hub 1-0:1.0: local power source is good
[    6.736277] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    6.736773] drivers/usb/core/inode.c: creating file '001'
[    6.737165]   alloc irq_desc for 23 on node -1
[    6.737447]   alloc kstat_irqs on node -1
[    6.737710] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.738128] reserve_memtype added 0xe0321000-0xe0322000, track uncached-minus, req uncached-minus, ret uncached-minus
[    6.738746] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.739095] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.739419] drivers/usb/core/inode.c: creating file '002'
[    6.739752] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    6.740211] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    6.740749] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    6.741284] ehci_hcd 0000:00:1d.7: debug port 1
[    6.741570] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.745963] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    6.746359] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    6.746723] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0321000
[    6.747065] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.751466] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    6.760608] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.760995] usb usb2: default language 0x0409
[    6.761287] usb usb2: udev 1, busnum 2, minor = 128
[    6.761591] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.761986] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.762432] usb usb2: Product: EHCI Host Controller
[    6.762735] usb usb2: Manufacturer: Linux 2.6.33-rc3-next-20100112 ehci_hcd
[    6.763138] usb usb2: SerialNumber: 0000:00:1d.7
[    6.763497] usb usb2: uevent
[    6.763748] usb usb2: usb_probe_device
[    6.763995] usb usb2: configuration #1 chosen from 1 choice
[    6.764339] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    6.764710] usb 2-0:1.0: uevent
[    6.764977] hub 2-0:1.0: usb_probe_interface
[    6.765249] hub 2-0:1.0: usb_probe_interface - got id
[    6.765562] hub 2-0:1.0: USB hub found
[    6.765815] hub 2-0:1.0: 6 ports detected
[    6.766075] hub 2-0:1.0: standalone hub
[    6.766326] hub 2-0:1.0: no power switching (usb 1.0)
[    6.766639] hub 2-0:1.0: individual port over-current protection
[    6.766996] hub 2-0:1.0: power on to power good time: 20ms
[    6.767336] hub 2-0:1.0: local power source is good
[    6.767638] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    6.768095] drivers/usb/core/inode.c: creating file '001'
[    6.768506] uhci_hcd: USB Universal Host Controller Interface driver
[    6.768938] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.769359] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.769709] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.770034] drivers/usb/core/inode.c: creating file '003'
[    6.770383] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    6.770843] uhci_hcd 0000:00:1a.0: detected 2 ports
[    6.771147] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    6.771539] uhci_hcd 0000:00:1a.0: Performing full reset
[    6.771874] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    6.772227] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020e0
[    6.772617] usb usb3: default language 0x0409
[    6.772907] usb usb3: udev 1, busnum 3, minor = 256
[    6.773209] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.773604] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.774050] usb usb3: Product: UHCI Host Controller
[    6.774351] usb usb3: Manufacturer: Linux 2.6.33-rc3-next-20100112 uhci_hcd
[    6.774755] usb usb3: SerialNumber: 0000:00:1a.0
[    6.775114] usb usb3: uevent
[    6.775366] usb usb3: usb_probe_device
[    6.775614] usb usb3: configuration #1 chosen from 1 choice
[    6.775959] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    6.776326] usb 3-0:1.0: uevent
[    6.776595] hub 3-0:1.0: usb_probe_interface
[    6.776868] hub 3-0:1.0: usb_probe_interface - got id
[    6.777180] hub 3-0:1.0: USB hub found
[    6.777465] hub 3-0:1.0: 2 ports detected
[    6.777726] hub 3-0:1.0: standalone hub
[    6.777977] hub 3-0:1.0: no power switching (usb 1.0)
[    6.778289] hub 3-0:1.0: individual port over-current protection
[    6.778646] hub 3-0:1.0: power on to power good time: 2ms
[    6.778997] hub 3-0:1.0: local power source is good
[    6.779300] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    6.779733] drivers/usb/core/inode.c: creating file '001'
[    6.780112]   alloc irq_desc for 21 on node -1
[    6.780393]   alloc kstat_irqs on node -1
[    6.780661] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.781083] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.781434] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.781759] drivers/usb/core/inode.c: creating file '004'
[    6.782094] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.782554] uhci_hcd 0000:00:1a.1: detected 2 ports
[    6.782858] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    6.783248] uhci_hcd 0000:00:1a.1: Performing full reset
[    6.783582] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    6.783946] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020c0
[    6.784328] usb usb4: default language 0x0409
[    6.784623] usb usb4: udev 1, busnum 4, minor = 384
[    6.784925] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.785320] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.785766] usb usb4: Product: UHCI Host Controller
[    6.786067] usb usb4: Manufacturer: Linux 2.6.33-rc3-next-20100112 uhci_hcd
[    6.786470] usb usb4: SerialNumber: 0000:00:1a.1
[    6.786829] usb usb4: uevent
[    6.787078] usb usb4: usb_probe_device
[    6.787325] usb usb4: configuration #1 chosen from 1 choice
[    6.787669] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    6.788037] usb 4-0:1.0: uevent
[    6.788298] hub 4-0:1.0: usb_probe_interface
[    6.788652] hub 4-0:1.0: usb_probe_interface - got id
[    6.788965] hub 4-0:1.0: USB hub found
[    6.789232] hub 4-0:1.0: 2 ports detected
[    6.789492] hub 4-0:1.0: standalone hub
[    6.789742] hub 4-0:1.0: no power switching (usb 1.0)
[    6.790054] hub 4-0:1.0: individual port over-current protection
[    6.790411] hub 4-0:1.0: power on to power good time: 2ms
[    6.790745] hub 4-0:1.0: local power source is good
[    6.791047] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    6.791479] drivers/usb/core/inode.c: creating file '001'
[    6.791855] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    6.792274] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    6.792629] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    6.792955] drivers/usb/core/inode.c: creating file '005'
[    6.793288] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    6.793750] uhci_hcd 0000:00:1a.2: detected 2 ports
[    6.794055] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    6.794447] uhci_hcd 0000:00:1a.2: Performing full reset
[    6.794781] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    6.795144] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000020a0
[    6.795532] usb usb5: default language 0x0409
[    6.795821] usb usb5: udev 1, busnum 5, minor = 512
[    6.796123] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.797066] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.797513] usb usb5: Product: UHCI Host Controller
[    6.797814] usb usb5: Manufacturer: Linux 2.6.33-rc3-next-20100112 uhci_hcd
[    6.798218] usb usb5: SerialNumber: 0000:00:1a.2
[    6.798576] usb usb5: uevent
[    6.798826] usb usb5: usb_probe_device
[    6.799075] usb usb5: configuration #1 chosen from 1 choice
[    6.799419] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    6.799785] usb 5-0:1.0: uevent
[    6.800045] hub 5-0:1.0: usb_probe_interface
[    6.800318] hub 5-0:1.0: usb_probe_interface - got id
[    6.800635] hub 5-0:1.0: USB hub found
[    6.800888] hub 5-0:1.0: 2 ports detected
[    6.801147] hub 5-0:1.0: standalone hub
[    6.801399] hub 5-0:1.0: no power switching (usb 1.0)
[    6.801709] hub 5-0:1.0: individual port over-current protection
[    6.802068] hub 5-0:1.0: power on to power good time: 2ms
[    6.802404] hub 5-0:1.0: local power source is good
[    6.802706] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    6.803138] drivers/usb/core/inode.c: creating file '001'
[    6.803532] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.803950] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.804298] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.804630] drivers/usb/core/inode.c: creating file '006'
[    6.804964] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    6.805425] uhci_hcd 0000:00:1d.0: detected 2 ports
[    6.805729] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    6.806120] uhci_hcd 0000:00:1d.0: Performing full reset
[    6.806456] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    6.806809] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
[    6.807193] usb usb6: default language 0x0409
[    6.807494] usb usb6: udev 1, busnum 6, minor = 640
[    6.807796] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    6.808191] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.808642] usb usb6: Product: UHCI Host Controller
[    6.808944] usb usb6: Manufacturer: Linux 2.6.33-rc3-next-20100112 uhci_hcd
[    6.809347] usb usb6: SerialNumber: 0000:00:1d.0
[    6.809706] usb usb6: uevent
[    6.809956] usb usb6: usb_probe_device
[    6.810203] usb usb6: configuration #1 chosen from 1 choice
[    6.810547] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    6.810915] usb 6-0:1.0: uevent
[    6.811175] hub 6-0:1.0: usb_probe_interface
[    6.811447] hub 6-0:1.0: usb_probe_interface - got id
[    6.811759] hub 6-0:1.0: USB hub found
[    6.812013] hub 6-0:1.0: 2 ports detected
[    6.812272] hub 6-0:1.0: standalone hub
[    6.812527] hub 6-0:1.0: no power switching (usb 1.0)
[    6.812839] hub 6-0:1.0: individual port over-current protection
[    6.813197] hub 6-0:1.0: power on to power good time: 2ms
[    6.813534] hub 6-0:1.0: local power source is good
[    6.813835] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    6.814265] drivers/usb/core/inode.c: creating file '001'
[    6.814641] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.815060] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.815409] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.815734] drivers/usb/core/inode.c: creating file '007'
[    6.816067] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    6.816532] uhci_hcd 0000:00:1d.1: detected 2 ports
[    6.816838] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    6.817231] uhci_hcd 0000:00:1d.1: Performing full reset
[    6.817566] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    6.817917] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
[    6.818302] usb usb7: default language 0x0409
[    6.818592] usb usb7: udev 1, busnum 7, minor = 768
[    6.818896] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    6.819291] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.819739] usb usb7: Product: UHCI Host Controller
[    6.820041] usb usb7: Manufacturer: Linux 2.6.33-rc3-next-20100112 uhci_hcd
[    6.820450] usb usb7: SerialNumber: 0000:00:1d.1
[    6.820809] usb usb7: uevent
[    6.821059] usb usb7: usb_probe_device
[    6.821307] usb usb7: configuration #1 chosen from 1 choice
[    6.821651] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    6.822017] usb 7-0:1.0: uevent
[    6.822276] hub 7-0:1.0: usb_probe_interface
[    6.822548] hub 7-0:1.0: usb_probe_interface - got id
[    6.822860] hub 7-0:1.0: USB hub found
[    6.823113] hub 7-0:1.0: 2 ports detected
[    6.823373] hub 7-0:1.0: standalone hub
[    6.823624] hub 7-0:1.0: no power switching (usb 1.0)
[    6.823934] hub 7-0:1.0: individual port over-current protection
[    6.824291] hub 7-0:1.0: power on to power good time: 2ms
[    6.824631] hub 7-0:1.0: local power source is good
[    6.824933] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    6.825365] drivers/usb/core/inode.c: creating file '001'
[    6.825742] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.826161] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.826512] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.826836] drivers/usb/core/inode.c: creating file '008'
[    6.827169] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    6.827629] uhci_hcd 0000:00:1d.2: detected 2 ports
[    6.827931] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    6.828322] uhci_hcd 0000:00:1d.2: Performing full reset
[    6.828662] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    6.829015] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    6.829398] usb usb8: default language 0x0409
[    6.829689] usb usb8: udev 1, busnum 8, minor = 896
[    6.829991] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    6.830388] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.830835] usb usb8: Product: UHCI Host Controller
[    6.831136] usb usb8: Manufacturer: Linux 2.6.33-rc3-next-20100112 uhci_hcd
[    6.831540] usb usb8: SerialNumber: 0000:00:1d.2
[    6.831898] usb usb8: uevent
[    6.832148] usb usb8: usb_probe_device
[    6.832401] usb usb8: configuration #1 chosen from 1 choice
[    6.832746] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    6.833147] usb 8-0:1.0: uevent
[    6.833414] hub 8-0:1.0: usb_probe_interface
[    6.833687] hub 8-0:1.0: usb_probe_interface - got id
[    6.833999] hub 8-0:1.0: USB hub found
[    6.834254] hub 8-0:1.0: 2 ports detected
[    6.834514] hub 8-0:1.0: standalone hub
[    6.834765] hub 8-0:1.0: no power switching (usb 1.0)
[    6.835076] hub 8-0:1.0: individual port over-current protection
[    6.835433] hub 8-0:1.0: power on to power good time: 2ms
[    6.835769] hub 8-0:1.0: local power source is good
[    6.836070] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    6.836585] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
[    6.837085] hub 1-0:1.0: port 5: status 0501 change 0001
[    6.837500] drivers/usb/core/inode.c: creating file '001'
[    6.838088] usbcore: registered new interface driver libusual
[    6.838618] PNP: No PS/2 controller found. Probing ports directly.
[    6.842213] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.842547] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.843068] mice: PS/2 mouse device common for all mice
[    6.844130] rtc_cmos 00:02: RTC can wake from S4
[    6.844582] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    6.844975] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    6.845384] ------------[ cut here ]------------
[    6.845673] kernel BUG at drivers/cpufreq/cpufreq.c:88!
[    6.845991] invalid opcode: 0000 [#1] SMP
[    6.846322] last sysfs file:
[    6.846529] CPU 3
[    6.846725] Pid: 1, comm: swapper Not tainted 2.6.33-rc3-next-20100112 #54 DX58SO/
[    6.847221] RIP: 0010:[<ffffffff815777f9>]  [<ffffffff815777f9>] lock_policy_rwsem_write+0x69/0x90
[    6.847788] RSP: 0000:ffff8800bbbddd20  EFLAGS: 00010246
[    6.848110] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 0000000000000038
[    6.848524] RDX: ffff880005600000 RSI: 0000000000000000 RDI: 0000000000000000
[    6.848935] RBP: ffff8800bbbddd40 R08: 0000000000000008 R09: ffffffff81a8b1a8
[    6.849347] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000ffffffea
[    6.849757] R13: 0000000000000000 R14: ffffffff81a8b1b0 R15: 0000000000000000
[    6.850168] FS:  0000000000000000(0000) GS:ffff880005c00000(0000) knlGS:0000000000000000
[    6.850656] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.850999] CR2: 0000000000000000 CR3: 00000000019a3000 CR4: 00000000000006e0
[    6.851411] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.851822] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.852233] Process swapper (pid: 1, threadinfo ffff8800bbbdc000, task ffff8800bbbe0000)
[    6.852721] Stack:
[    6.852881]  ffff8800bbbddd40 0000000000000000 00000000ffffffea 0000000000000000
[    6.853396] <0> ffff8800bbbddeb0 ffffffff815785ea ffff8800bbbddd90 0000000000000286
[    6.854027] <0> ffffffff813cf1f9 0000000000000000 ffff8800bbbe0000 0000000000000007
[    6.854732] Call Trace:
[    6.854915]  [<ffffffff815785ea>] cpufreq_update_policy+0x2a/0x110
[    6.855282]  [<ffffffff813cf1f9>] ? kobject_uevent_env+0x179/0x440
[    6.855649]  [<ffffffff8103f6c0>] ? native_sched_clock+0x20/0x80
[    6.856008]  [<ffffffff8103f729>] ? sched_clock+0x9/0x10
[    6.856333]  [<ffffffff810ab205>] ? sched_clock_cpu+0xb5/0x100
[    6.856683]  [<ffffffff810b753d>] ? trace_hardirqs_off+0xd/0x10
[    6.857035]  [<ffffffff810ab2bf>] ? cpu_clock+0x6f/0x80
[    6.857354]  [<ffffffff810b757d>] ? lock_release_holdtime+0x3d/0x1c0
[    6.857728]  [<ffffffff816e1e79>] ? __mutex_unlock_slowpath+0xf9/0x1a0
[    6.858111]  [<ffffffff810b96f5>] ? trace_hardirqs_on_caller+0x155/0x1a0
[    6.858502]  [<ffffffff810b974d>] ? trace_hardirqs_on+0xd/0x10
[    6.858850]  [<ffffffff816e1f2e>] ? mutex_unlock+0xe/0x10
[    6.859723]  [<ffffffff81c98156>] cpufreq_stats_init+0x83/0xb5
[    6.860072]  [<ffffffff81c980d3>] ? cpufreq_stats_init+0x0/0xb5
[    6.860426]  [<ffffffff810001dd>] do_one_initcall+0x3d/0x1d0
[    6.860766]  [<ffffffff81c66705>] kernel_init+0x192/0x1ea
[    6.861093]  [<ffffffff81038f64>] kernel_thread_helper+0x4/0x10
[    6.861448]  [<ffffffff816e5050>] ? restore_args+0x0/0x30
[    6.861775]  [<ffffffff81c66573>] ? kernel_init+0x0/0x1ea
[    6.862102]  [<ffffffff81038f60>] ? kernel_thread_helper+0x0/0x10
[    6.862462] Code: 3c e5 a0 ac a8 81 e8 c7 b7 16 00 48 8b 05 18 a1 18 00 44 0f a3 28 19 c0 31 d2 85 c0 74 14 48 83 c4 08 89 d0 5b 41 5c 41 5d c9 c3 <0f> 0b eb fe 0f 1f 00 4a 03 1c e5 a0 ac a8 81 48 89 df e8 90 1e
[    6.865666] RIP  [<ffffffff815777f9>] lock_policy_rwsem_write+0x69/0x90
[    6.866085]  RSP <ffff8800bbbddd20>
[    6.866383] ---[ end trace 4af48140f6ef26e4 ]---
[    6.866678] swapper used greatest stack depth: 3432 bytes left
[    6.867030] Kernel panic - not syncing: Attempted to kill init!
[    6.867386] Pid: 1, comm: swapper Tainted: G      D    2.6.33-rc3-next-20100112 #54
[    6.867855] Call Trace:
[    6.868041]  [<ffffffff816e040f>] panic+0xb7/0x181
[    6.868349]  [<ffffffff8108f708>] ? exit_ptrace+0x38/0x140
[    6.868685]  [<ffffffff81087320>] ? do_exit+0x6e0/0x8a0
[    6.869007]  [<ffffffff81086e5b>] ? do_exit+0x21b/0x8a0
[    6.869329]  [<ffffffff810b974d>] ? trace_hardirqs_on+0xd/0x10
[    6.869680]  [<ffffffff816e44b0>] ? _raw_write_unlock_irq+0x30/0x40
[    6.870052]  [<ffffffff8108734a>] do_exit+0x70a/0x8a0
[    6.870365]  [<ffffffff81083c10>] ? kmsg_dump+0x160/0x190
[    6.870696]  [<ffffffff816e6164>] oops_end+0xe4/0xf0
[    6.871001]  [<ffffffff8103bf0b>] die+0x5b/0x90
[    6.871289]  [<ffffffff816e5a36>] do_trap+0x156/0x180
[    6.871602]  [<ffffffff81039b65>] do_invalid_op+0x95/0xb0
[    6.871933]  [<ffffffff815777f9>] ? lock_policy_rwsem_write+0x69/0x90
[    6.872317]  [<ffffffff8103f729>] ? sched_clock+0x9/0x10
[    6.872644]  [<ffffffff816e3f9e>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    6.873029]  [<ffffffff816e5080>] ? irq_return+0x0/0x10
[    6.873350]  [<ffffffff81038ddb>] invalid_op+0x1b/0x20
[    6.873667]  [<ffffffff815777f9>] ? lock_policy_rwsem_write+0x69/0x90
[    6.874049]  [<ffffffff815785ea>] cpufreq_update_policy+0x2a/0x110
[    6.874417]  [<ffffffff813cf1f9>] ? kobject_uevent_env+0x179/0x440
[    6.874785]  [<ffffffff8103f6c0>] ? native_sched_clock+0x20/0x80
[    6.875145]  [<ffffffff8103f729>] ? sched_clock+0x9/0x10
[    6.875470]  [<ffffffff810ab205>] ? sched_clock_cpu+0xb5/0x100
[    6.875822]  [<ffffffff810b753d>] ? trace_hardirqs_off+0xd/0x10
[    6.876177]  [<ffffffff810ab2bf>] ? cpu_clock+0x6f/0x80
[    6.876503]  [<ffffffff810b757d>] ? lock_release_holdtime+0x3d/0x1c0
[    6.876880]  [<ffffffff816e1e79>] ? __mutex_unlock_slowpath+0xf9/0x1a0
[    6.877265]  [<ffffffff810b96f5>] ? trace_hardirqs_on_caller+0x155/0x1a0
[    6.877659]  [<ffffffff810b974d>] ? trace_hardirqs_on+0xd/0x10
[    6.878009]  [<ffffffff816e1f2e>] ? mutex_unlock+0xe/0x10
[    6.878338]  [<ffffffff81c98156>] cpufreq_stats_init+0x83/0xb5
[    6.878689]  [<ffffffff81c980d3>] ? cpufreq_stats_init+0x0/0xb5
[    6.879046]  [<ffffffff810001dd>] do_one_initcall+0x3d/0x1d0
[    6.879388]  [<ffffffff81c66705>] kernel_init+0x192/0x1ea
[    6.879718]  [<ffffffff81038f64>] kernel_thread_helper+0x4/0x10
[    6.880073]  [<ffffffff816e5050>] ? restore_args+0x0/0x30
[    6.880409]  [<ffffffff81c66573>] ? kernel_init+0x0/0x1ea
[    6.880437] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    6.881075]  [<ffffffff81038f60>] ? kernel_thread_helper+0x0/0x10
[    6.881441] Rebooting in 10 seconds..

