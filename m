Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbZLOTWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbZLOTWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbZLOTW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:22:29 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33039 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbZLOTW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:22:28 -0500
Date: Tue, 15 Dec 2009 20:22:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kexec boot regression
Message-ID: <20091215192226.GR28252@kernel.dk>
References: <20091215121436.GB28252@kernel.dk> <4B2781AC.8020301@kernel.org> <20091215123951.GD28252@kernel.dk> <4B278734.2040704@kernel.org> <20091215141105.GK28252@kernel.dk> <4B27D7E9.4030105@kernel.org> <20091215185941.GO28252@kernel.dk> <4B27DDD7.5040301@kernel.org> <20091215191129.GQ28252@kernel.dk> <4B27E0C7.9060909@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27E0C7.9060909@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15 2009, Yinghai Lu wrote:
> Jens Axboe wrote:
> > On Tue, Dec 15 2009, Yinghai Lu wrote:
> >> Jens Axboe wrote:
> >>> On Tue, Dec 15 2009, Yinghai Lu wrote:
> >>>> [   13.018720] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
> >>>>
> >>>> [   13.100724] [Firmware Bug]: PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] not reserved in ACPI motherboard resources
> >>> On a "normal" non-kexec boot, I get:
> >>>
> >>> [   12.173583] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
> >>> [   12.184075] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
> >>> [   12.216874] PCI: Using configuration type 1 for base access
> >>>
> >> can you run following scripts in first kernel?
> >>
> >> cd /sys/firmware/memmap
> >> for dir in * ; do
> >>   start=$(cat $dir/start)
> >>   end=$(cat $dir/end)
> >>   type=$(cat $dir/type)
> >>   printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type" >> /tmp/memmap.txt
> >> done
> >>
> >> and send out /tmp/memmap.txt
> > 
> > Below.
> > 
> >> what is your kexec tools version? could be too old?
> > 
> > It says:
> > 
> > kexec-tools-testing 20080324 released 24th March 2008
> > 
> > 
> > 0000000000000000-0000000000098800 (System RAM)
> > 0000000000098800-00000000000a0000 (reserved)
> > 0000000079301000-0000000079303000 (reserved)
> > 0000000079303000-0000000079305000 (ACPI Tables)
> > 0000000079305000-0000000079310000 (reserved)
> > 0000000079310000-0000000079314000 (ACPI Tables)
> > 0000000079314000-0000000079319000 (reserved)
> > 0000000079319000-0000000079336000 (ACPI Tables)
> > 0000000079336000-0000000079358000 (reserved)
> > 0000000079358000-0000000079388000 (ACPI Tables)
> > 0000000079388000-00000000793c9000 (reserved)
> > 00000000793c9000-000000007968f000 (ACPI Tables)
> > 00000000000e0000-0000000000100000 (reserved)
> > 000000007968f000-00000000796bb000 (reserved)
> > 00000000796bb000-00000000799d8000 (ACPI Tables)
> > 00000000799d8000-0000000079bd8000 (ACPI Non-volatile Storage)
> > 0000000079bd8000-0000000079d8b000 (ACPI Tables)
> > 0000000079d8b000-0000000079d8c000 (reserved)
> > 0000000079d8c000-0000000079dc8000 (ACPI Tables)
> > 0000000079dc8000-0000000079dcb000 (reserved)
> > 0000000079dcb000-0000000079e1c000 (ACPI Tables)
> > 0000000079e1c000-0000000079e87000 (reserved)
> > 0000000079e87000-000000007bd5f000 (ACPI Tables)
> > 0000000000100000-0000000078c59000 (System RAM)
> > 000000007bd5f000-000000007be4f000 (reserved)
> > 000000007be4f000-000000007bf87000 (ACPI Tables)
> > 000000007bf87000-000000007bfcf000 (ACPI Non-volatile Storage)
> > 000000007bfcf000-000000007bfff000 (ACPI Tables)
> > 000000007bfff000-0000000090000000 (reserved)
> > 00000000fc000000-00000000fd000000 (reserved)
> > 00000000fed1c000-00000000fed20000 (reserved)
> > 00000000ff000000-0000000100000000 (reserved)
> > 0000000100000000-0000001080000000 (System RAM)
> > 0000000078c59000-0000000078e6d000 (ACPI Non-volatile Storage)
> > 0000000078e6d000-000000007924e000 (ACPI Tables)
> > 000000007924e000-00000000792c2000 (reserved)
> > 00000000792c2000-00000000792d2000 (ACPI Tables)
> > 00000000792d2000-00000000792e7000 (reserved)
> > 00000000792e7000-0000000079301000 (ACPI Tables)
> > 
> 
> boot log of first kernel?

Hmm not completely sure, let me re-do it after a cold boot.

