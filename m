Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbYBST3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbYBST3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYBST3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:29:07 -0500
Received: from relay1.sgi.com ([192.48.171.29]:55670 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754049AbYBST3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:29:05 -0500
Message-ID: <47BB2DFC.8060607@sgi.com>
Date: Tue, 19 Feb 2008 11:29:00 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing
 boot failure
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <20080213175241.GA327@csn.ul.ie> <47B33ACF.5030700@sgi.com> <20080214201727.GC30841@csn.ul.ie> <47B4A774.7050509@sgi.com> <20080215020208.GA6500@csn.ul.ie> <47B77E90.5050809@sgi.com> <47BAFFD3.1070606@sgi.com> <20080219192319.GE12386@csn.ul.ie>
In-Reply-To: <20080219192319.GE12386@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (19/02/08 08:12), Mike Travis didst pronounce:
>> Mike Travis wrote:
>>> Mel Gorman wrote:
>>>
>>>> If you send me patches to apply on top of 2.6.25-rc1, I'll give them a spin
>>>> on the machine in question. Reverting didn't work out very well as there are
>>>> too many collisions with patches that were applied later. I eventually got
>>>> the machine booting but it only succeeds because it only brings up one core
>>>> on each processor.  The patch, which is pretty brain damaged is below in case
>>>> it helps you guess what the real problem is. dmesg logs are attached of the
>>>> vanilla failure with acpi=debug and the log with the patch applied showing
>>>> "__cpu_up: bad cpu 1" and "__cpu_up: bad cpu3" (i.e. the second cores of
>>>> each machine).
>>>>
>>> This should completely undo the change to 16 bit apic ids until we can figure
>>> out the problem with the memory-less nodes.  I checked it on both the numa
>>> and non-numa x86_64 box.
>>>
>>> Thanks,
>>> Mike
>>>
>> Hi Mel,
>>
>> Did you get a chance to try out this patch to see if it cleared up the problem
>> booting on your x86_64 numa box?
>>
> 
> I initially missed the patch in the bomb of mail that came through over
> the weekend, sorry. The machine still fails to boot with this patch
> applied. dmesg is below but it looks like essentially the same failure.
> I'm offline from tomorrow for a week as well so won't be able to test
> another version until I'm back properly :(

Ok, thanks, I'll continue looking into it.  Unfortunately, the system I am
testing on does not have remote access working.  I'll be over in MV again
tomorrow to try out some things.  In the meantime, I'm trying to fake a
node with zero memory to see if that duplicates the problem.

Thanks,
Mike

> 
> root (hd0,0)
>  Filesystem type is ext2fs, partition type 0x83
> kernel /vmlinuz-autobench ro root=/dev/VolGroup00/LogVol00 console=tty0 console
> =ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 AB
> AT:1203448759 loglevel=8
>    [Linux-bzImage, setup=0x2e00, size=0x2436f8]
> initrd /initrd-autobench.img
>    [Linux-initrd @ 0x37e5f000, 0x19097c bytes]
> Linux version 2.6.24-mm1-autokern1 (root@bl6-13.ltc.austin.ibm.com) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Tue Feb 19 12:52:43 CST 2008
> Command line: ro root=/dev/VolGroup00/LogVol00 console=tty0 console=ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 ABAT:1203448759 loglevel=8
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
>  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000003ffcddc0 (usable)
>  BIOS-e820: 000000003ffcddc0 - 000000003ffd0000 (ACPI data)
>  BIOS-e820: 000000003ffd0000 - 0000000040000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> Malformed early option 'loglevel'
> Entering add_active_range(0, 0, 157) 0 entries of 3200 used
> Entering add_active_range(0, 256, 262093) 1 entries of 3200 used
> end_pfn_map = 1048576
> DMI 2.3 present.
> ACPI: RSDP 000FDFC0, 0014 (r0 IBM   )
> ACPI: RSDT 3FFCFF80, 0034 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: FACP 3FFCFEC0, 0084 (r2 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: DSDT 3FFCDDC0, 1EA6 (r1 IBM    SERBLADE     1000 INTL  2002025)
> ACPI: FACS 3FFCFCC0, 0040
> ACPI: APIC 3FFCFE00, 009C (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: SRAT 3FFCFD40, 0098 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: HPET 3FFCFD00, 0038 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> SRAT: PXM 0 -> APIC 0 -> Node 0
> SRAT: PXM 0 -> APIC 1 -> Node 0
> SRAT: PXM 1 -> APIC 2 -> Node 1
> SRAT: PXM 1 -> APIC 3 -> Node 1
> SRAT: Node 0 PXM 0 0-40000000
> Entering add_active_range(0, 0, 157) 0 entries of 3200 used
> Entering add_active_range(0, 256, 262093) 1 entries of 3200 used
> NUMA: Using 63 for the hash shift.
> Bootmem setup node 0 0000000000000000-000000003ffcd000
> early res: 0 [0-fff] BIOS data page
> early res: 1 [6000-7fff] SMP_TRAMPOLINE
> early res: 2 [200000-a0566f] TEXT DATA BSS
> early res: 3 [37e5f000-37fef97b] RAMDISK
> early res: 4 [9d400-a03ff] EBDA
> early res: 5 [8000-afff] PGTABLE
>  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
>  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001400000 on node 0
>  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001600000 on node 0
>  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001a00000 on node 0
>  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810001c00000 on node 0
>  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002000000 on node 0
>  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002200000 on node 0
>  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002600000 on node 0
>  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810002800000 on node 0
>  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810002c00000 on node 0
>  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810002e00000 on node 0
>  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003200000 on node 0
>  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810003400000 on node 0
>  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810003800000 on node 0
>  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810003a00000 on node 0
>  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810003e00000 on node 0
>  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810004000000 on node 0
> sizeof(struct page) = 136
> Zone PFN ranges:
>   DMA             0 ->     4096
>   DMA32        4096 ->  1048576
>   Normal    1048576 ->  1048576
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0:        0 ->      157
>     0:      256 ->   262093
> On node 0 totalpages: 261994
>   DMA zone: 136 pages used for memmap
>   DMA zone: 2064 pages reserved
>   DMA zone: 1797 pages, LIFO batch:0
>   DMA32 zone: 8566 pages used for memmap
>   DMA32 zone: 249431 pages, LIFO batch:31
>   Normal zone: 0 pages used for memmap
>   Movable zone: 0 pages used for memmap
> Detected use of extended apic ids on hypertransport bus
> Detected use of extended apic ids on hypertransport bus
> ACPI: PM-Timer IO Port: 0x2208
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> Processor #0 (Bootup-CPU)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> Processor #1
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> Processor #2
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> Processor #3
> ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
> ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 14, address 0xfec00000, GSI 0-23
> ACPI: IOAPIC (id[0x0d] address[0xfec10000] gsi_base[24])
> IOAPIC[1]: apic_id 13, address 0xfec10000, GSI 24-27
> ACPI: IOAPIC (id[0x0c] address[0xfec20000] gsi_base[48])
> IOAPIC[2]: apic_id 12, address 0xfec20000, GSI 48-51
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ11 used by override.
> Setting APIC routing to flat
> ACPI: HPET id: 0x10228203 base: 0xfecff000
> Using ACPI (MADT) for SMP configuration information
> Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
> SMP: Allowing 4 CPUs, 0 hotplug CPUs
> PERCPU: Allocating 65560 bytes of per cpu data
> cpu with no node 2, num_online_nodes 1
> cpu with no node 3, num_online_nodes 1
> Built 1 zonelists in Node order, mobility grouping on.  Total pages: 251228
> Policy zone: DMA32
> Kernel command line: ro root=/dev/VolGroup00/LogVol00 console=tty0 console=ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 ABAT:1203448759 loglevel=8
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> TSC calibrated against PM_TIMER
> Marking TSC unstable due to TSCs unsynchronized
> time.c: Detected 1993.782 MHz processor.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> console [ttyS1] enabled
> Checking aperture...
> Node 0: aperture @ dc000000 size 64 MB
> Node 1: aperture @ dc000000 size 64 MB
> Memory: 1002864k/1048372k available (3149k kernel code, 45112k reserved, 1471k data, 396k init)
> hpet clockevent registered
> Calibrating delay using timer specific routine.. 3991.58 BogoMIPS (lpj=7983168)
> Security Framework initialized
> SELinux:  Disabled at boot.
> Capability LSM initialized
> Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
> Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
> Mount-cache hash table entries: 256
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 0/0 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> ACPI: Core revision 20070126
> Using local APIC timer interrupts.
> APIC timer calibration result 12461132
> Detected 12.461 MHz APIC timer.
> Booting processor 1/4 APIC 0x1
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 3987.60 BogoMIPS (lpj=7975215)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 1/1 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> Dual Core AMD Opteron(tm) Processor 270 stepping 02
> BUG: unable to handle kernel paging request at 0000000000007358
> IP: [<ffffffff8026ceec>] __alloc_pages+0x4f/0x403
> PGD 0 
> Oops: 0000 [1] SMP 
> last sysfs file: 
> CPU 0 
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.24-mm1-autokern1 #1
> RIP: 0010:[<ffffffff8026ceec>]  [<ffffffff8026ceec>] __alloc_pages+0x4f/0x403
> RSP: 0000:ffff81003fa2fbc0  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 00000000000412d0 RCX: 0000000000007358
> RDX: 0000000000000010 RSI: 0000000000000605 RDI: ffffffff805c3375
> RBP: ffff81003fa2fc30 R08: 0000000000000000 R09: ffff81003fa2d060
> R10: ffff81000000b000 R11: 000412d000000010 R12: 00000000000412d0
> R13: 0000000000007350 R14: 0000000000000000 R15: ffff81003fa29340
> FS:  0000000000000000(0000) GS:ffffffff80684000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000007358 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff81003fa2e000, task ffff81003fa2d060)
> Stack:  000000100000c5c8 ffffffff00000000 ffff81003fa2d060 0000000000007358
>  000000003fa2fd60 0000000000000000 00000000000000d0 ffff81000000fa70
>  0000000000000000 00000000000412d0 ffff81003f801080 0000000000000040
> Call Trace:
>  [<ffffffff8028ab2c>] kmem_getpages+0xd5/0x1ad
>  [<ffffffff8028aed0>] cache_grow+0xa8/0x222
>  [<ffffffff8028b2d8>] ____cache_alloc_node+0xff/0x125
>  [<ffffffff8028adcf>] kmem_cache_alloc_node+0x114/0x144
>  [<ffffffff8050ac0b>] cpuup_callback+0x8e/0x331
>  [<ffffffff8050ff96>] notifier_call_chain+0x33/0x65
>  [<ffffffff8024a061>] __raw_notifier_call_chain+0x9/0xb
>  [<ffffffff8050a258>] _cpu_up+0x6c/0x103
>  [<ffffffff8050a346>] cpu_up+0x57/0x67
>  [<ffffffff808ba689>] kernel_init+0xc5/0x2fe
>  [<ffffffff8020cd88>] child_rip+0xa/0x12
>  [<ffffffff8036d824>] ? acpi_ds_init_one_object+0x0/0x88
>  [<ffffffff808ba5c4>] ? kernel_init+0x0/0x2fe
>  [<ffffffff8020cd7e>] ? child_rip+0x0/0x12
> Code: 00 83 e2 10 48 89 45 a0 89 55 94 74 16 be 05 06 00 00 48 c7 c7 75 33 5c 80 e8 cf db fb ff e8 3e f3 29 00 49 8d 4d 08 48 89 4d a8 <49> 83 7d 08 00 0f 84 39 03 00 00 44 89 e0 b9 44 00 00 00 4c 89 
> RIP  [<ffffffff8026ceec>] __alloc_pages+0x4f/0x403
>  RSP <ffff81003fa2fbc0>
> CR2: 0000000000007358
> ---[ end trace 4eaa2a86a8e2da22 ]---
> Kernel panic - not syncing: Attempted to kill init!
> 
> 

