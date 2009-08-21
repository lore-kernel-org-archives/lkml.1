Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZHUQPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZHUQPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZHUQPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:15:14 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:57777 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZHUQPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:15:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:subject:date:user-agent:mime-version:to:content-type
         :message-id;
        b=mV5PkE9Te1TE4GEBgcARHQPWr2VpDa0bp3R9/q4OUgx2UcgpqTJW79SJEN1IwVyCwk
         K9RRUrN9xxv90KQK57WmckRfMZZYRdJPONZxPta/0veW1talChlnM+vXjorNJC1YVepY
         k05xjl4V2PzYm5LLzhP3LgOdWPSVK/sOkj3dQ=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
Subject: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and earlier.
Date: Fri, 21 Aug 2009 18:14:56 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30.5r4; KDE/4.3.0; x86_64; ; )
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_AgsjKTLsRHvTDXZ"
Message-Id: <200908211814.56800.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_AgsjKTLsRHvTDXZ
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

I have an amd64 system with 8GB ram. Of these only 3.1GB are currently cove=
red=20
with mtrr:
cat /proc/mtrr
reg00: base=3D0x000000000 (    0MB), size=3D 2048MB, count=3D1: write-back
reg01: base=3D0x080000000 ( 2048MB), size=3D 1024MB, count=3D1: write-back
reg02: base=3D0x0c0000000 ( 3072MB), size=3D  128MB, count=3D1: write-back

This is with a Phenom II X4. Mobo is an Asrock A770Crossfire with AMD 770=20
chipset. Ram is 1066 ddr2 running at 800.

Before that I had a X2 6000 where I had one more mtrr, covering additional=
=20
256mb with 6gb ram total.=20

When I use the opensource driver, I get a 'mtrr disabled' message when X=20
starts, nothing like that with fglrx. The results are the same.

Is there anything that I can do about it? I already played with mtrr cleanu=
p=20
options - without any results.

Except for reiser4 the kernel is 'vanilla', config is attached, dmesg and l=
spci=20
are folloiwing:

dmesg:
[    0.000000] Linux version 2.6.30.5r4 (root@energy) (gcc version 4.4.1=20
(Gentoo 4.4.1 p1.0) ) #1 SMP Tue Aug 18 06:28:18 CEST 2009                 =
                                         =20
[    0.000000] Command line: root=3D/dev/md1 md=3D3,/dev/sda3,/dev/sdb3,/de=
v/sdc3=20
nmi_watchdog=3D0 mtrr_spare_reg_nr=3D1                                     =
                                        =20
[    0.000000] KERNEL supported cpus:                                      =
                   =20
[    0.000000]   Intel GenuineIntel                                        =
                   =20
[    0.000000]   AMD AuthenticAMD                                          =
                   =20
[    0.000000] BIOS-provided physical RAM map:                             =
                   =20
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)    =
                   =20
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)  =
                   =20
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)  =
                   =20
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7eb0000 (usable)    =
                   =20
[    0.000000]  BIOS-e820: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data) =
                   =20
[    0.000000]  BIOS-e820: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)  =
                   =20
[    0.000000]  BIOS-e820: 00000000c7ef0000 - 00000000c7f00000 (reserved)  =
                   =20
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)  =
                   =20
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000238000000 (usable)    =
                   =20
[    0.000000] DMI present.                                                =
                   =20
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around =
it.                =20
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le)=20
=3D=3D> (reserved) =20
[    0.000000] last_pfn =3D 0x238000 max_arch_pfn =3D 0x100000000          =
                       =20
[    0.000000] MTRR default type: uncachable                               =
                   =20
[    0.000000] MTRR fixed ranges enabled:                                  =
                   =20
[    0.000000]   00000-9FFFF write-back                                    =
                   =20
[    0.000000]   A0000-EFFFF uncachable                                    =
                   =20
[    0.000000]   F0000-FFFFF write-protect                                 =
                   =20
[    0.000000] MTRR variable ranges enabled:                               =
                   =20
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back          =
                   =20
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back          =
                   =20
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back          =
                   =20
[    0.000000]   3 disabled                                                =
                   =20
[    0.000000]   4 disabled                                                =
                   =20
[    0.000000]   5 disabled                                                =
                   =20
[    0.000000]   6 disabled                                                =
                   =20
[    0.000000]   7 disabled                                                =
                   =20
[    0.000000] TOM2: 0000000238000000 aka 9088M                            =
                   =20
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new=20
0x7010600070106               =20
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usab=
le)=20
=3D=3D> (reserved) =20
[    0.000000] last_pfn =3D 0xc7eb0 max_arch_pfn =3D 0x100000000           =
                       =20
[    0.000000] init_memory_mapping: 0000000000000000-00000000c7eb0000      =
                   =20
[    0.000000] Using GB pages for direct mapping                           =
                   =20
[    0.000000]  0000000000 - 00c0000000 page 1G                            =
                   =20
[    0.000000]  00c0000000 - 00c7e00000 page 2M                            =
                   =20
[    0.000000]  00c7e00000 - 00c7eb0000 page 4k                            =
                   =20
[    0.000000] kernel direct mapping tables up to c7eb0000 @ 10000-13000   =
                   =20
[    0.000000] init_memory_mapping: 0000000100000000-0000000238000000      =
                   =20
[    0.000000] Using GB pages for direct mapping                           =
                   =20
[    0.000000]  0100000000 - 0200000000 page 1G                            =
                   =20
[    0.000000]  0200000000 - 0238000000 page 2M                            =
                   =20
[    0.000000] kernel direct mapping tables up to 238000000 @ 12000-14000  =
                   =20
[    0.000000] ACPI: RSDP 00000000000fa7c0 00014 (v00 ACPIAM)              =
                   =20
[    0.000000] ACPI: RSDT 00000000c7eb0000 00040 (v01 050609 RSDT2000 20090=
506=20
MSFT 00000097) =20
[    0.000000] ACPI: FACP 00000000c7eb0200 00084 (v02 A M I  OEMFACP  12000=
601=20
MSFT 00000097) =20
[    0.000000] ACPI: DSDT 00000000c7eb0440 08512 (v01  AS140 AS140121 00000=
121=20
INTL 20051117) =20
[    0.000000] ACPI: FACS 00000000c7ec0000 00040                           =
                   =20
[    0.000000] ACPI: APIC 00000000c7eb0390 0006C (v01 050609 APIC2000 20090=
506=20
MSFT 00000097) =20
[    0.000000] ACPI: MCFG 00000000c7eb0400 0003C (v01 050609 OEMMCFG  20090=
506=20
MSFT 00000097) =20
[    0.000000] ACPI: OEMB 00000000c7ec0040 00071 (v01 050609 OEMB2000 20090=
506=20
MSFT 00000097) =20
[    0.000000] ACPI: AAFT 00000000c7eb8960 00027 (v01 050609 OEMAAFT  20090=
506=20
MSFT 00000097) =20
[    0.000000] ACPI: HPET 00000000c7eb8990 00038 (v01 050609 OEMHPET  20090=
506=20
MSFT 00000097) =20
[    0.000000] ACPI: SSDT 00000000c7eb89d0 0088C (v01 A M I  POWERNOW 00000=
001=20
AMD  00000001) =20
[    0.000000] ACPI: Local APIC address 0xfee00000                         =
                   =20
[    0.000000] (7 early reservations) =3D=3D> bootmem [0000000000 - 0238000=
000]                   =20
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000=20
=2D 0000001000]  =20
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000=20
=2D 0000008000]  =20
[    0.000000]   #2 [0001000000 - 0001575998]    TEXT DATA BSS =3D=3D> [000=
1000000=20
=2D 0001575998]  =20
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved =3D=3D> [000=
009fc00=20
=2D 0000100000]  =20
[    0.000000]   #4 [0001576000 - 0001576133]              BRK =3D=3D> [000=
1576000=20
=2D 0001576133]  =20
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE =3D=3D> [000=
0010000=20
=2D 0000012000]  =20
[    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE =3D=3D> [000=
0012000=20
=2D 0000013000]  =20
[    0.000000]  [ffffe20000000000-ffffe20007dfffff] PMD -> [ffff88002820000=
0-
ffff88002fffffff] on node 0                                                =
                                     =20
[    0.000000] Zone PFN ranges:                                            =
                   =20
[    0.000000]   DMA      0x00000010 -> 0x00001000                         =
                   =20
[    0.000000]   DMA32    0x00001000 -> 0x00100000                         =
                   =20
[    0.000000]   Normal   0x00100000 -> 0x00238000                         =
                   =20
[    0.000000] Movable zone start PFN for each node                        =
                   =20
[    0.000000] early_node_map[3] active PFN ranges                         =
                   =20
[    0.000000]     0: 0x00000010 -> 0x0000009f                             =
                   =20
[    0.000000]     0: 0x00000100 -> 0x000c7eb0                             =
                   =20
[    0.000000]     0: 0x00100000 -> 0x00238000                             =
                   =20
[    0.000000] On node 0 totalpages: 2096703                               =
                   =20
[    0.000000]   DMA zone: 56 pages used for memmap                        =
                   =20
[    0.000000]   DMA zone: 102 pages reserved                              =
                   =20
[    0.000000]   DMA zone: 3825 pages, LIFO batch:0                        =
                   =20
[    0.000000]   DMA32 zone: 14280 pages used for memmap                   =
                   =20
[    0.000000]   DMA32 zone: 800488 pages, LIFO batch:31                   =
                   =20
[    0.000000]   Normal zone: 17472 pages used for memmap                  =
                   =20
[    0.000000]   Normal zone: 1260480 pages, LIFO batch:31                 =
                   =20
[    0.000000] ACPI: PM-Timer IO Port: 0x808                               =
                   =20
[    0.000000] ACPI: Local APIC address 0xfee00000                         =
                   =20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)          =
                   =20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)          =
                   =20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)          =
                   =20
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)          =
                   =20
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])     =
                   =20
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-2=
3                  =20
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)    =
                   =20
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)  =
                   =20
