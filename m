Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144Ab0AVH24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0AVH24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 02:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960Ab0AVH24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 02:28:56 -0500
Received: from mailsrv1.zmi.at ([195.202.151.133]:47961 "EHLO mailsrv13.zmi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab0AVH2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 02:28:53 -0500
To: linux-kernel@vger.kernel.org
Subject: kernel "OOPS: SMP" on remount EXT4, kernel 2.6.31.8-0.1-vanilla from openSUSE 11.2
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Organization: it-management http://it-management.at
Date: Fri, 22 Jan 2010 08:28:48 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6486238.EUvpQ097YS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201001220828.48609@zmi.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6486238.EUvpQ097YS
Content-Type: multipart/mixed;
  boundary="Boundary-01=_wOVWLWnvPFxF0Fq"
Content-Transfer-Encoding: 7bit


--Boundary-01=_wOVWLWnvPFxF0Fq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

(as I got no feedback from my first post on Jan 19, here a re-post)

I just had a kernel oops (but system didn't crash). I created an ext4=20
with

mkfs.ext4 -L saturnwork -O extent,uninit_bg -E lazy_itable_init=20
/dev/sdc3

and then mounted it with

mount /dev/sdc3 /1/disks/work/ -o=20
barrier,delalloc,auto_da_alloc,noatime,acl,user_xattr

then a remount:

mount -o remount,relatime /1/disks/work/

The disk is SATA and was hot-plugged before, and contained an old linux=20
reiserfs. I attach the full dmesg log for review. You can contact me=20
personally, I'm not on this list.

The kernel is from openSUSE 11.2, but vanilla, as with the "desktop"=20
kernel from openSUSE 11.2 my system crashed a lot (hardware seems OK,=20
running memtest for 14 hours showed no problems. Also no problems since=20
I use the vanilla kernel, except this ext4 problem now).

Problem seems SMP related, hardware is a quad-core AMD Phenom.

After that oops, I couldn't unmount the device anymore, had to reboot=20
the machine.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://it-management.at
Tel: 0660 / 415 65 31

// Wir haben zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://willhaben.at/iad/realestate/object?adId=3D15923011

--Boundary-01=_wOVWLWnvPFxF0Fq
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31.8-0.1-vanilla (geeko@buildhost) (gcc ve=
rsion 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #1 SMP 2009-12-=
15 23:55:40 +0100
[    0.000000] Command line: root=3D/dev/sda2 resume=3D/dev/disk/by-id/ata-=
WDC_WD1500HLFS-01G6U0_WD-WXJ608AR0429-part1 splash=3Dsilent quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff90000 (usable)
[    0.000000]  BIOS-e820: 00000000cff90000 - 00000000cffa8000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffa8000 - 00000000cffd0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffd0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around =
it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0x230000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000230000000 aka 8960M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xcff90 max_arch_pfn =3D 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009ec00 (usable)
[    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cff90000 (usable)
[    0.000000]  modified: 00000000cff90000 - 00000000cffa8000 (ACPI data)
[    0.000000]  modified: 00000000cffa8000 - 00000000cffd0000 (ACPI NVS)
[    0.000000]  modified: 00000000cffd0000 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cff90000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff90000 page 4k
[    0.000000] kernel direct mapping tables up to cff90000 @ 10000-13000
[    0.000000] init_memory_mapping: 0000000100000000-0000000230000000
[    0.000000]  0100000000 - 0200000000 page 1G
[    0.000000]  0200000000 - 0230000000 page 2M
[    0.000000] kernel direct mapping tables up to 230000000 @ 12000-14000
[    0.000000] RAMDISK: 379ee000 - 37fef916
[    0.000000] ACPI: RSDP 00000000000fb4f0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cff90100 00054 (v01 091009 XSDT1614 20090=
910 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cff90290 000F4 (v03 091009 FACP1614 20090=
910 MSFT 00000097)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero addres=
s or length: 0000000000000000/1 20090521 tbfadt-558
[    0.000000] ACPI: DSDT 00000000cff90450 0D60E (v01  A1392 A1392001 00000=
001 INTL 20060113)
[    0.000000] ACPI: FACS 00000000cffa8000 00040
[    0.000000] ACPI: APIC 00000000cff90390 0007C (v01 091009 APIC1614 20090=
910 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cff90410 0003C (v01 091009 OEMMCFG  20090=
910 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cffa8040 00072 (v01 091009 OEMB1614 20090=
910 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cff9f450 00038 (v01 091009 OEMHPET  20090=
910 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cff9f490 0088C (v01 A M I  POWERNOW 00000=
001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000230000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000230000000
[    0.000000]   NODE_DATA [0000000000013000 - 000000000002afff]
[    0.000000]   bootmap [000000000002b000 -  0000000000070fff] pages 46
[    0.000000] (8 early reservations) =3D=3D> bootmem [0000000000 - 0230000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001a76730]    TEXT DATA BSS =3D=3D> [000=
1000000 - 0001a76730]
[    0.000000]   #3 [00379ee000 - 0037fef916]          RAMDISK =3D=3D> [003=
79ee000 - 0037fef916]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved =3D=3D> [000=
009ec00 - 0000100000]
[    0.000000]   #5 [0001a77000 - 0001a77340]              BRK =3D=3D> [000=
1a77000 - 0001a77340]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE =3D=3D> [000=
0010000 - 0000012000]
[    0.000000]   #7 [0000012000 - 0000013000]          PGTABLE =3D=3D> [000=
0012000 - 0000013000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]  [ffffea0000000000-ffffea0007bfffff] PMD -> [ffff88002860000=
0-ffff88002f7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00230000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000cff90
[    0.000000]     0: 0x00100000 -> 0x00230000
[    0.000000] On node 0 totalpages: 2096926
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3823 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833480 pages, LIFO batch:31
[    0.000000]   Normal zone: 17024 pages used for memmap
[    0.000000]   Normal zone: 1228160 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 6 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000=
9f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 00000000cff90000 - 00000000cff=
a8000
[    0.000000] PM: Registered nosave memory: 00000000cffa8000 - 00000000cff=
d0000
[    0.000000] PM: Registered nosave memory: 00000000cffd0000 - 00000000d00=
00000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000ff7=
00000
[    0.000000] PM: Registered nosave memory: 00000000ff700000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000=
:2f700000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:6 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages at ffff880028034000, static data 8=
2912 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 2065463
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=3D/dev/sda2 resume=3D/dev/disk/by-=
id/ata-WDC_WD1500HLFS-01G6U0_WD-WXJ608AR0429-part1 splash=3Dsilent quiet
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 20000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 00000000240=
00000
[    0.000000] Memory: 8187504k/9175040k available (5221k kernel code, 7873=
36k absent, 200200k reserved, 2616k data, 1620k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:456
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2812.538 MHz processor.
[    0.000956] Console: colour VGA+ 80x25
[    0.000958] console [tty0] enabled
[    0.004000] allocated 83886080 bytes of page_cgroup
[    0.004000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.004000] hpet clockevent registered
[    0.004000]   alloc irq_desc for 24 on node 0
[    0.004000]   alloc kstat_irqs on node 0
[    0.004000] HPET: 4 timers in total, 1 timers will be used for per-cpu t=
imer
[    0.004007] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5625.06 BogoMIPS (lpj=3D11250136)
[    0.004065] Security Framework initialized
[    0.004073] SELinux:  Disabled at boot.
[    0.004599] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.006744] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.007657] Mount-cache hash table entries: 256
[    0.007764] Initializing cgroup subsys ns
[    0.007767] Initializing cgroup subsys cpuacct
[    0.007770] Initializing cgroup subsys memory
[    0.007780] Initializing cgroup subsys devices
[    0.007782] Initializing cgroup subsys freezer
[    0.007783] Initializing cgroup subsys net_cls
[    0.007803] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.007805] CPU: L2 Cache: 512K (64 bytes/line)
[    0.007807] CPU 0/0x0 -> Node 0
[    0.007809] tseg: 0000000000
[    0.007819] CPU: Physical Processor ID: 0
[    0.007820] CPU: Processor Core ID: 0
[    0.007822] mce: CPU supports 6 MCE banks
[    0.007829] using C1E aware idle routine
[    0.007831] Performance Counters: AMD PMU driver.
[    0.007834] ... version:                 0
[    0.007835] ... bit width:               48
[    0.007836] ... generic counters:        4
[    0.007838] ... value mask:              0000ffffffffffff
[    0.007839] ... max period:              00007fffffffffff
[    0.007840] ... fixed-purpose counters:  0
[    0.007842] ... counter mask:            000000000000000f
[    0.008960] ACPI: Core revision 20090521
[    0.028051] Setting APIC routing to flat
[    0.028346] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
=2D1
[    0.070984] CPU0: AMD Phenom(tm) II X4 925 Processor stepping 02
[    0.072001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5625.13 Bog=
oMIPS (lpj=3D11250275)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.156913] CPU1: AMD Phenom(tm) II X4 925 Processor stepping 02
[    0.156920] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.160078] Booting processor 2 APIC 0x2 ip 0x6000
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 5625.13 Bog=
oMIPS (lpj=3D11250278)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 2/0x2 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 2
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x701060007=
0106
[    0.248960] CPU2: AMD Phenom(tm) II X4 925 Processor stepping 02
[    0.248967] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.252074] Booting processor 3 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 5625.12 Bog=
oMIPS (lpj=3D11250249)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 3/0x3 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 3
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x701060007=
0106
[    0.340909] CPU3: AMD Phenom(tm) II X4 925 Processor stepping 02
[    0.340915] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.344012] Brought up 4 CPUs
[    0.344014] Total of 4 processors activated (22500.46 BogoMIPS).
[    0.344075] CPU0 attaching sched-domain:
[    0.344078]  domain 0: span 0-3 level MC
[    0.344080]   groups: 0 1 2 3
[    0.344085] CPU1 attaching sched-domain:
[    0.344087]  domain 0: span 0-3 level MC
[    0.344089]   groups: 1 2 3 0
[    0.344093] CPU2 attaching sched-domain:
[    0.344094]  domain 0: span 0-3 level MC
[    0.344096]   groups: 2 3 0 1
[    0.344100] CPU3 attaching sched-domain:
[    0.344101]  domain 0: span 0-3 level MC
[    0.344103]   groups: 3 0 1 2
[    0.344167] Booting paravirtualized kernel on bare hardware
[    0.344167] regulator: core version 0.5
[    0.344167] Time: 10:26:23  Date: 01/18/10
[    0.344167] NET: Registered protocol family 16
[    0.344199] node 0 link 0: io port [1000, ffffff]
[    0.344202] TOM: 00000000d0000000 aka 3328M
[    0.344203] Fam 10h mmconf [e0000000, efffffff]
[    0.344206] node 0 link 0: mmio [a0000, bffff]
[    0.344208] node 0 link 0: mmio [d0000000, dfffffff]
[    0.344210] node 0 link 0: mmio [e0000000, efffffff] =3D=3D> none
[    0.344212] node 0 link 0: mmio [f0000000, ffefffff]
[    0.344214] TOM2: 0000000230000000 aka 8960M
[    0.344216] bus: [00,07] on node 0 link 0
[    0.344218] bus: 00 index 0 io port: [0, ffff]
[    0.344219] bus: 00 index 1 mmio: [a0000, bffff]
[    0.344221] bus: 00 index 2 mmio: [d0000000, dfffffff]
[    0.344223] bus: 00 index 3 mmio: [f0000000, ffffffff]
[    0.344224] bus: 00 index 4 mmio: [230000000, fcffffffff]
[    0.344233] ACPI: bus type pci registered
[    0.344289] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.344291] PCI: Not using MMCONFIG.
[    0.344292] PCI: Using configuration type 1 for base access
[    0.344294] PCI: Using configuration type 1 for extended access
[    0.344775] bio: create slab <bio-0> at 0
[    0.344948] ACPI: EC: Look up EC in DSDT
[    0.411745] ACPI: Interpreter enabled
[    0.411749] ACPI: (supports S0 S1 S3 S4 S5)
[    0.411776] ACPI: Using IOAPIC for interrupt routing
[    0.411833] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.418569] PCI: MCFG area at e0000000 reserved in ACPI motherboard reso=
urces
[    0.424782] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.434145] ACPI Warning: Incorrect checksum in table [OEMB] - F2, shoul=
d be ED 20090521 tbutils-246
[    0.434277] ACPI: No dock devices found.
[    0.434456] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.434546] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.434548] pci 0000:00:02.0: PME# disabled
[    0.434583] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.434586] pci 0000:00:0a.0: PME# disabled
[    0.434632] pci 0000:00:11.0: reg 10 io port: [0xb000-0xb007]
[    0.434638] pci 0000:00:11.0: reg 14 io port: [0xa000-0xa003]
[    0.434645] pci 0000:00:11.0: reg 18 io port: [0x9000-0x9007]
[    0.434651] pci 0000:00:11.0: reg 1c io port: [0x8000-0x8003]
[    0.434657] pci 0000:00:11.0: reg 20 io port: [0x7000-0x700f]
[    0.434663] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe8ffc00-0xfe8fffff]
[    0.434712] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe8fe000-0xfe8fefff]
[    0.434762] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe8fd000-0xfe8fdfff]
[    0.434829] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe8ff800-0xfe8ff8ff]
[    0.434878] pci 0000:00:12.2: supports D1 D2
[    0.434879] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.434883] pci 0000:00:12.2: PME# disabled
[    0.434912] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe8fc000-0xfe8fcfff]
[    0.434963] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe8fb000-0xfe8fbfff]
[    0.435030] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe8ff400-0xfe8ff4ff]
[    0.435078] pci 0000:00:13.2: supports D1 D2
[    0.435079] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.435083] pci 0000:00:13.2: PME# disabled
[    0.435192] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.435198] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.435204] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.435210] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.435216] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.435276] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe8f4000-0xfe8f7fff]
[    0.435316] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.435320] pci 0000:00:14.2: PME# disabled
[    0.435417] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe8fa000-0xfe8fafff]
[    0.435542] pci 0000:01:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
[    0.435550] pci 0000:01:00.0: reg 18 64bit mmio: [0xfe9f0000-0xfe9fffff]
[    0.435554] pci 0000:01:00.0: reg 20 io port: [0xc000-0xc0ff]
[    0.435562] pci 0000:01:00.0: reg 30 32bit mmio: [0xfe9c0000-0xfe9dffff]
[    0.435577] pci 0000:01:00.0: supports D1 D2
[    0.435605] pci 0000:01:00.1: reg 10 64bit mmio: [0xfe9ec000-0xfe9effff]
[    0.435634] pci 0000:01:00.1: supports D1 D2
[    0.440071] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]
[    0.440074] pci 0000:00:02.0: bridge 32bit mmio: [0xfe900000-0xfe9fffff]
[    0.440078] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfff=
ffff]
[    0.440115] pci 0000:02:00.0: reg 10 io port: [0xd800-0xd8ff]
[    0.440129] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdfff000-0xfdffffff]
[    0.440139] pci 0000:02:00.0: reg 20 64bit mmio: [0xfdff8000-0xfdffbfff]
[    0.440145] pci 0000:02:00.0: reg 30 32bit mmio: [0xfeaf0000-0xfeafffff]
[    0.440174] pci 0000:02:00.0: supports D1 D2
[    0.440175] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.440179] pci 0000:02:00.0: PME# disabled
[    0.448078] pci 0000:00:0a.0: bridge io port: [0xd000-0xdfff]
[    0.448082] pci 0000:00:0a.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.448085] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xfdf00000-0xfdff=
ffff]
[    0.448142] pci 0000:03:08.0: reg 10 32bit mmio: [0xfebff800-0xfebfffff]
[    0.448150] pci 0000:03:08.0: reg 14 io port: [0xec00-0xec7f]
[    0.448206] pci 0000:03:08.0: supports D2
[    0.448208] pci 0000:03:08.0: PME# supported from D2 D3hot D3cold
[    0.448213] pci 0000:03:08.0: PME# disabled
[    0.448256] pci 0000:00:14.4: transparent bridge
[    0.448259] pci 0000:00:14.4: bridge io port: [0xe000-0xefff]
[    0.448263] pci 0000:00:14.4: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.448282] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.448514] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.448594] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.448671] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.453387] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 *10 11 12 14 15)
[    0.453511] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)
[    0.453632] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    0.453752] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.453872] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0=
, disabled.
[    0.453992] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0=
, disabled.
[    0.454113] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 *11 12 14 15)
[    0.454233] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)
[    0.454416] SCSI subsystem initialized
[    0.454437] libata version 3.00 loaded.
[    0.454437] usbcore: registered new interface driver usbfs
[    0.454437] usbcore: registered new interface driver hub
[    0.454437] usbcore: registered new device driver usb
[    0.454437] PCI: Using ACPI for IRQ routing
[    0.464147] PCI-DMA: Disabling AGP.
[    0.464224] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.464225] PCI-DMA: using GART IOMMU.
[    0.464228] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.465749] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.465755] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.468028] hpet: hpet2 irq 24 for MSI
[    0.484022] pnp: PnP ACPI init
[    0.484041] ACPI: bus type pnp registered
[    0.489998] pnp: PnP ACPI: found 14 devices
[    0.490000] ACPI: ACPI bus type pnp unregistered
[    0.490012] system 00:09: iomem range 0xfec00000-0xfec00fff could not be=
 reserved
