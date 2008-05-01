Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbYEAMJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbYEAMJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbYEAMJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:09:13 -0400
Received: from trillian.zoopnet.de ([85.214.111.199]:34532 "EHLO
	trillian.zoopnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYEAMJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:09:09 -0400
Message-ID: <4819B2E0.406@zoopnet.de>
Date: Thu, 01 May 2008 14:09:04 +0200
From: Mika Fischer <mika.fischer@zoopnet.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: yhlu.kernel@gmail.com
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 - auto detect
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804290352.33543.yhlu.kernel@gmail.com> <200804292025.58268.yhlu.kernel@gmail.com> <200805010100.34751.yhlu.kernel@gmail.com>
In-Reply-To: <200805010100.34751.yhlu.kernel@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------080506050109090308060904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080506050109090308060904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Yinghai Lu schrieb:
> loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal value.
> 
> so user don't need to add mtrr_chunk_size and mtrr_gran_size, 
> 
> if optimal value is not found, print out all list to help select less optimal
> value.
> 
> add mtrr_spare_reg_nr= so user could set 2 instead of 1, if the card need more entries.

On my system x86-latest + this patch and using no boot options gives me
this /proc/mtrr:
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size= 512MB: write-back, count=1
reg02: base=0xa0000000 (2560MB), size= 256MB: write-back, count=1
reg03: base=0xb0000000 (2816MB), size= 256MB: write-back, count=1
reg04: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
reg05: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
reg06: base=0x100000000 (4096MB), size=1024MB: write-back, count=1

Which is OK. It could probably collapse reg01-reg03 into one but that's
a minor issue (for me at least, there are probably cases where
collapsing them might save the user from having to specify the
mtrr_spare_reg_nr boot option).

In any case it works fine here. dmesg is attached.

Let me know if there's anything else I should test!

And thanks a lot for all your work, Yinghai! :)

Regards,
 Mika

--------------080506050109090308060904
Content-Type: text/plain;
 name="dmesg-2.6.25-x86-latest.git-06791-gd269f9f-dirty.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="dmesg-2.6.25-x86-latest.git-06791-gd269f9f-dirty.txt"

Linux version 2.6.25-x86-latest.git-06791-gd269f9f-dirty (mika@arthur) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #6 SMP Thu May 1 13:54:27 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf6d0000 (usable)
 BIOS-e820: 00000000bf6d0000 - 00000000bf6e3000 (ACPI NVS)
 BIOS-e820: 00000000bf6e3000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
After WB checking
MTRR MAP PFN: 0000000000000000 - 0000000000140000
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf700
MTRR MAP PFN: 0000000000100000 - 0000000000140000
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000bf700
MTRR MAP PFN: 0000000000100000 - 0000000000140000
total RAM coverred: 4087M

gran_size: 1M   chunk_size_size: 1M
rangeX: 0000000000000000 - 00000000bf700000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 512MB, type WB
Setting variable MTRR 2, base: 2560MB, range: 256MB, type WB
Setting variable MTRR 3, base: 2816MB, range: 128MB, type WB
Setting variable MTRR 4, base: 2944MB, range: 64MB, type WB
Setting variable MTRR 5, base: 3008MB, range: 32MB, type WB
Setting variable MTRR 6, base: 3040MB, range: 16MB, type WB
Setting variable MTRR 7, base: 3056MB, range: 4MB, type WB
rangeX: 0000000000000000 - 0000000040000000
DONE variable MTRRs
After WB checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf400
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf400
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000bf400

gran_size: 1M   chunk_size_size: 2M
range0: 0000000000000000 - 00000000bf600000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 512MB, type WB
Setting variable MTRR 2, base: 2560MB, range: 256MB, type WB
Setting variable MTRR 3, base: 2816MB, range: 128MB, type WB
Setting variable MTRR 4, base: 2944MB, range: 64MB, type WB
Setting variable MTRR 5, base: 3008MB, range: 32MB, type WB
Setting variable MTRR 6, base: 3040MB, range: 16MB, type WB
Setting variable MTRR 7, base: 3056MB, range: 4MB, type WB
range: 00000000bf600000 - 00000000bf700000
rangeX: 0000000000000000 - 0000000040000000
DONE variable MTRRs
After WB checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf400
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf400
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000bf400