[    0.000000] ACPI: IRQ0 used by override.                                =
                   =20
[    0.000000] ACPI: IRQ2 used by override.                                =
                   =20
[    0.000000] ACPI: IRQ9 used by override.                                =
                   =20
[    0.000000] Using ACPI (MADT) for SMP configuration information         =
                   =20
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000                      =
                   =20
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs                        =
                   =20
[    0.000000] nr_irqs_gsi: 24                                             =
                   =20
[    0.000000] PM: Registered nosave memory: 000000000009f000 -=20
00000000000a0000              =20
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -=20
00000000000e6000              =20
[    0.000000] PM: Registered nosave memory: 00000000000e6000 -=20
0000000000100000              =20
[    0.000000] PM: Registered nosave memory: 00000000c7eb0000 -=20
00000000c7ec0000              =20
[    0.000000] PM: Registered nosave memory: 00000000c7ec0000 -=20
00000000c7ef0000              =20
[    0.000000] PM: Registered nosave memory: 00000000c7ef0000 -=20
00000000c7f00000              =20
[    0.000000] PM: Registered nosave memory: 00000000c7f00000 -=20
00000000fff00000              =20
[    0.000000] PM: Registered nosave memory: 00000000fff00000 -=20
0000000100000000              =20
[    0.000000] Allocating PCI resources starting at c8000000 (gap:=20
c7f00000:38000000)         =20
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1      =
                   =20
[    0.000000] PERCPU: Embedded 24 pages at ffff880028034000, static data 6=
7808=20
bytes         =20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l=20
pages: 2064793   =20
[    0.000000] Kernel command line: root=3D/dev/md1=20
md=3D3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=3D0 mtrr_spare_reg_nr=3D1=
                                                                      =20
[    0.000000] md: Will configure md3 (super-block) from=20
/dev/sda3,/dev/sdb3,/dev/sdc3, below.=20
[    0.000000] Initializing CPU#0                                          =
                   =20
[    0.000000] NR_IRQS:384                                                 =
                   =20
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)       =
                   =20
[    0.000000] Fast TSC calibration using PIT                              =
                   =20
[    0.000000] Detected 3199.760 MHz processor.                            =
                   =20
[    0.003333] Console: colour VGA+ 80x25                                  =
                   =20
[    0.003333] console [tty0] enabled                                      =
                   =20
[    0.003333] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
=20
bytes)            =20
[    0.003333] Inode-cache hash table entries: 524288 (order: 10, 4194304=20
bytes)              =20
[    0.003333] Checking aperture...                                        =
                   =20
[    0.003333] No AGP bridge found                                         =
                   =20
[    0.003333] Node 0: aperture @ 20000000 size 32 MB                      =
                   =20
[    0.003333] Aperture pointing to e820 RAM. Ignoring.                    =
                   =20
[    0.003333] Your BIOS doesn't leave a aperture memory hole              =
                   =20
[    0.003333] Please enable the IOMMU option in the BIOS setup            =
                   =20
[    0.003333] This costs you 64 MB of RAM                                 =
                   =20
[    0.003333] Mapping aperture over 65536 KB of RAM @ 20000000            =
                   =20
[    0.003333] PM: Registered nosave memory: 0000000020000000 -=20
0000000024000000              =20
[    0.003333] Memory: 8172700k/9306112k available (3231k kernel code, 9193=
00k=20
absent, 213188k reserved, 1310k data, 348k init)                           =
                                   =20
[    0.003333] hpet clockevent registered                                  =
                   =20
[    0.003333] HPET: 4 timers in total, 1 timers will be used for per-cpu=20
timer               =20
[    0.003339] Calibrating delay loop (skipped), value calculated using tim=
er=20
frequency.. 6402.15 BogoMIPS (lpj=3D10665853)                              =
                                      =20
[    0.003445] Mount-cache hash table entries: 256                         =
                   =20
[    0.003564] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)              =20
[    0.003599] CPU: L2 Cache: 512K (64 bytes/line)                         =
                   =20
[    0.003634] tseg: 0000000000                                            =
                   =20
[    0.003639] CPU: Physical Processor ID: 0                               =
                   =20
[    0.003672] CPU: Processor Core ID: 0                                   =
                   =20
[    0.003710] using C1E aware idle routine                                =
                   =20
[    0.003754] ACPI: Core revision 20090320                                =
                   =20
[    0.016700] Setting APIC routing to flat                                =
                   =20
[    0.017036] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
=2D1                           =20
[    0.050750] CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02        =
                   =20
[    0.053332] Booting processor 1 APIC 0x1 ip 0x6000                      =
                   =20
[    0.003333] Initializing CPU#1                                          =
                   =20
[    0.003333] Calibrating delay using timer specific routine.. 6402.85=20
BogoMIPS (lpj=3D10666967)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)              =20
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                         =
                   =20
[    0.003333] CPU: Physical Processor ID: 0                               =
                   =20
[    0.003333] CPU: Processor Core ID: 1                                   =
                   =20
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new=20
0x7010600070106               =20
[    0.144205] CPU1: AMD Phenom(tm) II X4 955 Processor stepping 02        =
                   =20
[    0.144518] checking TSC synchronization [CPU#0 -> CPU#1]: passed.      =
                   =20
[    0.146715] Booting processor 2 APIC 0x2 ip 0x6000                      =
                   =20
[    0.003333] Initializing CPU#2                                          =
                   =20
[    0.003333] Calibrating delay using timer specific routine.. 6402.85=20
BogoMIPS (lpj=3D10666975)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)              =20
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                         =
                   =20
[    0.003333] CPU: Physical Processor ID: 0                               =
                   =20
[    0.003333] CPU: Processor Core ID: 2                                   =
                   =20
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new=20
0x7010600070106               =20
[    0.240829] CPU2: AMD Phenom(tm) II X4 955 Processor stepping 02        =
                   =20
[    0.241142] checking TSC synchronization [CPU#0 -> CPU#2]: passed.      =
                   =20
[    0.243382] Booting processor 3 APIC 0x3 ip 0x6000                      =
                   =20
[    0.003333] Initializing CPU#3                                          =
                   =20
[    0.003333] Calibrating delay using timer specific routine.. 6402.85=20
BogoMIPS (lpj=3D10666968)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)              =20
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                         =
                   =20
[    0.003333] CPU: Physical Processor ID: 0                               =
                   =20
[    0.003333] CPU: Processor Core ID: 3                                   =
                   =20
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new=20
0x7010600070106               =20
[    0.337453] CPU3: AMD Phenom(tm) II X4 955 Processor stepping 02        =
                   =20
[    0.337766] checking TSC synchronization [CPU#0 -> CPU#3]: passed.      =
                   =20
[    0.340014] Brought up 4 CPUs                                           =
                   =20
[    0.340047] Total of 4 processors activated (25610.72 BogoMIPS).        =
                   =20
[    0.340316] net_namespace: 1400 bytes                                   =
                   =20
[    0.340419] xor: automatically using best checksumming function:=20
generic_sse               =20
[    0.356667]    generic_sse: 12784.800 MB/sec                            =
                   =20
[    0.356701] xor: using function: generic_sse (12784.800 MB/sec)         =
                   =20
[    0.356754] Time: 18:06:22  Date: 08/21/09                              =
                   =20
[    0.356835] NET: Registered protocol family 16                          =
                   =20
[    0.357041] node 0 link 0: io port [1000, ffffff]                       =
                   =20
[    0.357043] TOM: 00000000c8000000 aka 3200M                             =
                   =20
[    0.357077] Fam 10h mmconf [e0000000, efffffff]                         =
                   =20
[    0.357079] node 0 link 0: mmio [e0000000, efffffff] =3D=3D> none       =
                       =20
[    0.357081] node 0 link 0: mmio [f0000000, ffffffff]                    =
                   =20
[    0.357083] node 0 link 0: mmio [a0000, bffff]                          =
                   =20
[    0.357085] node 0 link 0: mmio [c8000000, dfffffff]                    =
                   =20
[    0.357086] TOM2: 0000000238000000 aka 9088M                            =
                   =20
[    0.357120] bus: [00,07] on node 0 link 0                               =
                   =20
[    0.357121] bus: 00 index 0 io port: [0, ffff]                          =
                   =20
[    0.357122] bus: 00 index 1 mmio: [f0000000, ffffffff]                  =
                   =20
[    0.357123] bus: 00 index 2 mmio: [a0000, bffff]                        =
                   =20
[    0.357124] bus: 00 index 3 mmio: [c8000000, dfffffff]                  =
                   =20
[    0.357125] bus: 00 index 4 mmio: [238000000, fcffffffff]               =
                   =20
[    0.357133] ACPI: bus type pci registered                               =
                   =20
[    0.357237] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255               =20
[    0.357272] PCI: Not using MMCONFIG.                                    =
                   =20
[    0.357305] PCI: Using configuration type 1 for base access             =
                   =20
[    0.357339] PCI: Using configuration type 1 for extended access         =
                   =20
[    0.358962] bio: create slab <bio-0> at 0                               =
                   =20
[    0.359408] ACPI: EC: Look up EC in DSDT                                =
                   =20
[    0.367191] ACPI: Interpreter enabled                                   =
                   =20
[    0.367226] ACPI: (supports S0 S1 S3 S4 S5)                             =
                   =20
[    0.367342] ACPI: Using IOAPIC for interrupt routing                    =
                   =20
[    0.367420] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255               =20
[    0.370575] PCI: MCFG area at e0000000 reserved in ACPI motherboard=20
resources              =20
[    0.375709] PCI: Using MMCONFIG at e0000000 - efffffff                  =
                   =20
[    0.381422] ACPI: No dock devices found.                                =
                   =20
[    0.381651] ACPI: PCI Root Bridge [PCI0] (0000:00)                      =
                   =20
[    0.381732] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]=
                   =20