[    0.490015] system 00:09: iomem range 0xfee00000-0xfee00fff has been res=
erved
[    0.490020] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.490022] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    0.490024] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    0.490026] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    0.490028] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    0.490030] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    0.490033] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    0.490035] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    0.490037] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    0.490039] system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
[    0.490041] system 00:0a: ioport range 0xcd2-0xcd3 has been reserved
[    0.490043] system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
[    0.490045] system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
[    0.490047] system 00:0a: ioport range 0xcd8-0xcdf has been reserved
[    0.490050] system 00:0a: ioport range 0xb00-0xb3f has been reserved
[    0.490052] system 00:0a: ioport range 0x800-0x89f has been reserved
[    0.490054] system 00:0a: ioport range 0xb00-0xb0f has been reserved
[    0.490056] system 00:0a: ioport range 0xb20-0xb3f has been reserved
[    0.490058] system 00:0a: ioport range 0x900-0x90f has been reserved
[    0.490060] system 00:0a: ioport range 0x910-0x91f has been reserved
[    0.490063] system 00:0a: ioport range 0xfe00-0xfefe has been reserved
[    0.490065] system 00:0a: iomem range 0xffb80000-0xffbfffff has been res=
erved
[    0.490068] system 00:0a: iomem range 0xfec10000-0xfec1001f has been res=
erved
[    0.490070] system 00:0a: iomem range 0xfed40000-0xfed44fff has been res=
erved
[    0.490075] system 00:0b: ioport range 0x230-0x23f has been reserved
[    0.490077] system 00:0b: ioport range 0x290-0x29f has been reserved
[    0.490079] system 00:0b: ioport range 0x300-0x30f has been reserved
[    0.490081] system 00:0b: ioport range 0xa30-0xa3f has been reserved
[    0.490085] system 00:0c: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.490089] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.490092] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.490094] system 00:0d: iomem range 0xe0000-0xfffff could not be reser=
ved
[    0.490096] system 00:0d: iomem range 0x100000-0xcfffffff could not be r=
eserved
[    0.490098] system 00:0d: iomem range 0xfec00000-0xffffffff could not be=
 reserved
