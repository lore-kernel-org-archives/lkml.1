Return-Path: <linux-kernel-owner+w=401wt.eu-S1761213AbYDCVFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761213AbYDCVFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760849AbYDCVEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:04:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:60600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760762AbYDCVEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:04:31 -0400
Subject: Re: [>=2.6.23][BUG] Oops on power disconnection
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Sanjeev Aditya Naga <sanjeev.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <5681ec900804030915w720f3ccfp74e5d501ca3d6b56@mail.gmail.com>
References: <5681ec900803300645l5369cda4g119957a4b7f05d17@mail.gmail.com>
	 <5681ec900803300651m6e5f38deke1b7746236e5bb9@mail.gmail.com>
	 <20080402001418.aad6eed2.akpm@linux-foundation.org>
	 <5681ec900804020608o62be52c4ted172e18daf24f5b@mail.gmail.com>
	 <1207147729.30061.9.camel@hammer1.suse.de>
	 <5681ec900804020913t4adc38b1r2e424fa8bbdda241@mail.gmail.com>
	 <1207159974.4700.6.camel@queen.suse.de>
	 <5681ec900804030915w720f3ccfp74e5d501ca3d6b56@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 03 Apr 2008 23:04:38 +0200
Message-Id: <1207256678.6024.90.camel@linux-2bdv.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-03 at 21:45 +0530, Sanjeev Aditya Naga wrote:
> Hello Thomas,
> 
> On Wed, Apr 2, 2008 at 11:42 PM, Thomas Renninger <trenn@suse.de> wrote:
> >
> > On Wed, 2008-04-02 at 21:43 +0530, Sanjeev Aditya Naga wrote:
> >  > Hello Thomas,
> >  >
> >  > > Hi,
> >  > >
> >  > >
> >  > >  On Wed, 2008-04-02 at 18:38 +0530, Sanjeev Aditya Naga wrote:
> >  > >  > Hello Andrew Morton,
> >  > >  >
> >  > >  > Greetings!
> >  > >  >
> >  > >  > Thank you for the update. Is there anything I can do
> >  > >  > from my side?
> >  > >  >
> >  > >  > I thought it was a acpi (dsdt) problem. And based on
> >  > >  > a tutorial, I have tried to extract, fix, recompile the dsdt
> >  > >  > and use it with the kernel. But still I have the same problem.
> >  > >  > Let me know if I shall attach the dsdt (original) decompiled
> >  > >  > code, if that helps.
> >  > >
> >  > >  this could be due a general memory corruption problem through ACPICA.
> >  > >  If you get different backtraces on reboots even you only modified things
> >  > >  that do not have to do with the problem, it's probably that and related
> >  > >  to:
> >  > >  ﻿http://bugzilla.kernel.org/show_bug.cgi?id=10339
> >  > >
> >  > >  You might want to try the latest kernel or the patch posted there.
> >  >
> >  > Thank you for the update.
> >  > I have checked the bug and unfortunately its not the
> >  > same issue. Things work absolutely fine, when I'm
> >  > running on AC power. It even displays the exact
> >  > battery (and charging) status to me. It messes up
> >  > when suddenly AC power gets disconnected and
> >  > switches to battery mode (The time when I get Oops).
> >  > The system is still usable after switching to battery
> >  > mode and I still get correct battery stats until its
> >  > completely discharged. However most of the commands
> >  > like kill, poweroff, java doesn't work after the Oops.
> >  The bug is not related to battery, but to AML parsing and can therefore
> >  affect anything which is ACPI related.
> >
> >
> >  > BTW there is one similarity with the referenced bug.
> >  > If I boot the computer without AC Power, it gives the
> >  > same Oops and stops during booting itself.
> >  >
> >  > I shall try the latest kernel once and shall update you.
> >  That would be great.
> >  If it works, please give the patch there a try, IMO this one should see
> >  2.6.2[34].X stable kernels soon.
> 
> I have got the lastest kernel 2.6.25-rc8 today. I observed that
> the referenced patch is already in the kernel. However this didn't
> solve the problem in question. I get the same Oops on this kernel
> as well. Find the latest dmesg along with the Oops:
Ok.
Maybe best is you document the backtraces/oopses with kernel versions at
bugzilla.kernel.org and add dmesg and acpidump.
It seems your machine notifies OS that the C-state table changed.
AFAIK this is rare and there might be a general bug in the cpuidle layer
which I do not know well.
Best you add Venkatesh and Shaohua Li <shaohua.li@intel.com> to CC of
the bug.
While the backtrace shows a lot, cpuidle IMO is missing a general debug
option like in the cpufreq layer.
I couldn't find a single printk in the whole cpuidle/{cpuidle,sysfs}.c
files, even on error paths. ﻿Also in the cpuidle specific parts of
drivers/acpi/processor_idle.c some debug printks may help for future bug
reports. It is very hard to guess what happened...

   Thomas

