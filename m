Return-Path: <linux-kernel-owner+w=401wt.eu-S933890AbXDCXi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbXDCXi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933945AbXDCXi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:38:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45246 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933890AbXDCXiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:38:24 -0400
Subject: Re: 2.6.21-rc5-mm4
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com>
	 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 16:38:27 -0700
Message-Id: <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 16:27 -0700, Christoph Lameter wrote:
> On Tue, 3 Apr 2007, Badari Pulavarty wrote:
> 
> > On Tue, 2007-04-03 at 14:55 -0700, Badari Pulavarty wrote:
> > > On Mon, 2007-04-02 at 22:47 -0700, Andrew Morton wrote:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> > > 
> > > 
> > > 
> > > SLUB code paniced my x86-64 box also :(
> > 
> > More on this panic.. line of code causing the issue is:
> > 
> > mm/slub.c:1133
> >     2df1:       49 8b 04 c4             mov    (%r12,%rax,8),%rax
> >     2df5:       48 89 43 20             mov    %rax,0x20(%rbx)
> >       
> > page->freelist = object[page->offset];
> > 
> > Hope this helps.
> 
> Yes. Could you boot with "slub_debug" set? Looks like a slab object may 
> be getting corrupted.
> 
> x86_64 with numa emulation 4 nodes boots fine here.

Not sure, if this helps any (slub_debug = 1) :(

Thanks,
Badari

Linux version 2.6.21-rc5-mm4 (root@elm3b29) (gcc version 4.1.0 (SUSE
Linux)) #2 SMP Tue Apr 3 17:36:21 PDT 2007
Command line: root=/dev/hda2 vga=0x314  selinux=0   console=tty0
console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent
showopts
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfef0000 (usable)
 BIOS-e820: 00000000dfef0000 - 00000000dfeff000 (ACPI data)
 BIOS-e820: 00000000dfeff000 - 00000000dff00000 (ACPI NVS)
 BIOS-e820: 00000000dff00000 - 00000000e0000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001e0000000 (usable)
end_pfn_map = 1966080
DMI 2.3 present.
ACPI: RSDP 000F6970, 0024 (r2 PTLTD )
ACPI: XSDT DFEFC625, 003C (r1 PTLTD      XSDT    6040000  LTP        0)
ACPI: FACP DFEFED02, 00F4 (r3 AMD    HAMMER    6040000 PTEC    F4240)
ACPI: DSDT DFEFC661, 262D (r1 AMD-K8  AMDACPI  6040000 MSFT  100000D)
ACPI: FACS DFEFFFC0, 0040
ACPI: SRAT DFEFEDF6, 0160 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: APIC DFEFEF56, 00AA (r1 PTLTD      APIC    6040000  LTP        0)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 1 -> APIC 1 -> Node 1
SRAT: PXM 2 -> APIC 2 -> Node 2
SRAT: PXM 3 -> APIC 3 -> Node 3
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 0-e0000000
SRAT: Node 0 PXM 0 0-180000000
SRAT: PXM 1 (100000000-1a0000000) overlaps with PXM 0 (0-180000000)
SRAT: SRAT not used.
Scanning NUMA topology in Northbridge 24
Number of nodes 4
Node 0 MemBase 0000000000000000 Limit 0000000180000000
Node 1 MemBase 0000000180000000 Limit 00000001a0000000
Node 2 MemBase 00000001a0000000 Limit 00000001c0000000
Node 3 MemBase 00000001c0000000 Limit 00000001e0000000
Using node hash shift of 29
Bootmem setup node 0 0000000000000000-0000000180000000
Bootmem setup node 1 0000000180000000-00000001a0000000
Bootmem setup node 2 00000001a0000000-00000001c0000000
Bootmem setup node 3 00000001c0000000-00000001e0000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1966080
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0:        0 ->      159
    0:      256 ->   917232
    0:   917248 ->   917504
    0:  1048576 ->  1572864
    1:  1572864 ->  1703936
    2:  1703936 ->  1835008
    3:  1835008 ->  1966080
ACPI: PM-Timer IO Port: 0x8008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xfa3e0000] gsi_base[24])
IOAPIC[1]: apic_id 5, address 0xfa3e0000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xfa3e1000] gsi_base[28])
IOAPIC[2]: apic_id 6, address 0xfa3e1000, GSI 28-31
ACPI: IOAPIC (id[0x07] address[0xfa3e2000] gsi_base[32])
IOAPIC[3]: apic_id 7, address 0xfa3e2000, GSI 32-35
ACPI: IOAPIC (id[0x08] address[0xfa3e4000] gsi_base[36])
IOAPIC[4]: apic_id 8, address 0xfa3e4000, GSI 36-39
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
PERCPU: Allocating 41984 bytes of per cpu data
Built 4 zonelists.  Total pages: 1771993
Kernel command line: root=/dev/hda2 vga=0x314  selinux=0   console=tty0
console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent
showopts
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
time.c: Detected 1398.191 MHz processor.
Console: colour dummy device 80x25
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 7021948k/7864320k available (3113k kernel code, 317632k
reserved, 1229k data, 364k init)
SLUB V6: General Slabs=18, HW alignment=128, Processors=4, Nodes=64
Calibrating delay using timer specific routine.. 2799.03 BogoMIPS
(lpj=5598079)
Security Framework v1.0.0 initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
Freeing SMP alternatives: 36k freed
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12483855
Detected 12.483 MHz APIC timer.
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 2796.59 BogoMIPS
(lpj=5593189)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 1
Opteron MP w/ 1MB stepping 00
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 2796.57 BogoMIPS
(lpj=5593147)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 2
Opteron MP w/ 1MB stepping 00
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 2796.56 BogoMIPS
(lpj=5593127)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 3
Opteron MP w/ 1MB stepping 00
Brought up 4 CPUs
migration_cost=0,766
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
0000:00:07.1: cannot adjust BAR0 (not I/O)
0000:00:07.1: cannot adjust BAR1 (not I/O)
0000:00:07.1: cannot adjust BAR2 (not I/O)
0000:00:07.1: cannot adjust BAR3 (not I/O)
ACPI: PCI Root Bridge [PCI1] (0000:08)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 *5 10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 5 10 *11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 14 devices
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
report
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
general protection fault: 0000 [1] <6>Time: tsc clocksource has been
installed.
SMP
last sysfs file:
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.21-rc5-mm4 #2
RIP: 0010:[<ffffffff802860e1>]  [<ffffffff802860e1>] kmem_cache_alloc
+0xc1/0x1a0RSP: 0000:ffff8101c031bdd0  EFLAGS: 00010006
RAX: 0000000000000000 RBX: ffff81017400e900 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 00000000000000d0 RDI: ffffffff8068dac0
RBP: ffff8101c031be00 R08: ffff810000180d3a R09: 0000000000000000
R10: ffff810000180c00 R11: 0000000000000100 R12: f000ff53f000ff53
R13: ffffffff8068dac0 R14: 0000000000000282 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff8063e000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
Process swapper (pid: 1, threadinfo ffff8101c031a000, task
ffff810000068000)
Stack:  00000000000000d0 00000000000000d0 ffffffff80601d60
000000000000000d
 ffffffff805991c5 ffffffff805991c5 ffff8101c031be20 ffffffff80286551
 ffffffffffffffed ffff810000180c00 ffff8101c031be50 ffffffff802a3642
Call Trace:
 [<ffffffff80286551>] __kmalloc+0x21/0x30
 [<ffffffff802a3642>] alloc_vfsmnt+0xd2/0x110
 [<ffffffff8028c4ac>] vfs_kern_mount+0x3c/0x160
 [<ffffffff8028c5e0>] kern_mount+0x10/0x20
 [<ffffffff806cef6b>] anon_inode_init+0x2b/0x130
 [<ffffffff806b2a04>] kernel_init+0x154/0x330
 [<ffffffff8020a8c8>] child_rip+0xa/0x12
 [<ffffffff806b28b0>] kernel_init+0x0/0x330
 [<ffffffff8020a8be>] child_rip+0x0/0x12


Code: 49 8b 04 c4 48 89 43 20 f0 0f ba 2b 02 8b 03 a8 01 74 4c f0
RIP  [<ffffffff802860e1>] kmem_cache_alloc+0xc1/0x1a0
 RSP <ffff8101c031bdd0>
Kernel panic - not syncing: Attempted to kill init!