[    0.494820] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.494823] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    0.494826] pci 0000:00:02.0:   MEM window: 0xfe900000-0xfe9fffff
[    0.494829] pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x0000=
00dfffffff
[    0.494832] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
[    0.494835] pci 0000:00:0a.0:   IO window: 0xd000-0xdfff
[    0.494837] pci 0000:00:0a.0:   MEM window: 0xfea00000-0xfeafffff
[    0.494840] pci 0000:00:0a.0:   PREFETCH window: 0x000000fdf00000-0x0000=
00fdffffff
[    0.494843] pci 0000:00:14.4: PCI bridge, secondary bus 0000:03
[    0.494846] pci 0000:00:14.4:   IO window: 0xe000-0xefff
[    0.494851] pci 0000:00:14.4:   MEM window: 0xfeb00000-0xfebfffff
[    0.494855] pci 0000:00:14.4:   PREFETCH window: disabled
[    0.494864]   alloc irq_desc for 18 on node 0
[    0.494866]   alloc kstat_irqs on node 0
[    0.494870] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.494874] pci 0000:00:02.0: setting latency timer to 64
[    0.494879] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.494881] pci 0000:00:0a.0: setting latency timer to 64
[    0.494888] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.494890] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.494893] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    0.494895] pci_bus 0000:01: resource 1 mem: [0xfe900000-0xfe9fffff]
[    0.494897] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.494899] pci_bus 0000:02: resource 0 io:  [0xd000-0xdfff]
[    0.494901] pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.494903] pci_bus 0000:02: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.494905] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.494906] pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.494908] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
[    0.494910] pci_bus 0000:03: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.494996] NET: Registered protocol family 2
[    0.495204] IP route cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[    0.496273] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.498200] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.498441] TCP: Hash tables configured (established 524288 bind 65536)
[    0.498443] TCP reno registered
[    0.498574] NET: Registered protocol family 1
[    0.498623] Unpacking initramfs...
[    0.500901] Switched to high resolution mode on CPU 3
[    0.500904] Switched to high resolution mode on CPU 1
[    0.500945] Switched to high resolution mode on CPU 2
[    0.504018] Switched to high resolution mode on CPU 0
[    0.593504] Freeing initrd memory: 6150k freed
[    0.595206] Scanning for low memory corruption every 60 seconds
[    0.595340] audit: initializing netlink socket (disabled)
[    0.595350] type=3D2000 audit(1263810382.592:1): initialized
[    0.601000] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.601147] VFS: Disk quotas dquot_6.5.2
[    0.601176] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.601309] msgmni has been set to 16003
[    0.601383] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.601385] io scheduler noop registered
[    0.601386] io scheduler anticipatory registered
[    0.601388] io scheduler deadline registered
[    0.601406] io scheduler cfq registered (default)
[    0.764041] pci 0000:01:00.0: Boot video device
[    0.764171]   alloc irq_desc for 25 on node 0
[    0.764173]   alloc kstat_irqs on node 0
[    0.764180] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.764185] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.764271]   alloc irq_desc for 26 on node 0
[    0.764272]   alloc kstat_irqs on node 0
[    0.764277] pcieport-driver 0000:00:0a.0: irq 26 for MSI/MSI-X
[    0.764280] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    0.765246] Non-volatile memory driver v1.3
[    0.765248] Linux agpgart interface v0.103
[    0.765251] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.765347] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.765617] 00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.765751] ahci 0000:00:11.0: version 3.0
[    0.765763]   alloc irq_desc for 22 on node 0
[    0.765764]   alloc kstat_irqs on node 0
[    0.765769] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.765890] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x=
3f impl SATA mode
[    0.765893] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp=
 pio slum part=20
