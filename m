Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbYE2PPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbYE2PPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYE2POy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:14:54 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:58540 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418AbYE2POt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:14:49 -0400
X-Greylist: delayed 1240 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2008 11:14:48 EDT
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Thu, 29 May 2008 16:54:03 +0200
User-Agent: KMail/1.9.9
Cc: Peer Chen <pchen@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804221444.55483.volker.armin.hemmann@tu-clausthal.de> <480DF1F5.3060208@gmail.com>
In-Reply-To: <480DF1F5.3060208@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LOsPIBoQcUY/J2h"
Message-Id: <200805291654.03617.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_LOsPIBoQcUY/J2h
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Since 2.6.26-rc4 is out, I updated the bios and replaced one harddisk I=20
think its time for a status report ;)

Bios is now version 2.10 from 05/12/2008
 (http://www.asrock.com/mb/download.asp?Model=3DALiveNF5-eSATA2%2b&s=3DAM2)

=2DAHCI+nomsi: boots fine. Works fine. But: I still can not enable ncq
=2DAHCI+msi: the usual. No harddisks found, waiting for the timeouts, then=
=20
kernel panic because of missing root.

=2DNON-RAID/IDE+msi: works fine. No delays. No NCQ (not surprising since mo=
bos=20
handbook says that AHCI mode is required).
=2DNON-RAID/IDE+nomsi: see above.

Attached are kernel config used, lspci outputs and dmesgs. lspci was done=20
straight after boot without the nvidia-module loaded. Kernel is patched wit=
h=20
reiser4.=20

One thing that confuses me is this:
echo 31 > /sys/block/sda/device/queue_depth
echo: write error: invalid argument

but:
[14315325.624510] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps=
=20
0xf impl SATA mode
[14315325.624559] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[14315325.624599] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[14315325.626674] scsi0 : ahci
[14315325.626674] scsi1 : ahci
[14315325.626674] scsi2 : ahci
[14315325.626674] scsi3 : ahci
[14315325.626674] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port=20
0xf9dfc100 irq 23
[14315325.626674] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port=20
0xf9dfc180 irq 23
[14315325.626674] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port=20
0xf9dfc200 irq 23
[14315325.626674] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port=20
0xf9dfc280 irq 23
[14315325.943951] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[14315325.950222] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
[14315325.950222] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/=
32)
[14315325.953942] ata1.00: configured for UDMA/133
[14315326.273949] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[14315326.286509] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[14315326.286509] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/=
32)
[14315326.286509] ata2.00: configured for UDMA/133

shouldn't controller and harddisks support turning on NCQ? The handbooks sa=
ys=20
that NCQ is supported in AHCI mode and the harddisks doesn't seem to be=20
blacklisted.

Gl=FCck Auf,
Volker

--Boundary-00=_LOsPIBoQcUY/J2h
Content-Type: text/plain;
  charset="iso-8859-15";
  name="dmesg_2.6.26_rc4_reiser_non_raid_coldboot"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg_2.6.26_rc4_reiser_non_raid_coldboot"

[    0.000000] Linux version 2.6.26-rc4 (root@energy) (gcc version 4.2.4 (G=
entoo 4.2.4 p1.0)) #1 SMP Thu May 29 04:02:44 CEST 2008
[    0.000000] Command line: root=3D/dev/sda3 nmi_watchdog=3D0=FF=FF=BF
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
[    0.000000] max_pfn_mapped =3D 1245184
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] init_memory_mapping
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98F0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT   4000809 MSFT =
      97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A M I  OEMFACP  12000601 MSFT =
      97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19201      201 INTL =
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC   4000809 MSFT =
      97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG   4000809 MSFT =
      97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM   4000809 MSFT =
      97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0  4000809 MSFT =
      97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD  =
       1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of =
256 used
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-59fa33] TEXT DATA BSS
[    0.000000]   early res: 3 [9fc00-fffff] BIOS reserved
[    0.000000]   early res: 4 [8000-dfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20002dfffff] PMD -> [ffff81000120000=
0-ffff810003ffffff] on node 0
[    0.000000]  [ffffe20002e00000-ffffe200043fffff] PMD -> [ffff81000c00000=
0-ffff81000d5fffff] on node 0
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
[    0.000000]   DMA zone: 1032 pages reserved
[    0.000000]   DMA zone: 2911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
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
[    0.000000] PERCPU: Allocating 33264 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2
[14315324.233334] Built 1 zonelists in Zone order, mobility grouping on.  T=
otal pages: 1030343
[14315324.233334] Kernel command line: root=3D/dev/sda3 nmi_watchdog=3D0=FF=
=FF=BF
[14315324.233334] Initializing CPU#0
[14315324.233334] PID hash table entries: 4096 (order: 12, 32768 bytes)
[14315324.233334] TSC calibrated against PM_TIMER
[14315324.233334] Marking TSC unstable due to TSCs unsynchronized
[14315324.233334] time.c: Detected 3013.886 MHz processor.
[14315324.233334] spurious 8259A interrupt: IRQ7.
[14315324.233334] Console: colour VGA+ 80x25
[14315324.233334] console [tty0] enabled
[14315324.233334] Dentry cache hash table entries: 524288 (order: 10, 41943=
04 bytes)
[14315324.233334] Inode-cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[14315324.233334] Checking aperture...
[14315324.233334] Node 0: aperture @ ecca000000 size 32 MB
[14315324.233334] Aperture beyond 4GB. Ignoring.
[14315324.233334] No AGP bridge found
[14315324.233334] Your BIOS doesn't leave a aperture memory hole
[14315324.233334] Please enable the IOMMU option in the BIOS setup
[14315324.233334] This costs you 64 MB of RAM
[14315324.233334] Mapping aperture over 65536 KB of RAM @ 4000000
[14315324.233334] PM: Registered nosave memory: 0000000004000000 - 00000000=
08000000
[14315324.233334] Memory: 4047800k/4980736k available (2232k kernel code, 1=
45356k reserved, 912k data, 204k init)
[14315324.233334] CPA: page pool initialized 1 of 1 pages preallocated
[14315324.233334] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObject=
s=3D0, CPUs=3D2, Nodes=3D1
[14315324.233334] hpet clockevent registered
[14315324.316485] Calibrating delay using timer specific routine.. 6034.80 =
BogoMIPS (lpj=3D10054083)
[14315324.316576] Mount-cache hash table entries: 256
[14315324.316662] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 byt=
es/line)
[14315324.316662] CPU: L2 Cache: 1024K (64 bytes/line)
[14315324.316662] CPU: Physical Processor ID: 0
[14315324.316662] CPU: Processor Core ID: 0
[14315324.316662] ACPI: Core revision 20080321
[14315324.353326] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ step=
ping 03
[14315324.353426] Using local APIC timer interrupts.
[14315324.359992] APIC timer calibration result 12557862
[14315324.359992] Detected 12.557 MHz APIC timer.
[14315324.360104] Booting processor 1/1 ip 6000
[14315324.360104] Initializing CPU#1
[14315324.360104] Calibrating delay using timer specific routine.. 6030.97 =
BogoMIPS (lpj=3D10046354)
[14315324.360104] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 byt=
es/line)
[14315324.360104] CPU: L2 Cache: 1024K (64 bytes/line)
[14315324.360104] CPU: Physical Processor ID: 0
[14315324.360104] CPU: Processor Core ID: 1
[14315324.360104] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060=
0070106
[14315324.453718] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ step=
ping 03
[14315324.454105] Brought up 2 CPUs
[14315324.454142] Total of 2 processors activated (12065.77 BogoMIPS).
[14315324.456653] net_namespace: 360 bytes
[14315324.456653] NET: Registered protocol family 16
[14315324.456653] No dock devices found.
[14315324.456653] node 0 link 0: io port [1000, ffffff]
[14315324.456653] node 0 link 0: io port [2000, 2fff]
[14315324.456653] TOM: 00000000d0000000 aka 3328M
[14315324.456653] node 0 link 0: mmio [e0000000, efffffff]
[14315324.456653] node 0 link 0: mmio [a0000, bffff]
[14315324.456653] node 0 link 0: mmio [d0000000, fe0bffff]
[14315324.456653] TOM2: 0000000130000000 aka 4864M
[14315324.456653] bus: [00,07] on node 0 link 0
[14315324.456653] bus: 00 index 0 io port: [0, ffff]
[14315324.456653] bus: 00 index 1 mmio: [d0000000, ffffffff]
[14315324.456653] bus: 00 index 2 mmio: [a0000, bffff]
[14315324.456653] bus: 00 index 3 mmio: [130000000, fcffffffff]
[14315324.456653] ACPI: bus type pci registered
[14315324.456653] PCI: MCFG configuration 0: base e0000000 segment 0 buses =
0 - 255
[14315324.456653] PCI: Not using MMCONFIG.
[14315324.456653] PCI: Using configuration type 1 for base access
[14315324.456653] ACPI: EC: Look up EC in DSDT
[14315324.463319] ACPI: Interpreter enabled
[14315324.463319] ACPI: (supports S0 S1 S3 S4 S5)
[14315324.463319] ACPI: Using IOAPIC for interrupt routing
[14315324.463319] PCI: MCFG configuration 0: base e0000000 segment 0 buses =
0 - 255
[14315324.467063] PCI: MCFG area at e0000000 reserved in ACPI motherboard r=
esources
[14315324.475560] PCI: Using MMCONFIG at e0000000 - efffffff
[14315324.483318] ACPI: PCI Root Bridge [PCI0] (0000:00)
[14315324.483318] PCI: Transparent bridge - 0000:00:08.0
[14315324.483318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[14315324.483318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[14315324.483318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[14315324.483394] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[14315324.483469] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[14315324.483543] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[14315324.489984] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[14315324.489984] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[14315324.489984] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, di=
sabled.
[14315324.489984] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, di=
sabled.
[14315324.489984] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, di=
sabled.
[14315324.490383] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[14315324.490746] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, di=
sabled.
[14315324.491144] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[14315324.491507] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[14315324.491871] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.492268] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[14315324.492632] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.493034] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.493317] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[14315324.493683] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.494079] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[14315324.494443] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.494868] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.495265] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.495662] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.496621] Linux Plug and Play Support v0.97 (c) Adam Belay
[14315324.496650] pnp: PnP ACPI init
[14315324.496650] ACPI: bus type pnp registered
[14315324.499983] pnp: PnP ACPI: found 13 devices
[14315324.503316] ACPI: ACPI bus type pnp unregistered
[14315324.503316] SCSI subsystem initialized
[14315324.503316] libata version 3.00 loaded.
[14315324.503316] usbcore: registered new interface driver usbfs
[14315324.503316] usbcore: registered new interface driver hub
[14315324.506649] usbcore: registered new device driver usb
[14315324.506649] PCI: Using ACPI for IRQ routing
[14315324.523315] PCI-DMA: Disabling AGP.
[14315324.523315] PCI-DMA: aperture base @ 4000000 size 65536 KB
[14315324.523315] PCI-DMA: using GART IOMMU.
[14315324.523315] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[14315324.523315] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[14315324.523315] hpet0: 3 32-bit timers, 25000000 Hz
[14315324.524232] Switched to high resolution mode on CPU 0
[14315324.524232] Switched to high resolution mode on CPU 1
[14315324.527599] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[14315324.527640] system 00:05: ioport range 0x800-0x80f has been reserved
[14315324.527680] system 00:05: ioport range 0x2000-0x207f has been reserved
[14315324.527720] system 00:05: ioport range 0x2080-0x20ff has been reserved
[14315324.527760] system 00:05: ioport range 0x2400-0x247f has been reserved
[14315324.527800] system 00:05: ioport range 0x2480-0x24ff has been reserved
[14315324.527840] system 00:05: ioport range 0x2800-0x287f has been reserved
[14315324.527880] system 00:05: ioport range 0x2880-0x28ff has been reserved
[14315324.527920] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[14315324.527960] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[14315324.528001] system 00:05: iomem range 0x0-0xffffffffffffffff could no=
t be reserved
[14315324.528050] system 00:05: iomem range 0xfee01000-0xfeefffff could not=
 be reserved
[14315324.528103] system 00:07: iomem range 0xfec00000-0xfec00fff could not=
 be reserved
[14315324.528152] system 00:07: iomem range 0xfee00000-0xfee00fff could not=
 be reserved
[14315324.528205] system 00:0a: ioport range 0x290-0x29f has been reserved
[14315324.528249] system 00:0b: iomem range 0xe0000000-0xefffffff has been =
reserved
[14315324.528301] system 00:0c: iomem range 0x0-0x9ffff could not be reserv=
ed
[14315324.528341] system 00:0c: iomem range 0xc0000-0xcffff has been reserv=
ed
[14315324.528381] system 00:0c: iomem range 0xe0000-0xfffff could not be re=
served
[14315324.528430] system 00:0c: iomem range 0x100000-0xcfffffff could not b=
e reserved
[14315324.528478] system 00:0c: iomem range 0xff380000-0xffffffff could not=
 be reserved
