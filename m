Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYHOVU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYHOVU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 17:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYHOVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 17:20:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52369 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbYHOVUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 17:20:39 -0400
Date: Fri, 15 Aug 2008 23:20:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Prarit Bhargava <prarit@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jbarnes@virtuousgeek.org,
       joro@8bytes.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
Message-ID: <20080815212010.GA9187@elte.hu>
References: <4899B611.4070408@redhat.com> <200808071003.47326.jbarnes@virtuousgeek.org> <489B33D4.1080107@redhat.com> <20080809125116H.fujita.tomonori@lab.ntt.co.jp> <20080815161629.GL27955@elte.hu> <20080815180048.GA26844@elte.hu> <48A5E986.2040201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A5E986.2040201@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Prarit Bhargava <prarit@redhat.com> wrote:

>> on an AMD X2 testsystem. (Asus board) Can send more info on request.  
>> Config is:
>>
>>   http://redhat.com/~mingo/misc/config-Fri_Aug_15_18_30_56_CEST_2008.bad
>>
>> Any idea why that is so? Apparently the alignment change wasnt as 
>> benign as assumed.
>
> Ingo, can you please send me details on the system?  I'll try to track 
> it down.

below is a bootlog and lspci output. There's nothing special about it - 
run of the mill whitebox PC, ASUS A8N-E, Athlon64 X2 3800+, 1GB RAM.

	Ingo

--------------->
Initializing cgroup subsys cpuset
Linux version 2.6.27-rc3-tip (mingo@dione) (gcc version 4.2.3) #24581 SMP Fri Aug 15 23:11:30 CEST 2008
Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200,keep debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 highres=0 nmi_watchdog=0 nolapic_timer idle=mwait idle=poll highmem=512m nopat notsc pci=nomsi
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
console [earlyser0] enabled
debug: ignoring loglevel setting.
using polling idle threads.
PAT support disabled.
last_pfn = 0x3fff0 max_arch_pfn = 0x3ffffffff
init_memory_mapping
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003fff0000 page 4k
kernel direct mapping tables up to 3fff0000 @ 8000-b000
last_map_addr: 3fff0000 end: 3fff0000
DMI 2.3 present.
(5 early reservations) ==> bootmem [0000000000 - 003fff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 000107959c]    TEXT DATA BSS ==> [0000200000 - 000107959c]
  #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #4 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