gran_size: 1M   chunk_size_size: 4M
range0: 0000000000000000 - 00000000bf400000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 512MB, type WB
Setting variable MTRR 2, base: 2560MB, range: 256MB, type WB
Setting variable MTRR 3, base: 2816MB, range: 128MB, type WB
Setting variable MTRR 4, base: 2944MB, range: 64MB, type WB
Setting variable MTRR 5, base: 3008MB, range: 32MB, type WB
Setting variable MTRR 6, base: 3040MB, range: 16MB, type WB
Setting variable MTRR 7, base: 3056MB, range: 4MB, type WB
range: 00000000bf400000 - 00000000bf800000
hole: 00000000bf700000 - 00000000bf800000
rangeX: 0000000000000000 - 0000000040000000
DONE variable MTRRs
After WB checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf400
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf400
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000bf400

gran_size: 1M   chunk_size_size: 8M
range0: 0000000000000000 - 00000000bf000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 512MB, type WB
Setting variable MTRR 2, base: 2560MB, range: 256MB, type WB
Setting variable MTRR 3, base: 2816MB, range: 128MB, type WB
Setting variable MTRR 4, base: 2944MB, range: 64MB, type WB
Setting variable MTRR 5, base: 3008MB, range: 32MB, type WB
Setting variable MTRR 6, base: 3040MB, range: 16MB, type WB
range: 00000000bf000000 - 00000000bf800000
Setting variable MTRR 7, base: 3056MB, range: 8MB, type WB
hole: 00000000bf700000 - 00000000bf800000
rangeX: 0000000000000000 - 0000000040000000
DONE variable MTRRs
After WB checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf800
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf800
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000bf800

gran_size: 1M   chunk_size_size: 16M
range0: 0000000000000000 - 00000000bf000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 512MB, type WB
Setting variable MTRR 2, base: 2560MB, range: 256MB, type WB
Setting variable MTRR 3, base: 2816MB, range: 128MB, type WB
Setting variable MTRR 4, base: 2944MB, range: 64MB, type WB
Setting variable MTRR 5, base: 3008MB, range: 32MB, type WB
Setting variable MTRR 6, base: 3040MB, range: 16MB, type WB
range: 00000000bf000000 - 00000000bf700000
Setting variable MTRR 7, base: 3056MB, range: 4MB, type WB
rangeX: 0000000000000000 - 0000000040000000
DONE variable MTRRs
After WB checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf400
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf400
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000bf400

gran_size: 1M   chunk_size_size: 32M
range0: 0000000000000000 - 00000000be000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 512MB, type WB
Setting variable MTRR 2, base: 2560MB, range: 256MB, type WB
Setting variable MTRR 3, base: 2816MB, range: 128MB, type WB
Setting variable MTRR 4, base: 2944MB, range: 64MB, type WB
Setting variable MTRR 5, base: 3008MB, range: 32MB, type WB
range: 00000000be000000 - 00000000c0000000
Setting variable MTRR 6, base: 3040MB, range: 32MB, type WB
hole: 00000000bf700000 - 00000000c0000000
Setting variable MTRR 7, base: 3063MB, range: 1MB, type UC
rangeX: 0000000000000000 - 0000000040000000
DONE variable MTRRs
After WB checking
MTRR MAP PFN: 0000000000000000 - 00000000000c0000
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf700
MTRR MAP PFN: 00000000000bf800 - 00000000000c0000
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000bf700
MTRR MAP PFN: 00000000000bf800 - 00000000000c0000

