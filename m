Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbYDKL4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbYDKL4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbYDKL4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:56:05 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:62738 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYDKL4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:56:00 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Fri, 11 Apr 2008 13:55:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Peer Chen <pchen@nvidia.com>, Kuan Luo <kluo@nvidia.com>
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804031347.20352.volker.armin.hemmann@tu-clausthal.de> <47FEFFC6.4@gmail.com>
In-Reply-To: <47FEFFC6.4@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LH1/HQBIbZUHZo6"
Message-Id: <200804111355.55364.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_LH1/HQBIbZUHZo6
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

> Aiee.... Can you please try 2.6.25-rc8 with both configurations?  And
> w/o systemrescuecd?  Just seeing whether things mount properly or not is
> good enough.  There isn't much risk of losing data.

2.6.25-rc8 is a 'no change'. AHCI+pci=3Dnomsi boots, AHCI without hangs.
with AHCI I also get this:

[    0.363828] ------------[ cut here ]------------
[    0.363828] WARNING: at drivers/ata/ahci.c:645 ahci_init_one+0x190/0xa3a=
()
[    0.363828] Modules linked in:
[    0.363828] Pid: 1, comm: swapper Not tainted 2.6.25-rc8 #2
[    0.363828]
[    0.363828] Call Trace:
[    0.363828]  [<ffffffff8022c5a5>] warn_on_slowpath+0x51/0x63
[    0.363832]  [<ffffffff80220061>] __ioremap+0x8/0x197
[    0.363872]  [<ffffffff803921f4>] pci_conf1_read+0xb2/0xbd
[    0.363911]  [<ffffffff802f3316>] pcim_iomap_release+0x0/0x2c
[    0.363950]  [<ffffffff802f3316>] pcim_iomap_release+0x0/0x2c
[    0.363989]  [<ffffffff803471a9>] devres_find+0x4b/0x65
[    0.364028]  [<ffffffff8036e4cd>] ahci_init_one+0x190/0xa3a
[    0.364067]  [<ffffffff802af837>] sysfs_addrm_finish+0x1d/0x209
[    0.364107]  [<ffffffff80284014>] ifind+0x34/0x8d
[    0.364145]  [<ffffffff802af54e>] sysfs_find_dirent+0x1b/0x2f
[    0.364184]  [<ffffffff802eb75d>] ida_get_new_above+0xf0/0x180
[    0.364223]  [<ffffffff802af837>] sysfs_addrm_finish+0x1d/0x209
[    0.364263]  [<ffffffff802b0378>] sysfs_create_link+0xb6/0x102
[    0.364303]  [<ffffffff802f8664>] pci_device_probe+0x4c/0x72
[    0.364342]  [<ffffffff80344c48>] driver_probe_device+0xb5/0x132
[    0.364381]  [<ffffffff80344ddb>] __driver_attach+0x6f/0xaf
[    0.364419]  [<ffffffff80344d6c>] __driver_attach+0x0/0xaf
[    0.364458]  [<ffffffff80344d6c>] __driver_attach+0x0/0xaf
[    0.364498]  [<ffffffff8034400a>] bus_for_each_dev+0x44/0x6f
[    0.364538]  [<ffffffff802a9b57>] proc_match+0x23/0x2d
[    0.364576]  [<ffffffff80344876>] bus_add_driver+0xae/0x1f4
[    0.364614]  [<ffffffff8034500a>] driver_register+0x59/0xce
[    0.364654]  [<ffffffff802f88a5>] __pci_register_driver+0x4a/0x7d
[    0.364701]  [<ffffffff804e56b8>] kernel_init+0x14f/0x2b9
[    0.364740]  [<ffffffff8020be98>] child_rip+0xa/0x12
[    0.364779]  [<ffffffff804e5569>] kernel_init+0x0/0x2b9
[    0.364817]  [<ffffffff8020be8e>] child_rip+0x0/0x12
[    0.364854]
[    0.364891] ---[ end trace ea9d541113ecaf1e ]---
[    1.370495] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl SATA mode
[    1.370495] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[    1.370495] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.370495] scsi0 : ahci
[    1.370506] scsi1 : ahci
[    1.370515] scsi2 : ahci
[    1.370524] scsi3 : ahci

Gl=C3=BCck Auf,
Volker

--Boundary-00=_LH1/HQBIbZUHZo6
Content-Type: application/octet-stream;
  name="dmesg_2.6.25-rc8_ahci_nomsi"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg_2.6.25-rc8_ahci_nomsi"

[    0.000000] Linux version 2.6.25-rc8 (root@energy) (gcc version 4.2.3 (G=
entoo 4.2.3 p1.0)) #2 SMP Fri Apr 11 13:26:53 CEST 2008
[    0.000000] Command line: pci=3Dnomsi root=3D/dev/sda3 nmi_watchdog=3D0 =
console=3Dtty63A=8BL$=08=89=C8A=0F=AFD$@H=98H=8D=04=02H9=C5s=1BH)=D5Hc=D1H=
=89=E8H=89=D1H=99H=F7=F91=C0H=85=D2=0F=94=C0=EB=021=C0A\Z[]A\=C3H=85=FFSu=
=04=0F=0B=EB=FE1=C0H=83=FF=10=0F=84=87
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of =
256 used
[    0.000000] end_pfn_map =3D 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT =
      97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT =
      97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL =
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT =
      97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT =
      97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT =
      97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT =
      97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD  =
       1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of =