[14315324.530006] PCI: Bridge: 0000:00:08.0
[14315324.530006]   IO window: d000-dfff
[14315324.530006]   MEM window: 0xf9f00000-0xf9ffffff
[14315324.530006]   PREFETCH window: 0x00000000f0000000-0x00000000f00fffff
[14315324.530006] PCI: Bridge: 0000:00:0b.0
[14315324.530006]   IO window: c000-cfff
[14315324.530006]   MEM window: 0xf9e00000-0xf9efffff
[14315324.530006]   PREFETCH window: disabled.
[14315324.530006] PCI: Bridge: 0000:00:0c.0
[14315324.530006]   IO window: disabled.
[14315324.530006]   MEM window: disabled.
[14315324.530006]   PREFETCH window: disabled.
[14315324.530006] PCI: Bridge: 0000:00:0d.0
[14315324.530006]   IO window: e000-efff
[14315324.530006]   MEM window: 0xfa000000-0xfebfffff
[14315324.530006]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[14315324.530006] PCI: Bridge: 0000:00:0e.0
[14315324.530006]   IO window: disabled.
[14315324.530006]   MEM window: disabled.
[14315324.530006]   PREFETCH window: disabled.
[14315324.530006] PCI: Setting latency timer of device 0000:00:08.0 to 64
[14315324.530006] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[14315324.530006] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[14315324.530006] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[14315324.530006] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[14315324.530006] NET: Registered protocol family 2
[14315324.557696] IP route cache hash table entries: 131072 (order: 8, 1048=
576 bytes)
[14315324.558289] TCP established hash table entries: 262144 (order: 10, 41=
94304 bytes)
[14315324.559973] TCP bind hash table entries: 65536 (order: 8, 1048576 byt=
es)
[14315324.560006] TCP: Hash tables configured (established 262144 bind 6553=
6)
[14315324.560006] TCP reno registered
[14315324.567096] NET: Registered protocol family 1
[14315324.570006] Loading Reiser4. See www.namesys.com for a description of=
 Reiser4.
[14315324.570006] msgmni has been set to 7906 for ipc namespace ffffffff804=
f9180
[14315324.570006] Block layer SCSI generic (bsg) driver version 0.4 loaded =
(major 254)
[14315324.570006] io scheduler noop registered
[14315324.570006] io scheduler cfq registered (default)
[14315324.570006] pci 0000:00:00.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:08.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:0a.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:0b.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:0c.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:0d.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:0e.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:04:00.0: Boot video device
[14315324.570006] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[14315324.570006] assign_interrupt_mode Found MSI capability
[14315324.570006] Allocate Port Service[0000:00:0b.0:pcie00]
[14315324.570006] Allocate Port Service[0000:00:0b.0:pcie03]
[14315324.570006] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[14315324.570006] assign_interrupt_mode Found MSI capability
[14315324.570006] Allocate Port Service[0000:00:0c.0:pcie00]
[14315324.570006] Allocate Port Service[0000:00:0c.0:pcie03]
[14315324.570006] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[14315324.570006] assign_interrupt_mode Found MSI capability
[14315324.570006] Allocate Port Service[0000:00:0d.0:pcie00]
[14315324.570006] Allocate Port Service[0000:00:0d.0:pcie03]
[14315324.570006] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[14315324.570006] assign_interrupt_mode Found MSI capability
[14315324.570006] Allocate Port Service[0000:00:0e.0:pcie00]
[14315324.570006] Allocate Port Service[0000:00:0e.0:pcie03]
[14315324.570006] input: Power Button (FF) as /class/input/input0
[14315324.570006] ACPI: Power Button (FF) [PWRF]
[14315324.570006] input: Power Button (CM) as /class/input/input1
[14315324.570006] ACPI: Power Button (CM) [PWRB]
[14315324.573340] ACPI: ACPI0007:00 is registered as cooling_device0
[14315324.573340] ACPI: ACPI0007:01 is registered as cooling_device1
[14315324.606671] Real Time Clock Driver v1.12ac
[14315324.606671] hpet_resources: 0xfed00000 is busy
[14315324.606671] Linux agpgart interface v0.103
[14315324.606671] Driver 'sd' needs updating - please use bus_type methods
[14315324.606671] ahci 0000:00:0a.0: version 3.0
[14315324.606671] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[14315324.606671] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI=
 23 (level, low) -> IRQ 23
[14315325.606686] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps=
 0xf impl IDE mode
[14315325.606735] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio=20
[14315325.606775] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[14315325.610007] scsi0 : ahci
[14315325.610007] scsi1 : ahci
[14315325.610007] scsi2 : ahci
[14315325.610007] scsi3 : ahci
[14315325.610007] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9df=
c100 irq 315
[14315325.610007] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9df=
c180 irq 315
[14315325.610007] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9df=
c200 irq 315
[14315325.610007] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9df=
c280 irq 315
[14315325.927280] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[14315325.933553] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
[14315325.933553] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/=
32)
[14315325.937271] ata1.00: configured for UDMA/133
[14315326.258066] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[14315326.278501] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[14315326.278501] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/=
32)
[14315326.278501] ata2.00: configured for UDMA/133
[14315326.597278] ata3: SATA link down (SStatus 0 SControl 300)
[14315326.917278] ata4: SATA link down (SStatus 0 SControl 300)
[14315326.917278] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ =
 1AA0 PQ: 0 ANSI: 5
[14315326.917278] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (50=
0108 MB)
[14315326.917278] sd 0:0:0:0: [sda] Write Protect is off
[14315326.917278] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[14315326.917278] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
[14315326.917278] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (50=
0108 MB)
[14315326.917278] sd 0:0:0:0: [sda] Write Protect is off
[14315326.917278] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[14315326.917278] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
[14315326.917278]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[14315326.941437] sd 0:0:0:0: [sda] Attached SCSI disk
[14315326.941437] sd 0:0:0:0: Attached scsi generic sg0 type 0
[14315326.941437] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ =
 CR10 PQ: 0 ANSI: 5
[14315326.941437] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50=
0108 MB)
[14315326.941437] sd 1:0:0:0: [sdb] Write Protect is off
[14315326.941437] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[14315326.941437] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
[14315326.948122] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50=
0108 MB)
[14315326.948177] sd 1:0:0:0: [sdb] Write Protect is off
[14315326.948215] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[14315326.948232] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
[14315326.948282]  sdb: sdb1 sdb2
[14315327.009488] sd 1:0:0:0: [sdb] Attached SCSI disk
[14315327.009488] sd 1:0:0:0: Attached scsi generic sg1 type 0
[14315327.009488] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,=
0x64 irq 1,12
[14315327.012918] serio: i8042 KBD port at 0x60,0x64 irq 1
[14315327.012959] serio: i8042 AUX port at 0x60,0x64 irq 12
[14315327.041436] cpuidle: using governor ladder
[14315327.041436] cpuidle: using governor menu
[14315327.041436] usbcore: registered new interface driver usbhid
[14315327.041436] usbhid: v2.6:USB HID core driver
[14315327.041436] TCP cubic registered
[14315327.041436] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Proce=
ssor 6000+ processors (2 cpu cores) (version 2.20.00)
[14315327.041436] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[14315327.041436] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[14315327.041436] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[14315327.041436] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[14315327.041436] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[14315327.041436] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[14315327.041436] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[14315327.041436] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[14315327.061436] input: AT Translated Set 2 keyboard as /class/input/input2
[14315327.158140] reiser4: sda3: found disk format 4.0.0.
[14315328.731442] Clocksource tsc unstable (delta =3D -108742736 ns)
[14315332.661436] VFS: Mounted root (reiser4 filesystem) readonly.
[14315332.661436] Freeing unused kernel memory: 204k freed
[14315335.108134] Mem-info:
[14315335.108137] DMA per-cpu:
[14315335.108138] CPU    0: hi:    0, btch:   1 usd:   0
[14315335.108140] CPU    1: hi:    0, btch:   1 usd:   0
[14315335.108141] DMA32 per-cpu:
[14315335.108143] CPU    0: hi:  186, btch:  31 usd: 110
[14315335.108144] CPU    1: hi:  186, btch:  31 usd:   0
[14315335.108145] Normal per-cpu:
[14315335.108147] CPU    0: hi:  186, btch:  31 usd:  82
[14315335.108148] CPU    1: hi:  186, btch:  31 usd:  86
[14315335.108151] Active:2710 inactive:2495 dirty:0 writeback:0 unstable:0
[14315335.108152]  free:1002309 slab:1475 mapped:352 pagetables:443 bounce:0
[14315335.108154] DMA free:12420kB min:20kB low:24kB high:28kB active:0kB i=
nactive:0kB present:11644kB pages_scanned:0 all_unreclaimable? no
[14315335.108156] lowmem_reserve[]: 0 3255 4013 4013
[14315335.108160] DMA32 free:3249152kB min:6568kB low:8208kB high:9852kB ac=
tive:0kB inactive:0kB present:3334048kB pages_scanned:0 all_unreclaimable? =
no
[14315335.108162] lowmem_reserve[]: 0 0 757 757
[14315335.108165] Normal free:747664kB min:1528kB low:1908kB high:2292kB ac=
tive:10840kB inactive:9980kB present:775680kB pages_scanned:0 all_unreclaim=
able? no
[14315335.108167] lowmem_reserve[]: 0 0 0 0
[14315335.108169] DMA: 3*4kB 3*8kB 2*16kB 2*32kB 4*64kB 2*128kB 2*256kB 0*5=
12kB 1*1024kB 1*2048kB 2*4096kB =3D 12420kB
[14315335.108175] DMA32: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 2*256kB 3=
*512kB 1*1024kB 1*2048kB 792*4096kB =3D 3249152kB
[14315335.108180] Normal: 1*4kB 4*8kB 3*16kB 3*32kB 1*64kB 1*128kB 1*256kB =
3*512kB 2*1024kB 1*2048kB 181*4096kB =3D 747636kB
[14315335.108186] 3403 total pagecache pages
[14315335.108187] Swap cache: add 0, delete 0, find 0/0
[14315335.108188] Free swap  =3D 0kB
[14315335.108189] Total swap =3D 0kB
[14315335.111437] 1245184 pages of RAM
[14315335.111437] 233073 reserved pages
[14315335.111437] 6494 pages shared
[14315335.111437] 0 pages swap cached
[14315335.478135] r8169 Gigabit Ethernet driver 2.2LK loaded
[14315335.478388] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[14315335.478393] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI=
 19 (level, low) -> IRQ 19
[14315335.478401] PCI: Setting latency timer of device 0000:01:00.0 to 64
[14315335.478475] eth0: RTL8168b/8111b at 0xffffc2000005c000, 00:19:66:47:f=
3:cb, XID 38000000 IRQ 314
[14315335.518375] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[14315335.518375] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI=
 22 (level, low) -> IRQ 22
[14315335.518375] PCI: Setting latency timer of device 0000:00:02.1 to 64
[14315335.518375] ehci_hcd 0000:00:02.1: EHCI Host Controller
[14315335.518375] ehci_hcd 0000:00:02.1: new USB bus registered, assigned b=
us number 1
[14315335.518375] ehci_hcd 0000:00:02.1: debug port 1
[14315335.518375] PCI: cache line size of 64 is not supported by device 000=
0:00:02.1
[14315335.518375] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[14315335.528202] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver=
 10 Dec 2004
[14315335.528285] usb usb1: configuration #1 chosen from 1 choice
[14315335.528307] hub 1-0:1.0: USB hub found
[14315335.528313] hub 1-0:1.0: 10 ports detected
[14315335.861439] usb 1-4: new high speed USB device using ehci_hcd and add=
ress 2
[14315335.964771] reiser4: sdb2: found disk format 4.0.0.
[14315335.988104] usb 1-4: configuration #1 chosen from 1 choice
[14315335.988304] hub 1-4:1.0: USB hub found
[14315335.988392] hub 1-4:1.0: 4 ports detected
[14315336.278195] usb 1-4.1: new low speed USB device using ehci_hcd and ad=
dress 3
[14315336.367560] usb 1-4.1: configuration #1 chosen from 1 choice
[14315336.381887] input: Logitech USB Receiver as /class/input/input3
[14315336.404799] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb=
=2D0000:00:02.1-4.1
[14315336.414999] input: Logitech USB Receiver as /class/input/input4
[14315336.458131] input: USB HID v1.11 Device [Logitech USB Receiver] on us=
b-0000:00:02.1-4.1
[14315336.479020] mice: PS/2 mouse device common for all mice
[14315336.647391] usb 1-4.2: new high speed USB device using ehci_hcd and a=
ddress 4
[14315336.731414] usb 1-4.2: configuration #1 chosen from 1 choice
[14315336.768104] Initializing USB Mass Storage driver...
[14315336.770594] scsi4 : SCSI emulation for USB Mass Storage devices
[14315336.771438] usb-storage: device found at 4
[14315336.771438] usb-storage: waiting for device to settle before scanning
[14315336.771440] usbcore: registered new interface driver usb-storage
[14315336.771440] USB Mass Storage support registered.
[14315341.768103] scsi 4:0:0:0: Direct-Access     Generic  IC1210        CF=
 1.9C PQ: 0 ANSI: 0 CCS