[    0.381778] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold       =
                   =20
[    0.381813] pci 0000:00:02.0: PME# disabled                             =
                   =20
[    0.381881] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold       =
                   =20
[    0.381916] pci 0000:00:09.0: PME# disabled                             =
                   =20
[    0.382462] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold       =
                   =20
[    0.382497] pci 0000:00:0a.0: PME# disabled                             =
                   =20
[    0.382575] pci 0000:00:11.0: reg 10 io port: [0x9000-0x9007]           =
                   =20
[    0.382581] pci 0000:00:11.0: reg 14 io port: [0x8000-0x8003]           =
                   =20
[    0.382587] pci 0000:00:11.0: reg 18 io port: [0x7000-0x7007]           =
                   =20
[    0.382593] pci 0000:00:11.0: reg 1c io port: [0x6000-0x6003]           =
                   =20
[    0.382598] pci 0000:00:11.0: reg 20 io port: [0x5000-0x500f]           =
                   =20
[    0.382604] pci 0000:00:11.0: reg 24 32bit mmio: [0xfddff800-0xfddffbff]=
                   =20
[    0.382653] pci 0000:00:12.0: reg 10 32bit mmio: [0xfddfe000-0xfddfefff]=
                   =20
[    0.382705] pci 0000:00:12.1: reg 10 32bit mmio: [0xfddfd000-0xfddfdfff]=
                   =20
[    0.382773] pci 0000:00:12.2: reg 10 32bit mmio: [0xfddff000-0xfddff0ff]=
                   =20
[    0.382823] pci 0000:00:12.2: supports D1 D2                            =
                   =20
[    0.382824] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot        =
                   =20
[    0.382860] pci 0000:00:12.2: PME# disabled                             =
                   =20
[    0.382922] pci 0000:00:13.0: reg 10 32bit mmio: [0xfddfc000-0xfddfcfff]=
                   =20
[    0.382973] pci 0000:00:13.1: reg 10 32bit mmio: [0xfddf7000-0xfddf7fff]=
                   =20
[    0.383041] pci 0000:00:13.2: reg 10 32bit mmio: [0xfddf6800-0xfddf68ff]=
                   =20
[    0.383091] pci 0000:00:13.2: supports D1 D2                            =
                   =20
[    0.383092] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot        =
                   =20
[    0.383128] pci 0000:00:13.2: PME# disabled                             =
                   =20
[    0.383271] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]               =
                   =20
[    0.383277] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]               =
                   =20
[    0.383283] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]               =
                   =20
[    0.383288] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]               =
                   =20
[    0.383294] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]           =
                   =20
[    0.383421] pci 0000:00:14.5: reg 10 32bit mmio: [0xfddf5000-0xfddf5fff]=
                   =20
[    0.383555] pci 0000:02:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]=
                   =20
[    0.383563] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdff0000-0xfdffffff]=
                   =20
[    0.383567] pci 0000:02:00.0: reg 20 io port: [0xb000-0xb0ff]           =
                   =20
[    0.383574] pci 0000:02:00.0: reg 30 32bit mmio: [0xfdfc0000-0xfdfdffff]=
                   =20
[    0.383590] pci 0000:02:00.0: supports D1 D2                            =
                   =20
[    0.383617] pci 0000:02:00.1: reg 10 64bit mmio: [0xfdfec000-0xfdfeffff]=
                   =20
[    0.383647] pci 0000:02:00.1: supports D1 D2                            =
                   =20
[    0.383697] pci 0000:00:02.0: bridge io port: [0xb000-0xbfff]           =
                   =20
[    0.383699] pci 0000:00:02.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]=
                   =20
[    0.383702] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfff=
ffff]              =20
[    0.383743] pci 0000:03:00.0: reg 10 io port: [0xd800-0xd8ff]           =
                   =20
[    0.383759] pci 0000:03:00.0: reg 18 64bit mmio: [0xfebff000-0xfebfffff]=
                   =20
[    0.383774] pci 0000:03:00.0: reg 30 32bit mmio: [0xfebc0000-0xfebdffff]=
                   =20
[    0.383809] pci 0000:03:00.0: supports D1 D2                            =
                   =20
[    0.383810] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold    =
                   =20
[    0.383847] pci 0000:03:00.0: PME# disabled                             =
                   =20
[    0.383929] pci 0000:00:09.0: bridge io port: [0xc000-0xdfff]           =
                   =20
[    0.383931] pci 0000:00:09.0: bridge 32bit mmio: [0xfe000000-0xfebfffff]=
                   =20
[    0.383933] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfa000000-0xfcef=
ffff]              =20
[    0.383964] pci 0000:01:00.0: reg 10 io port: [0xa800-0xa8ff]           =
                   =20
[    0.383977] pci 0000:01:00.0: reg 18 64bit mmio: [0xcffff000-0xcfffffff]=
                   =20
[    0.383987] pci 0000:01:00.0: reg 20 64bit mmio: [0xcffe0000-0xcffeffff]=
                   =20
[    0.383992] pci 0000:01:00.0: reg 30 32bit mmio: [0xfdef0000-0xfdefffff]=
                   =20
[    0.384019] pci 0000:01:00.0: supports D1 D2                            =
                   =20
[    0.384021] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold =
                   =20
[    0.384057] pci 0000:01:00.0: PME# disabled                             =
                   =20
[    0.384143] pci 0000:00:0a.0: bridge io port: [0xa000-0xafff]           =
                   =20
[    0.384145] pci 0000:00:0a.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]=
                   =20
[    0.384148] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xcff00000-0xcfff=
ffff]              =20
[    0.384182] pci 0000:05:06.0: reg 10 32bit mmio: [0xfcfff000-0xfcffffff]=
                   =20
[    0.384262] pci 0000:05:08.0: reg 10 io port: [0xe800-0xe83f]           =
                   =20
[    0.384320] pci 0000:05:08.0: supports D1 D2                            =
                   =20
[    0.384362] pci 0000:00:14.4: transparent bridge                        =
                   =20
[    0.384398] pci 0000:00:14.4: bridge io port: [0xe000-0xefff]           =
                   =20
[    0.384404] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfcf00000-0xfcff=
ffff]              =20
[    0.384415] pci_bus 0000:00: on NUMA node 0                             =
                   =20
[    0.384419] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]         =
                   =20
[    0.384552] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]    =
                   =20
[    0.384597] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]    =
                   =20
[    0.384641] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]    =
                   =20
[    0.384703] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]    =
                   =20
[    0.387518] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)  =
                   =20
[    0.387762] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)  =
                   =20
[    0.388006] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)  =
                   =20
[    0.388247] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)  =
                   =20
[    0.388489] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0=
,=20
disabled.        =20
[    0.388777] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 *11 12 14 15)  =
                   =20
[    0.389019] ACPI: PCI Interrupt Link [LNKG] (IRQs *4 10 11 12 14 15)    =
                   =20
[    0.389247] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)  =
                   =20
[    0.389635] SCSI subsystem initialized                                  =
                   =20
[    0.389721] libata version 3.00 loaded.                                 =
                   =20
[    0.389792] usbcore: registered new interface driver usbfs              =
                   =20
[    0.389850] usbcore: registered new interface driver hub                =
                   =20
[    0.389913] usbcore: registered new device driver usb                   =
                   =20
[    0.446682] raid6: int64x1   2800 MB/s                                  =
                   =20
[    0.503351] raid6: int64x2   3604 MB/s                                  =
                   =20
[    0.560006] raid6: int64x4   2847 MB/s                                  =
                   =20
[    0.616678] raid6: int64x8   2701 MB/s                                  =
                   =20
[    0.673335] raid6: sse2x1    4094 MB/s                                  =
                   =20
[    0.730007] raid6: sse2x2    7122 MB/s                                  =
                   =20
[    0.786672] raid6: sse2x4    7749 MB/s                                  =
                   =20
[    0.786705] raid6: using algorithm sse2x4 (7749 MB/s)                   =
                   =20
[    0.786789] PCI: Using ACPI for IRQ routing                             =
                   =20
[    0.786827] pci 0000:00:00.0: BAR 3: can't allocate resource            =
                   =20
[    0.800198] PCI-DMA: Disabling AGP.                                     =
                   =20
[    0.800311] PCI-DMA: aperture base @ 20000000 size 65536 KB             =
                   =20
[    0.800346] PCI-DMA: using GART IOMMU.                                  =
                   =20
[    0.800380] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture   =
                   =20
[    0.802138] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0                 =
                   =20
[    0.802246] hpet0: 4 comparators, 32-bit 14.318180 MHz counter          =
                   =20
[    0.806695] hpet: hpet2 irq 24 for MSI                                  =
                   =20
[    0.816682] Switched to high resolution mode on CPU 0                   =
                   =20
[    0.817787] Switched to high resolution mode on CPU 3                   =
                   =20
[    0.817830] Switched to high resolution mode on CPU 2                   =
                   =20
[    0.817873] Switched to high resolution mode on CPU 1                   =
                   =20
[    0.826700] pnp: PnP ACPI init                                          =
                   =20
[    0.826753] ACPI: bus type pnp registered                               =
                   =20