256 used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-54e213] TEXT DATA BSS
[    0.000000] early res: 3 [9fc00-a0bff] EBDA
[    0.000000] early res: 4 [8000-dfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 =
on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 =
on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 =
on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 =
on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 =
on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 =
on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 =
on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 =
on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 =
on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 =
on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 =
on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 =
on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 =
on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 =
on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 =
on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 =
on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 =
on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 =
on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 =
on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 =
on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 =
on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 =
on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 =
on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 =
on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 =
on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 =
on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 =
on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 =
on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 =
on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 =
on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 =
on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 =
on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 =
on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 =
on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 856 pages reserved
[    0.000000]   DMA zone: 3087 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 00000000cff=
c0000
[    0.000000] PM: Registered nosave memory: 00000000cffc0000 - 00000000cff=
f0000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 00000000d00=
00000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec=
01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee=
00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef=
00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ff3=
80000
[    0.000000] PM: Registered nosave memory: 00000000ff380000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000=
:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 32584 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 1030519
[    0.000000] Kernel command line: pci=3Dnomsi root=3D/dev/sda3 nmi_watchd=
og=3D0 console=3Dtty63A=8BL$=08=89=C8A=0F=AFD$@H=98H=8D=04=02H9=C5s=1BH)=D5=
Hc=D1H=89=E8H=89=D1H=99H=F7=F91=C0H=85=D2=0F=94=C0=EB=021=C0A\Z[]A\=C3H=85=
=FFSu=04=0F=0B=EB=FE1=C0H=83=FF=10=0F=84=87
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000002] time.c: Detected 3013.883 MHz processor.
[    0.000011] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty63] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.003333] Checking aperture...
[    0.003333] Node 0: aperture @ 8000000 size 32 MB
[    0.003333] Aperture pointing to e820 RAM. Ignoring.
[    0.003333] No AGP bridge found
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ c000000
[    0.003333] PM: Registered nosave memory: 000000000c000000 - 00000000100=
00000
[    0.003333] Memory: 4047752k/4980736k available (1994k kernel code, 1451=
36k reserved, 866k data, 192k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D2, Nodes=3D1
[    0.003333] hpet clockevent registered
[    0.083330] Calibrating delay using timer specific routine.. 6034.75 Bog=
oMIPS (lpj=3D10054001)
[    0.083419] Mount-cache hash table entries: 256
[    0.083538] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.083579] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.083616] CPU: Physical Processor ID: 0
[    0.083653] CPU: Processor Core ID: 0
[    0.083702] ACPI: Core revision 20070126
[    0.122315] Using local APIC timer interrupts.
[    0.123326] APIC timer calibration result 12557883
[    0.123327] Detected 12.557 MHz APIC timer.
[    0.123430] Booting processor 1/2 APIC 0x1
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6030.96 Bog=
oMIPS (lpj=3D10046346)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.216840] Brought up 2 CPUs
[    0.217287] net_namespace: 296 bytes
[    0.217406] NET: Registered protocol family 16
[    0.217503] No dock devices found.
[    0.217565] ACPI: bus type pci registered
[    0.217642] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.217681] PCI: Not using MMCONFIG.
[    0.217718] PCI: Using configuration type 1
[    0.220763] ACPI: EC: Look up EC in DSDT
[    0.225383] ACPI: Interpreter enabled
[    0.225421] ACPI: (supports S0 S1 S3 S4 S5)
[    0.225592] ACPI: Using IOAPIC for interrupt routing
[    0.225773] ACPI: Error attaching device data
[    0.225814] ACPI: Error attaching device data
[    0.225854] ACPI: Error attaching device data
[    0.225894] ACPI: Error attaching device data
[    0.232203] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.232716] PCI: Transparent bridge - 0000:00:08.0
[    0.232966] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.233124] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.233433] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.233499] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.233565] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.233631] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.238118] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    0.238480] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.238840] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disab=
led.
[    0.239226] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disab=
led.
[    0.239612] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disab=
led.
[    0.240130] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.240491] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disab=
led.
[    0.240877] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.241237] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[    0.241598] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disab=
led.
[    0.241986] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.242347] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disab=
led.
[    0.242734] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disab=
led.
[    0.243120] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.243496] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disab=
led.
[    0.243884] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[    0.244244] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disab=
led.
[    0.244657] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disab=
led.
[    0.245045] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disab=
led.
[    0.245432] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disab=
led.
[    0.245760] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.245808] pnp: PnP ACPI init
[    0.245847] ACPI: bus type pnp registered
[    0.248984] pnp: PnP ACPI: found 13 devices
[    0.249021] ACPI: ACPI bus type pnp unregistered
[    0.249125] SCSI subsystem initialized
[    0.249198] libata version 3.00 loaded.
[    0.249237] usbcore: registered new interface driver usbfs
[    0.249287] usbcore: registered new interface driver hub
[    0.249342] usbcore: registered new device driver usb
[    0.249420] PCI: Using ACPI for IRQ routing
[    0.249458] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[    0.266649] PCI-DMA: Disabling AGP.
[    0.266649] PCI-DMA: aperture base @ c000000 size 65536 KB
[    0.266649] PCI-DMA: using GART IOMMU.
[    0.266649] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.266649] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.266649] hpet0: 3 32-bit timers, 25000000 Hz
[    0.266659] Switched to high resolution mode on CPU 0
[    0.063372] Switched to high resolution mode on CPU 1
[    0.280019] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.280019] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.280019] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.280019] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.280019] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.280019] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.280019] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.280022] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.280061] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.280101] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.280141] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.280181] system 00:05: iomem range 0xfee01000-0xfeefffff has been res=
erved
[    0.280225] system 00:07: iomem range 0xfec00000-0xfec00fff could not be=
 reserved
[    0.280273] system 00:07: iomem range 0xfee00000-0xfee00fff could not be=
 reserved
[    0.280324] system 00:0a: ioport range 0x290-0x29f has been reserved
[    0.280367] system 00:0b: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.280410] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.280450] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.280489] system 00:0c: iomem range 0xe0000-0xfffff could not be reser=
ved
[    0.280533] system 00:0c: iomem range 0x100000-0xcfffffff could not be r=
eserved
[    0.280581] system 00:0c: iomem range 0xff380000-0xffffffff could not be=
 reserved
[    0.281029] PCI: Bridge: 0000:00:08.0
[    0.281066]   IO window: d000-dfff
[    0.281103]   MEM window: 0xf9f00000-0xf9ffffff
[    0.281142]   PREFETCH window: 0x00000000f0000000-0x00000000f00fffff
[    0.281182] PCI: Bridge: 0000:00:0b.0
[    0.281219]   IO window: c000-cfff
[    0.281256]   MEM window: 0xf9e00000-0xf9efffff
[    0.281293]   PREFETCH window: disabled.
[    0.281331] PCI: Bridge: 0000:00:0c.0
[    0.281367]   IO window: disabled.
[    0.281403]   MEM window: disabled.
[    0.281440]   PREFETCH window: disabled.
[    0.281478] PCI: Bridge: 0000:00:0d.0
[    0.281514]   IO window: e000-efff
[    0.281551]   MEM window: 0xfa000000-0xfebfffff
[    0.281589]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.281628] PCI: Bridge: 0000:00:0e.0
[    0.281665]   IO window: disabled.
[    0.281701]   MEM window: disabled.
[    0.281738]   PREFETCH window: disabled.
[    0.281781] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    0.281790] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.281795] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.281800] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.281805] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.281812] NET: Registered protocol family 2
[    0.316684] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.316684] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.316684] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.316684] TCP: Hash tables configured (established 262144 bind 65536)
[    0.316684] TCP reno registered
[    0.326989] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    0.326989] io scheduler noop registered
[    0.326989] io scheduler cfq registered (default)
[    0.326989] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:04:00.0: Boot video device
[    0.326997] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.326997] assign_interrupt_mode Found MSI capability
[    0.326997] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.327004] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.327004] assign_interrupt_mode Found MSI capability
[    0.327004] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.327011] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.327011] assign_interrupt_mode Found MSI capability
[    0.327011] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.327017] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.327017] assign_interrupt_mode Found MSI capability
[    0.327017] Allocate Port Service[0000:00:0e.0:pcie00]
[    0.327058] input: Power Button (FF) as /class/input/input0
[    0.327058] ACPI: Power Button (FF) [PWRF]
[    0.327064] input: Power Button (CM) as /class/input/input1
[    0.327064] ACPI: Power Button (CM) [PWRB]
[    0.327097] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.327104] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.363785] Real Time Clock Driver v1.12ac
[    0.363789] hpet_resources: 0xfed00000 is busy
[    0.363796] Linux agpgart interface v0.103
[    0.363815] Driver 'sd' needs updating - please use bus_type methods
[    0.363828] ahci 0000:00:0a.0: version 3.0
[    0.363828] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.363828] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
 (level, low) -> IRQ 23
[    0.363828] ------------[ cut here ]------------
[    0.363828] WARNING: at drivers/ata/ahci.c:645 ahci_init_one+0x190/0xa3a=
()
[    0.363828] Modules linked in:
[    0.363828] Pid: 1, comm: swapper Not tainted 2.6.25-rc8 #2
[    0.363828]=20
[    0.363828] Call Trace:
[    0.363828]  [<ffffffff8022c5a5>] warn_on_slowpath+0x51/0x63
[    0.363832]  [<ffffffff80220061>] __ioremap+0x8/0x197
[    0.363872]  [<ffffffff803921f4>] pci_conf1_read+0xb2/0xbd
[    0.363911]  [<ffffffff802f3316>] pcim_iomap_release+0x0/0x2c
[    0.363950]  [<ffffffff802f3316>] pcim_iomap_release+0x0/0x2c
[    0.363989]  [<ffffffff803471a9>] devres_find+0x4b/0x65
[    0.364028]  [<ffffffff8036e4cd>] ahci_init_one+0x190/0xa3a
[    0.364067]  [<ffffffff802af837>] sysfs_addrm_finish+0x1d/0x209
[    0.364107]  [<ffffffff80284014>] ifind+0x34/0x8d
[    0.364145]  [<ffffffff802af54e>] sysfs_find_dirent+0x1b/0x2f
[    0.364184]  [<ffffffff802eb75d>] ida_get_new_above+0xf0/0x180
[    0.364223]  [<ffffffff802af837>] sysfs_addrm_finish+0x1d/0x209
[    0.364263]  [<ffffffff802b0378>] sysfs_create_link+0xb6/0x102
[    0.364303]  [<ffffffff802f8664>] pci_device_probe+0x4c/0x72
[    0.364342]  [<ffffffff80344c48>] driver_probe_device+0xb5/0x132
[    0.364381]  [<ffffffff80344ddb>] __driver_attach+0x6f/0xaf
[    0.364419]  [<ffffffff80344d6c>] __driver_attach+0x0/0xaf
[    0.364458]  [<ffffffff80344d6c>] __driver_attach+0x0/0xaf
[    0.364498]  [<ffffffff8034400a>] bus_for_each_dev+0x44/0x6f
[    0.364538]  [<ffffffff802a9b57>] proc_match+0x23/0x2d
[    0.364576]  [<ffffffff80344876>] bus_add_driver+0xae/0x1f4
[    0.364614]  [<ffffffff8034500a>] driver_register+0x59/0xce
[    0.364654]  [<ffffffff802f88a5>] __pci_register_driver+0x4a/0x7d
[    0.364701]  [<ffffffff804e56b8>] kernel_init+0x14f/0x2b9
[    0.364740]  [<ffffffff8020be98>] child_rip+0xa/0x12
[    0.364779]  [<ffffffff804e5569>] kernel_init+0x0/0x2b9
[    0.364817]  [<ffffffff8020be8e>] child_rip+0x0/0x12
[    0.364854]=20
[    0.364891] ---[ end trace ea9d541113ecaf1e ]---
[    1.370495] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f impl SATA mode
[    1.370495] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio=20
[    1.370495] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.370495] scsi0 : ahci
[    1.370506] scsi1 : ahci
[    1.370515] scsi2 : ahci
[    1.370524] scsi3 : ahci
[    1.370531] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0 irq 23
[    1.370531] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0 irq 23
[    1.370531] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0 irq 23
[    1.370531] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0 irq 23
[    1.806588] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.807084] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[    1.807084] ata1.00: 312581808 sectors, multi 16: LBA48=20
[    1.807625] ata1.00: configured for UDMA/133
[    2.440038] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.460530] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.460530] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.462446] ata2.00: configured for UDMA/133
[    2.779686] ata3: SATA link down (SStatus 0 SControl 300)
[    3.099550] ata4: SATA link down (SStatus 0 SControl 300)
[    3.298509] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0 PQ: 0 ANSI: 5
[    3.298522] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2 MB)
[    3.298522] sd 0:0:0:0: [sda] Write Protect is off
[    3.298522] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.298522] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.298522] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2 MB)
[    3.298522] sd 0:0:0:0: [sda] Write Protect is off
[    3.298522] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.298522] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.298522]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.132136] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.132147] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.132158] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10 PQ: 0 ANSI: 5
[    3.132158] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8 MB)
[    3.132158] sd 1:0:0:0: [sdb] Write Protect is off
[    3.132158] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.132158] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.132158] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8 MB)
[    3.132158] sd 1:0:0:0: [sdb] Write Protect is off
[    3.132158] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.132158] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.132158]  sdb: sdb1 sdb2
[    3.195925] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.195935] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.195955] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x6=
4 irq 1,12
[    3.196343] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.196383] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.226067] usbcore: registered new interface driver usbhid
[    3.226067] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    3.226067] TCP cubic registered
[    3.226067] NET: Registered protocol family 1
[    3.226072] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processo=
r 6000+ processors (2 cpu cores) (version 2.20.00)
[    3.425640] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[    3.425640] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[    3.425640] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[    3.425640] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[    3.425640] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[    3.425640] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[    3.425640] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[    3.425640] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    3.256943] input: AT Translated Set 2 keyboard as /class/input/input2
[    3.356887] ReiserFS: sda3: found reiserfs format "3.6" with standard jo=
urnal
[    3.356887] ReiserFS: sda3: using ordered data mode
[    3.368295] ReiserFS: sda3: journal params: device sda3, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[    3.368295] ReiserFS: sda3: checking transaction log (sda3)
[    3.411588] ReiserFS: sda3: Using r5 hash to sort names
[    3.411588] VFS: Mounted root (reiserfs filesystem) readonly.
[    3.411588] Freeing unused kernel memory: 192k freed
[    4.022298] Clocksource tsc unstable (delta =3D -141982313 ns)
[    8.607958] ReiserFS: sda3: switching to journaled data mode
[    8.961712] r8169 Gigabit Ethernet driver 2.2LK loaded
[    8.961947] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[    8.961952] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19=
 (level, low) -> IRQ 19
[    8.961960] PCI: Setting latency timer of device 0000:01:00.0 to 64
[    8.961969] r8169 0000:01:00.0: no MSI. Back to INTx.
[    8.964900] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:c=
b, XID 38000000 IRQ 19
[    8.981596] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    8.981596] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22=
 (level, low) -> IRQ 22
[    8.981596] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    8.981596] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    8.981617] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1
[    8.981639] ehci_hcd 0000:00:02.1: debug port 1
[    8.981642] PCI: cache line size of 64 is not supported by device 0000:0=
0:02.1
[    8.981649] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[    8.994942] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    8.994942] usb usb1: configuration #1 chosen from 1 choice
[    8.994942] hub 1-0:1.0: USB hub found
[    8.994942] hub 1-0:1.0: 10 ports detected
[    9.413400] usb 1-3: new high speed USB device using ehci_hcd and addres=
s 2
[    9.494126] usb 1-3: configuration #1 chosen from 1 choice
[    9.494126] hub 1-3:1.0: USB hub found
[    9.494201] hub 1-3:1.0: 4 ports detected
[    9.623768] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 ac=
ross:1951888k
[    9.820999] usb 1-3.1: new low speed USB device using ehci_hcd and addre=
ss 3
[    9.915859] usb 1-3.1: configuration #1 chosen from 1 choice
[    9.925950] input: Logitech USB Receiver as /class/input/input3
[   10.088175] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-00=
00:00:02.1-3.1
[   10.092051] input: Logitech USB Receiver as /class/input/input4
[   10.165322] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0=
000:00:02.1-3.1
[   10.272835] mice: PS/2 mouse device common for all mice
[   13.489248] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   13.491467] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18=
 (level, low) -> IRQ 18
[   13.494833] Audigy2 value: Special config.
[   17.056969] i2c /dev entries driver
[   17.121265] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[   17.121265] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[   17.324605] w83627ehf: Found W83627EHG chip at 0x290
[   18.452875] r8169: eth0: link up
[   18.521662] r8169: eth0: link up
[   19.665348] NET: Registered protocol family 17

--Boundary-00=_LH1/HQBIbZUHZo6
Content-Type: application/octet-stream;
  name="dmesg_2.6.25-rc8_nonraid"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg_2.6.25-rc8_nonraid"

[    0.000000] Linux version 2.6.25-rc8 (root@energy) (gcc version 4.2.3 (G=
entoo 4.2.3 p1.0)) #2 SMP Fri Apr 11 13:26:53 CEST 2008
[    0.000000] Command line: root=3D/dev/sda3 nmi_watchdog=3D0 console=3Dtt=
y6=90=A8=01
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of =
256 used
[    0.000000] end_pfn_map =3D 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT =
      97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT =
      97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL =
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT =
      97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT =
      97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT =
      97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT =
      97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD  =
       1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of =
