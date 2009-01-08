Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbZAHMsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbZAHMsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZAHMr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:47:58 -0500
Received: from monster.nessie.de ([84.200.20.120]:60027 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbZAHMry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:47:54 -0500
Message-ID: <4965F5F6.1010801@nessie.de>
Date: Thu, 08 Jan 2009 13:47:50 +0100
From: Michael Roth <mroth@nessie.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Funny problem with 2.6.28: Kernel stalls
References: <4953A35C.8090005@nessie.de> <495411FD.60409@gmail.com> <4958B9B7.8060505@nessie.de> <alpine.LFD.2.00.0812291636060.3723@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812291636060.3723@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner schrieb:

> Can you please provide the following information from the kernel which
> shows these freeze symptoms:
> 
> output of: dmesg
> output of: cat /proc/timer_list

It took quite some days but here are the results:


============ /proc/timer_list  ============


Timer List Version: v0.4
HRTIMER_MAX_CLOCK_BASES: 2
now at 152525318367 nsecs

cpu: 0
 clock 0:
  .base:       c04edc60
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1231417139240211059 nsecs
active timers:
 clock 1:
  .base:       c04edc8c
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <c05a13e0>, tick_sched_timer, S:01
 # expires at 152526000000-152526000000 nsecs [in 681633 to 681633 nsecs]
 #1: <f64fbb40>, hrtimer_wakeup, S:01
 # expires at 152978425506-152978924683 nsecs [in 453107139 to 453606316 nsecs]
 #2: <c057ee50>, sched_rt_period_timer, S:01
 # expires at 153000000000-153000000000 nsecs [in 474681633 to 474681633 nsecs]
 #3: <f66cbbcc>, hrtimer_wakeup, S:01
 # expires at 153205133460-153206126459 nsecs [in 679815093 to 680808092 nsecs]
 #4: <f6a55960>, it_real_fn, S:01
 # expires at 153241509572-153241509572 nsecs [in 716191205 to 716191205 nsecs]
 #5: <f669bbcc>, hrtimer_wakeup, S:01
 # expires at 153759872924-153761866922 nsecs [in 1234554557 to 1236548555 nsecs]
 #6: <f6639bcc>, hrtimer_wakeup, S:01
 # expires at 153760052197-153762050195 nsecs [in 1234733830 to 1236731828 nsecs]
 #7: <f667bbcc>, hrtimer_wakeup, S:01
 # expires at 153760135343-153762118342 nsecs [in 1234816976 to 1236799975 nsecs]
 #8: <f669fbcc>, hrtimer_wakeup, S:01
 # expires at 153760486107-153762478106 nsecs [in 1235167740 to 1237159739 nsecs]
 #9: <f6699bcc>, hrtimer_wakeup, S:01
 # expires at 153760629481-153762622479 nsecs [in 1235311114 to 1237304112 nsecs]
 #10: <f669dbcc>, hrtimer_wakeup, S:01
 # expires at 153760741563-153762735561 nsecs [in 1235423196 to 1237417194 nsecs]
 #11: <f6637bcc>, hrtimer_wakeup, S:01
 # expires at 153760256922-153790238919 nsecs [in 1234938555 to 1264920552 nsecs]
 #12: <f7041b40>, hrtimer_wakeup, S:01
 # expires at 153873058398-153878058396 nsecs [in 1347740031 to 1352740029 nsecs]
 #13: <f66c9f58>, hrtimer_wakeup, S:01
 # expires at 182382854778-182382904778 nsecs [in 29857536411 to 29857586411 nsecs]
 #14: <f602db40>, hrtimer_wakeup, S:01
 # expires at 237916308075-238001725073 nsecs [in 85390989708 to 85476406706 nsecs]
 #15: <f67e1bcc>, hrtimer_wakeup, S:01
 # expires at 374707119907-374807119907 nsecs [in 222181801540 to 222281801540 nsecs]
 #16: <f69fb600>, it_real_fn, S:01
 # expires at 431508420538-431508420538 nsecs [in 278983102171 to 278983102171 nsecs]
 #17: <f66a1be0>, it_real_fn, S:01
 # expires at 444860073316-444860073316 nsecs [in 292334754949 to 292334754949 nsecs]
 #18: <f66a1d80>, it_real_fn, S:01
 # expires at 446528483347-446528483347 nsecs [in 294003164980 to 294003164980 nsecs]
 #19: <f67abbcc>, hrtimer_wakeup, S:01
 # expires at 1329515524910-1329615524910 nsecs [in 1176990206543 to 1177090206543 nsecs]
 #20: <f6431f58>, hrtimer_wakeup, S:01
 # expires at 1876726495047-1876726545047 nsecs [in 1724201176680 to 1724201226680 nsecs]
 #21: <f64c7240>, it_real_fn, S:01
 # expires at 6107861183445-6107861183445 nsecs [in 5955335865078 to 5955335865078 nsecs]
 #22: <f73c3760>, it_real_fn, S:01
 # expires at 6111530098717-6111530098717 nsecs [in 5959004780350 to 5959004780350 nsecs]
 #23: <f64c7580>, it_real_fn, S:01
 # expires at 6112528074685-6112528074685 nsecs [in 5960002756318 to 5960002756318 nsecs]
 #24: <f6915100>, it_real_fn, S:01
 # expires at 10884538253986-10884538253986 nsecs [in 10732012935619 to 10732012935619 nsecs]
 #25: <f660fb40>, hrtimer_wakeup, S:01
 # expires at 86461308390857-86461408390857 nsecs [in 86308783072490 to 86308883072490 nsecs]
  .expires_next   : 152526000000 nsecs
  .hres_active    : 1
  .nr_events      : 130914
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294819821


Tick Device: mode:     1
Broadcast device
Clock Event Device: pit
 max_delta_ns:   27461866
 min_delta_ns:   12571
 mult:           5124677
 shift:          32
 mode:           3
 next_event:     152526000000 nsecs
 set_next_event: pit_next_event
 set_mode:       init_pit_timer
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: lapic
 max_delta_ns:   504751346
 min_delta_ns:   1000
 mult:           71379290
 shift:          32
 mode:           3
 next_event:     152526000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt


============ dmesg  ============


BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28notok (root@nautilus) (gcc version 4.2.4 (Gentoo 4.2.4)) #4 PREEMPT Thu Jan 8 12:58:23 CET 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
DMI 2.2 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0x3fff0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 377fe000 @ 10000-16000
RAMDISK: 37e7d000 - 37fef877
Allocated new RAMDISK: 005c0000 - 00732877
Move RAMDISK from 0000000037e7d000 - 0000000037fef876 to 005c0000 - 00732876
ACPI: RSDP 000F6F30, 0014 (r0 VKT333)
ACPI: RSDT 3FFF3000, 002C (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF3040, 0074 (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FFF30C0, 3E82 (r1 VKT333 AWRDACPI     1000 MSFT  100000D)
ACPI: FACS 3FFF0000, 0040
ACPI: APIC 3FFF6F80, 0054 (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
ACPI: Local APIC address 0xfee00000
135MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00012000 - 00018f00
(7 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 00005bc6ac]    TEXT DATA BSS ==> [0000100000 - 00005bc6ac]
  #2 [00005bd000 - 00005c0000]    INIT_PG_TABLE ==> [00005bd000 - 00005c0000]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #5 [00005c0000 - 0000732877]      NEW RAMDISK ==> [00005c0000 - 0000732877]
  #6 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003fff0
On node 0 totalpages: 262015
free_area_init_node: node 0, pgdat c0512160, node_mem_map c1000200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 272 pages used for memmap
  HighMem zone: 34530 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
Kernel command line: crypt_root=/dev/vg1/root.crypt dolvm lvmraid=/dev/md3 video=radeonfb
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 1994.335 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1032332k/1048512k available (3070k kernel code, 15352k reserved, 1132k data, 316k init, 139208k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc051e000 - 0xc056d000   ( 316 kB)
      .data : 0xc03ffbb2 - 0xc051ae5c   (1132 kB)
      .text : 0xc0100000 - 0xc03ffbb2   (3070 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3988.67 BogoMIPS (lpj=1994335)
Mount-cache hash table entries: 512
CPU: CLK_CTL MSR was 60031223. Reprogramming to 20031223
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: AMD Athlon(tm) XP 2400+ stepping 01
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080926
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
net_namespace: 688 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb3b0, last bus=1
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
pci 0000:00:01.0: supports D1
pci 0000:00:09.0: reg 10 32bit mmio: [0xe8100000-0xe811ffff]
pci 0000:00:09.0: reg 14 32bit mmio: [0xe8120000-0xe813ffff]
pci 0000:00:09.0: reg 18 io port: [0xa000-0xa03f]
pci 0000:00:09.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0a.0: reg 10 io port: [0xa400-0xa407]
pci 0000:00:0a.0: reg 14 io port: [0xa800-0xa803]
pci 0000:00:0a.0: reg 18 io port: [0xac00-0xac07]
pci 0000:00:0a.0: reg 1c io port: [0xb000-0xb003]
pci 0000:00:0a.0: reg 20 io port: [0xb400-0xb40f]
pci 0000:00:0a.0: reg 24 32bit mmio: [0xe8160000-0xe8163fff]
pci 0000:00:0a.0: reg 30 32bit mmio: [0x000000-0x003fff]
pci 0000:00:0a.0: supports D1
pci 0000:00:10.0: reg 20 io port: [0xb800-0xb81f]
pci 0000:00:10.0: supports D1 D2
pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.0: PME# disabled
pci 0000:00:10.1: reg 20 io port: [0xbc00-0xbc1f]
pci 0000:00:10.1: supports D1 D2
pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:10.2: reg 20 io port: [0xc000-0xc01f]
pci 0000:00:10.2: supports D1 D2
pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.2: PME# disabled
pci 0000:00:10.3: reg 10 32bit mmio: [0xe8164000-0xe81640ff]
pci 0000:00:10.3: supports D1 D2
pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.3: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
pci 0000:00:11.0: quirk: region 5000-500f claimed by vt8235 SMB
pci 0000:00:11.1: reg 20 io port: [0xc400-0xc40f]
pci 0000:00:11.5: reg 10 io port: [0xc800-0xc8ff]
pci 0000:00:11.5: supports D1 D2
pci 0000:00:12.0: reg 10 io port: [0xcc00-0xccff]
pci 0000:00:12.0: reg 14 32bit mmio: [0xe8165000-0xe81650ff]
pci 0000:00:12.0: supports D1 D2
pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:12.0: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0xd8000000-0xdfffffff]
pci 0000:01:00.0: reg 14 io port: [0x9000-0x90ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xe8020000-0xe802ffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: reg 10 32bit mmio: [0xe0000000-0xe7ffffff]
pci 0000:01:00.1: reg 14 32bit mmio: [0xe8030000-0xe803ffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:00:01.0: bridge io port: [0x9000-0x9fff]
pci 0000:00:01.0: bridge 32bit mmio: [0xe8000000-0xe80fffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xd8000000-0xe7ffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [ALKA] (IRQs 20) *0
ACPI: PCI Interrupt Link [ALKB] (IRQs 21) *0
ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *0
ACPI: PCI Interrupt Link [ALKD] (IRQs 23) *0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0xd0000-0xd3fff has been reserved
system 00:00: iomem range 0xd9800-0xdbfff has been reserved
system 00:00: iomem range 0xf0000-0xfbfff could not be reserved
system 00:00: iomem range 0xfc000-0xfffff could not be reserved
system 00:00: iomem range 0x3fff0000-0x3fffffff could not be reserved
system 00:00: iomem range 0xffff0000-0xffffffff has been reserved
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0x100000-0x3ffeffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:00: iomem range 0xfff80000-0xfffeffff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x805 has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x9000-0x9fff
pci 0000:00:01.0:   MEM window: 0xe8000000-0xe80fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000e7ffffff
pci 0000:00:01.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 io port: [0x9000-0x9fff]
bus: 01 index 1 mmio: [0xe8000000-0xe80fffff]
bus: 01 index 2 mmio: [0xd8000000-0xe7ffffff]
bus: 01 index 3 mmio: [0x0-0x0]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 1482k freed
Machine check exception polling timer started.
alg: cipher: Test 1 failed on encryption for aes-asm
00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08
audit: initializing netlink socket (disabled)
type=2000 audit(1231420738.223:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1748
alg: No test for cipher_null (cipher_null-generic)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for fcrypt (fcrypt-generic)
alg: No test for stdrng (krng)
alg: No test for stdrng (ansi_cprng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
PCI: VIA PCI bridge detected.Disabling DAC.
pci 0000:01:00.0: Boot video device
radeonfb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=240.00 Mhz, System=166.00 MHz
radeonfb: PLL min 20000 max 40000
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
Switched to high resolution mode on CPU 0
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
radeonfb: Monitor 1 type DFP found
radeonfb: EDID probed
radeonfb: Monitor 2 type no found
Console: switching to colour frame buffer device 160x64
radeonfb (0000:01:00.0): ATI Radeon 5960 "Y`"
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb1: VGA16 VGA frame buffer device
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN] (on)
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI_CPU:00: registered as cooling_device1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (40 C)
Linux agpgart interface v0.103
agpgart: Detected VIA KT266/KY266x/KT333 chipset
agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.29.0 20080528 on minor 0
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
Uniform Multi-Platform E-IDE driver
pdc202xx_new 0000:00:0a.0: IDE controller (0x105a:0x4d69 rev 0x02)
Promise_IDE 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pdc202xx_new 0000:00:0a.0: PLL input clock is 16597 kHz
pdc202xx_new 0000:00:0a.0: 100% native mode on irq 18
    ide2: BM-DMA at 0xb400-0xb407
    ide3: BM-DMA at 0xb408-0xb40f
Probing IDE interface ide2...
hde: HL-DT-ST DVDRAM GSA-H42N, ATAPI CD/DVD-ROM drive
hde: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hde: UDMA/66 mode selected
Probing IDE interface ide3...
ide2 at 0xa400-0xa407,0xa802 on irq 18
ide3 at 0xac00-0xac07,0xb002 on irq 18
via82cxxx 0000:00:11.1: VIA vt8235 (rev 00) IDE UDMA133
via82cxxx 0000:00:11.1: IDE controller (0x1106:0x0571 rev 0x06)
ACPI: PCI Interrupt Link [ALKA] BIOS reported IRQ 0, using IRQ 20
ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
VIA_IDE 0000:00:11.1: PCI INT A -> Link[ALKA] -> GSI 20 (level, low) -> IRQ 20
via82cxxx 0000:00:11.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xc400-0xc407
    ide1: BM-DMA at 0xc408-0xc40f
Probing IDE interface ide0...
hda: SAMSUNG HD400LD, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: SAMSUNG HD400LD, ATA DISK drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/100 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 781422768 sectors (400088 MB) w/8192KiB Cache, CHS=48641/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4
hdc: max request size: 512KiB
hdc: 781422768 sectors (400088 MB) w/8192KiB Cache, CHS=48641/255/63
hdc: cache flushes supported
 hdc: hdc1 hdc2 hdc3 hdc4
ide-cd driver 5.00
ide-cd: hde: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
usbmon: debugfs is not available
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [ALKB] BIOS reported IRQ 0, using IRQ 21
ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
ehci_hcd 0000:00:10.3: PCI INT D -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.3: EHCI Host Controller
ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.3: irq 21, io mem 0xe8164000
ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28notok ehci_hcd
usb usb1: SerialNumber: 0000:00:10.3
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:10.0: PCI INT A -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 21, io base 0x0000b800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28notok uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
uhci_hcd 0000:00:10.1: PCI INT B -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 21, io base 0x0000bc00
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28notok uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
uhci_hcd 0000:00:10.2: PCI INT C -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000c000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.28notok uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input3
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 316k freed
Marking TSC unstable due to TSC halts in idle
usb 1-4: new high speed USB device using ehci_hcd and address 4
usb 1-4: configuration #1 chosen from 1 choice
usb 1-4: New USB device found, idVendor=0dda, idProduct=2005
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: USB2.0 Card Reader
usb 1-4: Manufacturer: ICSI
usb 1-4: SerialNumber: 0000001
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
input: HID 046a:0004 as /class/input/input4
generic-usb 0003:046A:0004.0001: input,hidraw0: USB HID v1.10 Keyboard [HID 046a:0004] on usb-0000:00:10.0-1/input0
input: HID 046a:0004 as /class/input/input5
generic-usb 0003:046A:0004.0002: input,hidraw1: USB HID v1.10 Device [HID 046a:0004] on usb-0000:00:10.0-1/input1
usb 2-1: New USB device found, idVendor=046a, idProduct=0004
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 2-2: new low speed USB device using uhci_hcd and address 3
usb 2-2: configuration #1 chosen from 1 choice
input: B16_b_02 USB-PS/2 Optical Mouse as /class/input/input6
generic-usb 0003:046D:C024.0003: input,hidraw2: USB HID v1.10 Mouse [B16_b_02 USB-PS/2 Optical Mouse] on
usb-0000:00:10.0-2/input0
usb 2-2: New USB device found, idVendor=046d, idProduct=c024
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: USB-PS/2 Optical Mouse
usb 2-2: Manufacturer: B16_b_02
md: Autodetecting RAID arrays.
md: Scanned 4 and added 4 devices.
md: autorun ...
md: considering hdc3 ...
md:  adding hdc3 ...
md: hdc2 has different UUID to hdc3
md:  adding hda3 ...
md: hda2 has different UUID to hdc3
md: created md2
md: bind<hda3>
md: bind<hdc3>
md: running: <hdc3><hda3>
raid1: raid set md2 active with 2 out of 2 mirrors
md: considering hdc2 ...
md:  adding hdc2 ...
md:  adding hda2 ...
md: created md3
md: bind<hda2>
md: bind<hdc2>
md: running: <hdc2><hda2>
raid1: raid set md3 active with 2 out of 2 mirrors
md: ... autorun DONE.
 md2: unknown partition table
 md3: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
IT8705 SuperIO detected.
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
e1000 0000:00:09.0: PCI: Disallowing DAC for device
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
via-rhine: Broken BIOS detected, avoid_D3 enabled.
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
e1000: 0000:00:09.0: e1000_probe: (PCI:33MHz:32-bit) 00:07:e9:17:35:86
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt Link [ALKD] BIOS reported IRQ 0, using IRQ 23
ACPI: PCI Interrupt Link [ALKD] enabled at IRQ 23
via-rhine 0000:00:12.0: PCI INT A -> Link[ALKD] -> GSI 23 (level, low) -> IRQ 23
eth1: VIA Rhine II at 0xe8165000, 00:0a:e6:62:b1:b3, IRQ 23.
eth1: MII PHY found at address 1, status 0x7849 advertising 05e1 Link 0000.
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
ACPI: PCI Interrupt Link [ALKC] BIOS reported IRQ 0, using IRQ 22
ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
VIA 82xx Audio 0000:00:11.5: PCI INT C -> Link[ALKC] -> GSI 22 (level, low) -> IRQ 22
VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
EXT3 FS on dm-3, internal journal
scsi 0:0:0:0: Direct-Access     ICSI     IC1210        CF 1.6B PQ: 0 ANSI: 0 CCS
scsi 0:0:0:1: Direct-Access     ICSI     IC1210        MS 1.6B PQ: 0 ANSI: 0 CCS
scsi 0:0:0:2: Direct-Access     ICSI     IC1210    MMC/SD 1.6B PQ: 0 ANSI: 0 CCS
scsi 0:0:0:3: Direct-Access     ICSI     IC1210        SM 1.6B PQ: 0 ANSI: 0 CCS
usb-storage: device scan complete
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] Attached SCSI removable disk
sd 0:0:0:1: [sdb] Attached SCSI removable disk
sd 0:0:0:2: [sdc] Attached SCSI removable disk
sd 0:0:0:3: [sdd] Attached SCSI removable disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:1: Attached scsi generic sg1 type 0
sd 0:0:0:2: Attached scsi generic sg2 type 0
sd 0:0:0:3: Attached scsi generic sg3 type 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
fuse init (API version 7.10)
Adding 524280k swap on /dev/mapper/swap.  Priority:-1 extents:1 across:524280k
hda: UDMA/100 mode selected
hdc: UDMA/100 mode selected
hde: UDMA/66 mode selected
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
eth1: link down
Bridge firewalling registered
device eth0 entered promiscuous mode
device eth1 entered promiscuous mode
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth1: link is not ready
warning: `squid' uses 32-bit capabilities (legacy support in use)
br0: no IPv6 routers present
eth0: no IPv6 routers present
agpgart-via 0000:00:00.0: AGP 2.0 bridge
agpgart-via 0000:00:00.0: putting AGP V2 device into 4x mode
radeonfb 0000:01:00.0: putting AGP V2 device into 4x mode
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs

