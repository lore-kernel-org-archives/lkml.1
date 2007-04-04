Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbXDDWxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbXDDWxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXDDWxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:53:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53711 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbXDDWxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:53:01 -0400
Subject: Re: 2.6.21-rc5-mm4 (SLUB)
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704041120250.793@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com>
	 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com>
	 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com>
	 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com>
	 <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704040946370.24640@schroedinger.engr.sgi.com>
	 <1175709755.6185.34.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0704041120250.793@schroedinger.engr.sgi.com>
Content-Type: multipart/mixed; boundary="=-7JMeEWhMeDiDTw6a0XBI"
Date: Wed, 04 Apr 2007 15:53:04 -0700
Message-Id: <1175727185.5019.8.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7JMeEWhMeDiDTw6a0XBI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2007-04-04 at 11:22 -0700, Christoph Lameter wrote:
> On Wed, 4 Apr 2007, Christoph Lameter wrote:
> 
> > Yes. slub_debug=U. But user tracking may need to increase the slab 
> > size (depends on the padding available in the slab) to store the 
> > tracking information, so you may not get the same corruption.
> 
> Hummm U is switching off merging and you may need merging to trigger the 
> discovery of the overwrite.
> 
> Here is a patch to enable merging even while tracking slabs. This patch 
> should not be applied to mm. In general tracking requires knowing which
> slab the objects come from and merging looses that information.
> 
> Index: linux-2.6.21-rc5-mm4/mm/slub.c
> ===================================================================
> --- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-04 11:19:29.000000000 -0700
> +++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-04 11:19:35.000000000 -0700
> @@ -86,7 +86,7 @@
>  /*
>   * Set of flags that will prevent slab merging
>   */
> -#define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
> +#define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | \
>  		SLAB_TRACE | SLAB_DESTROY_BY_RCU)
>  
>  #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
> 

Here is the slub_debug=FU output with the above patch.

Thanks,
Badari



--=-7JMeEWhMeDiDTw6a0XBI
Content-Disposition: attachment; filename="slub_debug=FU"
Content-Type: text/plain; name="slub_debug=FU"; charset=utf-8
Content-Transfer-Encoding: 8bit

Linux version 2.6.21-rc5-mm4 (root@elm3b29) (gcc version 4.1.0 (SUSE Linux)) #6 SMP Wed Apr 4 16:52:03 PDT 2007
Command line: root=/dev/hda2 vga=0x314  slub_debug=FU selinux=0   console=tty0 console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent showopts
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
ACPI: XSDT DFEFC625, 003C (r1 PTLTD  	 XSDT    6040000  LTP        0)
ACPI: FACP DFEFED02, 00F4 (r3 AMD    HAMMER    6040000 PTEC    F4240)
ACPI: DSDT DFEFC661, 262D (r1 AMD-K8  AMDACPI  6040000 MSFT  100000D)
ACPI: FACS DFEFFFC0, 0040
ACPI: SRAT DFEFEDF6, 0160 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: APIC DFEFEF56, 00AA (r1 PTLTD  	 APIC    6040000  LTP        0)
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
Kernel command line: root=/dev/hda2 vga=0x314  slub_debug=FU selinux=0   console=tty0 console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent showopts
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
time.c: Detected 1398.178 MHz processor.
Console: colour dummy device 80x25
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 7021948k/7864320k available (3113k kernel code, 317632k reserved, 1229k data, 364k init)
SLUB V6: General Slabs=18, HW alignment=128, Processors=4, Nodes=64
Calibrating delay using timer specific routine.. 2799.04 BogoMIPS (lpj=5598086)
Security Framework v1.0.0 initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
*** SLUB: Freepointer corrupt in kmalloc-32@0xffff810180033190 Slab 0xffff81019f001980
    offset=400 flags=0x6000000000000c7 inuse=5 freelist=0xffff810180033190
  Bytes b4 0xffff810180033180:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff810180033190:  91 65 28 80 ff ff ff ff 00 00 00 00 00 00 00 00 .e(.ÿÿÿÿ........
    Object 0xffff8101800331a0:  62 db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 bÛþÿ............
    Object 0xffff8101800331b0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101800331c0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101800331d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff810180033190 -> 0xffffffff80286591
Last alloc: 0xffff810180033230 jiffies since=4294892386 cpu=0 pid=0
    Filler 0xffff810180033210:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810180033220:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810180033230:  80 32 03 80 01 81 ff ff 00 00 00 00 00 00 00 00 .2....ÿÿ........
    Filler 0xffff810180033240:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810180033250:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810180033260:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810180033270:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810180033280:  d0 32 03 80 01 81 ff ff 00 00 00 00 00 00 00 00 Ð2....ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff802861d9>] kmem_cache_zalloc+0x19/0x40
 [<ffffffff802db6ad>] __sysfs_new_dirent+0x1d/0x60
 [<ffffffff802db8bc>] __sysfs_make_dirent+0x2c/0xb0
 [<ffffffff802db965>] sysfs_make_dirent+0x25/0x50
 [<ffffffff802dbd64>] create_dir+0xc4/0x200
 [<ffffffff802dbecd>] sysfs_create_dir+0x2d/0x80
 [<ffffffff803902fa>] kobject_get+0x1a/0x30
 [<ffffffff803905a9>] kobject_shadow_add+0xb9/0x1e0
 [<ffffffff803906db>] kobject_add+0xb/0x10
 [<ffffffff803906f4>] kset_add+0x14/0x30
 [<ffffffff80390aa3>] subsystem_register+0x23/0x40
 [<ffffffff806ce96d>] mnt_init+0xed/0x240
 [<ffffffff806ce4d9>] vfs_caches_init+0xd9/0x180
 [<ffffffff806b27fb>] start_kernel+0x21b/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

*** SLUB: Freepointer corrupt in kmalloc-16@0xffff810173c00440 Slab 0xffff81017f9e0000
    offset=1088 flags=0x2000000000000c7 inuse=17 freelist=0xffff810173c00440
  Bytes b4 0xffff810173c00430:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff810173c00440:  1f 65 28 80 ff ff ff ff 00 00 00 00 00 00 00 00 .e(.ÿÿÿÿ........
    Object 0xffff810173c00450:  5e db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 ^Ûþÿ............
    Object 0xffff810173c00460:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff810173c00470:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff810173c00440 -> 0xffffffff8028651f
Last alloc: 0xffff810173c004c0 jiffies since=4294892387 cpu=0 pid=0
    Filler 0xffff810173c004b0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173c004c0:  00 05 c0 73 01 81 ff ff 00 e8 3a 80 01 81 ff ff ..Às..ÿÿ.è:...ÿÿ
    Filler 0xffff810173c004d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173c004e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173c004f0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173c00500:  40 05 c0 73 01 81 ff ff 00 00 00 00 00 00 00 00 @.Às..ÿÿ........
    Filler 0xffff810173c00510:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173c00520:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff80286551>] __kmalloc+0x21/0x30
 [<ffffffff802d0f5d>] proc_symlink+0x4d/0xb0
 [<ffffffff802d3020>] execdomains_read_proc+0x0/0x60
 [<ffffffff806cf4e5>] proc_misc_init+0x75/0x210
 [<ffffffff806cf334>] proc_root_init+0x44/0xf0
 [<ffffffff806b280f>] start_kernel+0x22f/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
*** SLUB: Freepointer corrupt in kmalloc-32@0xffff8101802fd050 Slab 0xffff81019f017e80
    offset=80 flags=0x6000000000000c7 inuse=1 freelist=0xffff8101802fd050
  Bytes b4 0xffff8101802fd040:  00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 ................
    Object 0xffff8101802fd050:  d9 61 28 80 ff ff ff ff 00 00 00 00 00 00 00 00 Ùa(.ÿÿÿÿ........
    Object 0xffff8101802fd060:  63 db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 cÛþÿ............
    Object 0xffff8101802fd070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101802fd080:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101802fd090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff8101802fd050 -> 0xffffffff802861d9
Last alloc: 0xffff8101802fd0f0 jiffies since=4294892391 cpu=0 pid=0
    Filler 0xffff8101802fd0d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101802fd0e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101802fd0f0:  40 d1 2f 80 01 81 ff ff 00 00 00 00 00 00 00 00 @Ñ/...ÿÿ........
    Filler 0xffff8101802fd100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101802fd110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101802fd120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101802fd130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101802fd140:  90 d1 2f 80 01 81 ff ff 00 00 00 00 00 00 00 00 .Ñ/...ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff80286551>] __kmalloc+0x21/0x30
 [<ffffffff806bdbc0>] mtrr_bp_init+0xd0/0x1e0
 [<ffffffff806babca>] identify_cpu+0x6fa/0x7e0
 [<ffffffff806b281b>] start_kernel+0x23b/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

Freeing SMP alternatives: 36k freed
ACPI: Core revision 20070126
*** SLUB: Freepointer corrupt in kmalloc-32@0xffff8101a02fe050 Slab 0xffff8101bf017f00
    offset=80 flags=0xa000000000000c7 inuse=1 freelist=0xffff8101a02fe050
  Bytes b4 0xffff8101a02fe040:  98 14 ed 70 01 81 ff ff 00 00 00 00 00 00 00 00 ..íp..ÿÿ........
    Object 0xffff8101a02fe050:  51 65 28 80 ff ff ff ff 00 00 00 00 00 00 00 00 Qe(.ÿÿÿÿ........
    Object 0xffff8101a02fe060:  68 db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 hÛþÿ............
    Object 0xffff8101a02fe070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101a02fe080:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101a02fe090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff8101a02fe050 -> 0xffffffff80286551
Last alloc: 0xffff8101a02fe0f0 jiffies since=4294892394 cpu=0 pid=0
    Filler 0xffff8101a02fe0d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fe0e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fe0f0:  40 e1 2f a0 01 81 ff ff 00 00 00 00 00 00 00 00 @á/...ÿÿ........
    Filler 0xffff8101a02fe100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fe110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fe120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fe130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fe140:  90 e1 2f a0 01 81 ff ff 00 00 00 00 00 00 00 00 .á/...ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff80286591>] sysfs_slab_alias+0x31/0x80
 [<ffffffff80286afc>] kmem_cache_create+0x20c/0x220
 [<ffffffff803b76ea>] acpi_os_create_cache+0x1e/0x2e
 [<ffffffff803cc664>] acpi_ut_create_caches+0x46/0xae
 [<ffffffff803ce560>] acpi_ut_init_globals+0x9/0x1a1
 [<ffffffff803cda3b>] acpi_initialize_subsystem+0x3a/0x8b
 [<ffffffff806d382b>] acpi_early_init+0x5c/0x104
 [<ffffffff806b2825>] start_kernel+0x245/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

*** SLUB: Freepointer corrupt in kmalloc-32@0xffff8101c0344050 Slab 0xffff8101df01a200
    offset=80 flags=0xe000000000000c7 inuse=1 freelist=0xffff8101c0344050
  Bytes b4 0xffff8101c0344040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101c0344050:  91 65 28 80 ff ff ff ff 00 00 00 00 00 00 00 00 .e(.ÿÿÿÿ........
    Object 0xffff8101c0344060:  6b db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 kÛþÿ............
    Object 0xffff8101c0344070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101c0344080:  00 00 00 00 00 00 00 00 d8 c7 4a be 01 81 ff ff ........ØÇJ¾..ÿÿ
    Object 0xffff8101c0344090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff8101c0344050 -> 0xffffffff80286591
Last alloc: 0xffff8101c03440f0 jiffies since=4294892395 cpu=0 pid=0
    Filler 0xffff8101c03440d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c03440e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c03440f0:  40 41 34 c0 01 81 ff ff 00 00 00 00 00 00 00 00 @A4À..ÿÿ........
    Filler 0xffff8101c0344100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0344110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0344120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0344130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0344140:  90 41 34 c0 01 81 ff ff 00 00 00 00 00 00 00 00 .A4À..ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff80286591>] sysfs_slab_alias+0x31/0x80
 [<ffffffff80286afc>] kmem_cache_create+0x20c/0x220
 [<ffffffff803b76ea>] acpi_os_create_cache+0x1e/0x2e
 [<ffffffff803cc6a6>] acpi_ut_create_caches+0x88/0xae
 [<ffffffff803ce560>] acpi_ut_init_globals+0x9/0x1a1
 [<ffffffff803cda3b>] acpi_initialize_subsystem+0x3a/0x8b
 [<ffffffff806d382b>] acpi_early_init+0x5c/0x104
 [<ffffffff806b2825>] start_kernel+0x245/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

