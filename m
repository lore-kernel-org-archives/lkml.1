Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbYHPAKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbYHPAKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 20:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYHPAKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 20:10:42 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53033 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbYHPAKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 20:10:38 -0400
Date: Fri, 15 Aug 2008 08:58:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       ak@linux.intel.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Message-Id: <20080815085836.67e420f1.randy.dunlap@oracle.com>
In-Reply-To: <3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com>
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>
	<20080814083828.d10e126d.randy.dunlap@oracle.com>
	<3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Fri__15_Aug_2008_08_58_36_-0700_YO_48Dvbno2.TL36"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Fri__15_Aug_2008_08_58_36_-0700_YO_48Dvbno2.TL36
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 Aug 2008 13:27:00 +0200 Kay Sievers wrote:

> On Thu, Aug 14, 2008 at 17:38, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > calling  param_sysfs_init+0x0/0x1e7
> > ------------[ cut here ]------------
> > WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
> > sysfs: duplicate filename 'acpi' can not be created
> 
> Hi Randy,
> care to add a printk to the module sysfs setup, and post dmesg again?
> 
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -603,6 +603,8 @@ static void __init param_sysfs_builtin(void)
>  		}
>  		name_len = dot - kp->name;
> 
> +		printk("XXX adding modparam:'%s' %i (%p)\n", kp->name, i, kp);
> +
>   		/* new kbuild_modname? */
>  		if (strlen(modname) != name_len
>  		    || strncmp(modname, kp->name, name_len) != 0) {
> 
> I might show the order of registering the /sys/modules/ directory, and
> if there is possibly another "acpi" section, which tries to add
> parameter names.

Done.  Full boot log is attached.

Extract is:

XXX adding modparam:'acpi.power_nocheck' 34 (ffffffff806a4cf0)
XXX adding modparam:'processor.latency_factor' 35 (ffffffff806a4d18)
XXX adding modparam:'processor.nocst' 36 (ffffffff806a4d40)
XXX adding modparam:'processor.max_cstate' 37 (ffffffff806a4d68)
XXX adding modparam:'processor.ignore_ppc' 38 (ffffffff806a4d90)
XXX adding modparam:'thermal.psv' 39 (ffffffff806a4db8)
XXX adding modparam:'thermal.off' 40 (ffffffff806a4de0)
XXX adding modparam:'thermal.nocrt' 41 (ffffffff806a4e08)
XXX adding modparam:'thermal.tzp' 42 (ffffffff806a4e30)
XXX adding modparam:'thermal.crt' 43 (ffffffff806a4e58)
XXX adding modparam:'thermal.act' 44 (ffffffff806a4e80)
XXX adding modparam:'acpi.acpica_version' 45 (ffffffff806a4ea8)
XXX adding modparam:'keyboard.brl_nbchords' 46 (ffffffff806a4ed0)
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
sysfs: duplicate filename 'acpi' can not be created


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/

--Multipart=_Fri__15_Aug_2008_08_58_36_-0700_YO_48Dvbno2.TL36
Content-Type: text/x-log;
 name="netcon-4846.log"
Content-Disposition: attachment;
 filename="netcon-4846.log"
Content-Transfer-Encoding: quoted-printable

Linux version 2.6.27-rc3-next-20080814 (root@ca-ostest293.us.oracle.com) (g=
cc version 4.1.1 20070105 (Red Hat 4.1.1-52)) #1 SMP Fri Aug 15 08:20:32 PD=
T 2008
Command line: root=3DLABEL=3D/ selinux=3D0 console=3Dtty0 netconsole=3D5484=
6@139.185.50.77/eth0,54846@139.185.50.76/00:18:FE:34:1C:3D debug ignore_log=
level 3 kex
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe50000 (usable)
 BIOS-e820: 000000007fe50000 - 000000007fe58000 (ACPI data)
 BIOS-e820: 000000007fe58000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000027ffff000 (usable)
debug: ignoring loglevel setting.
last_pfn =3D 0x27ffff max_arch_pfn =3D 0x3ffffffff
last_pfn =3D 0x7fe50 max_arch_pfn =3D 0x3ffffffff
init_memory_mapping
 0000000000 - 007fe00000 page 2M
 007fe00000 - 007fe50000 page 4k
kernel direct mapping tables up to 7fe50000 @ 8000-c000
last_map_addr: 7fe50000 end: 7fe50000
init_memory_mapping
 0100000000 - 027fe00000 page 2M
 027fe00000 - 027ffff000 page 4k
kernel direct mapping tables up to 27ffff000 @ a000-16000
last_map_addr: 27ffff000 end: 27ffff000
RAMDISK: 7fd04000 - 7fe4f68d
DMI 2.3 present.
ACPI: RSDP 000F4F00, 0024 (r2 HP    )
ACPI: XSDT 7FE50780, 005C (r1 HP     A08             2   =D2=04     162E)
ACPI: FACP 7FE50800, 00F4 (r3 HP     A08             2   =D2=04     162E)
ACPI: DSDT 7FE50900, 3F75 (r1 HP         DSDT        1 INTL 20030228)
ACPI: FACS 7FE50100, 0040
ACPI: SPCR 7FE50140, 0050 (r1 HP     SPCRRBSU        1   =D2=04     162E)
ACPI: MCFG 7FE501C0, 003C (r1 HP     ProLiant        1             0)
ACPI: HPET 7FE50200, 0038 (r1 HP     A08             2   =D2=04     162E)
ACPI: SPMI 7FE50240, 0040 (r5 HP     ProLiant        1   =D2=04     162E)
ACPI: APIC 7FE50280, 00DE (r1 HP     00000083        2             0)
ACPI: SRAT 7FE50380, 0110 (r1 AMD    HAMMER          1 AMD         1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 0 PXM 0 100000000-180000000
SRAT: Node 1 PXM 1 180000000-280000000
NUMA: Allocated memnodemap from 11000 - 16080
NUMA: Using 20 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000180000000
  NODE_DATA [0000000000001000 - 0000000000004fff]
  bootmap [0000000000017000 -  0000000000046fff] pages 30
(8 early reservations) =3D=3D> bootmem [0000000000 - 0180000000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 00000=
01000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [0000006000 - 00000=
08000]
  #2 [0000200000 - 000088c750]    TEXT DATA BSS =3D=3D> [0000200000 - 00008=
8c750]
  #3 [007fd04000 - 007fe4f68d]          RAMDISK =3D=3D> [007fd04000 - 007fe=
4f68d]
  #4 [000009f400 - 0000100000]    BIOS reserved =3D=3D> [000009f400 - 00001=
00000]
  #5 [0000008000 - 000000a000]          PGTABLE =3D=3D> [0000008000 - 00000=
