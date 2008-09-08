Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYIHRp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYIHRp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYIHRpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:45:13 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:46953 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYIHRpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:45:06 -0400
Date: Mon, 8 Sep 2008 19:52:08 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@linux.ie>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.27-rc5-mm1: 3 WARN_ON dumps during boot (acpi +
 vmap_pte_range)
Message-Id: <20080908195208.773ecadb.krzysztof.h1@poczta.fm>
In-Reply-To: <200809081937.16427.nickpiggin@yahoo.com.au>
References: <20080906084558.dff614d4.krzysztof.h1@poczta.fm>
	<20080905235014.fc31b2b0.akpm@linux-foundation.org>
	<200809081937.16427.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 98e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 19:37:16 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> 
> OK, would it be possible to test the following patch on the failing
> machine(s), and send me the complete dmesg trace afterwards, please?
> 
> The patch does a little bit of extra page table checking, and also
> prints a trace of operations on the vmap-space.
> 

The dmesg with Nick's patch below (now the third WARN_ON is
triggered in different module).

Regards,
Krzysztof

Linux version 2.6.27-rc5-mm1 (root@xxx) (gcc version 3.4.6) #2 SMP Mon Sep 8 17:49:16 CEST 2008
PAT WC disabled due to known CPU erratum.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 0000000020000000 (reserved)
last_pfn = 0x1fff0 max_arch_pfn = 0x100000
kernel direct mapping tables up to 1fff0000 @ 7000-d000
DMI 2.3 present.
ACPI: RSDP 000E0010, 0014 (r0 COMPAQ)
ACPI: RSDT 000E0080, 0040 (r1 COMPAQ CPQB154  20010410             0)
ACPI: FACP 000E00EC, 0074 (r1 COMPAQ CARMEL          1             0)
ACPI: DSDT 000E0230, 1B6C (r1 COMPAQ     DSDT        1 MSFT  100000D)
ACPI: FACS 000E0040, 0040
ACPI: APIC 000E0160, 0068 (r1 COMPAQ CARMEL          1             0)
ACPI: SSDT 000E1D9C, 005B (r1 COMPAQ   ZURICH        1 MSFT  100000D)
ACPI: SSDT 000E1FE8, 06A5 (r1 COMPAQ PNP_PRSS        1 MSFT  100000D)
ACPI: SSDT 000E3414, 005D (r1 COMPAQ     FHUB        1 MSFT  100000D)
ACPI: SSDT 000E268D, 0CBF (r1 COMPAQ  THERMAL        1 MSFT  100000D)
ACPI: SSDT 000E334C, 0024 (r1 COMPAQ       S1        1 MSFT  100000D)
511MB LOWMEM available.
  mapped low ram: 0 - 1fff0000
  low ram: 00000000 - 1fff0000
  bootmap 00002000 - 00006000
(8 early reservations) ==> bootmem [0000000000 - 001fff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00004dbb24]    TEXT DATA BSS ==> [0000100000 - 00004dbb24]
  #4 [00004dc000 - 00004df000]    INIT_PG_TABLE ==> [00004dc000 - 00004df000]
  #5 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #7 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 - 0000006000]
