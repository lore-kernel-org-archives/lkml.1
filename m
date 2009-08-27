Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZH0BNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZH0BNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 21:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbZH0BNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 21:13:41 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:58223 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZH0BNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 21:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:message-id;
        b=jyx04k5cW+2VJf1KqfHSJlqErSmRCfXs/AvowbHMkZlUn82RhZYRMoQHRM0MymkR/V
         7yhz6rlx8CtUdXRBDD3a+737LJwOAiYJz4BtuHRzjZhJG8bA1EK0l9JCg9nqV1H/EyHf
         yCgo2Rmv1ELPqB7LyJyaE7K5vELXv77D5gddc=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and earlier.
Date: Thu, 27 Aug 2009 03:13:32 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30.5r4; KDE/4.3.0; x86_64; ; )
References: <200908211814.56800.volkerarmin@googlemail.com> <200908222126.31390.volkerarmin@googlemail.com> <86802c440908222322s44957498s72a76940f89271cf@mail.gmail.com>
In-Reply-To: <86802c440908222322s44957498s72a76940f89271cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_82dlKfr5G2p/RkC"
Message-Id: <200908270313.32528.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_82dlKfr5G2p/RkC
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi,

On Sonntag 23 August 2009, Yinghai Lu wrote:
> On Sat, Aug 22, 2009 at 12:26 PM, Volker Armin
>
> Hemmann<volkerarmin@googlemail.com> wrote:
> > when I went from 4gb to 6gb I had a performance degradation. Since the
> > 8gb are faster and the new cpu is faster, I don't see degradation. But I
> > wonder how much better performance could be with 'correct' mtrr.
>
> that is weird. with 4g should have mem hole remapping.
>
> do you still have /proc/mtrr for 6g setup?
>
> YH

some more information, mtrr of 8gb with my X2 6000:

reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg02: base=0x0c0000000 ( 3072MB), size=  128MB, count=1: write-back
reg03: base=0x0c8000000 ( 3200MB), size=   64MB, count=1: write-back
reg04: base=0x0cc000000 ( 3264MB), size=   32MB, count=1: write-back
reg05: base=0x0ce000000 ( 3296MB), size=   16MB, count=1: write-back

from June with 2.6.30, dmesg from that incident is attached

compared that with the mtrr with my X4:

reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg02: base=0x0c0000000 ( 3072MB), size=  128MB, count=1: write-back


just ignore the fgrlx parts - whenever I checked it did not made a difference 
if X was started or not.

--Boundary-00=_82dlKfr5G2p/RkC
Content-Type: text/plain;
  charset="ISO-8859-15";
  name="dmesg_8gb_x2_6000"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_8gb_x2_6000"