[14315341.774771] sd 4:0:0:0: [sdc] Attached SCSI removable disk
[14315341.774771] sd 4:0:0:0: Attached scsi generic sg2 type 0
[14315341.778105] scsi 4:0:0:1: Direct-Access     Generic  IC1210        MS=
 1.9C PQ: 0 ANSI: 0 CCS
[14315341.788927] sd 4:0:0:1: [sdd] Attached SCSI removable disk
[14315341.791436] sd 4:0:0:1: Attached scsi generic sg3 type 0
[14315341.968103] scsi 4:0:0:2: Direct-Access     Generic  IC1210    MMC/SD=
 1.9C PQ: 0 ANSI: 0 CCS
[14315341.986615] sd 4:0:0:2: [sde] 122624 512-byte hardware sectors (63 MB)
[14315341.988689] sd 4:0:0:2: [sde] Write Protect is off
[14315341.988692] sd 4:0:0:2: [sde] Mode Sense: 4b 00 00 08
[14315341.988693] sd 4:0:0:2: [sde] Assuming drive cache: write through
[14315341.998729] sd 4:0:0:2: [sde] 122624 512-byte hardware sectors (63 MB)
[14315342.001911] sd 4:0:0:2: [sde] Write Protect is off
[14315342.001913] sd 4:0:0:2: [sde] Mode Sense: 4b 00 00 08
[14315342.001914] sd 4:0:0:2: [sde] Assuming drive cache: write through
[14315342.001916]  sde: sde1
[14315342.005017] sd 4:0:0:2: [sde] Attached SCSI removable disk
[14315342.005044] sd 4:0:0:2: Attached scsi generic sg4 type 0
[14315342.011484] scsi 4:0:0:3: Direct-Access     Generic  IC1210        SM=
 1.9C PQ: 0 ANSI: 0 CCS
[14315342.024769] sd 4:0:0:3: [sdf] Attached SCSI removable disk
[14315342.024769] sd 4:0:0:3: Attached scsi generic sg5 type 0
[14315342.024769] usb-storage: device scan complete
[14315361.064828] reiser4: sda5: found disk format 4.0.0.
[14315363.724769] reiser4: sdb1: found disk format 4.0.0.
[14315364.821826] Adding 4000176k swap on /dev/sda2.  Priority:-1 extents:1=
 across:4000176k
[14315365.571434] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[14315365.571434] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI=
 18 (level, low) -> IRQ 18
[14315365.572531] Audigy2 value: Special config.
[14315365.598378] r8169: eth0: link up
[14315365.598378] r8169: eth0: link up
[14315366.613262] i2c /dev entries driver
[14315366.688376] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[14315366.688376] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[14315367.078375] w83627ehf: Found W83627EHG chip at 0x290

--Boundary-00=_LOsPIBoQcUY/J2h
Content-Type: application/octet-stream;
  name="dmesg_2.6.26_rc4_reiser_ahci_nomsi"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg_2.6.26_rc4_reiser_ahci_nomsi"

[    0.000000] Linux version 2.6.26-rc4 (root@energy) (gcc version 4.2.4 (G=
entoo 4.2.4 p1.0)) #1 SMP Thu May 29 04:02:44 CEST 2008
[    0.000000] Command line: pci=3Dnomsi root=3D/dev/sda3 nmi_watchdog=3D0=
=F6A=89=D1H=89t$=18f=8Bu=18f=89t$ A=89=D0@=8Au=1A@=88t$"=89=D7@=8Au=1B@=88t=
$#@=8Au=1CD	=D1@=88t$$D	=C9D	=C1	=F9	=D1	=C1=EB=13=BA=20
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
[    0.000000] max_pfn_mapped =3D 1245184
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] init_memory_mapping
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98F0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT   4000809 MSFT =
      97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT =
      97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19201      201 INTL =
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC   4000809 MSFT =
      97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG   4000809 MSFT =
      97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM   4000809 MSFT =
      97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0  4000809 MSFT =
      97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD  =
       1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of =
256 used
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-59fa33] TEXT DATA BSS
[    0.000000]   early res: 3 [9fc00-fffff] BIOS reserved
[    0.000000]   early res: 4 [8000-dfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20002dfffff] PMD -> [ffff81000120000=
0-ffff810003ffffff] on node 0
[    0.000000]  [ffffe20002e00000-ffffe200043fffff] PMD -> [ffff81000c00000=
0-ffff81000d5fffff] on node 0
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
[    0.000000]   DMA zone: 1032 pages reserved
[    0.000000]   DMA zone: 2911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
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
[    0.000000] PERCPU: Allocating 33264 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2
[14315324.233334] Built 1 zonelists in Zone order, mobility grouping on.  T=
otal pages: 1030343
[14315324.233334] Kernel command line: pci=3Dnomsi root=3D/dev/sda3 nmi_wat=
chdog=3D0=F6A=89=D1H=89t$=18f=8Bu=18f=89t$ A=89=D0@=8Au=1A@=88t$"=89=D7@=8A=
u=1B@=88t$#@=8Au=1CD	=D1@=88t$$D	=C9D	=C1	=F9	=D1	=C1=EB=13=BA=20
[14315324.233334] Initializing CPU#0
[14315324.233334] PID hash table entries: 4096 (order: 12, 32768 bytes)
[14315324.233334] TSC calibrated against PM_TIMER
[14315324.233334] Marking TSC unstable due to TSCs unsynchronized
[14315324.233334] time.c: Detected 3013.892 MHz processor.
[14315324.233334] spurious 8259A interrupt: IRQ7.
[14315324.233334] Console: colour VGA+ 80x25
[14315324.233334] console [tty0] enabled
[14315324.233334] Dentry cache hash table entries: 524288 (order: 10, 41943=
04 bytes)
[14315324.233334] Inode-cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[14315324.233334] Checking aperture...
[14315324.233334] Node 0: aperture @ 4000000 size 32 MB
[14315324.233334] Aperture pointing to e820 RAM. Ignoring.
[14315324.233334] No AGP bridge found
[14315324.233334] Your BIOS doesn't leave a aperture memory hole
[14315324.233334] Please enable the IOMMU option in the BIOS setup
[14315324.233334] This costs you 64 MB of RAM
[14315324.233334] Mapping aperture over 65536 KB of RAM @ 4000000
[14315324.233334] PM: Registered nosave memory: 0000000004000000 - 00000000=
08000000
[14315324.233334] Memory: 4047800k/4980736k available (2232k kernel code, 1=
45356k reserved, 912k data, 204k init)
[14315324.233334] CPA: page pool initialized 1 of 1 pages preallocated
[14315324.233334] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObject=
s=3D0, CPUs=3D2, Nodes=3D1
[14315324.233334] hpet clockevent registered
[14315324.316485] Calibrating delay using timer specific routine.. 6034.79 =
BogoMIPS (lpj=3D10054068)
[14315324.316576] Mount-cache hash table entries: 256
[14315324.316662] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 byt=
es/line)
[14315324.316662] CPU: L2 Cache: 1024K (64 bytes/line)
[14315324.316662] CPU: Physical Processor ID: 0
[14315324.316662] CPU: Processor Core ID: 0
[14315324.316662] ACPI: Core revision 20080321
[14315324.353326] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ step=
ping 03
[14315324.353426] Using local APIC timer interrupts.
[14315324.359992] APIC timer calibration result 12557888
[14315324.359992] Detected 12.557 MHz APIC timer.
[14315324.360104] Booting processor 1/1 ip 6000
[14315324.360104] Initializing CPU#1
[14315324.360104] Calibrating delay using timer specific routine.. 6030.97 =
BogoMIPS (lpj=3D10046363)
[14315324.360104] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 byt=
es/line)
[14315324.360104] CPU: L2 Cache: 1024K (64 bytes/line)
[14315324.360104] CPU: Physical Processor ID: 0
[14315324.360104] CPU: Processor Core ID: 1
[14315324.360104] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060=
0070106
[14315324.453718] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ step=
ping 03
[14315324.454104] Brought up 2 CPUs
[14315324.454141] Total of 2 processors activated (12065.76 BogoMIPS).
[14315324.456653] net_namespace: 360 bytes
[14315324.456653] NET: Registered protocol family 16
[14315324.456653] No dock devices found.
[14315324.456653] node 0 link 0: io port [1000, ffffff]
[14315324.456653] node 0 link 0: io port [2000, 2fff]
[14315324.456653] TOM: 00000000d0000000 aka 3328M
[14315324.456653] node 0 link 0: mmio [e0000000, efffffff]
[14315324.456653] node 0 link 0: mmio [a0000, bffff]
[14315324.456653] node 0 link 0: mmio [d0000000, fe0bffff]
[14315324.456653] TOM2: 0000000130000000 aka 4864M
[14315324.456653] bus: [00,07] on node 0 link 0
[14315324.456653] bus: 00 index 0 io port: [0, ffff]
[14315324.456653] bus: 00 index 1 mmio: [d0000000, ffffffff]
[14315324.456653] bus: 00 index 2 mmio: [a0000, bffff]
[14315324.456653] bus: 00 index 3 mmio: [130000000, fcffffffff]
[14315324.456653] ACPI: bus type pci registered
[14315324.456653] PCI: MCFG configuration 0: base e0000000 segment 0 buses =
0 - 255
[14315324.456653] PCI: Not using MMCONFIG.
[14315324.456653] PCI: Using configuration type 1 for base access
[14315324.456653] ACPI: EC: Look up EC in DSDT
[14315324.463319] ACPI: Interpreter enabled
[14315324.463319] ACPI: (supports S0 S1 S3 S4 S5)
[14315324.463319] ACPI: Using IOAPIC for interrupt routing
[14315324.463319] PCI: MCFG configuration 0: base e0000000 segment 0 buses =
0 - 255
[14315324.467059] PCI: MCFG area at e0000000 reserved in ACPI motherboard r=
esources
[14315324.475555] PCI: Using MMCONFIG at e0000000 - efffffff
[14315324.483318] ACPI: PCI Root Bridge [PCI0] (0000:00)
[14315324.483318] PCI: Transparent bridge - 0000:00:08.0
[14315324.483318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[14315324.483318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[14315324.483318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[14315324.483393] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[14315324.483469] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[14315324.483543] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[14315324.489984] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[14315324.489984] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[14315324.489984] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, di=
sabled.
[14315324.489984] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, di=
sabled.
[14315324.489984] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, di=
sabled.
[14315324.490383] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[14315324.490745] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, di=
sabled.
[14315324.491141] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[14315324.491504] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[14315324.491868] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.492264] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[14315324.492627] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.493027] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.493317] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[14315324.493682] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.494078] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[14315324.494441] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.494865] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.495261] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.495658] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, di=
sabled.
[14315324.496618] Linux Plug and Play Support v0.97 (c) Adam Belay
[14315324.496650] pnp: PnP ACPI init
[14315324.499983] ACPI: bus type pnp registered
[14315324.503316] pnp: PnP ACPI: found 13 devices
[14315324.503316] ACPI: ACPI bus type pnp unregistered
[14315324.503316] SCSI subsystem initialized
[14315324.503316] libata version 3.00 loaded.
[14315324.503316] usbcore: registered new interface driver usbfs
[14315324.503316] usbcore: registered new interface driver hub
[14315324.503320] usbcore: registered new device driver usb
[14315324.506649] PCI: Using ACPI for IRQ routing
[14315324.519982] PCI-DMA: Disabling AGP.
[14315324.519982] PCI-DMA: aperture base @ 4000000 size 65536 KB
[14315324.519982] PCI-DMA: using GART IOMMU.
[14315324.519982] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[14315324.519982] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[14315324.519982] hpet0: 3 32-bit timers, 25000000 Hz
[14315324.520903] Switched to high resolution mode on CPU 0
[14315324.520903] Switched to high resolution mode on CPU 1
[14315324.527595] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[14315324.527636] system 00:05: ioport range 0x800-0x80f has been reserved
[14315324.527676] system 00:05: ioport range 0x2000-0x207f has been reserved
[14315324.527716] system 00:05: ioport range 0x2080-0x20ff has been reserved
[14315324.527756] system 00:05: ioport range 0x2400-0x247f has been reserved
[14315324.527796] system 00:05: ioport range 0x2480-0x24ff has been reserved
[14315324.527836] system 00:05: ioport range 0x2800-0x287f has been reserved
[14315324.527876] system 00:05: ioport range 0x2880-0x28ff has been reserved
[14315324.527916] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[14315324.527956] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[14315324.527997] system 00:05: iomem range 0x0-0xffffffffffffffff could no=
t be reserved
[14315324.528046] system 00:05: iomem range 0xfee01000-0xfeefffff could not=
 be reserved
[14315324.528099] system 00:07: iomem range 0xfec00000-0xfec00fff could not=
 be reserved
[14315324.528147] system 00:07: iomem range 0xfee00000-0xfee00fff could not=
 be reserved
[14315324.528200] system 00:0a: ioport range 0x290-0x29f has been reserved
[14315324.528245] system 00:0b: iomem range 0xe0000000-0xefffffff has been =
reserved
[14315324.528296] system 00:0c: iomem range 0x0-0x9ffff could not be reserv=
ed
[14315324.528336] system 00:0c: iomem range 0xc0000-0xcffff has been reserv=
ed
[14315324.528377] system 00:0c: iomem range 0xe0000-0xfffff could not be re=
served
[14315324.528425] system 00:0c: iomem range 0x100000-0xcfffffff could not b=
e reserved
[14315324.528473] system 00:0c: iomem range 0xff380000-0xffffffff could not=
 be reserved