256 used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-54e213] TEXT DATA BSS
[    0.000000] early res: 3 [9fc00-a0bff] EBDA
[    0.000000] early res: 4 [8000-dfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 =
on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 =
on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 =
on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 =
on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 =
on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 =
on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 =
on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 =
on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 =
on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 =
on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 =
on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 =
on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 =
on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 =
on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 =
on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 =
on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 =
on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 =
on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 =
on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 =
on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 =
on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 =
on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 =
on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 =
on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 =
on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 =
on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 =
on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 =
on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 =
on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 =
on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 =
on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 =
on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 =
on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 =
on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 856 pages reserved
[    0.000000]   DMA zone: 3087 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 00000000cff=
c0000
[    0.000000] PM: Registered nosave memory: 00000000cffc0000 - 00000000cff=
f0000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 00000000d00=
00000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec=
01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee=
00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef=
00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ff3=
80000
[    0.000000] PM: Registered nosave memory: 00000000ff380000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000=
:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 32584 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 1030519
[    0.000000] Kernel command line: root=3D/dev/sda3 nmi_watchdog=3D0 conso=
le=3Dtty6=90=A8=01
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000002] time.c: Detected 3013.883 MHz processor.
[    0.000011] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty6] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.003333] Checking aperture...
[    0.003333] Node 0: aperture @ c000000 size 32 MB
[    0.003333] Aperture pointing to e820 RAM. Ignoring.
[    0.003333] No AGP bridge found
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ c000000
[    0.003333] PM: Registered nosave memory: 000000000c000000 - 00000000100=
00000
[    0.003333] Memory: 4047752k/4980736k available (1994k kernel code, 1451=
36k reserved, 866k data, 192k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D2, Nodes=3D1
[    0.003333] hpet clockevent registered
[    0.083330] Calibrating delay using timer specific routine.. 6034.74 Bog=
oMIPS (lpj=3D10053996)
[    0.083419] Mount-cache hash table entries: 256
[    0.083538] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.083578] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.083616] CPU: Physical Processor ID: 0
[    0.083652] CPU: Processor Core ID: 0
[    0.083701] ACPI: Core revision 20070126
[    0.122313] Using local APIC timer interrupts.
[    0.123326] APIC timer calibration result 12557884
[    0.123327] Detected 12.557 MHz APIC timer.
[    0.123429] Booting processor 1/2 APIC 0x1
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6030.96 Bog=
oMIPS (lpj=3D10046340)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.216840] Brought up 2 CPUs
[    0.217287] net_namespace: 296 bytes
[    0.217406] NET: Registered protocol family 16
[    0.217503] No dock devices found.
[    0.217564] ACPI: bus type pci registered
[    0.217641] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.217680] PCI: Not using MMCONFIG.
[    0.217717] PCI: Using configuration type 1
[    0.220764] ACPI: EC: Look up EC in DSDT
[    0.225384] ACPI: Interpreter enabled
[    0.225421] ACPI: (supports S0 S1 S3 S4 S5)
[    0.225592] ACPI: Using IOAPIC for interrupt routing
[    0.225774] ACPI: Error attaching device data
[    0.225815] ACPI: Error attaching device data
[    0.225855] ACPI: Error attaching device data
[    0.225895] ACPI: Error attaching device data
[    0.232202] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.232716] PCI: Transparent bridge - 0000:00:08.0
[    0.232967] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.233319] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.233435] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.233501] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.233567] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.233633] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.238119] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    0.238481] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.238841] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disab=
led.
[    0.239227] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disab=
led.
[    0.239613] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disab=
led.
[    0.240130] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.240490] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disab=
led.
[    0.240876] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.241236] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[    0.241596] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disab=
led.
[    0.241985] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.242346] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disab=
led.
[    0.242733] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disab=
led.
[    0.243120] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.243496] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disab=
led.
[    0.243884] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[    0.244245] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disab=
led.
[    0.244658] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disab=
led.
[    0.245046] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disab=
led.
[    0.245433] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disab=
led.
[    0.245761] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.245809] pnp: PnP ACPI init
[    0.245848] ACPI: bus type pnp registered
[    0.248987] pnp: PnP ACPI: found 13 devices
[    0.249024] ACPI: ACPI bus type pnp unregistered
[    0.249127] SCSI subsystem initialized
[    0.249201] libata version 3.00 loaded.
[    0.249239] usbcore: registered new interface driver usbfs
[    0.249290] usbcore: registered new interface driver hub
[    0.249344] usbcore: registered new device driver usb
[    0.249422] PCI: Using ACPI for IRQ routing
[    0.249460] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[    0.266649] PCI-DMA: Disabling AGP.
[    0.266649] PCI-DMA: aperture base @ c000000 size 65536 KB
[    0.266649] PCI-DMA: using GART IOMMU.
[    0.266649] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.266649] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.266649] hpet0: 3 32-bit timers, 25000000 Hz
[    0.266659] Switched to high resolution mode on CPU 0
[    0.063372] Switched to high resolution mode on CPU 1
[    0.280019] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.280019] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.280019] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.280019] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.280019] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.280019] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.280019] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.280019] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.280019] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.280019] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.280022] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.280062] system 00:05: iomem range 0xfee01000-0xfeefffff has been res=
erved
[    0.280107] system 00:07: iomem range 0xfec00000-0xfec00fff could not be=
 reserved
[    0.280154] system 00:07: iomem range 0xfee00000-0xfee00fff could not be=
 reserved
[    0.280206] system 00:0a: ioport range 0x290-0x29f has been reserved
[    0.280249] system 00:0b: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.280292] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.280331] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.280371] system 00:0c: iomem range 0xe0000-0xfffff could not be reser=
ved
[    0.280416] system 00:0c: iomem range 0x100000-0xcfffffff could not be r=
eserved
[    0.280464] system 00:0c: iomem range 0xff380000-0xffffffff could not be=
 reserved
[    0.280912] PCI: Bridge: 0000:00:08.0
[    0.280949]   IO window: d000-dfff
[    0.280987]   MEM window: 0xf9f00000-0xf9ffffff
[    0.281025]   PREFETCH window: 0x00000000f0000000-0x00000000f00fffff
[    0.281066] PCI: Bridge: 0000:00:0b.0
[    0.281102]   IO window: c000-cfff
[    0.281139]   MEM window: 0xf9e00000-0xf9efffff
[    0.281177]   PREFETCH window: disabled.
[    0.281214] PCI: Bridge: 0000:00:0c.0
[    0.281250]   IO window: disabled.
[    0.281287]   MEM window: disabled.
[    0.281323]   PREFETCH window: disabled.
[    0.281361] PCI: Bridge: 0000:00:0d.0
[    0.281398]   IO window: e000-efff
[    0.281434]   MEM window: 0xfa000000-0xfebfffff
[    0.281472]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.281512] PCI: Bridge: 0000:00:0e.0
[    0.281548]   IO window: disabled.
[    0.281585]   MEM window: disabled.
[    0.281621]   PREFETCH window: disabled.
[    0.281664] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    0.281673] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.281678] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.281683] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.281688] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.281695] NET: Registered protocol family 2
[    0.316684] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.316684] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.316684] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.316684] TCP: Hash tables configured (established 262144 bind 65536)
[    0.316684] TCP reno registered
[    0.326989] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    0.326989] io scheduler noop registered
[    0.326989] io scheduler cfq registered (default)
[    0.326989] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.326989] pci 0000:04:00.0: Boot video device
[    0.326997] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.326997] assign_interrupt_mode Found MSI capability
[    0.326997] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.327004] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.327004] assign_interrupt_mode Found MSI capability
[    0.327004] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.327011] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.327011] assign_interrupt_mode Found MSI capability
[    0.327011] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.327017] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.327017] assign_interrupt_mode Found MSI capability
[    0.327017] Allocate Port Service[0000:00:0e.0:pcie00]
[    0.327058] input: Power Button (FF) as /class/input/input0
[    0.327058] ACPI: Power Button (FF) [PWRF]
[    0.327065] input: Power Button (CM) as /class/input/input1
[    0.327065] ACPI: Power Button (CM) [PWRB]
[    0.327097] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.327104] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.363809] Real Time Clock Driver v1.12ac
[    0.363813] hpet_resources: 0xfed00000 is busy
[    0.363820] Linux agpgart interface v0.103
[    0.363839] Driver 'sd' needs updating - please use bus_type methods
[    0.363852] ahci 0000:00:0a.0: version 3.0
[    0.363852] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.363852] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
 (level, low) -> IRQ 23