[    0.829214] pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 =
BAR 3=20
(0x0-0x1fffffff), disabling                                                =
                                 =20
[    0.829269] pnp 00:0b: mem resource (0xc0000-0xcffff) overlaps 0000:00:0=
0.0=20
BAR 3 (0x0-0x1fffffff), disabling                                          =
                                   =20
[    0.829324] pnp 00:0b: mem resource (0xe0000-0xfffff) overlaps 0000:00:0=
0.0=20
BAR 3 (0x0-0x1fffffff), disabling                                          =
                                   =20
[    0.829378] pnp 00:0b: mem resource (0x100000-0xc7efffff) overlaps=20
0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling                             =
                                            =20
[    0.829732] pnp: PnP ACPI: found 12 devices                             =
                   =20
[    0.829766] ACPI: ACPI bus type pnp unregistered                        =
                   =20
[    0.829806] system 00:06: iomem range 0xfec00000-0xfec00fff could not be=
=20
reserved          =20
[    0.829859] system 00:06: iomem range 0xfee00000-0xfee00fff has been=20
reserved              =20
[    0.829897] system 00:07: ioport range 0x4d0-0x4d1 has been reserved    =
                   =20
[    0.829932] system 00:07: ioport range 0x40b-0x40b has been reserved    =
                   =20
[    0.829966] system 00:07: ioport range 0x4d6-0x4d6 has been reserved    =
                   =20
[    0.830007] system 00:07: ioport range 0xc00-0xc01 has been reserved    =
                   =20
[    0.830042] system 00:07: ioport range 0xc14-0xc14 has been reserved    =
                   =20
[    0.830077] system 00:07: ioport range 0xc50-0xc51 has been reserved    =
                   =20
[    0.830111] system 00:07: ioport range 0xc52-0xc52 has been reserved    =
                   =20
[    0.830146] system 00:07: ioport range 0xc6c-0xc6c has been reserved    =
                   =20
[    0.830180] system 00:07: ioport range 0xc6f-0xc6f has been reserved    =
                   =20
[    0.830215] system 00:07: ioport range 0xcd0-0xcd1 has been reserved    =
                   =20
[    0.830249] system 00:07: ioport range 0xcd2-0xcd3 has been reserved    =
                   =20
[    0.830284] system 00:07: ioport range 0xcd4-0xcd5 has been reserved    =
                   =20
[    0.830319] system 00:07: ioport range 0xcd6-0xcd7 has been reserved    =
                   =20
[    0.830353] system 00:07: ioport range 0xcd8-0xcdf has been reserved    =
                   =20
[    0.830388] system 00:07: ioport range 0x800-0x89f has been reserved    =
                   =20
[    0.830423] system 00:07: ioport range 0xb00-0xb0f has been reserved    =
                   =20
[    0.830457] system 00:07: ioport range 0xb20-0xb3f has been reserved    =
                   =20
[    0.830492] system 00:07: ioport range 0x900-0x90f has been reserved    =
                   =20
[    0.830526] system 00:07: ioport range 0x910-0x91f has been reserved    =
                   =20
[    0.830561] system 00:07: ioport range 0xfe00-0xfefe has been reserved  =
                   =20
[    0.830596] system 00:07: iomem range 0xffb80000-0xffbfffff has been res=
erved              =20
[    0.830631] system 00:07: iomem range 0xfec10000-0xfec1001f has been=20
reserved              =20
[    0.830668] system 00:09: ioport range 0x290-0x29f has been reserved    =
                   =20
[    0.830704] system 00:0a: iomem range 0xe0000000-0xefffffff has been res=
erved              =20
[    0.830740] system 00:0b: iomem range 0xfec00000-0xffffffff could not be=
=20
reserved          =20
[    0.835633] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02         =
                   =20
[    0.835668] pci 0000:00:02.0:   IO window: 0xb000-0xbfff                =
                   =20
[    0.835703] pci 0000:00:02.0:   MEM window: 0xfdf00000-0xfdffffff       =
                   =20
[    0.835739] pci 0000:00:02.0:   PREFETCH window:=20
0x000000d0000000-0x000000dfffffff         =20
[    0.835793] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03         =
                   =20
[    0.835828] pci 0000:00:09.0:   IO window: 0xc000-0xdfff                =
                   =20
[    0.835863] pci 0000:00:09.0:   MEM window: 0xfe000000-0xfebfffff       =
                   =20
[    0.835898] pci 0000:00:09.0:   PREFETCH window:=20
0x000000fa000000-0x000000fcefffff         =20
[    0.835952] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:01         =
                   =20
[    0.835987] pci 0000:00:0a.0:   IO window: 0xa000-0xafff                =
                   =20
[    0.836022] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff       =
                   =20
[    0.836057] pci 0000:00:0a.0:   PREFETCH window:=20
0x000000cff00000-0x000000cfffffff         =20
[    0.836112] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05         =
                   =20
[    0.836147] pci 0000:00:14.4:   IO window: 0xe000-0xefff                =
                   =20
[    0.836184] pci 0000:00:14.4:   MEM window: disabled                    =
                   =20
[    0.836220] pci 0000:00:14.4:   PREFETCH window:=20
0x000000fcf00000-0x000000fcffffff         =20
[    0.836284] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18=
                   =20
[    0.836320] pci 0000:00:02.0: setting latency timer to 64               =
                   =20
[    0.836325] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17=
                   =20
[    0.836361] pci 0000:00:09.0: setting latency timer to 64               =
                   =20
[    0.836364] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18=
                   =20
[    0.836399] pci 0000:00:0a.0: setting latency timer to 64               =
                   =20
[    0.836406] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]              =
                   =20
[    0.836408] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]                 =20
[    0.836409] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]            =
                   =20
[    0.836411] pci_bus 0000:02: resource 1 mem: [0xfdf00000-0xfdffffff]    =
                   =20
[    0.836412] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]=
                   =20
[    0.836413] pci_bus 0000:03: resource 0 io:  [0xc000-0xdfff]            =
                   =20
[    0.836415] pci_bus 0000:03: resource 1 mem: [0xfe000000-0xfebfffff]    =
                   =20
[    0.836416] pci_bus 0000:03: resource 2 pref mem [0xfa000000-0xfcefffff]=
                   =20
[    0.836418] pci_bus 0000:01: resource 0 io:  [0xa000-0xafff]            =
                   =20
[    0.836419] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdefffff]    =
                   =20
[    0.836420] pci_bus 0000:01: resource 2 pref mem [0xcff00000-0xcfffffff]=
                   =20
[    0.836422] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]            =
                   =20
[    0.836423] pci_bus 0000:05: resource 2 pref mem [0xfcf00000-0xfcffffff]=
                   =20
[    0.836424] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]              =
                   =20
[    0.836426] pci_bus 0000:05: resource 4 mem: [0x000000-0xfffffffffffffff=
f]                 =20
[    0.836479] NET: Registered protocol family 2                           =
                   =20
[    0.873408] IP route cache hash table entries: 262144 (order: 9, 2097152=
=20
bytes)            =20
[    0.873918] TCP established hash table entries: 262144 (order: 10, 41943=
04=20
bytes)          =20
[    0.874895] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)=
                   =20
[    0.875292] TCP: Hash tables configured (established 262144 bind 65536) =
                   =20
[    0.875327] TCP reno registered                                         =
                   =20
[    0.883428] NET: Registered protocol family 1                           =
                   =20
[    0.885125] HugeTLB registered 2 MB page size, pre-allocated 0 pages    =
                   =20
[    0.885267] Loading Reiser4. See www.namesys.com for a description of=20
Reiser4.             =20
[    0.885403] msgmni has been set to 15964                                =
                   =20
[    0.885668] alg: No test for stdrng (krng)                              =
                   =20
[    0.885707] async_tx: api initialized (sync-only)                       =
                   =20
[    0.885786] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor=20
253)           =20
[    0.885839] io scheduler noop registered                                =
                   =20
[    0.885883] io scheduler cfq registered (default)                       =
                   =20
[    0.886008] pci 0000:02:00.0: Boot video device                         =
                   =20
[    0.886108] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X          =
                   =20
[    0.886115] pcieport-driver 0000:00:02.0: setting latency timer to 64   =
                   =20
[    0.886207] pcieport-driver 0000:00:09.0: irq 26 for MSI/MSI-X          =
                   =20
[    0.886214] pcieport-driver 0000:00:09.0: setting latency timer to 64   =
                   =20
[    0.886303] pcieport-driver 0000:00:0a.0: irq 27 for MSI/MSI-X          =
                   =20
[    0.886309] pcieport-driver 0000:00:0a.0: setting latency timer to 64   =
                   =20
[    0.886528] input: Power Button as=20
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0           =20
[    0.886581] ACPI: Power Button [PWRF]                                   =
                   =20
[    0.886662] input: Power Button as=20
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1  =20
[    0.886724] ACPI: Power Button [PWRB]                                   =
                   =20
[    0.886868] processor ACPI_CPU:00: registered as cooling_device0        =
                   =20
[    0.886903] ACPI: Processor [P001] (supports 8 throttling states)       =
                   =20
[    0.886998] processor ACPI_CPU:01: registered as cooling_device1        =
                   =20
[    0.887066] processor ACPI_CPU:02: registered as cooling_device2        =
                   =20
[    0.887134] processor ACPI_CPU:03: registered as cooling_device3        =
                   =20
[    0.890988] Linux agpgart interface v0.103                              =
                   =20
[    0.891110] Driver 'sd' needs updating - please use bus_type methods    =
                   =20
[    0.891197] ahci 0000:00:11.0: version 3.0                              =
                   =20
[    0.891209] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 2=
2                  =20
[    0.891353] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x=
3f=20
impl SATA mode  =20
[    0.891407] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp=
 pio=20