[    0.766185] scsi0 : ahci
[    0.766259] scsi1 : ahci
[    0.766297] scsi2 : ahci
[    0.766334] scsi3 : ahci
[    0.766372] scsi4 : ahci
[    0.766408] scsi5 : ahci
[    0.766521] ata1: SATA max UDMA/133 abar m1024@0xfe8ffc00 port 0xfe8ffd0=
0 irq 22
[    0.766525] ata2: SATA max UDMA/133 abar m1024@0xfe8ffc00 port 0xfe8ffd8=
0 irq 22
[    0.766528] ata3: SATA max UDMA/133 abar m1024@0xfe8ffc00 port 0xfe8ffe0=
0 irq 22
[    0.766531] ata4: SATA max UDMA/133 abar m1024@0xfe8ffc00 port 0xfe8ffe8=
0 irq 22
[    0.766534] ata5: SATA max UDMA/133 abar m1024@0xfe8ffc00 port 0xfe8fff0=
0 irq 22
[    0.766537] ata6: SATA max UDMA/133 abar m1024@0xfe8ffc00 port 0xfe8fff8=
0 irq 22
[    0.766612] Fixed MDIO Bus: probed
[    0.766618] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.766669]   alloc irq_desc for 17 on node 0
[    0.766670]   alloc kstat_irqs on node 0
[    0.766674] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[    0.766685] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.766704] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus =
number 1
[    0.766738] ehci_hcd 0000:00:12.2: debug port 1
[    0.766752] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe8ff800
[    0.776023] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.776047] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    0.776049] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.776051] usb usb1: Product: EHCI Host Controller
[    0.776053] usb usb1: Manufacturer: Linux 2.6.31.8-0.1-vanilla ehci_hcd
[    0.776054] usb usb1: SerialNumber: 0000:00:12.2
[    0.776093] usb usb1: configuration #1 chosen from 1 choice
[    0.776113] hub 1-0:1.0: USB hub found
[    0.776119] hub 1-0:1.0: 6 ports detected
[    0.776208]   alloc irq_desc for 19 on node 0
[    0.776209]   alloc kstat_irqs on node 0
[    0.776215] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> I=
RQ 19
[    0.776225] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.776233] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus =
number 2
[    0.776262] ehci_hcd 0000:00:13.2: debug port 1
[    0.776275] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe8ff400
[    0.788023] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.788045] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    0.788046] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.788048] usb usb2: Product: EHCI Host Controller
[    0.788050] usb usb2: Manufacturer: Linux 2.6.31.8-0.1-vanilla ehci_hcd
[    0.788051] usb usb2: SerialNumber: 0000:00:13.2
[    0.788086] usb usb2: configuration #1 chosen from 1 choice
[    0.788103] hub 2-0:1.0: USB hub found
[    0.788108] hub 2-0:1.0: 6 ports detected
[    0.788166] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.788206]   alloc irq_desc for 16 on node 0
[    0.788208]   alloc kstat_irqs on node 0
[    0.788212] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    0.788224] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.788230] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus =
number 3
[    0.788251] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe8fe000
[    0.848022] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    0.848025] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.848027] usb usb3: Product: OHCI Host Controller
[    0.848029] usb usb3: Manufacturer: Linux 2.6.31.8-0.1-vanilla ohci_hcd
[    0.848030] usb usb3: SerialNumber: 0000:00:12.0
[    0.848065] usb usb3: configuration #1 chosen from 1 choice
[    0.848086] hub 3-0:1.0: USB hub found
[    0.848095] hub 3-0:1.0: 3 ports detected
[    0.848171] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    0.848182] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    0.848188] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus =
number 4
[    0.848204] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe8fd000
[    0.908020] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    0.908022] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.908024] usb usb4: Product: OHCI Host Controller
[    0.908026] usb usb4: Manufacturer: Linux 2.6.31.8-0.1-vanilla ohci_hcd
[    0.908027] usb usb4: SerialNumber: 0000:00:12.1
[    0.908064] usb usb4: configuration #1 chosen from 1 choice
[    0.908083] hub 4-0:1.0: USB hub found
[    0.908090] hub 4-0:1.0: 3 ports detected
[    0.908167] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> I=
RQ 18
[    0.908179] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.908184] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus =
number 5
[    0.908206] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe8fc000
[    0.968018] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    0.968021] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.968023] usb usb5: Product: OHCI Host Controller
[    0.968024] usb usb5: Manufacturer: Linux 2.6.31.8-0.1-vanilla ohci_hcd
[    0.968026] usb usb5: SerialNumber: 0000:00:13.0
[    0.968063] usb usb5: configuration #1 chosen from 1 choice
[    0.968080] hub 5-0:1.0: USB hub found
[    0.968088] hub 5-0:1.0: 3 ports detected
[    0.968167] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> I=
RQ 18
[    0.968177] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.968183] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus =
number 6
[    0.968199] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe8fb000
[    1.028020] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.028022] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.028024] usb usb6: Product: OHCI Host Controller
[    1.028026] usb usb6: Manufacturer: Linux 2.6.31.8-0.1-vanilla ohci_hcd
[    1.028027] usb usb6: SerialNumber: 0000:00:13.1
[    1.028067] usb usb6: configuration #1 chosen from 1 choice
[    1.028085] hub 6-0:1.0: USB hub found
[    1.028092] hub 6-0:1.0: 3 ports detected
[    1.028170] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    1.028182] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.028188] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus =
number 7
[    1.028203] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe8fa000
[    1.084369] ata5: SATA link down (SStatus 0 SControl 300)
[    1.084451] ata4: SATA link down (SStatus 0 SControl 300)
[    1.084475] ata6: SATA link down (SStatus 0 SControl 300)
[    1.088020] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.088023] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.088024] usb usb7: Product: OHCI Host Controller
[    1.088026] usb usb7: Manufacturer: Linux 2.6.31.8-0.1-vanilla ohci_hcd
[    1.088027] usb usb7: SerialNumber: 0000:00:14.5
[    1.088062] usb usb7: configuration #1 chosen from 1 choice
[    1.088080] hub 7-0:1.0: USB hub found
[    1.088088] hub 7-0:1.0: 2 ports detected
[    1.088135] uhci_hcd: USB Universal Host Controller Interface driver
[    1.088179] Initializing USB Mass Storage driver...
[    1.088206] usbcore: registered new interface driver usb-storage
[    1.088208] USB Mass Storage support registered.
[    1.088232] usbcore: registered new interface driver libusual
[    1.088240] usbcore: registered new interface driver ums-alauda
[    1.088248] usbcore: registered new interface driver ums-cypress
[    1.088256] usbcore: registered new interface driver ums-datafab
[    1.088264] usbcore: registered new interface driver ums-freecom
[    1.088272] usbcore: registered new interface driver ums-isd200
[    1.088279] usbcore: registered new interface driver ums-jumpshot
[    1.088288] usbcore: registered new interface driver ums-karma
[    1.088296] usbcore: registered new interface driver ums-onetouch
[    1.088304] usbcore: registered new interface driver ums-sddr09
[    1.088312] usbcore: registered new interface driver ums-sddr55
[    1.088320] usbcore: registered new interface driver ums-usbat
[    1.088348] PNP: No PS/2 controller found. Probing ports directly.
[    1.088643] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.088649] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.088703] mice: PS/2 mouse device common for all mice
[    1.088781] rtc_cmos 00:03: RTC can wake from S4
[    1.088806] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.088829] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.088840] cpuidle: using governor ladder
[    1.088841] cpuidle: using governor menu
[    1.089026] usbcore: registered new interface driver hiddev
[    1.089038] usbcore: registered new interface driver usbhid
[    1.089039] usbhid: v2.6:USB HID core driver
[    1.089282] TCP cubic registered
[    1.089336] NET: Registered protocol family 10
[    1.089669] lo: Disabled Privacy Extensions
[    1.089896] lib80211: common routines for IEEE802.11 drivers
[    1.089898] lib80211_crypt: registered algorithm 'NULL'
[    1.089951] PM: Checking image partition /dev/disk/by-id/ata-WDC_WD1500H=
LFS-01G6U0_WD-WXJ608AR0429-part1
[    1.248032] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.248056] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.248074] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.250684] ata2.00: ATAPI: HL-DT-ST DVDRAM GH20NS15, IL00, max UDMA/100
[    1.250998] ata1.00: ATA-8: WDC WD1500HLFS-01G6U0, 04.04V01, max UDMA/133
[    1.251000] ata1.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.251100] ata3.00: ATA-8: WDC WD2002FYPS-01U1B0, 04.05G04, max UDMA/133
[    1.251102] ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2)
[    1.253943] ata3.00: configured for UDMA/133
[    1.254141] ata1.00: configured for UDMA/133
[    1.254512] ata2.00: configured for UDMA/100
[    1.268104] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1500HLFS-0 04=
=2E0 PQ: 0 ANSI: 5
[    1.268217] sd 0:0:0:0: [sda] 293046768 512-byte logical blocks: (150 GB=
/139 GiB)
[    1.268245] sd 0:0:0:0: [sda] Write Protect is off
[    1.268247] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.268261] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.268344]  sda: sda1 sda2 sda3
[    1.273572] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.382858] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH20NS15  IL=
00 PQ: 0 ANSI: 5
[    1.382976] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2002FYPS-0 04=
=2E0 PQ: 0 ANSI: 5
[    1.383067] sd 2:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[    1.383094] sd 2:0:0:0: [sdb] Write Protect is off
[    1.383096] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.383110] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.383176]  sdb:
[    1.408020] usb 3-2: new low speed USB device using ohci_hcd and address=
 2