[    0.000000] Linux version 2.6.30r4 (root@energy) (gcc version 4.4.0 (Gentoo 4.4.0 p1.0) ) #2 SMP Sat Jun 27 00:46:23 CEST 2009
[    0.000000] Command line: root=/dev/md1 md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=0 amd_iommu_size=128M mtrr_spare_reg_nr=0
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000ceeb0000 (usable)
[    0.000000]  BIOS-e820: 00000000ceeb0000 - 00000000ceec0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000ceec0000 - 00000000ceef0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ceef0000 - 00000000cef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000231000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x231000 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFF8000000 write-back
[    0.000000]   3 base 00C8000000 mask FFFC000000 write-back
[    0.000000]   4 base 00CC000000 mask FFFE000000 write-back
[    0.000000]   5 base 00CE000000 mask FFFF000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000231000000 aka 8976M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cf000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xceeb0 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000ceeb0000
[    0.000000]  0000000000 - 00cee00000 page 2M
[    0.000000]  00cee00000 - 00ceeb0000 page 4k
[    0.000000] kernel direct mapping tables up to ceeb0000 @ 10000-16000
[    0.000000] init_memory_mapping: 0000000100000000-0000000231000000
[    0.000000]  0100000000 - 0231000000 page 2M
[    0.000000] kernel direct mapping tables up to 231000000 @ 14000-1e000
[    0.000000] ACPI: RSDP 00000000000fa7b0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000ceeb0000 00040 (v01 121508 RSDT1922 20081215 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000ceeb0200 00084 (v02 A_M_I  OEMFACP  12000601 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000ceeb0440 08512 (v01  AS140 AS140115 00000115 INTL 20051117)
[    0.000000] ACPI: FACS 00000000ceec0000 00040
[    0.000000] ACPI: APIC 00000000ceeb0390 0006C (v01 121508 APIC1922 20081215 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000ceeb0400 0003C (v01 121508 OEMMCFG  20081215 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000ceec0040 00071 (v01 121508 OEMB1922 20081215 MSFT 00000097)
[    0.000000] ACPI: AAFT 00000000ceeb8960 00027 (v01 121508 OEMAAFT  20081215 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000ceeb8990 00038 (v01 121508 OEMHPET  20081215 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000ceeb89d0 0030E (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0231000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000156ffbc]    TEXT DATA BSS ==> [0001000000 - 000156ffbc]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [0001570000 - 0001570133]              BRK ==> [0001570000 - 0001570133]
[    0.000000]   #5 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 - 0000014000]
[    0.000000]   #6 [0000014000 - 0000019000]          PGTABLE ==> [0000014000 - 0000019000]
[    0.000000]  [ffffe20000000000-ffffe20007dfffff] PMD -> [ffff880028200000-ffff88002fffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00231000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000ceeb0
[    0.000000]     0: 0x00100000 -> 0x00231000
[    0.000000] On node 0 totalpages: 2096703
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 108 pages reserved
[    0.000000]   DMA zone: 3819 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 829160 pages, LIFO batch:31
[    0.000000]   Normal zone: 17080 pages used for memmap
[    0.000000]   Normal zone: 1232200 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000ceeb0000 - 00000000ceec0000
[    0.000000] PM: Registered nosave memory: 00000000ceec0000 - 00000000ceef0000
[    0.000000] PM: Registered nosave memory: 00000000ceef0000 - 00000000cef00000
[    0.000000] PM: Registered nosave memory: 00000000cef00000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: cef00000:31000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 24 pages at ffff880028034000, static data 67744 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065179
[    0.000000] Kernel command line: root=/dev/md1 md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=0 amd_iommu_size=128M mtrr_spare_reg_nr=0
[    0.000000] md: Will configure md3 (super-block) from /dev/sda3,/dev/sdb3,/dev/sdc3, below.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:320
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3000.107 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.003333] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] Node 0: aperture @ e8c8000000 size 32 MB
[    0.003333] Aperture beyond 4GB. Ignoring.
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.003333] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.003333] Memory: 8172932k/9191424k available (3234k kernel code, 804612k absent, 212996k reserved, 1300k data, 348k init)
[    0.003333] hpet clockevent registered
[    0.003333] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.003338] Calibrating delay loop (skipped), value calculated using timer frequency.. 6002.22 BogoMIPS (lpj=10000356)
[    0.003480] Mount-cache hash table entries: 256
[    0.003616] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003669] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003721] tseg: 0000000000
[    0.003726] CPU: Physical Processor ID: 0
[    0.003778] CPU: Processor Core ID: 0
[    0.003835] using C1E aware idle routine
[    0.003896] ACPI: Core revision 20090320
[    0.011804] Setting APIC routing to flat
[    0.012172] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.045231] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.046666] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6002.12 BogoMIPS (lpj=10000202)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.136931] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.137414] Brought up 2 CPUs
[    0.137466] Total of 2 processors activated (12005.34 BogoMIPS).
[    0.137710] net_namespace: 608 bytes
[    0.137824] xor: automatically using best checksumming function: generic_sse
[    0.153334]    generic_sse:  9249.600 MB/sec
[    0.153386] xor: using function: generic_sse (9249.600 MB/sec)
[    0.153459] Time: 14:03:02  Date: 06/28/09
[    0.153533] NET: Registered protocol family 16
[    0.153710] node 0 link 0: io port [1000, ffffff]
[    0.153713] TOM: 00000000cf000000 aka 3312M
[    0.153767] node 0 link 0: mmio [e0000000, efffffff]
[    0.153769] node 0 link 0: mmio [f0000000, ffffffff]
[    0.153771] node 0 link 0: mmio [a0000, bffff]
[    0.153773] node 0 link 0: mmio [cf000000, dfffffff]
[    0.153774] TOM2: 0000000231000000 aka 8976M
[    0.153827] bus: [00,07] on node 0 link 0
[    0.153828] bus: 00 index 0 io port: [0, ffff]
[    0.153830] bus: 00 index 1 mmio: [cf000000, ffffffff]
[    0.153831] bus: 00 index 2 mmio: [a0000, bffff]
[    0.153833] bus: 00 index 3 mmio: [231000000, fcffffffff]
[    0.153837] ACPI: bus type pci registered
[    0.153949] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.154003] PCI: Not using MMCONFIG.
[    0.154055] PCI: Using configuration type 1 for base access
[    0.155427] bio: create slab <bio-0> at 0
[    0.155885] ACPI: EC: Look up EC in DSDT
[    0.163220] ACPI: Interpreter enabled
[    0.163273] ACPI: (supports S0 S1 S3 S4 S5)
[    0.163424] ACPI: Using IOAPIC for interrupt routing
[    0.163518] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.166738] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.174519] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.180654] ACPI: No dock devices found.
[    0.180898] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.181006] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.181062] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.181116] pci 0000:00:02.0: PME# disabled
[    0.181207] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.181261] pci 0000:00:09.0: PME# disabled
[    0.181345] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.181398] pci 0000:00:0a.0: PME# disabled
[    0.181500] pci 0000:00:11.0: reg 10 io port: [0xa000-0xa007]
[    0.181506] pci 0000:00:11.0: reg 14 io port: [0x9000-0x9003]
[    0.181513] pci 0000:00:11.0: reg 18 io port: [0x8000-0x8007]
[    0.181520] pci 0000:00:11.0: reg 1c io port: [0x7000-0x7003]
[    0.181526] pci 0000:00:11.0: reg 20 io port: [0x6000-0x600f]
[    0.181533] pci 0000:00:11.0: reg 24 32bit mmio: [0xfddff800-0xfddffbff]
[    0.181587] pci 0000:00:12.0: reg 10 32bit mmio: [0xfddfe000-0xfddfefff]
[    0.181643] pci 0000:00:12.1: reg 10 32bit mmio: [0xfddfd000-0xfddfdfff]
[    0.181718] pci 0000:00:12.2: reg 10 32bit mmio: [0xfddff000-0xfddff0ff]
[    0.181773] pci 0000:00:12.2: supports D1 D2
[    0.181774] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.181829] pci 0000:00:12.2: PME# disabled
[    0.181912] pci 0000:00:13.0: reg 10 32bit mmio: [0xfddfc000-0xfddfcfff]
[    0.181969] pci 0000:00:13.1: reg 10 32bit mmio: [0xfddf7000-0xfddf7fff]
[    0.182043] pci 0000:00:13.2: reg 10 32bit mmio: [0xfddf6800-0xfddf68ff]
[    0.182097] pci 0000:00:13.2: supports D1 D2
[    0.182099] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.182154] pci 0000:00:13.2: PME# disabled
[    0.182326] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.182333] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.182340] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.182346] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.182353] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.182491] pci 0000:00:14.5: reg 10 32bit mmio: [0xfddf5000-0xfddf5fff]
[    0.182625] pci 0000:02:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
[    0.182633] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdff0000-0xfdffffff]
[    0.182639] pci 0000:02:00.0: reg 20 io port: [0xc000-0xc0ff]
[    0.182647] pci 0000:02:00.0: reg 30 32bit mmio: [0xfdfc0000-0xfdfdffff]
[    0.182665] pci 0000:02:00.0: supports D1 D2
[    0.182698] pci 0000:02:00.1: reg 10 64bit mmio: [0xfdfec000-0xfdfeffff]
[    0.182733] pci 0000:02:00.1: supports D1 D2
[    0.182789] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]
[    0.182792] pci 0000:00:02.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]
[    0.182795] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.182843] pci 0000:00:09.0: bridge io port: [0xd000-0xdfff]
[    0.182845] pci 0000:00:09.0: bridge 32bit mmio: [0xfe000000-0xfeafffff]
[    0.182849] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfa000000-0xfcefffff]
[    0.182885] pci 0000:01:00.0: reg 10 io port: [0xb800-0xb8ff]
[    0.182900] pci 0000:01:00.0: reg 18 64bit mmio: [0xcffff000-0xcfffffff]
[    0.182910] pci 0000:01:00.0: reg 20 64bit mmio: [0xcffe0000-0xcffeffff]
[    0.182917] pci 0000:01:00.0: reg 30 32bit mmio: [0xfdef0000-0xfdefffff]
[    0.182948] pci 0000:01:00.0: supports D1 D2
[    0.182949] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.183004] pci 0000:01:00.0: PME# disabled
[    0.183115] pci 0000:00:0a.0: bridge io port: [0xb000-0xbfff]
[    0.183117] pci 0000:00:0a.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.183121] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xcff00000-0xcfffffff]
[    0.183172] pci 0000:05:05.0: reg 10 io port: [0xe800-0xe8ff]
[    0.183180] pci 0000:05:05.0: reg 14 32bit mmio: [0xfebffc00-0xfebffdff]
[    0.183236] pci 0000:05:05.0: supports D1 D2
[    0.183238] pci 0000:05:05.0: PME# supported from D1 D2 D3hot D3cold
[    0.183294] pci 0000:05:05.0: PME# disabled
[    0.183362] pci 0000:05:06.0: reg 10 32bit mmio: [0xfcfff000-0xfcffffff]
[    0.183448] pci 0000:05:08.0: reg 10 io port: [0xe400-0xe43f]
[    0.183509] pci 0000:05:08.0: supports D1 D2
[    0.183555] pci 0000:00:14.4: transparent bridge
[    0.183610] pci 0000:00:14.4: bridge io port: [0xe000-0xefff]
[    0.183614] pci 0000:00:14.4: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.183618] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfcf00000-0xfcffffff]
[    0.183632] pci_bus 0000:00: on NUMA node 0
[    0.183637] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.183794] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.183841] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.183889] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.183960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.187037] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
[    0.187324] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)
[    0.187609] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    0.187894] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.188178] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 *11 12 14 15)
[    0.188464] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 *10 11 12 14 15)
[    0.188749] ACPI: PCI Interrupt Link [LNKG] (IRQs *4 10 11 12 14 15)
[    0.189018] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)
[    0.189432] SCSI subsystem initialized
[    0.189525] libata version 3.00 loaded.
[    0.189609] usbcore: registered new interface driver usbfs
[    0.189688] usbcore: registered new interface driver hub
[    0.189772] usbcore: registered new device driver usb
[    0.243337] raid6: int64x1   2557 MB/s
[    0.300018] raid6: int64x2   3408 MB/s
[    0.356686] raid6: int64x4   2162 MB/s
[    0.413358] raid6: int64x8   2341 MB/s
[    0.470002] raid6: sse2x1    4312 MB/s
[    0.526673] raid6: sse2x2    5658 MB/s
[    0.583337] raid6: sse2x4    5812 MB/s
[    0.583389] raid6: using algorithm sse2x4 (5812 MB/s)
[    0.583464] PCI: Using ACPI for IRQ routing
[    0.583523] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.590192] PCI-DMA: Disabling AGP.
[    0.590327] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.590380] PCI-DMA: using GART IOMMU.
[    0.590438] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.590915] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.591054] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.593355] hpet: hpet2 irq 24 for MSI
[    0.596684] Switched to high resolution mode on CPU 0
[    0.596914] Switched to high resolution mode on CPU 1
[    0.610016] pnp: PnP ACPI init
[    0.610080] ACPI: bus type pnp registered
[    0.612578] pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.612668] pnp 00:0b: mem resource (0xc0000-0xcffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.612757] pnp 00:0b: mem resource (0xe0000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.612846] pnp 00:0b: mem resource (0x100000-0xceefffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.613219] pnp: PnP ACPI: found 12 devices
[    0.613272] ACPI: ACPI bus type pnp unregistered
[    0.613347] system 00:06: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.613401] system 00:06: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.613457] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.613510] system 00:07: ioport range 0x40b-0x40b has been reserved
[    0.613564] system 00:07: ioport range 0x4d6-0x4d6 has been reserved
[    0.613618] system 00:07: ioport range 0xc00-0xc01 has been reserved
[    0.613671] system 00:07: ioport range 0xc14-0xc14 has been reserved
[    0.613725] system 00:07: ioport range 0xc50-0xc51 has been reserved
[    0.613778] system 00:07: ioport range 0xc52-0xc52 has been reserved
[    0.613831] system 00:07: ioport range 0xc6c-0xc6c has been reserved
[    0.613885] system 00:07: ioport range 0xc6f-0xc6f has been reserved
[    0.613938] system 00:07: ioport range 0xcd0-0xcd1 has been reserved
[    0.613991] system 00:07: ioport range 0xcd2-0xcd3 has been reserved
[    0.614044] system 00:07: ioport range 0xcd4-0xcd5 has been reserved
[    0.614098] system 00:07: ioport range 0xcd6-0xcd7 has been reserved
[    0.614151] system 00:07: ioport range 0xcd8-0xcdf has been reserved
[    0.614209] system 00:07: ioport range 0x800-0x89f has been reserved
[    0.614262] system 00:07: ioport range 0xb00-0xb0f has been reserved
[    0.614315] system 00:07: ioport range 0xb20-0xb3f has been reserved
[    0.614369] system 00:07: ioport range 0x900-0x90f has been reserved
[    0.614422] system 00:07: ioport range 0x910-0x91f has been reserved
[    0.614476] system 00:07: ioport range 0xfe00-0xfefe has been reserved
[    0.614529] system 00:07: iomem range 0xffb80000-0xffbfffff has been reserved
[    0.614583] system 00:07: iomem range 0xfec10000-0xfec1001f has been reserved
[    0.614638] system 00:09: ioport range 0x290-0x29f has been reserved
[    0.614693] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.614749] system 00:0b: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.619596] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
[    0.619650] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    0.619705] pci 0000:00:02.0:   MEM window: 0xfdf00000-0xfdffffff
[    0.619759] pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.619848] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    0.619902] pci 0000:00:09.0:   IO window: 0xd000-0xdfff
[    0.619956] pci 0000:00:09.0:   MEM window: 0xfe000000-0xfeafffff
[    0.620023] pci 0000:00:09.0:   PREFETCH window: 0x000000fa000000-0x000000fcefffff
[    0.620112] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:01
[    0.620165] pci 0000:00:0a.0:   IO window: 0xb000-0xbfff
[    0.620219] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff
[    0.620273] pci 0000:00:0a.0:   PREFETCH window: 0x000000cff00000-0x000000cfffffff
[    0.620363] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
[    0.620417] pci 0000:00:14.4:   IO window: 0xe000-0xefff
[    0.620473] pci 0000:00:14.4:   MEM window: 0xfeb00000-0xfebfffff
[    0.620528] pci 0000:00:14.4:   PREFETCH window: 0x000000fcf00000-0x000000fcffffff
[    0.620626] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.620681] pci 0000:00:02.0: setting latency timer to 64
[    0.620687] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.620741] pci 0000:00:09.0: setting latency timer to 64
[    0.620745] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.620798] pci 0000:00:0a.0: setting latency timer to 64
[    0.620806] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.620808] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.620810] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    0.620812] pci_bus 0000:02: resource 1 mem: [0xfdf00000-0xfdffffff]
[    0.620814] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.620816] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    0.620817] pci_bus 0000:03: resource 1 mem: [0xfe000000-0xfeafffff]
[    0.620819] pci_bus 0000:03: resource 2 pref mem [0xfa000000-0xfcefffff]
[    0.620821] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.620823] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.620825] pci_bus 0000:01: resource 2 pref mem [0xcff00000-0xcfffffff]
[    0.620827] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
[    0.620829] pci_bus 0000:05: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.620830] pci_bus 0000:05: resource 2 pref mem [0xfcf00000-0xfcffffff]
[    0.620832] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.620834] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.620861] NET: Registered protocol family 2
[    0.656706] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.657789] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.659447] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.659987] TCP: Hash tables configured (established 262144 bind 65536)
[    0.660062] TCP reno registered
[    0.670061] NET: Registered protocol family 1
[    0.671306] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.671435] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[    0.671590] msgmni has been set to 15964
[    0.671801] alg: No test for stdrng (krng)
[    0.671856] async_tx: api initialized (sync-only)
[    0.671941] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.672029] io scheduler noop registered
[    0.672092] io scheduler cfq registered (default)
[    0.800021] pci 0000:02:00.0: Boot video device
[    0.800134] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.800143] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.800254] pcieport-driver 0000:00:09.0: irq 26 for MSI/MSI-X
[    0.800262] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.800371] pcieport-driver 0000:00:0a.0: irq 27 for MSI/MSI-X
[    0.800379] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    0.800631] input: Power Button as /class/input/input0
[    0.800684] ACPI: Power Button [PWRF]
[    0.800793] input: Power Button as /class/input/input1
[    0.800848] ACPI: Power Button [PWRB]
[    0.801020] processor ACPI_CPU:00: registered as cooling_device0
[    0.801074] ACPI: Processor [P001] (supports 8 throttling states)
[    0.801200] processor ACPI_CPU:01: registered as cooling_device1
[    0.805016] Linux agpgart interface v0.103
[    0.805174] Driver 'sd' needs updating - please use bus_type methods
[    0.805284] ahci 0000:00:11.0: version 3.0
[    0.805298] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.805468] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.805557] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    0.806030] scsi0 : ahci
[    0.806175] scsi1 : ahci
[    0.806272] scsi2 : ahci
[    0.806367] scsi3 : ahci
[    0.806464] scsi4 : ahci
[    0.806564] scsi5 : ahci
[    0.806736] ata1: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff900 irq 22
[    0.806825] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff980 irq 22
[    0.806914] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa00 irq 22
[    0.807002] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa80 irq 22
[    0.807091] ata5: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb00 irq 22
[    0.807179] ata6: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb80 irq 22
[    0.807478] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.807535] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.808136] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.808243] mice: PS/2 mouse device common for all mice
[    0.808393] rtc_cmos 00:02: RTC can wake from S4
[    0.808481] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.808558] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.808630] md: raid1 personality registered for level 1
[    0.808683] md: raid6 personality registered for level 6
[    0.808735] md: raid5 personality registered for level 5
[    0.808788] md: raid4 personality registered for level 4
[    0.808909] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    0.809023] cpuidle: using governor ladder
[    0.809169] usbcore: registered new interface driver hiddev
[    0.809241] usbcore: registered new interface driver usbhid
[    0.809295] usbhid: v2.6:USB HID core driver
[    0.809375] TCP cubic registered
[    0.809428] NET: Registered protocol family 17
[    0.809493] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[    0.809622] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[    0.809676] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[    0.809729] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[    0.809781] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[    0.809834] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[    0.809887] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[    0.809939] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[    0.809992] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    0.810198] PM: Resume from disk failed.
[    0.810303]   Magic number: 13:102:82
[    0.833832] input: AT Translated Set 2 keyboard as /class/input/input2
[    1.126701] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.126781] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.126854] ata5: SATA link down (SStatus 0 SControl 300)
[    1.126931] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.127004] ata3: SATA link down (SStatus 0 SControl 300)
[    1.127078] ata6: SATA link down (SStatus 0 SControl 300)
[    1.133063] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
[    1.133122] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.133185] ata4.00: ATA-7: SAMSUNG HD753LJ, 1AA01113, max UDMA7
[    1.133246] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.133286] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7
[    1.133287] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.139554] ata1.00: configured for UDMA/133
[    1.139682] ata2.00: configured for UDMA/133
[    1.139811] ata4.00: configured for UDMA/133
[    1.150914] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    1.151138] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    1.152079] sd 0:0:0:0: [sda] Write Protect is off
[    1.152132] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.152143] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.152273]  sda:<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.152430] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    1.152616] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    1.152709] sd 1:0:0:0: [sdb] Write Protect is off
[    1.152762] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.152771] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.152894]  sdb:<5>sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.153036] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[    1.153217] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    1.153291] sd 3:0:0:0: [sdc] 1465149168 512-byte hardware sectors: (750 GB/698 GiB)
[    1.153399] sd 3:0:0:0: [sdc] Write Protect is off
[    1.153452] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.153462] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.153586]  sdc: sdc1 sdc2 sdc3 sdc4 < sda1 sda2 sda3 sda4 < sdb1 sdb2 sdb3 sdb4 < sda5 sdc5 sdc6 sdb5 sda6 >
[    1.178636] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.187480]  sdc7 >
[    1.187819]  sdb6 >
[    1.188149] sd 3:0:0:0: [sdc] Attached SCSI disk
[    1.188317] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.188377] md: Waiting for all devices to be available before autodetect
[    1.188431] md: If you don't use raid, use raid=noautodetect
[    1.188560] md: Autodetecting RAID arrays.
[    1.303098] md: Scanned 12 and added 12 devices.
[    1.303151] md: autorun ...
[    1.303203] md: considering sdb6 ...
[    1.303257] md:  adding sdb6 ...
[    1.303310] md: sdb5 has different UUID to sdb6
[    1.303372] md: sdb3 has different UUID to sdb6
[    1.303425] md: sdb1 has different UUID to sdb6
[    1.303479] md:  adding sdc6 ...
[    1.303532] md: sdc5 has different UUID to sdb6
[    1.303585] md: sdc3 has different UUID to sdb6
[    1.303639] md: sdc1 has different UUID to sdb6
[    1.303693] md:  adding sda6 ...
[    1.303745] md: sda5 has different UUID to sdb6
[    1.303799] md: sda3 has different UUID to sdb6
[    1.303852] md: sda1 has different UUID to sdb6
[    1.303983] md: created md3
[    1.304035] md: bind<sda6>
[    1.304092] md: bind<sdc6>
[    1.304148] md: bind<sdb6>
[    1.304213] md: running: <sdb6><sdc6><sda6>
[    1.304363] raid5: device sdb6 operational as raid disk 1
[    1.304415] raid5: device sdc6 operational as raid disk 2
[    1.304468] raid5: device sda6 operational as raid disk 0
[    1.304715] raid5: allocated 3220kB for md3
[    1.304778] raid5: raid level 5 set md3 active with 3 out of 3 devices, algorithm 2
[    1.304866] RAID5 conf printout:
[    1.304918]  --- rd:3 wd:3
[    1.304969]  disk 0, o:1, dev:sda6
[    1.305021]  disk 1, o:1, dev:sdb6
[    1.305073]  disk 2, o:1, dev:sdc6
[    1.305159] md: considering sdb5 ...
[    1.305215] md:  adding sdb5 ...
[    1.305268] md: sdb3 has different UUID to sdb5
[    1.305321] md: sdb1 has different UUID to sdb5
[    1.305375] md:  adding sdc5 ...
[    1.305429] md: sdc3 has different UUID to sdb5
[    1.305482] md: sdc1 has different UUID to sdb5
[    1.305536] md:  adding sda5 ...
[    1.305589] md: sda3 has different UUID to sdb5
[    1.305643] md: sda1 has different UUID to sdb5
[    1.305758] md: created md2
[    1.305810] md: bind<sda5>
[    1.305866] md: bind<sdc5>
[    1.305923] md: bind<sdb5>
[    1.305980] md: running: <sdb5><sdc5><sda5>
[    1.306123] raid5: device sdb5 operational as raid disk 1
[    1.306175] raid5: device sdc5 operational as raid disk 2
[    1.306228] raid5: device sda5 operational as raid disk 0
[    1.306488] raid5: allocated 3220kB for md2
[    1.306552] raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2
[    1.306639] RAID5 conf printout:
[    1.306698]  --- rd:3 wd:3
[    1.306750]  disk 0, o:1, dev:sda5
[    1.306802]  disk 1, o:1, dev:sdb5
[    1.306854]  disk 2, o:1, dev:sdc5
[    1.306937] md: considering sdb3 ...
[    1.306993] md:  adding sdb3 ...
[    1.307046] md: sdb1 has different UUID to sdb3
[    1.307101] md:  adding sdc3 ...
[    1.307154] md: sdc1 has different UUID to sdb3
[    1.307208] md:  adding sda3 ...
[    1.307261] md: sda1 has different UUID to sdb3
[    1.307369] md: created md1
[    1.307422] md: bind<sda3>
[    1.307478] md: bind<sdc3>
[    1.307544] md: bind<sdb3>
[    1.307600] md: running: <sdb3><sdc3><sda3>
[    1.307742] raid5: device sdb3 operational as raid disk 1
[    1.307795] raid5: device sdc3 operational as raid disk 2
[    1.307848] raid5: device sda3 operational as raid disk 0
[    1.308111] raid5: allocated 3220kB for md1
[    1.308174] raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
[    1.308261] RAID5 conf printout:
[    1.308313]  --- rd:3 wd:3
[    1.308365]  disk 0, o:1, dev:sda3
[    1.308417]  disk 1, o:1, dev:sdb3
[    1.308469]  disk 2, o:1, dev:sdc3
[    1.308552] md: considering sdb1 ...
[    1.308607] md:  adding sdb1 ...
[    1.308661] md:  adding sdc1 ...
[    1.308714] md:  adding sda1 ...
[    1.308767] md: created md0
[    1.308819] md: bind<sda1>
[    1.308877] md: bind<sdc1>
[    1.308934] md: bind<sdb1>
[    1.308990] md: running: <sdb1><sdc1><sda1>
[    1.309170] raid1: raid set md0 active with 3 out of 3 mirrors
[    1.309252] md: ... autorun DONE.
[    1.309330] md: Loading md3: /dev/sda3
[    1.309391]  md3: unknown partition table
[    1.309585] md: couldn't update array info. -22
[    1.309641] md: could not bd_claim sda3.
[    1.309694] md: md_import_device returned -16
[    1.309748] md: could not bd_claim sdb3.
[    1.309800] md: md_import_device returned -16
[    1.309854] md: could not bd_claim sdc3.
[    1.309905] md: md_import_device returned -16
[    1.309958] md: starting md3 failed
[    1.310056]  md1: unknown partition table
[    1.356793] reiser4: md1: found disk format 4.0.0.
[    5.390569] VFS: Mounted root (reiser4 filesystem) readonly on device 9:1.
[    5.390642] Freeing unused kernel memory: 348k freed
[    9.065384] udev: starting version 141
[    9.065405] udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
[    9.382904]  md0: unknown partition table
[    9.388785]  md2: unknown partition table
[   10.684104] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   10.684120] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   10.684133] r8169 0000:01:00.0: setting latency timer to 64
[   10.684506] r8169 0000:01:00.0: irq 28 for MSI/MSI-X
[   10.684588] eth0: RTL8168c/8111c at 0xffffc20012e10000, 00:19:66:86:ce:12, XID 3c4000c0 IRQ 28
[   10.715247] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.715273] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   10.715299] ehci_hcd 0000:00:12.2: EHCI Host Controller
[   10.715833] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[   10.715864] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[   10.715882] ehci_hcd 0000:00:12.2: debug port 1
[   10.715900] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[   10.724178] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   10.724212] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   10.724214] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.724216] usb usb1: Product: EHCI Host Controller
[   10.724217] usb usb1: Manufacturer: Linux 2.6.30r4 ehci_hcd
[   10.724219] usb usb1: SerialNumber: 0000:00:12.2
[   10.724273] usb usb1: configuration #1 chosen from 1 choice
[   10.724298] hub 1-0:1.0: USB hub found
[   10.724307] hub 1-0:1.0: 6 ports detected
[   10.724411] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   10.724431] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   10.724467] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[   10.724488] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[   10.724507] ehci_hcd 0000:00:13.2: debug port 1
[   10.724522] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[   10.734185] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   10.734209] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   10.734211] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.734213] usb usb2: Product: EHCI Host Controller
[   10.734215] usb usb2: Manufacturer: Linux 2.6.30r4 ehci_hcd
[   10.734216] usb usb2: SerialNumber: 0000:00:13.2
[   10.734275] usb usb2: configuration #1 chosen from 1 choice
[   10.734300] hub 2-0:1.0: USB hub found
[   10.734308] hub 2-0:1.0: 6 ports detected
[   10.778632] Linux video capture interface: v2.00
[   10.789097] bttv: driver version 0.9.18 loaded
[   10.789100] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   10.789129] bttv: Bt8xx card found (0).
[   10.789141] bttv 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   10.789152] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 32, mmio: 0xfcfff000
[   10.789776] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra TValue Version 1.0/ Vobis TV-Boostar [card=25,insmod option]
[   10.789779] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[   10.789819] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
[   11.030844] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   11.155884] usb 1-3: New USB device found, idVendor=05e3, idProduct=0608
[   11.155885] usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   11.155887] usb 1-3: Product: USB2.0 Hub
[   11.155935] usb 1-3: configuration #1 chosen from 1 choice
[   11.156149] hub 1-3:1.0: USB hub found
[   11.156502] hub 1-3:1.0: 4 ports detected
[   11.424864] usb 1-3.1: new low speed USB device using ehci_hcd and address 3
[   11.514100] usb 1-3.1: New USB device found, idVendor=046d, idProduct=c518
[   11.514102] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   11.514104] usb 1-3.1: Product: USB Receiver
[   11.514105] usb 1-3.1: Manufacturer: Logitech
[   11.514158] usb 1-3.1: configuration #1 chosen from 1 choice
[   11.524577] input: Logitech USB Receiver as /class/input/input3
[   11.524629] generic-usb 0003:046D:C518.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.2-3.1/input0
[   11.530287] input: Logitech USB Receiver as /class/input/input4
[   11.530354] generic-usb 0003:046D:C518.0002: input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-3.1/input1
[   11.790024] bttv0: tea5757: read timeout
[   11.790027] bttv0: tuner type=5
[   11.808501] All bytes are equal. It is not a TEA5767
[   11.808540] tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])
[   11.811730] tuner-simple 0-0060: creating new instance
[   11.811733] tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
[   11.825006] bttv0: audio absent, no audio device found!
[   11.825049] bttv0: registered device video0
[   11.825069] bttv0: registered device vbi0
[   11.844462] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   11.844465] e100: Copyright(c) 1999-2006 Intel Corporation
[   12.193039] reiser4: md2: found disk format 4.0.0.
[   13.997414] reiser4: md3: found disk format 4.0.0.
[   55.180844] reiser4: sdc7: found disk format 4.0.0.
[   67.595571] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1 across:7815612k 
[   67.606657] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1 across:7815612k 
[   67.617095] Adding 7815612k swap on /dev/sdc2.  Priority:1 extents:1 across:7815612k 
[   68.400516] w83627ehf: Found W83627EHG chip at 0x290
[   68.410870] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[   68.814675] r8169: eth0: link up
[   68.814682] r8169: eth0: link up
[   69.000840] Clocksource tsc unstable (delta = -134183872 ns)
[   71.440722] EMU10K1_Audigy 0000:05:08.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   71.448506] Audigy2 value: Special config.
[   72.793961] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[   72.793971] Disabling lock debugging due to kernel taint
[   72.849012] [fglrx] Maximum main memory to use for locked dma buffers: 7749 MBytes.
[   72.849222] [fglrx]   vendor: 1002 device: 9501 count: 1
[   72.849704] [fglrx] ioport: bar 4, base 0xc000, size: 0x100
[   72.849728] pci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   72.849738] pci 0000:02:00.0: setting latency timer to 64
[   72.850071] [fglrx] Kernel PAT support is enabled
[   72.850115] [fglrx] module loaded - fglrx 8.62.4 [May 20 2009] with 1 minors
[   74.433201] fglrx_pci 0000:02:00.0: irq 29 for MSI/MSI-X
[   74.433535] [fglrx] Firegl kernel thread PID: 3915
[   74.448363] [fglrx] Gart USWC size:1279 M.
[   74.448366] [fglrx] Gart cacheable size:508 M.
[   74.448371] [fglrx] Reserved FB block: Shared offset:0, size:1000000 
[   74.448373] [fglrx] Reserved FB block: Unshared offset:fbff000, size:401000 
[   74.448375] [fglrx] Reserved FB block: Unshared offset:1fffc000, size:4000 
[   74.457643] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fae1f0000,handle:0xd0000000
[   74.515927] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fad83f000,handle:0xd10a0000
[   74.532065] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e96000,handle:0xd11a0000
[   74.532114] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb11a5000,handle:0xd11a4000
[   74.751708] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e95000,handle:0xd11a8000
[   74.751730] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e94000,handle:0xd11a9000
[   74.984297] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac307000,handle:0xfdff0000
[   74.984492] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac2c7000,handle:0xd11aa000
[   74.988311] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac2c7000,handle:0xd11aa000
[   75.004646] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac23c000,handle:0xfdff0000
[   75.550286] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac23c000,handle:0xfdff0000
[   75.550325] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac307000,handle:0xfdff0000
[   75.550447] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fad83f000,handle:0xd10a0000
[   75.551925] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fae1f0000,handle:0xd0000000
[   75.552052] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb11a5000,handle:0xd11a4000
[   75.552114] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e94000,handle:0xd11a9000
[   75.552125] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e95000,handle:0xd11a8000
[   75.552137] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e96000,handle:0xd11a0000
[   75.553632] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac23c000,handle:0xfdff0000
[   75.553640] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac307000,handle:0xfdff0000
[   75.553647] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fad83f000,handle:0xd10a0000
[   75.553654] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fae1f0000,handle:0xd0000000
[   75.553666] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb11a5000,handle:0xd11a4000
[   75.553676] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e94000,handle:0xd11a9000
[   75.553682] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e95000,handle:0xd11a8000
[   75.553688] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e96000,handle:0xd11a0000
[   75.858023] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac23c000,handle:0xfdff0000
[   75.858096] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac307000,handle:0xfdff0000
[   75.858303] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fad83f000,handle:0xd10a0000
[   75.860375] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fae1f0000,handle:0xd0000000
[   75.860589] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb11a5000,handle:0xd11a4000
[   75.860703] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e94000,handle:0xd11a9000
[   75.860726] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e95000,handle:0xd11a8000
[   75.860745] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e96000,handle:0xd11a0000
[   75.863454] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac23c000,handle:0xfdff0000
[   75.863469] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac307000,handle:0xfdff0000
[   75.863481] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fad83f000,handle:0xd10a0000
[   75.863494] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fae1f0000,handle:0xd0000000
[   75.863519] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb11a5000,handle:0xd11a4000
[   75.863537] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e94000,handle:0xd11a9000
[   75.863547] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e95000,handle:0xd11a8000
[   75.863558] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e96000,handle:0xd11a0000
[   75.968577] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac23c000,handle:0xfdff0000
[   75.968604] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac307000,handle:0xfdff0000
[   75.968680] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fad83f000,handle:0xd10a0000
[   75.969422] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fae1f0000,handle:0xd0000000
[   75.969507] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb11a5000,handle:0xd11a4000
[   75.969550] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e94000,handle:0xd11a9000
[   75.969556] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e95000,handle:0xd11a8000
[   75.969563] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e96000,handle:0xd11a0000
[   75.970505] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac23c000,handle:0xfdff0000
[   75.970509] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fac307000,handle:0xfdff0000
[   75.970513] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fad83f000,handle:0xd10a0000
[   75.970517] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fae1f0000,handle:0xd0000000
[   75.970525] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb11a5000,handle:0xd11a4000
[   75.970531] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e94000,handle:0xd11a9000
[   75.970535] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e95000,handle:0xd11a8000
[   75.970538] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7fb1e96000,handle:0xd11a0000
[   99.004408] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7faafc7000,handle:0xd11ab000
[   99.005315] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7faa8da000,handle:0xd13ab000
[   99.009092] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7faa8da000,handle:0xd13ab000
[   99.344445] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7faa8da000,handle:0xd1a97000
[   99.346962] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7faa8da000,handle:0xd1a97000
[   99.780075] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f7faafc7000,handle:0xd11ab000
[  310.130543] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f3461ce2000,handle:0xfdff0000
[  310.132172] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f346198a000,handle:0xd11ac000
[  310.135805] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f346198a000,handle:0xd11ac000
[  310.301717] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345f68a000,handle:0xd125c000
[  310.529123] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345f208000,handle:0xd145c000
[  330.643213] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345c7d9000,handle:0xd165c000
[  330.644786] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345c7d9000,handle:0xd165c000
[  331.072608] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345d159000,handle:0xd1a5c000
[  334.394209] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345b744000,handle:0xd1c64000
[  334.394933] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345b744000,handle:0xd1c64000
[  344.444794] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345bb83000,handle:0xd1e6c000
[  344.446393] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345b744000,handle:0xd21a4000
[  549.610432] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345f68a000,handle:0xd125c000
[  549.610497] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345d159000,handle:0xd1a5c000
[  549.610561] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345bb83000,handle:0xd1e6c000
[  549.610625] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345b744000,handle:0xd21a4000
[  549.610688] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f345f208000,handle:0xd145c000
[  549.671659] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f3461ce2000,handle:0xfdff0000
[  564.981893] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f9010a04000,handle:0xfdff0000
[  564.983515] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f9010163000,handle:0xd11ac000
[  564.987387] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f9010163000,handle:0xd11ac000
[  565.401879] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f900ee9b000,handle:0xd125c000
[  588.766362] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f9000327000,handle:0xd14b9000
[  591.568345] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffdb0b000,handle:0xd16b9000
[  592.314446] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffd39e000,handle:0xd18b9000
[  592.813976] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffcc23000,handle:0xd1ab9000
[  612.575160] reiser4[zsh(5703)]: disable_write_barrier (fs/reiser4/wander.c:235)[zam-1055]:
[  612.575161] NOTICE: md1 does not support write barriers, using synchronous write instead.
[  671.429039] reiser4[qmgr(3749)]: disable_write_barrier (fs/reiser4/wander.c:235)[zam-1055]:
[  671.429040] NOTICE: md2 does not support write barriers, using synchronous write instead.
[  684.136908] reiser4[ktxnmgrd:md3:ru(2825)]: disable_write_barrier (fs/reiser4/wander.c:235)[zam-1055]:
[  684.136909] NOTICE: md3 does not support write barriers, using synchronous write instead.
[  827.910880] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f900dddf000,handle:0xd1cb9000
[  855.901749] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffc0cb000,handle:0xd1eb9000
[  855.902475] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffc0cb000,handle:0xd1eb9000
[  855.903785] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f900d644000,handle:0xd21a4000
[  855.904505] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f900d644000,handle:0xd21a4000
[  855.905475] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffbae1000,handle:0xd23a4000
[  855.906966] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffbae1000,handle:0xd23a4000
[  855.908185] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f900d644000,handle:0xd27a4000
[  855.908927] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f900d644000,handle:0xd27a4000
[  966.615713] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffb35d000,handle:0xd29a4000
[  966.616497] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffb35d000,handle:0xd29a4000
[ 1056.227655] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_open] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffc8a1000,handle:0xd2ba4000
[ 1056.228390] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffc8a1000,handle:0xd2ba4000
[ 1076.675435] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f900ee9b000,handle:0xd125c000
[ 1076.675503] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffcc23000,handle:0xd1ab9000
[ 1076.675565] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f9000327000,handle:0xd14b9000
[ 1076.675629] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffdb0b000,handle:0xd16b9000
[ 1076.675692] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f900dddf000,handle:0xd1cb9000
[ 1076.675781] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f8ffd39e000,handle:0xd18b9000
[ 1076.734879] [fglrx:firegl_find_any_map] *ERROR* Invalid map handle!<3>[fglrx:drm_vm_close] *ERROR* map not found -> inconsistent kernel data!!! vma_start:0x7f9010a04000,handle:0xfdff0000