[14315324.530006] PCI: Bridge: 0000:00:08.0
[14315324.530006]   IO window: d000-dfff
[14315324.530006]   MEM window: 0xf9f00000-0xf9ffffff
[14315324.530006]   PREFETCH window: 0x00000000f0000000-0x00000000f00fffff
[14315324.530006] PCI: Bridge: 0000:00:0b.0
[14315324.530006]   IO window: c000-cfff
[14315324.530006]   MEM window: 0xf9e00000-0xf9efffff
[14315324.530006]   PREFETCH window: disabled.
[14315324.530006] PCI: Bridge: 0000:00:0c.0
[14315324.530006]   IO window: disabled.
[14315324.530006]   MEM window: disabled.
[14315324.530006]   PREFETCH window: disabled.
[14315324.530006] PCI: Bridge: 0000:00:0d.0
[14315324.530006]   IO window: e000-efff
[14315324.530006]   MEM window: 0xfa000000-0xfebfffff
[14315324.530006]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[14315324.530006] PCI: Bridge: 0000:00:0e.0
[14315324.530006]   IO window: disabled.
[14315324.530006]   MEM window: disabled.
[14315324.530006]   PREFETCH window: disabled.
[14315324.530006] PCI: Setting latency timer of device 0000:00:08.0 to 64
[14315324.530006] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[14315324.530006] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[14315324.530006] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[14315324.530006] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[14315324.530006] NET: Registered protocol family 2
[14315324.557701] IP route cache hash table entries: 131072 (order: 8, 1048=
576 bytes)
[14315324.558294] TCP established hash table entries: 262144 (order: 10, 41=
94304 bytes)
[14315324.559982] TCP bind hash table entries: 65536 (order: 8, 1048576 byt=
es)
[14315324.560006] TCP: Hash tables configured (established 262144 bind 6553=
6)
[14315324.560006] TCP reno registered
[14315324.567093] NET: Registered protocol family 1
[14315324.570006] Loading Reiser4. See www.namesys.com for a description of=
 Reiser4.
[14315324.570006] msgmni has been set to 7906 for ipc namespace ffffffff804=
f9180
[14315324.570006] Block layer SCSI generic (bsg) driver version 0.4 loaded =
(major 254)
[14315324.570006] io scheduler noop registered
[14315324.570006] io scheduler cfq registered (default)
[14315324.570006] pci 0000:00:00.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:08.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:0a.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:0b.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:0c.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:0d.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:00:0e.0: Enabling HT MSI Mapping
[14315324.570006] pci 0000:04:00.0: Boot video device
[14315324.570006] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[14315324.570006] assign_interrupt_mode Found MSI capability
[14315324.570006] Allocate Port Service[0000:00:0b.0:pcie00]
[14315324.570006] Allocate Port Service[0000:00:0b.0:pcie03]
[14315324.570006] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[14315324.570006] assign_interrupt_mode Found MSI capability
[14315324.570006] Allocate Port Service[0000:00:0c.0:pcie00]
[14315324.570006] Allocate Port Service[0000:00:0c.0:pcie03]
[14315324.570006] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[14315324.570006] assign_interrupt_mode Found MSI capability
[14315324.570006] Allocate Port Service[0000:00:0d.0:pcie00]
[14315324.570006] Allocate Port Service[0000:00:0d.0:pcie03]
[14315324.570006] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[14315324.570006] assign_interrupt_mode Found MSI capability
[14315324.570006] Allocate Port Service[0000:00:0e.0:pcie00]
[14315324.570006] Allocate Port Service[0000:00:0e.0:pcie03]
[14315324.570006] input: Power Button (FF) as /class/input/input0
[14315324.570006] ACPI: Power Button (FF) [PWRF]
[14315324.570006] input: Power Button (CM) as /class/input/input1
[14315324.570006] ACPI: Power Button (CM) [PWRB]
[14315324.573339] ACPI: ACPI0007:00 is registered as cooling_device0
[14315324.573339] ACPI: ACPI0007:01 is registered as cooling_device1
[14315324.606671] Real Time Clock Driver v1.12ac
[14315324.606671] hpet_resources: 0xfed00000 is busy
[14315324.606671] Linux agpgart interface v0.103
[14315324.606671] Driver 'sd' needs updating - please use bus_type methods
[14315324.606671] ahci 0000:00:0a.0: version 3.0
[14315324.606671] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[14315324.606671] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI=
 23 (level, low) -> IRQ 23
[14315325.624510] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps=
 0xf impl SATA mode
[14315325.624559] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio=20
[14315325.624599] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[14315325.626674] scsi0 : ahci
[14315325.626674] scsi1 : ahci
[14315325.626674] scsi2 : ahci
[14315325.626674] scsi3 : ahci
[14315325.626674] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9df=
c100 irq 23
[14315325.626674] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9df=
c180 irq 23
[14315325.626674] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9df=
c200 irq 23
[14315325.626674] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9df=
c280 irq 23
[14315325.943951] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[14315325.950222] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
[14315325.950222] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/=
32)
[14315325.953942] ata1.00: configured for UDMA/133
[14315326.273949] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[14315326.286509] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[14315326.286509] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/=
32)
[14315326.286509] ata2.00: configured for UDMA/133
[14315326.607282] ata3: SATA link down (SStatus 0 SControl 300)
[14315326.927282] ata4: SATA link down (SStatus 0 SControl 300)
[14315326.927282] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ =
 1AA0 PQ: 0 ANSI: 5
[14315326.927282] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (50=
0108 MB)
[14315326.927282] sd 0:0:0:0: [sda] Write Protect is off
[14315326.927282] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[14315326.927282] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
[14315326.927282] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (50=
0108 MB)
[14315326.927282] sd 0:0:0:0: [sda] Write Protect is off
[14315326.927282] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[14315326.927282] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
[14315326.927282]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[14315326.954774] sd 0:0:0:0: [sda] Attached SCSI disk
[14315326.954774] sd 0:0:0:0: Attached scsi generic sg0 type 0
[14315326.954774] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ =
 CR10 PQ: 0 ANSI: 5
[14315326.961440] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50=
0108 MB)
[14315326.961440] sd 1:0:0:0: [sdb] Write Protect is off
[14315326.961440] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[14315326.961440] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
[14315326.961440] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50=
0108 MB)
[14315326.961440] sd 1:0:0:0: [sdb] Write Protect is off
[14315326.961440] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[14315326.961440] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
[14315326.961440]  sdb: sdb1 sdb2
[14315326.986900] sd 1:0:0:0: [sdb] Attached SCSI disk
[14315326.986900] sd 1:0:0:0: Attached scsi generic sg1 type 0
[14315326.986900] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,=
0x64 irq 1,12
[14315326.988198] serio: i8042 KBD port at 0x60,0x64 irq 1
[14315326.988198] serio: i8042 AUX port at 0x60,0x64 irq 12
[14315327.021441] cpuidle: using governor ladder
[14315327.021441] cpuidle: using governor menu
[14315327.021441] usbcore: registered new interface driver usbhid
[14315327.021441] usbhid: v2.6:USB HID core driver
[14315327.021441] TCP cubic registered
[14315327.021441] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Proce=
ssor 6000+ processors (2 cpu cores) (version 2.20.00)
[14315327.021441] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[14315327.021441] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[14315327.021441] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[14315327.021441] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[14315327.021441] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[14315327.021441] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[14315327.021441] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[14315327.021441] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[14315327.032204] input: AT Translated Set 2 keyboard as /class/input/input2
[14315327.138106] reiser4: sda3: found disk format 4.0.0.
[14315328.731449] Clocksource tsc unstable (delta =3D -108891423 ns)
[14315333.004774] VFS: Mounted root (reiser4 filesystem) readonly.
[14315333.012840] Freeing unused kernel memory: 204k freed
[14315335.854775] r8169 Gigabit Ethernet driver 2.2LK loaded
[14315335.854775] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[14315335.854775] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI=
 19 (level, low) -> IRQ 19
[14315335.854775] PCI: Setting latency timer of device 0000:01:00.0 to 64
[14315335.854775] r8169 0000:01:00.0: no MSI. Back to INTx.
[14315335.854775] eth0: RTL8168b/8111b at 0xffffc2000005c000, 00:19:66:47:f=
3:cb, XID 38000000 IRQ 19
[14315335.905856] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[14315335.905861] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI=
 22 (level, low) -> IRQ 22
[14315335.905870] PCI: Setting latency timer of device 0000:00:02.1 to 64
[14315335.905872] ehci_hcd 0000:00:02.1: EHCI Host Controller
[14315335.908191] ehci_hcd 0000:00:02.1: new USB bus registered, assigned b=
us number 1
[14315335.908214] ehci_hcd 0000:00:02.1: debug port 1
[14315335.908216] PCI: cache line size of 64 is not supported by device 000=
0:00:02.1
[14315335.908225] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[14315335.918117] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver=
 10 Dec 2004
[14315335.918203] usb usb1: configuration #1 chosen from 1 choice
[14315335.918225] hub 1-0:1.0: USB hub found
[14315335.918232] hub 1-0:1.0: 10 ports detected
[14315336.248127] usb 1-4: new high speed USB device using ehci_hcd and add=
ress 2
[14315336.381443] reiser4: sdb2: found disk format 4.0.0.
[14315336.383706] usb 1-4: configuration #1 chosen from 1 choice
[14315336.383891] hub 1-4:1.0: USB hub found
[14315336.384003] hub 1-4:1.0: 4 ports detected
[14315336.674855] usb 1-4.1: new low speed USB device using ehci_hcd and ad=
dress 3
[14315336.764229] usb 1-4.1: configuration #1 chosen from 1 choice
[14315336.778581] input: Logitech USB Receiver as /class/input/input3
[14315336.798137] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb=
=2D0000:00:02.1-4.1
[14315336.811443] input: Logitech USB Receiver as /class/input/input4
[14315336.851471] input: USB HID v1.11 Device [Logitech USB Receiver] on us=
b-0000:00:02.1-4.1
[14315336.861469] mice: PS/2 mouse device common for all mice
[14315337.041550] usb 1-4.2: new high speed USB device using ehci_hcd and a=
ddress 4
[14315337.128108] usb 1-4.2: configuration #1 chosen from 1 choice
[14315337.163542] Initializing USB Mass Storage driver...
[14315337.317399] usb 1-4.3: new full speed USB device using ehci_hcd and a=
ddress 5
[14315337.410833] usb 1-4.3: configuration #1 chosen from 2 choices
[14315337.431443] scsi4 : SCSI emulation for USB Mass Storage devices
[14315337.431443] usb-storage: device found at 4
[14315337.431443] usb-storage: waiting for device to settle before scanning
[14315337.431443] scsi5 : SCSI emulation for USB Mass Storage devices
[14315337.431448] usb-storage: device found at 5
[14315337.431448] usb-storage: waiting for device to settle before scanning
[14315337.434778] usbcore: registered new interface driver usb-storage
[14315337.434778] USB Mass Storage support registered.
[14315342.428601] scsi 4:0:0:0: Direct-Access     Generic  IC1210        CF=
 1.9C PQ: 0 ANSI: 0 CCS
[14315342.432509] sd 4:0:0:0: [sdc] Attached SCSI removable disk
[14315342.432537] sd 4:0:0:0: Attached scsi generic sg2 type 0
[14315342.435399] scsi 4:0:0:1: Direct-Access     Generic  IC1210        MS=
 1.9C PQ: 0 ANSI: 0 CCS
[14315342.448112] sd 4:0:0:1: [sdd] Attached SCSI removable disk
[14315342.448112] sd 4:0:0:1: Attached scsi generic sg3 type 0
[14315342.622431] scsi 4:0:0:2: Direct-Access     Generic  IC1210    MMC/SD=
 1.9C PQ: 0 ANSI: 0 CCS
[14315342.648325] sd 4:0:0:2: [sde] 122624 512-byte hardware sectors (63 MB)
[14315342.651506] sd 4:0:0:2: [sde] Write Protect is off
[14315342.651508] sd 4:0:0:2: [sde] Mode Sense: 4b 00 00 08
[14315342.651510] sd 4:0:0:2: [sde] Assuming drive cache: write through
[14315342.661545] sd 4:0:0:2: [sde] 122624 512-byte hardware sectors (63 MB)
[14315342.662501] sd 4:0:0:2: [sde] Write Protect is off
[14315342.662503] sd 4:0:0:2: [sde] Mode Sense: 4b 00 00 08
[14315342.662505] sd 4:0:0:2: [sde] Assuming drive cache: write through
[14315342.662507]  sde: sde1
[14315342.665647] sd 4:0:0:2: [sde] Attached SCSI removable disk
[14315342.665675] sd 4:0:0:2: Attached scsi generic sg4 type 0
[14315342.675479] scsi 4:0:0:3: Direct-Access     Generic  IC1210        SM=
 1.9C PQ: 0 ANSI: 0 CCS