0a000]
  #6 [000000a000 - 0000011000]          PGTABLE =3D=3D> [000000a000 - 00000=
11000]
  #7 [0000011000 - 0000016080]       MEMNODEMAP =3D=3D> [0000011000 - 00000=
16080]
Bootmem setup node 1 0000000180000000-000000027ffff000
  NODE_DATA [0000000180000000 - 0000000180003fff]
  bootmap [0000000180004000 -  0000000180023fff] pages 20
(8 early reservations) =3D=3D> bootmem [0180000000 - 027ffff000]
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0000200000 - 000088c750]    TEXT DATA BSS
  #3 [007fd04000 - 007fe4f68d]          RAMDISK
  #4 [000009f400 - 0000100000]    BIOS reserved
  #5 [0000008000 - 000000a000]          PGTABLE
  #6 [000000a000 - 0000011000]          PGTABLE
  #7 [0000011000 - 0000016080]       MEMNODEMAP
found SMP MP-table at [ffff8800000f4f80] 000f4f80
 [ffffe20000000000-ffffe200053fffff] PMD -> [ffff880028200000-ffff88002b9ff=
fff] on node 0
 [ffffe20005400000-ffffe20008bfffff] PMD -> [ffff880180200000-ffff8801839ff=
fff] on node 1
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0027ffff
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000001 -> 0x0000009f
    0: 0x00000100 -> 0x0007fe50
    0: 0x00100000 -> 0x00180000
    1: 0x00180000 -> 0x0027ffff
On node 0 totalpages: 1048046
  DMA zone: 2151 pages, LIFO batch:0
  DMA32 zone: 505480 pages, LIFO batch:31
  Normal zone: 517120 pages, LIFO batch:31
On node 1 totalpages: 1048575
  Normal zone: 1034239 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xf7df0000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xf7df0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfdef0000] gsi_base[38])