sizeof(struct page) = 32
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0001fff0
On node 0 totalpages: 130959
Node 0 memmap at 0xc1000000 size 4194304 first pfn 0xc1000000
free_area_init_node: node 0, pgdat c045d4a0, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 125968 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0xf808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 30000000 (gap: 20000000:e0000000)
dyn_array 0xc04b92a4 size:0x1c nr:32 align:0x1000
dyn_array 0xc04b92ac size:0xc nr:256 align:0x1000
dyn_array 0xc04ce274 size:0x60 nr:32 align:0x1000
dyn_array total_size: 0x3000
dyn_array 0xc04b92a4 ==> [0x1402000 - 0x1402380]
dyn_array 0xc04b92ac ==> [0x1403000 - 0x1403c00]
dyn_array 0xc04ce274 ==> [0x1404000 - 0x1404c00]
kstat_irqs ==> [0x1405000 - 0x1405100]
PERCPU: Allocating 32768 bytes of per cpu data
NR_CPUS: 4, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129935
Kernel command line: BOOT_IMAGE=Linux-test ro root=306 video=tridentfb:1024x768-8@75
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
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
CPU 0 irqstacks, hard=c04aa000 soft=c04a6000
PID hash table entries: 2048 (order: 11, 8192 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PMTIMER calibration value
Detected 863.926 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 515180k/524224k available (2583k kernel code, 8564k reserved, 892k data, 228k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
    vmalloc : 0xe07f0000 - 0xfffb7000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc046a000 - 0xc04a3000   ( 228 kB)
      .data : 0xc0385fe5 - 0xc04652b8   ( 892 kB)
      .text : 0xc0100000 - 0xc0385fe5   (2583 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 1727.85 BogoMIPS (lpj=3455704)
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080729
 0 add_pin_to_irq: irq 1 --> apic 0 pin 1
 0 add_pin_to_irq: irq 0 --> apic 0 pin 2
 0 add_pin_to_irq: irq 3 --> apic 0 pin 3
 0 add_pin_to_irq: irq 4 --> apic 0 pin 4
 0 add_pin_to_irq: irq 5 --> apic 0 pin 5
 0 add_pin_to_irq: irq 6 --> apic 0 pin 6
 0 add_pin_to_irq: irq 7 --> apic 0 pin 7
 0 add_pin_to_irq: irq 8 --> apic 0 pin 8
 0 add_pin_to_irq: irq 9 --> apic 0 pin 9
 0 add_pin_to_irq: irq 10 --> apic 0 pin 10
 0 add_pin_to_irq: irq 11 --> apic 0 pin 11
 0 add_pin_to_irq: irq 12 --> apic 0 pin 12
 0 add_pin_to_irq: irq 13 --> apic 0 pin 13
 0 add_pin_to_irq: irq 14 --> apic 0 pin 14
 0 add_pin_to_irq: irq 15 --> apic 0 pin 15
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel Pentium III (Coppermine) stepping 03
CPU 1 irqstacks, hard=c04ab000 soft=c04a7000
Booting processor 1/0 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 1727.95 BogoMIPS (lpj=3455918)
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU1: Intel Pentium III (Coppermine) stepping 03
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (3455.81 BogoMIPS).
net_namespace: 296 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xedb08, last bus=2
PCI: Using configuration type 1 for base access
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:465 sysfs_add_one+0x4c/0x50()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc5-mm1 #2
 [<c012530f>] warn_slowpath+0x6f/0xa0
 [<c03839b0>] __sched_text_start+0x2b0/0x4b0
 [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
 [<c01f6fc9>] sub_alloc+0x69/0x160
 [<c01f7175>] idr_get_empty_slot+0xb5/0x140
 [<c01f788f>] ida_get_new_above+0x3f/0x1b0
 [<c0383c65>] wait_for_common+0xb5/0x130
 [<c01b6620>] sysfs_ilookup_test+0x0/0x10
 [<c01b6620>] sysfs_ilookup_test+0x0/0x10
 [<c01b69ca>] sysfs_find_dirent+0x1a/0x30
 [<c01b66fc>] __sysfs_add_one+0x1c/0x80
 [<c01b67ac>] sysfs_add_one+0x4c/0x50
 [<c01b6a88>] create_dir+0x48/0xb0
 [<c01b6b39>] sysfs_create_dir+0x29/0x50
 [<c01f7d89>] create_dir+0x19/0x50
 [<c01f7fca>] kobject_add_internal+0x8a/0x120
 [<c01f809a>] kobject_set_name_vargs+0x3a/0x50
 [<c01f8192>] kobject_add_varg+0x22/0x60
 [<c01f8259>] kobject_init_and_add+0x29/0x30
 [<c04795db>] kernel_param_sysfs_setup+0x5b/0xc0
 [<c01b6a91>] create_dir+0x51/0xb0
 [<c047974e>] param_sysfs_builtin+0x10e/0x150
 [<c0479790>] param_sysfs_init+0x0/0x60
 [<c04797bc>] param_sysfs_init+0x2c/0x60
 [<c0471531>] mtrr_init_finialize+0x31/0x40
 [<c0101032>] _stext+0x32/0x180
 [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
 [<c011aeb4>] resched_task+0x54/0x60
 [<c011e76e>] try_to_wake_up+0x12e/0x140
 [<c0135211>] __create_workqueue_key+0x131/0x150
 [<c046a8d3>] do_initcalls+0x53/0xd0
 [<c046a9a0>] kernel_init+0x0/0xb0
 [<c046a9f5>] kernel_init+0x55/0xb0
 [<c0103f3b>] kernel_thread_helper+0x7/0x1c
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for acpi with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5-mm1 #2
 [<c01f8048>] kobject_add_internal+0x108/0x120
 [<c01f8192>] kobject_add_varg+0x22/0x60
 [<c01f8259>] kobject_init_and_add+0x29/0x30
 [<c04795db>] kernel_param_sysfs_setup+0x5b/0xc0
 [<c01b6a91>] create_dir+0x51/0xb0
 [<c047974e>] param_sysfs_builtin+0x10e/0x150
 [<c0479790>] param_sysfs_init+0x0/0x60
 [<c04797bc>] param_sysfs_init+0x2c/0x60
 [<c0471531>] mtrr_init_finialize+0x31/0x40
 [<c0101032>] _stext+0x32/0x180
 [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
 [<c011aeb4>] resched_task+0x54/0x60
 [<c011e76e>] try_to_wake_up+0x12e/0x140
 [<c0135211>] __create_workqueue_key+0x131/0x150
 [<c046a8d3>] do_initcalls+0x53/0xd0
 [<c046a9a0>] kernel_init+0x0/0xb0
 [<c046a9f5>] kernel_init+0x55/0xb0
 [<c0103f3b>] kernel_thread_helper+0x7/0x1c
 =======================
Module 'acpi' failed to be added to sysfs, error number -17
The system will be unstable now.
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region f800-f87f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region fa00-fa3f claimed by ICH4 GPIO
pci 0000:01:00.0: supports D1 D2
PCI: bridge 0000:00:01.0 32bit mmio: [fd000000, fe7fffff]
pci 0000:02:02.0: supports D1 D2
pci 0000:02:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:02.0: PME# disabled
pci 0000:02:0b.0: supports D2
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [5000, 5fff]
PCI: bridge 0000:00:1e.0 32bit mmio: [fcb00000, fcffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BUS1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11)
ACPI: Power Resource [PFN0] (on)
ACPI: Power Resource [PFN1] (on)
ACPI: Power Resource [PFN2] (on)
ACPI: Power Resource [PFN3] (on)
ACPI: Power Resource [PFN4] (on)
ACPI: Power Resource [PFN5] (on)
ACPI: Power Resource [PFN6] (on)
ACPI: Power Resource [PFN7] (on)
ACPI: Power Resource [PFN8] (on)
ACPI: Power Resource [PFN9] (on)
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:0d: io resource (0xf800-0xf81f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp 00:0d: io resource (0xf820-0xf83f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp 00:0d: io resource (0xf840-0xf85f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp 00:0d: io resource (0xf860-0xf87f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp 00:0d: io resource (0xfa00-0xfa1f) overlaps 0000:00:1f.0 BAR 8 (0xfa00-0xfa3f), disabling
pnp 00:0d: io resource (0xfa20-0xfa3f) overlaps 0000:00:1f.0 BAR 8 (0xfa00-0xfa3f), disabling
pnp 00:0e: mem resource (0x0-0x9ffff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:0e: mem resource (0xe0000-0xfffff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:0e: mem resource (0xd3600-0xd3fff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
ACPI: RTC can wake from S4
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0d: ioport range 0x400-0x41f has been reserved
system 00:0d: ioport range 0x420-0x43f has been reserved
system 00:0d: ioport range 0x440-0x45f has been reserved
system 00:0d: ioport range 0x460-0x47f has been reserved
system 00:0e: iomem range 0x100000-0x2000ffff could not be reserved
system 00:0e: iomem range 0xfff80000-0xffffffff has been reserved
system 00:0e: iomem range 0xfeea0000-0xfeebffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xfd000000-0xfe7fffff
pci 0000:00:01.0:   PREFETCH window: 0x00000030000000-0x000000300fffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0x5000-0x5fff
pci 0000:00:1e.0:   MEM window: 0xfcb00000-0xfcffffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000030100000-0x000000302fffff
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [fd000000, fe7fffff]
bus: 01 index 2 mmio: [30000000, 300fffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [5000, 5fff]
bus: 02 index 1 mmio: [fcb00000, fcffffff]
bus: 02 index 2 mmio: [30100000, 302fffff]
bus: 02 index 3 io port: [0, ffff]
bus: 02 index 4 mmio: [0, ffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
pci 0000:01:00.0: Boot video device
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e07f0000-e07f2000)
pci 0000:02:02.0: Firmware left e100 interrupts enabled; disabling
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PBTN]
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (27 C)
USB Universal Host Controller Interface driver v3.0
found new irq_cfg for irq 19
 0 add_pin_to_irq: irq 19 --> apic 0 pin 19
found new irq_desc for irq 19
uhci_hcd 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1f.2: setting latency timer to 64
uhci_hcd 0000:00:1f.2: UHCI Host Controller
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1f.2: irq 19, io base 0x00006440
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
alloc_vmap_area within(e07f0000-fffb7000) size=c000 returns=(e07f3000-e07ff000)
vmap_page_range (e07f3000-e07fe000 size=b000)
msgmni has been set to 1006
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
found new irq_cfg for irq 18
 0 add_pin_to_irq: irq 18 --> apic 0 pin 18
found new irq_desc for irq 18
tridentfb 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
alloc_vmap_area within(e07f0000-fffb7000) size=21000 returns=(e0800000-e0821000)
vunmap_page_range (e07f0000-e07f2000 size=2000)
free_vmap_area (e07f0000-e07f2000 size=2000)
tridentfb: framebuffer size = 8192 Kb
alloc_vmap_area within(e07f0000-fffb7000) size=801000 returns=(e0880000-e1081000)
Console: switching to colour frame buffer device 128x48
tridentfb: fb0: Trident frame buffer device 1024x768-8bpp
ACPI: Transitioning device [FN0] to D3
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FN0] (off)
ACPI: Transitioning device [FN1] to D3
fan PNP0C0B:01: registered as cooling_device1
ACPI: Fan [FN1] (off)
ACPI: Transitioning device [FN2] to D3
fan PNP0C0B:02: registered as cooling_device2
ACPI: Fan [FN2] (off)
ACPI: Transitioning device [FN3] to D3
fan PNP0C0B:03: registered as cooling_device3
ACPI: Fan [FN3] (off)
ACPI: Transitioning device [FN4] to D3
fan PNP0C0B:04: registered as cooling_device4
ACPI: Fan [FN4] (off)
ACPI: Transitioning device [FN5] to D3
fan PNP0C0B:05: registered as cooling_device5
ACPI: Fan [FN5] (off)
ACPI: Transitioning device [FN6] to D3
fan PNP0C0B:06: registered as cooling_device6
ACPI: Fan [FN6] (off)
ACPI: Transitioning device [FN7] to D3
fan PNP0C0B:07: registered as cooling_device7
ACPI: Fan [FN7] (off)
ACPI: Transitioning device [FN8] to D3
fan PNP0C0B:08: registered as cooling_device8
ACPI: Fan [FN8] (off)
fan PNP0C0B:09: registered as cooling_device9
ACPI: Fan [FN9] (on)
processor ACPI0007:00: registered as cooling_device10
processor ACPI0007:01: registered as cooling_device11
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e07f0000-e07f2000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e0822000-e0824000)
vunmap_page_range (e07f0000-e07f2000 size=2000)
free_vmap_area (e07f0000-e07f2000 size=2000)
Intel 82802 RNG detected
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel i840 Chipset
alloc_vmap_area within(e07f0000-fffb7000) size=5000 returns=(e07f0000-e07f5000)
------------[ cut here ]------------
WARNING: at mm/vmalloc.c:40 check_pte_range+0x83/0x90()
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5-mm1 #2
 [<c012526f>] warn_on_slowpath+0x5f/0x90
 [<c013c6d7>] atomic_notifier_call_chain+0x17/0x20
 [<c025a46d>] notify_update+0x1d/0x30
 [<c025e49c>] vt_console_print+0x23c/0x2f0
 [<c025e260>] vt_console_print+0x0/0x2f0
 [<c012582e>] __call_console_drivers+0x5e/0x70
 [<c0125954>] call_console_drivers+0x74/0x100
 [<c013c4b1>] up+0x11/0x40
 [<c012612a>] release_console_sem+0x6a/0x90
 [<c013e4f8>] getnstimeofday+0x38/0x150
 [<c0167533>] check_pte_range+0x83/0x90
 [<c016755a>] check_pmd_range+0x1a/0x30
 [<c0167575>] check_pud_range+0x5/0x10
 [<c01675c7>] check_page_range+0x47/0x60
 [<c0167c02>] alloc_vmap_area+0x192/0x1f0
 [<c0168726>] __get_vm_area_node+0xb6/0x170
 [<c0103df8>] apic_timer_interrupt+0x28/0x30
 [<c02605a2>] agp_backend_initialize+0x82/0x230
 [<c0168c95>] __vmalloc_node+0x85/0xb0
 [<c02605a2>] agp_backend_initialize+0x82/0x230
 [<c0168d01>] vmalloc+0x21/0x30
 [<c02605a2>] agp_backend_initialize+0x82/0x230
 [<c02605a2>] agp_backend_initialize+0x82/0x230
 [<c027f990>] __driver_attach+0x0/0xc0
 [<c02608b5>] agp_add_bridge+0x55/0x1a0
 [<c020975a>] pci_call_probe+0xa/0x10
 [<c02097ae>] __pci_device_probe+0x4e/0x60
 [<c02097e6>] pci_device_probe+0x26/0x60
 [<c027f7cb>] really_probe+0x9b/0x130
 [<c02096b0>] pci_match_device+0x10/0xb0
 [<c027f8af>] driver_probe_device+0x3f/0x60
 [<c027fa19>] __driver_attach+0x89/0xc0
 [<c027e719>] bus_for_each_dev+0x39/0x60
 [<c027fa66>] driver_attach+0x16/0x20
 [<c027f990>] __driver_attach+0x0/0xc0
 [<c027ef29>] bus_add_driver+0x109/0x1a0
 [<c01f87ed>] kset_find_obj+0x2d/0x60
 [<c0209860>] pci_device_shutdown+0x0/0x20
 [<c0209860>] pci_device_shutdown+0x0/0x20
 [<c027feff>] driver_register+0x3f/0xd0
 [<c0125b17>] printk+0x17/0x20
 [<c0482250>] agp_intel_init+0x0/0x20
 [<c02098c7>] __pci_register_driver+0x47/0x80
 [<c0482250>] agp_intel_init+0x0/0x20
 [<c0101032>] _stext+0x32/0x180
 [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
 [<c011aeb4>] resched_task+0x54/0x60
 [<c011e76e>] try_to_wake_up+0x12e/0x140
 [<c0135211>] __create_workqueue_key+0x131/0x150
 [<c046a8d3>] do_initcalls+0x53/0xd0
 [<c046a9a0>] kernel_init+0x0/0xb0
 [<c046a9f5>] kernel_init+0x55/0xb0
 [<c0103f3b>] kernel_thread_helper+0x7/0x1c
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
vmap_page_range (e07f0000-e07f4000 size=4000)
------------[ cut here ]------------
WARNING: at mm/vmalloc.c:162 vmap_pte_range+0xcb/0x100()
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5-mm1 #2
 [<c012526f>] warn_on_slowpath+0x5f/0x90
 [<c013c6d7>] atomic_notifier_call_chain+0x17/0x20
 [<c025a46d>] notify_update+0x1d/0x30
 [<c025e49c>] vt_console_print+0x23c/0x2f0
 [<c025e260>] vt_console_print+0x0/0x2f0
 [<c012582e>] __call_console_drivers+0x5e/0x70
 [<c0125954>] call_console_drivers+0x74/0x100
 [<c013c4b1>] up+0x11/0x40
 [<c012612a>] release_console_sem+0x6a/0x90
 [<c01677db>] vmap_pte_range+0xcb/0x100
 [<c016783d>] vmap_pmd_range+0x2d/0x40
 [<c016787d>] vmap_pud_range+0x2d/0x40
 [<c0167912>] vmap_page_range+0x82/0xa0
 [<c016864f>] map_vm_area+0x2f/0x50
 [<c0168b96>] __vmalloc_area_node+0xb6/0x110
 [<c0168c95>] __vmalloc_node+0x85/0xb0
 [<c02605a2>] agp_backend_initialize+0x82/0x230
 [<c0168d01>] vmalloc+0x21/0x30
 [<c02605a2>] agp_backend_initialize+0x82/0x230
 [<c02605a2>] agp_backend_initialize+0x82/0x230
 [<c027f990>] __driver_attach+0x0/0xc0
 [<c02608b5>] agp_add_bridge+0x55/0x1a0
 [<c020975a>] pci_call_probe+0xa/0x10
 [<c02097ae>] __pci_device_probe+0x4e/0x60
 [<c02097e6>] pci_device_probe+0x26/0x60
 [<c027f7cb>] really_probe+0x9b/0x130
 [<c02096b0>] pci_match_device+0x10/0xb0
 [<c027f8af>] driver_probe_device+0x3f/0x60
 [<c027fa19>] __driver_attach+0x89/0xc0
 [<c027e719>] bus_for_each_dev+0x39/0x60
 [<c027fa66>] driver_attach+0x16/0x20
 [<c027f990>] __driver_attach+0x0/0xc0
 [<c027ef29>] bus_add_driver+0x109/0x1a0
 [<c01f87ed>] kset_find_obj+0x2d/0x60
 [<c0209860>] pci_device_shutdown+0x0/0x20
 [<c0209860>] pci_device_shutdown+0x0/0x20
 [<c027feff>] driver_register+0x3f/0xd0
 [<c0125b17>] printk+0x17/0x20
 [<c0482250>] agp_intel_init+0x0/0x20
 [<c02098c7>] __pci_register_driver+0x47/0x80
 [<c0482250>] agp_intel_init+0x0/0x20
 [<c0101032>] _stext+0x32/0x180
 [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
 [<c011aeb4>] resched_task+0x54/0x60
 [<c011e76e>] try_to_wake_up+0x12e/0x140
 [<c0135211>] __create_workqueue_key+0x131/0x150
 [<c046a8d3>] do_initcalls+0x53/0xd0
 [<c046a9a0>] kernel_init+0x0/0xb0
 [<c046a9f5>] kernel_init+0x55/0xb0
 [<c0103f3b>] kernel_thread_helper+0x7/0x1c
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
agpgart-intel 0000:00:00.0: can't allocate memory for key lists
vunmap_page_range (e07f0000-e07f5000 size=5000)
free_vmap_area (e07f0000-e07f5000 size=5000)
agpgart-intel 0000:00:00.0: agp_backend_initialize() failed
agpgart-intel: probe of 0000:00:00.0 failed with error -12
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
loop: module loaded
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x2411 rev 0x02)
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x6460-0x6467
    ide1: BM-DMA at 0x6468-0x646f
Probing IDE interface ide0...
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
hda: SAMSUNG SP0411N, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/66 mode selected
Probing IDE interface ide1...
hdc: ATAPI DVD A DH20A3H, ATAPI CD/DVD-ROM drive
hdd: Compaq CRD-8402B, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/66 mode selected
hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdd: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 512KiB
hda: 78242976 sectors (40060 MB) w/2048KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2 < hda5 hda6 hda7 > hda3
hdc: ATAPI 12X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 48X CD-ROM drive, 128kB Cache
Driver 'sd' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, native irqs
i2c /dev entries driver
found new irq_cfg for irq 17
 0 add_pin_to_irq: irq 17 --> apic 0 pin 17
found new irq_desc for irq 17
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
input: ImExPS/2 Generic Explorer Mouse as /class/input/input3
iTCO_wdt: Found a ICH TCO device (Version=1, TCOBASE=0xf860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
cpuidle: using governor ladder
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.18rc1.
ALSA device list:
  No soundcards found.
TCP cubic registered
Using IPI No-Shortcut mode
rtc_cmos 00:03: setting system clock to 2008-09-08 19:42:21 UTC (1220902941)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 228k freed
EXT3 FS on hda6, internal journal
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e07f0000-e07f2000)
vmap_page_range (e07f0000-e07f1000 size=1000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e0825000-e0827000)
vmap_page_range (e0825000-e0826000 size=1000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e0828000-e082a000)
vmap_page_range (e0828000-e0829000 size=1000)
alloc_vmap_area within(e07f0000-fffb7000) size=14000 returns=(e082b000-e083f000)
vmap_page_range (e082b000-e083e000 size=13000)
alloc_vmap_area within(e07f0000-fffb7000) size=f000 returns=(e0840000-e084f000)
vmap_page_range (e0840000-e084e000 size=e000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e0850000-e0852000)
vmap_page_range (e0850000-e0851000 size=1000)
Floppy drive(s): fd0 is 1.44M
alloc_vmap_area within(e07f0000-fffb7000) size=e000 returns=(e0853000-e0861000)
vmap_page_range (e0853000-e0860000 size=d000)
alloc_vmap_area within(e07f0000-fffb7000) size=b000 returns=(e0862000-e086d000)
vmap_page_range (e0862000-e086c000 size=a000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e086e000-e0870000)
vmap_page_range (e086e000-e086f000 size=1000)
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7<6>FDC 0 is a post-1991 82077
, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
alloc_vmap_area within(e07f0000-fffb7000) size=4000 returns=(e0871000-e0875000)
vmap_page_range (e0871000-e0874000 size=3000)
alloc_vmap_area within(e07f0000-fffb7000) size=3000 returns=(e0876000-e0879000)
vmap_page_range (e0876000-e0878000 size=2000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e087a000-e087c000)
vmap_page_range (e087a000-e087b000 size=1000)
alloc_vmap_area within(e07f0000-fffb7000) size=20000 returns=(e1082000-e10a2000)
vmap_page_range (e1082000-e10a1000 size=1f000)
alloc_vmap_area within(e07f0000-fffb7000) size=1a000 returns=(e10a3000-e10bd000)
vmap_page_range (e10a3000-e10bc000 size=19000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e087d000-e087f000)
vmap_page_range (e087d000-e087e000 size=1000)
alloc_vmap_area within(e07f0000-fffb7000) size=7000 returns=(e10be000-e10c5000)
vmap_page_range (e10be000-e10c4000 size=6000)
alloc_vmap_area within(e07f0000-fffb7000) size=6000 returns=(e10c6000-e10cc000)
vmap_page_range (e10c6000-e10cb000 size=5000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e10cd000-e10cf000)
vmap_page_range (e10cd000-e10ce000 size=1000)
alloc_vmap_area within(e07f0000-fffb7000) size=8000 returns=(e10d0000-e10d8000)
vmap_page_range (e10d0000-e10d7000 size=7000)
alloc_vmap_area within(e07f0000-fffb7000) size=7000 returns=(e10d9000-e10e0000)
vmap_page_range (e10d9000-e10df000 size=6000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e10e1000-e10e3000)
vmap_page_range (e10e1000-e10e2000 size=1000)
de2104x PCI Ethernet driver v0.7 (Mar 17, 2004)
de2104x 0000:02:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e10e4000-e10e6000)
vunmap_page_range (e07f0000-e07f2000 size=2000)
vunmap_page_range (e0828000-e082a000 size=2000)
vunmap_page_range (e082b000-e083f000 size=14000)
vunmap_page_range (e0850000-e0852000 size=2000)
vunmap_page_range (e0853000-e0861000 size=e000)
vunmap_page_range (e0871000-e0875000 size=4000)
vunmap_page_range (e087a000-e087c000 size=2000)
vunmap_page_range (e087d000-e087f000 size=2000)
vunmap_page_range (e1082000-e10a2000 size=20000)
vunmap_page_range (e10be000-e10c5000 size=7000)
vunmap_page_range (e10cd000-e10cf000 size=2000)
vunmap_page_range (e10d0000-e10d8000 size=8000)
free_vmap_area (e07f0000-e07f2000 size=2000)
free_vmap_area (e0828000-e082a000 size=2000)
free_vmap_area (e082b000-e083f000 size=14000)
free_vmap_area (e0850000-e0852000 size=2000)
free_vmap_area (e0853000-e0861000 size=e000)
free_vmap_area (e0871000-e0875000 size=4000)
free_vmap_area (e087a000-e087c000 size=2000)
free_vmap_area (e087d000-e087f000 size=2000)
free_vmap_area (e1082000-e10a2000 size=20000)
free_vmap_area (e10be000-e10c5000 size=7000)
free_vmap_area (e10cd000-e10cf000 size=2000)
free_vmap_area (e10d0000-e10d8000 size=8000)
de0: SROM leaf offset 30, default media 10baseT auto
de0:   media block #0: 10baseT-FD
de0:   media block #1: BNC
de0:   media block #2: 10baseT-HD
eth0: 21041 at 0xe10e4000, 00:80:c8:e8:5f:b9, IRQ 18
alloc_vmap_area within(e07f0000-fffb7000) size=4000 returns=(e07f0000-e07f4000)
vmap_page_range (e07f0000-e07f3000 size=3000)
alloc_vmap_area within(e07f0000-fffb7000) size=3000 returns=(e0828000-e082b000)
vmap_page_range (e0828000-e082a000 size=2000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e082c000-e082e000)
vmap_page_range (e082c000-e082d000 size=1000)
alloc_vmap_area within(e07f0000-fffb7000) size=b000 returns=(e082f000-e083a000)
vmap_page_range (e082f000-e0839000 size=a000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e0850000-e0859000)
vmap_page_range (e0850000-e0858000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e083b000-e083d000)
vmap_page_range (e083b000-e083c000 size=1000)
Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Intel ICH 0000:00:1f.5: setting latency timer to 64
alloc_vmap_area within(e07f0000-fffb7000) size=b000 returns=(e1082000-e108d000)
vmap_page_range (e1082000-e108c000 size=a000)
alloc_vmap_area within(e07f0000-fffb7000) size=a000 returns=(e108e000-e1098000)
vmap_page_range (e108e000-e1097000 size=9000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e085a000-e085c000)
vmap_page_range (e085a000-e085b000 size=1000)
intel8x0_measure_ac97_clock: measured 53920 usecs
intel8x0: clocking to 48000
au8820 0000:02:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
alloc_vmap_area within(e07f0000-fffb7000) size=21000 returns=(e1100000-e1121000)
vunmap_page_range (e07f0000-e07f4000 size=4000)
vunmap_page_range (e082c000-e082e000 size=2000)
vunmap_page_range (e082f000-e083a000 size=b000)
vunmap_page_range (e083b000-e083d000 size=2000)
vunmap_page_range (e086e000-e0870000 size=2000)
vunmap_page_range (e1082000-e108d000 size=b000)
vunmap_page_range (e10e1000-e10e3000 size=2000)
free_vmap_area (e07f0000-e07f4000 size=4000)
free_vmap_area (e082c000-e082e000 size=2000)
free_vmap_area (e082f000-e083a000 size=b000)
free_vmap_area (e083b000-e083d000 size=2000)
free_vmap_area (e086e000-e0870000 size=2000)
free_vmap_area (e1082000-e108d000 size=b000)
free_vmap_area (e10e1000-e10e3000 size=2000)
Vortex: init.... <6>done.
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e07f0000-e0801000)
vmap_page_range (e07f0000-e0800000 size=10000)
------------[ cut here ]------------
WARNING: at mm/vmalloc.c:162 vmap_pte_range+0xcb/0x100()
Modules linked in: snd_au8820(+) snd_intel8x0 snd_mpu401_uart de2104x snd_rawmidi snd_ac97_codec snd_seq_device parport_pc floppy ac97_bus
Pid: 821, comm: modprobe Tainted: G        W 2.6.27-rc5-mm1 #2
 [<c012526f>] warn_on_slowpath+0x5f/0x90
 [<c013b832>] hrtimer_interrupt+0x142/0x1b0
 [<c011210f>] local_apic_timer_interrupt+0x4f/0x60
 [<c011214d>] smp_apic_timer_interrupt+0x2d/0x40
 [<c0103df8>] apic_timer_interrupt+0x28/0x30
 [<c013007b>] kill_something_info+0x10b/0x120
 [<c0125cab>] vprintk+0x11b/0x230
 [<c016755a>] check_pmd_range+0x1a/0x30
 [<c01677db>] vmap_pte_range+0xcb/0x100
 [<c016783d>] vmap_pmd_range+0x2d/0x40
 [<c016787d>] vmap_pud_range+0x2d/0x40
 [<c0167912>] vmap_page_range+0x82/0xa0
 [<c016864f>] map_vm_area+0x2f/0x50
 [<c0168ac4>] vmap+0x34/0x50
 [<c031615f>] snd_malloc_sgbuf_pages+0x17f/0x230
 [<c030b8c6>] snd_pcm_new_stream+0x126/0x210
 [<c0315727>] snd_dma_alloc_pages+0x117/0x150
 [<c0314d9f>] preallocate_pcm_pages+0x4f/0x70
 [<c03150f5>] snd_pcm_lib_preallocate_pages1+0xc5/0xe0
 [<c031517a>] snd_pcm_lib_preallocate_pages_for_all+0x3a/0x60
 [<c027f990>] __driver_attach+0x0/0xc0
 [<e1092b3e>] snd_vortex_new_pcm+0xce/0x160 [snd_au8820]
 [<e109331a>] snd_vortex_probe+0xea/0x1f0 [snd_au8820]
 [<c020975a>] pci_call_probe+0xa/0x10
 [<c02097ae>] __pci_device_probe+0x4e/0x60
 [<c02097e6>] pci_device_probe+0x26/0x60
 [<c027f7cb>] really_probe+0x9b/0x130
 [<c03846cd>] __down+0x4d/0x80
 [<c02096b0>] pci_match_device+0x10/0xb0
 [<c027f8af>] driver_probe_device+0x3f/0x60
 [<c027fa19>] __driver_attach+0x89/0xc0
 [<c027e719>] bus_for_each_dev+0x39/0x60
 [<c027fa66>] driver_attach+0x16/0x20
 [<c027f990>] __driver_attach+0x0/0xc0
 [<c027ef29>] bus_add_driver+0x109/0x1a0
 [<c01f87ed>] kset_find_obj+0x2d/0x60
 [<c0209860>] pci_device_shutdown+0x0/0x20
 [<c0209860>] pci_device_shutdown+0x0/0x20
 [<c027feff>] driver_register+0x3f/0xd0
 [<e085a000>] alsa_card_vortex_init+0x0/0x14 [snd_au8820]
 [<c02098c7>] __pci_register_driver+0x47/0x80
 [<e085a000>] alsa_card_vortex_init+0x0/0x14 [snd_au8820]
 [<c0101032>] _stext+0x32/0x180
 [<c0149ced>] sys_init_module+0xed/0x1a0
 [<c0178311>] sys_read+0x41/0x70
 [<c01031fa>] syscall_call+0x7/0xb
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e082c000-e0835000)
vmap_page_range (e082c000-e0834000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e10e7000-e10f8000)
vmap_page_range (e10e7000-e10f7000 size=10000)
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e1122000-e1133000)
vmap_page_range (e1122000-e1132000 size=10000)
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e1134000-e1145000)
vmap_page_range (e1134000-e1144000 size=10000)
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e1146000-e1157000)
vmap_page_range (e1146000-e1156000 size=10000)
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e1158000-e1169000)
vmap_page_range (e1158000-e1168000 size=10000)
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e116a000-e117b000)
vmap_page_range (e116a000-e117a000 size=10000)
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e117c000-e118d000)
vmap_page_range (e117c000-e118c000 size=10000)
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e118e000-e119f000)
vmap_page_range (e118e000-e119e000 size=10000)
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e11a0000-e11b1000)
vmap_page_range (e11a0000-e11b0000 size=10000)
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e11b2000-e11c3000)
vmap_page_range (e11b2000-e11c2000 size=10000)
alloc_vmap_area within(e07f0000-fffb7000) size=11000 returns=(e11c4000-e11d5000)
vmap_page_range (e11c4000-e11d4000 size=10000)
gameport: AU88x0 Gameport is pci0000:02:0b.0/gameport0, speed 1387kHz
alloc_vmap_area within(e07f0000-fffb7000) size=28000 returns=(e11d6000-e11fe000)
vmap_page_range (e11d6000-e11fd000 size=27000)
alloc_vmap_area within(e07f0000-fffb7000) size=1f000 returns=(e11ff000-e121e000)
vmap_page_range (e11ff000-e121d000 size=1e000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e0836000-e0838000)
vmap_page_range (e0836000-e0837000 size=1000)
aic7xxx 0000:02:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e083a000-e083c000)
vunmap_page_range (e07f0000-e0801000 size=11000)
vunmap_page_range (e085a000-e085c000 size=2000)
vunmap_page_range (e11d6000-e11fe000 size=28000)
free_vmap_area (e07f0000-e0801000 size=11000)
free_vmap_area (e085a000-e085c000 size=2000)
free_vmap_area (e11d6000-e11fe000 size=28000)
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec aic7892 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi 0:0:0:0: Direct-Access     COMPAQ   BD009222BB       3B09 PQ: 0 ANSI: 2
scsi0:A:0:0: Tagged Queuing enabled.  Depth 64
 target0:0:0: Beginning Domain Validation
 target0:0:0: wide asynchronous
 target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