gran_size: 1M   chunk_size_size: 64M
range0: 0000000000000000 - 00000000bc000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 512MB, type WB
Setting variable MTRR 2, base: 2560MB, range: 256MB, type WB
Setting variable MTRR 3, base: 2816MB, range: 128MB, type WB
Setting variable MTRR 4, base: 2944MB, range: 64MB, type WB
range: 00000000bc000000 - 00000000c0000000
Setting variable MTRR 5, base: 3008MB, range: 64MB, type WB
hole: 00000000bf700000 - 00000000c0000000
Setting variable MTRR 6, base: 3063MB, range: 1MB, type UC
Setting variable MTRR 7, base: 3064MB, range: 8MB, type UC
rangeX: 0000000000000000 - 0000000040000000
DONE variable MTRRs
After WB checking
MTRR MAP PFN: 0000000000000000 - 00000000000c0000
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf700
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000bf700

gran_size: 1M   chunk_size_size: 128M
range0: 0000000000000000 - 00000000b8000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 512MB, type WB
Setting variable MTRR 2, base: 2560MB, range: 256MB, type WB
Setting variable MTRR 3, base: 2816MB, range: 128MB, type WB
range: 00000000b8000000 - 00000000c0000000
Setting variable MTRR 4, base: 2944MB, range: 128MB, type WB
hole: 00000000bf700000 - 00000000c0000000
Setting variable MTRR 5, base: 3063MB, range: 1MB, type UC
Setting variable MTRR 6, base: 3064MB, range: 8MB, type UC
rangeX: 0000000000000000 - 0000000040000000
Setting variable MTRR 7, base: 4096MB, range: 1024MB, type WB
DONE variable MTRRs
After WB checking
MTRR MAP PFN: 0000000000000000 - 00000000000c0000
MTRR MAP PFN: 0000000000100000 - 0000000000140000
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf700
MTRR MAP PFN: 0000000000100000 - 0000000000140000
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000bf700
MTRR MAP PFN: 0000000000100000 - 0000000000140000

gran_size: 1M   chunk_size_size: 256M
range0: 0000000000000000 - 00000000b0000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 512MB, type WB
Setting variable MTRR 2, base: 2560MB, range: 256MB, type WB
range: 00000000b0000000 - 00000000c0000000
Setting variable MTRR 3, base: 2816MB, range: 256MB, type WB
hole: 00000000bf700000 - 00000000c0000000
Setting variable MTRR 4, base: 3063MB, range: 1MB, type UC
Setting variable MTRR 5, base: 3064MB, range: 8MB, type UC
rangeX: 0000000000000000 - 0000000040000000
Setting variable MTRR 6, base: 4096MB, range: 1024MB, type WB
DONE variable MTRRs
After WB checking
MTRR MAP PFN: 0000000000000000 - 00000000000c0000
MTRR MAP PFN: 0000000000100000 - 0000000000140000
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf700
MTRR MAP PFN: 0000000000100000 - 0000000000140000
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000bf700
MTRR MAP PFN: 0000000000100000 - 0000000000140000
Found optimal setting for mtrr clean up
gran_size: 1M  	chunk_size: 256M  	num_reg: 7  	lose cover RAM: 0M 
range0: 0000000000000000 - 00000000b0000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 512MB, type WB
Setting variable MTRR 2, base: 2560MB, range: 256MB, type WB
range: 00000000b0000000 - 00000000c0000000
Setting variable MTRR 3, base: 2816MB, range: 256MB, type WB
hole: 00000000bf700000 - 00000000c0000000
Setting variable MTRR 4, base: 3063MB, range: 1MB, type UC
Setting variable MTRR 5, base: 3064MB, range: 8MB, type UC
rangeX: 0000000000000000 - 0000000040000000
Setting variable MTRR 6, base: 4096MB, range: 1024MB, type WB
DONE variable MTRRs
x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
After WB checking
MTRR MAP PFN: 0000000000000000 - 00000000000c0000
MTRR MAP PFN: 0000000000100000 - 0000000000140000
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000bf700
MTRR MAP PFN: 0000000000100000 - 0000000000140000
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000bf700
MTRR MAP PFN: 0000000000100000 - 0000000000140000
Warning only 4GB will be used.
Use a HIGHMEM64G enabled kernel.
3200MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at [c00f6e10] 000f6e10
Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->  1048576
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->  1048576
On node 0 totalpages: 1048576
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 6400 pages used for memmap
  HighMem zone: 812800 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI present.