[    1.434262]  sdb1
[    1.434413] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.434417] PM: Resume from disk failed.
[    1.434425] registered taskstats version 1
[    1.434527]   Magic number: 10:753:426
[    1.434584] rtc_cmos 00:03: setting system clock to 2010-01-18 10:26:24 =
UTC (1263810384)
[    1.434633] Freeing unused kernel memory: 1620k freed
[    1.434968] Write protecting the kernel read-only data: 7332k
[    1.459951] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -=
> IRQ 16
[    1.459975] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    1.460043] scsi6 : pata_atiixp
[    1.460094] scsi7 : pata_atiixp
[    1.461366] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq=
 14
[    1.461368] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq=
 15
[    1.577066] usb 3-2: New USB device found, idVendor=3D046d, idProduct=3D=
c047
[    1.577069] usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    1.577071] usb 3-2: Product: USB Optical Mouse
[    1.577072] usb 3-2: Manufacturer: Logitech
[    1.577122] usb 3-2: configuration #1 chosen from 1 choice
[    1.586202] input: Logitech USB Optical Mouse as /devices/pci0000:00/000=
0:00:12.0/usb3/3-2/3-2:1.0/input/input0
[    1.586244] generic-usb 0003:046D:C047.0001: input,hidraw0: USB HID v1.1=
0 Mouse [Logitech USB Optical Mouse] on usb-0000:00:12.0-2/input0
[    1.696021] usb 2-5: new high speed USB device using ehci_hcd and addres=
s 2
[    1.792637] Uniform Multi-Platform E-IDE driver
[    1.798616] processor LNXCPU:00: registered as cooling_device0
[    1.798620] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.798975] processor LNXCPU:01: registered as cooling_device1
[    1.799316] processor LNXCPU:02: registered as cooling_device2
[    1.799658] processor LNXCPU:03: registered as cooling_device3
[    1.803696] udev: starting version 146
[    1.830403] usb 2-5: New USB device found, idVendor=3D05e3, idProduct=3D=
0608
[    1.830407] usb 2-5: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[    1.830409] usb 2-5: Product: USB2.0 Hub
[    1.830471] usb 2-5: configuration #1 chosen from 1 choice
[    1.830795] hub 2-5:1.0: USB hub found
[    1.831025] hub 2-5:1.0: 4 ports detected
[    2.030465] PM: Marking nosave pages: 000000000009e000 - 0000000000100000
[    2.030469] PM: Marking nosave pages: 00000000cff90000 - 0000000100000000
[    2.030962] PM: Marking nosave pages: 0000000020000000 - 0000000024000000
[    2.031191] PM: Basic memory bitmaps created
[    2.062474] PM: Basic memory bitmaps freed
[    2.068131] PM: Starting manual resume from disk
[    2.068134] PM: Resume from partition 259:524288
[    2.068135] PM: Checking hibernation image.
[    2.068245] PM: Resume from disk failed.
[    2.093020] usb 4-2: new low speed USB device using ohci_hcd and address=
 2
[    2.110443] EXT4-fs (sda2): barriers enabled
[    2.113161] kjournald2 starting: pid 320, dev sda2:8, commit interval 5 =
seconds
[    2.121789] EXT4-fs (sda2): internal journal on sda2:8
[    2.121793] EXT4-fs (sda2): delayed allocation enabled
[    2.121795] EXT4-fs: file extents enabled
[    2.121842] EXT4-fs: mballoc enabled
[    2.121852] EXT4-fs (sda2): mounted filesystem with ordered data mode
[    2.263052] usb 4-2: New USB device found, idVendor=3D046a, idProduct=3D=
0001
[    2.263055] usb 4-2: New USB device strings: Mfr=3D1, Product=3D0, Seria=
lNumber=3D0
[    2.263057] usb 4-2: Manufacturer: Cherry GmbH
[    2.263119] usb 4-2: configuration #1 chosen from 1 choice
[    2.272205] input: Cherry GmbH as /devices/pci0000:00/0000:00:12.1/usb4/=
4-2/4-2:1.0/input/input1
[    2.272244] generic-usb 0003:046A:0001.0002: input,hidraw1: USB HID v1.1=
1 Keyboard [Cherry GmbH] on usb-0000:00:12.1-2/input0
[    2.533020] usb 4-3: new low speed USB device using ohci_hcd and address=
 3