[14315342.685739] sd 4:0:0:3: [sdf] Attached SCSI removable disk
[14315342.685772] sd 4:0:0:3: Attached scsi generic sg5 type 0
[14315342.688174] usb-storage: device scan complete
[14315342.781938] scsi 5:0:0:0: Direct-Access     Motorola Motorola Phone  =
 2.31 PQ: 0 ANSI: 2
[14315342.808329] sd 5:0:0:0: [sdg] 979456 512-byte hardware sectors (501 M=
B)
[14315342.818108] sd 5:0:0:0: [sdg] Write Protect is off
[14315342.818108] sd 5:0:0:0: [sdg] Mode Sense: 0b 00 00 08
[14315342.818108] sd 5:0:0:0: [sdg] Assuming drive cache: write through
[14315342.861582] sd 5:0:0:0: [sdg] 979456 512-byte hardware sectors (501 M=
B)
[14315342.884786] sd 5:0:0:0: [sdg] Write Protect is off
[14315342.884786] sd 5:0:0:0: [sdg] Mode Sense: 0b 00 00 08
[14315342.884786] sd 5:0:0:0: [sdg] Assuming drive cache: write through
[14315342.884786]  sdg: sdg1
[14315342.914198] sd 5:0:0:0: [sdg] Attached SCSI removable disk
[14315342.914198] sd 5:0:0:0: Attached scsi generic sg6 type 0
[14315342.914198] usb-storage: device scan complete
[14315360.661441] reiser4: sda5: found disk format 4.0.0.
[14315363.361441] reiser4: sdb1: found disk format 4.0.0.
[14315364.789163] Adding 4000176k swap on /dev/sda2.  Priority:-1 extents:1=
 across:4000176k
[14315365.132947] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[14315365.132952] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI=
 18 (level, low) -> IRQ 18
[14315365.135160] Audigy2 value: Special config.
[14315365.184777] r8169: eth0: link up
[14315365.184777] r8169: eth0: link up
[14315365.988624] i2c /dev entries driver
[14315366.009106] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[14315366.009130] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[14315366.459885] w83627ehf: Found W83627EHG chip at 0x290
[14316182.181358] nvidia: module license 'NVIDIA' taints kernel.
[14316182.444689] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 17
[14316182.444689] ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNED] -> GSI=
 17 (level, low) -> IRQ 17
[14316182.444689] PCI: Setting latency timer of device 0000:04:00.0 to 64
[14316182.444689] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  173.14.05=
  Mon May 19 00:03:22 PDT 2008
[14316305.145289] kio_http_cache_[11759] general protection ip:33b77f1fe9 s=
p:7fff9ae2da10 error:0 in libqt-mt.so.3.3.8[33b7200000+7d5000]

--Boundary-00=_LOsPIBoQcUY/J2h
Content-Type: text/plain;
  charset="iso-8859-15";
  name="lspci_ahci_nomsi_2.6.26-rc4_vxxx"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci_ahci_nomsi_2.6.26-rc4_vxxx"

00:00.0 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
	Subsystem: ASRock Incorporation Device 0444
	Flags: bus master, 66MHz, fast devsel, latency 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
	Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
00: de 10 44 04 06 00 b0 00 a1 00 00 05 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 44 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 00 00
40: 49 18 44 04 08 dc e0 01 22 00 11 11 d0 00 00 00
50: 23 05 7f 00 03 00 00 00 00 00 03 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 06 15 00 00
70: 44 44 44 00 d0 09 00 00 11 00 00 00 11 11 88 00
80: 12 88 88 00 fa 00 64 0d 03 00 00 00 7f 00 00 00
90: 70 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 01 01 01 01 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 80 00 0f 0f 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 08 00 01 a8
e0: 00 00 e0 fe 00 00 00 00 00 00 80 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:01.0 ISA bridge: nVidia Corporation MCP65 LPC Bridge (rev a2)
	Subsystem: ASRock Incorporation Device 0441
	Flags: bus master, 66MHz, fast devsel, latency 0
00: de 10 41 04 0f 00 a0 20 a2 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 41 04
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00
40: 49 18 41 04 00 00 d0 fe fa 3e ff 00 fa 3e ff 00
50: fa 3e ff 00 00 5a 62 02 00 00 00 05 33 00 2c 01
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 10 00 ff ff c5 80 00 00 00 00 04 19 60 00 c0 00
80: 09 20 00 10 00 00 00 00 f0 00 00 01 ff 00 00 00
90: ff 7f 00 00 00 00 00 00 21 97 0a 68 ed bc 00 00
a0: 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 90 02 0f 03 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 04 c0 df f9 00 01 00 70
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:01.1 SMBus: nVidia Corporation MCP65 SMBus (rev a1)
	Subsystem: ASRock Incorporation Device 0446
	Flags: 66MHz, fast devsel, IRQ 11
	I/O ports at bc00 [size=64]
	I/O ports at 2d00 [size=64]
	I/O ports at 2e00 [size=64]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c-nforce2
00: de 10 46 04 01 00 b0 00 a1 00 05 0c 00 00 80 00
10: 01 bc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 2d 00 00 01 2e 00 00 00 00 00 00 49 18 46 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 00 00
40: 49 18 46 04 01 00 02 c0 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 20 00 00 01 24 00 00 01 28 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 01 2c 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: d4 30 80 00 01 00 00 00 00 00 00 00 00 00 00 00
d0: 40 00 40 01 10 00 00 00 05 00 00 00 00 00 00 00
e0: 80 10 04 00 04 40 00 07 80 1e 02 00 41 44 44 11
f0: 02 ff 1e bf 01 00 00 80 10 00 00 00 00 00 00 00

00:01.2 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
	Subsystem: ASRock Incorporation Device 0446
	Flags: 66MHz, fast devsel
00: de 10 45 04 00 04 a0 00 a1 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 46 04
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 49 18 45 04 00 00 00 00 10 02 80 10 10 00 10 10
50: 10 10 10 10 00 00 00 00 00 00 00 00 10 42 00 00
60: 69 0c 21 06 43 98 31 0c c7 0c 63 0c 62 00 00 04
70: 20 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 01 00 00 04 42 00 01 00
90: 00 00 01 18 06 00 00 00 00 00 70 00 20 01 00 00
a0: 00 00 00 00 00 00 00 00 40 0c 50 06 40 18 20 0c
b0: 00 98 11 00 00 04 00 00 00 00 00 02 00 04 10 00
c0: 01 84 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.0 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1) (prog-if 10 [OHCI])
	Subsystem: ASRock Incorporation Device 0454
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 5
	Memory at f9dff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Kernel modules: ohci-hcd
00: de 10 54 04 07 00 b0 00 a1 10 03 0c 00 00 80 00
10: 00 f0 df f9 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 54 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 05 01 03 01
40: 49 18 54 04 01 00 02 fe 00 00 00 00 00 00 00 00
50: 00 00 00 00 1d 47 40 00 10 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.1 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1) (prog-if 20 [EHCI])
	Subsystem: ASRock Incorporation Device 0455
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
	Memory at f9dfec00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=0098
	Capabilities: [80] Power Management version 2
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd
00: de 10 55 04 06 00 b0 00 a1 20 03 0c 00 00 80 00
10: 00 ec df f9 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 55 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 07 02 03 01
40: 49 18 55 04 0a 80 98 20 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 20 01 00 00 60 18 85 03 3c 3f 01 00 00 00 00
70: 00 00 08 05 00 10 20 80 89 3d b6 22 77 25 34 00
80: 01 00 02 fe 00 00 00 00 00 00 00 00 15 16 00 00
90: 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 00 00 00 00 08 80 00 00 00 00 00 00 00 00
b0: 00 11 22 33 44 00 00 00 ff 03 00 00 00 00 00 00
c0: 10 10 2d 0d 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:08.0 PCI bridge: nVidia Corporation MCP65 PCI bridge (rev a1) (prog-if 01 [Subtractive decode])
	Flags: bus master, 66MHz, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: f9f00000-f9ffffff
	Prefetchable memory behind bridge: f0000000-f00fffff
	Capabilities: [b8] Subsystem: ASRock Incorporation Device 0449
	Capabilities: [8c] HyperTransport: MSI Mapping Enable+ Fixed-
00: de 10 49 04 07 00 b0 00 a1 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 02 02 20 d0 d0 80 22
20: f0 f9 f0 f9 00 f0 00 f0 00 00 00 00 00 00 00 00
30: 00 00 00 00 b8 00 00 00 00 00 00 00 00 00 02 02
40: 00 00 73 07 01 00 02 00 07 00 00 00 00 00 48 00
50: 00 00 00 00 00 00 00 00 f7 1f ff 1f 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 0a 00 00 3c 00 00 01 00 00 00 00 08 00 01 a8
90: 00 00 e0 fe 00 00 00 00 00 00 00 00 00 00 00 00
a0: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 ff ff 00 00 0d 8c 00 00 49 18 49 04
c0: 49 18 49 04 07 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:09.0 IDE interface: nVidia Corporation MCP65 IDE (rev a1) (prog-if 8a [Master SecP PriP])
	Subsystem: ASRock Incorporation Device 0448
	Flags: bus master, 66MHz, fast devsel, latency 0
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at ffa0 [size=16]
	Capabilities: [44] Power Management version 2
00: de 10 48 04 05 00 b0 00 a1 8a 01 01 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: a1 ff 00 00 00 00 00 00 00 00 00 00 49 18 48 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 03 01
40: 49 18 48 04 01 00 02 00 00 00 00 00 00 00 00 00
50: 02 f0 01 00 00 00 00 00 a8 a8 a8 a8 ff 00 ff ff
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 01
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:0a.0 SATA controller: nVidia Corporation MCP65 AHCI Controller (rev a1) (prog-if 01 [AHCI 1.0])
	Subsystem: ASRock Incorporation Device 044d
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
	I/O ports at 0e00 [size=8]
	I/O ports at 0e20 [size=4]
	I/O ports at 0e40 [size=8]
	I/O ports at 0e60 [size=4]
	I/O ports at a800 [size=16]
	Memory at f9dfc000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
	Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: ahci
00: de 10 4d 04 07 00 b0 00 a1 01 06 01 00 00 80 00
10: 01 0e 00 00 21 0e 00 00 41 0e 00 00 61 0e 00 00
20: 01 a8 00 00 00 c0 df f9 00 00 00 00 49 18 4d 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 0f 01 03 01
40: 49 18 4d 04 01 b0 02 00 00 00 00 00 00 00 00 00
50: 0f 68 38 60 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 01 00 60 ac 00 0f 00 0f 06 42 00 00 00 00
70: 2c 78 c4 40 00 00 00 00 07 a0 18 40 20 00 20 78
80: 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 4d 04 06 01
a0: 6e 5a 00 3f 00 00 00 00 00 00 00 00 33 31 00 02
b0: 05 cc 86 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 08 00 02 a8
d0: 00 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00
e0: 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 01 1f 00 00 00 00 00