[    1.367186] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f impl IDE mode
[    1.367186] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio=20
[    1.367186] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.367186] scsi0 : ahci
[    1.367196] scsi1 : ahci
[    1.367205] scsi2 : ahci
[    1.367215] scsi3 : ahci
[    1.367222] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0 irq 315
[    1.367222] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0 irq 315
[    1.367222] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0 irq 315
[    1.367222] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0 irq 315
[    1.805203] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.805703] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[    1.805703] ata1.00: 312581808 sectors, multi 16: LBA48=20
[    1.806245] ata1.00: configured for UDMA/133
[    2.438148] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.446973] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.446973] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.448887] ata2.00: configured for UDMA/133
[    2.767796] ata3: SATA link down (SStatus 0 SControl 300)
[    3.087660] ata4: SATA link down (SStatus 0 SControl 300)
[    3.283879] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0 PQ: 0 ANSI: 5
[    3.283892] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2 MB)
[    3.283892] sd 0:0:0:0: [sda] Write Protect is off
[    3.283892] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.283892] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.283892] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2 MB)
[    3.283892] sd 0:0:0:0: [sda] Write Protect is off
[    3.283892] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.283892] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.283892]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.119376] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.119479] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.119612] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10 PQ: 0 ANSI: 5
[    3.119742] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8 MB)
[    3.119790] sd 1:0:0:0: [sdb] Write Protect is off
[    3.119828] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.119843] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.119921] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8 MB)
[    3.119968] sd 1:0:0:0: [sdb] Write Protect is off
[    3.120005] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.120020] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.120069]  sdb: sdb1 sdb2
[    3.128202] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.128213] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.128226] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x6=
4 irq 1,12
[    3.130473] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.130513] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.158253] usbcore: registered new interface driver usbhid
[    3.158253] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    3.158253] TCP cubic registered
[    3.158253] NET: Registered protocol family 1
[    3.158259] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processo=
r 6000+ processors (2 cpu cores) (version 2.20.00)
[    3.349195] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[    3.349195] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[    3.349195] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[    3.349195] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[    3.349195] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[    3.349195] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[    3.349195] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[    3.349195] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    3.189923] input: AT Translated Set 2 keyboard as /class/input/input2
[    3.289135] ReiserFS: sda3: found reiserfs format "3.6" with standard jo=
urnal
[    3.289179] ReiserFS: sda3: using ordered data mode
[    3.300193] ReiserFS: sda3: journal params: device sda3, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[    3.300193] ReiserFS: sda3: checking transaction log (sda3)
[    3.346227] ReiserFS: sda3: Using r5 hash to sort names
[    3.346227] VFS: Mounted root (reiserfs filesystem) readonly.
[    3.346227] Freeing unused kernel memory: 192k freed
[    3.954164] Clocksource tsc unstable (delta =3D -141984678 ns)
[    8.556079] ReiserFS: sda3: switching to journaled data mode
[    8.911115] r8169 Gigabit Ethernet driver 2.2LK loaded
[    8.911349] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[    8.911354] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19=
 (level, low) -> IRQ 19
[    8.911362] PCI: Setting latency timer of device 0000:01:00.0 to 64
[    8.911729] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:c=
b, XID 38000000 IRQ 314
[    8.957473] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    8.957478] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22=
 (level, low) -> IRQ 22
[    8.957486] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    8.957487] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    8.957554] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1
[    8.957577] ehci_hcd 0000:00:02.1: debug port 1
[    8.957579] PCI: cache line size of 64 is not supported by device 0000:0=
0:02.1
[    8.957587] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[    8.967141] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    8.967222] usb usb1: configuration #1 chosen from 1 choice
[    8.967238] hub 1-0:1.0: USB hub found
[    8.967244] hub 1-0:1.0: 10 ports detected
[    9.317253] usb 1-3: new high speed USB device using ehci_hcd and addres=
s 2
[    9.465010] usb 1-3: configuration #1 chosen from 1 choice
[    9.465270] hub 1-3:1.0: USB hub found
[    9.465472] hub 1-3:1.0: 4 ports detected
[    9.592382] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 ac=
ross:1951888k
[    9.784528] usb 1-3.1: new low speed USB device using ehci_hcd and addre=
ss 3
[    9.872170] usb 1-3.1: configuration #1 chosen from 1 choice
[    9.891580] input: Logitech USB Receiver as /class/input/input3
[   10.334405] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-00=
00:00:02.1-3.1
[   10.341080] input: Logitech USB Receiver as /class/input/input4
[   10.414407] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0=
000:00:02.1-3.1
[   10.494408] mice: PS/2 mouse device common for all mice
[   13.300230] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   13.300237] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18=
 (level, low) -> IRQ 18
[   13.303384] Audigy2 value: Special config.
[   15.787369] i2c /dev entries driver
[   15.934662] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[   15.935466] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[   16.120481] w83627ehf: Found W83627EHG chip at 0x290
[   17.565704] r8169: eth0: link up
[   17.565710] r8169: eth0: link up
[   18.794858] NET: Registered protocol family 17

--Boundary-00=_LH1/HQBIbZUHZo6
Content-Type: application/octet-stream;
  name="dmesg_2.6.25-rc8_nonraid_nomsi"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg_2.6.25-rc8_nonraid_nomsi"

[    0.000000] Linux version 2.6.25-rc8 (root@energy) (gcc version 4.2.3 (G=
entoo 4.2.3 p1.0)) #2 SMP Fri Apr 11 13:26:53 CEST 2008
[    0.000000] Command line: pci=3Dnomsi root=3D/dev/sda3 nmi_watchdog=3D0 =
console=3Dtty6=89
[    0.000000] H=89=B0=A8=01
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of =
256 used
[    0.000000] end_pfn_map =3D 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT =
      97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT =
      97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL =
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT =
      97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT =
      97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT =
      97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT =
      97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD  =
       1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of =