IOAPIC[1]: apic_id 9, version 0, address 0xfdef0000, GSI 38-61
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0x10228201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 000000007fe50000 - 000000007fe58000
PM: Registered nosave memory: 000000007fe58000 - 0000000080000000
PM: Registered nosave memory: 0000000080000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000ffc00000
PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
PERCPU: Allocating 47784 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 2
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 2058990
Policy zone: Normal
Kernel command line: root=3DLABEL=3D/ selinux=3D0 console=3Dtty0 netconsole=
=3D54846@139.185.50.77/eth0,54846@139.185.50.76/00:18:FE:34:1C:3D debug ign=
ore_loglevel 3 kex
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Detected 1004.627 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
Node 0: aperture @ c000000 size 64 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Memory: 8197540k/10485756k available (3463k kernel code, 188944k reserved, =
1822k data, 392k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D2
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. =
2009.25 BogoMIPS (lpj=3D4018508)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
ACPI: Core revision 20080729
Setting APIC routing to flat
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Using local APIC timer interrupts.
APIC timer calibration result 12557864
Detected 12.557 MHz APIC timer.
Booting processor 1/2 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2009.35 BogoMIPS (lpj=3D40=
18718)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 2/1 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 2009.45 BogoMIPS (lpj=3D40=
18915)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 3/3 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 2009.36 BogoMIPS (lpj=3D40=
18734)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU3: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Brought up 4 CPUs
Total of 4 processors activated (8037.43 BogoMIPS).
khelper used greatest stack depth: 6040 bytes left
net_namespace: 592 bytes
NET: Registered protocol family 16
node 0 link 1: io port [1000, 3fff]
node 1 link 2: io port [4000, ffff]
TOM: 0000000080000000 aka 2048M
node 0 link 1: mmio [e8000000, fddfffff]
node 1 link 2: mmio [fde00000, fdffffff]
node 0 link 1: mmio [80000000, 83ffffff]
node 1 link 2: mmio [84000000, 8fffffff]
node 0 link 1: mmio [a0000, bffff]
TOM2: 0000000280000000 aka 10240M
bus: [00,3f] on node 0 link 1
bus: 00 index 0 io port: [0, 3fff]
bus: 00 index 1 mmio: [90000000, fddfffff]
bus: 00 index 2 mmio: [80000000, 83ffffff]
bus: 00 index 3 mmio: [a0000, bffff]
bus: 00 index 4 mmio: [fe000000, ffffffff]
bus: 00 index 5 mmio: [280000000, fcffffffff]
bus: [40,ff] on node 1 link 2
bus: 40 index 0 io port: [4000, ffff]
bus: 40 index 1 mmio: [fde00000, fdffffff]
bus: 40 index 2 mmio: [84000000, 8fffffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base 80000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
PCI: HP ProLiant BL685c G1 detected, enabling pci=3Dbfsort.
XXX adding modparam:'mtrr.show' 0 (ffffffff806a47a0)
XXX adding modparam:'acpi_cpufreq.acpi_pstate_strict' 1 (ffffffff806a47c8)
XXX adding modparam:'printk.time' 2 (ffffffff806a47f0)
XXX adding modparam:'spurious.irqfixup' 3 (ffffffff806a4818)
XXX adding modparam:'spurious.noirqdebug' 4 (ffffffff806a4840)
XXX adding modparam:'rcuclassic.qlowmark' 5 (ffffffff806a4868)
XXX adding modparam:'rcuclassic.qhimark' 6 (ffffffff806a4890)
XXX adding modparam:'rcuclassic.blimit' 7 (ffffffff806a48b8)
XXX adding modparam:'nfs.enable_ino64' 8 (ffffffff806a48e0)
XXX adding modparam:'lockd.nsm_use_hostnames' 9 (ffffffff806a4908)
XXX adding modparam:'lockd.nlm_tcpport' 10 (ffffffff806a4930)
XXX adding modparam:'lockd.nlm_udpport' 11 (ffffffff806a4958)
XXX adding modparam:'lockd.nlm_timeout' 12 (ffffffff806a4980)
XXX adding modparam:'lockd.nlm_grace_period' 13 (ffffffff806a49a8)
XXX adding modparam:'rivafb.strictmode' 14 (ffffffff806a49d0)
XXX adding modparam:'rivafb.nomtrr' 15 (ffffffff806a49f8)
XXX adding modparam:'rivafb.forceCRTC' 16 (ffffffff806a4a20)
XXX adding modparam:'rivafb.flatpanel' 17 (ffffffff806a4a48)
XXX adding modparam:'rivafb.noaccel' 18 (ffffffff806a4a70)
XXX adding modparam:'nvidiafb.nomtrr' 19 (ffffffff806a4a98)
XXX adding modparam:'nvidiafb.reverse_i2c' 20 (ffffffff806a4ac0)
XXX adding modparam:'nvidiafb.bpp' 21 (ffffffff806a4ae8)
XXX adding modparam:'nvidiafb.mode_option' 22 (ffffffff806a4b10)
XXX adding modparam:'nvidiafb.vram' 23 (ffffffff806a4b38)
XXX adding modparam:'nvidiafb.forceCRTC' 24 (ffffffff806a4b60)
XXX adding modparam:'nvidiafb.paneltweak' 25 (ffffffff806a4b88)
XXX adding modparam:'nvidiafb.noscale' 26 (ffffffff806a4bb0)
XXX adding modparam:'nvidiafb.noaccel' 27 (ffffffff806a4bd8)
XXX adding modparam:'nvidiafb.hwcur' 28 (ffffffff806a4c00)
XXX adding modparam:'nvidiafb.fpdither' 29 (ffffffff806a4c28)
XXX adding modparam:'nvidiafb.flatpanel' 30 (ffffffff806a4c50)
XXX adding modparam:'vt8623fb.mtrr' 31 (ffffffff806a4c78)
XXX adding modparam:'vt8623fb.mode' 32 (ffffffff806a4ca0)
XXX adding modparam:'vt8623fb.mode_option' 33 (ffffffff806a4cc8)
XXX adding modparam:'acpi.power_nocheck' 34 (ffffffff806a4cf0)
XXX adding modparam:'processor.latency_factor' 35 (ffffffff806a4d18)
XXX adding modparam:'processor.nocst' 36 (ffffffff806a4d40)
XXX adding modparam:'processor.max_cstate' 37 (ffffffff806a4d68)
XXX adding modparam:'processor.ignore_ppc' 38 (ffffffff806a4d90)
XXX adding modparam:'thermal.psv' 39 (ffffffff806a4db8)
XXX adding modparam:'thermal.off' 40 (ffffffff806a4de0)
XXX adding modparam:'thermal.nocrt' 41 (ffffffff806a4e08)
XXX adding modparam:'thermal.tzp' 42 (ffffffff806a4e30)
XXX adding modparam:'thermal.crt' 43 (ffffffff806a4e58)
XXX adding modparam:'thermal.act' 44 (ffffffff806a4e80)
XXX adding modparam:'acpi.acpica_version' 45 (ffffffff806a4ea8)
XXX adding modparam:'keyboard.brl_nbchords' 46 (ffffffff806a4ed0)
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc3-next-20080814 #1

Call Trace:
 [<ffffffff802358cb>] warn_slowpath+0xae/0xdd
 [<ffffffff8036a6be>] ? number+0x115/0x21f
 [<ffffffff8036a6be>] ? number+0x115/0x21f
 [<ffffffff8036aefc>] ? string+0x3d/0xa2
 [<ffffffff80365e02>] ? idr_get_empty_slot+0x161/0x24e
 [<ffffffff8036b2ea>] ? vsnprintf+0x389/0x678
 [<ffffffff802def96>] ? sysfs_ilookup_test+0x0/0x14
 [<ffffffff802aa5bf>] ? ifind+0x3d/0xac
 [<ffffffff802df1bd>] ? sysfs_find_dirent+0x1c/0x31
 [<ffffffff802df1f1>] ? __sysfs_add_one+0x1f/0x7c
 [<ffffffff802df283>] sysfs_add_one+0x35/0x3d
 [<ffffffff802df7d2>] create_dir+0x58/0x93
 [<ffffffff802df845>] sysfs_create_dir+0x38/0x4f
 [<ffffffff80366b8a>] kobject_add_internal+0xce/0x18f
 [<ffffffff80366d17>] kobject_add_varg+0x41/0x4d
 [<ffffffff80366d91>] kobject_init_and_add+0x6e/0x7c
 [<ffffffff80236323>] ? printk+0x67/0x69
 [<ffffffff80764a30>] kernel_param_sysfs_setup+0x6b/0xc6
 [<ffffffff80764c0a>] param_sysfs_init+0x17f/0x202
 [<ffffffff802debf1>] ? sysfs_add_file+0xc/0xe
 [<ffffffff80764a8b>] ? param_sysfs_init+0x0/0x202
 [<ffffffff80209047>] _stext+0x47/0x13f
 [<ffffffff80269f25>] ? register_irq_proc+0xb7/0xd3
 [<ffffffff807508e5>] kernel_init+0x11b/0x171
 [<ffffffff802311ef>] ? schedule_tail+0x28/0x60
 [<ffffffff8020ce49>] child_rip+0xa/0x11
 [<ffffffff807507ca>] ? kernel_init+0x0/0x171
 [<ffffffff8020ce3f>] ? child_rip+0x0/0x11

---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for acpi with -EEXIST, don't try to register th=
ings with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc3-next-20080814 #1

Call Trace:
 [<ffffffff8036698f>] ? kobject_put+0x47/0x4b
 [<ffffffff80366c08>] kobject_add_internal+0x14c/0x18f
 [<ffffffff80366d17>] kobject_add_varg+0x41/0x4d
 [<ffffffff80366d91>] kobject_init_and_add+0x6e/0x7c
 [<ffffffff80236323>] ? printk+0x67/0x69
 [<ffffffff80764a30>] kernel_param_sysfs_setup+0x6b/0xc6
 [<ffffffff80764c0a>] param_sysfs_init+0x17f/0x202
 [<ffffffff802debf1>] ? sysfs_add_file+0xc/0xe
 [<ffffffff80764a8b>] ? param_sysfs_init+0x0/0x202
 [<ffffffff80209047>] _stext+0x47/0x13f
 [<ffffffff80269f25>] ? register_irq_proc+0xb7/0xd3
 [<ffffffff807508e5>] kernel_init+0x11b/0x171
 [<ffffffff802311ef>] ? schedule_tail+0x28/0x60
 [<ffffffff8020ce49>] child_rip+0xa/0x11
 [<ffffffff807507ca>] ? kernel_init+0x0/0x171
 [<ffffffff8020ce3f>] ? child_rip+0x0/0x11

Module 'acpi' failed to be added to sysfs, error number -17
The system will be unstable now.
XXX adding modparam:'keyboard.brl_timeout' 47 (ffffffff806a4ef8)
XXX adding modparam:'vt.underline' 48 (ffffffff806a4f20)
XXX adding modparam:'vt.italic' 49 (ffffffff806a4f48)
XXX adding modparam:'vt.default_blu' 50 (ffffffff806a4f70)
XXX adding modparam:'vt.default_grn' 51 (ffffffff806a4f98)
XXX adding modparam:'vt.default_red' 52 (ffffffff806a4fc0)
XXX adding modparam:'vt.default_utf8' 53 (ffffffff806a4fe8)
XXX adding modparam:'intel_rng.no_fwh_detect' 54 (ffffffff806a5010)
XXX adding modparam:'amd64_agp.agp_try_unsupported' 55 (ffffffff806a5038)
XXX adding modparam:'ipmi_devintf.ipmi_major' 56 (ffffffff806a5060)
XXX adding modparam:'ipmi_si.unload_when_empty' 57 (ffffffff806a5088)
XXX adding modparam:'ipmi_si.force_kipmid' 58 (ffffffff806a50b0)
XXX adding modparam:'ipmi_si.slave_addrs' 59 (ffffffff806a50d8)
XXX adding modparam:'ipmi_si.regshifts' 60 (ffffffff806a5100)
XXX adding modparam:'ipmi_si.regsizes' 61 (ffffffff806a5128)
XXX adding modparam:'ipmi_si.regspacings' 62 (ffffffff806a5150)
XXX adding modparam:'ipmi_si.irqs' 63 (ffffffff806a5178)
XXX adding modparam:'ipmi_si.ports' 64 (ffffffff806a51a0)
XXX adding modparam:'ipmi_si.addrs' 65 (ffffffff806a51c8)
XXX adding modparam:'ipmi_si.type' 66 (ffffffff806a51f0)
XXX adding modparam:'ipmi_si.trydefaults' 67 (ffffffff806a5218)
XXX adding modparam:'ipmi_si.hotmod' 68 (ffffffff806a5240)
XXX adding modparam:'ipmi_si.kcs_debug' 69 (ffffffff806a5268)
XXX adding modparam:'ipmi_si.smic_debug' 70 (ffffffff806a5290)
XXX adding modparam:'ipmi_si.bt_debug' 71 (ffffffff806a52b8)
XXX adding modparam:'ipmi_watchdog.nowayout' 72 (ffffffff806a52e0)
XXX adding modparam:'ipmi_watchdog.start_now' 73 (ffffffff806a5308)
XXX adding modparam:'ipmi_watchdog.preop' 74 (ffffffff806a5330)
XXX adding modparam:'ipmi_watchdog.preaction' 75 (ffffffff806a5358)
XXX adding modparam:'ipmi_watchdog.action' 76 (ffffffff806a5380)
XXX adding modparam:'ipmi_watchdog.pretimeout' 77 (ffffffff806a53a8)
XXX adding modparam:'ipmi_watchdog.timeout' 78 (ffffffff806a53d0)
XXX adding modparam:'ipmi_watchdog.ifnum_to_use' 79 (ffffffff806a53f8)
XXX adding modparam:'ipmi_poweroff.poweroff_powercycle' 80 (ffffffff806a542=
0)
XXX adding modparam:'ipmi_poweroff.ifnum_to_use' 81 (ffffffff806a5448)
XXX adding modparam:'hangcheck_timer.hangcheck_dump_tasks' 82 (ffffffff806a=
5470)
XXX adding modparam:'hangcheck_timer.hangcheck_reboot' 83 (ffffffff806a5498)
XXX adding modparam:'hangcheck_timer.hangcheck_margin' 84 (ffffffff806a54c0)
XXX adding modparam:'hangcheck_timer.hangcheck_tick' 85 (ffffffff806a54e8)
XXX adding modparam:'drm.debug' 86 (ffffffff806a5510)
XXX adding modparam:'radeon.no_wb' 87 (ffffffff806a5538)
XXX adding modparam:'cn.cn_val' 88 (ffffffff806a5560)
XXX adding modparam:'cn.cn_idx' 89 (ffffffff806a5588)
XXX adding modparam:'8250.nr_uarts' 90 (ffffffff806a55b0)
XXX adding modparam:'8250.share_irqs' 91 (ffffffff806a55d8)
XXX adding modparam:'brd.max_part' 92 (ffffffff806a5600)
XXX adding modparam:'brd.rd_size' 93 (ffffffff806a5628)
XXX adding modparam:'brd.rd_nr' 94 (ffffffff806a5650)
XXX adding modparam:'bnx2.disable_msi' 95 (ffffffff806a5678)
XXX adding modparam:'b44.b44_debug' 96 (ffffffff806a56a0)
XXX adding modparam:'netconsole.netconsole' 97 (ffffffff806a56c8)
XXX adding modparam:'scsi_mod.scsi_logging_level' 98 (ffffffff806a56f0)
XXX adding modparam:'scsi_mod.inq_timeout' 99 (ffffffff806a5718)
XXX adding modparam:'scsi_mod.max_report_luns' 100 (ffffffff806a5740)
XXX adding modparam:'scsi_mod.scan' 101 (ffffffff806a5768)
XXX adding modparam:'scsi_mod.max_luns' 102 (ffffffff806a5790)
XXX adding modparam:'scsi_mod.default_dev_flags' 103 (ffffffff806a57b8)
XXX adding modparam:'scsi_mod.dev_flags' 104 (ffffffff806a57e0)
XXX adding modparam:'scsi_transport_fc.dev_loss_tmo' 105 (ffffffff806a5808)
XXX adding modparam:'sg.allow_dio' 106 (ffffffff806a5830)
XXX adding modparam:'sg.def_reserved_size' 107 (ffffffff806a5858)
XXX adding modparam:'sg.scatter_elem_sz' 108 (ffffffff806a5880)
XXX adding modparam:'usbcore.debug' 110 (ffffffff806a58d0)
XXX adding modparam:'usbcore.use_both_schemes' 111 (ffffffff806a58f8)
XXX adding modparam:'usbcore.old_scheme_first' 112 (ffffffff806a5920)
XXX adding modparam:'usbcore.blinkenlights' 113 (ffffffff806a5948)
XXX adding modparam:'usbcore.usbfs_snoop' 114 (ffffffff806a5970)
XXX adding modparam:'i8042.debug' 115 (ffffffff806a5998)
XXX adding modparam:'i8042.nopnp' 116 (ffffffff806a59c0)
XXX adding modparam:'i8042.dritek' 117 (ffffffff806a59e8)
XXX adding modparam:'i8042.panicblink' 118 (ffffffff806a5a10)
XXX adding modparam:'i8042.noloop' 119 (ffffffff806a5a38)
XXX adding modparam:'i8042.dumbkbd' 120 (ffffffff806a5a60)
XXX adding modparam:'i8042.direct' 121 (ffffffff806a5a88)
XXX adding modparam:'i8042.reset' 122 (ffffffff806a5ab0)
XXX adding modparam:'i8042.unlock' 123 (ffffffff806a5ad8)
XXX adding modparam:'i8042.nomux' 124 (ffffffff806a5b00)
XXX adding modparam:'i8042.noaux' 125 (ffffffff806a5b28)
XXX adding modparam:'i8042.nokbd' 126 (ffffffff806a5b50)
XXX adding modparam:'mousedev.tap_time' 127 (ffffffff806a5b78)
XXX adding modparam:'mousedev.yres' 128 (ffffffff806a5ba0)
XXX adding modparam:'mousedev.xres' 129 (ffffffff806a5bc8)
XXX adding modparam:'atkbd.extra' 130 (ffffffff806a5bf0)
XXX adding modparam:'atkbd.scroll' 131 (ffffffff806a5c18)
XXX adding modparam:'atkbd.softraw' 132 (ffffffff806a5c40)
XXX adding modparam:'atkbd.softrepeat' 133 (ffffffff806a5c68)
XXX adding modparam:'atkbd.reset' 134 (ffffffff806a5c90)
XXX adding modparam:'atkbd.set' 135 (ffffffff806a5cb8)
XXX adding modparam:'psmouse.resync_time' 136 (ffffffff806a5ce0)
XXX adding modparam:'psmouse.resetafter' 137 (ffffffff806a5d08)
XXX adding modparam:'psmouse.smartscroll' 138 (ffffffff806a5d30)
XXX adding modparam:'psmouse.rate' 139 (ffffffff806a5d58)
XXX adding modparam:'psmouse.resolution' 140 (ffffffff806a5d80)
XXX adding modparam:'psmouse.proto' 141 (ffffffff806a5da8)
XXX adding modparam:'i2c_piix4.force_addr' 142 (ffffffff806a5dd0)
XXX adding modparam:'i2c_piix4.force' 143 (ffffffff806a5df8)
XXX adding modparam:'i2c_viapro.force_addr' 144 (ffffffff806a5e20)
XXX adding modparam:'i2c_viapro.force' 145 (ffffffff806a5e48)
XXX adding modparam:'i2c_algo_bit.bit_test' 146 (ffffffff806a5e70)
XXX adding modparam:'via686a.force_addr' 147 (ffffffff806a5e98)
XXX adding modparam:'vt1211.force_id' 148 (ffffffff806a5ec0)
XXX adding modparam:'vt1211.int_mode' 149 (ffffffff806a5ee8)
XXX adding modparam:'vt1211.uch_config' 150 (ffffffff806a5f10)
XXX adding modparam:'vt8231.force_addr' 151 (ffffffff806a5f38)
XXX adding modparam:'softdog.soft_noboot' 152 (ffffffff806a5f60)
XXX adding modparam:'softdog.nowayout' 153 (ffffffff806a5f88)
XXX adding modparam:'softdog.soft_margin' 154 (ffffffff806a5fb0)
XXX adding modparam:'edac_core.edac_mc_poll_msec' 155 (ffffffff806a5fd8)
XXX adding modparam:'edac_core.edac_mc_log_ce' 156 (ffffffff806a6000)
XXX adding modparam:'edac_core.edac_mc_log_ue' 157 (ffffffff806a6028)
XXX adding modparam:'edac_core.edac_mc_panic_on_ue' 158 (ffffffff806a6050)
XXX adding modparam:'edac_core.edac_pci_panic_on_pe' 159 (ffffffff806a6078)
XXX adding modparam:'edac_core.check_pci_errors' 160 (ffffffff806a60a0)
XXX adding modparam:'i5000_edac.edac_op_state' 161 (ffffffff806a60c8)
XXX adding modparam:'e752x_edac.report_non_memory_errors' 162 (ffffffff806a=
60f0)
XXX adding modparam:'e752x_edac.sysbus_parity' 163 (ffffffff806a6118)
XXX adding modparam:'e752x_edac.edac_op_state' 164 (ffffffff806a6140)
XXX adding modparam:'e752x_edac.force_function_unhide' 165 (ffffffff806a616=
8)
XXX adding modparam:'i82975x_edac.edac_op_state' 166 (ffffffff806a6190)
XXX adding modparam:'cpufreq.debug_ratelimit' 167 (ffffffff806a61b8)
XXX adding modparam:'cpufreq.debug' 168 (ffffffff806a61e0)
XXX adding modparam:'hid.debug' 169 (ffffffff806a6208)
XXX adding modparam:'hid.pb_fnmode' 170 (ffffffff806a6230)
XXX adding modparam:'usbhid.rdesc_quirks' 171 (ffffffff806a6258)
XXX adding modparam:'usbhid.quirks' 172 (ffffffff806a6280)
XXX adding modparam:'usbhid.mousepoll' 173 (ffffffff806a62a8)
XXX adding modparam:'tcp_bic.smooth_part' 174 (ffffffff806a62d0)
XXX adding modparam:'tcp_bic.initial_ssthresh' 175 (ffffffff806a62f8)
XXX adding modparam:'tcp_bic.beta' 176 (ffffffff806a6320)
XXX adding modparam:'tcp_bic.low_window' 177 (ffffffff806a6348)
XXX adding modparam:'tcp_bic.max_increment' 178 (ffffffff806a6370)
XXX adding modparam:'tcp_bic.fast_convergence' 179 (ffffffff806a6398)
XXX adding modparam:'sunrpc.pool_mode' 180 (ffffffff806a63c0)
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 7FE58000, 04F0 (r2 HP     PNOWSSDT        2 HP          1)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base 80000000 segment 0 buses 0 - 255
PCI: MCFG area at 80000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at 80000000 - 8fffffff
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: supports D1
pci 0000:00:02.0: supports D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: supports D1
pci 0000:00:02.1: supports D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:01:03.0: supports D1
pci 0000:01:03.0: supports D2
pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
pci 0000:01:04.0: PME# disabled
pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
pci 0000:01:04.2: PME# disabled
pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
pci 0000:01:04.4: PME# disabled
pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
pci 0000:01:04.6: PME# disabled
pci 0000:00:09.0: transparent bridge
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:03:00.0: PME# supported from D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:05:00.0: PME# supported from D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:07:04.0: PME# supported from D3hot D3cold
pci 0000:07:04.0: PME# disabled
pci 0000:07:04.1: PME# supported from D3hot D3cold
pci 0000:07:04.1: PME# disabled
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1.NB01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2.NC1B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE3.NC2B._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:40)
pci 0000:40:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0c.0: PME# disabled
pci 0000:40:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0d.0: PME# disabled
pci 0000:40:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0e.0: PME# disabled
pci 0000:41:00.0: PME# supported from D0 D3hot D3cold
pci 0000:41:00.0: PME# disabled
pci 0000:42:08.0: supports D1
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2.SASB._PRT]
ACPI: PCI Interrupt Link [LNKW] (IRQs *16)
ACPI: PCI Interrupt Link [LNKX] (IRQs *17)
ACPI: PCI Interrupt Link [LNKY] (IRQs *18)
ACPI: PCI Interrupt Link [LNKZ] (IRQs *19)
ACPI: PCI Interrupt Link [LNU0] (IRQs *22)
ACPI: PCI Interrupt Link [LNU2] (IRQs *23)
ACPI: PCI Interrupt Link [LNKA] (IRQs *54)
ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
system 00:01: ioport range 0x408-0x40f has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x700-0x73f has been reserved
system 00:01: ioport range 0x800-0x8fe has been reserved
system 00:01: ioport range 0x900-0x9fe has been reserved
system 00:01: ioport range 0x9ff-0x9ff has been reserved
system 00:01: ioport range 0xa00-0xafe has been reserved
system 00:01: ioport range 0xaff-0xaff has been reserved
system 00:01: ioport range 0xb00-0xbfe has been reserved
system 00:01: ioport range 0xbff-0xbff has been reserved
system 00:01: ioport range 0xc80-0xc83 has been reserved
system 00:01: ioport range 0xcd4-0xcd7 has been reserved
system 00:01: ioport range 0xf50-0xf58 has been reserved
system 00:01: ioport range 0xca0-0xca1 has been reserved
system 00:01: ioport range 0xca4-0xca5 has been reserved
system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
system 00:01: ioport range 0x3f8-0x3ff has been reserved
system 00:01: iomem range 0x80000000-0x8fffffff could not be reserved
system 00:01: iomem range 0xf7df0000-0xf7df0fff has been reserved
system 00:01: iomem range 0xfdef0000-0xfdef0fff has been reserved
pci 0000:00:09.0: PCI bridge, secondary bus 0000:01
pci 0000:00:09.0:   IO window: 0x1000-0x2fff
pci 0000:00:09.0:   MEM window: 0xf7e00000-0xf7ffffff
pci 0000:00:09.0:   PREFETCH window: 0x000000e8000000-0x000000efffffff
pci 0000:02:00.0: PCI bridge, secondary bus 0000:03
pci 0000:02:00.0:   IO window: disabled
pci 0000:02:00.0:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:02:00.0:   PREFETCH window: 0x00000090000000-0x000000900fffff
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:00:0b.0:   PREFETCH window: 0x00000090000000-0x000000900fffff
pci 0000:04:00.0: PCI bridge, secondary bus 0000:05
pci 0000:04:00.0:   IO window: disabled
pci 0000:04:00.0:   MEM window: 0xfa000000-0xfbffffff
pci 0000:04:00.0:   PREFETCH window: 0x00000090100000-0x000000901fffff
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0c.0:   IO window: disabled
pci 0000:00:0c.0:   MEM window: 0xfa000000-0xfbffffff
pci 0000:00:0c.0:   PREFETCH window: 0x00000090100000-0x000000901fffff
pci 0000:06:00.0: PCI bridge, secondary bus 0000:07
pci 0000:06:00.0:   IO window: disabled
pci 0000:06:00.0:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:06:00.0:   PREFETCH window: 0x00000090200000-0x000000902fffff
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:06
pci 0000:00:0d.0:   IO window: disabled
pci 0000:00:0d.0:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:0d.0:   PREFETCH window: 0x00000090200000-0x000000902fffff
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:08
pci 0000:00:0e.0:   IO window: 0x3000-0x3fff
pci 0000:00:0e.0:   MEM window: 0xfdd00000-0xfddfffff
pci 0000:00:0e.0:   PREFETCH window: 0x00000090300000-0x000000903fffff
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:02:00.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:04:00.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:06:00.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci 0000:42:04.0: PCI bridge, secondary bus 0000:43
pci 0000:42:04.0:   IO window: disabled
pci 0000:42:04.0:   MEM window: disabled
pci 0000:42:04.0:   PREFETCH window: disabled
pci 0000:41:00.0: PCI bridge, secondary bus 0000:42
pci 0000:41:00.0:   IO window: 0x4000-0x4fff
pci 0000:41:00.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:41:00.0:   PREFETCH window: 0x00000084000000-0x000000840fffff
pci 0000:40:0c.0: PCI bridge, secondary bus 0000:41
pci 0000:40:0c.0:   IO window: 0x4000-0x4fff
pci 0000:40:0c.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:40:0c.0:   PREFETCH window: 0x00000084000000-0x000000840fffff
pci 0000:40:0d.0: PCI bridge, secondary bus 0000:44
pci 0000:40:0d.0:   IO window: disabled
pci 0000:40:0d.0:   MEM window: disabled
pci 0000:40:0d.0:   PREFETCH window: disabled
pci 0000:40:0e.0: PCI bridge, secondary bus 0000:47
pci 0000:40:0e.0:   IO window: disabled
pci 0000:40:0e.0:   MEM window: disabled
pci 0000:40:0e.0:   PREFETCH window: disabled
pci 0000:40:0c.0: setting latency timer to 64
pci 0000:41:00.0: setting latency timer to 64
pci 0000:40:0d.0: setting latency timer to 64
pci 0000:40:0e.0: setting latency timer to 64
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 1325k freed
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
microcode: CPU0 not a capable Intel processor
microcode: CPU1 not a capable Intel processor
microcode: CPU2 not a capable Intel processor
microcode: CPU3 not a capable Intel processor
audit: initializing netlink socket (disabled)
type=3D2000 audit(1218788487.795:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 16013
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Enabling HT MSI Mapping
pci 0000:00:0c.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Enabling HT MSI Mapping
pci 0000:00:0d.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Found enabled HT MSI Mapping
pci 0000:01:03.0: Boot video device
pci 0000:01:04.4: HCRESET not completed yet!
pci 0000:40:00.0: Enabling HT MSI Mapping
pci 0000:40:0c.0: Enabling HT MSI Mapping
pci 0000:40:0c.0: Found enabled HT MSI Mapping
pci 0000:40:0d.0: Enabling HT MSI Mapping
pci 0000:40:0d.0: Found enabled HT MSI Mapping
pci 0000:40:0e.0: Enabling HT MSI Mapping
pci 0000:40:0e.0: Found enabled HT MSI Mapping
pcieport-driver 0000:00:0b.0: setting latency timer to 64
pcieport-driver 0000:00:0b.0: found MSI capability
pci_express 0000:00:0b.0:pcie00: allocate port service
pci_express 0000:00:0b.0:pcie01: allocate port service
pci_express 0000:00:0b.0:pcie03: allocate port service
pcieport-driver 0000:00:0c.0: setting latency timer to 64
pcieport-driver 0000:00:0c.0: found MSI capability
pci_express 0000:00:0c.0:pcie00: allocate port service
pci_express 0000:00:0c.0:pcie01: allocate port service
pci_express 0000:00:0c.0:pcie03: allocate port service
pcieport-driver 0000:00:0d.0: setting latency timer to 64
pcieport-driver 0000:00:0d.0: found MSI capability
pci_express 0000:00:0d.0:pcie00: allocate port service
pci_express 0000:00:0d.0:pcie01: allocate port service
pci_express 0000:00:0d.0:pcie03: allocate port service
pcieport-driver 0000:00:0e.0: setting latency timer to 64
pcieport-driver 0000:00:0e.0: found MSI capability
pci_express 0000:00:0e.0:pcie00: allocate port service
pci_express 0000:00:0e.0:pcie01: allocate port service
pci_express 0000:00:0e.0:pcie03: allocate port service
pcieport-driver 0000:40:0c.0: setting latency timer to 64
pcieport-driver 0000:40:0c.0: found MSI capability
pci_express 0000:40:0c.0:pcie00: allocate port service
pci_express 0000:40:0c.0:pcie01: allocate port service
pci_express 0000:40:0c.0:pcie03: allocate port service
pcieport-driver 0000:40:0d.0: setting latency timer to 64
pcieport-driver 0000:40:0d.0: found MSI capability
pci_express 0000:40:0d.0:pcie00: allocate port service
pci_express 0000:40:0d.0:pcie01: allocate port service
pci_express 0000:40:0d.0:pcie03: allocate port service
pcieport-driver 0000:40:0e.0: setting latency timer to 64
pcieport-driver 0000:40:0e.0: found MSI capability
pci_express 0000:40:0e.0:pcie00: allocate port service
pci_express 0000:40:0e.0:pcie01: allocate port service
pci_express 0000:40:0e.0:pcie03: allocate port service
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
processor ACPI0007:00: registered as cooling_device0
processor ACPI0007:01: registered as cooling_device1
processor ACPI0007:02: registered as cooling_device2
processor ACPI0007:03: registered as cooling_device3
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
ipmi message handler version 39.2
ipmi device interface
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, sl=
ave address 0x20, irq 0
ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev_id: 0x11)
IPMI kcs interface initialized
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slav=
e address 0x0, irq 0
ipmi_si: duplicate interface
ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 16
ipmi_si 0000:01:04.6: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IR=
Q 16
ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf7ef0000, =
slave address 0x0, irq 16
Clocksource tsc unstable (delta =3D 4358919421601 ns)
  Using irq 16
ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: =
0x11)
IPMI kcs interface initialized
IPMI Watchdog: driver initialized
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
IPMI poweroff: ATCA Detect mfg 0xB prod 0x0
IPMI poweroff: Unable to find a poweroff function that will work, giving up
IPMI poweroff: ATCA Detect mfg 0xB prod 0x0
IPMI poweroff: Unable to find a poweroff function that will work, giving up
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 6=
0 seconds).
Hangcheck: Using get_cycles().
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [LNKY] enabled at IRQ 18
pci 0000:01:03.0: PCI INT A -> Link[LNKY] -> GSI 18 (level, high) -> IRQ 18
[drm] Initialized radeon 1.29.0 20080528 on minor 0
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
brd: module loaded
Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.7.9 (July 18, 2008)
ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
bnx2 0000:03:00.0: PCI INT A -> Link[LNKX] -> GSI 17 (level, high) -> IRQ 17
eth0: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz fo=
und at mem f8000000, IRQ 17, node addr 00:18:fe:35:26:f6
bnx2 0000:05:00.0: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IRQ 16
eth1: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz fo=
und at mem fa000000, IRQ 16, node addr 00:18:fe:35:26:f4
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: local port 54846
netconsole: local IP 139.185.50.77
netconsole: interface eth0
netconsole: remote port 54846
netconsole: remote IP 139.185.50.76
netconsole: remote ethernet address 00:18:fe:34:1c:3d
netconsole: device eth0 not up yet, forcing it
bnx2: eth0: using MSI
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
bnx2: eth0 NIC SerDes Link is Up, 1000 Mbps full duplex
console [netcon0] enabled
netconsole: network logging started
Loading iSCSI transport class v2.0-870.
Driver 'sd' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input1
i2c /dev entries driver
SoftDog: cannot register miscdev on minor=3D130 (err=3D-16)
EDAC MC: Ver: 2.1.0 Aug 15 2008
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
NET: Registered protocol family 15
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
powernow-k8: Found 2 Dual-Core AMD Opteron(tm) Processor 8218 processors (4=
 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
registered taskstats version 1
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
EDD information not available.
Freeing unused kernel memory: 392k freed
Write protecting the kernel read-only data: 4728k
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:01:04.4: PCI INT B -> Link[LNKX] -> GSI 17 (level, high) -> I=
RQ 17
uhci_hcd 0000:01:04.4: UHCI Host Controller
uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 1
uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:04.4: HCRESET not completed yet!
uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
insmod used greatest stack depth: 4928 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNU0] -> GSI 22 (level, high) -> I=
RQ 22
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xf7de0000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
ehci_hcd 0000:00:02.1: PCI INT B -> Link[LNU2] -> GSI 23 (level, high) -> I=
RQ 23
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 23, io mem 0xf7dd0000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 10 ports detected
usb 1-1: configuration #1 chosen from 1 choice
input: HP Virtual Keyboard as /class/input/input2
input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1
input: HP Virtual Keyboard as /class/input/input3
input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
insmod used greatest stack depth: 4880 bytes left
HP CISS Driver (v 3.6.20)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54
cciss 0000:42:08.0: PCI INT A -> Link[LNKA] -> GSI 54 (level, high) -> IRQ =
54
cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 503 using DAC
usb 1-2: new full speed USB device using uhci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 7 ports detected
      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

 cciss/c0d0: p1 p2 p3 p4
      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

 cciss/c0d1: p1 p2