*** SLUB: Freepointer corrupt in kmalloc-32@0xffff810173f38050 Slab 0xffff81017f9f9c00
    offset=80 flags=0x2000000000000c7 inuse=1 freelist=0xffff810173f38050
  Bytes b4 0xffff810173f38040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff810173f38050:  91 65 28 80 ff ff ff ff 00 00 00 00 00 00 00 00 .e(.ÿÿÿÿ........
    Object 0xffff810173f38060:  6c db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 lÛþÿ............
    Object 0xffff810173f38070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff810173f38080:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff810173f38090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff810173f38050 -> 0xffffffff80286591
Last alloc: 0xffff810173f380f0 jiffies since=4294892396 cpu=0 pid=0
    Filler 0xffff810173f380d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f380e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f380f0:  40 81 f3 73 01 81 ff ff 00 00 00 00 00 00 00 00 @.ós..ÿÿ........
    Filler 0xffff810173f38100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f38110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f38120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f38130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f38140:  90 81 f3 73 01 81 ff ff 00 00 00 00 00 00 00 00 ..ós..ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff80286591>] sysfs_slab_alias+0x31/0x80
 [<ffffffff80286afc>] kmem_cache_create+0x20c/0x220
 [<ffffffff803b76ea>] acpi_os_create_cache+0x1e/0x2e
 [<ffffffff803cc6c7>] acpi_ut_create_caches+0xa9/0xae
 [<ffffffff803ce560>] acpi_ut_init_globals+0x9/0x1a1
 [<ffffffff803cda3b>] acpi_initialize_subsystem+0x3a/0x8b
 [<ffffffff806d382b>] acpi_early_init+0x5c/0x104
 [<ffffffff806b2825>] start_kernel+0x245/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

*** SLUB: Freepointer corrupt in kmalloc-32@0xffff8101a02fd050 Slab 0xffff8101bf017e80
    offset=80 flags=0xa000000000000c7 inuse=1 freelist=0xffff8101a02fd050
  Bytes b4 0xffff8101a02fd040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101a02fd050:  91 65 28 80 ff ff ff ff 00 00 00 00 00 00 00 00 .e(.ÿÿÿÿ........
    Object 0xffff8101a02fd060:  6d db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 mÛþÿ............
    Object 0xffff8101a02fd070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101a02fd080:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101a02fd090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff8101a02fd050 -> 0xffffffff80286591
Last alloc: 0xffff8101a02fd0f0 jiffies since=4294892397 cpu=0 pid=0
    Filler 0xffff8101a02fd0d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fd0e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fd0f0:  40 d1 2f a0 01 81 ff ff 00 00 00 00 00 00 00 00 @Ñ/...ÿÿ........
    Filler 0xffff8101a02fd100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fd110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fd120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fd130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a02fd140:  90 d1 2f a0 01 81 ff ff 00 00 00 00 00 00 00 00 .Ñ/...ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff803b7795>] acpi_os_create_semaphore+0x36/0x71
 [<ffffffff803cef18>] acpi_ut_mutex_initialize+0x33/0x77
 [<ffffffff803cda40>] acpi_initialize_subsystem+0x3f/0x8b
 [<ffffffff806d382b>] acpi_early_init+0x5c/0x104
 [<ffffffff806b2825>] start_kernel+0x245/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