sd 0:0:0:0: [sda] 17773524 512-byte hardware sectors (9100 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: f3 00 10 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:0: [sda] 17773524 512-byte hardware sectors (9100 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: f3 00 10 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
alloc_vmap_area within(e07f0000-fffb7000) size=a000 returns=(e07f0000-e07fa000)
vmap_page_range (e07f0000-e07f9000 size=9000)
alloc_vmap_area within(e07f0000-fffb7000) size=8000 returns=(e1082000-e108a000)
vmap_page_range (e1082000-e1089000 size=7000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e083d000-e083f000)
vmap_page_range (e083d000-e083e000 size=1000)
sd 0:0:0:0: Attached scsi generic sg0 type 0
alloc_vmap_area within(e07f0000-fffb7000) size=5000 returns=(e085a000-e085f000)
vmap_page_range (e085a000-e085e000 size=4000)
alloc_vmap_area within(e07f0000-fffb7000) size=4000 returns=(e086e000-e0872000)
vmap_page_range (e086e000-e0871000 size=3000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e0873000-e0875000)
vmap_page_range (e0873000-e0874000 size=1000)
alloc_vmap_area within(e07f0000-fffb7000) size=5000 returns=(e087a000-e087f000)
vmap_page_range (e087a000-e087e000 size=4000)
alloc_vmap_area within(e07f0000-fffb7000) size=4000 returns=(e1099000-e109d000)
vmap_page_range (e1099000-e109c000 size=3000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e108b000-e108d000)
vmap_page_range (e108b000-e108c000 size=1000)
lp0: using parport0 (interrupt-driven).
alloc_vmap_area within(e07f0000-fffb7000) size=86000 returns=(e121f000-e12a5000)
vmap_page_range (e121f000-e12a4000 size=85000)
alloc_vmap_area within(e07f0000-fffb7000) size=78000 returns=(e12a6000-e131e000)
vmap_page_range (e12a6000-e131d000 size=77000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e109e000-e10a0000)
vmap_page_range (e109e000-e109f000 size=1000)
SGI XFS with security attributes, no debug enabled
XFS mounting filesystem hda7
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e10cd000-e10d6000)
vmap_page_range (e10cd000-e10d5000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e11d6000-e11df000)
vmap_page_range (e11d6000-e11de000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e11e0000-e11e9000)
vmap_page_range (e11e0000-e11e8000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e11ea000-e11f3000)
vmap_page_range (e11ea000-e11f2000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e11f4000-e11fd000)
vmap_page_range (e11f4000-e11fc000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e131f000-e1328000)
vmap_page_range (e131f000-e1327000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e1329000-e1332000)
vmap_page_range (e1329000-e1331000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e1333000-e133c000)
vmap_page_range (e1333000-e133b000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=81000 returns=(e133d000-e13be000)
vmap_page_range (e133d000-e13bd000 size=80000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e13bf000-e13c8000)
vmap_page_range (e13bf000-e13c7000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=81000 returns=(e13c9000-e144a000)
vmap_page_range (e13c9000-e1449000 size=80000)
Ending clean XFS mount for filesystem: hda7
XFS mounting filesystem sda1
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e144b000-e1454000)
vmap_page_range (e144b000-e1453000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e1455000-e145e000)
vmap_page_range (e1455000-e145d000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e145f000-e1468000)
vmap_page_range (e145f000-e1467000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e1469000-e1472000)
vmap_page_range (e1469000-e1471000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e1473000-e147c000)
vmap_page_range (e1473000-e147b000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e147d000-e1486000)
vmap_page_range (e147d000-e1485000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e1487000-e1490000)
vmap_page_range (e1487000-e148f000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e1491000-e149a000)
vmap_page_range (e1491000-e1499000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=81000 returns=(e149b000-e151c000)
vmap_page_range (e149b000-e151b000 size=80000)
alloc_vmap_area within(e07f0000-fffb7000) size=9000 returns=(e151d000-e1526000)
vmap_page_range (e151d000-e1525000 size=8000)
alloc_vmap_area within(e07f0000-fffb7000) size=81000 returns=(e1527000-e15a8000)
vmap_page_range (e1527000-e15a7000 size=80000)
Ending clean XFS mount for filesystem: sda1
alloc_vmap_area within(e07f0000-fffb7000) size=31000 returns=(e15a9000-e15da000)
vmap_page_range (e15a9000-e15d9000 size=30000)
alloc_vmap_area within(e07f0000-fffb7000) size=2a000 returns=(e15db000-e1605000)
vmap_page_range (e15db000-e1604000 size=29000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e10be000-e10c0000)
vmap_page_range (e10be000-e10bf000 size=1000)
JFS: nTxBlock = 4027, nTxLock = 32218
alloc_vmap_area within(e07f0000-fffb7000) size=5c000 returns=(e1606000-e1662000)
vmap_page_range (e1606000-e1661000 size=5b000)
alloc_vmap_area within(e07f0000-fffb7000) size=1f9000 returns=(e1663000-e185c000)
vmap_page_range (e1663000-e185b000 size=1f8000)
alloc_vmap_area within(e07f0000-fffb7000) size=3000 returns=(e10c1000-e10c4000)
vmap_page_range (e10c1000-e10c3000 size=2000)
alloc_vmap_area within(e07f0000-fffb7000) size=3000 returns=(e10f9000-e10fc000)
vmap_page_range (e10f9000-e10fb000 size=2000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e10e1000-e10e3000)
vmap_page_range (e10e1000-e10e2000 size=1000)
alloc_vmap_area within(e07f0000-fffb7000) size=7000 returns=(e185d000-e1864000)
vmap_page_range (e185d000-e1863000 size=6000)
alloc_vmap_area within(e07f0000-fffb7000) size=6000 returns=(e1865000-e186b000)
vmap_page_range (e1865000-e186a000 size=5000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e10fd000-e10ff000)
vmap_page_range (e10fd000-e10fe000 size=1000)
NET: Registered protocol family 17
eth0: enabling interface
eth0: set link 10baseT auto
eth0:    mode 0x7ffc0040, sia 0x12c4,0xffffef01,0xffffffff,0xffff0008
eth0:    set mode 0x7ffc0040, set sia 0xef01,0xffff,0x8
eth0: link up, media 10baseT auto
alloc_vmap_area within(e07f0000-fffb7000) size=3000 returns=(e186c000-e186f000)
vmap_page_range (e186c000-e186e000 size=2000)
alloc_vmap_area within(e07f0000-fffb7000) size=3000 returns=(e1870000-e1873000)
vmap_page_range (e1870000-e1872000 size=2000)
alloc_vmap_area within(e07f0000-fffb7000) size=31000 returns=(e1874000-e18a5000)
vmap_page_range (e1874000-e18a4000 size=30000)
alloc_vmap_area within(e07f0000-fffb7000) size=2c000 returns=(e18a6000-e18d2000)
vmap_page_range (e18a6000-e18d1000 size=2b000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e18d3000-e18d5000)
vmap_page_range (e18d3000-e18d4000 size=1000)
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
alloc_vmap_area within(e07f0000-fffb7000) size=15000 returns=(e18d6000-e18eb000)
vmap_page_range (e18d6000-e18ea000 size=14000)
alloc_vmap_area within(e07f0000-fffb7000) size=12000 returns=(e18ec000-e18fe000)
vmap_page_range (e18ec000-e18fd000 size=11000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e18ff000-e1901000)
vmap_page_range (e18ff000-e1900000 size=1000)
alloc_vmap_area within(e07f0000-fffb7000) size=1c000 returns=(e1902000-e191e000)
vmap_page_range (e1902000-e191d000 size=1b000)
alloc_vmap_area within(e07f0000-fffb7000) size=18000 returns=(e191f000-e1937000)
vmap_page_range (e191f000-e1936000 size=17000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e1938000-e193a000)
vmap_page_range (e1938000-e1939000 size=1000)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
alloc_vmap_area within(e07f0000-fffb7000) size=6000 returns=(e193b000-e1941000)
vmap_page_range (e193b000-e1940000 size=5000)
alloc_vmap_area within(e07f0000-fffb7000) size=5000 returns=(e1942000-e1947000)
vmap_page_range (e1942000-e1946000 size=4000)
alloc_vmap_area within(e07f0000-fffb7000) size=2000 returns=(e1948000-e194a000)
vmap_page_range (e1948000-e1949000 size=1000)

----------------------------------------------------------------------
Tanie polaczenia z Polska i ze swiatem
Sprawdz >>  http://link.interia.pl/f1f00 