256 used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-54e213] TEXT DATA BSS
[    0.000000] early res: 3 [9fc00-a0bff] EBDA
[    0.000000] early res: 4 [8000-dfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 =
on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 =
on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 =
on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 =
on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 =
on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 =
on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 =
on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 =
on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 =
on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 =
on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 =
on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 =
on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 =
on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 =
on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 =
on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 =
on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 =
on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 =
on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 =
on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 =
on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 =
on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 =
on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 =
on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 =
on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 =
on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 =
on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 =
on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 =
on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 =
on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 =
on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 =
on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 =
on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 =
on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 =
on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 856 pages reserved
[    0.000000]   DMA zone: 3087 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 00000000cff=
c0000
[    0.000000] PM: Registered nosave memory: 00000000cffc0000 - 00000000cff=
f0000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 00000000d00=
00000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec=
01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee=
00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef=
00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ff3=
80000
[    0.000000] PM: Registered nosave memory: 00000000ff380000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000=
:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 32584 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 1030519
[    0.000000] Kernel command line: pci=3Dnomsi root=3D/dev/sda3 nmi_watchd=
og=3D0 console=3Dtty6=89
[    0.000000] H=89=B0=A8=01
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000002] time.c: Detected 3013.888 MHz processor.
[    0.000011] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty6] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.003333] Checking aperture...
[    0.003333] Node 0: aperture @ c000000 size 32 MB
[    0.003333] Aperture pointing to e820 RAM. Ignoring.
[    0.003333] No AGP bridge found
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ c000000
[    0.003333] PM: Registered nosave memory: 000000000c000000 - 00000000100=
00000
[    0.003333] Memory: 4047752k/4980736k available (1994k kernel code, 1451=
36k reserved, 866k data, 192k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D2, Nodes=3D1
[    0.003333] hpet clockevent registered
[    0.083330] Calibrating delay using timer specific routine.. 6034.75 Bog=
oMIPS (lpj=3D10054001)
[    0.083419] Mount-cache hash table entries: 256
[    0.083538] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.083578] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.083616] CPU: Physical Processor ID: 0
[    0.083653] CPU: Processor Core ID: 0
[    0.083702] ACPI: Core revision 20070126
[    0.122314] Using local APIC timer interrupts.
[    0.123326] APIC timer calibration result 12557905
[    0.123327] Detected 12.557 MHz APIC timer.
[    0.123429] Booting processor 1/2 APIC 0x1
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6030.96 Bog=
oMIPS (lpj=3D10046336)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.216840] Brought up 2 CPUs
[    0.217286] net_namespace: 296 bytes
[    0.217406] NET: Registered protocol family 16
[    0.217503] No dock devices found.
[    0.217564] ACPI: bus type pci registered
[    0.217641] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.217680] PCI: Not using MMCONFIG.
[    0.217717] PCI: Using configuration type 1
[    0.220763] ACPI: EC: Look up EC in DSDT
[    0.225384] ACPI: Interpreter enabled
[    0.225421] ACPI: (supports S0 S1 S3 S4 S5)
[    0.225592] ACPI: Using IOAPIC for interrupt routing
[    0.225774] ACPI: Error attaching device data
[    0.225814] ACPI: Error attaching device data
[    0.225855] ACPI: Error attaching device data
[    0.225895] ACPI: Error attaching device data
[    0.232199] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.232713] PCI: Transparent bridge - 0000:00:08.0
[    0.232964] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.233122] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.233430] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.233496] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.233562] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.233628] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.238112] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    0.238473] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.238833] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disab=
led.
[    0.239219] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disab=
led.
[    0.239605] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disab=
led.
[    0.240130] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.240490] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disab=
led.
[    0.240876] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.241235] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[    0.241596] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disab=
led.
[    0.241984] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.242344] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disab=
led.
[    0.242731] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disab=
led.
[    0.243118] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.243496] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disab=
led.
[    0.243883] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[    0.244244] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disab=
led.
[    0.244657] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disab=
led.
[    0.245044] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disab=
led.
[    0.245431] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disab=
led.
[    0.245758] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.245806] pnp: PnP ACPI init
[    0.245845] ACPI: bus type pnp registered
[    0.248973] pnp: PnP ACPI: found 13 devices
[    0.249010] ACPI: ACPI bus type pnp unregistered
[    0.249114] SCSI subsystem initialized
[    0.249187] libata version 3.00 loaded.
[    0.249225] usbcore: registered new interface driver usbfs
[    0.249276] usbcore: registered new interface driver hub
[    0.249331] usbcore: registered new device driver usb
[    0.249409] PCI: Using ACPI for IRQ routing
[    0.249447] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[    0.266649] PCI-DMA: Disabling AGP.
[    0.266649] PCI-DMA: aperture base @ c000000 size 65536 KB
[    0.266649] PCI-DMA: using GART IOMMU.
[    0.266649] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.266649] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.266649] hpet0: 3 32-bit timers, 25000000 Hz
[    0.266659] Switched to high resolution mode on CPU 0
[    0.063372] Switched to high resolution mode on CPU 1
[    0.280018] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.280018] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.280018] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.280018] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.280018] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.280018] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.280021] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.280060] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.280100] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.280139] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.280179] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.280219] system 00:05: iomem range 0xfee01000-0xfeefffff has been res=
erved
[    0.280263] system 00:07: iomem range 0xfec00000-0xfec00fff could not be=
 reserved
[    0.280311] system 00:07: iomem range 0xfee00000-0xfee00fff could not be=
 reserved
[    0.280362] system 00:0a: ioport range 0x290-0x29f has been reserved
[    0.280405] system 00:0b: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.280448] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.280488] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.280528] system 00:0c: iomem range 0xe0000-0xfffff could not be reser=
ved
[    0.280571] system 00:0c: iomem range 0x100000-0xcfffffff could not be r=
eserved
[    0.280619] system 00:0c: iomem range 0xff380000-0xffffffff could not be=
 reserved
[    0.281067] PCI: Bridge: 0000:00:08.0
[    0.281105]   IO window: d000-dfff
[    0.281142]   MEM window: 0xf9f00000-0xf9ffffff
[    0.281180]   PREFETCH window: 0x00000000f0000000-0x00000000f00fffff
[    0.281221] PCI: Bridge: 0000:00:0b.0
[    0.281258]   IO window: c000-cfff
[    0.281294]   MEM window: 0xf9e00000-0xf9efffff
[    0.281332]   PREFETCH window: disabled.
[    0.281369] PCI: Bridge: 0000:00:0c.0
[    0.281405]   IO window: disabled.
[    0.281442]   MEM window: disabled.
[    0.281479]   PREFETCH window: disabled.
[    0.281516] PCI: Bridge: 0000:00:0d.0
[    0.281553]   IO window: e000-efff
[    0.281590]   MEM window: 0xfa000000-0xfebfffff
[    0.281627]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.281667] PCI: Bridge: 0000:00:0e.0
[    0.281703]   IO window: disabled.
[    0.281740]   MEM window: disabled.
[    0.281776]   PREFETCH window: disabled.
[    0.281819] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    0.281828] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.281833] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.281838] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.281843] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.281850] NET: Registered protocol family 2
[    0.316683] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.316683] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.316683] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.316683] TCP: Hash tables configured (established 262144 bind 65536)
[    0.316683] TCP reno registered
[    0.326987] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    0.326987] io scheduler noop registered
[    0.326987] io scheduler cfq registered (default)
[    0.326987] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.326987] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.326987] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.326987] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.326987] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.326987] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.326987] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.326987] pci 0000:04:00.0: Boot video device
[    0.326995] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.326995] assign_interrupt_mode Found MSI capability
[    0.326995] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.327002] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.327002] assign_interrupt_mode Found MSI capability
[    0.327002] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.327009] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.327009] assign_interrupt_mode Found MSI capability
[    0.327009] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.327015] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.327015] assign_interrupt_mode Found MSI capability
[    0.327015] Allocate Port Service[0000:00:0e.0:pcie00]
[    0.327056] input: Power Button (FF) as /class/input/input0
[    0.327056] ACPI: Power Button (FF) [PWRF]
[    0.327062] input: Power Button (CM) as /class/input/input1
[    0.327062] ACPI: Power Button (CM) [PWRB]
[    0.327095] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.327102] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.360473] Real Time Clock Driver v1.12ac
[    0.360477] hpet_resources: 0xfed00000 is busy
[    0.360484] Linux agpgart interface v0.103
[    0.360504] Driver 'sd' needs updating - please use bus_type methods
[    0.360516] ahci 0000:00:0a.0: version 3.0
[    0.360516] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.360516] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
 (level, low) -> IRQ 23