[    2.711063] usb 4-3: New USB device found, idVendor=3D051d, idProduct=3D=
0002
[    2.711067] usb 4-3: New USB device strings: Mfr=3D3, Product=3D1, Seria=
lNumber=3D2
[    2.711069] usb 4-3: Product: Smart-UPS 1500 FW:653.13.I USB FW:7.3
[    2.711071] usb 4-3: Manufacturer: American Power Conversion
[    2.711072] usb 4-3: SerialNumber: AS0717131457
[    2.711129] usb 4-3: configuration #1 chosen from 1 choice
[    4.226127] generic-usb 0003:051D:0002.0003: hiddev0,hidraw2: USB HID v1=
=2E10 Device [American Power Conversion Smart-UPS 1500 FW:653.13.I USB FW:7=
=2E3] on usb-0000:00:12.1-3/input0
[    4.971898] udev: starting version 146
[    5.042863] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.042883] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    5.042901] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    5.043867] ACPI: WMI: Mapper loaded
[    5.044593] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input2
[    5.044613] ACPI: Power Button [PWRF]
[    5.044656] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input3
[    5.044675] ACPI: Power Button [PWRB]
[    5.143383] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    5.143386] Uniform CD-ROM driver Revision: 3.20
[    5.143455] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.175673] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    5.183230] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with =
ACPI region SOR1 [0xb00-0xb0f]
[    5.183315] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[    5.197954] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.197971] r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ =
18
[    5.198035] r8169 0000:02:00.0: setting latency timer to 64
[    5.198066]   alloc irq_desc for 27 on node 0
[    5.198067]   alloc kstat_irqs on node 0
[    5.198079] r8169 0000:02:00.0: irq 27 for MSI/MSI-X
[    5.198509] eth0: RTL8168d/8111d at 0xffffc90011a90000, 90:e6:ba:c9:f4:c=
8, XID 283000c0 IRQ 27
[    5.275780] EDAC MC: Ver: 2.1.0 Dec 18 2009
[    5.366829] IT8712 SuperIO detected.
[    5.367167] parport_pc 00:06: reported by Plug and Play ACPI
[    5.367232] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRI=
STATE,COMPAT,ECP,DMA]
[    5.372892]   alloc irq_desc for 23 on node 0
[    5.372894]   alloc kstat_irqs on node 0
[    5.372901] ohci1394 0000:03:08.0: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    5.388663] EDAC amd64_edac:  Ver: 3.2.0 Dec 18 2009
[    5.388828] EDAC amd64: This node reports that Memory ECC is currently d=
isabled.
[    5.388831] EDAC amd64: bit 0x400000 in register F3x44 of the MISC_CONTR=
OL device (0000:00:18.3) should be enabled
[    5.388834] EDAC amd64: WARNING: ECC is NOT currently enabled by the BIO=
S. Module will NOT be loaded.
[    5.388835]     Either Enable ECC in the BIOS, or use the 'ecc_enable_ov=
erride' parameter.
[    5.388836]     Might be a BIOS bug, if BIOS says ECC is enabled
[    5.388837]     Use of the override can cause unknown side effects.
[    5.388847] amd64_edac: probe of 0000:00:18.2 failed with error -22
[    5.430050] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[23]  MMIO=3D=
[febff800-febfffff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
[    5.510135] ppdev: user-space parallel port driver
[    5.562242] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> =
IRQ 16
[    5.643905] ALSA /usr/src/packages/BUILD/kernel-vanilla-2.6.31.8/linux-2=
=2E6.31/sound/pci/hda/hda_codec.c:3857: autoconfig: line_outs=3D4 (0x1c/0x1=
9/0x22/0x23/0x0)
[    5.643909] ALSA /usr/src/packages/BUILD/kernel-vanilla-2.6.31.8/linux-2=
=2E6.31/sound/pci/hda/hda_codec.c:3861:    speaker_outs=3D0 (0x0/0x0/0x0/0x=
0/0x0)
[    5.643913] ALSA /usr/src/packages/BUILD/kernel-vanilla-2.6.31.8/linux-2=
=2E6.31/sound/pci/hda/hda_codec.c:3865:    hp_outs=3D1 (0x1d/0x0/0x0/0x0/0x=
0)
[    5.643916] ALSA /usr/src/packages/BUILD/kernel-vanilla-2.6.31.8/linux-2=
=2E6.31/sound/pci/hda/hda_codec.c:3866:    mono: mono_out=3D0x0
[    5.643919] ALSA /usr/src/packages/BUILD/kernel-vanilla-2.6.31.8/linux-2=
=2E6.31/sound/pci/hda/hda_codec.c:3869:    dig-out=3D0x20/0x21
[    5.643921] ALSA /usr/src/packages/BUILD/kernel-vanilla-2.6.31.8/linux-2=
=2E6.31/sound/pci/hda/hda_codec.c:3877:    inputs: mic=3D0x1a, fmic=3D0x1e,=
 line=3D0x1b, fline=3D0x0, cd=3D0x0, aux=3D0x0
[    5.645999] HDA Intel 0000:01:00.1: PCI INT B -> GSI 19 (level, low) -> =
IRQ 19
[    5.646030] HDA Intel 0000:01:00.1: setting latency timer to 64
[    5.842169] Adding 8393920k swap on /dev/sda1.  Priority:-1 extents:1 ac=
ross:8393920k=20
[    6.046847] device-mapper: uevent: version 1.0.3
[    6.046923] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised:=
 dm-devel@redhat.com
[    6.283334] loop: module loaded
[    6.291875] EXT4-fs (sda3): barriers enabled
[    6.292244] kjournald2 starting: pid 756, dev sda3:8, commit interval 5 =
seconds
[    6.299111] EXT4-fs (sda3): internal journal on sda3:8
[    6.299114] EXT4-fs (sda3): delayed allocation enabled
[    6.299117] EXT4-fs: file extents enabled
[    6.308987] EXT4-fs: mballoc enabled
[    6.308998] EXT4-fs (sda3): mounted filesystem with ordered data mode
[    6.414812] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[    6.415239] SGI XFS Quota Management subsystem
[    6.437009] XFS mounting filesystem sdb1
[    6.593332] Ending clean XFS mount for filesystem: sdb1
[    6.708140] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[1e00000000008c=
00]
[    6.786157] fuse init (API version 7.12)
[    8.647097] powernow-k8: Found 1 AMD Phenom(tm) II X4 925 Processor proc=
essors (4 cpu cores) (version 2.20.00)
[    8.647141] powernow-k8:    0 : pstate 0 (2800 MHz)
[    8.647144] powernow-k8:    1 : pstate 1 (2100 MHz)
[    8.647146] powernow-k8:    2 : pstate 2 (1600 MHz)
[    8.647149] powernow-k8:    3 : pstate 3 (800 MHz)
[    9.551024] [drm] Initialized drm 1.1.0 20060810
[    9.566972] pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.566991] pci 0000:01:00.0: setting latency timer to 64
[    9.567261] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:00.0 on=
 minor 0