slum part     =20
[    0.891916] scsi0 : ahci                                                =
                   =20
[    0.892055] scsi1 : ahci                                                =
                   =20
[    0.892146] scsi2 : ahci                                                =
                   =20
[    0.892234] scsi3 : ahci                                                =
                   =20
[    0.892323] scsi4 : ahci                                                =
                   =20
[    0.892413] scsi5 : ahci                                                =
                   =20
[    0.892540] ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed=
                   =20
[    0.892576] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff98=
0 irq=20
22           =20
[    0.892630] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa0=
0 irq=20
22           =20
[    0.892683] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa8=
0 irq=20
22           =20
[    0.892737] ata5: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb0=
0 irq=20
22           =20
[    0.892791] ata6: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb8=
0 irq=20
22           =20
[    0.893006] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1      =
                   =20
[    0.893043] PNP: PS/2 appears to have AUX port disabled, if this is=20
incorrect please boot with i8042.nopnp                                     =
                                           =20
[    0.893561] serio: i8042 KBD port at 0x60,0x64 irq 1                    =
                   =20
[    0.893654] mice: PS/2 mouse device common for all mice                 =
                   =20
[    0.893782] rtc_cmos 00:02: RTC can wake from S4                        =
                   =20
[    0.893847] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0       =
                   =20
[    0.893902] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irq=
s                  =20
[    0.893957] md: raid1 personality registered for level 1                =
                   =20
[    0.893991] md: raid6 personality registered for level 6                =
                   =20
[    0.894025] md: raid5 personality registered for level 5                =
                   =20
[    0.894059] md: raid4 personality registered for level 4                =
                   =20
[    0.894169] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
=20
dm-devel@redhat.com
[    0.894264] cpuidle: using governor ladder                              =
                   =20
[    0.894400] usbcore: registered new interface driver hiddev             =
                   =20
[    0.894454] usbcore: registered new interface driver usbhid             =
                   =20
[    0.894488] usbhid: v2.6:USB HID core driver                            =
                   =20
[    0.894562] TCP cubic registered                                        =
                   =20
[    0.894596] NET: Registered protocol family 17                          =
                   =20
[    0.894654] powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor=20
processors (4 cpu cores) (version 2.20.00)                                 =
                                           =20
[    0.895233] powernow-k8:    0 : pstate 0 (3200 MHz)                     =
                   =20
[    0.895269] powernow-k8:    1 : pstate 1 (2500 MHz)                     =
                   =20
[    0.895303] powernow-k8:    2 : pstate 2 (2100 MHz)                     =
                   =20
[    0.895336] powernow-k8:    3 : pstate 3 (800 MHz)                      =
                   =20
[    0.895713] PM: Resume from disk failed.                                =
                   =20
[    0.895806]   Magic number: 5:564:140                                   =
                   =20
[    0.895863] acpi device:11: hash matches                                =
                   =20
[    0.920790] input: AT Translated Set 2 keyboard as=20
/devices/platform/i8042/serio0/input/input2                                =
                                                            =20
[    1.211283] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)      =
                   =20
[    1.211344] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)      =
                   =20
[    1.211396] ata3: SATA link down (SStatus 0 SControl 300)               =
                   =20
[    1.211450] ata5: SATA link down (SStatus 0 SControl 300)               =
                   =20
[    1.214613] ata6: SATA link down (SStatus 0 SControl 300)               =
                   =20
[    1.217640] ata4.00: ATA-7: SAMSUNG HD753LJ, 1AA01113, max UDMA7        =
                   =20
[    1.217680] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32=
)                  =20
[    1.217726] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7        =
                   =20
[    1.217761] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)=
                   =20
[    1.224134] ata4.00: configured for UDMA/133                            =
                   =20
[    1.224187] ata2.00: configured for UDMA/133                            =
                   =20
[    1.611284] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)      =
                   =20
[    1.617637] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7        =
                   =20
[    1.617674] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)=
                   =20
[    1.624092] ata1.00: configured for UDMA/133                            =
                   =20
[    1.637994] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1A=
A0=20
PQ: 0 ANSI: 5   =20
[    1.638206] sd 0:0:0:0: Attached scsi generic sg0 type 0                =
                   =20
[    1.638258] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500=
=20
GB/465 GiB)        =20
[    1.638325] sd 0:0:0:0: [sda] Write Protect is off                      =
                   =20
[    1.638359] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                   =
                   =20
[    1.638372] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA                                                 =
                                      =20
[    1.638432] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1A=
A0=20
PQ: 0 ANSI: 5   =20
[    1.638468]  sda:<5>sd 1:0:0:0: [sdb] 976773168 512-byte hardware sector=
s:=20
(500 GB/465 GiB)=20
[    1.638628] sd 1:0:0:0: Attached scsi generic sg1 type 0                =
                   =20
[    1.638719] sd 1:0:0:0: [sdb] Write Protect is off                      =
                   =20
[    1.638754] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00                   =
                   =20
[    1.638763] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA                                                 =
                                      =20
[    1.638857]  sdb:<5>scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG=20
HD753LJ  1AA0 PQ: 0 ANSI: 5                                                =
                                          =20
[    1.639075] sd 3:0:0:0: [sdc] 1465149168 512-byte hardware sectors: (750=
=20
GB/698 GiB)       =20
[    1.639079] sd 3:0:0:0: Attached scsi generic sg2 type 0                =
                   =20
[    1.639167] sd 3:0:0:0: [sdc] Write Protect is off                      =
                   =20
[    1.639201] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00                   =
                   =20
[    1.639209] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA                                                 =
                                      =20
[    1.639290]  sdc: sda1 sda2 sda3 sda4 < sdc1 sdc2 sdc3 sdc4 < sdb1 sdb2=
=20
sdb3 sdb4 < sdb5 sda5 sdc5 sdc6 sda6 >                                     =
                                       =20
[    1.661815] sd 0:0:0:0: [sda] Attached SCSI disk                        =
                   =20
[    1.667853]  sdb6 >                                                     =
                   =20
[    1.668156] sd 1:0:0:0: [sdb] Attached SCSI disk                        =
                   =20
[    1.671409]  sdc7 >                                                     =
                   =20
[    1.671734] sd 3:0:0:0: [sdc] Attached SCSI disk                        =
                   =20
[    1.671776] md: Waiting for all devices to be available before autodetec=
t                  =20
[    1.671811] md: If you don't use raid, use raid=3Dnoautodetect          =
                     =20
[    1.671909] md: Autodetecting RAID arrays.                              =
                   =20
[    1.778184] md: Scanned 12 and added 12 devices.                        =
                   =20
[    1.778219] md: autorun ...                                             =
                   =20
[    1.778252] md: considering sdc6 ...                                    =
                   =20
[    1.778289] md:  adding sdc6 ...                                        =
                   =20
[    1.778323] md: sdc5 has different UUID to sdc6                         =
                   =20
[    1.778357] md: sdc3 has different UUID to sdc6                         =
                   =20
[    1.778392] md: sdc1 has different UUID to sdc6                         =
                   =20
[    1.778427] md:  adding sdb6 ...                                        =
                   =20
[    1.778461] md: sdb5 has different UUID to sdc6                         =
                   =20
[    1.778495] md: sdb3 has different UUID to sdc6                         =
                   =20
[    1.778529] md: sdb1 has different UUID to sdc6                         =
                   =20
[    1.778564] md:  adding sda6 ...                                        =
                   =20
[    1.778598] md: sda5 has different UUID to sdc6                         =
                   =20
[    1.778632] md: sda3 has different UUID to sdc6                         =
                   =20
[    1.778667] md: sda1 has different UUID to sdc6                         =
                   =20
[    1.778789] md: created md3                                             =
                   =20
[    1.778822] md: bind<sda6>                                              =
                   =20
[    1.778859] md: bind<sdb6>                                              =
                   =20
[    1.778895] md: bind<sdc6>                                              =
                   =20
[    1.778932] md: running: <sdc6><sdb6><sda6>                             =
                   =20
[    1.779059] raid5: device sdc6 operational as raid disk 2               =
                   =20
[    1.779093] raid5: device sdb6 operational as raid disk 1               =
                   =20
[    1.779127] raid5: device sda6 operational as raid disk 0               =
                   =20
[    1.779316] raid5: allocated 3220kB for md3                             =
                   =20
[    1.779368] raid5: raid level 5 set md3 active with 3 out of 3 devices,=
=20
algorithm 2        =20
[    1.779421] RAID5 conf printout:                                        =
                   =20
[    1.779454]  --- rd:3 wd:3                                              =
                   =20
[    1.779487]  disk 0, o:1, dev:sda6                                      =
                   =20
[    1.779520]  disk 1, o:1, dev:sdb6                                      =
                   =20
[    1.779554]  disk 2, o:1, dev:sdc6                                      =
                   =20
[    1.779626] md: considering sdc5 ...                                    =
                   =20
[    1.779661] md:  adding sdc5 ...                                        =
                   =20
[    1.779695] md: sdc3 has different UUID to sdc5                         =
                   =20
[    1.779730] md: sdc1 has different UUID to sdc5                         =
                   =20
[    1.779764] md:  adding sdb5 ...                                        =
                   =20
[    1.779798] md: sdb3 has different UUID to sdc5                         =
                   =20
[    1.779833] md: sdb1 has different UUID to sdc5                         =
                   =20
[    1.779868] md:  adding sda5 ...                                        =
                   =20
[    1.779901] md: sda3 has different UUID to sdc5                         =
                   =20
[    1.779936] md: sda1 has different UUID to sdc5                         =
                   =20