BTW, I just checked, and 2.6.32 has NUMA working fine. Below is the SRAT
and NUMA output from 2.6.32 (kexec'ed kernel). Is the check a newly
introduced one?

[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 64 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 32 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 96 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 2 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 66 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 34 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 98 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 4 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 68 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 36 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 100 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 6 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 70 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 38 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 102 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 16 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 80 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 48 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 112 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 18 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 82 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 50 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 114 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 20 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 84 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 52 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 116 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 22 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 86 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 54 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 118 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 65 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 33 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 97 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 3 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 67 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 35 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 99 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 5 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 69 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 37 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 101 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 7 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 71 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 39 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 103 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 17 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 81 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 49 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 113 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 19 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 83 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 51 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 115 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 21 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 85 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 53 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 117 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 23 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 87 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 55 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 119 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-480000000
[    0.000000] SRAT: Node 2 PXM 1 480000000-880000000
[    0.000000] SRAT: Node 1 PXM 2 880000000-c80000000
[    0.000000] SRAT: Node 3 PXM 3 c80000000-1080000000
[    0.000000] NUMA: Using 31 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000480000000
[    0.000000]   NODE_DATA [0000000000048000 - 000000000004cfff]
[    0.000000]   bootmap [0000000000100000 -  000000000018ffff] pages 90
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0480000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000200f260]    TEXT DATA BSS ==> [0001000000 - 000200f260]
[    0.000000]   #3 [0000098800 - 0000100000]    BIOS reserved ==> [0000098800 - 0000100000]
[    0.000000]   #4 [0002010000 - 000201035c]              BRK ==> [0002010000 - 000201035c]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #6 [000000a000 - 0000048000]          PGTABLE ==> [000000a000 - 0000048000]
[    0.000000]   #7 [0000001000 - 000000103c]        ACPI SLIT ==> [0000001000 - 000000103c]
[    0.000000] Bootmem setup node 1 0000000880000000-0000000c80000000
[    0.000000]   NODE_DATA [0000000880000000 - 0000000880004fff]
[    0.000000]   bootmap [0000000880005000 -  0000000880084fff] pages 80
[    0.000000] (8 early reservations) ==> bootmem [0880000000 - 0c80000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0001000000 - 000200f260]    TEXT DATA BSS
[    0.000000]   #3 [0000098800 - 0000100000]    BIOS reserved
[    0.000000]   #4 [0002010000 - 000201035c]              BRK
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000048000]          PGTABLE
[    0.000000]   #7 [0000001000 - 000000103c]        ACPI SLIT
[    0.000000] Bootmem setup node 2 0000000480000000-0000000880000000
[    0.000000]   NODE_DATA [0000000480000000 - 0000000480004fff]
[    0.000000]   bootmap [0000000480005000 -  0000000480084fff] pages 80
[    0.000000] (8 early reservations) ==> bootmem [0480000000 - 0880000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0001000000 - 000200f260]    TEXT DATA BSS
[    0.000000]   #3 [0000098800 - 0000100000]    BIOS reserved
[    0.000000]   #4 [0002010000 - 000201035c]              BRK
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000048000]          PGTABLE
[    0.000000]   #7 [0000001000 - 000000103c]        ACPI SLIT
[    0.000000] Bootmem setup node 3 0000000c80000000-0000001080000000
[    0.000000]   NODE_DATA [0000000c80000000 - 0000000c80004fff]
[    0.000000]   bootmap [0000000c80005000 -  0000000c80084fff] pages 80
[    0.000000] (8 early reservations) ==> bootmem [0c80000000 - 1080000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0001000000 - 000200f260]    TEXT DATA BSS
[    0.000000]   #3 [0000098800 - 0000100000]    BIOS reserved
[    0.000000]   #4 [0002010000 - 000201035c]              BRK
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000048000]          PGTABLE
[    0.000000]   #7 [0000001000 - 000000103c]        ACPI SLIT
[    0.000000] found SMP MP-table at [ffff8800000fddb0] fddb0
[    0.000000]  [ffffea0000000000-ffffea001d3fffff] PMD -> [ffff880028600000-ffff8800425fffff] on node 0
[    0.000000]  [ffffea001d400000-ffffea00373fffff] PMD -> [ffff880480200000-ffff88049a1fffff] on node 2
[    0.000000]  [ffffea0037400000-ffffea003fffffff] PMD -> [ffff880880200000-ffff880888dfffff] on node 1
[    0.000000]  [ffffea0040000000-ffffea00513fffff] PMD -> [ffff880889000000-ffff88089a3fffff] on node 1
[    0.000000]  [ffffea0051400000-ffffea006b3fffff] PMD -> [ffff880c80200000-ffff880c9a1fffff] on node 3
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x01080000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x00000098
[    0.000000]     0: 0x00000100 -> 0x00078c59
[    0.000000]     0: 0x00100000 -> 0x00480000
[    0.000000]     2: 0x00480000 -> 0x00880000
[    0.000000]     1: 0x00880000 -> 0x00c80000
[    0.000000]     3: 0x00c80000 -> 0x01080000
[    0.000000] On node 0 totalpages: 4164592
[    0.000000]   DMA zone: 104 pages used for memmap
[    0.000000]   DMA zone: 185 pages reserved
[    0.000000]   DMA zone: 3702 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 26520 pages used for memmap
[    0.000000]   DMA32 zone: 464065 pages, LIFO batch:31
[    0.000000]   Normal zone: 93184 pages used for memmap
[    0.000000]   Normal zone: 3576832 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 4194304
[    0.000000]   Normal zone: 106496 pages used for memmap
[    0.000000]   Normal zone: 4087808 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 4194304
[    0.000000]   Normal zone: 106496 pages used for memmap
[    0.000000]   Normal zone: 4087808 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 4194304
[    0.000000]   Normal zone: 106496 pages used for memmap
[    0.000000]   Normal zone: 4087808 pages, LIFO batch:31

-- 
Jens Axboe