[    9.707903] [drm] Setting GART location based on new memory map
[    9.722890] [drm] Loading RV710 PFP Microcode
[    9.722901] [drm] Loading RV710 CP Microcode
[    9.737813] [drm] Resetting GPU
[    9.737870] [drm] writeback test succeeded in 1 usecs
[   10.267031] r8169: eth0: link up
[   10.267048] r8169: eth0: link up
[   11.252552] RPC: Registered udp transport module.
[   11.252556] RPC: Registered tcp transport module.
[   11.297919] Slow work thread pool: Starting up
[   11.298337] Slow work thread pool: Ready
[   11.298419] FS-Cache: Loaded
[   11.357982] FS-Cache: Netfs 'nfs' registered for caching
[   12.650405] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[   13.298721] [drm] Resetting GPU
[   21.036033] eth0: no IPv6 routers present
[  146.826813] [drm] Loading RV710 PFP Microcode
[  146.826842] [drm] Loading RV710 CP Microcode
[  146.841772] [drm] Resetting GPU
[  154.130762] CPU0 attaching NULL sched-domain.
[  154.130774] CPU1 attaching NULL sched-domain.
[  154.130780] CPU2 attaching NULL sched-domain.
[  154.130786] CPU3 attaching NULL sched-domain.
[  154.148532] CPU0 attaching sched-domain:
[  154.148543]  domain 0: span 0-3 level MC
[  154.148550]   groups: 0 1 2 3
[  154.148568] CPU1 attaching sched-domain:
[  154.148573]  domain 0: span 0-3 level MC
[  154.148579]   groups: 1 2 3 0
[  154.148592] CPU2 attaching sched-domain:
[  154.148597]  domain 0: span 0-3 level MC
[  154.148602]   groups: 2 3 0 1
[  154.148615] CPU3 attaching sched-domain:
[  154.148619]  domain 0: span 0-3 level MC
[  154.148624]   groups: 3 0 1 2
[  195.325191] ISO 9660 Extensions: Microsoft Joliet Level 3
[  195.343931] ISO 9660 Extensions: RRIP_1991A
[79634.944656] ata1: exception Emask 0x10 SAct 0x0 SErr 0x90202 action 0xe =
frozen
[79634.944676] ata1: irq_stat 0x00400000, PHY RDY changed
[79634.944691] ata1: SError: { RecovComm Persist PHYRdyChg 10B8B }
[79634.944708] ata1: hard resetting link
[79634.944735] ata3: exception Emask 0x50 SAct 0x0 SErr 0x90a02 action 0xe =
frozen
[79634.944748] ata3: irq_stat 0x00400000, PHY RDY changed
[79634.944760] ata3: SError: { RecovComm Persist HostInt PHYRdyChg 10B8B }
[79634.944774] ata3: hard resetting link
[79635.836086] ata1: SATA link down (SStatus 0 SControl 300)
[79635.861391] ata1: hard resetting link
[79639.313061] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[79639.341815] ata1.00: configured for UDMA/133
[79639.341850] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[79639.341862] ata1: irq_stat 0x00400040, connection status changed
[79639.349060] ata1.00: configured for UDMA/133
[79639.349078] ata1: EH complete
[79641.656076] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[79641.688909] ata3.00: configured for UDMA/133
[79641.688929] ata3: EH complete
[79644.477353] ata6: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x=
e frozen
[79644.477372] ata6: irq_stat 0x00400040, connection status changed
[79644.477387] ata6: SError: { PHYRdyChg CommWake 10B8B DevExch }
[79644.477406] ata6: hard resetting link
[79645.364077] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[79645.407969] ata6.00: ATA-7: ST3320620NS, 3.AEG, max UDMA/133
[79645.407986] ata6.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[79645.466302] ata6.00: configured for UDMA/133
[79645.466329] ata6: EH complete
[79645.466522] scsi 5:0:0:0: Direct-Access     ATA      ST3320620NS      3.=
AE PQ: 0 ANSI: 5
[79645.466859] sd 5:0:0:0: Attached scsi generic sg3 type 0
[79645.467379] sd 5:0:0:0: [sdc] 625142448 512-byte logical blocks: (320 GB=
/298 GiB)
[79645.467529] sd 5:0:0:0: [sdc] Write Protect is off
[79645.467542] sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[79645.467593] sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[79645.467898]  sdc: sdc1 sdc2 sdc3
[79645.506961] sd 5:0:0:0: [sdc] Attached SCSI disk
[80391.082414] REISERFS (device sdc2): found reiserfs format "3.6" with sta=
ndard journal
[80391.082453] REISERFS (device sdc2): using ordered data mode
[80391.089544] REISERFS (device sdc2): journal params: device sdc2, size 81=
92, journal first block 18, max trans len 1024, max batch 900, max commit a=
ge 30, max trans age 30
[80391.090610] REISERFS (device sdc2): checking transaction log (sdc2)
[80391.523508] REISERFS (device sdc2): Using r5 hash to sort names
[80391.523581] REISERFS (device sdc2): Created .reiserfs_priv - reserved fo=
r xattr storage.
[80400.398697] REISERFS (device sdc2): found reiserfs format "3.6" with sta=
ndard journal
[80400.398742] REISERFS (device sdc2): using ordered data mode
[80400.402876] REISERFS (device sdc2): journal params: device sdc2, size 81=
92, journal first block 18, max trans len 1024, max batch 900, max commit a=
ge 30, max trans age 30
[80400.403935] REISERFS (device sdc2): checking transaction log (sdc2)
[80400.411892] REISERFS (device sdc2): Using r5 hash to sort names
[80765.236856] EXT4-fs (sdc3): barriers enabled
[80765.251127] kjournald2 starting: pid 14574, dev sdc3:8, commit interval =
5 seconds
[80765.251586] EXT4-fs (sdc3): internal journal on sdc3:8
[80765.251607] EXT4-fs (sdc3): delayed allocation enabled
[80765.251620] EXT4-fs: file extents enabled
[80765.341889] EXT4-fs: mballoc enabled
[80765.341931] EXT4-fs (sdc3): mounted filesystem with ordered data mode
[80808.306719] EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
[80808.306736] EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits=
, 0 breaks, 0 lost
[80808.306752] EXT4-fs: mballoc: 0 generated and it took 0
[80808.306761] EXT4-fs: mballoc: 0 preallocated, 0 discarded
[80835.571895] EXT4-fs (sdc3): barriers enabled
[80835.586163] kjournald2 starting: pid 14587, dev sdc3:8, commit interval =
5 seconds
[80835.586582] EXT4-fs (sdc3): internal journal on sdc3:8
[80835.586603] EXT4-fs (sdc3): delayed allocation enabled
[80835.586616] EXT4-fs: file extents enabled
[80835.676777] EXT4-fs: mballoc enabled
[80835.676818] EXT4-fs (sdc3): mounted filesystem with ordered data mode
[80852.449414] BUG: unable to handle kernel NULL pointer dereference at (nu=
ll)
[80852.449439] IP: [<ffffffff81274ac0>] memcpy_c+0x10/0x20
[80852.449462] PGD 17cdae067 PUD 2188dc067 PMD 0=20
[80852.449477] Oops: 0000 [#1] SMP=20
[80852.449488] last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host5/=
target5:0:0/5:0:0:0/block/sdc/sdc3/start
[80852.449505] CPU 3=20
[80852.449512] Modules linked in: reiserfs nls_utf8 snd_pcm_oss snd_mixer_o=
ss snd_seq snd_seq_device edd nfs lockd fscache nfs_acl auth_rpcgss sunrpc =
radeon drm cpufreq_conservative cpufreq_userspace cpufreq_powersave powerno=
w_k8 fuse xfs exportfs loop dm_mod snd_hda_codec_atihdmi snd_hda_codec_via =
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm ppdev snd_timer amd64_edac_mo=
d ohci1394 parport_pc snd parport edac_core snd_page_alloc ieee1394 r8169 i=
2c_piix4 pcspkr sr_mod cdrom serio_raw asus_atk0110 button wmi sg ext4 jbd2=
 crc16 fan processor ide_pci_generic atiixp ide_core ata_generic pata_marve=
ll pata_atiixp thermal thermal_sys
[80852.449677] Pid: 14593, comm: mount Not tainted 2.6.31.8-0.1-vanilla #1 =
System Product Name
[80852.449692] RIP: 0010:[<ffffffff81274ac0>]  [<ffffffff81274ac0>] memcpy_=
c+0x10/0x20
[80852.449712] RSP: 0018:ffff880225053c20  EFLAGS: 00010202
[80852.449722] RAX: ffff880204d847e0 RBX: ffff880225053ce8 RCX: 00000000000=
00001
[80852.449734] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff880204d=
847e0
[80852.449746] RBP: ffff880225053c68 R08: fffffffffffffffa R09: ffff8801310=
61007
[80852.449758] R10: 000000000000002c R11: 0000000000000202 R12: ffff880204d=
847e0
[80852.449770] R13: ffff880225053ce4 R14: 0000000000000000 R15: 00000000fff=
fffea
[80852.449783] FS:  00007f6ba3d1b7d0(0000) GS:ffff880028088000(0000) knlGS:=
00000000f6937970
[80852.449797] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[80852.449808] CR2: 0000000000000000 CR3: 00000001985f7000 CR4: 00000000000=
006e0
[80852.449820] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[80852.449832] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[80852.449844] Process mount (pid: 14593, threadinfo ffff880225052000, task=
 ffff88019814a440)
[80852.449857] Stack:
[80852.449863]  ffffffff812757ec ffff880225053ce8 000000003b3945e5 ffff8801=
7c0fbc00
[80852.449878] <0> ffff880224580c00 ffff880131061000 ffff880225053cd0 ffff8=
8017c0fbc00
[80852.449897] <0> ffff880225053ce8 ffff880225053c88 ffffffff812758ee ffff8=
80131061000
[80852.449917] Call Trace:
[80852.449929]  [<ffffffff812757ec>] ? match_number+0x6c/0xd0
[80852.449945]  [<ffffffff812758ee>] match_int+0x1e/0x40
[80852.449992]  [<ffffffffa00b6d7b>] parse_options+0x1ab/0x8b0 [ext4]
[80852.450010]  [<ffffffff8110603b>] ? __filemap_fdatawrite_range+0x5b/0x80
[80852.450057]  [<ffffffffa00be436>] ext4_remount+0xe6/0x4d0 [ext4]
[80852.450073]  [<ffffffff81156bea>] do_remount_sb+0x7a/0x180
[80852.450086]  [<ffffffff81172ffe>] do_remount+0x14e/0x170
[80852.450098]  [<ffffffff811761e2>] do_mount+0x1f2/0x240
[80852.450110]  [<ffffffff811732d2>] ? copy_mount_options+0x102/0x1b0
[80852.450123]  [<ffffffff811762ce>] sys_mount+0x9e/0x100
[80852.450138]  [<ffffffff8100c602>] system_call_fastpath+0x16/0x1b
[80852.450148] Code: 00 48 3b 42 20 73 07 48 8b 50 f9 31 c0 c3 31 d2 48 c7 =
c0 f2 ff ff ff c3 90 90 90 48 89 f8 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 =
<f3> a4 c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 eb de f8 89 d1=20
[80852.450247] RIP  [<ffffffff81274ac0>] memcpy_c+0x10/0x20
[80852.450261]  RSP <ffff880225053c20>
[80852.450269] CR2: 0000000000000000
[80852.450279] ---[ end trace af3c39f272f308bf ]---
[80852.450287] ------------[ cut here ]------------
[80852.450301] WARNING: at /usr/src/packages/BUILD/kernel-vanilla-2.6.31.8/=
linux-2.6.31/kernel/exit.c:895 do_exit+0x36a/0x370()
[80852.450317] Hardware name: System Product Name
[80852.450325] Modules linked in: reiserfs nls_utf8 snd_pcm_oss snd_mixer_o=
ss snd_seq snd_seq_device edd nfs lockd fscache nfs_acl auth_rpcgss sunrpc =
radeon drm cpufreq_conservative cpufreq_userspace cpufreq_powersave powerno=
w_k8 fuse xfs exportfs loop dm_mod snd_hda_codec_atihdmi snd_hda_codec_via =
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm ppdev snd_timer amd64_edac_mo=
d ohci1394 parport_pc snd parport edac_core snd_page_alloc ieee1394 r8169 i=
2c_piix4 pcspkr sr_mod cdrom serio_raw asus_atk0110 button wmi sg ext4 jbd2=
 crc16 fan processor ide_pci_generic atiixp ide_core ata_generic pata_marve=
ll pata_atiixp thermal thermal_sys
[80852.450477] Pid: 14593, comm: mount Tainted: G      D    2.6.31.8-0.1-va=
nilla #1
[80852.450489] Call Trace:
[80852.450501]  [<ffffffff8106c450>] warn_slowpath_common+0x80/0xd0
[80852.450514]  [<ffffffff8106c4c2>] warn_slowpath_null+0x22/0x40
[80852.450528]  [<ffffffff810718ca>] do_exit+0x36a/0x370
[80852.450540]  [<ffffffff8106c0f1>] ? print_oops_end_marker+0x31/0x50
[80852.450556]  [<ffffffff81512893>] oops_end+0xd3/0x130
[80852.450570]  [<ffffffff810433ab>] no_context+0x10b/0x1a0
[80852.450583]  [<ffffffff810435bd>] __bad_area_nosemaphore+0x17d/0x230
[80852.450597]  [<ffffffff81131dfd>] ? page_add_new_anon_rmap+0x6d/0x80
[80852.450613]  [<ffffffff81039646>] ? default_spin_lock_flags+0x26/0x50
[80852.450627]  [<ffffffff8126ffd9>] ? __up_read+0xa9/0xf0
[80852.450640]  [<ffffffff8104370d>] __bad_area+0x5d/0x90
[80852.450653]  [<ffffffff81043761>] bad_area+0x21/0x40
[80852.450664]  [<ffffffff815149d9>] do_page_fault+0x399/0x3b0
[80852.450678]  [<ffffffff81511985>] page_fault+0x25/0x30
[80852.450692]  [<ffffffff81274ac0>] ? memcpy_c+0x10/0x20
[80852.450705]  [<ffffffff812757ec>] ? match_number+0x6c/0xd0
[80852.450718]  [<ffffffff812758ee>] match_int+0x1e/0x40
[80852.450758]  [<ffffffffa00b6d7b>] parse_options+0x1ab/0x8b0 [ext4]
[80852.450774]  [<ffffffff8110603b>] ? __filemap_fdatawrite_range+0x5b/0x80
[80852.450816]  [<ffffffffa00be436>] ext4_remount+0xe6/0x4d0 [ext4]
[80852.450831]  [<ffffffff81156bea>] do_remount_sb+0x7a/0x180
[80852.450842]  [<ffffffff81172ffe>] do_remount+0x14e/0x170
[80852.450854]  [<ffffffff811761e2>] do_mount+0x1f2/0x240
[80852.450866]  [<ffffffff811732d2>] ? copy_mount_options+0x102/0x1b0
[80852.450879]  [<ffffffff811762ce>] sys_mount+0x9e/0x100
[80852.450892]  [<ffffffff8100c602>] system_call_fastpath+0x16/0x1b
[80852.450903] ---[ end trace af3c39f272f308c0 ]---
[80853.547291] hda-intel: IRQ timing workaround is activated for card #1. S=
uggest a bigger bdl_pos_adj.

--Boundary-01=_wOVWLWnvPFxF0Fq--

--nextPart6486238.EUvpQ097YS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktZU7AACgkQzhSR9xwSCbQJbACfQ13Je2af0hFhwTocA7tT/I7B
/6IAn13fZFAglkV4ch4aSbpPs+dfB2vy
=MfmP
-----END PGP SIGNATURE-----

--nextPart6486238.EUvpQ097YS--