[    1.780031] md: created md2                                             =
                   =20
[    1.780064] md: bind<sda5>                                              =
                   =20
[    1.780101] md: bind<sdb5>                                              =
                   =20
[    1.780137] md: bind<sdc5>                                              =
                   =20
[    1.780173] md: running: <sdc5><sdb5><sda5>                             =
                   =20
[    1.780292] raid5: device sdc5 operational as raid disk 2               =
                   =20
[    1.780326] raid5: device sdb5 operational as raid disk 1               =
                   =20
[    1.780359] raid5: device sda5 operational as raid disk 0               =
                   =20
[    1.780550] raid5: allocated 3220kB for md2                             =
                   =20
[    1.780600] raid5: raid level 5 set md2 active with 3 out of 3 devices,=
=20
algorithm 2        =20
[    1.780653] RAID5 conf printout:                                        =
                   =20
[    1.780686]  --- rd:3 wd:3                                              =
                   =20
[    1.780719]  disk 0, o:1, dev:sda5                                      =
                   =20
[    1.780752]  disk 1, o:1, dev:sdb5                                      =
                   =20
[    1.780785]  disk 2, o:1, dev:sdc5                                      =
                   =20
[    1.780856] md: considering sdc3 ...                                    =
                   =20
[    1.780892] md:  adding sdc3 ...                                        =
                   =20
[    1.780926] md: sdc1 has different UUID to sdc3                         =
                   =20
[    1.780961] md:  adding sdb3 ...                                        =
                   =20
[    1.780994] md: sdb1 has different UUID to sdc3                         =
                   =20
[    1.781029] md:  adding sda3 ...                                        =
                   =20
[    1.781063] md: sda1 has different UUID to sdc3                         =
                   =20
[    1.781160] md: created md1                                             =
                   =20
[    1.781193] md: bind<sda3>                                              =
                   =20
[    1.781229] md: bind<sdb3>                                              =
                   =20
[    1.781269] md: bind<sdc3>                                              =
                   =20
[    1.781305] md: running: <sdc3><sdb3><sda3>                             =
                   =20
[    1.781441] raid5: device sdc3 operational as raid disk 2               =
                   =20
[    1.781475] raid5: device sdb3 operational as raid disk 1               =
                   =20
[    1.781509] raid5: device sda3 operational as raid disk 0               =
                   =20
[    1.781707] raid5: allocated 3220kB for md1                             =
                   =20
[    1.781755] raid5: raid level 5 set md1 active with 3 out of 3 devices,=
=20
algorithm 2        =20
[    1.781807] RAID5 conf printout:                                        =
                   =20
[    1.781840]  --- rd:3 wd:3                                              =
                   =20
[    1.781873]  disk 0, o:1, dev:sda3                                      =
                   =20
[    1.781907]  disk 1, o:1, dev:sdb3                                      =
                   =20
[    1.781940]  disk 2, o:1, dev:sdc3                                      =
                   =20
[    1.782006] md: considering sdc1 ...                                    =
                   =20
[    1.782042] md:  adding sdc1 ...                                        =
                   =20
[    1.782077] md:  adding sdb1 ...                                        =
                   =20
[    1.782111] md:  adding sda1 ...                                        =
                   =20
[    1.782144] md: created md0                                             =
                   =20
[    1.782177] md: bind<sda1>                                              =
                   =20
[    1.782213] md: bind<sdb1>                                              =
                   =20
[    1.782250] md: bind<sdc1>                                              =
                   =20
[    1.782286] md: running: <sdc1><sdb1><sda1>                             =
                   =20
[    1.782435] raid1: raid set md0 active with 3 out of 3 mirrors          =
                   =20
[    1.782496] md: ... autorun DONE.                                       =
                   =20
[    1.782545] md: Loading md3: /dev/sda3                                  =
                   =20
[    1.782584]  md3: unknown partition table                               =
                   =20
[    1.782743] md: couldn't update array info. -22                         =
                   =20
[    1.782780] md: could not bd_claim sda3.                                =
                   =20
[    1.782814] md: md_import_device returned -16                           =
                   =20
[    1.782849] md: could not bd_claim sdb3.                                =
                   =20
[    1.782883] md: md_import_device returned -16                           =
                   =20
[    1.782918] md: could not bd_claim sdc3.                                =
                   =20
[    1.782951] md: md_import_device returned -16                           =
                   =20
[    1.782986] md: starting md3 failed                                     =
                   =20
[    1.783062]  md1: unknown partition table                               =
                   =20
[    1.828578] reiser4: md1: found disk format 4.0.0.                      =
                   =20
[    5.831455] VFS: Mounted root (reiser4 filesystem) readonly on device 9:=
1.                 =20
[    5.831506] Freeing unused kernel memory: 348k freed                    =
                   =20
[    9.678802] udev: starting version 145                                  =
                   =20
[    9.860154]  md2:<6> md0: unknown partition table                       =
                   =20
[    9.941283]  unknown partition table                                    =
                   =20
[   10.440126] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded             =
                   =20
[   10.440143] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ =
17                 =20
[   10.440157] r8169 0000:03:00.0: setting latency timer to 64             =
                   =20
[   10.440428] r8169 0000:03:00.0: irq 28 for MSI/MSI-X                    =
                   =20
[   10.440505] eth0: RTL8168b/8111b at 0xffffc20012f54000, 00:e0:45:46:00:2=
9,=20
XID 38000000 IRQ 28                                                        =
                                    =20
[   10.441896] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded             =
                   =20
[   10.441905] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ =
18                 =20
[   10.441912] r8169 0000:01:00.0: setting latency timer to 64             =
                   =20
[   10.441963] r8169 0000:01:00.0: irq 29 for MSI/MSI-X                    =
                   =20
[   10.442010] eth1: RTL8168c/8111c at 0xffffc2000006a000, 00:19:66:86:ce:1=
2,=20
XID 3c4000c0 IRQ 29                                                        =
                                    =20
[   10.445199] udev: renamed network interface eth1 to eth0                =
                   =20
[   10.463384] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver  =
                   =20
[   10.463405] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> I=
RQ=20
17              =20
[   10.463437] ehci_hcd 0000:00:12.2: EHCI Host Controller                 =
                   =20
[   10.463663] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus=
=20
number 1           =20
[   10.463685] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze=20
workaround          =20
[   10.463701] ehci_hcd 0000:00:12.2: debug port 1                         =
                   =20
[   10.463717] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000            =
                   =20
[   10.474599] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00           =
                   =20
[   10.474625] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002                  =20
[   10.474626] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1             =20
[   10.474628] usb usb1: Product: EHCI Host Controller                     =
                   =20
[   10.474630] usb usb1: Manufacturer: Linux 2.6.30.5r4 ehci_hcd           =
                   =20
[   10.474631] usb usb1: SerialNumber: 0000:00:12.2                        =
                   =20
[   10.474997] usb usb1: configuration #1 chosen from 1 choice             =
                   =20
[   10.475042] hub 1-0:1.0: USB hub found                                  =
                   =20
[   10.475047] hub 1-0:1.0: 6 ports detected                               =
                   =20
[   10.475268] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> I=
RQ=20
19              =20
[   10.475293] ehci_hcd 0000:00:13.2: EHCI Host Controller                 =
                   =20
[   10.475443] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus=
=20
number 2           =20
[   10.475463] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze=20
workaround          =20
[   10.475480] ehci_hcd 0000:00:13.2: debug port 1                         =
                   =20
[   10.475493] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800            =
                   =20
[   10.484596] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00           =
                   =20
[   10.484608] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002                  =20
[   10.484609] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1             =20
[   10.484611] usb usb2: Product: EHCI Host Controller                     =
                   =20
[   10.484612] usb usb2: Manufacturer: Linux 2.6.30.5r4 ehci_hcd           =
                   =20
[   10.484613] usb usb2: SerialNumber: 0000:00:13.2                        =
                   =20
[   10.484681] usb usb2: configuration #1 chosen from 1 choice             =
                   =20
[   10.484709] hub 2-0:1.0: USB hub found                                  =
                   =20
[   10.484714] hub 2-0:1.0: 6 ports detected                               =
                   =20
[   10.495237] udev: renamed network interface _rename to eth1             =
                   =20
[   10.520914] Linux video capture interface: v2.00                        =
                   =20
[   10.528998] bttv: driver version 0.9.18 loaded                          =
                   =20
[   10.529000] bttv: using 8 buffers with 2080k (520 pages) each for captur=
e                  =20
[   10.529041] bttv: Bt8xx card found (0).                                 =
                   =20
[   10.529053] bttv 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 2=
1                  =20
[   10.529063] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 128=
,=20
mmio: 0xfcfff000 =20
[   10.529090] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra=20
TValue Version 1.0/ Vobis TV-Boostar [card=3D25,insmod option]             =
                                          =20
[   10.529093] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs=
                   =20