*** SLUB: Freepointer corrupt in kmalloc-32@0xffff8101c0343050 Slab 0xffff8101df01a180
    offset=80 flags=0xe000000000000c7 inuse=1 freelist=0xffff8101c0343050
  Bytes b4 0xffff8101c0343040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101c0343050:  95 77 3b 80 ff ff ff ff 00 00 00 00 00 00 00 00 .w;.ÿÿÿÿ........
    Object 0xffff8101c0343060:  6e db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 nÛþÿ............
    Object 0xffff8101c0343070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101c0343080:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101c0343090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff8101c0343050 -> 0xffffffff803b7795
Last alloc: 0xffff8101c03430f0 jiffies since=4294892398 cpu=0 pid=0
    Filler 0xffff8101c03430d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c03430e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c03430f0:  40 31 34 c0 01 81 ff ff 00 00 00 00 00 00 00 00 @14À..ÿÿ........
    Filler 0xffff8101c0343100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0343110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0343120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0343130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0343140:  90 31 34 c0 01 81 ff ff 00 00 00 00 00 00 00 00 .14À..ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff803b7795>] acpi_os_create_semaphore+0x36/0x71
 [<ffffffff803cef18>] acpi_ut_mutex_initialize+0x33/0x77
 [<ffffffff803cda40>] acpi_initialize_subsystem+0x3f/0x8b
 [<ffffffff806d382b>] acpi_early_init+0x5c/0x104
 [<ffffffff806b2825>] start_kernel+0x245/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

*** SLUB: Freepointer corrupt in kmalloc-32@0xffff810173f37050 Slab 0xffff81017f9f9b80
    offset=80 flags=0x2000000000000c7 inuse=1 freelist=0xffff810173f37050
  Bytes b4 0xffff810173f37040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff810173f37050:  95 77 3b 80 ff ff ff ff 00 00 00 00 00 00 00 00 .w;.ÿÿÿÿ........
    Object 0xffff810173f37060:  6f db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 oÛþÿ............
    Object 0xffff810173f37070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff810173f37080:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff810173f37090:  18 81 70 72 01 81 ff ff 00 00 00 00 00 00 00 00 ..pr..ÿÿ........
FreePointer 0xffff810173f37050 -> 0xffffffff803b7795
Last alloc: 0xffff810173f370f0 jiffies since=4294892399 cpu=0 pid=0
    Filler 0xffff810173f370d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f370e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f370f0:  40 71 f3 73 01 81 ff ff 00 00 00 00 00 00 00 00 @qós..ÿÿ........
    Filler 0xffff810173f37100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f37110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f37120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f37130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f37140:  90 71 f3 73 01 81 ff ff 00 00 00 00 00 00 00 00 .qós..ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff803b7795>] acpi_os_create_semaphore+0x36/0x71
 [<ffffffff803cef18>] acpi_ut_mutex_initialize+0x33/0x77
 [<ffffffff803cda40>] acpi_initialize_subsystem+0x3f/0x8b
 [<ffffffff806d382b>] acpi_early_init+0x5c/0x104
 [<ffffffff806b2825>] start_kernel+0x245/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

*** SLUB: Freepointer corrupt in kmalloc-32@0xffff81018033c050 Slab 0xffff81019f019e00
    offset=80 flags=0x6000000000000c7 inuse=1 freelist=0xffff81018033c050
  Bytes b4 0xffff81018033c040:  40 c0 33 80 01 81 ff ff 40 c0 33 80 01 81 ff ff @À3...ÿÿ@À3...ÿÿ
    Object 0xffff81018033c050:  95 77 3b 80 ff ff ff ff 00 00 00 00 00 00 00 00 .w;.ÿÿÿÿ........
    Object 0xffff81018033c060:  70 db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 pÛþÿ............
    Object 0xffff81018033c070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff81018033c080:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff81018033c090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff81018033c050 -> 0xffffffff803b7795