00:0b.0 PCI bridge: nVidia Corporation Device 045b (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: f9e00000-f9efffff
	Capabilities: [40] Subsystem: ASRock Incorporation Device 045b
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 5b 04 07 00 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 c1 c1 00 00
20: e0 f9 e0 f9 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 02 00
40: 0d 48 00 00 49 18 5b 04 01 50 02 f8 00 00 00 00
50: 05 60 82 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 21 3c 11 03
90: 00 00 11 30 00 00 00 00 c0 01 48 01 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0c.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Capabilities: [40] Subsystem: ASRock Incorporation Device 045a
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 5a 04 04 00 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 f1 01 00 00
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 02 00
40: 0d 48 00 00 49 18 5a 04 01 50 02 f8 00 00 00 00
50: 05 60 82 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 11 3c 11 02
90: 00 00 21 10 00 00 00 00 c0 01 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0d.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fa000000-febfffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Capabilities: [40] Subsystem: ASRock Incorporation Device 0458
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 58 04 07 00 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 04 04 00 e1 e1 00 00
20: 00 fa b0 fe 01 d0 f1 df 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 1a 00
40: 0d 48 00 00 49 18 58 04 01 50 02 f8 00 00 00 00
50: 05 60 82 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 01 3d 11 00
90: 00 00 01 31 00 00 00 00 c0 01 48 01 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0e.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Capabilities: [40] Subsystem: ASRock Incorporation Device 0459
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 59 04 04 00 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 05 05 00 f1 01 00 00
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 02 00
40: 0d 48 00 00 49 18 59 04 01 50 02 f8 00 00 00 00
50: 05 60 82 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 11 3c 11 01
90: 00 00 81 10 00 00 00 00 c0 01 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface
00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
60: 00 00 01 00 e4 00 00 00 20 c8 2e 0f 0c 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 00 01 21 20 00 11 11 22 05 75 80 02 00 00 00
90: 69 01 61 01 00 00 07 00 07 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Flags: fast devsel
00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 2f 01 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 03 00 e0 00 80 ff ef 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 03 0a 00 00 00 0b 00 00 03 00 d0 00 00 0b fe 00
c0: 13 10 00 00 00 f0 ff 00 00 00 00 00 00 00 00 00
d0: 03 20 00 00 00 20 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 07 00 00 00 00 00 00 00 00 00 00 00 00
f0: 01 30 00 d0 00 00 00 00 00 00 00 00 00 00 00 00

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Flags: fast devsel
00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 00 00 01 01 00 00 01 02 00 00 01 03 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: e0 3c f8 00 e0 3c f8 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 46 00 00 00 00 00 00 00
80: 22 00 00 00 00 00 00 00 13 91 15 0c 20 12 92 00
90: 10 08 01 00 69 80 10 34 39 00 00 80 00 00 00 00
a0: eb 02 00 0c 00 00 00 00 00 00 00 00 00 00 00 00
b0: e3 5e ab 99 42 00 00 00 88 63 88 15 18 83 09 11
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 7f 1e b4 c6 ec fb ce bf 3a ab 34 fd 4b e5 61 e0
e0: 7e 3f dd 27 cf dc c2 89 3e 1f 53 66 6d 07 0b 72
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k8temp
	Kernel modules: k8temp
00: 22 10 03 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00
40: ff 3b 04 00 40 00 10 0a 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 c0 d7 0d b0
60: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 01 02 51 22 30 00 50 00 1b 00 08 2e 22 00 00
80: 00 00 07 23 13 21 13 21 00 00 00 00 00 00 00 00
90: 03 00 00 00 02 00 00 00 00 e5 2f 01 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 40 4a 04
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 01 a7 0d 00 00 00 40 00 25 20 20 00
e0: 00 00 00 00 24 16 46 00 19 17 00 00 00 00 00 00
f0: 0f 00 10 00 00 00 00 00 00 00 00 00 33 0f 04 00

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
	Subsystem: ASRock Incorporation Device 8168
	Flags: bus master, fast devsel, latency 0, IRQ 19
	I/O ports at c800 [size=256]
	Memory at f9eff000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at f9ec0000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 2
	Capabilities: [48] Vital Product Data <?>
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [84] Vendor Specific Information <?>
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [12c] Virtual Channel <?>
	Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-00-00
	Capabilities: [154] Power Budgeting <?>
	Kernel driver in use: r8169
	Kernel modules: r8169
00: ec 10 68 81 07 01 10 40 01 00 00 02 10 00 00 00
10: 01 c8 00 00 00 00 00 00 04 f0 ef f9 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 68 81
30: 00 00 ec f9 40 00 00 00 00 00 00 00 0a 01 00 00
40: 01 48 c2 f7 00 00 00 00 03 50 00 00 00 00 00 00
50: 05 60 82 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 84 01 00 63 7e 00 00 10 58 1a 00 11 f4 03 00
70: 00 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 09 00 4c 01 01 1c 02 00 fb ff ff 11
90: 08 30 00 00 75 42 0f 00 ad 40 0c 00 47 07 00 00
a0: 02 28 ff 01 00 00 00 00 00 08 00 00 03 00 03 00
b0: 00 00 00 00 ff 3f ff 3f ff ff 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:08.0 SCSI storage controller: Adaptec AHA-2944UW / AIC-7884U (rev 01)
	Subsystem: Adaptec Device 7884
	Flags: bus master, medium devsel, latency 32, IRQ 11
	I/O ports at d800 [size=256]
	Memory at f9fff000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at f0000000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 1
	Kernel modules: aic7xxx
00: 04 90 78 84 17 01 90 02 01 00 00 01 10 20 00 00
10: 01 d8 00 00 00 f0 ff f9 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 04 90 84 78
30: 00 00 fe f9 dc 00 00 00 00 00 00 00 0b 01 08 08
40: 80 15 00 00 80 15 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 21 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:09.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
	Subsystem: Creative Labs Device 1001
	Flags: bus master, medium devsel, latency 32, IRQ 18
	I/O ports at dc00 [size=64]
	Capabilities: [dc] Power Management version 2
	Kernel driver in use: EMU10K1_Audigy
	Kernel modules: snd-emu10k1
00: 02 11 08 00 05 01 90 02 00 00 01 04 00 20 00 00
10: 01 dc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 11 01 10
30: 00 00 00 00 dc 00 00 00 00 00 00 00 05 01 02 14
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 82 00 00
50: 00 80 00 00 ff ff 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 22 06
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

04:00.0 VGA compatible controller: nVidia Corporation Device 0402 (rev a1) (prog-if 00 [VGA controller])
	Subsystem: nVidia Corporation Device 0439
	Flags: bus master, fast devsel, latency 0, IRQ 10
	Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
	I/O ports at ec00 [size=128]
	Expansion ROM at febe0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [78] Express Endpoint, MSI 00
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information <?>
	Kernel modules: nvidia
00: de 10 02 04 07 01 10 00 a1 00 00 03 10 00 00 00
10: 00 00 00 fd 0c 00 00 d0 00 00 00 00 04 00 00 fa
20: 00 00 00 00 01 ec 00 00 00 00 00 00 de 10 39 04
30: 00 00 be fe 60 00 00 00 00 00 00 00 0a 01 00 00
40: de 10 39 04 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 00 00 01 00 00 00 ce d6 23 00 00 00 00 00
60: 01 68 02 00 00 00 00 00 05 78 80 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 10 00 01 00 e0 84 00 00
80: 10 28 00 00 01 3d 01 00 08 00 01 11 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


--Boundary-00=_LOsPIBoQcUY/J2h
Content-Type: text/plain;
  charset="iso-8859-15";
  name="lspci_non_raid_msi_2.6.24-rc4_vxxx"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci_non_raid_msi_2.6.24-rc4_vxxx"

00:00.0 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
	Subsystem: ASRock Incorporation Device 0444
	Flags: bus master, 66MHz, fast devsel, latency 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
	Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
00: de 10 44 04 06 00 b0 00 a1 00 00 05 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 44 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 00 00
40: 49 18 44 04 08 dc e0 01 22 00 11 11 d0 00 00 00
50: 23 05 7f 00 03 00 00 00 00 00 03 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 06 15 00 00
70: 44 44 44 00 d0 09 00 00 11 00 00 00 11 11 88 00
80: 12 88 88 00 fa 00 64 0d 03 00 00 00 7f 00 00 00
90: 70 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 01 01 01 01 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 80 00 0f 0f 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 08 00 01 a8
e0: 00 00 e0 fe 00 00 00 00 00 00 80 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:01.0 ISA bridge: nVidia Corporation MCP65 LPC Bridge (rev a2)
	Subsystem: ASRock Incorporation Device 0441
	Flags: bus master, 66MHz, fast devsel, latency 0
	I/O ports at 2f00 [size=256]
00: de 10 41 04 0f 00 a0 20 a2 00 01 06 00 00 80 00
10: 01 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 41 04
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00
40: 49 18 41 04 00 00 d0 fe fa 3e ff 00 fa 3e ff 00
50: fa 3e ff 00 00 5a 62 02 00 00 00 05 33 00 2c 01
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 10 00 ff ff c5 80 00 00 00 00 04 19 60 00 c0 00
80: 09 20 00 10 00 00 00 00 f0 00 00 01 ff 00 00 00
90: ff 7f 00 00 00 00 00 00 21 97 0a 68 ed bc 00 00
a0: 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 90 02 0f 03 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:01.1 SMBus: nVidia Corporation MCP65 SMBus (rev a1)
	Subsystem: ASRock Incorporation Device 0446
	Flags: 66MHz, fast devsel, IRQ 11
	I/O ports at bc00 [size=64]
	I/O ports at 2d00 [size=64]
	I/O ports at 2e00 [size=64]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c-nforce2
00: de 10 46 04 01 00 b0 00 a1 00 05 0c 00 00 80 00
10: 01 bc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 2d 00 00 01 2e 00 00 00 00 00 00 49 18 46 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 00 00
40: 49 18 46 04 01 00 02 c0 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 20 00 00 01 24 00 00 01 28 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 01 2c 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: d4 30 80 00 01 00 00 00 00 00 00 00 00 00 00 00
d0: 40 00 40 01 10 00 00 00 05 00 00 00 00 00 00 00
e0: 80 10 04 00 04 40 00 07 80 1e 02 00 41 44 44 11
f0: 02 ff 1e bf 01 00 00 80 10 00 00 00 00 00 00 00

00:01.2 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
	Subsystem: ASRock Incorporation Device 0446
	Flags: 66MHz, fast devsel
00: de 10 45 04 00 04 a0 00 a1 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 46 04
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 49 18 45 04 00 00 00 00 10 02 80 10 10 00 10 10
50: 10 10 10 10 00 00 00 00 00 00 00 00 10 42 00 00
60: 69 0c 21 06 43 98 31 0c c7 0c 63 0c 62 00 00 04
70: 20 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 01 00 00 04 42 00 01 00
90: 00 00 01 18 06 00 00 00 00 00 70 00 20 01 00 00
a0: 00 00 00 00 00 00 00 00 40 0c 50 06 40 18 20 0c
b0: 00 98 11 00 00 04 00 00 00 00 00 02 00 04 10 00
c0: 01 84 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.0 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1) (prog-if 10 [OHCI])
	Subsystem: ASRock Incorporation Device 0454
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 5
	Memory at f9dff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Kernel modules: ohci-hcd
00: de 10 54 04 07 00 b0 00 a1 10 03 0c 00 00 80 00
10: 00 f0 df f9 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 54 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 05 01 03 01
40: 49 18 54 04 01 00 02 fe 00 00 00 00 00 00 00 00
50: 00 00 00 00 1d 47 40 00 10 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.1 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1) (prog-if 20 [EHCI])
	Subsystem: ASRock Incorporation Device 0455
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
	Memory at f9dfec00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=0098
	Capabilities: [80] Power Management version 2
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd
00: de 10 55 04 06 00 b0 00 a1 20 03 0c 00 00 80 00
10: 00 ec df f9 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 55 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 07 02 03 01
40: 49 18 55 04 0a 80 98 20 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 20 01 00 00 60 18 85 03 3c 3f 01 00 00 00 00
70: 00 00 08 05 00 10 20 80 89 3d b6 22 77 25 c4 00
80: 01 00 02 fe 00 00 00 00 00 00 00 00 15 16 00 00
90: 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 00 00 00 00 08 80 00 00 00 00 00 00 00 00
b0: 00 11 22 33 44 00 00 00 ff 03 00 00 00 00 00 00
c0: 10 10 2d 0d 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:08.0 PCI bridge: nVidia Corporation MCP65 PCI bridge (rev a1) (prog-if 01 [Subtractive decode])
	Flags: bus master, 66MHz, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: f9f00000-f9ffffff
	Prefetchable memory behind bridge: f0000000-f00fffff
	Capabilities: [b8] Subsystem: ASRock Incorporation Device 0449
	Capabilities: [8c] HyperTransport: MSI Mapping Enable+ Fixed-
00: de 10 49 04 07 00 b0 00 a1 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 02 02 20 d0 d0 80 22
20: f0 f9 f0 f9 00 f0 00 f0 00 00 00 00 00 00 00 00
30: 00 00 00 00 b8 00 00 00 00 00 00 00 00 00 02 02
40: 00 00 73 07 01 00 02 00 07 00 00 00 00 00 48 00
50: 00 00 00 00 00 00 00 00 f7 1f ff 1f 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 0a 00 00 3c 00 00 01 00 00 00 00 08 00 01 a8
90: 00 00 e0 fe 00 00 00 00 00 00 00 00 00 00 00 00
a0: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 ff ff 00 00 0d 8c 00 00 49 18 49 04
c0: 49 18 49 04 07 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:09.0 IDE interface: nVidia Corporation MCP65 IDE (rev a1) (prog-if 8a [Master SecP PriP])
	Subsystem: ASRock Incorporation Device 0448
	Flags: bus master, 66MHz, fast devsel, latency 0
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at ffa0 [size=16]
	Capabilities: [44] Power Management version 2
00: de 10 48 04 05 00 b0 00 a1 8a 01 01 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: a1 ff 00 00 00 00 00 00 00 00 00 00 49 18 48 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 03 01
40: 49 18 48 04 01 00 02 00 00 00 00 00 00 00 00 00
50: 02 f0 01 00 00 00 00 00 a8 a8 a8 a8 ff 00 ff ff
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 01
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:0a.0 IDE interface: nVidia Corporation MCP65 SATA Controller (rev a1) (prog-if 85 [Master SecO PriO])
	Subsystem: ASRock Incorporation Device 045d
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 315
	I/O ports at 0e00 [size=8]
	I/O ports at 0e20 [size=4]
	I/O ports at 0e40 [size=8]
	I/O ports at 0e60 [size=4]
	I/O ports at a800 [size=16]
	Memory at f9dfc000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable+
	Capabilities: [cc] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: ahci
00: de 10 5d 04 07 04 b0 00 a1 85 01 01 00 00 80 00
10: 01 0e 00 00 21 0e 00 00 41 0e 00 00 61 0e 00 00
20: 01 a8 00 00 00 c0 df f9 00 00 00 00 49 18 5d 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 0f 01 03 01
40: 49 18 5d 04 01 b0 02 00 00 00 00 00 00 00 00 00
50: 0f 68 38 60 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 60 ac 00 0f 00 0f 06 42 00 00 00 00
70: 2c 78 c4 40 00 00 00 00 07 a0 18 40 20 00 20 78
80: 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 5d 04 01 01
a0: 6e 5a 00 3f 00 00 00 00 00 00 00 00 33 31 00 02
b0: 05 cc 87 00 0c 30 e0 fe 00 00 00 00 71 41 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 08 00 03 a8
d0: 00 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00
e0: 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 01 1e 00 00 00 00 00