--Boundary-00=_82dlKfr5G2p/RkC
Content-Type: text/plain;
  charset="ISO-8859-15";
  name="dmesg_8gb_x4_955"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_8gb_x4_955"

[    0.000000] Linux version 2.6.30.5r4 (root@energy) (gcc version 4.4.1 (Gentoo 4.4.1 p1.0) ) #1 SMP Tue Aug 18 06:28:18 CEST 2009
[    0.000000] Command line: root=/dev/md1 md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=0 mtrr_spare_reg_nr=1
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7eb0000 (usable)
[    0.000000]  BIOS-e820: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7ef0000 - 00000000c7f00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000238000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x238000 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000238000000 aka 9088M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xc7eb0 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000c7eb0000
[    0.000000] Using GB pages for direct mapping
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00c7e00000 page 2M
[    0.000000]  00c7e00000 - 00c7eb0000 page 4k
[    0.000000] kernel direct mapping tables up to c7eb0000 @ 10000-13000
[    0.000000] init_memory_mapping: 0000000100000000-0000000238000000
[    0.000000] Using GB pages for direct mapping
[    0.000000]  0100000000 - 0200000000 page 1G
[    0.000000]  0200000000 - 0238000000 page 2M
[    0.000000] kernel direct mapping tables up to 238000000 @ 12000-14000
[    0.000000] ACPI: RSDP 00000000000fa7c0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000c7eb0000 00040 (v01 050609 RSDT2000 20090506 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000c7eb0200 00084 (v02 A M I  OEMFACP  12000601 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000c7eb0440 08512 (v01  AS140 AS140121 00000121 INTL 20051117)
[    0.000000] ACPI: FACS 00000000c7ec0000 00040
[    0.000000] ACPI: APIC 00000000c7eb0390 0006C (v01 050609 APIC2000 20090506 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000c7eb0400 0003C (v01 050609 OEMMCFG  20090506 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000c7ec0040 00071 (v01 050609 OEMB2000 20090506 MSFT 00000097)
[    0.000000] ACPI: AAFT 00000000c7eb8960 00027 (v01 050609 OEMAAFT  20090506 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000c7eb8990 00038 (v01 050609 OEMHPET  20090506 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000c7eb89d0 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0238000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001575998]    TEXT DATA BSS ==> [0001000000 - 0001575998]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [0001576000 - 0001576133]              BRK ==> [0001576000 - 0001576133]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
[    0.000000]  [ffffe20000000000-ffffe20007dfffff] PMD -> [ffff880028200000-ffff88002fffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00238000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000c7eb0
[    0.000000]     0: 0x00100000 -> 0x00238000
[    0.000000] On node 0 totalpages: 2096703
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 102 pages reserved
[    0.000000]   DMA zone: 3825 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 800488 pages, LIFO batch:31
[    0.000000]   Normal zone: 17472 pages used for memmap
[    0.000000]   Normal zone: 1260480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000c7eb0000 - 00000000c7ec0000
[    0.000000] PM: Registered nosave memory: 00000000c7ec0000 - 00000000c7ef0000
[    0.000000] PM: Registered nosave memory: 00000000c7ef0000 - 00000000c7f00000
[    0.000000] PM: Registered nosave memory: 00000000c7f00000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c8000000 (gap: c7f00000:38000000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 24 pages at ffff880028034000, static data 67808 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2064793
[    0.000000] Kernel command line: root=/dev/md1 md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=0 mtrr_spare_reg_nr=1
[    0.000000] md: Will configure md3 (super-block) from /dev/sda3,/dev/sdb3,/dev/sdc3, below.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:384
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3199.396 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.003333] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] Node 0: aperture @ 20000000 size 32 MB
[    0.003333] Aperture pointing to e820 RAM. Ignoring.
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.003333] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.003333] Memory: 8172700k/9306112k available (3231k kernel code, 919300k absent, 213188k reserved, 1310k data, 348k init)
[    0.003333] hpet clockevent registered
[    0.003333] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.003339] Calibrating delay loop (skipped), value calculated using timer frequency.. 6401.40 BogoMIPS (lpj=10664640)
[    0.003445] Mount-cache hash table entries: 256
[    0.003565] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003600] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003635] tseg: 0000000000
[    0.003640] CPU: Physical Processor ID: 0
[    0.003673] CPU: Processor Core ID: 0
[    0.003712] using C1E aware idle routine
[    0.003755] ACPI: Core revision 20090320
[    0.016702] Setting APIC routing to flat
[    0.017042] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.050834] CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.053332] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 BogoMIPS (lpj=10666975)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.144186] CPU1: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.144501] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.146716] Booting processor 2 APIC 0x2 ip 0x6000
[    0.003333] Initializing CPU#2
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 BogoMIPS (lpj=10666969)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 2
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.240889] CPU2: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.241204] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.243382] Booting processor 3 APIC 0x3 ip 0x6000
[    0.003333] Initializing CPU#3
[    0.003333] Calibrating delay using timer specific routine.. 6402.86 BogoMIPS (lpj=10666976)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 3
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.337491] CPU3: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.337806] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.340014] Brought up 4 CPUs
[    0.340048] Total of 4 processors activated (25609.97 BogoMIPS).
[    0.340318] net_namespace: 1400 bytes
[    0.340422] xor: automatically using best checksumming function: generic_sse
[    0.356667]    generic_sse: 12784.800 MB/sec
[    0.356701] xor: using function: generic_sse (12784.800 MB/sec)
[    0.356755] Time:  1:11:08  Date: 08/27/09
[    0.356837] NET: Registered protocol family 16
[    0.357045] node 0 link 0: io port [1000, ffffff]
[    0.357048] TOM: 00000000c8000000 aka 3200M
[    0.357082] Fam 10h mmconf [e0000000, efffffff]
[    0.357084] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.357086] node 0 link 0: mmio [f0000000, ffffffff]
[    0.357088] node 0 link 0: mmio [a0000, bffff]
[    0.357089] node 0 link 0: mmio [c8000000, dfffffff]
[    0.357091] TOM2: 0000000238000000 aka 9088M
[    0.357125] bus: [00,07] on node 0 link 0
[    0.357126] bus: 00 index 0 io port: [0, ffff]
[    0.357127] bus: 00 index 1 mmio: [f0000000, ffffffff]
[    0.357128] bus: 00 index 2 mmio: [a0000, bffff]
[    0.357129] bus: 00 index 3 mmio: [c8000000, dfffffff]
[    0.357131] bus: 00 index 4 mmio: [238000000, fcffffffff]
[    0.357137] ACPI: bus type pci registered
[    0.357241] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.357277] PCI: Not using MMCONFIG.
[    0.357310] PCI: Using configuration type 1 for base access
[    0.357345] PCI: Using configuration type 1 for extended access
[    0.358938] bio: create slab <bio-0> at 0
[    0.359389] ACPI: EC: Look up EC in DSDT
[    0.367199] ACPI: Interpreter enabled
[    0.367234] ACPI: (supports S0 S1 S3 S4 S5)
[    0.367351] ACPI: Using IOAPIC for interrupt routing
[    0.367429] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.370599] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.375781] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.381489] ACPI: No dock devices found.
[    0.381718] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.381799] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.381845] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.381880] pci 0000:00:02.0: PME# disabled
[    0.381948] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.381983] pci 0000:00:09.0: PME# disabled
[    0.382532] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.382567] pci 0000:00:0a.0: PME# disabled
[    0.382645] pci 0000:00:11.0: reg 10 io port: [0x9000-0x9007]
[    0.382651] pci 0000:00:11.0: reg 14 io port: [0x8000-0x8003]
[    0.382657] pci 0000:00:11.0: reg 18 io port: [0x7000-0x7007]
[    0.382663] pci 0000:00:11.0: reg 1c io port: [0x6000-0x6003]
[    0.382668] pci 0000:00:11.0: reg 20 io port: [0x5000-0x500f]
[    0.382674] pci 0000:00:11.0: reg 24 32bit mmio: [0xfddff800-0xfddffbff]
[    0.382724] pci 0000:00:12.0: reg 10 32bit mmio: [0xfddfe000-0xfddfefff]
[    0.382775] pci 0000:00:12.1: reg 10 32bit mmio: [0xfddfd000-0xfddfdfff]
[    0.382843] pci 0000:00:12.2: reg 10 32bit mmio: [0xfddff000-0xfddff0ff]
[    0.382892] pci 0000:00:12.2: supports D1 D2
[    0.382894] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.382930] pci 0000:00:12.2: PME# disabled
[    0.382992] pci 0000:00:13.0: reg 10 32bit mmio: [0xfddfc000-0xfddfcfff]
[    0.383043] pci 0000:00:13.1: reg 10 32bit mmio: [0xfddf7000-0xfddf7fff]
[    0.383111] pci 0000:00:13.2: reg 10 32bit mmio: [0xfddf6800-0xfddf68ff]
[    0.383161] pci 0000:00:13.2: supports D1 D2
[    0.383162] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.383199] pci 0000:00:13.2: PME# disabled
[    0.383342] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.383348] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.383353] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.383359] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.383365] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.383490] pci 0000:00:14.5: reg 10 32bit mmio: [0xfddf5000-0xfddf5fff]
[    0.383624] pci 0000:02:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
[    0.383631] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdff0000-0xfdffffff]
[    0.383636] pci 0000:02:00.0: reg 20 io port: [0xb000-0xb0ff]
[    0.383643] pci 0000:02:00.0: reg 30 32bit mmio: [0xfdfc0000-0xfdfdffff]
[    0.383659] pci 0000:02:00.0: supports D1 D2
[    0.383686] pci 0000:02:00.1: reg 10 64bit mmio: [0xfdfec000-0xfdfeffff]
[    0.383717] pci 0000:02:00.1: supports D1 D2
[    0.383767] pci 0000:00:02.0: bridge io port: [0xb000-0xbfff]
[    0.383769] pci 0000:00:02.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]
[    0.383772] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.383812] pci 0000:03:00.0: reg 10 io port: [0xd800-0xd8ff]
[    0.383828] pci 0000:03:00.0: reg 18 64bit mmio: [0xfebff000-0xfebfffff]
[    0.383844] pci 0000:03:00.0: reg 30 32bit mmio: [0xfebc0000-0xfebdffff]
[    0.383878] pci 0000:03:00.0: supports D1 D2
[    0.383879] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.383916] pci 0000:03:00.0: PME# disabled
[    0.383999] pci 0000:00:09.0: bridge io port: [0xc000-0xdfff]
[    0.384001] pci 0000:00:09.0: bridge 32bit mmio: [0xfe000000-0xfebfffff]
[    0.384003] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfa000000-0xfcefffff]
[    0.384035] pci 0000:01:00.0: reg 10 io port: [0xa800-0xa8ff]
[    0.384049] pci 0000:01:00.0: reg 18 64bit mmio: [0xcffff000-0xcfffffff]
[    0.384059] pci 0000:01:00.0: reg 20 64bit mmio: [0xcffe0000-0xcffeffff]
[    0.384065] pci 0000:01:00.0: reg 30 32bit mmio: [0xfdef0000-0xfdefffff]
[    0.384094] pci 0000:01:00.0: supports D1 D2
[    0.384095] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.384132] pci 0000:01:00.0: PME# disabled
[    0.384219] pci 0000:00:0a.0: bridge io port: [0xa000-0xafff]
[    0.384221] pci 0000:00:0a.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.384223] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xcff00000-0xcfffffff]
[    0.384258] pci 0000:05:06.0: reg 10 32bit mmio: [0xfcfff000-0xfcffffff]
[    0.384338] pci 0000:05:08.0: reg 10 io port: [0xe800-0xe83f]
[    0.384395] pci 0000:05:08.0: supports D1 D2
[    0.384437] pci 0000:00:14.4: transparent bridge
[    0.384474] pci 0000:00:14.4: bridge io port: [0xe000-0xefff]
[    0.384480] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfcf00000-0xfcffffff]
[    0.384492] pci_bus 0000:00: on NUMA node 0
[    0.384496] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.384625] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.384670] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.384715] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.384777] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.387594] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
[    0.387840] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)
[    0.388083] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    0.388326] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.388568] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.388857] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 *11 12 14 15)
[    0.389100] ACPI: PCI Interrupt Link [LNKG] (IRQs *4 10 11 12 14 15)
[    0.389329] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)
[    0.389715] SCSI subsystem initialized
[    0.389800] libata version 3.00 loaded.
[    0.389869] usbcore: registered new interface driver usbfs
[    0.389925] usbcore: registered new interface driver hub
[    0.389988] usbcore: registered new device driver usb
[    0.446681] raid6: int64x1   2808 MB/s
[    0.503341] raid6: int64x2   3611 MB/s
[    0.560017] raid6: int64x4   2846 MB/s
[    0.616667] raid6: int64x8   2701 MB/s
[    0.673348] raid6: sse2x1    4157 MB/s
[    0.730004] raid6: sse2x2    7091 MB/s
[    0.786669] raid6: sse2x4    7848 MB/s
[    0.786702] raid6: using algorithm sse2x4 (7848 MB/s)
[    0.786786] PCI: Using ACPI for IRQ routing
[    0.786825] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.800198] PCI-DMA: Disabling AGP.
[    0.800313] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.800347] PCI-DMA: using GART IOMMU.
[    0.800382] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.802129] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.802238] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.806695] hpet: hpet2 irq 24 for MSI
[    0.813350] Switched to high resolution mode on CPU 0
[    0.814492] Switched to high resolution mode on CPU 3
[    0.814519] Switched to high resolution mode on CPU 1
[    0.814556] Switched to high resolution mode on CPU 2
[    0.826700] pnp: PnP ACPI init
[    0.826753] ACPI: bus type pnp registered
[    0.829222] pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.829277] pnp 00:0b: mem resource (0xc0000-0xcffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.829332] pnp 00:0b: mem resource (0xe0000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.829387] pnp 00:0b: mem resource (0x100000-0xc7efffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.829741] pnp: PnP ACPI: found 12 devices
[    0.829775] ACPI: ACPI bus type pnp unregistered
[    0.829816] system 00:06: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.829869] system 00:06: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.829907] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.829942] system 00:07: ioport range 0x40b-0x40b has been reserved
[    0.829977] system 00:07: ioport range 0x4d6-0x4d6 has been reserved
[    0.830018] system 00:07: ioport range 0xc00-0xc01 has been reserved
[    0.830053] system 00:07: ioport range 0xc14-0xc14 has been reserved
[    0.830088] system 00:07: ioport range 0xc50-0xc51 has been reserved
[    0.830123] system 00:07: ioport range 0xc52-0xc52 has been reserved
[    0.830158] system 00:07: ioport range 0xc6c-0xc6c has been reserved
[    0.830192] system 00:07: ioport range 0xc6f-0xc6f has been reserved
[    0.830227] system 00:07: ioport range 0xcd0-0xcd1 has been reserved
[    0.830262] system 00:07: ioport range 0xcd2-0xcd3 has been reserved
[    0.830297] system 00:07: ioport range 0xcd4-0xcd5 has been reserved
[    0.830331] system 00:07: ioport range 0xcd6-0xcd7 has been reserved
[    0.830366] system 00:07: ioport range 0xcd8-0xcdf has been reserved
[    0.830401] system 00:07: ioport range 0x800-0x89f has been reserved
[    0.830436] system 00:07: ioport range 0xb00-0xb0f has been reserved
[    0.830471] system 00:07: ioport range 0xb20-0xb3f has been reserved
[    0.830505] system 00:07: ioport range 0x900-0x90f has been reserved
[    0.830540] system 00:07: ioport range 0x910-0x91f has been reserved
[    0.830575] system 00:07: ioport range 0xfe00-0xfefe has been reserved
[    0.830610] system 00:07: iomem range 0xffb80000-0xffbfffff has been reserved
[    0.830645] system 00:07: iomem range 0xfec10000-0xfec1001f has been reserved
[    0.830682] system 00:09: ioport range 0x290-0x29f has been reserved
[    0.830718] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.830755] system 00:0b: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.835661] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
[    0.835696] pci 0000:00:02.0:   IO window: 0xb000-0xbfff
[    0.835732] pci 0000:00:02.0:   MEM window: 0xfdf00000-0xfdffffff
[    0.835768] pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.835823] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    0.835857] pci 0000:00:09.0:   IO window: 0xc000-0xdfff
[    0.835893] pci 0000:00:09.0:   MEM window: 0xfe000000-0xfebfffff
[    0.835928] pci 0000:00:09.0:   PREFETCH window: 0x000000fa000000-0x000000fcefffff
[    0.835982] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:01
[    0.836017] pci 0000:00:0a.0:   IO window: 0xa000-0xafff
[    0.836052] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff
[    0.836088] pci 0000:00:0a.0:   PREFETCH window: 0x000000cff00000-0x000000cfffffff
[    0.836142] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
[    0.836178] pci 0000:00:14.4:   IO window: 0xe000-0xefff
[    0.836215] pci 0000:00:14.4:   MEM window: disabled
[    0.836251] pci 0000:00:14.4:   PREFETCH window: 0x000000fcf00000-0x000000fcffffff
[    0.836315] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.836351] pci 0000:00:02.0: setting latency timer to 64
[    0.836357] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.836392] pci 0000:00:09.0: setting latency timer to 64
[    0.836396] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.836431] pci 0000:00:0a.0: setting latency timer to 64
[    0.836438] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.836439] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.836441] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    0.836442] pci_bus 0000:02: resource 1 mem: [0xfdf00000-0xfdffffff]
[    0.836444] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.836445] pci_bus 0000:03: resource 0 io:  [0xc000-0xdfff]
[    0.836447] pci_bus 0000:03: resource 1 mem: [0xfe000000-0xfebfffff]
[    0.836448] pci_bus 0000:03: resource 2 pref mem [0xfa000000-0xfcefffff]
[    0.836449] pci_bus 0000:01: resource 0 io:  [0xa000-0xafff]
[    0.836451] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.836452] pci_bus 0000:01: resource 2 pref mem [0xcff00000-0xcfffffff]
[    0.836454] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
[    0.836455] pci_bus 0000:05: resource 2 pref mem [0xfcf00000-0xfcffffff]
[    0.836456] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.836457] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.836508] NET: Registered protocol family 2
[    0.873408] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.873922] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.874916] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.875314] TCP: Hash tables configured (established 262144 bind 65536)
[    0.875350] TCP reno registered
[    0.883431] NET: Registered protocol family 1
[    0.885125] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.885268] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[    0.885408] msgmni has been set to 15964
[    0.885675] alg: No test for stdrng (krng)
[    0.885715] async_tx: api initialized (sync-only)
[    0.885794] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.885848] io scheduler noop registered
[    0.885892] io scheduler cfq registered (default)
[    0.886016] pci 0000:02:00.0: Boot video device
[    0.886115] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.886122] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.886214] pcieport-driver 0000:00:09.0: irq 26 for MSI/MSI-X
[    0.886220] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.886308] pcieport-driver 0000:00:0a.0: irq 27 for MSI/MSI-X
[    0.886315] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    0.886532] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.886585] ACPI: Power Button [PWRF]
[    0.886677] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.886730] ACPI: Power Button [PWRB]
[    0.886873] processor ACPI_CPU:00: registered as cooling_device0
[    0.886908] ACPI: Processor [P001] (supports 8 throttling states)
[    0.887004] processor ACPI_CPU:01: registered as cooling_device1
[    0.887074] processor ACPI_CPU:02: registered as cooling_device2
[    0.887145] processor ACPI_CPU:03: registered as cooling_device3
[    0.890974] Linux agpgart interface v0.103
[    0.891098] Driver 'sd' needs updating - please use bus_type methods
[    0.891182] ahci 0000:00:11.0: version 3.0
[    0.891194] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.891338] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.891392] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    0.891907] scsi0 : ahci
[    0.892044] scsi1 : ahci
[    0.892134] scsi2 : ahci
[    0.892222] scsi3 : ahci
[    0.892313] scsi4 : ahci
[    0.892400] scsi5 : ahci
[    0.892527] ata1: SATA max UDMA/133 irq_stat 0x00400000 irq 22, PHY RDY changed
[    0.892582] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff980 irq 22
[    0.892636] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa00 irq 22
[    0.892691] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa80 irq 22
[    0.892745] ata5: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb00 irq 22
[    0.892799] ata6: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb80 irq 22
[    0.893030] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.893067] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.893532] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.893598] mice: PS/2 mouse device common for all mice
[    0.893731] rtc_cmos 00:02: RTC can wake from S4
[    0.893805] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.893861] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.893914] md: raid1 personality registered for level 1
[    0.893948] md: raid6 personality registered for level 6
[    0.893983] md: raid5 personality registered for level 5
[    0.894017] md: raid4 personality registered for level 4
[    0.894124] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    0.894217] cpuidle: using governor ladder
[    0.894335] usbcore: registered new interface driver hiddev
[    0.894389] usbcore: registered new interface driver usbhid
[    0.894424] usbhid: v2.6:USB HID core driver
[    0.894497] TCP cubic registered
[    0.894531] NET: Registered protocol family 17
[    0.894592] powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor processors (4 cpu cores) (version 2.20.00)
[    0.895174] powernow-k8:    0 : pstate 0 (3200 MHz)
[    0.895210] powernow-k8:    1 : pstate 1 (2500 MHz)
[    0.895244] powernow-k8:    2 : pstate 2 (2100 MHz)
[    0.895278] powernow-k8:    3 : pstate 3 (800 MHz)
[    0.895659] PM: Resume from disk failed.
[    0.895752]   Magic number: 5:759:155
[    0.895802] acpi device:22: hash matches
[    0.918908] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    1.210866] ata5: SATA link down (SStatus 0 SControl 300)
[    1.210927] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.210985] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.211037] ata6: SATA link down (SStatus 0 SControl 300)
[    1.211091] ata3: SATA link down (SStatus 0 SControl 300)
[    1.217280] ata4.00: ATA-7: SAMSUNG HD753LJ, 1AA01113, max UDMA7
[    1.217321] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.217367] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7
[    1.217402] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.223776] ata4.00: configured for UDMA/133
[    1.223829] ata2.00: configured for UDMA/133
[    1.610867] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.617221] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
[    1.617257] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.623677] ata1.00: configured for UDMA/133
[    1.637999] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    1.638214] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.638266] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    1.638333] sd 0:0:0:0: [sda] Write Protect is off
[    1.638350] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    1.638421] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.638433] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.638475] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    1.638482] sd 1:0:0:0: [sdb] Write Protect is off
[    1.638484] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.638486] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.638493] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.638536]  sdb:<5>scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[    1.638695] sd 3:0:0:0: [sdc] 1465149168 512-byte hardware sectors: (750 GB/698 GiB)
[    1.638702] sd 3:0:0:0: [sdc] Write Protect is off
[    1.638704] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.638712] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.638755]  sdc:<5>sd 3:0:0:0: Attached scsi generic sg2 type 0
[    1.638933]  sda: sda1 sda2 sda3 sda4 < sdc1 sdc2 sdc3 sdc4 < sdb1 sdb2 sdb3 sdb4 < sda5 sdc5 sda6 >
[    1.660539]  sdb5<5>sd 0:0:0:0: [sda] Attached SCSI disk
[    1.661819]  sdc6 sdb6 >
[    1.672095] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.675012]  sdc7 >
[    1.675339] sd 3:0:0:0: [sdc] Attached SCSI disk
[    1.675382] md: Waiting for all devices to be available before autodetect
[    1.675416] md: If you don't use raid, use raid=noautodetect
[    1.675516] md: Autodetecting RAID arrays.
[    1.773512] md: Scanned 12 and added 12 devices.
[    1.773547] md: autorun ...
[    1.773581] md: considering sdc6 ...
[    1.773620] md:  adding sdc6 ...
[    1.773654] md: sdc5 has different UUID to sdc6
[    1.773688] md: sdc3 has different UUID to sdc6
[    1.773723] md: sdc1 has different UUID to sdc6
[    1.773758] md:  adding sdb6 ...
[    1.773792] md: sdb5 has different UUID to sdc6
[    1.773826] md: sdb3 has different UUID to sdc6
[    1.773861] md: sdb1 has different UUID to sdc6
[    1.773896] md:  adding sda6 ...
[    1.773930] md: sda5 has different UUID to sdc6
[    1.773965] md: sda3 has different UUID to sdc6
[    1.773999] md: sda1 has different UUID to sdc6
[    1.774117] md: created md3
[    1.774151] md: bind<sda6>
[    1.774188] md: bind<sdb6>
[    1.774225] md: bind<sdc6>
[    1.774261] md: running: <sdc6><sdb6><sda6>
[    1.774392] raid5: device sdc6 operational as raid disk 2
[    1.774426] raid5: device sdb6 operational as raid disk 1
[    1.774460] raid5: device sda6 operational as raid disk 0
[    1.774655] raid5: allocated 3220kB for md3
[    1.774703] raid5: raid level 5 set md3 active with 3 out of 3 devices, algorithm 2
[    1.774756] RAID5 conf printout:
[    1.774789]  --- rd:3 wd:3
[    1.774823]  disk 0, o:1, dev:sda6
[    1.774856]  disk 1, o:1, dev:sdb6
[    1.774890]  disk 2, o:1, dev:sdc6
[    1.774953] md: considering sdc5 ...
[    1.774989] md:  adding sdc5 ...
[    1.775023] md: sdc3 has different UUID to sdc5
[    1.775058] md: sdc1 has different UUID to sdc5
[    1.775093] md:  adding sdb5 ...
[    1.775127] md: sdb3 has different UUID to sdc5
[    1.775162] md: sdb1 has different UUID to sdc5
[    1.775197] md:  adding sda5 ...
[    1.775231] md: sda3 has different UUID to sdc5
[    1.775265] md: sda1 has different UUID to sdc5
[    1.775356] md: created md2
[    1.775389] md: bind<sda5>
[    1.775426] md: bind<sdb5>
[    1.775463] md: bind<sdc5>
[    1.775499] md: running: <sdc5><sdb5><sda5>
[    1.775629] raid5: device sdc5 operational as raid disk 2
[    1.775663] raid5: device sdb5 operational as raid disk 1
[    1.775697] raid5: device sda5 operational as raid disk 0
[    1.775886] raid5: allocated 3220kB for md2
[    1.775932] raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2
[    1.775985] RAID5 conf printout:
[    1.776018]  --- rd:3 wd:3
[    1.776051]  disk 0, o:1, dev:sda5
[    1.776084]  disk 1, o:1, dev:sdb5
[    1.776118]  disk 2, o:1, dev:sdc5
[    1.776180] md: considering sdc3 ...
[    1.776216] md:  adding sdc3 ...
[    1.776250] md: sdc1 has different UUID to sdc3
[    1.776285] md:  adding sdb3 ...
[    1.776319] md: sdb1 has different UUID to sdc3
[    1.776354] md:  adding sda3 ...
[    1.776388] md: sda1 has different UUID to sdc3
[    1.776480] md: created md1
[    1.776513] md: bind<sda3>
[    1.776551] md: bind<sdb3>
[    1.776588] md: bind<sdc3>
[    1.776624] md: running: <sdc3><sdb3><sda3>
[    1.776755] raid5: device sdc3 operational as raid disk 2
[    1.776790] raid5: device sdb3 operational as raid disk 1
[    1.776824] raid5: device sda3 operational as raid disk 0
[    1.777017] raid5: allocated 3220kB for md1
[    1.777064] raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
[    1.777116] RAID5 conf printout:
[    1.777150]  --- rd:3 wd:3
[    1.777183]  disk 0, o:1, dev:sda3
[    1.777216]  disk 1, o:1, dev:sdb3
[    1.777250]  disk 2, o:1, dev:sdc3
[    1.777313] md: considering sdc1 ...
[    1.777351] md:  adding sdc1 ...
[    1.777386] md:  adding sdb1 ...
[    1.777421] md:  adding sda1 ...
[    1.777454] md: created md0
[    1.777487] md: bind<sda1>
[    1.777524] md: bind<sdb1>
[    1.777560] md: bind<sdc1>
[    1.777597] md: running: <sdc1><sdb1><sda1>
[    1.777755] raid1: raid set md0 active with 3 out of 3 mirrors
[    1.777816] md: ... autorun DONE.
[    1.777867] md: Loading md3: /dev/sda3
[    1.777906]  md3: unknown partition table
[    1.778067] md: couldn't update array info. -22
[    1.778104] md: could not bd_claim sda3.
[    1.778138] md: md_import_device returned -16
[    1.778174] md: could not bd_claim sdb3.
[    1.778207] md: md_import_device returned -16
[    1.778243] md: could not bd_claim sdc3.
[    1.778276] md: md_import_device returned -16
[    1.778311] md: starting md3 failed
[    1.778386]  md1: unknown partition table
[    1.815947] reiser4: md1: found disk format 4.0.0.
[    5.835444] VFS: Mounted root (reiser4 filesystem) readonly on device 9:1.
[    5.835495] Freeing unused kernel memory: 348k freed
[    8.831192] udev: starting version 145
[    8.956611]  md0:<6> md2: unknown partition table
[    8.992687]  unknown partition table
[    9.615011] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    9.615028] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.615042] r8169 0000:03:00.0: setting latency timer to 64
[    9.615310] r8169 0000:03:00.0: irq 28 for MSI/MSI-X
[    9.615384] eth0: RTL8168b/8111b at 0xffffc20012dec000, 00:e0:45:46:00:29, XID 38000000 IRQ 28
[    9.616772] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    9.616780] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.616788] r8169 0000:01:00.0: setting latency timer to 64
[    9.616840] r8169 0000:01:00.0: irq 29 for MSI/MSI-X
[    9.616887] eth1: RTL8168c/8111c at 0xffffc2000006a000, 00:19:66:86:ce:12, XID 3c4000c0 IRQ 29
[    9.620294] udev: renamed network interface eth1 to eth0
[    9.641911] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.641933] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    9.641970] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    9.642198] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    9.642222] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    9.642238] ehci_hcd 0000:00:12.2: debug port 1
[    9.642255] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[    9.651263] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    9.651288] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    9.651290] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.651291] usb usb1: Product: EHCI Host Controller
[    9.651292] usb usb1: Manufacturer: Linux 2.6.30.5r4 ehci_hcd
[    9.651293] usb usb1: SerialNumber: 0000:00:12.2
[    9.651638] usb usb1: configuration #1 chosen from 1 choice
[    9.651679] hub 1-0:1.0: USB hub found
[    9.651685] hub 1-0:1.0: 6 ports detected
[    9.651813] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    9.651834] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    9.651994] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    9.652012] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    9.652028] ehci_hcd 0000:00:13.2: debug port 1
[    9.652041] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[    9.661263] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    9.661274] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    9.661275] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.661276] usb usb2: Product: EHCI Host Controller
[    9.661277] usb usb2: Manufacturer: Linux 2.6.30.5r4 ehci_hcd
[    9.661278] usb usb2: SerialNumber: 0000:00:13.2
[    9.661346] usb usb2: configuration #1 chosen from 1 choice
[    9.661374] hub 2-0:1.0: USB hub found
[    9.661378] hub 2-0:1.0: 6 ports detected
[    9.670316] udev: renamed network interface _rename to eth1
[    9.691307] Linux video capture interface: v2.00
[    9.699465] bttv: driver version 0.9.18 loaded
[    9.699467] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    9.699515] bttv: Bt8xx card found (0).
[    9.699527] bttv 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    9.699537] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 128, mmio: 0xfcfff000
[    9.699567] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra TValue Version 1.0/ Vobis TV-Boostar [card=25,insmod option]
[    9.699569] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[    9.699603] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
[    9.957103] usb 1-2: new high speed USB device using ehci_hcd and address 2
[   10.082077] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[   10.082079] usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   10.082081] usb 1-2: Product: USB2.0 Hub
[   10.082130] usb 1-2: configuration #1 chosen from 1 choice
[   10.082560] hub 1-2:1.0: USB hub found
[   10.082825] hub 1-2:1.0: 4 ports detected
[   10.351118] usb 1-2.2: new low speed USB device using ehci_hcd and address 3
[   10.440497] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[   10.440499] usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   10.440501] usb 1-2.2: Product: USB Receiver
[   10.440502] usb 1-2.2: Manufacturer: Logitech
[   10.440535] usb 1-2.2: configuration #1 chosen from 1 choice
[   10.450750] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input3
[   10.450789] generic-usb 0003:046D:C518.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
[   10.455931] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input4
[   10.455981] generic-usb 0003:046D:C518.0002: input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
[   10.700030] bttv0: tea5757: read timeout
[   10.700032] bttv0: tuner type=5
[   10.711868] All bytes are equal. It is not a TEA5767
[   10.711899] tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])
[   10.714766] tuner-simple 0-0060: creating new instance
[   10.714768] tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
[   10.727127] bttv0: audio absent, no audio device found!
[   10.727193] bttv0: registered device video0
[   10.727219] bttv0: registered device vbi0
[   11.006704] reiser4: md2: found disk format 4.0.0.
[   12.788508] reiser4: md3: found disk format 4.0.0.
[   54.187328] reiser4: sdc7: found disk format 4.0.0.
[   66.507842] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1 across:7815612k 
[   66.514717] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1 across:7815612k 
[   66.584800] Adding 7815612k swap on /dev/sdc2.  Priority:1 extents:1 across:7815612k 
[   67.187645] w83627ehf: Found W83627EHG chip at 0x290
[   67.569061] r8169: eth0: link up
[   67.569070] r8169: eth0: link up
[   67.573771] r8169: eth1: link down
[   70.343374] EMU10K1_Audigy 0000:05:08.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   70.350367] Audigy2 value: Special config.
[   71.704750] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[   71.704759] Disabling lock debugging due to kernel taint
[   71.752696] [fglrx] Maximum main memory to use for locked dma buffers: 7749 MBytes.
[   71.752961] [fglrx]   vendor: 1002 device: 9501 count: 1
[   71.753615] [fglrx] ioport: bar 4, base 0xb000, size: 0x100
[   71.753637] pci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   71.753646] pci 0000:02:00.0: setting latency timer to 64
[   71.754126] [fglrx] Kernel PAT support is enabled
[   71.754163] [fglrx] module loaded - fglrx 8.66.2 [Aug 25 2009] with 1 minors
[   71.953696] fglrx_pci 0000:02:00.0: irq 30 for MSI/MSI-X
[   71.954048] [fglrx] Firegl kernel thread PID: 3883
[   74.083532] [fglrx] Gart USWC size:1279 M.
[   74.083534] [fglrx] Gart cacheable size:508 M.
[   74.083538] [fglrx] Reserved FB block: Shared offset:0, size:1000000 
[   74.083540] [fglrx] Reserved FB block: Unshared offset:fbff000, size:401000 
[   74.083541] [fglrx] Reserved FB block: Unshared offset:1fffc000, size:4000 
[  611.862435] reiser4[ktxnmgrd:md1:ru(537)]: disable_write_barrier (fs/reiser4/wander.c:235)[zam-1055]:
[  611.862436] NOTICE: md1 does not support write barriers, using synchronous write instead.
[  670.057754] reiser4[pickup(3743)]: disable_write_barrier (fs/reiser4/wander.c:235)[zam-1055]:
[  670.057755] NOTICE: md2 does not support write barriers, using synchronous write instead.
[  692.937317] reiser4[ktxnmgrd:md3:ru(2705)]: disable_write_barrier (fs/reiser4/wander.c:235)[zam-1055]:
[  692.937318] NOTICE: md3 does not support write barriers, using synchronous write instead.
[ 6000.574616] usb 1-2.2: reset low speed USB device using ehci_hcd and address 3

--Boundary-00=_82dlKfr5G2p/RkC--