Using APIC driver default
ACPI: RSDP 000F6DE0, 0024 (r2 PTLTD )
ACPI: XSDT BF6D7236, 00AC (r1 SECCSD LH43STAR  6040000  LTP        0)
ACPI: FACP BF6DFB37, 00F4 (r3 INTEL  CRESTLNE  6040000 ALAN        1)
ACPI: DSDT BF6D9266, 685D (r2 INTEL  CRESTLNE  6040000 INTL 20050624)
ACPI: FACS BF6E2FC0, 0040
ACPI: APIC BF6DFC2B, 0068 (r1 INTEL  CRESTLNE  6040000 LOHR       5A)
ACPI: HPET BF6DFC93, 0038 (r1 INTEL  CRESTLNE  6040000 LOHR       5A)
ACPI: MCFG BF6DFCCB, 003C (r1 INTEL  CRESTLNE  6040000 LOHR       5A)
ACPI: TCPA BF6DFD07, 0032 (r1 Intel   CRESTLN  6040000          5A52)
ACPI: TMOR BF6DFD39, 0026 (r1 PTLTD            6040000 PTL         3)
ACPI: APIC BF6DFD5F, 0068 (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: HPET BF6DFDC7, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
ACPI: BOOT BF6DFDFF, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: ASF! BF6DFE27, 0063 (r16   CETP     CETP  6040000 PTL         1)
ACPI: SLIC BF6DFE8A, 0176 (r1 SECCSD LH43STAR  6040000  LTP        0)
ACPI: SSDT BF6D8C17, 064F (r1 SataRe  SataPri     1000 INTL 20050624)
ACPI: SSDT BF6D8585, 0692 (r1 SataRe  SataSec     1000 INTL 20050624)
ACPI: SSDT BF6D854C, 0039 (r1 BrtRef  DD01BRT     1000 INTL 20050624)
ACPI: SSDT BF6D786E, 025F (r1  PmRef  Cpu0Tst     3000 INTL 20050624)
ACPI: SSDT BF6D77C8, 00A6 (r1  PmRef  Cpu1Tst     3000 INTL 20050624)
ACPI: SSDT BF6D72E2, 04E6 (r1  PmRef    CpuPm     3000 INTL 20050624)
ACPI: BIOS bug: multiple APIC/MADT found, using 0
ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
ACPI: DMI detected: Samsung
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1 already used, trying 2
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 31232 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1040384
Kernel command line: root=/dev/hda6 init=/bin/bash
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Extended CMOS year: 2000
Detected 1995.177 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3095596k/4194304k available (3079k kernel code, 39520k reserved, 1707k data, 244k init, 2218816k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe18000 - 0xfffff000   (1948 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc05b3000 - 0xc05f0000   ( 244 kB)
      .data : 0xc0401f9f - 0xc05acf68   (1707 kB)
      .text : 0xc0100000 - 0xc0401f9f   (3079 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 3995.16 BogoMIPS (lpj=7990332)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 932 Objects with 77 Devices 247 Methods 37 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 10 Objects with 3 Devices 4 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 10 Objects with 3 Devices 4 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0004) - 0 Objects with 0 Devices 0 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0005) - 7 Objects with 0 Devices 3 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0006) - 4 Objects with 0 Devices 3 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0007) - 13 Objects with 0 Devices 4 Methods 0 Regions
 tbxface-0598 [02] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.03 BogoMIPS (lpj=7980072)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