00:0b.0 PCI bridge: nVidia Corporation Device 045b (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: f9e00000-f9efffff
	Capabilities: [40] Subsystem: ASRock Incorporation Device 045b
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 5b 04 07 04 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 c1 c1 00 00
20: e0 f9 e0 f9 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 02 00
40: 0d 48 00 00 49 18 5b 04 01 50 02 f8 00 00 00 00
50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 49 41 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 21 3c 11 03
90: 00 00 11 30 00 00 00 00 c0 01 48 01 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0c.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Capabilities: [40] Subsystem: ASRock Incorporation Device 045a
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 5a 04 04 04 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 f1 01 00 00
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 02 00
40: 0d 48 00 00 49 18 5a 04 01 50 02 f8 00 00 00 00
50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 51 41 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 11 3c 11 02
90: 00 00 21 10 00 00 00 00 c0 01 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0d.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fa000000-febfffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Capabilities: [40] Subsystem: ASRock Incorporation Device 0458
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 58 04 07 04 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 04 04 00 e1 e1 00 00
20: 00 fa b0 fe 01 d0 f1 df 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 1a 00
40: 0d 48 00 00 49 18 58 04 01 50 02 f8 00 00 00 00
50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 59 41 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 01 3d 11 00
90: 00 00 01 31 00 00 00 00 c0 01 48 01 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0e.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Capabilities: [40] Subsystem: ASRock Incorporation Device 0459
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 59 04 04 04 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 05 05 00 f1 01 00 00
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 02 00
40: 0d 48 00 00 49 18 59 04 01 50 02 f8 00 00 00 00
50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 61 41 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 11 3c 11 01
90: 00 00 81 10 00 00 00 00 c0 01 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface
00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
60: 00 00 01 00 e4 00 00 00 20 c8 2e 0f 0c 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 00 01 21 20 00 11 11 22 05 75 80 02 00 00 00
90: 69 01 61 01 00 00 07 00 07 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Flags: fast devsel
00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 2f 01 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 03 00 e0 00 80 ff ef 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 03 0a 00 00 00 0b 00 00 03 00 d0 00 00 0b fe 00
c0: 13 10 00 00 00 f0 ff 00 00 00 00 00 00 00 00 00
d0: 03 20 00 00 00 20 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 07 00 00 00 00 00 00 00 00 00 00 00 00
f0: 01 30 00 d0 00 00 00 00 00 00 00 00 00 00 00 00

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Flags: fast devsel
00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 00 00 01 01 00 00 01 02 00 00 01 03 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: e0 3c f8 00 e0 3c f8 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 46 00 00 00 00 00 00 00
80: 22 00 00 00 00 00 00 00 13 91 15 0c 20 12 92 00
90: 10 08 01 00 69 80 10 34 39 00 00 80 00 00 00 00
a0: eb 02 00 0c 00 00 00 00 00 00 00 00 00 00 00 00
b0: 9a 5b bb 39 35 00 00 00 88 63 88 15 18 83 09 11
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 7f 1e b4 c6 ec fb ce bf 3a ab 34 fd 4b e5 61 e0
e0: 7e 3f dd 27 cf dc c2 89 3e 1f 53 66 6d 07 0b 72
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k8temp
	Kernel modules: k8temp
00: 22 10 03 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00
40: ff 3b 04 00 40 00 10 0a 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 c0 d7 0d b0
60: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 01 02 51 22 30 00 50 00 1b 00 08 2e 22 00 00
80: 00 00 07 23 13 21 13 21 00 00 00 00 00 00 00 00
90: 03 00 00 00 02 00 00 00 00 e5 2f 01 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 b0 3d 04
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 01 a7 0d 00 00 00 40 00 25 20 20 00
e0: 00 00 00 00 24 16 46 00 19 17 00 00 00 00 00 00
f0: 0f 00 10 00 00 00 00 00 00 00 00 00 33 0f 04 00

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
	Subsystem: ASRock Incorporation Device 8168
	Flags: bus master, fast devsel, latency 0, IRQ 314
	I/O ports at c800 [size=256]
	Memory at f9eff000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at f9ec0000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 2
	Capabilities: [48] Vital Product Data <?>
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [84] Vendor Specific Information <?>
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [12c] Virtual Channel <?>
	Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-00-00
	Capabilities: [154] Power Budgeting <?>
	Kernel driver in use: r8169
	Kernel modules: r8169
00: ec 10 68 81 07 05 10 40 01 00 00 02 10 00 00 00
10: 01 c8 00 00 00 00 00 00 04 f0 ef f9 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 68 81
30: 00 00 ec f9 40 00 00 00 00 00 00 00 0a 01 00 00
40: 01 48 c2 f7 00 00 00 00 03 50 00 00 00 00 00 00
50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 81 41 00 00
60: 10 84 01 00 63 7e 00 00 10 58 1a 00 11 f4 03 00
70: 00 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 09 00 4c 01 01 1c 02 00 fb ff ff 11
90: 08 30 00 00 d5 41 05 00 b4 00 04 00 aa 04 00 00
a0: 02 28 ff 01 00 00 00 00 00 08 00 00 03 00 03 00
b0: 00 00 00 00 ff 3f ff 3f ff ff 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:08.0 SCSI storage controller: Adaptec AHA-2944UW / AIC-7884U (rev 01)
	Subsystem: Adaptec Device 7884
	Flags: bus master, medium devsel, latency 32, IRQ 11
	I/O ports at d800 [size=256]
	Memory at f9fff000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at f0000000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 1
	Kernel modules: aic7xxx
00: 04 90 78 84 17 01 90 02 01 00 00 01 10 20 00 00
10: 01 d8 00 00 00 f0 ff f9 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 04 90 84 78
30: 00 00 fe f9 dc 00 00 00 00 00 00 00 0b 01 08 08
40: 80 15 00 00 80 15 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 21 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:09.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
	Subsystem: Creative Labs Device 1001
	Flags: bus master, medium devsel, latency 32, IRQ 18
	I/O ports at dc00 [size=64]
	Capabilities: [dc] Power Management version 2
	Kernel driver in use: EMU10K1_Audigy
	Kernel modules: snd-emu10k1
00: 02 11 08 00 05 01 90 02 00 00 01 04 00 20 00 00
10: 01 dc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 11 01 10
30: 00 00 00 00 dc 00 00 00 00 00 00 00 05 01 02 14
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 82 00 00
50: 00 80 00 00 ff ff 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 22 06
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

04:00.0 VGA compatible controller: nVidia Corporation Device 0402 (rev a1) (prog-if 00 [VGA controller])
	Subsystem: nVidia Corporation Device 0439
	Flags: bus master, fast devsel, latency 0, IRQ 10
	Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
	I/O ports at ec00 [size=128]
	Expansion ROM at febe0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [78] Express Endpoint, MSI 00
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information <?>
	Kernel modules: nvidia
00: de 10 02 04 07 01 10 00 a1 00 00 03 10 00 00 00
10: 00 00 00 fd 0c 00 00 d0 00 00 00 00 04 00 00 fa
20: 00 00 00 00 01 ec 00 00 00 00 00 00 de 10 39 04
30: 00 00 be fe 60 00 00 00 00 00 00 00 0a 01 00 00
40: de 10 39 04 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 00 00 01 00 00 00 ce d6 23 00 00 00 00 00
60: 01 68 02 00 00 00 00 00 05 78 80 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 10 00 01 00 e0 84 00 00
80: 10 28 00 00 01 3d 01 00 08 00 01 11 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


--Boundary-00=_LOsPIBoQcUY/J2h
Content-Type: text/plain;
  charset="iso-8859-15";
  name="lspci_non_raid_nomsi_2.6.24-rc4_vxxx"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci_non_raid_nomsi_2.6.24-rc4_vxxx"

00:00.0 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
	Subsystem: ASRock Incorporation Device 0444
	Flags: bus master, 66MHz, fast devsel, latency 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
	Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
00: de 10 44 04 06 00 b0 00 a1 00 00 05 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 44 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 00 00
40: 49 18 44 04 08 dc e0 01 22 00 11 11 d0 00 00 00
50: 23 05 7f 00 03 00 00 00 00 00 03 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 06 15 00 00
70: 44 44 44 00 d0 09 00 00 11 00 00 00 11 11 88 00
80: 12 88 88 00 fa 00 64 0d 03 00 00 00 7f 00 00 00
90: 70 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 01 01 01 01 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 80 00 0f 0f 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 08 00 01 a8
e0: 00 00 e0 fe 00 00 00 00 00 00 80 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:01.0 ISA bridge: nVidia Corporation MCP65 LPC Bridge (rev a2)
	Subsystem: ASRock Incorporation Device 0441
	Flags: bus master, 66MHz, fast devsel, latency 0
	I/O ports at 2f00 [size=256]
00: de 10 41 04 0f 00 a0 20 a2 00 01 06 00 00 80 00
10: 01 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 41 04
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00
40: 49 18 41 04 00 00 d0 fe fa 3e ff 00 fa 3e ff 00
50: fa 3e ff 00 00 5a 62 02 00 00 00 05 33 00 2c 01
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 10 00 ff ff c5 80 00 00 00 00 04 19 60 00 c0 00
80: 09 20 00 10 00 00 00 00 f0 00 00 01 ff 00 00 00
90: ff 7f 00 00 00 00 00 00 21 97 0a 68 ed bc 00 00
a0: 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 90 02 0f 03 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:01.1 SMBus: nVidia Corporation MCP65 SMBus (rev a1)
	Subsystem: ASRock Incorporation Device 0446
	Flags: 66MHz, fast devsel, IRQ 11
	I/O ports at bc00 [size=64]
	I/O ports at 2d00 [size=64]
	I/O ports at 2e00 [size=64]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c-nforce2
00: de 10 46 04 01 00 b0 00 a1 00 05 0c 00 00 80 00
10: 01 bc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 2d 00 00 01 2e 00 00 00 00 00 00 49 18 46 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 00 00
40: 49 18 46 04 01 00 02 c0 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 20 00 00 01 24 00 00 01 28 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 01 2c 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: d4 30 80 00 01 00 00 00 00 00 00 00 00 00 00 00
d0: 40 00 40 01 10 00 00 00 05 00 00 00 00 00 00 00
e0: 80 10 04 00 04 40 00 07 80 1e 02 00 41 44 44 11
f0: 02 ff 1e bf 01 00 00 80 10 00 00 00 00 00 00 00

00:01.2 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
	Subsystem: ASRock Incorporation Device 0446
	Flags: 66MHz, fast devsel
00: de 10 45 04 00 04 a0 00 a1 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 46 04
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 49 18 45 04 00 00 00 00 10 02 80 10 10 00 10 10
50: 10 10 10 10 00 00 00 00 00 00 00 00 10 42 00 00
60: 69 0c 21 06 43 98 31 0c c7 0c 63 0c 62 00 00 04
70: 20 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 01 00 00 04 42 00 01 00
90: 00 00 01 18 06 00 00 00 00 00 70 00 20 01 00 00
a0: 00 00 00 00 00 00 00 00 40 0c 50 06 40 18 20 0c
b0: 00 98 11 00 00 04 00 00 00 00 00 02 00 04 10 00
c0: 01 84 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.0 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1) (prog-if 10 [OHCI])
	Subsystem: ASRock Incorporation Device 0454
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 5
	Memory at f9dff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Kernel modules: ohci-hcd
00: de 10 54 04 07 00 b0 00 a1 10 03 0c 00 00 80 00
10: 00 f0 df f9 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 54 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 05 01 03 01
40: 49 18 54 04 01 00 02 fe 00 00 00 00 00 00 00 00
50: 00 00 00 00 1d 47 40 00 10 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.1 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1) (prog-if 20 [EHCI])
	Subsystem: ASRock Incorporation Device 0455
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
	Memory at f9dfec00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=0098
	Capabilities: [80] Power Management version 2
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd
00: de 10 55 04 06 00 b0 00 a1 20 03 0c 00 00 80 00
10: 00 ec df f9 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 55 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 07 02 03 01
40: 49 18 55 04 0a 80 98 20 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 20 01 00 00 60 18 85 03 3c 3f 01 00 00 00 00
70: 00 00 08 05 00 10 20 80 89 3d b6 22 77 25 04 00
80: 01 00 02 fe 00 00 00 00 00 00 00 00 15 16 00 00
90: 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 00 00 00 00 08 80 00 00 00 00 00 00 00 00
b0: 00 11 22 33 44 00 00 00 ff 03 00 00 00 00 00 00
c0: 10 10 2d 0d 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:08.0 PCI bridge: nVidia Corporation MCP65 PCI bridge (rev a1) (prog-if 01 [Subtractive decode])
	Flags: bus master, 66MHz, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: f9f00000-f9ffffff
	Prefetchable memory behind bridge: f0000000-f00fffff
	Capabilities: [b8] Subsystem: ASRock Incorporation Device 0449
	Capabilities: [8c] HyperTransport: MSI Mapping Enable+ Fixed-
