Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbYLSVD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbYLSVD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYLSVDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:03:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:41577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbYLSVDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:03:17 -0500
Message-ID: <494C0BF0.3080109@kernel.org>
Date: Fri, 19 Dec 2008 13:02:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333	smp_call_function_mask
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au> <20081219105441.GA19750@linux.vnet.ibm.com> <86802c440812190351q3118516aif664dd5869c21b2a@mail.gmail.com> <20081219134636.GA11772@linux.vnet.ibm.com>
In-Reply-To: <20081219134636.GA11772@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> * Yinghai Lu <yinghai@kernel.org> [2008-12-19 03:51:53]:
> 
>> On Fri, Dec 19, 2008 at 2:54 AM, Kamalesh Babulal
>> <kamalesh@linux.vnet.ibm.com> wrote:
>>> Hi,
>>>
>>>        next-200816 kernel panics, while boot up on x86_64 machine.
>>>
>>> Initializing CPU#0
>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
>>> IP: [<ffffffff80700449>] init_ISA_irqs+0x18/0x53
>> .config and good boot log?
>>
>> YH
> Hi,
> 
> I am able to reproduce with next-20081218 kernel also, attaching the
> bootlog and .config file of next-20081218 kernel
> 
> root (hd0,0)
>  Filesystem type is ext2fs, partition type 0x83
> kernel /vmlinuz-autotest root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 c
> onsole=ttyS1,19200 selinux=no debug nmi_watchdog=1 initcall_debug earlyprintk=s
> erial,ttyS1,19200 IDENT=1229689794
>    [Linux-bzImage, setup=0x3000, size=0x274e50]
> initrd /initrd-autotest
>    [Linux-initrd @ 0x37e5f000, 0x190980 bytes]
> 
> Command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug nmi_watchdog=1 initcall_debug earlyprintk=serial,ttyS1,19200 IDENT=1229689794
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   Centaur CentaurHauls
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
>  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000003ffcddc0 (usable)
>  BIOS-e820: 000000003ffcddc0 - 000000003ffd0000 (ACPI data)
>  BIOS-e820: 000000003ffd0000 - 0000000040000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> DMI 2.3 present.
> last_pfn = 0x3ffcd max_arch_pfn = 0x3ffffffff
> init_memory_mapping: 0000000000000000-000000003ffcd000
>  0000000000 - 003fe00000 page 2M
>  003fe00000 - 003ffcd000 page 4k
> kernel direct mapping tables up to 3ffcd000 @ 8000-b000
> last_map_addr: 3ffcd000 end: 3ffcd000
> RAMDISK: 37e5f000 - 37fef980
> ACPI: RSDP 000FDFC0, 0014 (r0 IBM   )
> ACPI: RSDT 3FFCFF80, 0034 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: FACP 3FFCFEC0, 0084 (r2 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: DSDT 3FFCDDC0, 1EA6 (r1 IBM    SERBLADE     1000 INTL  2002025)
> ACPI: FACS 3FFCFCC0, 0040
> ACPI: APIC 3FFCFE00, 009C (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: SRAT 3FFCFD40, 0098 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: HPET 3FFCFD00, 0038 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: Local APIC address 0xfee00000
> SRAT: PXM 0 -> APIC 0 -> Node 0
> SRAT: PXM 0 -> APIC 1 -> Node 0
> SRAT: PXM 1 -> APIC 2 -> Node 1
> SRAT: PXM 1 -> APIC 3 -> Node 1
> SRAT: Node 0 PXM 0 0-40000000
> NUMA: Using 63 for the hash shift.
> Bootmem setup node 0 0000000000000000-000000003ffcd000
>   NODE_DATA [0000000000009000 - 000000000000efff]
>   bootmap [000000000000f000 -  0000000000016fff] pages 8
> (6 early reservations) ==> bootmem [0000000000 - 003ffcd000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
>   #2 [0000200000 - 00008198b0]    TEXT DATA BSS ==> [0000200000 - 00008198b0]
>   #3 [0037e5f000 - 0037fef980]          RAMDISK ==> [0037e5f000 - 0037fef980]
>   #4 [000009d400 - 0000100000]    BIOS reserved ==> [000009d400 - 0000100000]
>   #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
> found SMP MP-table at [ffff88000009d540] 0009d540
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   DMA32    0x00001000 -> 0x00100000
>   Normal   0x00100000 -> 0x00100000
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000000 -> 0x0000009d
>     0: 0x00000100 -> 0x0003ffcd
> On node 0 totalpages: 261994
>   DMA zone: 64 pages used for memmap
>   DMA zone: 1665 pages reserved
>   DMA zone: 2268 pages, LIFO batch:0
>   DMA32 zone: 4032 pages used for memmap
>   DMA32 zone: 253965 pages, LIFO batch:31
>   Normal zone: 0 pages used for memmap
>   Movable zone: 0 pages used for memmap
> Detected use of extended apic ids on hypertransport bus
> Detected use of extended apic ids on hypertransport bus
> ACPI: PM-Timer IO Port: 0x2208
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
> ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 14, version 0, address 0xfec00000, GSI 0-23
> ACPI: IOAPIC (id[0x0d] address[0xfec10000] gsi_base[24])
> IOAPIC[1]: apic_id 13, version 0, address 0xfec10000, GSI 24-27
> ACPI: IOAPIC (id[0x0c] address[0xfec20000] gsi_base[48])
> IOAPIC[2]: apic_id 12, version 0, address 0xfec20000, GSI 48-51
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ11 used by override.
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x10228203 base: 0xfecff000
> SMP: Allowing 4 CPUs, 0 hotplug CPUs
> Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
> PERCPU: Allocating 49152 bytes of per cpu data
> per cpu data for cpu0 on node0 at 000000000100e000
> per cpu data for cpu1 on node0 at 000000000101a000
> per cpu data for cpu2 on node0 at 0000000001026000
> per cpu data for cpu3 on node0 at 0000000001032000
> NR_CPUS: 255, nr_cpu_ids: 4, nr_node_ids 1
> Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256233
> Policy zone: DMA32
> Kernel command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug nmi_watchdog=1 initcall_debug earlyprintk=serial,ttyS1,19200 IDENT=1229689794
> Initializing CPU#0
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> IP: [<ffffffff80714479>] init_ISA_irqs+0x18/0x53
> PGD 0 
> Thread overran stack, or stack corrupted
> Oops: 0002 [#1] SMP 
> last sysfs file: 
> CPU 0 
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.28-rc8-next-20081218-autotest #1
> RIP: 0010:[<ffffffff80714479>]  [<ffffffff80714479>] init_ISA_irqs+0x18/0x53
> RSP: 0018:ffffffff80705f88  EFLAGS: 00010093
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff80778a80
> RDX: 0000000000000100 RSI: 0000000000000092 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff88008089e000 R09: 0000000000000000
> R10: ffff880001012c60 R11: ffffffff803560a0 R12: ffff88000103e040
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffffffff806f73c0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000048 CR3: 0000000000201000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffffffff80704000, task ffffffff806843a0)
> Stack:
>  ffffffff8073b560 ffffffff807144bd ffffffff806e8f40 ffffffff8050e772
>  ffffffff8073b560 ffffffff8070daf6 0000000000000000 0000000000093370
>  0000000000000000 ffffffff8070d394 80708e000010d136 00000000ffffffff
> Call Trace:
>  [<ffffffff807144bd>] native_init_IRQ+0x9/0x931
>  [<ffffffff8050e772>] register_cpu_notifier+0x1f/0x23
>  [<ffffffff8070daf6>] start_kernel+0x1a8/0x319
>  [<ffffffff8070d394>] x86_64_start_kernel+0xde/0xe2
> Code: 85 c0 75 0d 59 48 c7 c7 20 5f 68 80 e9 65 74 cb ff 5a c3 53 31 db e8 ba 85 00 00 31 ff e8 52 ad af ff 89 df e8 6a 12 b5 ff 89 df <c7> 40 48 00 02 00 00 48 c7 40 40 00 00 00 00 c7 40 4c 01 00 00 
> RIP  [<ffffffff80714479>] init_ISA_irqs+0x18/0x53
>  RSP <ffffffff80705f88>
> CR2: 0000000000000048

can you check if tip works or not?

YH