x86 PAT enabled: cpu 1, old 0x7010600070106, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (7985.20 BogoMIPS).
net_namespace: 332 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
evgpeblk-0956 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1052 [03] ev_initialize_gpe_bloc: Found 3 Wake, Enabled 4 Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:........................................................................
Initialized 35/37 Regions 0/0 Fields 24/24 Buffers 13/21 Packages (985 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:<5>ACPI: BIOS _OSI(Linux) query ignored via DMI
.......
Executed 7 _INI methods requiring 0 _STA executions (examined 89 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 11) *10
ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
ACPI: PCI Interrupt Link [LNKC] (IRQs *10)
ACPI: PCI Interrupt Link [LNKD] (IRQs *5)
ACPI: PCI Interrupt Link [LNKE] (IRQs *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs *10)
ACPI: PCI Interrupt Link [LNKG] (IRQs *5)
ACPI: PCI Interrupt Link [LNKH] (IRQs *5)
ACPI: Power Resource [FN00] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:01: iomem range 0xfed40000-0xfed44fff could not be reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:04: iomem range 0xfed00000-0xfed003ff could not be reserved
system 00:06: ioport range 0x680-0x69f has been reserved
system 00:06: ioport range 0x6b0-0x6ff has been reserved
system 00:06: ioport range 0x800-0x80f has been reserved
system 00:06: ioport range 0x900-0x90f has been reserved
system 00:06: ioport range 0x1000-0x107f has been reserved
system 00:06: ioport range 0x1180-0x11bf has been reserved
system 00:06: ioport range 0x1640-0x164f has been reserved
system 00:06: ioport range 0xfe00-0xfe00 has been reserved
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: 0xf0300000-0xf03fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: 2000-2fff
  MEM window: 0xf0200000-0xf02fffff
  PREFETCH window: disabled.
PCI: Bus 5, cardbus bridge: 0000:04:09.0
  IO window: 0x00003000-0x000030ff
  IO window: 0x00003400-0x000034ff
  PREFETCH window: 0xc8000000-0xcbffffff
  MEM window: 0xcc000000-0xcfffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-3fff
  MEM window: 0xf0400000-0xf04fffff
  PREFETCH window: 0x00000000c2000000-0x00000000c5ffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:04:09.0[A] -> GSI 20 (level, low) -> IRQ 20
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x36 set to 0x1
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 1714 for ipc namespace c0564fc8
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.1
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: SAMSUNG HM160HI, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 512KiB
hda: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
hda: cache flushes supported
 hda: hda1 hda2 < hda5 hda6 hda7 >
3ware Storage Controller device driver for Linux v1.26.02.002.
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
PCI: Unable to reserve I/O region #1:8@1f0 for device 0000:00:1f.2
ata_piix 0000:00:1f.2: failed to request/iomap BARs for port 0 (errno=-16)
PCI: Unable to reserve I/O region #3:8@170 for device 0000:00:1f.2
ata_piix 0000:00:1f.2: failed to request/iomap BARs for port 1 (errno=-16)
ata_piix 0000:00:1f.2: no available native port
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
ACPI: PCI Interrupt 0000:04:09.1[B] -> GSI 21 (level, low) -> IRQ 21
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[21]  MMIO=[f0401000-f04017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
ieee1394: raw1394: /dev/raw1394 device initialized
usbmon: debugfs is not available
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf0704000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf0704400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-2: new high speed USB device using ehci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001860
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-2: configuration #1 chosen from 1 choice
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001880
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018a0
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 2-2: new high speed USB device using ehci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
hub 2-0:1.0: unable to enumerate USB device on port 5
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0000f0410107774d]
usb 7-1: new full speed USB device using uhci_hcd and address 2
usb 7-1: configuration #1 chosen from 1 choice
usb 2-2.2: new high speed USB device using ehci_hcd and address 4
usb 2-2.2: configuration #1 chosen from 1 choice
hub 2-2.2:1.0: USB hub found
hub 2-2.2:1.0: 4 ports detected
usb 2-2.2.1: new low speed USB device using ehci_hcd and address 5
usb 2-2.2.1: configuration #1 chosen from 1 choice
usb 2-2.2.2: new low speed USB device using ehci_hcd and address 6
usb 2-2.2.2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
input: HID 046a:0021 as /class/input/input0
input: USB HID v1.11 Keyboard [HID 046a:0021] on usb-0000:00:1d.7-2.2.1
input: HID 046a:0021 as /class/input/input1
input: USB HID v1.11 Device [HID 046a:0021] on usb-0000:00:1d.7-2.2.1
input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.7-2.2.2
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI No-Shortcut mode
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04713/0x200000
input: SynPS/2 Synaptics TouchPad as /class/input/input3
input: AT Translated Set 2 keyboard as /class/input/input4
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 244k freed
EXT3 FS on hda6, internal journal

--------------080506050109090308060904--