00: de 10 49 04 07 00 b0 00 a1 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 02 02 20 d0 d0 80 22
20: f0 f9 f0 f9 00 f0 00 f0 00 00 00 00 00 00 00 00
30: 00 00 00 00 b8 00 00 00 00 00 00 00 00 00 02 02
40: 00 00 73 07 01 00 02 00 07 00 00 00 00 00 48 00
50: 00 00 00 00 00 00 00 00 f7 1f ff 1f 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 0a 00 00 3c 00 00 01 00 00 00 00 08 00 01 a8
90: 00 00 e0 fe 00 00 00 00 00 00 00 00 00 00 00 00
a0: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 ff ff 00 00 0d 8c 00 00 49 18 49 04
c0: 49 18 49 04 07 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:09.0 IDE interface: nVidia Corporation MCP65 IDE (rev a1) (prog-if 8a [Master SecP PriP])
	Subsystem: ASRock Incorporation Device 0448
	Flags: bus master, 66MHz, fast devsel, latency 0
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at ffa0 [size=16]
	Capabilities: [44] Power Management version 2
00: de 10 48 04 05 00 b0 00 a1 8a 01 01 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: a1 ff 00 00 00 00 00 00 00 00 00 00 49 18 48 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 03 01
40: 49 18 48 04 01 00 02 00 00 00 00 00 00 00 00 00
50: 02 f0 01 00 00 00 00 00 a8 a8 a8 a8 ff 00 ff ff
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 01
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:0a.0 IDE interface: nVidia Corporation MCP65 SATA Controller (rev a1) (prog-if 85 [Master SecO PriO])
	Subsystem: ASRock Incorporation Device 045d
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
	I/O ports at 0e00 [size=8]
	I/O ports at 0e20 [size=4]
	I/O ports at 0e40 [size=8]
	I/O ports at 0e60 [size=4]
	I/O ports at a800 [size=16]
	Memory at f9dfc000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
	Capabilities: [cc] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: ahci
00: de 10 5d 04 07 00 b0 00 a1 85 01 01 00 00 80 00
10: 01 0e 00 00 21 0e 00 00 41 0e 00 00 61 0e 00 00
20: 01 a8 00 00 00 c0 df f9 00 00 00 00 49 18 5d 04
30: 00 00 00 00 44 00 00 00 00 00 00 00 0f 01 03 01
40: 49 18 5d 04 01 b0 02 00 00 00 00 00 00 00 00 00
50: 0f 68 38 60 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 60 ac 00 0f 00 0f 06 42 00 00 00 00
70: 2c 78 c4 40 00 00 00 00 07 a0 18 40 20 00 20 78
80: 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 5d 04 01 01
a0: 6e 5a 00 3f 00 00 00 00 00 00 00 00 33 31 00 02
b0: 05 cc 86 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 08 00 03 a8
d0: 00 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00
e0: 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 01 1e 00 00 00 00 00

00:0b.0 PCI bridge: nVidia Corporation Device 045b (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: f9e00000-f9efffff
	Capabilities: [40] Subsystem: ASRock Incorporation Device 045b
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 5b 04 07 00 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 c1 c1 00 00
20: e0 f9 e0 f9 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 02 00
40: 0d 48 00 00 49 18 5b 04 01 50 02 f8 00 00 00 00
50: 05 60 82 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 21 3c 11 03
90: 00 00 11 30 00 00 00 00 c0 01 48 01 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0c.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Capabilities: [40] Subsystem: ASRock Incorporation Device 045a
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 5a 04 04 00 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 f1 01 00 00
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 02 00
40: 0d 48 00 00 49 18 5a 04 01 50 02 f8 00 00 00 00
50: 05 60 82 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 11 3c 11 02
90: 00 00 21 10 00 00 00 00 c0 01 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0d.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fa000000-febfffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Capabilities: [40] Subsystem: ASRock Incorporation Device 0458
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 58 04 07 00 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 04 04 00 e1 e1 00 00
20: 00 fa b0 fe 01 d0 f1 df 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 1a 00
40: 0d 48 00 00 49 18 58 04 01 50 02 f8 00 00 00 00
50: 05 60 82 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 01 3d 11 00
90: 00 00 01 31 00 00 00 00 c0 01 48 01 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0e.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Capabilities: [40] Subsystem: ASRock Incorporation Device 0459
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
00: de 10 59 04 04 00 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 05 05 00 f1 01 00 00
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 02 00
40: 0d 48 00 00 49 18 59 04 01 50 02 f8 00 00 00 00
50: 05 60 82 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 08 80 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 01 80 00 00 1f 28 00 00 11 3c 11 01
90: 00 00 81 10 00 00 00 00 c0 01 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface
00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
60: 00 00 01 00 e4 00 00 00 20 c8 2e 0f 0c 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 00 01 21 20 00 11 11 22 05 75 80 02 00 00 00
90: 69 01 61 01 00 00 07 00 07 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Flags: fast devsel
00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 2f 01 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 03 00 e0 00 80 ff ef 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 03 0a 00 00 00 0b 00 00 03 00 d0 00 00 0b fe 00
c0: 13 10 00 00 00 f0 ff 00 00 00 00 00 00 00 00 00
d0: 03 20 00 00 00 20 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 07 00 00 00 00 00 00 00 00 00 00 00 00
f0: 01 30 00 d0 00 00 00 00 00 00 00 00 00 00 00 00

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Flags: fast devsel
00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 00 00 01 01 00 00 01 02 00 00 01 03 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: e0 3c f8 00 e0 3c f8 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 46 00 00 00 00 00 00 00
80: 22 00 00 00 00 00 00 00 13 91 15 0c 20 12 92 00
90: 10 08 01 00 69 80 10 34 39 00 00 80 00 00 00 00
a0: eb 02 00 0c 00 00 00 00 00 00 00 00 00 00 00 00
b0: 50 dc 68 26 2b 00 00 00 88 63 88 15 18 83 09 11
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 7f 1e b4 c6 ec fb ce bf 3a ab 34 fd 4b e5 61 e0
e0: 7e 3f dd 27 cf dc c2 89 3e 1f 53 66 6d 07 0b 72
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k8temp
	Kernel modules: k8temp
00: 22 10 03 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00
40: ff 3b 04 00 40 00 10 0a 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 c0 d7 0d b0
60: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 01 02 51 22 30 00 50 00 1b 00 08 2e 22 00 00
80: 00 00 07 23 13 21 13 21 00 00 00 00 00 00 00 00
90: 03 00 00 00 02 00 00 00 00 e5 2f 01 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 50 37 04
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 01 a7 0d 00 00 00 40 00 25 20 20 00
e0: 00 00 00 00 24 16 47 00 19 17 00 00 00 00 00 00
f0: 0f 00 10 00 00 00 00 00 00 00 00 00 33 0f 04 00

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
	Subsystem: ASRock Incorporation Device 8168
	Flags: bus master, fast devsel, latency 0, IRQ 19
	I/O ports at c800 [size=256]
	Memory at f9eff000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at f9ec0000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 2
	Capabilities: [48] Vital Product Data <?>
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [84] Vendor Specific Information <?>
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [12c] Virtual Channel <?>
	Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-00-00
	Capabilities: [154] Power Budgeting <?>
	Kernel driver in use: r8169
	Kernel modules: r8169
00: ec 10 68 81 07 01 10 40 01 00 00 02 10 00 00 00
10: 01 c8 00 00 00 00 00 00 04 f0 ef f9 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 68 81
30: 00 00 ec f9 40 00 00 00 00 00 00 00 0a 01 00 00
40: 01 48 c2 f7 00 00 00 00 03 50 00 00 00 00 00 00
50: 05 60 82 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 84 01 00 63 7e 00 00 10 58 1a 00 11 f4 03 00
70: 00 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 09 00 4c 01 01 1c 02 00 fb ff ff 11
90: 08 30 00 00 75 41 0f 00 ad 70 0c 00 12 03 00 00
a0: 02 28 ff 01 00 00 00 00 00 08 00 00 03 00 03 00
b0: 00 00 00 00 ff 3f ff 3f ff ff 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:08.0 SCSI storage controller: Adaptec AHA-2944UW / AIC-7884U (rev 01)
	Subsystem: Adaptec Device 7884
	Flags: bus master, medium devsel, latency 32, IRQ 11
	I/O ports at d800 [size=256]
	Memory at f9fff000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at f0000000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 1
	Kernel modules: aic7xxx
00: 04 90 78 84 17 01 90 02 01 00 00 01 10 20 00 00
10: 01 d8 00 00 00 f0 ff f9 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 04 90 84 78
30: 00 00 fe f9 dc 00 00 00 00 00 00 00 0b 01 08 08
40: 80 15 00 00 80 15 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 21 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:09.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
	Subsystem: Creative Labs Device 1001
	Flags: bus master, medium devsel, latency 32, IRQ 18
	I/O ports at dc00 [size=64]
	Capabilities: [dc] Power Management version 2
	Kernel driver in use: EMU10K1_Audigy
	Kernel modules: snd-emu10k1
00: 02 11 08 00 05 01 90 02 00 00 01 04 00 20 00 00
10: 01 dc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 11 01 10
30: 00 00 00 00 dc 00 00 00 00 00 00 00 05 01 02 14
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 82 00 00
50: 00 80 00 00 ff ff 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 22 06
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

04:00.0 VGA compatible controller: nVidia Corporation Device 0402 (rev a1) (prog-if 00 [VGA controller])
	Subsystem: nVidia Corporation Device 0439
	Flags: bus master, fast devsel, latency 0, IRQ 10
	Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
	I/O ports at ec00 [size=128]
	Expansion ROM at febe0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [78] Express Endpoint, MSI 00
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information <?>
	Kernel modules: nvidia
00: de 10 02 04 07 01 10 00 a1 00 00 03 10 00 00 00
10: 00 00 00 fd 0c 00 00 d0 00 00 00 00 04 00 00 fa
20: 00 00 00 00 01 ec 00 00 00 00 00 00 de 10 39 04
30: 00 00 be fe 60 00 00 00 00 00 00 00 0a 01 00 00
40: de 10 39 04 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 00 00 01 00 00 00 ce d6 23 00 00 00 00 00
60: 01 68 02 00 00 00 00 00 05 78 80 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 10 00 01 00 e0 84 00 00
80: 10 28 00 00 01 3d 01 00 08 00 01 11 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


--Boundary-00=_LOsPIBoQcUY/J2h
Content-Type: text/plain;
  charset="iso-8859-15";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.26-rc4
# Thu May 29 03:57:42 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
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
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=16
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
# CONFIG_NAMESPACES is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_BLK_DEV_BSG=y
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
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_MEMTEST_BOOTPARAM=y
CONFIG_MEMTEST_BOOTPARAM_VALUE=0
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
# CONFIG_MWINCHIP2 is not set
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
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
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
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=m
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
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
# CONFIG_BT_HCIUSB is not set
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
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
CONFIG_FW_LOADER=m
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

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
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=16
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
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
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
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
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
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
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_E1000E_ENABLED is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
# CONFIG_R8169_NAPI is not set
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set

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
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
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
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
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
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_PLATFORM is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
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
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
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
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set

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
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
# CONFIG_MEDIA_TUNER_TDA8290 is not set
# CONFIG_MEDIA_TUNER_TDA827X is not set
# CONFIG_MEDIA_TUNER_TDA18271 is not set
CONFIG_MEDIA_TUNER_TDA9887=m
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
# CONFIG_MEDIA_TUNER_MT2266 is not set
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_TUNER_3036 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DPC is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_VIDEO_PVRUSB2 is not set
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_W9968CF is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_SOC_CAMERA is not set
# CONFIG_RADIO_ADAPTERS is not set
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
# CONFIG_DVB_CINERGYT2 is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_TDA10086 is not set
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TUA6100 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set
# CONFIG_DVB_TDA10048 is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=m
# CONFIG_DVB_S5H1409 is not set
# CONFIG_DVB_AU8522 is not set
# CONFIG_DVB_S5H1411 is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
# CONFIG_DVB_TUNER_DIB0070 is not set

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_ISL6405 is not set
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
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
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_AC97_CODEC=m
# CONFIG_SND_DUMMY is not set
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set

#
# PCI devices
#
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
# CONFIG_SND_BT87X is not set
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
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
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
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0

#
# USB devices
#
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# ALSA SoC audio for Freescale SOCs
#

#
# SoC Audio for the Texas Instruments OMAP
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

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

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
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
# CONFIG_USB_MON is not set

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
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
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
# CONFIG_EXT4DEV_FS is not set
CONFIG_REISER4_FS=y
# CONFIG_REISER4_DEBUG is not set
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m

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
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-15"
# CONFIG_NLS_CODEPAGE_437 is not set
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
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_NONPROMISC_DEVMEM is not set
CONFIG_EARLY_PRINTK=y
CONFIG_X86_MPPARSE=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=m
# CONFIG_CRYPTO_MANAGER is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
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
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
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
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-00=_LOsPIBoQcUY/J2h--