[   10.529127] bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00ffffff [in=
it]                      =20
[   10.780436] usb 1-2: new high speed USB device using ehci_hcd and addres=
s 2                =20
[   10.905489] usb 1-2: New USB device found, idVendor=3D05e3, idProduct=3D=
0608                   =20
[   10.905491] usb 1-2: New USB device strings: Mfr=3D0, Product=3D1,=20
SerialNumber=3D0              =20
[   10.905492] usb 1-2: Product: USB2.0 Hub
[   10.905542] usb 1-2: configuration #1 chosen from 1 choice
[   10.905975] hub 1-2:1.0: USB hub found
[   10.906238] hub 1-2:1.0: 4 ports detected
[   11.175248] usb 1-2.1: new low speed USB device using ehci_hcd and addre=
ss=20
3
[   11.265001] usb 1-2.1: New USB device found, idVendor=3D046d, idProduct=
=3Dc518
[   11.265002] usb 1-2.1: New USB device strings: Mfr=3D1, Product=3D2,=20
SerialNumber=3D0
[   11.265003] usb 1-2.1: Product: USB Receiver
[   11.265005] usb 1-2.1: Manufacturer: Logitech
[   11.265037] usb 1-2.1: configuration #1 chosen from 1 choice
[   11.275244] input: Logitech USB Receiver as=20
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.1/1-2.1:1.0/input/input3
[   11.275280] generic-usb 0003:046D:C518.0001: input,hidraw0: USB HID v1.1=
1=20
Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.1/input0
[   11.280796] input: Logitech USB Receiver as=20
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.1/1-2.1:1.1/input/input4
[   11.280842] generic-usb 0003:046D:C518.0002: input,hiddev96,hidraw1: USB=
=20
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.1/input1
[   11.530027] bttv0: tea5757: read timeout
[   11.530028] bttv0: tuner type=3D5
[   11.545289] All bytes are equal. It is not a TEA5767
[   11.545319] tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])
[   11.548613] tuner-simple 0-0060: creating new instance
[   11.548616] tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 a=
nd=20
compatibles))
[   11.560954] bttv0: audio absent, no audio device found!
[   11.560985] bttv0: registered device video0
[   11.560997] bttv0: registered device vbi0
[   11.860360] reiser4: md2: found disk format 4.0.0.
[   13.670978] reiser4: md3: found disk format 4.0.0.
[   55.040308] reiser4: sdc7: found disk format 4.0.0.
[   67.430760] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1=20
across:7815612k
[   67.446393] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1=20
across:7815612k
[   67.469538] Adding 7815612k swap on /dev/sdc2.  Priority:1 extents:1=20
across:7815612k
[   68.044789] w83627ehf: Found W83627EHG chip at 0x290
[   68.383049] r8169: eth1: link down
[   68.405254] r8169: eth0: link up
[   68.405264] r8169: eth0: link up
[   71.210164] EMU10K1_Audigy 0000:05:08.0: PCI INT A -> GSI 23 (level, low=
) -
> IRQ 23
[   71.217149] Audigy2 value: Special config.
[   72.532724] fglrx: module license 'Proprietary. (C) 2002 - ATI=20
Technologies, Starnberg, GERMANY' taints kernel.
[   72.532733] Disabling lock debugging due to kernel taint
[   72.580553] [fglrx] Maximum main memory to use for locked dma buffers: 7=
749=20
MBytes.
[   72.580833] [fglrx]   vendor: 1002 device: 9501 count: 1
[   72.581529] [fglrx] ioport: bar 4, base 0xb000, size: 0x100
[   72.581552] pci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   72.581561] pci 0000:02:00.0: setting latency timer to 64
[   72.582058] [fglrx] Kernel PAT support is enabled
[   72.582095] [fglrx] module loaded - fglrx 8.66.1 [Aug 18 2009] with 1=20
minors
[   72.754245] fglrx_pci 0000:02:00.0: irq 30 for MSI/MSI-X
[   72.754717] [fglrx] Firegl kernel thread PID: 3773
[   74.849325] [fglrx] Gart USWC size:1279 M.
[   74.849328] [fglrx] Gart cacheable size:508 M.
[   74.849331] [fglrx] Reserved FB block: Shared offset:0, size:1000000
[   74.849333] [fglrx] Reserved FB block: Unshared offset:fbff000, size:401=
000
[   74.849334] [fglrx] Reserved FB block: Unshared offset:1fffc000, size:40=
00
[  145.542137] reiser4[kopete(3948)]: disable_write_barrier=20
(fs/reiser4/wander.c:235)[zam-1055]:
[  145.542139] NOTICE: md3 does not support write barriers, using synchrono=
us=20
write instead.

lspci:
00:00.0 Host bridge: ATI Technologies Inc RX780/RX790 Chipset Host Bridge
        Subsystem: ASRock Incorporation Device 5957                     =20
        Flags: bus master, 66MHz, medium devsel, latency 0              =20
        Memory at <ignored> (64-bit, non-prefetchable)                  =20
        Capabilities: [c4] HyperTransport: Slave or Primary Interface   =20
        Capabilities: [40] HyperTransport: Retry Mode                   =20
        Capabilities: [54] HyperTransport: UnitID Clumping              =20
        Capabilities: [9c] HyperTransport: #1a                          =20

00:02.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (external=
=20
gfx0 port A) (prog-if 00 [Normal decode])                                  =
                                       =20
        Flags: bus master, fast devsel, latency 0                          =
                   =20
        Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D=
0                          =20
        I/O behind bridge: 0000b000-0000bfff                               =
                   =20
        Memory behind bridge: fdf00000-fdffffff                            =
                   =20
        Prefetchable memory behind bridge: 00000000d0000000-00000000dffffff=
f                  =20
        Capabilities: [50] Power Management version 3                      =
                   =20
        Capabilities: [58] Express Root Port (Slot-), MSI 00               =
                   =20
        Capabilities: [a0] MSI: Mask- 64bit- Count=3D1/1 Enable+           =
                     =20
        Capabilities: [b0] Subsystem: ASRock Incorporation Device 5957     =
                   =20
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+      =
                   =20
        Capabilities: [100] Vendor Specific Information <?>                =
                   =20
        Capabilities: [110] Virtual Channel <?>                            =
                   =20
        Kernel driver in use: pcieport-driver                              =
                   =20

00:09.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI expre=
ss=20
gpp port E) (prog-if 00 [Normal decode])                                   =
                                    =20
        Flags: bus master, fast devsel, latency 0                          =
                   =20
        Bus: primary=3D00, secondary=3D03, subordinate=3D04, sec-latency=3D=
0                          =20
        I/O behind bridge: 0000c000-0000dfff                               =
                   =20
        Memory behind bridge: fe000000-febfffff                            =
                   =20
        Prefetchable memory behind bridge: 00000000fa000000-00000000fceffff=
f                  =20
        Capabilities: [50] Power Management version 3                      =
                   =20
        Capabilities: [58] Express Root Port (Slot-), MSI 00               =
                   =20
        Capabilities: [a0] MSI: Mask- 64bit- Count=3D1/1 Enable+           =
                     =20
        Capabilities: [b0] Subsystem: ASRock Incorporation Device 5957     =
                   =20
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+      =
                   =20
        Capabilities: [100] Vendor Specific Information <?>                =
                   =20
        Capabilities: [110] Virtual Channel <?>                            =
                   =20
        Kernel driver in use: pcieport-driver                              =
                   =20

00:0a.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI expre=
ss=20
gpp port F) (prog-if 00 [Normal decode])                                   =
                                    =20
        Flags: bus master, fast devsel, latency 0                          =
                   =20
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
0                          =20
        I/O behind bridge: 0000a000-0000afff                               =
                   =20
        Memory behind bridge: fde00000-fdefffff                            =
                   =20
        Prefetchable memory behind bridge: 00000000cff00000-00000000cffffff=
f                  =20
        Capabilities: [50] Power Management version 3                      =
                   =20
        Capabilities: [58] Express Root Port (Slot-), MSI 00               =
                   =20
        Capabilities: [a0] MSI: Mask- 64bit- Count=3D1/1 Enable+           =
                     =20
        Capabilities: [b0] Subsystem: ASRock Incorporation Device 5957     =
                   =20
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+      =
                   =20
        Capabilities: [100] Vendor Specific Information <?>                =
                   =20
        Capabilities: [110] Virtual Channel <?>                            =
                   =20
        Kernel driver in use: pcieport-driver                              =
                   =20

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller=20
[AHCI mode] (prog-if 01 [AHCI 1.0])                                        =
                                        =20
        Subsystem: ASRock Incorporation Device 4391                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 22       =
                   =20
        I/O ports at 9000 [size=3D8]                                       =
                     =20
        I/O ports at 8000 [size=3D4]                                       =
                     =20
        I/O ports at 7000 [size=3D8]                                       =
                     =20
        I/O ports at 6000 [size=3D4]                                       =
                     =20
        I/O ports at 5000 [size=3D16]                                      =
                     =20
        Memory at fddff800 (32-bit, non-prefetchable) [size=3D1K]          =
                     =20
        Capabilities: [60] Power Management version 2                      =
                   =20
        Capabilities: [70] SATA HBA <?>                                    =
                   =20
        Kernel driver in use: ahci                                         =
                   =20

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controll=
er=20
(prog-if 10 [OHCI])                                                        =
                                    =20
        Subsystem: ASRock Incorporation Device 4397                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 7        =
                   =20
        Memory at fddfe000 (32-bit, non-prefetchable) [size=3D4K]          =
                     =20
        Kernel modules: ohci-hcd                                           =
                   =20

00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (pr=
og-
if 10 [OHCI])
        Subsystem: ASRock Incorporation Device 4398                        =
               =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 7        =
               =20
        Memory at fddfd000 (32-bit, non-prefetchable) [size=3D4K]          =
                 =20
        Kernel modules: ohci-hcd                                           =
               =20

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controlle=
r=20
(prog-if 20 [EHCI])                                                        =
                                     =20
        Subsystem: ASRock Incorporation Device 4396                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 17       =
                   =20
        Memory at fddff000 (32-bit, non-prefetchable) [size=3D256]         =
                     =20
        Capabilities: [c0] Power Management version 2                      =
                   =20
        Capabilities: [e4] Debug port: BAR=3D1 offset=3D00e0               =
                       =20
        Kernel driver in use: ehci_hcd                                     =
                   =20
        Kernel modules: ehci-hcd                                           =
                   =20

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controll=
er=20
(prog-if 10 [OHCI])                                                        =
                                    =20
        Subsystem: ASRock Incorporation Device 4397                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10       =
                   =20
        Memory at fddfc000 (32-bit, non-prefetchable) [size=3D4K]          =
                     =20
        Kernel modules: ohci-hcd                                           =
                   =20