Last alloc: 0xffff81018033c0f0 jiffies since=4294892400 cpu=0 pid=0
    Filler 0xffff81018033c0d0:  00 00 00 00 00 00 00 00 80 44 f1 73 01 81 ff ff .........Dñs..ÿÿ
    Filler 0xffff81018033c0e0:  30 80 f1 73 01 81 ff ff c0 60 f1 73 01 81 ff ff 0.ñs..ÿÿÀ`ñs..ÿÿ
    Filler 0xffff81018033c0f0:  40 c1 33 80 01 81 ff ff 00 00 00 00 00 00 00 00 @Á3...ÿÿ........
    Filler 0xffff81018033c100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff81018033c110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff81018033c120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff81018033c130:  00 00 00 00 00 00 00 00 a7 1d 14 46 00 00 00 00 ........§..F....
    Filler 0xffff81018033c140:  90 c1 33 80 01 81 ff ff 00 00 00 00 00 00 00 00 .Á3...ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff803b7795>] acpi_os_create_semaphore+0x36/0x71
 [<ffffffff803cef18>] acpi_ut_mutex_initialize+0x33/0x77
 [<ffffffff803cda40>] acpi_initialize_subsystem+0x3f/0x8b
 [<ffffffff806d382b>] acpi_early_init+0x5c/0x104
 [<ffffffff806b2825>] start_kernel+0x245/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

*** SLUB: Freepointer corrupt in kmalloc-32@0xffff8101a0342050 Slab 0xffff8101bf01a100
    offset=80 flags=0xa000000000000c7 inuse=1 freelist=0xffff8101a0342050
  Bytes b4 0xffff8101a0342040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101a0342050:  95 77 3b 80 ff ff ff ff 00 00 00 00 00 00 00 00 .w;.ÿÿÿÿ........
    Object 0xffff8101a0342060:  71 db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 qÛþÿ............
    Object 0xffff8101a0342070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101a0342080:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101a0342090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff8101a0342050 -> 0xffffffff803b7795
Last alloc: 0xffff8101a03420f0 jiffies since=4294892401 cpu=0 pid=0
    Filler 0xffff8101a03420d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a03420e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a03420f0:  40 21 34 a0 01 81 ff ff 00 00 00 00 00 00 00 00 @!4...ÿÿ........
    Filler 0xffff8101a0342100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a0342110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a0342120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a0342130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101a0342140:  90 21 34 a0 01 81 ff ff 00 00 00 00 00 00 00 00 .!4...ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff803b7795>] acpi_os_create_semaphore+0x36/0x71
 [<ffffffff803cef18>] acpi_ut_mutex_initialize+0x33/0x77
 [<ffffffff803cda40>] acpi_initialize_subsystem+0x3f/0x8b
 [<ffffffff806d382b>] acpi_early_init+0x5c/0x104
 [<ffffffff806b2825>] start_kernel+0x245/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

*** SLUB: Freepointer corrupt in kmalloc-32@0xffff8101c0342050 Slab 0xffff8101df01a100
    offset=80 flags=0xe000000000000c7 inuse=1 freelist=0xffff8101c0342050
  Bytes b4 0xffff8101c0342040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101c0342050:  95 77 3b 80 ff ff ff ff 00 00 00 00 00 00 00 00 .w;.ÿÿÿÿ........
    Object 0xffff8101c0342060:  72 db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 rÛþÿ............
    Object 0xffff8101c0342070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101c0342080:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff8101c0342090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff8101c0342050 -> 0xffffffff803b7795
Last alloc: 0xffff8101c03420f0 jiffies since=4294892402 cpu=0 pid=0
    Filler 0xffff8101c03420d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c03420e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c03420f0:  40 21 34 c0 01 81 ff ff 00 00 00 00 00 00 00 00 @!4À..ÿÿ........
    Filler 0xffff8101c0342100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0342110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0342120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0342130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff8101c0342140:  90 21 34 c0 01 81 ff ff 00 00 00 00 00 00 00 00 .!4À..ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff803b7795>] acpi_os_create_semaphore+0x36/0x71
 [<ffffffff803cef18>] acpi_ut_mutex_initialize+0x33/0x77
 [<ffffffff803cda40>] acpi_initialize_subsystem+0x3f/0x8b
 [<ffffffff806d382b>] acpi_early_init+0x5c/0x104
 [<ffffffff806b2825>] start_kernel+0x245/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

*** SLUB: Freepointer corrupt in kmalloc-32@0xffff810173f36050 Slab 0xffff81017f9f9b00
    offset=80 flags=0x2000000000000c7 inuse=1 freelist=0xffff810173f36050
  Bytes b4 0xffff810173f36040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff810173f36050:  95 77 3b 80 ff ff ff ff 00 00 00 00 00 00 00 00 .w;.ÿÿÿÿ........
    Object 0xffff810173f36060:  73 db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 sÛþÿ............
    Object 0xffff810173f36070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff810173f36080:  00 00 00 00 00 00 00 00 18 97 6f bd 01 81 ff ff ..........o½..ÿÿ
    Object 0xffff810173f36090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff810173f36050 -> 0xffffffff803b7795
Last alloc: 0xffff810173f360f0 jiffies since=4294892403 cpu=0 pid=0
    Filler 0xffff810173f360d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f360e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f360f0:  40 61 f3 73 01 81 ff ff 00 00 00 00 00 00 00 00 @aós..ÿÿ........
    Filler 0xffff810173f36100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f36110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f36120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f36130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff810173f36140:  90 61 f3 73 01 81 ff ff 00 00 00 00 00 00 00 00 .aós..ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff803b7795>] acpi_os_create_semaphore+0x36/0x71
 [<ffffffff803cef18>] acpi_ut_mutex_initialize+0x33/0x77
 [<ffffffff803cda40>] acpi_initialize_subsystem+0x3f/0x8b
 [<ffffffff806d382b>] acpi_early_init+0x5c/0x104
 [<ffffffff806b2825>] start_kernel+0x245/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170

*** SLUB: Freepointer corrupt in kmalloc-32@0xffff81018033b050 Slab 0xffff81019f019d80
    offset=80 flags=0x6000000000000c7 inuse=1 freelist=0xffff81018033b050
  Bytes b4 0xffff81018033b040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff81018033b050:  95 77 3b 80 ff ff ff ff 00 00 00 00 00 00 00 00 .w;.ÿÿÿÿ........
    Object 0xffff81018033b060:  74 db fe ff 00 00 00 00 00 00 00 00 00 00 00 00 tÛþÿ............
    Object 0xffff81018033b070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff81018033b080:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xffff81018033b090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FreePointer 0xffff81018033b050 -> 0xffffffff803b7795
Last alloc: 0xffff81018033b0f0 jiffies since=4294892404 cpu=0 pid=0
    Filler 0xffff81018033b0d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff81018033b0e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff81018033b0f0:  40 b1 33 80 01 81 ff ff 00 00 00 00 00 00 00 00 @±3...ÿÿ........
    Filler 0xffff81018033b100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff81018033b110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff81018033b120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff81018033b130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Filler 0xffff81018033b140:  90 b1 33 80 01 81 ff ff 00 00 00 00 00 00 00 00 .±3...ÿÿ........

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff803b7795>] acpi_os_create_semaphore+0x36/0x71
 [<ffffffff803cef18>] acpi_ut_mutex_initialize+0x33/0x77
 [<ffffffff803cda40>] acpi_initialize_subsystem+0x3f/0x8b
 [<ffffffff806d382b>] acpi_early_init+0x5c/0x104
 [<ffffffff806b2825>] start_kernel+0x245/0x2d0
 [<ffffffff806b2127>] _sinittext+0x127/0x170


--=-7JMeEWhMeDiDTw6a0XBI--