> Regards,
> Sanjeev
> 
> ------------[ cut here ]------------
> WARNING: at lib/kref.c:43 kref_get+0x17/0x1c()
> Modules linked in: wlan_scan_sta ath_rate_sample ath_pci wlan
> ath_hal(P) sit tunnel4 ipv6 cbc aes_i586 aes_generic dm_crypt
> ipt_MASQUERADE iptable_nat nf_nat bridge autofs4 nf_conntrack_ipv4
> xt_state nf_conntrack xt_tcpudp ipt_REJECT iptable_filter ip_tables
> x_tables cpufreq_ondemand acpi_cpufreq fuse loop dm_mirror
> dm_multipath dm_mod snd_hda_intel snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
> snd_pcm snd_timer sr_mod video 8139cp snd_page_alloc 8139too snd_hwdep
> i2c_piix4 i2c_core pcspkr output snd battery soundcore ac mii joydev
> sg cdrom button pata_atiixp pata_acpi sata_sil ata_generic libata
> sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last
> unloaded: microcode]
> Pid: 70, comm: kacpi_notify Tainted: P         2.6.25-rc8 #2
>  [<c0427dcc>] warn_on_slowpath+0x40/0x65
>  [<c043007b>] switch_uid+0x5a/0x70
>  [<c04147bc>] smp_call_function_single+0x27/0x47
>  [<c04f1610>] number+0x120/0x1e6
>  [<c04f1ed1>] vsnprintf+0x40a/0x447
>  [<c04ef103>] kref_get+0x17/0x1c
>  [<c04ee6a0>] kobject_get+0xf/0x13
>  [<c04ee72f>] kobject_add_internal+0x42/0x13b
>  [<c04ee8dc>] kobject_init_and_add+0x23/0x25
>  [<c0596b90>] cpuidle_add_state_sysfs+0x63/0xd7
>  [<c05144d4>] acpi_os_execute_deferred+0x0/0x25
>  [<c0596498>] cpuidle_enable_device+0x35/0xac
>  [<c0531c28>] acpi_processor_cst_has_changed+0x40/0x54
>  [<c052fac1>] acpi_processor_notify+0x83/0xde
>  [<c0519549>] acpi_ev_notify_dispatch+0x4c/0x57
>  [<c05144f1>] acpi_os_execute_deferred+0x1d/0x25
>  [<c0435441>] run_workqueue+0x74/0xef
>  [<c0435572>] worker_thread+0xb6/0xc2
>  [<c0437f8a>] autoremove_wake_function+0x0/0x2d
>  [<c04354bc>] worker_thread+0x0/0xc2
>  [<c0437d35>] kthread+0x38/0x5d
>  [<c0437cfd>] kthread+0x0/0x5d
>  [<c0406d47>] kernel_thread_helper+0x7/0x10
>  =======================
> ---[ end trace c2cdf21b5cc60ed6 ]---
> 
> dmesg output:
> 
> Initializing cgroup subsys cpuset
> Linux version 2.6.25-rc8 (root@draksha.cultuzz.in) (gcc version 4.3.0
> 20080222 (Red Hat 4.3.0-0.11) (GCC) ) #2 SMP Mon Apr 7 11:37:36 IST
> 2008
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
>  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
>  BIOS-e820: 00000000000dc000 - 00000000000e0000 (reserved)
>  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000057e80000 (usable)
>  BIOS-e820: 0000000057e80000 - 0000000057e96000 (ACPI data)
>  BIOS-e820: 0000000057e96000 - 0000000057f00000 (ACPI NVS)
>  BIOS-e820: 0000000057f00000 - 0000000058000000 (reserved)
>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> 510MB HIGHMEM available.
> 896MB LOWMEM available.
> Scan SMP from c0000000 for 1024 bytes.
> Scan SMP from c009fc00 for 1024 bytes.
> Scan SMP from c00f0000 for 65536 bytes.
> found SMP MP-table at [c00f7130] 000f7130
> Entering add_active_range(0, 0, 360064) 0 entries of 256 used
> Zone PFN ranges:
>   DMA             0 ->     4096
>   Normal       4096 ->   229376
>   HighMem    229376 ->   360064
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     0:        0 ->   360064
> On node 0 totalpages: 360064
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 4064 pages, LIFO batch:0
>   Normal zone: 1760 pages used for memmap
>   Normal zone: 223520 pages, LIFO batch:31
>   HighMem zone: 1021 pages used for memmap
>   HighMem zone: 129667 pages, LIFO batch:31
>   Movable zone: 0 pages used for memmap
> DMI present.
> Using APIC driver default
> ACPI: RSDP 000F7070, 0014 (r0 TOSQCI)
> ACPI: RSDT 57E8F4EF, 0038 (r1 TOSQCI TOSQCI00  6040000  LTP        0)
> ACPI: FACP 57E95D7C, 0074 (r1 ATI    Bonefish  6040000 ATI     F4240)
> ACPI: DSDT 57E8FF4C, 5E30 (r1 TOSQCI L10       6040000 MSFT  2000002)
> ACPI: FACS 57E96FC0, 0040
> ACPI: APIC 57E95DF0, 005E (r1 PTLTD  	 APIC    6040000  LTP        0)
> ACPI: MCFG 57E95E4E, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
> ACPI: SLIC 57E95E8A, 0176 (r1 TOSQCI TOSQCI00  6040000  LTP        0)
> ACPI: SSDT 57E8F527, 0535 (r1  PmRef    CpuPm     3000 INTL 20050228)
> ACPI: DMI detected: Toshiba
> ATI board detected. Disabling timer routing over 8254.
> ACPI: PM-Timer IO Port: 0x8008
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> Processor #0 6:14 APIC version 20
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> Processor #1 6:14 APIC version 20
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> Using ACPI (MADT) for SMP configuration information
> Allocating PCI resources starting at 60000000 (gap: 58000000:88000000)
> PM: Registered nosave memory: 000000000009d000 - 000000000009e000
> PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000ce000
> PM: Registered nosave memory: 00000000000ce000 - 00000000000d0000
> PM: Registered nosave memory: 00000000000d0000 - 00000000000dc000
> PM: Registered nosave memory: 00000000000dc000 - 00000000000e0000
> PM: Registered nosave memory: 00000000000e0000 - 00000000000e4000
> PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 357251
> Kernel command line: ro root=LABEL=/1 rhgb quiet acpi_os="!Linux"
> acpi_os_name="Windows 2006"
> mapped APIC to ffffb000 (fee00000)
> mapped IOAPIC to ffffa000 (fec00000)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> CPU 0 irqstacks, hard=c07b0000 soft=c0790000
> PID hash table entries: 4096 (order: 12, 16384 bytes)
> Detected 1600.057 MHz processor.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Memory: 1419748k/1440256k available (2198k kernel code, 19260k
> reserved, 1127k data, 280k init, 522752k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xffc52000 - 0xfffff000   (3764 kB)
>     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
>     vmalloc : 0xf8800000 - 0xff3fe000   ( 107 MB)
>     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>       .init : 0xc0747000 - 0xc078d000   ( 280 kB)
>       .data : 0xc0625b16 - 0xc073f7f0   (1127 kB)
>       .text : 0xc0400000 - 0xc0625b16   (2198 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> CPA: page pool initialized 1 of 1 pages preallocated
> SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
> Calibrating delay using timer specific routine.. 3203.40 BogoMIPS (lpj=1601701)
> Security Framework initialized
> SELinux:  Initializing.
> SELinux:  Starting in permissive mode
> selinux_register_security:  Registering secondary module capability
> Capability LSM initialized as secondary
> Mount-cache hash table entries: 512
> Initializing cgroup subsys ns
> Initializing cgroup subsys cpuacct
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 1024K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> using mwait in idle threads.
> Compat vDSO mapped to ffffe000.
> Checking 'hlt' instruction... OK.
> Early unpacking initramfs... done
> ACPI: Core revision 20070126
> ACPI: Overriding _OS definition to 'Windows 2006'
> ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
> CPU0: Intel Genuine Intel(R) CPU           T2060  @ 1.60GHz stepping 0c
> Booting processor 1/1 ip 4000
> CPU 1 irqstacks, hard=c07b1000 soft=c0791000
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 3199.54 BogoMIPS (lpj=1599774)
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 1024K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#1.
> CPU1: Intel Genuine Intel(R) CPU           T2060  @ 1.60GHz stepping 0c
> Total of 2 processors activated (6402.95 BogoMIPS).
> ENABLING IO-APIC IRQs
> ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> Brought up 2 CPUs
> CPU0 attaching sched-domain:
>  domain 0: span 00000003
>   groups: 00000001 00000002
> CPU1 attaching sched-domain:
>  domain 0: span 00000003
>   groups: 00000002 00000001
> net_namespace: 548 bytes
> Booting paravirtualized kernel on bare hardware
> NET: Registered protocol family 16
> No dock devices found.
> ACPI: bus type pci registered
> PCI: Using MMCONFIG for extended config space
> PCI: Using configuration type 1
> Setting up standard PCI resources
> ACPI: EC: Look up EC in DSDT
> ACPI Error (dswload-0664): [\___] Namespace lookup failure, AE_NOT_FOUND
> ACPI Exception (psloop-0225): AE_NOT_FOUND, During name lookup/catalog
> [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0._INI] (Node f781a6c0), AE_NOT_FOUND
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: EC: GPE = 0x10, I/O: command/status = 0x66, data = 0x62
> ACPI: EC: driver started in poll mode
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: Transparent bridge - 0000:00:14.4
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
>  00:09: mem resource (0xc0004800-0xc00057ff) overlaps 0000:00:01.0 BAR
> 8 (0xc0000000-0xc00fffff), disabling
> pnp: PnP ACPI: found 10 devices
> ACPI: ACPI bus type pnp unregistered
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> NetLabel: Initializing
> NetLabel:  domain hash size = 128
> NetLabel:  protocols = UNLABELED CIPSOv4
> NetLabel:  unlabeled traffic allowed by default
> system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
> system 00:08: ioport range 0x1080-0x1080 has been reserved
> system 00:08: ioport range 0x200-0x20f has been reserved
> system 00:08: ioport range 0x40b-0x40b has been reserved
> system 00:08: ioport range 0x4d0-0x4d1 has been reserved
> system 00:08: ioport range 0x4d6-0x4d6 has been reserved
> system 00:08: ioport range 0x530-0x537 has been reserved
> system 00:08: ioport range 0xc00-0xc01 has been reserved
> system 00:08: ioport range 0xc14-0xc14 has been reserved
> system 00:08: ioport range 0xc50-0xc52 has been reserved
> system 00:08: ioport range 0xc6c-0xc6c has been reserved
> system 00:08: ioport range 0xc6f-0xc6f has been reserved
> system 00:08: ioport range 0xcd4-0xcd5 has been reserved
> system 00:08: ioport range 0xcd6-0xcd7 has been reserved
> system 00:08: ioport range 0xcd8-0xcdf has been reserved
> system 00:08: ioport range 0x8000-0x805f could not be reserved
> system 00:08: ioport range 0x8210-0x821f has been reserved
> system 00:08: ioport range 0xf40-0xf47 has been reserved
> system 00:08: ioport range 0x280-0x293 has been reserved
> system 00:08: ioport range 0x87f-0x87f has been reserved
> system 00:09: iomem range 0xe0000-0xfffff could not be reserved
> system 00:09: iomem range 0xfff00000-0xffffffff could not be reserved
> system 00:09: iomem range 0x0-0xfff could not be reserved
> PCI: Bridge: 0000:00:01.0
>   IO window: 9000-9fff
>   MEM window: 0xc0000000-0xc00fffff
>   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
> PCI: Bus 10, cardbus bridge: 0000:09:01.0
>   IO window: 0x0000a400-0x0000a4ff
>   IO window: 0x0000a800-0x0000a8ff
>   PREFETCH window: 0x60000000-0x63ffffff
>   MEM window: 0x64000000-0x67ffffff
> PCI: Bridge: 0000:00:14.4
>   IO window: a000-afff
>   MEM window: 0xc0100000-0xc01fffff
>   PREFETCH window: 0x0000000060000000-0x0000000063ffffff
> PCI: Enabling device 0000:09:01.0 (0000 -> 0003)
> ACPI: PCI Interrupt 0000:09:01.0[A] -> GSI 20 (level, low) -> IRQ 20
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> checking if image is initramfs... it is
> Freeing initrd memory: 2618k freed
> apm: BIOS not found.
> audit: initializing netlink socket (disabled)
> type=2000 audit(1207624959.772:1): initialized
> highmem bounce pool size: 64 pages
> Total HugeTLB memory allocated, 0
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> SELinux:  Registering netfilter hooks
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> pci 0000:01:05.0: Boot video device
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> ACPI: SSDT 57E8FCDD, 01E8 (r1  PmRef  Cpu0Ist     3000 INTL 20050228)
> ACPI: SSDT 57E8FA5C, 01FC (r1  PmRef  Cpu0Cst     3001 INTL 20050228)
> ACPI: ACPI0007:00 is registered as cooling_device0
> ACPI: Processor [CPU0] (supports 8 throttling states)
> ACPI: SSDT 57E8FEC5, 0087 (r1  PmRef  Cpu1Ist     3000 INTL 20050228)
> ACPI: SSDT 57E8FC58, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050228)
> ACPI: ACPI0007:01 is registered as cooling_device1
> ACPI: Processor [CPU1] (supports 8 throttling states)
> ACPI: LNXTHERM:01 is registered as thermal_zone0
> ACPI: EC: non-query interrupt received, switching to interrupt mode
> ACPI: Thermal Zone [THRM] (41 C)
> isapnp: Scanning for PnP cards...
> Switched to high resolution mode on CPU 1
> Switched to high resolution mode on CPU 0
> isapnp: No Plug & Play device found
> Real Time Clock Driver v1.12ac
> Non-volatile memory driver v1.2
> Linux agpgart interface v0.103
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> brd: module loaded
> input: Macintosh mouse button emulation as /devices/virtual/input/input0
> Yenta: CardBus bridge found at 0000:09:01.0 [1179:ff31]
> Yenta: Using CSCINT to route CSC interrupts to PCI
> Yenta: Routing CardBus interrupts to PCI
> Yenta TI: socket 0000:09:01.0, mfunc 0x00001002, devctl 0x44
> Yenta: ISA IRQ mask 0x0cf8, PCI irq 20
> Socket status: 30000006
> pcmcia: parent PCI bridge I/O window: 0xa000 - 0xafff
> cs: IO port probe 0xa000-0xafff: clean.
> pcmcia: parent PCI bridge Memory window: 0xc0100000 - 0xc01fffff
> pcmcia: parent PCI bridge Memory window: 0x60000000 - 0x63ffffff
> PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input1
> cpuidle: using governor ladder
> cpuidle: using governor menu
> usbcore: registered new interface driver hiddev
> usbcore: registered new interface driver usbhid
> drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> TCP cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> Using IPI No-Shortcut mode
> registered taskstats version 1
> Freeing unused kernel memory: 280k freed
> Write protecting the kernel read-only data: 916k
> ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
> ehci_hcd 0000:00:13.2: EHCI Host Controller
> ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:13.2: irq 19, io mem 0xc0406000
> ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 8 ports detected
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: EHCI Host Controller
> usb usb1: Manufacturer: Linux 2.6.25-rc8 ehci_hcd
> usb usb1: SerialNumber: 0000:00:13.2
> ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
> ohci_hcd 0000:00:13.0: OHCI Host Controller
> ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
> ohci_hcd 0000:00:13.0: irq 19, io mem 0xc0404000
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 4 ports detected
> usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb2: Product: OHCI Host Controller
> usb usb2: Manufacturer: Linux 2.6.25-rc8 ohci_hcd
> usb usb2: SerialNumber: 0000:00:13.0
> ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
> ohci_hcd 0000:00:13.1: OHCI Host Controller
> ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
> ohci_hcd 0000:00:13.1: irq 19, io mem 0xc0405000
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 4 ports detected
> Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04713/0x0
> synaptics: Toshiba Satellite L35 detected, limiting rate to 40pps.
> input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input2
> usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb3: Product: OHCI Host Controller
> usb usb3: Manufacturer: Linux 2.6.25-rc8 ohci_hcd
> usb usb3: SerialNumber: 0000:00:13.1
> USB Universal Host Controller Interface driver v3.0
> SCSI subsystem initialized
> Driver 'sd' needs updating - please use bus_type methods
> libata version 3.00 loaded.
> sata_sil 0000:00:12.0: version 2.3
> PCI: Enabling device 0000:00:12.0 (0005 -> 0007)
> ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
> scsi0 : sata_sil
> scsi1 : sata_sil
> ata1: SATA max UDMA/100 mmio m512@0xc0407000 tf 0xc0407080 irq 22
> ata2: SATA max UDMA/100 mmio m512@0xc0407000 tf 0xc04070c0 irq 22
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-7: TOSHIBA MK8037GSX, DL230M, max UDMA/100
> ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata1.00: configured for UDMA/100
> ata2: SATA link down (SStatus 0 SControl 300)
> scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK8037GS DL23 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sda: sda1 sda2 sda3 sda4
> sd 0:0:0:0: [sda] Attached SCSI disk
> ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:14.1 to 64
> ACPI: PCI interrupt for device 0000:00:14.1 disabled
> ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
> scsi2 : pata_atiixp
> scsi3 : pata_atiixp
> ata3: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x8460 irq 14
> ata4: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x8468 irq 15
> ata3: port disabled. ignoring.
> ata4.00: ATAPI: MATSHITADVD-RAM UJ-850S, 1.10, max UDMA/33
> ata4.00: configured for UDMA/33
> scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-850S  1.10 PQ: 0 ANSI: 5
> EXT3-fs: INFO: recovery required on readonly filesystem.
> EXT3-fs: write access will be enabled during recovery.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: recovery complete.
> EXT3-fs: mounted filesystem with ordered data mode.
> SELinux:  Disabled at runtime.
> SELinux:  Unregistering netfilter hooks
> type=1404 audit(1207624975.849:2): selinux=0 auid=4294967295 ses=4294967295
> input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> ACPI: Power Button (FF) [PWRF]
> input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input4
> ACPI: Lid Switch [LID]
> input: Power Button (CM) as
> /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
> ACPI: Power Button (CM) [PWRB]
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> scsi 3:0:0:0: Attached scsi generic sg1 type 5
> ACPI: AC Adapter [ACAD] (on-line)
> input: PC Speaker as /devices/platform/pcspkr/input/input6
> cs: IO port probe 0x100-0x3af: clean.
> cs: IO port probe 0x3e0-0x4ff: clean.
> cs: IO port probe 0x820-0x8ff: clean.
> cs: IO port probe 0xc00-0xcf7: clean.
> cs: IO port probe 0xa00-0xaff: clean.
> piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
> 8139too Fast Ethernet driver 0.9.28
> ACPI: PCI Interrupt 0000:09:02.0[A] -> GSI 21 (level, low) -> IRQ 21
> eth0: RealTek RTL8139 at 0xf8914000, 00:1b:24:1e:9a:57, IRQ 21
> eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
> ACPI: Battery Slot [BAT1] (battery present)
> 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
> Driver 'sr' needs updating - please use bus_type methods
> sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> Uniform CD-ROM driver Revision: 3.20
> sr 3:0:0:0: Attached scsi CD-ROM sr0
> ACPI: device:1d is registered as cooling_device2
> input: Video Bus as
> /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1a/device:1b/input/input7
> ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
> ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
> ALSA sound/pci/hda/hda_intel.c:1813: chipset global capabilities = 0x4401
> ALSA sound/pci/hda/hda_intel.c:749: codec_mask = 0xb
> ALSA sound/pci/hda/hda_codec.c:2214: hda_codec: model '3stack' is selected
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Surround
> Playback Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Center Playback
> Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave LFE Playback
> Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Side Playback
> Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Headphone
> Playback Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Speaker
> Playback Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Mono Playback
> Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Line-Out
> Playback Volume, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Surround
> Playback Switch, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Center Playback
> Switch, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave LFE Playback
> Switch, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Side Playback
> Switch, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Speaker
> Playback Switch, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave Mono Playback
> Switch, skipped
> ALSA sound/pci/hda/hda_codec.c:1076: Cannot find slave IEC958 Playback
> Switch, skipped
> device-mapper: uevent: version 1.0.3
> device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
> device-mapper: multipath: version 1.0.5 loaded
> loop: module loaded
> EXT3 FS on sda4, internal journal
> fuse init (API version 7.9)
> Adding 3116600k swap on /dev/sda3.  Priority:-1 extents:1 across:3116600k
> IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
> ip_tables: (C) 2000-2006 Netfilter Core Team
> nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> openser[1791]: segfault at 9 ip 0045a625 sp bf89948c error 4 in
> libc-2.7.90.so[3e2000+169000]
> Bridge firewalling registered
> virbr0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
> virbr0: starting userspace STP failed, starting kernel STP
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
> EXT3 FS on dm-0, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> warning: `pulseaudio' uses 32-bit capabilities (legacy support in use)
> ALSA sound/pci/hda/hda_intel.c:1293: azx_pcm_prepare: bufsize=0x4400,
> fragsize=0x1100, format=0x4011
> ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x5,
> stream=0x5, channel=0, format=0x4011
> hda-intel: Invalid position buffer, using LPIB read method instead.
> ALSA sound/pci/hda/hda_intel.c:1293: azx_pcm_prepare: bufsize=0x4400,
> fragsize=0x1100, format=0x4011
> ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x9,
> stream=0x1, channel=0, format=0x4011
> ALSA sound/pci/hda/hda_intel.c:1293: azx_pcm_prepare: bufsize=0x4400,
> fragsize=0x1100, format=0x4011
> ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x9,
> stream=0x1, channel=0, format=0x4011
> ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x9,
> stream=0x0, channel=0, format=0x0
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x3,
> stream=0x0, channel=0, format=0x0
> ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x4,
> stream=0x0, channel=0, format=0x0
> ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x5,
> stream=0x0, channel=0, format=0x0
> IPv6 over IPv4 tunneling driver
> sit0: Disabled Privacy Extensions
> eth0: link down
> ADDRCONF(NETDEV_UP): eth0: link is not ready
> ath_hal: module license 'Proprietary' taints kernel.
> ath_hal: 0.9.30.13 (AR5210, AR5211, AR5212, AR5416, RF5111, RF5112,
> RF2413, RF5413, RF2133)
> wlan: svn r3349
> ath_pci: svn r3349
> ACPI: PCI Interrupt 0000:09:04.0[A] -> GSI 22 (level, low) -> IRQ 22
> MadWifi: ath_attach: Switching rfkill capability off
> ath_rate_sample: 1.2 (svn r3349)
> MadWifi: ath_attach: Switching per-packet transmit power control off
> wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
> wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps
> 24Mbps 36Mbps 48Mbps 54Mbps
> wifi0: H/W encryption support: WEP AES AES_CCM TKIP
> wifi0: ath_announce: Use hw queue 1 for WME_AC_BE traffic
> wifi0: ath_announce: Use hw queue 0 for WME_AC_BK traffic
> wifi0: ath_announce: Use hw queue 2 for WME_AC_VI traffic
> wifi0: ath_announce: Use hw queue 3 for WME_AC_VO traffic
> wifi0: ath_announce: Use hw queue 8 for CAB traffic
> wifi0: ath_announce: Use hw queue 9 for beacons
> ath_pci: wifi0: Atheros 5212: mem=0xc0110000, irq=22
> udev: renamed network interface ath0 to wlan0
> wlan0: no IPv6 routers present
> ALSA sound/pci/hda/hda_intel.c:1293: azx_pcm_prepare: bufsize=0x4400,
> fragsize=0x1100, format=0x4011
> ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x4,
> stream=0x0, channel=0, format=0x0
> ALSA sound/pci/hda/hda_codec.c:686: hda_codec_setup_stream: NID=0x5,
> stream=0x0, channel=0, format=0x0
> ------------[ cut here ]------------
> WARNING: at lib/kref.c:43 kref_get+0x17/0x1c()
> Modules linked in: wlan_scan_sta ath_rate_sample ath_pci wlan
> ath_hal(P) sit tunnel4 ipv6 cbc aes_i586 aes_generic dm_crypt
> ipt_MASQUERADE iptable_nat nf_nat bridge autofs4 nf_conntrack_ipv4
> xt_state nf_conntrack xt_tcpudp ipt_REJECT iptable_filter ip_tables
> x_tables cpufreq_ondemand acpi_cpufreq fuse loop dm_mirror
> dm_multipath dm_mod snd_hda_intel snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
> snd_pcm snd_timer sr_mod video 8139cp snd_page_alloc 8139too snd_hwdep
> i2c_piix4 i2c_core pcspkr output snd battery soundcore ac mii joydev
> sg cdrom button pata_atiixp pata_acpi sata_sil ata_generic libata
> sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last
> unloaded: microcode]
> Pid: 70, comm: kacpi_notify Tainted: P         2.6.25-rc8 #2
>  [<c0427dcc>] warn_on_slowpath+0x40/0x65
>  [<c043007b>] switch_uid+0x5a/0x70
>  [<c04147bc>] smp_call_function_single+0x27/0x47
>  [<c04f1610>] number+0x120/0x1e6
>  [<c04f1ed1>] vsnprintf+0x40a/0x447
>  [<c04ef103>] kref_get+0x17/0x1c
>  [<c04ee6a0>] kobject_get+0xf/0x13
>  [<c04ee72f>] kobject_add_internal+0x42/0x13b
>  [<c04ee8dc>] kobject_init_and_add+0x23/0x25
>  [<c0596b90>] cpuidle_add_state_sysfs+0x63/0xd7
>  [<c05144d4>] acpi_os_execute_deferred+0x0/0x25
>  [<c0596498>] cpuidle_enable_device+0x35/0xac
>  [<c0531c28>] acpi_processor_cst_has_changed+0x40/0x54
>  [<c052fac1>] acpi_processor_notify+0x83/0xde
>  [<c0519549>] acpi_ev_notify_dispatch+0x4c/0x57
>  [<c05144f1>] acpi_os_execute_deferred+0x1d/0x25
>  [<c0435441>] run_workqueue+0x74/0xef
>  [<c0435572>] worker_thread+0xb6/0xc2
>  [<c0437f8a>] autoremove_wake_function+0x0/0x2d
>  [<c04354bc>] worker_thread+0x0/0xc2
>  [<c0437d35>] kthread+0x38/0x5d
>  [<c0437cfd>] kthread+0x0/0x5d
>  [<c0406d47>] kernel_thread_helper+0x7/0x10
>  =======================
> ---[ end trace c2cdf21b5cc60ed6 ]---
> BUG: unable to handle kernel NULL pointer dereference at 00000020
> IP: [<c04b56d0>] sysfs_addrm_start+0x1e/0x7a
> *pde = 5784d067
> Oops: 0000 [#1] SMP
> Modules linked in: wlan_scan_sta ath_rate_sample ath_pci wlan
> ath_hal(P) sit tunnel4 ipv6 cbc aes_i586 aes_generic dm_crypt
> ipt_MASQUERADE iptable_nat nf_nat bridge autofs4 nf_conntrack_ipv4
> xt_state nf_conntrack xt_tcpudp ipt_REJECT iptable_filter ip_tables
> x_tables cpufreq_ondemand acpi_cpufreq fuse loop dm_mirror
> dm_multipath dm_mod snd_hda_intel snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
> snd_pcm snd_timer sr_mod video 8139cp snd_page_alloc 8139too snd_hwdep
> i2c_piix4 i2c_core pcspkr output snd battery soundcore ac mii joydev
> sg cdrom button pata_atiixp pata_acpi sata_sil ata_generic libata
> sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last
> unloaded: microcode]
> 
> Pid: 70, comm: kacpi_notify Tainted: P         (2.6.25-rc8 #2)
> EIP: 0060:[<c04b56d0>] EFLAGS: 00010246 CPU: 1
> EIP is at sysfs_addrm_start+0x1e/0x7a
> EAX: 41ed0000 EBX: 00000000 ECX: 00000000 EDX: 00000246
> ESI: f7873ee0 EDI: f7873ef0 EBP: 00000000 ESP: f7873ed0
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process kacpi_notify (pid: 70, ti=f7873000 task=f78874d0 task.ti=f7873000)
> Stack: f2d86c94 f71484b0 fffffff4 c04b5af4 00000000 00000000 00000000 00000000
>        f2d86c94 fffffffe f2d86c94 f7a9001c c04b5b56 f7873f08 c04ee6a0 f2d86c94
>        c04ee78f f7a90318 f2d86c80 00000000 f2d86c94 f7a9001c c04ee8dc f7873f44
> Call Trace:
>  [<c04b5af4>] create_dir+0x33/0x6c
>  [<c04b5b56>] sysfs_create_dir+0x29/0x3b
>  [<c04ee6a0>] kobject_get+0xf/0x13
>  [<c04ee78f>] kobject_add_internal+0xa2/0x13b
>  [<c04ee8dc>] kobject_init_and_add+0x23/0x25
>  [<c0596b90>] cpuidle_add_state_sysfs+0x63/0xd7
>  [<c05144d4>] acpi_os_execute_deferred+0x0/0x25
>  [<c0596498>] cpuidle_enable_device+0x35/0xac
>  [<c0531c28>] acpi_processor_cst_has_changed+0x40/0x54
>  [<c052fac1>] acpi_processor_notify+0x83/0xde
>  [<c0519549>] acpi_ev_notify_dispatch+0x4c/0x57
>  [<c05144f1>] acpi_os_execute_deferred+0x1d/0x25
>  [<c0435441>] run_workqueue+0x74/0xef
>  [<c0435572>] worker_thread+0xb6/0xc2
>  [<c0437f8a>] autoremove_wake_function+0x0/0x2d
>  [<c04354bc>] worker_thread+0x0/0xc2
>  [<c0437d35>] kthread+0x38/0x5d
>  [<c0437cfd>] kthread+0x0/0x5d
>  [<c0406d47>] kernel_thread_helper+0x7/0x10
>  =======================
> Code: 75 ee 89 56 0c 31 c0 89 31 5b 5e 5f c3 57 b9 04 00 00 00 56 89
> c7 53 89 c6 89 d3 31 c0 f3 ab b8 34 83 71 c0 89 16 e8 57 bd 16 00 <8b>
> 53 20 b9 8c 53 4b c0 a1 88 54 83 c0  53 e8 a6 7f fd ff 5b 85
> EIP: [<c04b56d0>] sysfs_addrm_start+0x1e/0x7a SS:ESP 0068:f7873ed0
> ---[ end trace c2cdf21b5cc60ed6 ]---
> 
> 
> >
> >  Thanks,
> >
> >     Thomas
> >
> >
> >
> >  >
> >  > >
> >  > >    Thomas
> >  > >
> >  > >
> >  > >
> >  > >  > Kind Regards,
> >  > >  > Sanjeev
> >  > >  >
> >  > >  > On Wed, Apr 2, 2008 at 12:44 PM, Andrew Morton
> >  > >  > <akpm@linux-foundation.org> wrote:
> >  > >  > >
> >  > >  > > On Sun, 30 Mar 2008 19:21:39 +0530 "Sanjeev Aditya Naga" <sanjeev.kernel@gmail.com> wrote:
> >  > >  > >
> >  > >  > >  > Hi,
> >  > >  > >  >
> >  > >  > >  >  This happens everytime there is a power disconnection
> >  > >  > >  >  (switching to battery). Complete dmesg attached. This
> >  > >  > >  >  in particular is of kernel 2.6.24.3.
> >  > >  > >  >
> >  > >  > >  >  Greetings,
> >  > >  > >  >  Kind Regards,
> >  > >  > >  >  Sanjeev
> >  > >  > >  >
> >  > >  > >  >  BUG: unable to handle kernel NULL pointer dereference at virtual
> >  > >  > >  >  address 00000020
> >  > >  > >  >  printing eip: c04c4716 *pde = 578c2067
> >  > >  > >  >  Oops: 0000 [#1] SMP
> >  > >  > >  >  Modules linked in: cbc(U) geode_aes(U) blkcipher(U) aes_i586(U)
> >  > >  > >  >  aes_generic(U) dm_crypt(U) ipt_MASQUERADE(U) iptable_nat(U) nf_nat(U)
> >  > >  > >  >  bridge(U) autofs4(U) nf_conntrack_ipv4(U) xt_state(U) nf_conntrack(U)
> >  > >  > >  >  xt_tcpudp(U) ipt_REJECT(U) iptable_filter(U) ip_tables(U) x_tables(U)
> >  > >  > >  >  cpufreq_ondemand(U) acpi_cpufreq(U) fuse(U) loop(U) dm_mirror(U)
> >  > >  > >  >  dm_multipath(U) dm_mod(U) ipv6(U) snd_hda_intel(U) snd_seq_dummy(U)
> >  > >  > >  >  snd_seq_oss(U) snd_seq_midi_event(U) snd_seq(U) snd_seq_device(U)
> >  > >  > >  >  snd_pcm_oss(U) sr_mod(U) snd_mixer_oss(U) snd_pcm(U) 8139cp(U)
> >  > >  > >  >  snd_timer(U) button(U) 8139too(U) mii(U) snd_page_alloc(U) cdrom(U)
> >  > >  > >  >  video(U) output(U) snd_hwdep(U) ac(U) snd(U) pcspkr(U) i2c_piix4(U)
> >  > >  > >  >  i2c_core(U) battery(U) joydev(U) soundcore(U) sg(U) pata_atiixp(U)
> >  > >  > >  >  pata_acpi(U) sata_sil(U) ata_generic(U) libata(U) sd_mod(U)
> >  > >  > >  >  scsi_mod(U) ext3(U) jbd(U) mbcache(U) uhci_hcd(U) ohci_hcd(U)
> >  > >  > >  >  ehci_hcd(U)
> >  > >  > >  >
> >  > >  > >  >  Pid: 69, comm: kacpi_notify Not tainted (2.6.24.3 #5)
> >  > >  > >  >  EIP: 0060:[<c04c4716>] EFLAGS: 00010246 CPU: 0
> >  > >  > >  >  EIP is at sysfs_addrm_start+0x21/0x81
> >  > >  > >  >  EAX: c04c47d7 EBX: 00000000 ECX: 00000000 EDX: f78b8000
> >  > >  > >  >  ESI: f78b8eb8 EDI: f78b8ec8 EBP: 00000000 ESP: f78b8ea4
> >  > >  > >  >   DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> >  > >  > >  >  Process kacpi_notify (pid: 69, ti=f78b8000 task=f78d8000 task.ti=f78b8000)
> >  > >  > >  >  Stack: f229ff54 f229ff54 f5b8d390 fffffff4 c04c4b45 00000000 00000000 00000000
> >  > >  > >  >        00000000 f229ff54 00000000 00000000 f782601c c04c4bab f78b8ee0 c04fe65d
> >  > >  > >  >        f229ff54 c04fe8a8 f722e67f ffffffff ffffffff 00000007 f722e678 f78261d8
> >  > >  > >  >  Call Trace:
> >  > >  > >  >   [<c04c4b45>] create_dir+0x33/0x6c
> >  > >  > >  >   [<c04c4bab>] sysfs_create_dir+0x2d/0x40
> >  > >  > >  >   [<c04fe65d>] kobject_get+0xf/0x13
> >  > >  > >  >   [<c04fe8a8>] kobject_add+0xdd/0x176
> >  > >  > >  >   [<c04fe9eb>] kobject_register+0x19/0x2d
> >  > >  > >  >   [<c05b0ad0>] cpuidle_add_state_sysfs+0x7b/0xe4
> >  > >  > >  >   [<c052660e>] acpi_os_execute_notify+0x0/0x2b
> >  > >  > >  >   [<c05b03fd>] cpuidle_enable_device+0x31/0x9b
> >  > >  > >  >   [<c0545923>] acpi_processor_cst_has_changed+0x40/0x55
> >  > >  > >  >   [<c0543ae2>] acpi_processor_notify+0x8b/0xf4
> >  > >  > >  >   [<c052bcbb>] acpi_ev_notify_dispatch+0x4c/0x55
> >  > >  > >  >   [<c0526630>] acpi_os_execute_notify+0x22/0x2b
> >  > >  > >  >   [<c052660e>] acpi_os_execute_notify+0x0/0x2b
> >  > >  > >  >   [<c043c212>] run_workqueue+0x7d/0x107
> >  > >  > >  >   [<c043fa5b>] prepare_to_wait+0x28/0x45
> >  > >  > >  >   [<c043c35a>] worker_thread+0xbe/0xca
> >  > >  > >  >   [<c043f8ff>] autoremove_wake_function+0x0/0x35
> >  > >  > >  >   [<c043c29c>] worker_thread+0x0/0xca
> >  > >  > >  >   [<c043f679>] kthread+0x38/0x5d
> >  > >  > >  >   [<c043f641>] kthread+0x0/0x5d
> >  > >  > >  >   [<c0406477>] kernel_thread_helper+0x7/0x10
> >  > >  > >  >   =======================
> >  > >  > >  >  Code: c0 89 31 83 c4 14 5b 5e 5f c3 57 b9 04 00 00 00 56 89 c7 53 89
> >  > >  > >  >  c6 83 ec 04 89 d3 31 c0 f3 ab b8 903f 72 c0 89 16 e8 6a cf 16 00 <8b>
> >  > >  > >  >  53 20 b9 ec 42 4c c0 a1 84 e4 83 c0 89 1c 24 e8 44 6e fd ff
> >  > >  > >  >  EIP: [<c04c4716>] sysfs_addrm_start+0x21/0x81 SS:ESP 0068:f78b8ea4
> >  > >  > >
> >  > >  > >  Looks like a cpuidle problem (or at least acpi).
> >  > >  > >
> >  > >  > >  I seem to recall having seen other reports of this?
> >  > >  Then it might be something else...
> >  > >
> >  > >    Thomas
> >  > >
> >  > >
> >
> >