found SMP MP-table at [ffff8800000f5680] 000f5680
 [ffffe20000000000-ffffe20000ffffff] PMD -> [ffff880001200000-ffff8800021fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003fff0
On node 0 totalpages: 262031
  DMA zone: 3833 pages, LIFO batch:0
  DMA32 zone: 254000 pages, LIFO batch:31
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: OEM00000
MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
Bus #0 is PCI   
Bus #1 is PCI   
Bus #2 is PCI   
Bus #3 is PCI   
Bus #4 is PCI   
Bus #5 is PCI   
Bus #6 is ISA   
I/O APIC #2 Version 17 at 0xFEC00000.
Int: type 0, pol 3, trig 3, bus 00, IRQ 28, APIC ID 2, APIC INT 0b
Int: type 0, pol 3, trig 3, bus 00, IRQ 10, APIC ID 2, APIC INT 03
Int: type 0, pol 3, trig 3, bus 01, IRQ 00, APIC ID 2, APIC INT 05
Int: type 0, pol 3, trig 3, bus 05, IRQ 1c, APIC ID 2, APIC INT 0b
Int: type 3, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 00
Int: type 0, pol 0, trig 0, bus 06, IRQ 01, APIC ID 2, APIC INT 01
Int: type 0, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 02
Int: type 0, pol 0, trig 0, bus 06, IRQ 04, APIC ID 2, APIC INT 04
Int: type 0, pol 0, trig 0, bus 06, IRQ 06, APIC ID 2, APIC INT 06
Int: type 0, pol 0, trig 0, bus 06, IRQ 07, APIC ID 2, APIC INT 07
Int: type 0, pol 1, trig 1, bus 06, IRQ 08, APIC ID 2, APIC INT 08
Int: type 0, pol 0, trig 0, bus 06, IRQ 09, APIC ID 2, APIC INT 09
Int: type 0, pol 0, trig 0, bus 06, IRQ 0a, APIC ID 2, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 06, IRQ 0c, APIC ID 2, APIC INT 0c
Int: type 0, pol 0, trig 0, bus 06, IRQ 0d, APIC ID 2, APIC INT 0d
Int: type 0, pol 0, trig 0, bus 06, IRQ 0e, APIC ID 2, APIC INT 0e
Int: type 0, pol 0, trig 0, bus 06, IRQ 0f, APIC ID 2, APIC INT 0f
Lint: type 3, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 00
Lint: type 1, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 01
Processors: 2
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffffffff5fc000 (        fee00000)
mapped IOAPIC to ffffffffff5fb000 (00000000fec00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
dyn_array irq_2_pin_head+0x0/0x8 size:0x10 nr:256 align:0x1000
dyn_array irq_cfgx+0x0/0x8 size:0x420 nr:32 align:0x1000
dyn_array irq_descX+0x0/0x8 size:0x500 nr:32 align:0x1000
dyn_array total_size: 0x14000
dyn_array irq_2_pin_head+0x0/0x8  ==> [0x1084000 - 0x1085000]
dyn_array irq_cfgx+0x0/0x8  ==> [0x1085000 - 0x108d400]
dyn_array irq_descX+0x0/0x8  ==> [0x108e000 - 0x1098000]
kstat_irqs ==> [0x1098000 - 0x1098100]
PERCPU: Allocating 69632 bytes of per cpu data
NR_CPUS: 4096, nr_cpu_ids: 2, nr_node_ids 512
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257833
Kernel command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200,keep debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 highres=0 nmi_watchdog=0 nolapic_timer idle=mwait idle=poll highmem=512m nopat notsc pci=nomsi
debug: sysrq always enabled.
notsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely.
Initializing CPU#0
found new irq_desc for irq 0
found new irq_desc for irq 1
found new irq_desc for irq 2
found new irq_desc for irq 3
found new irq_desc for irq 4
found new irq_desc for irq 5
found new irq_desc for irq 6
found new irq_desc for irq 7
found new irq_desc for irq 8
found new irq_desc for irq 9
found new irq_desc for irq 10
found new irq_desc for irq 11
found new irq_desc for irq 12
found new irq_desc for irq 13
found new irq_desc for irq 14
found new irq_desc for irq 15
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PIT
Detected 2010.337 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Memory: 1014380k/1048512k available (5275k kernel code, 33136k reserved, 5387k data, 1128k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=512
Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.67 BogoMIPS (lpj=8041348)
Security Framework initialized
Mount-cache hash table entries: 256
Initializing cgroup subsys debug
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 22239 hash entries in 175 pages
Setting APIC routing to flat
enabled ExtINT on CPU#0
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0 not connected.
 0 add_pin_to_irq: irq 1 --> apic 0 pin 1
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
 0 add_pin_to_irq: irq 0 --> apic 0 pin 2
IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
 0 add_pin_to_irq: irq 3 --> apic 0 pin 3
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
 0 add_pin_to_irq: irq 4 --> apic 0 pin 4
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
 0 add_pin_to_irq: irq 5 --> apic 0 pin 5
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
 0 add_pin_to_irq: irq 6 --> apic 0 pin 6
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
 0 add_pin_to_irq: irq 7 --> apic 0 pin 7
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
 0 add_pin_to_irq: irq 8 --> apic 0 pin 8
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
 0 add_pin_to_irq: irq 9 --> apic 0 pin 9
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
 0 add_pin_to_irq: irq 10 --> apic 0 pin 10
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
 0 add_pin_to_irq: irq 11 --> apic 0 pin 11
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
 0 add_pin_to_irq: irq 12 --> apic 0 pin 12
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
 0 add_pin_to_irq: irq 13 --> apic 0 pin 13
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
 0 add_pin_to_irq: irq 14 --> apic 0 pin 14
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
 0 add_pin_to_irq: irq 15 --> apic 0 pin 15
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... works.
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Disabling APIC timer
calling  migration_init+0x0/0x4f
initcall migration_init+0x0/0x4f returned 1 after 0 msecs
initcall migration_init+0x0/0x4f returned with error code 1 
calling  spawn_ksoftirqd+0x0/0x4d
initcall spawn_ksoftirqd+0x0/0x4d returned 0 after 0 msecs
calling  init_call_single_data+0x0/0x5a
initcall init_call_single_data+0x0/0x5a returned 0 after 0 msecs
calling  relay_init+0x0/0x14
initcall relay_init+0x0/0x14 returned 0 after 0 msecs
Booting processor 1/1 ip 6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay loop... 2007.04 BogoMIPS (lpj=4014080)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Brought up 2 CPUs
Total of 2 processors activated (6027.71 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
PM: Adding info for No Bus:platform
calling  init_cpufreq_transition_notifier_list+0x0/0x1b
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 msecs
calling  net_ns_init+0x0/0x13e
net_namespace: 1392 bytes
initcall net_ns_init+0x0/0x13e returned 0 after 3 msecs
calling  cpufreq_tsc+0x0/0x16
initcall cpufreq_tsc+0x0/0x16 returned 0 after 0 msecs
calling  init_smp_flush+0x0/0x53
initcall init_smp_flush+0x0/0x53 returned 0 after 0 msecs
calling  print_banner+0x0/0xe
Booting paravirtualized kernel on bare hardware
initcall print_banner+0x0/0xe returned 0 after 3 msecs
calling  ksysfs_init+0x0/0xbb
initcall ksysfs_init+0x0/0xbb returned 0 after 0 msecs
calling  init_jiffies_clocksource+0x0/0x12
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 msecs
calling  pm_init+0x0/0x34
initcall pm_init+0x0/0x34 returned 0 after 0 msecs
calling  pm_disk_init+0x0/0x19
initcall pm_disk_init+0x0/0x19 returned 0 after 0 msecs
calling  swsusp_header_init+0x0/0x31
initcall swsusp_header_init+0x0/0x31 returned 0 after 0 msecs
calling  filelock_init+0x0/0x2e
initcall filelock_init+0x0/0x2e returned 0 after 0 msecs
calling  init_script_binfmt+0x0/0x12
initcall init_script_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  init_elf_binfmt+0x0/0x12
initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  init_compat_elf_binfmt+0x0/0x12
initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  debugfs_init+0x0/0x51
initcall debugfs_init+0x0/0x51 returned 0 after 0 msecs
calling  securityfs_init+0x0/0x51
initcall securityfs_init+0x0/0x51 returned 0 after 0 msecs
calling  random32_init+0x0/0xca
initcall random32_init+0x0/0xca returned 0 after 0 msecs
calling  early_resume_init+0x0/0x1a6
Time: 21:11:41  Date: 08/15/08
initcall early_resume_init+0x0/0x1a6 returned 0 after 0 msecs
calling  cpufreq_core_init+0x0/0x89
initcall cpufreq_core_init+0x0/0x89 returned 0 after 0 msecs
calling  cpuidle_init+0x0/0x40
initcall cpuidle_init+0x0/0x40 returned 0 after 0 msecs
calling  virtio_init+0x0/0x2b
initcall virtio_init+0x0/0x2b returned 0 after 0 msecs
calling  sock_init+0x0/0x5e
initcall sock_init+0x0/0x5e returned 0 after 0 msecs
calling  netpoll_init+0x0/0x31
initcall netpoll_init+0x0/0x31 returned 0 after 0 msecs
calling  netlink_proto_init+0x0/0x14d
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x14d returned 0 after 3 msecs
calling  bdi_class_init+0x0/0x41
initcall bdi_class_init+0x0/0x41 returned 0 after 0 msecs
calling  kobject_uevent_init+0x0/0x45
initcall kobject_uevent_init+0x0/0x45 returned 0 after 0 msecs
calling  pcibus_class_init+0x0/0x19
initcall pcibus_class_init+0x0/0x19 returned 0 after 0 msecs
calling  pci_driver_init+0x0/0x12
initcall pci_driver_init+0x0/0x12 returned 0 after 0 msecs
calling  lcd_class_init+0x0/0x4d
initcall lcd_class_init+0x0/0x4d returned 0 after 0 msecs
calling  tty_class_init+0x0/0x31
initcall tty_class_init+0x0/0x31 returned 0 after 0 msecs
calling  vtconsole_class_init+0x0/0xc3
PM: Adding info for No Bus:vtcon0
initcall vtconsole_class_init+0x0/0xc3 returned 0 after 3 msecs
calling  enable_pci_io_ecs+0x0/0x2e
initcall enable_pci_io_ecs+0x0/0x2e returned 0 after 0 msecs
calling  early_fill_mp_bus_info+0x0/0x7c2
node 0 link 0: io port [1000, fffff]
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [feb00000, fec0ffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [40000000, fed3ffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [40000000, fcffffffff]
bus: 00 index 2 mmio: [feb00000, fec0ffff]
bus: 00 index 3 mmio: [a0000, bffff]
initcall early_fill_mp_bus_info+0x0/0x7c2 returned 0 after 34 msecs
calling  arch_kdebugfs_init+0x0/0x24
initcall arch_kdebugfs_init+0x0/0x24 returned 0 after 0 msecs
calling  mtrr_if_init+0x0/0x77
initcall mtrr_if_init+0x0/0x77 returned 0 after 0 msecs
calling  dmi_id_init+0x0/0x2f0
PM: Adding info for No Bus:id
initcall dmi_id_init+0x0/0x2f0 returned 0 after 0 msecs
calling  pci_arch_init+0x0/0x40
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x40 returned 0 after 3 msecs
calling  topology_init+0x0/0x33
initcall topology_init+0x0/0x33 returned 0 after 0 msecs
calling  mtrr_init_finialize+0x0/0x3d
initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 msecs
calling  param_sysfs_init+0x0/0x1d6
initcall param_sysfs_init+0x0/0x1d6 returned 0 after 15 msecs
calling  pm_sysrq_init+0x0/0x1e
initcall pm_sysrq_init+0x0/0x1e returned 0 after 3 msecs
calling  readahead_init+0x0/0x38
PM: Adding info for No Bus:default
initcall readahead_init+0x0/0x38 returned 0 after 0 msecs
calling  init_bio+0x0/0xc5
initcall init_bio+0x0/0xc5 returned 0 after 0 msecs
calling  blk_settings_init+0x0/0x2a
initcall blk_settings_init+0x0/0x2a returned 0 after 0 msecs
calling  blk_ioc_init+0x0/0x2a
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 msecs
calling  genhd_device_init+0x0/0x55
initcall genhd_device_init+0x0/0x55 returned 0 after 0 msecs
calling  gpiolib_debugfs_init+0x0/0x24
initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 msecs
calling  pci_slot_init+0x0/0x4a
initcall pci_slot_init+0x0/0x4a returned 0 after 0 msecs
calling  misc_init+0x0/0x9f
initcall misc_init+0x0/0x9f returned 0 after 0 msecs
calling  tifm_init+0x0/0x7e
initcall tifm_init+0x0/0x7e returned 0 after 0 msecs
calling  phy_init+0x0/0x31
initcall phy_init+0x0/0x31 returned 0 after 0 msecs
calling  init_scsi+0x0/0x81
SCSI subsystem initialized
initcall init_scsi+0x0/0x81 returned 0 after 3 msecs
calling  ata_init+0x0/0x336
libata version 3.00 loaded.
initcall ata_init+0x0/0x336 returned 0 after 3 msecs
calling  spi_init+0x0/0x83
initcall spi_init+0x0/0x83 returned 0 after 0 msecs
calling  usb_init+0x0/0x10f
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x10f returned 0 after 11 msecs
calling  serio_init+0x0/0x99
initcall serio_init+0x0/0x99 returned 0 after 0 msecs
calling  gameport_init+0x0/0x98
initcall gameport_init+0x0/0x98 returned 0 after 0 msecs
calling  input_init+0x0/0x10e
initcall input_init+0x0/0x10e returned 0 after 0 msecs
calling  i2c_init+0x0/0x66
i2c-core: driver [dummy] registered
initcall i2c_init+0x0/0x66 returned 0 after 3 msecs
calling  leds_init+0x0/0x31
initcall leds_init+0x0/0x31 returned 0 after 0 msecs
calling  pci_subsys_init+0x0/0x116
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PM: Adding info for No Bus:pci0000:00
PM: Adding info for No Bus:0000:00
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: supports D1
pci 0000:00:02.0: supports D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: supports D1
pci 0000:00:02.1: supports D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:04.0: supports D1
pci 0000:00:04.0: supports D2
pci 0000:00:0a.0: supports D1
pci 0000:00:0a.0: supports D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:05:07.0: supports D1
pci 0000:05:07.0: supports D2
pci 0000:05:07.0: PME# supported from D1 D2 D3hot
pci 0000:05:07.0: PME# disabled
pci 0000:00:09.0: transparent bridge
PCI: bridge 0000:00:09.0 io port: [c000, cfff]
PCI: bridge 0000:00:09.0 32bit mmio: [da000000, da0fffff]
pci 0000:01:00.0: supports D1
pci 0000:01:00.0: supports D2
pci 0000:01:00.1: supports D1
pci 0000:01:00.1: supports D2
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:0e.0. It can be enabled forcedly with 'pcie_aspm=force'
PCI: bridge 0000:00:0e.0 io port: [b000, bfff]
PCI: bridge 0000:00:0e.0 32bit mmio: [d8000000, d9ffffff]
PCI: bridge 0000:00:0e.0 64bit mmio pref: [d0000000, d7ffffff]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:01.1
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:02.1
PM: Adding info for pci:0000:00:04.0
PM: Adding info for pci:0000:00:06.0
PM: Adding info for pci:0000:00:09.0
PM: Adding info for pci:0000:00:0a.0
PM: Adding info for pci:0000:00:0b.0
PM: Adding info for pci:0000:00:0c.0
PM: Adding info for pci:0000:00:0d.0
PM: Adding info for pci:0000:00:0e.0
PM: Adding info for pci:0000:00:18.0
PM: Adding info for pci:0000:00:18.1
PM: Adding info for pci:0000:00:18.2
PM: Adding info for pci:0000:00:18.3
PM: Adding info for pci:0000:05:07.0
PM: Adding info for No Bus:0000:05
PM: Adding info for No Bus:0000:04
PM: Adding info for No Bus:0000:03
PM: Adding info for No Bus:0000:02
PM: Adding info for pci:0000:01:00.0
PM: Adding info for pci:0000:01:00.1
PM: Adding info for No Bus:0000:01
pci 0000:00:00.0: default IRQ router [10de/005e]
pci 0000:00:04.0: PCI->APIC IRQ transform: INT A -> IRQ 3
pci 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 11
pci 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 11
pci 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 5
initcall pci_subsys_init+0x0/0x116 returned 0 after 221 msecs
calling  proto_init+0x0/0x2e
initcall proto_init+0x0/0x2e returned 0 after 0 msecs
calling  net_dev_init+0x0/0x148
initcall net_dev_init+0x0/0x148 returned 0 after 0 msecs
calling  neigh_init+0x0/0x71
initcall neigh_init+0x0/0x71 returned 0 after 0 msecs
calling  fib_rules_init+0x0/0xa6
initcall fib_rules_init+0x0/0xa6 returned 0 after 0 msecs
calling  pktsched_init+0x0/0xc4
initcall pktsched_init+0x0/0xc4 returned 0 after 0 msecs
calling  tc_filter_init+0x0/0x4c
initcall tc_filter_init+0x0/0x4c returned 0 after 0 msecs
calling  tc_action_init+0x0/0x4c
initcall tc_action_init+0x0/0x4c returned 0 after 0 msecs
calling  genl_init+0x0/0xd8
initcall genl_init+0x0/0xd8 returned 0 after 15 msecs
calling  cipso_v4_init+0x0/0x64
initcall cipso_v4_init+0x0/0x64 returned 0 after 0 msecs
calling  wanrouter_init+0x0/0x55
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
initcall wanrouter_init+0x0/0x55 returned 0 after 3 msecs
calling  wireless_nlevent_init+0x0/0x31
initcall wireless_nlevent_init+0x0/0x31 returned 0 after 0 msecs
calling  netlbl_init+0x0/0x83
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0x83 returned 0 after 11 msecs
calling  pci_iommu_init+0x0/0xd
initcall pci_iommu_init+0x0/0xd returned 0 after 0 msecs
calling  print_all_ICs+0x0/0x441

printing PIC contents
... PIC  IMR: fffa
... PIC  IRR: 0001
... PIC  ISR: 0001
... PIC ELCR: 0828

printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 00040010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC EOI: 00000000
... APIC RRR: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000
... APIC ESR: 00000000
... APIC ICR: 000008ef
... APIC ICR2: 02000000
... APIC LVTT: 00010000
... APIC LVTPC: 00010000
... APIC LVT0: 00010700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 00000000
... APIC TMCCT: 00000000
... APIC TDCR: 00000000


printing local APIC contents on CPU#1/1:
... APIC ID:      01000000 (1)
... APIC VERSION: 00040010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 00000030 (30)
... APIC PROCPRI: 00000000
... APIC EOI: 00000000
... APIC RRR: 00000000
... APIC LDR: 02000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000001000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC ESR: 00000000
... APIC ICR: 000008ef
... APIC ICR2: 01000000
... APIC LVTT: 00010000
... APIC LVTPC: 00010000
... APIC LVT0: 00010700
... APIC LVT1: 00010400
... APIC LVTERR: 000000fe
... APIC TMICT: 00000000
... APIC TMCCT: 00000000
... APIC TDCR: 00000000

number of MP IRQ sources: 17.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 003 0    0    0   0   0    1    1    30
 01 003 0    0    0   0   0    1    1    31
 02 000 1    0    0   0   0    0    0    00
 03 003 1    1    0   1   0    1    1    33
 04 003 0    0    0   0   0    1    1    34
 05 003 1    1    0   1   0    1    1    35
 06 003 0    0    0   0   0    1    1    36
 07 003 1    0    0   0   0    1    1    37
 08 003 0    0    0   0   0    1    1    38
 09 003 0    0    0   0   0    1    1    39
 0a 003 0    0    0   0   0    1    1    3A
 0b 003 1    1    0   1   0    1    1    3B
 0c 003 0    0    0   0   0    1    1    3C
 0d 003 0    0    0   0   0    1    1    3D
 0e 003 0    0    0   0   0    1    1    3E
 0f 003 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
initcall print_all_ICs+0x0/0x441 returned 0 after 175 msecs
calling  hpet_late_init+0x0/0x4d
initcall hpet_late_init+0x0/0x4d returned -19 after 0 msecs
calling  clocksource_done_booting+0x0/0x12
initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 msecs
calling  ftrace_init_debugfs+0x0/0xfd
initcall ftrace_init_debugfs+0x0/0xfd returned 0 after 0 msecs
calling  tracer_alloc_buffers+0x0/0x608
tracer: 357 pages allocated for 16384 entries of 88 bytes
   actual entries 16422
initcall tracer_alloc_buffers+0x0/0x608 returned 0 after 7 msecs
calling  init_pipe_fs+0x0/0x4c
initcall init_pipe_fs+0x0/0x4c returned 0 after 0 msecs
calling  init_mnt_writers+0x0/0x55
initcall init_mnt_writers+0x0/0x55 returned 0 after 0 msecs
calling  anon_inode_init+0x0/0x115
initcall anon_inode_init+0x0/0x115 returned 0 after 0 msecs
calling  pcie_aspm_init+0x0/0x8
initcall pcie_aspm_init+0x0/0x8 returned 0 after 0 msecs
calling  chr_dev_init+0x0/0xb4
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PM: Adding info for No Bus:oldmem
initcall chr_dev_init+0x0/0xb4 returned 0 after 26 msecs
calling  firmware_class_init+0x0/0x79
initcall firmware_class_init+0x0/0x79 returned 0 after 0 msecs
calling  loopback_init+0x0/0x12
PM: Adding info for No Bus:lo
initcall loopback_init+0x0/0x12 returned 0 after 0 msecs
calling  cpufreq_gov_performance_init+0x0/0x12
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 msecs
calling  ssb_modinit+0x0/0x4a
initcall ssb_modinit+0x0/0x4a returned 0 after 0 msecs
calling  pcibios_assign_resources+0x0/0x88
pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
pci 0000:00:09.0:   IO window: 0xc000-0xcfff
pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
pci 0000:00:09.0:   PREFETCH window: disabled
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: disabled
pci 0000:00:0b.0:   PREFETCH window: disabled
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0c.0:   IO window: disabled
pci 0000:00:0c.0:   MEM window: disabled
pci 0000:00:0c.0:   PREFETCH window: disabled
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0d.0:   IO window: disabled
pci 0000:00:0d.0:   MEM window: disabled
pci 0000:00:0d.0:   PREFETCH window: disabled
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 05 index 0 io port: [c000, cfff]
bus: 05 index 1 mmio: [da000000, da0fffff]
bus: 05 index 2 mmio: [0, 0]
bus: 05 index 3 io port: [0, ffff]
bus: 05 index 4 mmio: [0, ffffffffffffffff]
bus: 04 index 0 mmio: [0, 0]
bus: 04 index 1 mmio: [0, 0]
bus: 04 index 2 mmio: [0, 0]
bus: 04 index 3 mmio: [0, 0]
bus: 03 index 0 mmio: [0, 0]
bus: 03 index 1 mmio: [0, 0]
bus: 03 index 2 mmio: [0, 0]
bus: 03 index 3 mmio: [0, 0]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [0, 0]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 01 index 0 io port: [b000, bfff]
bus: 01 index 1 mmio: [d8000000, d9ffffff]
bus: 01 index 2 mmio: [d0000000, d7ffffff]
bus: 01 index 3 mmio: [0, 0]
initcall pcibios_assign_resources+0x0/0x88 returned 0 after 148 msecs
calling  inet_init+0x0/0x1fb
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x1fb returned 0 after 72 msecs
calling  af_unix_init+0x0/0x55
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after 3 msecs
calling  populate_rootfs+0x0/0x201
initcall populate_rootfs+0x0/0x201 returned 0 after 0 msecs
calling  pci_init+0x0/0x3a
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Enabling HT MSI Mapping
pci 0000:00:0c.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Enabling HT MSI Mapping
pci 0000:00:0d.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Found enabled HT MSI Mapping
pci 0000:01:00.0: Boot video device
initcall pci_init+0x0/0x3a returned 0 after 53 msecs
calling  i8259A_init_sysfs+0x0/0x22
calling  ehci_hcd_init+0x0/0x1b
ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
initcall ehci_hcd_init+0x0/0x1b returned 0 after 15 msecs
calling  ohci_hcd_mod_init+0x0/0x6b
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 41 msecs
calling  vsyscall_init+0x0/0x27
initcall vsyscall_init+0x0/0x27 returned 0 after 0 msecs
calling  sbf_init+0x0/0xd5
initcall sbf_init+0x0/0xd5 returned 0 after 0 msecs
calling  i8237A_init_sysfs+0x0/0x22
initcall ohci_hcd_mod_init+0x0/0x6b returned 0 after 38 msecs
calling  uhci_hcd_init+0x0/0xac
USB Universal Host Controller Interface driver v3.0
initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 11 msecs
calling  add_rtc_cmos+0x0/0x14
PM: Adding info for platform:rtc_cmos
initcall uhci_hcd_init+0x0/0xac returned 0 after 15 msecs
initcall add_rtc_cmos+0x0/0x14 returned 0 after 7 msecs
calling  cache_sysfs_init+0x0/0x5c
initcall cache_sysfs_init+0x0/0x5c returned 0 after 0 msecs
calling  mce_init_device+0x0/0x78
PM: Adding info for No Bus:mcelog
initcall mce_init_device+0x0/0x78 returned 0 after 3 msecs
calling  periodic_mcheck_init+0x0/0x3f
initcall periodic_mcheck_init+0x0/0x3f returned 0 after 0 msecs
calling  thermal_throttle_init_device+0x0/0x68
initcall thermal_throttle_init_device+0x0/0x68 returned 0 after 0 msecs
calling  threshold_init_device+0x0/0x43
initcall threshold_init_device+0x0/0x43 returned 0 after 0 msecs
calling  msr_init+0x0/0xed
PM: Adding info for No Bus:msr0
PM: Adding info for No Bus:msr1
initcall msr_init+0x0/0xed returned 0 after 7 msecs
calling  cpuid_init+0x0/0xed
PM: Adding info for No Bus:cpu0
PM: Adding info for No Bus:cpu1
initcall cpuid_init+0x0/0xed returned 0 after 3 msecs
calling  init_lapic_sysfs+0x0/0x2d
initcall init_lapic_sysfs+0x0/0x2d returned 0 after 0 msecs
calling  ioapic_init_sysfs+0x0/0x99
initcall ioapic_init_sysfs+0x0/0x99 returned 0 after 0 msecs
calling  add_pcspkr+0x0/0x43
PM: Adding info for platform:pcspkr
initcall add_pcspkr+0x0/0x43 returned 0 after 3 msecs
calling  uv_ptc_init+0x0/0x75
initcall uv_ptc_init+0x0/0x75 returned 0 after 0 msecs
calling  uv_bau_init+0x0/0x58d
initcall uv_bau_init+0x0/0x58d returned 0 after 0 msecs
calling  audit_classes_init+0x0/0xaf
initcall audit_classes_init+0x0/0xaf returned 0 after 0 msecs
calling  init+0x0/0x12
initcall init+0x0/0x12 returned 0 after 0 msecs
calling  init_vdso_vars+0x0/0x1f7
initcall init_vdso_vars+0x0/0x1f7 returned 0 after 0 msecs
calling  sysenter_setup+0x0/0x296
initcall sysenter_setup+0x0/0x296 returned 0 after 0 msecs
calling  init_sched_debug_procfs+0x0/0x2c
initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 0 msecs
calling  ioresources_init+0x0/0x3c
initcall ioresources_init+0x0/0x3c returned 0 after 0 msecs
calling  uid_cache_init+0x0/0x77
initcall uid_cache_init+0x0/0x77 returned 0 after 0 msecs
calling  init_posix_timers+0x0/0xb6
initcall init_posix_timers+0x0/0xb6 returned 0 after 0 msecs
calling  init_posix_cpu_timers+0x0/0xd4
initcall init_posix_cpu_timers+0x0/0xd4 returned 0 after 0 msecs
calling  nsproxy_cache_init+0x0/0x2d
initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 msecs
calling  create_proc_profile+0x0/0x241
initcall create_proc_profile+0x0/0x241 returned 0 after 0 msecs
calling  timekeeping_init_device+0x0/0x22
initcall timekeeping_init_device+0x0/0x22 returned 0 after 0 msecs
calling  init_clocksource_sysfs+0x0/0x50
initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 0 msecs
calling  init_timer_list_procfs+0x0/0x2c
initcall init_timer_list_procfs+0x0/0x2c returned 0 after 0 msecs
calling  futex_init+0x0/0x6f
initcall futex_init+0x0/0x6f returned 0 after 0 msecs
calling  proc_dma_init+0x0/0x22
initcall proc_dma_init+0x0/0x22 returned 0 after 0 msecs
calling  percpu_modinit+0x0/0x74
initcall percpu_modinit+0x0/0x74 returned 0 after 0 msecs
calling  kallsyms_init+0x0/0x25
initcall kallsyms_init+0x0/0x25 returned 0 after 0 msecs
calling  snapshot_device_init+0x0/0x12
PM: Adding info for No Bus:snapshot
initcall snapshot_device_init+0x0/0x12 returned 0 after 3 msecs
calling  audit_init+0x0/0x126
audit: initializing netlink socket (disabled)
type=2000 audit(1218834701.408:1): initialized
initcall audit_init+0x0/0x126 returned 0 after 7 msecs
calling  init_kprobes+0x0/0x143
initcall init_kprobes+0x0/0x143 returned 0 after 7 msecs
calling  init_lstats_procfs+0x0/0x25
initcall init_lstats_procfs+0x0/0x25 returned 0 after 0 msecs
calling  init_sched_switch_trace+0x0/0x41
Testing tracer sched_switch: PASSED
initcall init_sched_switch_trace+0x0/0x41 returned 0 after 141 msecs
calling  init_stack_trace+0x0/0x12
Testing tracer sysprof: PASSED
initcall init_stack_trace+0x0/0x12 returned 0 after 106 msecs
calling  init_function_trace+0x0/0x12
Testing tracer ftrace: PASSED
Testing dynamic ftrace: PASSED
initcall init_function_trace+0x0/0x12 returned 0 after 415 msecs
calling  init_wakeup_tracer+0x0/0x12
Testing tracer wakeup: .. no entries found ..FAILED!
initcall init_wakeup_tracer+0x0/0x12 returned -1 after 213 msecs
initcall init_wakeup_tracer+0x0/0x12 returned with error code -1 
calling  init_per_zone_pages_min+0x0/0x45
initcall init_per_zone_pages_min+0x0/0x45 returned 0 after 0 msecs
calling  pdflush_init+0x0/0x1d
initcall pdflush_init+0x0/0x1d returned 0 after 0 msecs
calling  kswapd_init+0x0/0x68
initcall kswapd_init+0x0/0x68 returned 0 after 0 msecs
calling  setup_vmstat+0x0/0x44
initcall setup_vmstat+0x0/0x44 returned 0 after 0 msecs
calling  mm_sysfs_init+0x0/0x29
initcall mm_sysfs_init+0x0/0x29 returned 0 after 0 msecs
calling  procswaps_init+0x0/0x22
initcall procswaps_init+0x0/0x22 returned 0 after 0 msecs
calling  init_tmpfs+0x0/0x29
initcall init_tmpfs+0x0/0x29 returned 0 after 0 msecs
calling  slab_sysfs_init+0x0/0xf0
initcall slab_sysfs_init+0x0/0xf0 returned 0 after 11 msecs
calling  fasync_init+0x0/0x2a
initcall fasync_init+0x0/0x2a returned 0 after 0 msecs
calling  aio_setup+0x0/0x6e
initcall aio_setup+0x0/0x6e returned 0 after 0 msecs
calling  inotify_setup+0x0/0x12
initcall inotify_setup+0x0/0x12 returned 0 after 0 msecs
calling  inotify_user_setup+0x0/0xb8
initcall inotify_user_setup+0x0/0xb8 returned 0 after 0 msecs
calling  init_sys32_ioctl+0x0/0x85
initcall init_sys32_ioctl+0x0/0x85 returned 0 after 0 msecs
calling  init_mbcache+0x0/0x14
initcall init_mbcache+0x0/0x14 returned 0 after 0 msecs
calling  vmcore_init+0x0/0x8b5
initcall vmcore_init+0x0/0x8b5 returned 0 after 0 msecs
calling  configfs_init+0x0/0xb3
initcall configfs_init+0x0/0xb3 returned 0 after 0 msecs
calling  init_devpts_fs+0x0/0x3f
initcall init_devpts_fs+0x0/0x3f returned 0 after 0 msecs
calling  init_ext3_fs+0x0/0x6a
initcall init_ext3_fs+0x0/0x6a returned 0 after 0 msecs
calling  journal_init+0x0/0x85
initcall journal_init+0x0/0x85 returned 0 after 0 msecs
calling  init_ext2_fs+0x0/0x5a
initcall init_ext2_fs+0x0/0x5a returned 0 after 0 msecs
calling  init_ramfs_fs+0x0/0x12
initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 msecs
calling  init_fat_fs+0x0/0x4f
initcall init_fat_fs+0x0/0x4f returned 0 after 0 msecs
calling  init_vfat_fs+0x0/0x12
initcall init_vfat_fs+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_cp855+0x0/0x12
initcall init_nls_cp855+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_cp860+0x0/0x12
initcall init_nls_cp860+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_cp861+0x0/0x12
initcall init_nls_cp861+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_cp862+0x0/0x12
initcall init_nls_cp862+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_cp866+0x0/0x12
initcall init_nls_cp866+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_cp869+0x0/0x12
initcall init_nls_cp869+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_cp1251+0x0/0x12
initcall init_nls_cp1251+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_ascii+0x0/0x12
initcall init_nls_ascii+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_iso8859_1+0x0/0x12
initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_iso8859_2+0x0/0x12
initcall init_nls_iso8859_2+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_iso8859_4+0x0/0x12
initcall init_nls_iso8859_4+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_iso8859_13+0x0/0x12
initcall init_nls_iso8859_13+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_iso8859_15+0x0/0x12
initcall init_nls_iso8859_15+0x0/0x12 returned 0 after 0 msecs
calling  init_smb_fs+0x0/0x6c
initcall init_smb_fs+0x0/0x6c returned 0 after 0 msecs
calling  init_ncp_fs+0x0/0x5a
initcall init_ncp_fs+0x0/0x5a returned 0 after 0 msecs
calling  init_efs_fs+0x0/0x68
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
initcall init_efs_fs+0x0/0x68 returned 0 after 3 msecs
calling  init_adfs_fs+0x0/0x5a
initcall init_adfs_fs+0x0/0x5a returned 0 after 0 msecs
calling  fuse_init+0x0/0x125
fuse init (API version 7.9)
PM: Adding info for No Bus:fuse
initcall fuse_init+0x0/0x125 returned 0 after 3 msecs
calling  init_befs_fs+0x0/0x7b
BeFS version: 0.9.3
initcall init_befs_fs+0x0/0x7b returned 0 after 3 msecs
calling  init_gfs2_fs+0x0/0x178
GFS2 (built Aug 15 2008 23:09:32) installed
initcall init_gfs2_fs+0x0/0x178 returned 0 after 3 msecs
calling  key_proc_init+0x0/0x33
initcall key_proc_init+0x0/0x33 returned 0 after 0 msecs
calling  crypto_algapi_init+0x0/0xd
initcall crypto_algapi_init+0x0/0xd returned 0 after 0 msecs
calling  blkcipher_module_init+0x0/0x2a
initcall blkcipher_module_init+0x0/0x2a returned 0 after 0 msecs
calling  seqiv_module_init+0x0/0x12
initcall seqiv_module_init+0x0/0x12 returned 0 after 0 msecs
calling  cryptomgr_init+0x0/0x12
initcall cryptomgr_init+0x0/0x12 returned 0 after 0 msecs
calling  hmac_module_init+0x0/0x12
initcall hmac_module_init+0x0/0x12 returned 0 after 0 msecs
calling  md5_mod_init+0x0/0x12
initcall md5_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  rmd128_mod_init+0x0/0x12
initcall rmd128_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  rmd160_mod_init+0x0/0x12
initcall rmd160_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  sha1_generic_mod_init+0x0/0x12
initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  wp512_mod_init+0x0/0x64
initcall wp512_mod_init+0x0/0x64 returned 0 after 0 msecs
calling  tgr192_mod_init+0x0/0x64
initcall tgr192_mod_init+0x0/0x64 returned 0 after 0 msecs
calling  crypto_cbc_module_init+0x0/0x12
initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 msecs
calling  crypto_ctr_module_init+0x0/0x3f
initcall crypto_ctr_module_init+0x0/0x3f returned 0 after 0 msecs
calling  des_generic_mod_init+0x0/0x3f
initcall des_generic_mod_init+0x0/0x3f returned 0 after 0 msecs
calling  fcrypt_mod_init+0x0/0x12
initcall fcrypt_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  serpent_mod_init+0x0/0x3f
initcall serpent_mod_init+0x0/0x3f returned 0 after 0 msecs
calling  camellia_init+0x0/0x12
initcall camellia_init+0x0/0x12 returned 0 after 0 msecs
calling  arc4_init+0x0/0x12
initcall arc4_init+0x0/0x12 returned 0 after 0 msecs
calling  tea_mod_init+0x0/0x64
initcall tea_mod_init+0x0/0x64 returned 0 after 0 msecs
calling  deflate_mod_init+0x0/0x12
initcall deflate_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  crc32c_mod_init+0x0/0x3f
initcall crc32c_mod_init+0x0/0x3f returned 0 after 0 msecs
calling  crypto_authenc_module_init+0x0/0x12
initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 msecs
calling  bsg_init+0x0/0x126
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
initcall bsg_init+0x0/0x126 returned 0 after 3 msecs
calling  noop_init+0x0/0x14
io scheduler noop registered
initcall noop_init+0x0/0x14 returned 0 after 3 msecs
calling  as_init+0x0/0x14
io scheduler anticipatory registered (default)
initcall as_init+0x0/0x14 returned 0 after 3 msecs
calling  init_kmp+0x0/0x12
initcall init_kmp+0x0/0x12 returned 0 after 0 msecs
calling  init_bm+0x0/0x12
initcall init_bm+0x0/0x12 returned 0 after 0 msecs
calling  init_fsm+0x0/0x12
initcall init_fsm+0x0/0x12 returned 0 after 0 msecs
calling  percpu_counter_startup+0x0/0x14
initcall percpu_counter_startup+0x0/0x14 returned 0 after 0 msecs
calling  max732x_init+0x0/0x14
i2c-core: driver [max732x] registered
initcall max732x_init+0x0/0x14 returned 0 after 3 msecs
calling  pci_proc_init+0x0/0x6a
initcall pci_proc_init+0x0/0x6a returned 0 after 0 msecs
calling  pcie_portdrv_init+0x0/0x4c
pcieport-driver 0000:00:0b.0: setting latency timer to 64
pcieport-driver 0000:00:0b.0: found MSI capability
pci_express 0000:00:0b.0:pcie00: allocate port service
PM: Adding info for pci_express:0000:00:0b.0:pcie00
pcieport-driver 0000:00:0c.0: setting latency timer to 64
pcieport-driver 0000:00:0c.0: found MSI capability
pci_express 0000:00:0c.0:pcie00: allocate port service
PM: Adding info for pci_express:0000:00:0c.0:pcie00
pcieport-driver 0000:00:0d.0: setting latency timer to 64
pcieport-driver 0000:00:0d.0: found MSI capability
pci_express 0000:00:0d.0:pcie00: allocate port service
PM: Adding info for pci_express:0000:00:0d.0:pcie00
pcieport-driver 0000:00:0e.0: setting latency timer to 64
pcieport-driver 0000:00:0e.0: found MSI capability
pci_express 0000:00:0e.0:pcie00: allocate port service
PM: Adding info for pci_express:0000:00:0e.0:pcie00
initcall pcie_portdrv_init+0x0/0x4c returned 0 after 61 msecs
calling  aer_service_init+0x0/0x20
initcall aer_service_init+0x0/0x20 returned 0 after 0 msecs
calling  vgg2432a4_init+0x0/0x12
initcall vgg2432a4_init+0x0/0x12 returned 0 after 0 msecs
calling  display_class_init+0x0/0x7e
initcall display_class_init+0x0/0x7e returned 0 after 0 msecs
calling  rand_initialize+0x0/0x31
initcall rand_initialize+0x0/0x31 returned 0 after 0 msecs
calling  tty_init+0x0/0x1cd
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
initcall tty_init+0x0/0x1cd returned 0 after 202 msecs
calling  pty_init+0x0/0x26f
initcall pty_init+0x0/0x26f returned 0 after 0 msecs
calling  isicom_init+0x0/0x19d
initcall isicom_init+0x0/0x19d returned 0 after 0 msecs
calling  synclink_init+0x0/0x258
SyncLink serial driver $Revision: 4.38 $
PM: Adding info for No Bus:ttySL0
PM: Adding info for No Bus:ttySL1
PM: Adding info for No Bus:ttySL2
PM: Adding info for No Bus:ttySL3
PM: Adding info for No Bus:ttySL4
PM: Adding info for No Bus:ttySL5
PM: Adding info for No Bus:ttySL6
PM: Adding info for No Bus:ttySL7
PM: Adding info for No Bus:ttySL8
PM: Adding info for No Bus:ttySL9
PM: Adding info for No Bus:ttySL10
PM: Adding info for No Bus:ttySL11
PM: Adding info for No Bus:ttySL12
PM: Adding info for No Bus:ttySL13
PM: Adding info for No Bus:ttySL14
PM: Adding info for No Bus:ttySL15
PM: Adding info for No Bus:ttySL16
PM: Adding info for No Bus:ttySL17
PM: Adding info for No Bus:ttySL18
PM: Adding info for No Bus:ttySL19
PM: Adding info for No Bus:ttySL20
PM: Adding info for No Bus:ttySL21
PM: Adding info for No Bus:ttySL22
PM: Adding info for No Bus:ttySL23
PM: Adding info for No Bus:ttySL24
PM: Adding info for No Bus:ttySL25
PM: Adding info for No Bus:ttySL26
PM: Adding info for No Bus:ttySL27
PM: Adding info for No Bus:ttySL28
PM: Adding info for No Bus:ttySL29
PM: Adding info for No Bus:ttySL30
PM: Adding info for No Bus:ttySL31
PM: Adding info for No Bus:ttySL32
PM: Adding info for No Bus:ttySL33
PM: Adding info for No Bus:ttySL34
PM: Adding info for No Bus:ttySL35
PM: Adding info for No Bus:ttySL36
PM: Adding info for No Bus:ttySL37
PM: Adding info for No Bus:ttySL38
PM: Adding info for No Bus:ttySL39
PM: Adding info for No Bus:ttySL40
PM: Adding info for No Bus:ttySL41
PM: Adding info for No Bus:ttySL42
PM: Adding info for No Bus:ttySL43
PM: Adding info for No Bus:ttySL44
PM: Adding info for No Bus:ttySL45
PM: Adding info for No Bus:ttySL46
PM: Adding info for No Bus:ttySL47
PM: Adding info for No Bus:ttySL48
PM: Adding info for No Bus:ttySL49
PM: Adding info for No Bus:ttySL50
PM: Adding info for No Bus:ttySL51
PM: Adding info for No Bus:ttySL52
PM: Adding info for No Bus:ttySL53
PM: Adding info for No Bus:ttySL54
PM: Adding info for No Bus:ttySL55
PM: Adding info for No Bus:ttySL56
PM: Adding info for No Bus:ttySL57
PM: Adding info for No Bus:ttySL58
PM: Adding info for No Bus:ttySL59
PM: Adding info for No Bus:ttySL60
PM: Adding info for No Bus:ttySL61
PM: Adding info for No Bus:ttySL62
PM: Adding info for No Bus:ttySL63
PM: Adding info for No Bus:ttySL64
PM: Adding info for No Bus:ttySL65
PM: Adding info for No Bus:ttySL66
PM: Adding info for No Bus:ttySL67
PM: Adding info for No Bus:ttySL68
PM: Adding info for No Bus:ttySL69
PM: Adding info for No Bus:ttySL70
PM: Adding info for No Bus:ttySL71
PM: Adding info for No Bus:ttySL72
PM: Adding info for No Bus:ttySL73
PM: Adding info for No Bus:ttySL74
PM: Adding info for No Bus:ttySL75
PM: Adding info for No Bus:ttySL76
PM: Adding info for No Bus:ttySL77
PM: Adding info for No Bus:ttySL78
PM: Adding info for No Bus:ttySL79
PM: Adding info for No Bus:ttySL80
PM: Adding info for No Bus:ttySL81
PM: Adding info for No Bus:ttySL82
PM: Adding info for No Bus:ttySL83
PM: Adding info for No Bus:ttySL84
PM: Adding info for No Bus:ttySL85
PM: Adding info for No Bus:ttySL86
PM: Adding info for No Bus:ttySL87
PM: Adding info for No Bus:ttySL88
PM: Adding info for No Bus:ttySL89
PM: Adding info for No Bus:ttySL90
PM: Adding info for No Bus:ttySL91
PM: Adding info for No Bus:ttySL92
PM: Adding info for No Bus:ttySL93
PM: Adding info for No Bus:ttySL94
PM: Adding info for No Bus:ttySL95
PM: Adding info for No Bus:ttySL96
PM: Adding info for No Bus:ttySL97
PM: Adding info for No Bus:ttySL98
PM: Adding info for No Bus:ttySL99
PM: Adding info for No Bus:ttySL100
PM: Adding info for No Bus:ttySL101
PM: Adding info for No Bus:ttySL102
PM: Adding info for No Bus:ttySL103
PM: Adding info for No Bus:ttySL104
PM: Adding info for No Bus:ttySL105
PM: Adding info for No Bus:ttySL106
PM: Adding info for No Bus:ttySL107
PM: Adding info for No Bus:ttySL108
PM: Adding info for No Bus:ttySL109
PM: Adding info for No Bus:ttySL110
PM: Adding info for No Bus:ttySL111
PM: Adding info for No Bus:ttySL112
PM: Adding info for No Bus:ttySL113
PM: Adding info for No Bus:ttySL114
PM: Adding info for No Bus:ttySL115
PM: Adding info for No Bus:ttySL116
PM: Adding info for No Bus:ttySL117
PM: Adding info for No Bus:ttySL118
PM: Adding info for No Bus:ttySL119
PM: Adding info for No Bus:ttySL120
PM: Adding info for No Bus:ttySL121
PM: Adding info for No Bus:ttySL122
PM: Adding info for No Bus:ttySL123
PM: Adding info for No Bus:ttySL124
PM: Adding info for No Bus:ttySL125
PM: Adding info for No Bus:ttySL126
PM: Adding info for No Bus:ttySL127
SyncLink serial driver $Revision: 4.38 $, tty major#253
initcall synclink_init+0x0/0x258 returned 0 after 396 msecs
calling  n_hdlc_init+0x0/0x94
HDLC line discipline: version $Revision: 4.8 $, maxframe=4096
N_HDLC line discipline registered.
initcall n_hdlc_init+0x0/0x94 returned 0 after 7 msecs
calling  raw_init+0x0/0xdd
PM: Adding info for No Bus:rawctl
initcall raw_init+0x0/0xdd returned 0 after 3 msecs
calling  r3964_init+0x0/0x44
r3964: Philips r3964 Driver $Revision: 1.10 $
initcall r3964_init+0x0/0x44 returned 0 after 3 msecs
calling  nvram_init+0x0/0x8a
PM: Adding info for No Bus:nvram
Non-volatile memory driver v1.2
initcall nvram_init+0x0/0x8a returned 0 after 3 msecs
calling  i8k_init+0x0/0x1ef
initcall i8k_init+0x0/0x1ef returned -19 after 0 msecs
calling  serial8250_init+0x0/0x118
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
PM: Adding info for platform:serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 0) is a 16550A
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
initcall serial8250_init+0x0/0x118 returned 0 after 267 msecs
calling  serial8250_pci_init+0x0/0x1b
initcall serial8250_pci_init+0x0/0x1b returned 0 after 0 msecs
calling  jsm_init_module+0x0/0x48
initcall jsm_init_module+0x0/0x48 returned 0 after 0 msecs
calling  topology_sysfs_init+0x0/0x48
initcall topology_sysfs_init+0x0/0x48 returned 0 after 0 msecs
calling  brd_init+0x0/0x19c
PM: Adding info for No Bus:ram0
PM: Adding info for No Bus:1:0
PM: Adding info for No Bus:ram1
PM: Adding info for No Bus:1:1
PM: Adding info for No Bus:ram2
PM: Adding info for No Bus:1:2
PM: Adding info for No Bus:ram3
PM: Adding info for No Bus:1:3
PM: Adding info for No Bus:ram4
PM: Adding info for No Bus:1:4
PM: Adding info for No Bus:ram5
PM: Adding info for No Bus:1:5
PM: Adding info for No Bus:ram6
PM: Adding info for No Bus:1:6
PM: Adding info for No Bus:ram7
PM: Adding info for No Bus:1:7
PM: Adding info for No Bus:ram8
PM: Adding info for No Bus:1:8
PM: Adding info for No Bus:ram9
PM: Adding info for No Bus:1:9
PM: Adding info for No Bus:ram10
PM: Adding info for No Bus:1:10
PM: Adding info for No Bus:ram11
PM: Adding info for No Bus:1:11
PM: Adding info for No Bus:ram12
PM: Adding info for No Bus:1:12
PM: Adding info for No Bus:ram13
PM: Adding info for No Bus:1:13
PM: Adding info for No Bus:ram14
PM: Adding info for No Bus:1:14
PM: Adding info for No Bus:ram15
PM: Adding info for No Bus:1:15
brd: module loaded
initcall brd_init+0x0/0x19c returned 0 after 91 msecs
calling  cpqarray_init+0x0/0x264
Compaq SMART2 Driver (v 2.6.0)
initcall cpqarray_init+0x0/0x264 returned 0 after 3 msecs
calling  mm_init+0x0/0x17b
MM: desc_per_page = 128
initcall mm_init+0x0/0x17b returned 0 after 0 msecs
calling  nbd_init+0x0/0x2d5
nbd: registered device at major 43
PM: Adding info for No Bus:nbd0
PM: Adding info for No Bus:43:0
PM: Adding info for No Bus:nbd1
PM: Adding info for No Bus:43:1
PM: Adding info for No Bus:nbd2
PM: Adding info for No Bus:43:2
PM: Adding info for No Bus:nbd3
PM: Adding info for No Bus:43:3
PM: Adding info for No Bus:nbd4
PM: Adding info for No Bus:43:4
PM: Adding info for No Bus:nbd5
PM: Adding info for No Bus:43:5
PM: Adding info for No Bus:nbd6
PM: Adding info for No Bus:43:6
PM: Adding info for No Bus:nbd7
PM: Adding info for No Bus:43:7
PM: Adding info for No Bus:nbd8
PM: Adding info for No Bus:43:8
PM: Adding info for No Bus:nbd9
PM: Adding info for No Bus:43:9
PM: Adding info for No Bus:nbd10
PM: Adding info for No Bus:43:10
PM: Adding info for No Bus:nbd11
PM: Adding info for No Bus:43:11
PM: Adding info for No Bus:nbd12
PM: Adding info for No Bus:43:12
PM: Adding info for No Bus:nbd13
PM: Adding info for No Bus:43:13
PM: Adding info for No Bus:nbd14
PM: Adding info for No Bus:43:14
PM: Adding info for No Bus:nbd15
PM: Adding info for No Bus:43:15
initcall nbd_init+0x0/0x2d5 returned 0 after 99 msecs
calling  init+0x0/0x2a
initcall init+0x0/0x2a returned 0 after 0 msecs
calling  carm_init+0x0/0x1b
initcall carm_init+0x0/0x1b returned 0 after 0 msecs
calling  tifm_7xx1_init+0x0/0x1b
initcall tifm_7xx1_init+0x0/0x1b returned 0 after 0 msecs
calling  ioc4_init+0x0/0x20
initcall ioc4_init+0x0/0x20 returned 0 after 0 msecs
calling  pasic3_base_init+0x0/0x19
initcall pasic3_base_init+0x0/0x19 returned -19 after 0 msecs
calling  e1000_init_module+0x0/0x6b
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
initcall e1000_init_module+0x0/0x6b returned 0 after 7 msecs
calling  igb_init_module+0x0/0x56
Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
Copyright (c) 2008 Intel Corporation.
initcall igb_init_module+0x0/0x56 returned 0 after 7 msecs
calling  ixgbe_init_module+0x0/0x5a
ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 1.3.18-k2
ixgbe: Copyright (c) 1999-2007 Intel Corporation.
initcall ixgbe_init_module+0x0/0x5a returned 0 after 11 msecs
calling  ipg_init_module+0x0/0x1b
initcall ipg_init_module+0x0/0x1b returned 0 after 0 msecs
calling  t1_init_module+0x0/0x1b
initcall t1_init_module+0x0/0x1b returned 0 after 0 msecs
calling  cxgb3_init_module+0x0/0x20
initcall cxgb3_init_module+0x0/0x20 returned 0 after 0 msecs
calling  bonding_init+0x0/0x8df
Ethernet Channel Bonding Driver: v3.3.0 (June 10, 2008)
bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
PM: Adding info for No Bus:bond0
initcall bonding_init+0x0/0x8df returned 0 after 11 msecs
calling  atl1_init_module+0x0/0x1b
initcall atl1_init_module+0x0/0x1b returned 0 after 0 msecs
calling  atl1e_init_module+0x0/0x1b
initcall atl1e_init_module+0x0/0x1b returned 0 after 0 msecs
calling  rr_init_module+0x0/0x1b
initcall rr_init_module+0x0/0x1b returned 0 after 0 msecs
calling  cas_init+0x0/0x3d
initcall cas_init+0x0/0x3d returned 0 after 0 msecs
calling  vortex_init+0x0/0xad
initcall vortex_init+0x0/0xad returned 0 after 0 msecs
calling  typhoon_init+0x0/0x1b
initcall typhoon_init+0x0/0x1b returned 0 after 0 msecs
calling  eepro100_init_module+0x0/0x1b
initcall eepro100_init_module+0x0/0x1b returned 0 after 0 msecs
calling  e100_init_module+0x0/0x5d
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall e100_init_module+0x0/0x5d returned 0 after 7 msecs
calling  sis900_init_module+0x0/0x1b
initcall sis900_init_module+0x0/0x1b returned 0 after 0 msecs
calling  tg3_init+0x0/0x1b
initcall tg3_init+0x0/0x1b returned 0 after 0 msecs
calling  bnx2x_init+0x0/0x1b
initcall bnx2x_init+0x0/0x1b returned 0 after 0 msecs
calling  skge_init_module+0x0/0x1b
initcall skge_init_module+0x0/0x1b returned 0 after 0 msecs
calling  velocity_init_module+0x0/0x3b
initcall velocity_init_module+0x0/0x3b returned 0 after 0 msecs
calling  vsc8244_init+0x0/0x12
initcall vsc8244_init+0x0/0x12 returned 0 after 0 msecs
calling  fixed_mdio_bus_init+0x0/0xa8
PM: Adding info for platform:Fixed MDIO bus.0
Fixed MDIO Bus: probed
initcall fixed_mdio_bus_init+0x0/0xa8 returned 0 after 7 msecs
calling  hamachi_init+0x0/0x1b
initcall hamachi_init+0x0/0x1b returned 0 after 0 msecs
calling  net_olddevs_init+0x0/0xa0
initcall net_olddevs_init+0x0/0xa0 returned 0 after 0 msecs
calling  hp100_module_init+0x0/0x1b
initcall hp100_module_init+0x0/0x1b returned 0 after 0 msecs
calling  init_nic+0x0/0x1b
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
forcedeth 0000:00:0a.0: setting latency timer to 64
PM: Adding info for No Bus:eth0
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 9, addr 00:13:d4:dc:41:12
forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
initcall init_nic+0x0/0x1b returned 0 after 514 msecs
calling  ql3xxx_init_module+0x0/0x1b
initcall ql3xxx_init_module+0x0/0x1b returned 0 after 3 msecs
calling  ppp_init+0x0/0xa3
PPP generic driver version 2.4.2
PM: Adding info for No Bus:ppp
initcall ppp_init+0x0/0xa3 returned 0 after 7 msecs
calling  deflate_init+0x0/0x3b
PPP Deflate Compression module registered
initcall deflate_init+0x0/0x3b returned 0 after 3 msecs
calling  pppox_init+0x0/0x12
NET: Registered protocol family 24
initcall pppox_init+0x0/0x12 returned 0 after 0 msecs
calling  pppoe_init+0x0/0x99
initcall pppoe_init+0x0/0x99 returned 0 after 0 msecs
calling  slip_init+0x0/0xb2
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
SLIP linefill/keepalive option.
initcall slip_init+0x0/0xb2 returned 0 after 7 msecs
calling  rtl8139_init_module+0x0/0x1b
8139too Fast Ethernet driver 0.9.28
PM: Adding info for No Bus:eth1
eth1: RealTek RTL8139 at 0xffffc20000004000, 00:c0:df:03:68:5d, IRQ 11
eth1:  Identified 8139 chip type 'RTL-8139B'
initcall rtl8139_init_module+0x0/0x1b returned 0 after 11 msecs
calling  eql_init_module+0x0/0x65
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
PM: Adding info for No Bus:eql
initcall eql_init_module+0x0/0x65 returned 0 after 7 msecs
calling  rio_init+0x0/0x1b
initcall rio_init+0x0/0x1b returned 0 after 0 msecs
calling  s2io_starter+0x0/0x1b
initcall s2io_starter+0x0/0x1b returned 0 after 0 msecs
calling  enc28j60_init+0x0/0x23
initcall enc28j60_init+0x0/0x23 returned 0 after 0 msecs
calling  strip_init_driver+0x0/0x6a
STRIP: Version 1.3A-STUART.CHESHIRE (unlimited channels)
initcall strip_init_driver+0x0/0x6a returned 0 after 3 msecs
calling  init_netconsole+0x0/0x238
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x238 returned 0 after 3 msecs
calling  netxen_init_module+0x0/0x48
initcall netxen_init_module+0x0/0x48 returned 0 after 0 msecs
calling  init+0x0/0x12
initcall init+0x0/0x12 returned 0 after 0 msecs
calling  efx_init_module+0x0/0x8f
Solarflare NET driver v2.2
initcall efx_init_module+0x0/0x8f returned 0 after 3 msecs
calling  saa7146_vv_init_module+0x0/0x8
initcall saa7146_vv_init_module+0x0/0x8 returned 0 after 0 msecs
calling  videodev_init+0x0/0x84
Linux video capture interface: v2.00
initcall videodev_init+0x0/0x84 returned 0 after 3 msecs
calling  v4l2_i2c_drv_init+0x0/0xfd
i2c-core: driver [tvaudio'] registered
i2c-core: driver [tvaudio] registered
initcall v4l2_i2c_drv_init+0x0/0xfd returned 0 after 7 msecs
calling  init_saa_5246a+0x0/0x2c
SAA5246A (or compatible) Teletext decoder driver version 1.8
i2c-core: driver [SAA5246A] registered
initcall init_saa_5246a+0x0/0x2c returned 0 after 7 msecs
calling  init_saa_5249+0x0/0x2c
SAA5249 driver (SAA5249 interface) for VideoText version 1.8
i2c-core: driver [SAA5249] registered
initcall init_saa_5249+0x0/0x2c returned 0 after 7 msecs
calling  v4l2_i2c_drv_init+0x0/0xfe
i2c-core: driver [saa7115'] registered
i2c-core: driver [saa7115] registered
initcall v4l2_i2c_drv_init+0x0/0xfe returned 0 after 7 msecs
calling  v4l2_i2c_drv_init+0x0/0x74
i2c-core: driver [saa717x] registered
initcall v4l2_i2c_drv_init+0x0/0x74 returned 0 after 3 msecs
calling  v4l2_i2c_drv_init+0x0/0x77
i2c-core: driver [saa7127] registered
initcall v4l2_i2c_drv_init+0x0/0x77 returned 0 after 3 msecs
calling  adv7175_init+0x0/0x14
i2c-core: driver [adv7175] registered
initcall adv7175_init+0x0/0x14 returned 0 after 3 msecs
calling  cx8800_init+0x0/0x37
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
initcall cx8800_init+0x0/0x37 returned 0 after 3 msecs
calling  cx8802_init+0x0/0x37
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
initcall cx8802_init+0x0/0x37 returned 0 after 3 msecs
calling  usbvision_init+0x0/0x105
usbcore: registered new interface driver usbvision
USBVision USB Video Device Driver for Linux : 0.9.9
initcall usbvision_init+0x0/0x105 returned 0 after 7 msecs
calling  tvp5150_init+0x0/0x14
i2c-core: driver [tvp5150] registered
initcall tvp5150_init+0x0/0x14 returned 0 after 3 msecs
calling  v4l2_i2c_drv_init+0x0/0xfe
i2c-core: driver [msp3400'] registered
i2c-core: driver [msp3400] registered
initcall v4l2_i2c_drv_init+0x0/0xfe returned 0 after 7 msecs
calling  v4l2_i2c_drv_init+0x0/0x77
i2c-core: driver [cs5345] registered
initcall v4l2_i2c_drv_init+0x0/0x77 returned 0 after 3 msecs
calling  v4l2_i2c_drv_init+0x0/0xfd
i2c-core: driver [cs53l32a'] registered
i2c-core: driver [cs53l32a] registered
initcall v4l2_i2c_drv_init+0x0/0xfd returned 0 after 7 msecs
calling  v4l2_i2c_drv_init+0x0/0x74
i2c-core: driver [m52790] registered
initcall v4l2_i2c_drv_init+0x0/0x74 returned 0 after 3 msecs
calling  v4l2_i2c_drv_init+0x0/0xfd
i2c-core: driver [wm8775'] registered
i2c-core: driver [wm8775] registered
initcall v4l2_i2c_drv_init+0x0/0xfd returned 0 after 7 msecs
calling  v4l2_i2c_drv_init+0x0/0x74
i2c-core: driver [wm8739] registered
initcall v4l2_i2c_drv_init+0x0/0x74 returned 0 after 3 msecs
calling  v4l2_i2c_drv_init+0x0/0x74
i2c-core: driver [vp27smpx] registered
initcall v4l2_i2c_drv_init+0x0/0x74 returned 0 after 3 msecs
calling  mxb_init_module+0x0/0x57
saa7146: register extension 'Multimedia eXtension Board'.
initcall mxb_init_module+0x0/0x57 returned 0 after 3 msecs
calling  tuner3036_init+0x0/0x14
i2c-core: driver [sab3036] registered
initcall tuner3036_init+0x0/0x14 returned 0 after 3 msecs
calling  v4l2_i2c_drv_init+0x0/0xfd
i2c-core: driver [tuner'] registered
i2c-core: driver [tuner] registered
initcall v4l2_i2c_drv_init+0x0/0xfd returned 0 after 7 msecs
calling  v4l2_i2c_drv_init+0x0/0xfe
i2c-core: driver [cx25840'] registered
i2c-core: driver [cx25840] registered
initcall v4l2_i2c_drv_init+0x0/0xfe returned 0 after 7 msecs
calling  v4l2_i2c_drv_init+0x0/0x74
i2c-core: driver [upd64031a] registered
initcall v4l2_i2c_drv_init+0x0/0x74 returned 0 after 3 msecs
calling  v4l2_i2c_drv_init+0x0/0x74
i2c-core: driver [upd64083] registered
initcall v4l2_i2c_drv_init+0x0/0x74 returned 0 after 3 msecs
calling  cafe_init+0x0/0x91
Marvell M88ALP01 'CAFE' Camera Controller version 2
initcall cafe_init+0x0/0x91 returned 0 after 3 msecs
calling  ov7670_mod_init+0x0/0x22
OmniVision ov7670 sensor driver, at your service
i2c-core: driver [ov7670] registered
initcall ov7670_mod_init+0x0/0x22 returned 0 after 7 msecs
calling  stk_camera_init+0x0/0x3a
usbcore: registered new interface driver stkwebcam
initcall stk_camera_init+0x0/0x3a returned 0 after 3 msecs
calling  sn9c102_module_init+0x0/0x5b
sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers v1:1.47pre49
usbcore: registered new interface driver sn9c102
initcall sn9c102_module_init+0x0/0x5b returned 0 after 7 msecs
calling  et61x251_module_init+0x0/0x5a
et61x251: V4L2 driver for ET61X[12]51 PC Camera Controllers v1:1.09
usbcore: registered new interface driver et61x251
initcall et61x251_module_init+0x0/0x5a returned 0 after 7 msecs
calling  konicawc_init+0x0/0xb3
konicawc: Konica Webcam driver v1.4
usbcore: registered new interface driver konicawc
initcall konicawc_init+0x0/0xb3 returned 0 after 7 msecs
calling  usb_vicam_init+0x0/0x38
usbcore: registered new interface driver vicam
initcall usb_vicam_init+0x0/0x38 returned 0 after 3 msecs
calling  module_start+0x0/0xb6
ivtv:  Start initialization, version 1.3.0
ivtv:  End initialization
initcall module_start+0x0/0xb6 returned 0 after 7 msecs
calling  maxiradio_radio_init+0x0/0x1b
initcall maxiradio_radio_init+0x0/0x1b returned 0 after 0 msecs
calling  gemtek_pci_init_module+0x0/0x1b
initcall gemtek_pci_init_module+0x0/0x1b returned 0 after 0 msecs
calling  maestro_radio_init+0x0/0x38
initcall maestro_radio_init+0x0/0x38 returned 0 after 0 msecs
calling  dsbr100_init+0x0/0x34
usbcore: registered new interface driver dsbr100
dsbr100: v0.41:D-Link DSB-R100 USB FM radio driver
initcall dsbr100_init+0x0/0x34 returned 0 after 7 msecs
calling  spi_transport_init+0x0/0x2e
initcall spi_transport_init+0x0/0x2e returned 0 after 0 msecs
calling  fc_transport_init+0x0/0x4c
initcall fc_transport_init+0x0/0x4c returned 0 after 0 msecs
calling  iscsi_transport_init+0x0/0x148
Loading iSCSI transport class v2.0-870.
initcall iscsi_transport_init+0x0/0x148 returned 0 after 3 msecs
calling  sas_transport_init+0x0/0xbb
initcall sas_transport_init+0x0/0xbb returned 0 after 0 msecs
calling  ahc_linux_init+0x0/0x59
initcall ahc_linux_init+0x0/0x59 returned 0 after 0 msecs
calling  init_sd+0x0/0xef
Driver 'sd' needs updating - please use bus_type methods
initcall init_sd+0x0/0xef returned 0 after 3 msecs
calling  init_sr+0x0/0x49
Driver 'sr' needs updating - please use bus_type methods
initcall init_sr+0x0/0x49 returned 0 after 3 msecs
calling  ahci_init+0x0/0x1b
initcall ahci_init+0x0/0x1b returned 0 after 0 msecs
calling  piix_init+0x0/0x29
initcall piix_init+0x0/0x29 returned 0 after 0 msecs
calling  pdc_ata_init+0x0/0x1b
initcall pdc_ata_init+0x0/0x1b returned 0 after 0 msecs
calling  qs_ata_init+0x0/0x1b
initcall qs_ata_init+0x0/0x1b returned 0 after 0 msecs
calling  sil24_init+0x0/0x1b
initcall sil24_init+0x0/0x1b returned 0 after 0 msecs
calling  pdc_sata_init+0x0/0x1b
initcall pdc_sata_init+0x0/0x1b returned 0 after 0 msecs
calling  nv_init+0x0/0x1b
initcall nv_init+0x0/0x1b returned 0 after 0 msecs
calling  mv_init+0x0/0x48
initcall mv_init+0x0/0x48 returned 0 after 0 msecs
calling  inic_init+0x0/0x1b
initcall inic_init+0x0/0x1b returned 0 after 0 msecs
calling  ali_init+0x0/0x1b
initcall ali_init+0x0/0x1b returned 0 after 0 msecs
calling  amd_init+0x0/0x1b
pata_amd 0000:00:06.0: version 0.3.10
pata_amd 0000:00:06.0: setting latency timer to 64
scsi0 : pata_amd
PM: Adding info for No Bus:host0
PM: Adding info for No Bus:host0
scsi1 : pata_amd
PM: Adding info for No Bus:host1
PM: Adding info for No Bus:host1
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: 488397168 sectors, multi 1: LBA48 
ata1: nv_mode_filter: 0x3f39f&0x3f07f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
ata1.00: configured for UDMA/100
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
ata2: nv_mode_filter: 0x1f39f&0x707f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
ata2.01: configured for UDMA/33
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
PM: Adding info for No Bus:target0:0:0
PM: Adding info for scsi:0:0:0:0
PM: Adding info for No Bus:0:0:0:0
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
PM: Adding info for No Bus:sda
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
PM: Adding info for No Bus:sda1
PM: Adding info for No Bus:sda2
PM: Adding info for No Bus:sda3
PM: Adding info for No Bus:sda5
PM: Adding info for No Bus:sda6
PM: Adding info for No Bus:sda7
PM: Adding info for No Bus:sda8
PM: Adding info for No Bus:sda9
PM: Adding info for No Bus:sda10
PM: Adding info for No Bus:8:0
sd 0:0:0:0: [sda] Attached SCSI disk
PM: Adding info for No Bus:0:0:0:0
PM: Adding info for No Bus:0:0:0:0
scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
PM: Adding info for No Bus:target1:0:1
PM: Adding info for scsi:1:0:1:0
sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
PM: Adding info for No Bus:sr0
PM: Adding info for No Bus:11:0
sr 1:0:1:0: Attached scsi CD-ROM sr0
PM: Adding info for No Bus:1:0:1:0
PM: Adding info for No Bus:1:0:1:0
initcall amd_init+0x0/0x1b returned 0 after 656 msecs
calling  cs5520_init+0x0/0x1b
initcall cs5520_init+0x0/0x1b returned 0 after 0 msecs
calling  hpt3x3_init+0x0/0x1b
initcall hpt3x3_init+0x0/0x1b returned 0 after 0 msecs
calling  netcell_init+0x0/0x1b
initcall netcell_init+0x0/0x1b returned 0 after 0 msecs
calling  mpiix_init+0x0/0x1b
initcall mpiix_init+0x0/0x1b returned 0 after 0 msecs
calling  oldpiix_init+0x0/0x1b
initcall oldpiix_init+0x0/0x1b returned 0 after 0 msecs
calling  via_init+0x0/0x1b
initcall via_init+0x0/0x1b returned 0 after 0 msecs
calling  sl82c105_init+0x0/0x1b
initcall sl82c105_init+0x0/0x1b returned 0 after 0 msecs
calling  pata_platform_init+0x0/0x12
initcall pata_platform_init+0x0/0x12 returned 0 after 0 msecs
calling  fusion_init+0x0/0xf8
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
initcall fusion_init+0x0/0xf8 returned 0 after 3 msecs
calling  mptspi_init+0x0/0xde
Fusion MPT SPI Host driver 3.04.07
initcall mptspi_init+0x0/0xde returned 0 after 3 msecs
calling  ieee1394_init+0x0/0x26c
initcall ieee1394_init+0x0/0x26c returned 0 after 0 msecs
calling  pcilynx_init+0x0/0x3c
initcall pcilynx_init+0x0/0x3c returned 0 after 0 msecs
calling  init_raw1394+0x0/0xf4
PM: Adding info for No Bus:raw1394
ieee1394: raw1394: /dev/raw1394 device initialized
initcall init_raw1394+0x0/0xf4 returned 0 after 7 msecs
calling  cdrom_init+0x0/0x8
initcall cdrom_init+0x0/0x8 returned 0 after 0 msecs
calling  at25_init+0x0/0x12
initcall at25_init+0x0/0x12 returned 0 after 0 msecs
calling  tle62x0_init+0x0/0x12
initcall tle62x0_init+0x0/0x12 returned 0 after 0 msecs
calling  aoe_init+0x0/0xa7
PM: Adding info for No Bus:err
PM: Adding info for No Bus:discover
PM: Adding info for No Bus:interfaces
PM: Adding info for No Bus:revalidate
PM: Adding info for No Bus:flush
aoe: AoE v47 initialised.
initcall aoe_init+0x0/0xa7 returned 0 after 19 msecs
calling  isp116x_init+0x0/0x3e
116x: driver isp116x-hcd, 03 Nov 2005
initcall isp116x_init+0x0/0x3e returned 0 after 3 msecs
calling  sl811h_init+0x0/0x3e
sl811: driver sl811-hcd, 19 May 2005
initcall sl811h_init+0x0/0x3e returned 0 after 0 msecs
calling  u132_hcd_init+0x0/0xa8
driver u132_hcd built at 23:10:19 on Aug 15 2008
initcall u132_hcd_init+0x0/0xa8 returned 0 after 3 msecs
calling  r8a66597_init+0x0/0x3e
r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
initcall r8a66597_init+0x0/0x3e returned 0 after 3 msecs
calling  c67x00_init+0x0/0x12
initcall c67x00_init+0x0/0x12 returned 0 after 0 msecs
calling  usb_stor_init+0x0/0x50
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
initcall usb_stor_init+0x0/0x50 returned 0 after 11 msecs
calling  usb_usual_init+0x0/0x3e
usbcore: registered new interface driver libusual
initcall usb_usual_init+0x0/0x3e returned 0 after 3 msecs
calling  usb_serial_init+0x0/0x235
usbcore: registered new interface driver usbserial
usbserial: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
initcall usb_serial_init+0x0/0x235 returned 0 after 11 msecs
calling  ch341_init+0x0/0x48
usbserial: USB Serial support registered for ch341-uart
usbcore: registered new interface driver ch341
initcall ch341_init+0x0/0x48 returned 0 after 7 msecs
calling  cyberjack_init+0x0/0x66
usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
usbcore: registered new interface driver cyberjack
cyberjack: v1.01 Matthias Bruestle
cyberjack: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver
initcall cyberjack_init+0x0/0x66 returned 0 after 15 msecs
calling  debug_init+0x0/0x48
usbserial: USB Serial support registered for debug
usbcore: registered new interface driver debug
initcall debug_init+0x0/0x48 returned 0 after 7 msecs
calling  digi_init+0x0/0x76
usbserial: USB Serial support registered for Digi 2 port USB adapter
usbserial: USB Serial support registered for Digi 4 port USB adapter
usbcore: registered new interface driver digi_acceleport
digi_acceleport: v1.80.1.2:Digi AccelePort USB-2/USB-4 Serial Converter driver
initcall digi_init+0x0/0x76 returned 0 after 15 msecs
calling  edgeport_init+0x0/0xc1
usbserial: USB Serial support registered for Edgeport 2 port adapter
usbserial: USB Serial support registered for Edgeport 4 port adapter
usbserial: USB Serial support registered for Edgeport 8 port adapter
usbserial: USB Serial support registered for EPiC device
usbcore: registered new interface driver io_edgeport
io_edgeport: Edgeport USB Serial Driver v2.7
initcall edgeport_init+0x0/0xc1 returned 0 after 22 msecs
calling  usb_ipw_init+0x0/0x5d
usbserial: USB Serial support registered for IPWireless converter
usbcore: registered new interface driver ipwtty
ipw: IPWireless tty driver v0.3
initcall usb_ipw_init+0x0/0x5d returned 0 after 7 msecs
calling  ir_init+0x0/0x58
usbserial: USB Serial support registered for IR Dongle
usbcore: registered new interface driver ir-usb
ir_usb: USB IR Dongle driver v0.4
initcall ir_init+0x0/0x58 returned 0 after 11 msecs
calling  mct_u232_init+0x0/0x58
usbserial: USB Serial support registered for MCT U232
usbcore: registered new interface driver mct_u232
mct_u232: Magic Control Technology USB-RS232 converter driver z2.1
initcall mct_u232_init+0x0/0x58 returned 0 after 11 msecs
calling  moto_init+0x0/0x48
usbserial: USB Serial support registered for moto-modem
usbcore: registered new interface driver moto-modem
initcall moto_init+0x0/0x48 returned 0 after 7 msecs
calling  omninet_init+0x0/0x58
usbserial: USB Serial support registered for ZyXEL - omni.net lcd plus usb
usbcore: registered new interface driver omninet
omninet: v1.1:USB ZyXEL omni.net LCD PLUS Driver
initcall omninet_init+0x0/0x58 returned 0 after 11 msecs
calling  option_init+0x0/0x58
usbserial: USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver option
option: USB Driver for GSM modems: v0.7.2
initcall option_init+0x0/0x58 returned 0 after 11 msecs
calling  spcp8x5_init+0x0/0x58
usbserial: USB Serial support registered for SPCP8x5
usbcore: registered new interface driver spcp8x5
spcp8x5: SPCP8x5 USB to serial adaptor driver v0.04
initcall spcp8x5_init+0x0/0x58 returned 0 after 11 msecs
calling  whiteheat_init+0x0/0x77
usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
usbcore: registered new interface driver whiteheat
whiteheat: USB ConnectTech WhiteHEAT driver v2.0
initcall whiteheat_init+0x0/0x77 returned 0 after 15 msecs
calling  keyspan_pda_init+0x0/0x94
usbserial: USB Serial support registered for Keyspan PDA
usbserial: USB Serial support registered for Keyspan PDA - (prerenumeration)
usbserial: USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
usbcore: registered new interface driver keyspan_pda
keyspan_pda: USB Keyspan PDA Converter driver v1.1
initcall keyspan_pda_init+0x0/0x94 returned 0 after 19 msecs
calling  berry_init+0x0/0x1b
usbcore: registered new interface driver berry_charge
initcall berry_init+0x0/0x1b returned 0 after 3 msecs
calling  cypress_init+0x0/0x3a
usbcore: registered new interface driver cypress_cy7c63
initcall cypress_init+0x0/0x3a returned 0 after 3 msecs
calling  ftdi_elan_init+0x0/0x159
driver ftdi-elan built at 23:10:27 on Aug 15 2008
usbcore: registered new interface driver ftdi-elan
initcall ftdi_elan_init+0x0/0x159 returned 0 after 7 msecs
calling  usb_lcd_init+0x0/0x3a
usbcore: registered new interface driver usblcd
initcall usb_lcd_init+0x0/0x3a returned 0 after 3 msecs
calling  tv_init+0x0/0x4a
usbcore: registered new interface driver trancevibrator
trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
initcall tv_init+0x0/0x4a returned 0 after 7 msecs
calling  usb_sisusb_init+0x0/0x20
usbcore: registered new interface driver sisusb
initcall usb_sisusb_init+0x0/0x20 returned 0 after 3 msecs
calling  i8042_init+0x0/0xef
PM: Adding info for platform:i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0xef returned 0 after 11 msecs
calling  serport_init+0x0/0x34
initcall serport_init+0x0/0x34<7>PM: Adding info for serio:serio0
 returned 0 after 0 msecs
calling  fm801_gp_init+0x0/0x1b
PM: Adding info for serio:serio1
initcall fm801_gp_init+0x0/0x1b returned 0 after 3 msecs
calling  ns558_init+0x0/0x2fa
initcall ns558_init+0x0/0x2fa returned -19 after 7 msecs
calling  mousedev_init+0x0/0x8e
PM: Adding info for No Bus:mice
PM: Adding info for No Bus:psaux
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x8e returned 0 after 7 msecs
calling  evdev_init+0x0/0x12
initcall evdev_init+0x0/0x12 returned 0 after 0 msecs
calling  atkbd_init+0x0/0x27
initcall atkbd_init+0x0/0x27 returned 0 after 0 msecs
calling  adi_init+0x0/0x16
initcall adi_init+0x0/0x16 returned 0 after 0 msecs
calling  analog_init+0x0/0xf1
initcall analog_init+0x0/0xf1 returned 0 after 0 msecs
calling  interact_init+0x0/0x16
initcall interact_init+0x0/0x16 returned 0 after 0 msecs
calling  spaceball_init+0x0/0x1b
PM: Adding info for No Bus:input0
input: AT Translated Set 2 keyboard as /class/input/input0
PM: Adding info for No Bus:event0
initcall spaceball_init+0x0/0x1b returned 0 after 41 msecs
calling  stinger_init+0x0/0x1b
initcall stinger_init+0x0/0x1b returned 0 after 0 msecs
calling  tmdc_init+0x0/0x16
initcall tmdc_init+0x0/0x16 returned 0 after 0 msecs
calling  zhenhua_init+0x0/0x1b
initcall zhenhua_init+0x0/0x1b returned 0 after 0 msecs
calling  usb_acecad_init+0x0/0x38
usbcore: registered new interface driver usb_acecad
acecad: v3.2:USB Acecad Flair tablet driver
initcall usb_acecad_init+0x0/0x38 returned 0 after 7 msecs
calling  gtco_init+0x0/0x51
usbcore: registered new interface driver gtco
GTCO usb driver version: 2.00.0006initcall gtco_init+0x0/0x51 returned 0 after 7 msecs
calling  wacom_init+0x0/0x44
usbcore: registered new interface driver wacom
wacom: v1.48:USB Wacom Graphire and Wacom Intuos tablet driver
initcall wacom_init+0x0/0x44 returned 0 after 7 msecs
calling  tr_init+0x0/0x1b
initcall tr_init+0x0/0x1b returned 0 after 0 msecs
calling  ali1563_init+0x0/0x1b
initcall ali1563_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_ali15x3_init+0x0/0x1b
initcall i2c_ali15x3_init+0x0/0x1b returned 0 after 0 msecs
calling  amd756_init+0x0/0x1b
initcall amd756_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_amd8111_init+0x0/0x1b
initcall i2c_amd8111_init+0x0/0x1b returned 0 after 0 msecs
calling  nforce2_init+0x0/0x1b
PM: Adding info for No Bus:i2c-0
i2c-adapter i2c-0: adapter [SMBus nForce2 adapter at 4c00] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x6a
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x6b
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x5c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x5d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
PM: Adding info for No Bus:i2c-1
i2c-adapter i2c-1: adapter [SMBus nForce2 adapter at 4c40] registered
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x6a
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x6b
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2a
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2b
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x5c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x5d
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
initcall nforce2_init+0x0/0x1b returned 0 after 247 msecs
calling  i2c_piix4_init+0x0/0x1b
initcall i2c_piix4_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_vt596_init+0x0/0x1b
initcall i2c_vt596_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_adap_simtec_init+0x0/0x12
initcall i2c_adap_simtec_init+0x0/0x12 returned 0 after 0 msecs
calling  i2c_pca_pf_init+0x0/0x12
initcall i2c_pca_pf_init+0x0/0x12 returned 0 after 0 msecs
calling  ds1682_init+0x0/0x14
i2c-core: driver [ds1682] registered
initcall ds1682_init+0x0/0x14 returned 0 after 3 msecs
calling  pcf8574_init+0x0/0x14
i2c-core: driver [pcf8574] registered
initcall pcf8574_init+0x0/0x14 returned 0 after 3 msecs
calling  isdn_init+0x0/0x2fd
ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/1.1.2.3/1.1.2.2/1.1.2.2
initcall isdn_init+0x0/0x2fd returned 0 after 7 msecs
calling  divert_init+0x0/0x64
dss1_divert module successfully installed
initcall divert_init+0x0/0x64 returned 0 after 3 msecs
calling  gigaset_init_module+0x0/0x37
gigaset: Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>, Stefan Eilers
gigaset: Driver for Gigaset 307x
initcall gigaset_init_module+0x0/0x37 returned 0 after 7 msecs
calling  bas_gigaset_init+0x0/0xa5
usbcore: registered new interface driver bas_gigaset
bas_gigaset: Tilman Schmidt <tilman@imap.cc>, Hansjoerg Lipp <hjlipp@web.de>, Stefan Eilers
bas_gigaset: USB Driver for Gigaset 307x
initcall bas_gigaset_init+0x0/0xa5 returned 0 after 11 msecs
calling  cpufreq_stats_init+0x0/0x89
initcall cpufreq_stats_init+0x0/0x89 returned 0 after 0 msecs
calling  cpufreq_gov_userspace_init+0x0/0x12
initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 msecs
calling  cpufreq_gov_dbs_init+0x0/0x12
initcall cpufreq_gov_dbs_init+0x0/0x12 returned 0 after 0 msecs
calling  init_ladder+0x0/0x12
cpuidle: using governor ladder
initcall init_ladder+0x0/0x12 returned 0 after 3 msecs
calling  gpio_led_init+0x0/0x12
initcall gpio_led_init+0x0/0x12 returned 0 after 0 msecs
calling  heartbeat_trig_init+0x0/0x12
initcall heartbeat_trig_init+0x0/0x12 returned 0 after 0 msecs
calling  hid_init+0x0/0xb
initcall hid_init+0x0/0xb returned 0 after 0 msecs
calling  hid_init+0x0/0x62
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
initcall hid_init+0x0/0x62 returned 0 after 11 msecs
calling  usb_mouse_init+0x0/0x38
usbcore: registered new interface driver usbmouse
usbmouse: v1.6:USB HID Boot Protocol mouse driver
initcall usb_mouse_init+0x0/0x38 returned 0 after 7 msecs
calling  virtio_pci_init+0x0/0x48
PM: Adding info for No Bus:virtio-pci
initcall virtio_pci_init+0x0/0x48 returned 0 after 3 msecs
calling  init+0x0/0x12
initcall init+0x0/0x12 returned 0 after 0 msecs
calling  init_soundcore+0x0/0x60
initcall init_soundcore+0x0/0x60 returned 0 after 0 msecs
calling  alsa_sound_init+0x0/0x93
Advanced Linux Sound Architecture Driver Version 1.0.17.
initcall alsa_sound_init+0x0/0x93 returned 0 after 3 msecs
calling  alsa_sound_last_init+0x0/0x61
ALSA device list:
  No soundcards found.
initcall alsa_sound_last_init+0x0/0x61 returned 0 after 3 msecs
calling  flow_cache_init+0x0/0x1b8
initcall flow_cache_init+0x0/0x1b8 returned 0 after 0 msecs
calling  pg_init+0x0/0x304
pktgen v2.70: Packet Generator for packet performance testing.
initcall pg_init+0x0/0x304 returned 0 after 3 msecs
calling  llc_init+0x0/0x20
initcall llc_init+0x0/0x20 returned 0 after 0 msecs
calling  llc2_init+0x0/0xaa
NET: Registered protocol family 26
initcall llc2_init+0x0/0xaa returned 0 after 7 msecs
calling  snap_init+0x0/0x31
initcall snap_init+0x0/0x31 returned 0 after 0 msecs
calling  rif_init+0x0/0x70
initcall rif_init+0x0/0x70 returned 0 after 0 msecs
calling  blackhole_module_init+0x0/0x12
initcall blackhole_module_init+0x0/0x12 returned 0 after 0 msecs
calling  mirred_init_module+0x0/0x20
Mirror/redirect action on
initcall mirred_init_module+0x0/0x20 returned 0 after 3 msecs
calling  cbq_module_init+0x0/0x12
initcall cbq_module_init+0x0/0x12 returned 0 after 0 msecs
calling  red_module_init+0x0/0x12
initcall red_module_init+0x0/0x12 returned 0 after 0 msecs
calling  ingress_module_init+0x0/0x12
initcall ingress_module_init+0x0/0x12 returned 0 after 0 msecs
calling  tbf_module_init+0x0/0x12
initcall tbf_module_init+0x0/0x12 returned 0 after 0 msecs
calling  init_route4+0x0/0x12
initcall init_route4+0x0/0x12 returned 0 after 0 msecs
calling  init_fw+0x0/0x12
initcall init_fw+0x0/0x12 returned 0 after 0 msecs
calling  init_rsvp+0x0/0x12
initcall init_rsvp+0x0/0x12 returned 0 after 0 msecs
calling  init_rsvp+0x0/0x12
initcall init_rsvp+0x0/0x12 returned 0 after 0 msecs
calling  cls_flow_init+0x0/0x12
initcall cls_flow_init+0x0/0x12 returned 0 after 0 msecs
calling  nfnetlink_init+0x0/0x5d
Netfilter messages via NETLINK v0.30.
initcall nfnetlink_init+0x0/0x5d returned 0 after 3 msecs
calling  nfnetlink_queue_init+0x0/0xa2
initcall nfnetlink_queue_init+0x0/0xa2 returned 0 after 0 msecs
calling  nf_conntrack_standalone_init+0x0/0x7d
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
initcall nf_conntrack_standalone_init+0x0/0x7d returned 0 after 15 msecs
calling  nf_ct_proto_gre_init+0x0/0x12
initcall nf_ct_proto_gre_init+0x0/0x12 returned 0 after 0 msecs
calling  nf_conntrack_proto_udplite_init+0x0/0x43
initcall nf_conntrack_proto_udplite_init+0x0/0x43 returned 0 after 0 msecs
calling  nf_conntrack_amanda_init+0x0/0xa6
initcall nf_conntrack_amanda_init+0x0/0xa6 returned 0 after 0 msecs
calling  nf_conntrack_ftp_init+0x0/0x1a0
initcall nf_conntrack_ftp_init+0x0/0x1a0 returned 0 after 0 msecs
calling  nf_conntrack_pptp_init+0x0/0x12
initcall nf_conntrack_pptp_init+0x0/0x12 returned 0 after 0 msecs
calling  nf_conntrack_sip_init+0x0/0x18c
initcall nf_conntrack_sip_init+0x0/0x18c returned 0 after 0 msecs
calling  xt_init+0x0/0xca
initcall xt_init+0x0/0xca returned 0 after 0 msecs
calling  tcpudp_mt_init+0x0/0x17
initcall tcpudp_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  classify_tg_init+0x0/0x17
initcall classify_tg_init+0x0/0x17 returned 0 after 0 msecs
calling  nflog_tg_init+0x0/0x17
initcall nflog_tg_init+0x0/0x17 returned 0 after 0 msecs
calling  connmark_mt_init+0x0/0x17
initcall connmark_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  dscp_mt_init+0x0/0x17
initcall dscp_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  length_mt_init+0x0/0x17
initcall length_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  limit_mt_init+0x0/0x17
initcall limit_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  policy_mt_init+0x0/0x17
initcall policy_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  quota_mt_init+0x0/0x17
initcall quota_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  sctp_mt_init+0x0/0x17
initcall sctp_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  statistic_mt_init+0x0/0x17
initcall statistic_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  string_mt_init+0x0/0x17
initcall string_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  tcpmss_mt_init+0x0/0x17
initcall tcpmss_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  time_mt_init+0x0/0x17
initcall time_mt_init+0x0/0x17 returned 0 after 0 msecs
calling  ipgre_init+0x0/0x71
GRE over IPv4 tunneling driver
PM: Adding info for No Bus:gre0
initcall ipgre_init+0x0/0x71 returned 0 after 3 msecs
calling  esp4_init+0x0/0x68
initcall esp4_init+0x0/0x68 returned 0 after 0 msecs
calling  ipv4_netfilter_init+0x0/0x17
initcall ipv4_netfilter_init+0x0/0x17 returned 0 after 0 msecs
calling  ip_queue_init+0x0/0x114
initcall ip_queue_init+0x0/0x114 returned 0 after 0 msecs
calling  inet_diag_init+0x0/0x69
initcall inet_diag_init+0x0/0x69 returned 0 after 0 msecs
calling  tcp_diag_init+0x0/0x12
initcall tcp_diag_init+0x0/0x12 returned 0 after 0 msecs
calling  bictcp_register+0x0/0x12
TCP bic registered
initcall bictcp_register+0x0/0x12 returned 0 after 3 msecs
calling  tcp_westwood_register+0x0/0x12
TCP westwood registered
initcall tcp_westwood_register+0x0/0x12 returned 0 after 0 msecs
calling  hybla_register+0x0/0x12
TCP hybla registered
initcall hybla_register+0x0/0x12 returned 0 after 0 msecs
calling  tcp_vegas_register+0x0/0x14
TCP vegas registered
initcall tcp_vegas_register+0x0/0x14 returned 0 after 3 msecs
calling  tcp_scalable_register+0x0/0x12
TCP scalable registered
initcall tcp_scalable_register+0x0/0x12 returned 0 after 3 msecs
calling  packet_init+0x0/0x47
NET: Registered protocol family 17
initcall packet_init+0x0/0x47 returned 0 after 0 msecs
calling  atalk_init+0x0/0x88
NET: Registered protocol family 5
initcall atalk_init+0x0/0x88 returned 0 after 30 msecs
calling  x25_init+0x0/0x5a
NET: Registered protocol family 9
X.25 for Linux Version 0.2
initcall x25_init+0x0/0x5a returned 0 after 7 msecs
calling  lapb_init+0x0/0x8
initcall lapb_init+0x0/0x8 returned 0 after 0 msecs
calling  vlan_proto_init+0x0/0xc7
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
initcall vlan_proto_init+0x0/0xc7 returned 0 after 7 msecs
calling  powernowk8_init+0x0/0xd9
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (2 cpu cores) (version 2.20.00)
powernow-k8: ACPI Processor support is required for SMP systems but is absent. Please load the ACPI Processor module before starting this driver.
powernow-k8: ACPI Processor support is required for SMP systems but is absent. Please load the ACPI Processor module before starting this driver.
initcall powernowk8_init+0x0/0xd9 returned -19 after 15 msecs
calling  update_mp_table+0x0/0x476
initcall update_mp_table+0x0/0x476 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x40
initcall lapic_insert_resource+0x0/0x40 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x38
initcall init_lapic_nmi_sysfs+0x0/0x38 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x4f
initcall ioapic_insert_resources+0x0/0x4f returned 0 after 0 msecs
calling  check_early_ioremap_leak+0x0/0x22
initcall check_early_ioremap_leak+0x0/0x22 returned 0 after 0 msecs
calling  pat_memtype_list_init+0x0/0x29
initcall pat_memtype_list_init+0x0/0x29 returned 0 after 3 msecs
calling  sched_init_debug+0x0/0x24
initcall sched_init_debug+0x0/0x24 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x28
initcall init_oops_id+0x0/0x28 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x3a
initcall disable_boot_consoles+0x0/0x3a returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0x61
PM: Adding info for No Bus:cpu_dma_latency
PM: Adding info for No Bus:network_latency
PM: Adding info for No Bus:network_throughput
initcall pm_qos_power_init+0x0/0x61 returned 0 after 11 msecs
calling  software_resume+0x0/0x1b8
initcall software_resume+0x0/0x1b8 returned -2 after 0 msecs
initcall software_resume+0x0/0x1b8 returned with error code -2 
calling  debugfs_kprobe_init+0x0/0x89
initcall debugfs_kprobe_init+0x0/0x89 returned 0 after 0 msecs
calling  taskstats_init+0x0/0x95
registered taskstats version 1
initcall taskstats_init+0x0/0x95 returned 0 after 3 msecs
calling  random32_reseed+0x0/0x9e
initcall random32_reseed+0x0/0x9e returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x4c
initcall pci_sysfs_init+0x0/0x4c returned 0 after 0 msecs
calling  seqgen_init+0x0/0xf
initcall seqgen_init+0x0/0xf returned 0 after 0 msecs
calling  late_resume_init+0x0/0xf2
  Magic number: 4:982:196
initcall late_resume_init+0x0/0xf2 returned 0 after 0 msecs
calling  hd_init+0x0/0x2fe
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
initcall hd_init+0x0/0x2fe returned -1 after 3 msecs
initcall hd_init+0x0/0x2fe returned with error code -1 
calling  scsi_complete_async_scans+0x0/0x129
initcall scsi_complete_async_scans+0x0/0x129 returned 0 after 0 msecs
calling  memmap_init+0x0/0x90
initcall memmap_init+0x0/0x90 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x12
initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 msecs
calling  ip_auto_config+0x0/0xce7
initcall ip_auto_config+0x0/0xce7 returned 0 after 0 msecs
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 1128k freed
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
udev: renamed network interface eth0 to eth1
udev: renamed network interface eth1_rename to eth0
eth0: link down
EXT3 FS on sda6, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 3911816k swap on /dev/sda2.  Priority:-1 extents:1 across:3911816k
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
warning: `sudo' uses 32-bit capabilities (legacy support in use)
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
eth1: too many iterations (6) in nv_nic_irq.
---------------------->
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio Controller (rev a2)
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)]
01:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
05:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)