insmod used greatest stack depth: 4136 bytes left
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
modprobe used greatest stack depth: 3576 bytes left
Emulex LightPulse Fibre Channel SCSI driver 8.2.7
Copyright(c) 2004-2008 Emulex.  All rights reserved.
lpfc 0000:08:00.0: PCI INT A -> Link[LNKY] -> GSI 18 (level, high) -> IRQ 18
lpfc 0000:08:00.0: setting latency timer to 64
scsi0 :  on PCI bus 08 device 00 irq 18
lpfc 0000:08:00.0: 0:1303 Link Up Event x1 received Data: x1 xf7 x4 x2
scsi 0:0:0:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 0:0:0:0: Attached scsi generic sg0 type 12
scsi 0:0:1:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 0:0:1:0: Attached scsi generic sg1 type 12
scsi 0:0:1:8: Direct-Access     COMPAQ   MSA1000 VOLUME   5.20 PQ: 0 ANSI: 4
sd 0:0:1:8: [sda] 2187605616 512-byte hardware sectors (1120054 MB)
sd 0:0:1:8: [sda] Write Protect is off
sd 0:0:1:8: [sda] Mode Sense: 83 00 00 08
sd 0:0:1:8: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:1:8: [sda] 2187605616 512-byte hardware sectors (1120054 MB)
sd 0:0:1:8: [sda] Write Protect is off
sd 0:0:1:8: [sda] Mode Sense: 83 00 00 08
sd 0:0:1:8: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1
sd 0:0:1:8: [sda] Attached SCSI disk
sd 0:0:1:8: Attached scsi generic sg2 type 0
tg3.c:v3.93 (May 22, 2008)
ACPI: PCI Interrupt Link [LNKZ] enabled at IRQ 19
tg3 0000:07:04.0: PCI INT A -> Link[LNKZ] -> GSI 19 (level, high) -> IRQ 19
lpfc 0000:08:00.1: PCI INT B -> Link[LNKZ] -> GSI 19 (level, high) -> IRQ 19
lpfc 0000:08:00.1: setting latency timer to 64
scsi1 :  on PCI bus 08 device 01 irq 19
firmware: requesting tigon/tg3_tso.bin
eth2: Tigon3 [partno(011276-001) rev 9003 PHY(5714)] (PCIX:133MHz:64-bit) 1=
000Base-SX Ethernet 00:18:fe:34:1c:2f
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth2: dma_rwctrl[76148000] dma_mask[40-bit]
tg3 0000:07:04.1: PCI INT B -> Link[LNKW] -> GSI 16 (level, high) -> IRQ 16
firmware: requesting tigon/tg3_tso.bin
eth3: Tigon3 [partno(011276-001) rev 9003 PHY(5714)] (PCIX:133MHz:64-bit) 1=
000Base-SX Ethernet 00:18:fe:34:1c:30
eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth3: dma_rwctrl[76148000] dma_mask[40-bit]
lpfc 0000:08:00.1: 1:1303 Link Up Event x1 received Data: x1 xf7 x4 x2
scsi 1:0:0:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 1:0:0:0: Attached scsi generic sg3 type 12
scsi 1:0:1:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 1:0:1:0: Attached scsi generic sg4 type 12
scsi 1:0:1:8: Direct-Access     COMPAQ   MSA1000 VOLUME   5.20 PQ: 0 ANSI: 4
sd 1:0:1:8: [sdb] 2187605616 512-byte hardware sectors (1120054 MB)
sd 1:0:1:8: [sdb] Write Protect is off
sd 1:0:1:8: [sdb] Mode Sense: 83 00 00 08
sd 1:0:1:8: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 1:0:1:8: [sdb] 2187605616 512-byte hardware sectors (1120054 MB)
sd 1:0:1:8: [sdb] Write Protect is off
sd 1:0:1:8: [sdb] Mode Sense: 83 00 00 08
sd 1:0:1:8: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sdb: sdb1
sd 1:0:1:8: [sdb] Attached SCSI disk
sd 1:0:1:8: Attached scsi generic sg5 type 0
lp: driver loaded but no devices found
EXT3 FS on cciss/c0d0p3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on cciss/c0d0p1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on cciss/c0d1p1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on cciss/c0d1p2, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with writeback data mode.
Adding 8385920k swap on /dev/cciss/c0d0p2.  Priority:-1 extents:1 across:83=
85920k
rc.sysinit used greatest stack depth: 3560 bytes left
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
 rport-0:0-17: blocked FC remote port time out: removing rport
 rport-1:0-18: blocked FC remote port time out: removing rport

--Multipart=_Fri__15_Aug_2008_08_58_36_-0700_YO_48Dvbno2.TL36--