00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (pr=
og-
if 10 [OHCI])
        Subsystem: ASRock Incorporation Device 4398                        =
               =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10       =
               =20
        Memory at fddf7000 (32-bit, non-prefetchable) [size=3D4K]          =
                 =20
        Kernel modules: ohci-hcd                                           =
               =20

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controlle=
r=20
(prog-if 20 [EHCI])                                                        =
                                     =20
        Subsystem: ASRock Incorporation Device 4396                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 19       =
                   =20
        Memory at fddf6800 (32-bit, non-prefetchable) [size=3D256]         =
                     =20
        Capabilities: [c0] Power Management version 2                      =
                   =20
        Capabilities: [e4] Debug port: BAR=3D1 offset=3D00e0               =
                       =20
        Kernel driver in use: ehci_hcd                                     =
                   =20
        Kernel modules: ehci-hcd                                           =
                   =20

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
        Subsystem: ASRock Incorporation Device 4385               =20
        Flags: 66MHz, medium devsel                               =20
        Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
        Kernel modules: i2c-piix4                                   =20

00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller (pro=
g-
if 8a [Master SecP PriP])                                                  =
                                     =20
        Subsystem: ASRock Incorporation Device 439c                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 0                 =
                   =20
        I/O ports at 01f0 [size=3D8]                                       =
                     =20
        I/O ports at 03f4 [size=3D1]                                       =
                     =20
        I/O ports at 0170 [size=3D8]                                       =
                     =20
        I/O ports at 0374 [size=3D1]                                       =
                     =20
        I/O ports at ff00 [size=3D16]                                      =
                     =20
        Capabilities: [70] MSI: Mask- 64bit- Count=3D1/1 Enable-           =
                     =20

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
        Subsystem: ASRock Incorporation Device 439d                    =20
        Flags: bus master, 66MHz, medium devsel, latency 0             =20

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 0=
1=20
[Subtractive decode])                                                      =
                                     =20
        Flags: bus master, 66MHz, medium devsel, latency 64                =
                   =20
        Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D=
64                         =20
        I/O behind bridge: 0000e000-0000efff                               =
                   =20
        Prefetchable memory behind bridge: fcf00000-fcffffff               =
                   =20

00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controll=
er=20
(prog-if 10 [OHCI])                                                        =
                                    =20
        Subsystem: ASRock Incorporation Device 4399                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10       =
                   =20
        Memory at fddf5000 (32-bit, non-prefetchable) [size=3D4K]          =
                     =20
        Kernel modules: ohci-hcd                                           =
                   =20

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,=20
Athlon64, Sempron] HyperTransport Configuration                            =
                                           =20
        Flags: fast devsel                                                 =
                   =20
        Capabilities: [80] HyperTransport: Host or Secondary Interface     =
                   =20

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,=20
Athlon64, Sempron] Address Map                                             =
                                           =20
        Flags: fast devsel                                                 =
                   =20

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,=20
Athlon64, Sempron] DRAM Controller                                         =
                                           =20
        Flags: fast devsel                                                 =
                   =20

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,=20
Athlon64, Sempron] Miscellaneous Control                                   =
                                           =20
        Flags: fast devsel                                                 =
                   =20
        Capabilities: [f0] Secure device <?>                               =
                   =20
        Kernel driver in use: k10temp                                      =
                   =20
        Kernel modules: k8temp                                             =
                   =20

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,=20
Athlon64, Sempron] Link Control                                            =
                                           =20
        Flags: fast devsel                                                 =
                   =20

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B =
PCI=20
Express Gigabit Ethernet controller (rev 02)                               =
                                   =20
        Subsystem: ASRock Incorporation A770CrossFire motherboard          =
                   =20
        Flags: bus master, fast devsel, latency 0, IRQ 29                  =
                   =20
        I/O ports at a800 [size=3D256]                                     =
                     =20
        Memory at cffff000 (64-bit, prefetchable) [size=3D4K]              =
                     =20
        Memory at cffe0000 (64-bit, prefetchable) [size=3D64K]             =
                     =20
        Expansion ROM at fdef0000 [disabled] [size=3D64K]                  =
                     =20
        Capabilities: [40] Power Management version 3                      =
                   =20
        Capabilities: [50] MSI: Mask- 64bit+ Count=3D1/2 Enable+           =
                     =20
        Capabilities: [70] Express Endpoint, MSI 01                        =
                   =20
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=3D2                =
                     =20
        Capabilities: [d0] Vital Product Data                              =
                   =20
        Capabilities: [100] Advanced Error Reporting                       =
                   =20
        Capabilities: [140] Virtual Channel <?>                            =
                   =20
        Capabilities: [160] Device Serial Number 00-e0-4c-68-12-34-56-78   =
                   =20
        Kernel driver in use: r8169                                        =
                   =20
        Kernel modules: r8169                                              =
                   =20

02:00.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3870 (pro=
g-
if 00 [VGA controller])
        Subsystem: Info-Tek Corp. Device 4070
        Flags: bus master, fast devsel, latency 0, IRQ 30
        Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
        Memory at fdff0000 (64-bit, non-prefetchable) [size=3D64K]
        I/O ports at b000 [size=3D256]
        Expansion ROM at fdfc0000 [disabled] [size=3D128K]
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Legacy Endpoint, MSI 00
        Capabilities: [a0] MSI: Mask- 64bit+ Count=3D1/1 Enable+
        Capabilities: [100] Vendor Specific Information <?>
        Kernel driver in use: fglrx_pci
        Kernel modules: fglrx

02:00.1 Audio device: ATI Technologies Inc Radeon HD 3870 Audio device
        Subsystem: Info-Tek Corp. Device aa18
        Flags: bus master, fast devsel, latency 0, IRQ 10
        Memory at fdfec000 (64-bit, non-prefetchable) [size=3D16K]
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Legacy Endpoint, MSI 00
        Capabilities: [a0] MSI: Mask- 64bit+ Count=3D1/1 Enable-
        Capabilities: [100] Vendor Specific Information <?>
        Kernel modules: snd-hda-intel

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B =
PCI=20
Express Gigabit Ethernet controller (rev 01)
        Subsystem: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Expres=
s=20
Gigabit Ethernet controller
        Flags: bus master, fast devsel, latency 0, IRQ 28
        I/O ports at d800 [size=3D256]
        Memory at febff000 (64-bit, non-prefetchable) [size=3D4K]
        Expansion ROM at febc0000 [disabled] [size=3D128K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Vital Product Data
        Capabilities: [50] MSI: Mask- 64bit+ Count=3D1/2 Enable+
        Capabilities: [60] Express Endpoint, MSI 00
        Capabilities: [84] Vendor Specific Information <?>
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [12c] Virtual Channel <?>
        Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-0d-36
        Capabilities: [154] Power Budgeting <?>
        Kernel driver in use: r8169
        Kernel modules: r8169

05:06.0 Multimedia video controller: Brooktree Corporation Bt848 Video Capt=
ure=20
(rev 12)
        Flags: bus master, medium devsel, latency 128, IRQ 21
        Memory at fcfff000 (32-bit, prefetchable) [size=3D4K]
        Kernel driver in use: bttv
        Kernel modules: bttv

05:08.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
        Subsystem: Creative Labs Device 1001
        Flags: bus master, medium devsel, latency 128, IRQ 23
        I/O ports at e800 [size=3D64]
        Capabilities: [dc] Power Management version 2
        Kernel driver in use: EMU10K1_Audigy
        Kernel modules: snd-emu10k1

Gl=FCck Auf
Volker

--Boundary-00=_AgsjKTLsRHvTDXZ
Content-Type: text/plain;
  charset="ISO-8859-15";
  name="config-2.6.30.5r4"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="config-2.6.30.5r4"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.30.5
# Tue Aug 18 06:20:30 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="r4"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_EXTRA_PASS=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_API_DEBUG=y
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
CONFIG_NR_CPUS=4
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_CPU_DEBUG=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_GFX_WA=y
CONFIG_DMAR_FLOPPY_WA=y
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CT_ACCT is not set
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NF_CT_NETLINK=m
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
CONFIG_NETFILTER_XT_MATCH_MAC=m
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_GARP=m
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=16
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_93CX6=m
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=y
CONFIG_MD_RAID6_PQ=y
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_COMPAT_NET_DEV_OPS=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
CONFIG_MACVLAN=m
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
# CONFIG_NET_PCI is not set
# CONFIG_B44 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1680
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1050
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
# CONFIG_MOUSE_PS2_ALPS is not set
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=m
# CONFIG_VIDEO_BT848_DVB is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
# CONFIG_USB_GSPCA is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
# CONFIG_VIDEO_CX231XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_PWC_INPUT_EVDEV is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_SIANO_SMS1XXX is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#
# CONFIG_DVB_DM1105 is not set

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set
CONFIG_DVB_CX24110=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_LGDT330X=m
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
CONFIG_SND_HDA_CODEC_ATIHDMI=y
# CONFIG_SND_HDA_CODEC_NVHDMI is not set
# CONFIG_SND_HDA_CODEC_INTELHDMI is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
# CONFIG_SND_HDA_GENERIC is not set
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_REISER4_FS=y
# CONFIG_REISER4_DEBUG is not set
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
# CONFIG_FRAME_POINTER is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_EVENT_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_IMA is not set
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_KVM_TRACE is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--Boundary-00=_AgsjKTLsRHvTDXZ--