[    1.363851] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f impl IDE mode
[    1.363851] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio=20
[    1.363851] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.363851] scsi0 : ahci
[    1.363861] scsi1 : ahci
[    1.363870] scsi2 : ahci
[    1.363879] scsi3 : ahci
[    1.363886] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0 irq 23
[    1.363886] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0 irq 23
[    1.363886] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0 irq 23
[    1.363886] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0 irq 23
[    1.801876] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.802364] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[    1.802364] ata1.00: 312581808 sectors, multi 16: LBA48=20
[    1.802910] ata1.00: configured for UDMA/133
[    2.434825] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.436701] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.436701] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.438610] ata2.00: configured for UDMA/133
[    2.757807] ata3: SATA link down (SStatus 0 SControl 300)
[    3.077671] ata4: SATA link down (SStatus 0 SControl 300)
[    3.273875] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0 PQ: 0 ANSI: 5
[    3.273887] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2 MB)
[    3.273887] sd 0:0:0:0: [sda] Write Protect is off
[    3.273887] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.273887] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.273887] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2 MB)
[    3.273887] sd 0:0:0:0: [sda] Write Protect is off
[    3.273887] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.273887] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.273887]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.111378] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.111389] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.111394] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10 PQ: 0 ANSI: 5
[    3.111405] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8 MB)
[    3.111405] sd 1:0:0:0: [sdb] Write Protect is off
[    3.111405] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.111405] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.111405] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8 MB)
[    3.111405] sd 1:0:0:0: [sdb] Write Protect is off
[    3.111405] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.111405] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.111405]  sdb: sdb1 sdb2
[    3.139178] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.139188] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.139195] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x6=
4 irq 1,12
[    3.140372] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.140413] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.169221] usbcore: registered new interface driver usbhid
[    3.169221] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    3.169221] TCP cubic registered
[    3.169221] NET: Registered protocol family 1
[    3.169226] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processo=
r 6000+ processors (2 cpu cores) (version 2.20.00)
[    3.364071] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[    3.364071] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[    3.364071] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[    3.364071] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[    3.364071] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[    3.364071] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[    3.364071] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[    3.364071] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    3.201064] input: AT Translated Set 2 keyboard as /class/input/input2
[    3.299015] ReiserFS: sda3: found reiserfs format "3.6" with standard jo=
urnal
[    3.299058] ReiserFS: sda3: using ordered data mode
[    3.310078] ReiserFS: sda3: journal params: device sda3, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[    3.310078] ReiserFS: sda3: checking transaction log (sda3)
[    3.355742] ReiserFS: sda3: Using r5 hash to sort names
[    3.355742] VFS: Mounted root (reiserfs filesystem) readonly.
[    3.355742] Freeing unused kernel memory: 192k freed
[    3.976100] Clocksource tsc unstable (delta =3D -130871149 ns)
[    8.496405] ReiserFS: sda3: switching to journaled data mode
[    8.839097] r8169 Gigabit Ethernet driver 2.2LK loaded
[    8.839331] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[    8.839337] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19=
 (level, low) -> IRQ 19
[    8.839345] PCI: Setting latency timer of device 0000:01:00.0 to 64
[    8.839354] r8169 0000:01:00.0: no MSI. Back to INTx.
[    8.850442] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:c=
b, XID 38000000 IRQ 19
[    8.859539] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    8.859545] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22=
 (level, low) -> IRQ 22
[    8.859552] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    8.859554] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    8.859618] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1
[    8.859640] ehci_hcd 0000:00:02.1: debug port 1
[    8.859642] PCI: cache line size of 64 is not supported by device 0000:0=
0:02.1
[    8.859649] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[    8.872727] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    8.872727] usb usb1: configuration #1 chosen from 1 choice
[    8.872727] hub 1-0:1.0: USB hub found
[    8.872727] hub 1-0:1.0: 10 ports detected
[    9.224776] usb 1-3: new high speed USB device using ehci_hcd and addres=
s 2
[    9.370997] usb 1-3: configuration #1 chosen from 1 choice
[    9.360611] hub 1-3:1.0: USB hub found
[    9.360611] hub 1-3:1.0: 4 ports detected
[    9.510544] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 ac=
ross:1951888k
[    9.708976] usb 1-3.1: new low speed USB device using ehci_hcd and addre=
ss 3
[    9.801972] usb 1-3.1: configuration #1 chosen from 1 choice
[    9.819151] input: Logitech USB Receiver as /class/input/input3
[   10.181957] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-00=
00:00:02.1-3.1
[   10.188650] input: Logitech USB Receiver as /class/input/input4
[   10.259567] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0=
000:00:02.1-3.1
[   10.298635] mice: PS/2 mouse device common for all mice
[   13.140500] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   13.140507] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18=
 (level, low) -> IRQ 18
[   13.143610] Audigy2 value: Special config.
[   15.435107] i2c /dev entries driver
[   15.616006] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[   15.616031] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[   15.785507] w83627ehf: Found W83627EHG chip at 0x290
[   17.141652] r8169: eth0: link up
[   17.272710] r8169: eth0: link up
[   18.511795] NET: Registered protocol family 17

--Boundary-00=_LH1/HQBIbZUHZo6--
