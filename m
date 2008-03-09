Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYCISc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYCISc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYCISco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:32:44 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:57304 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbYCISch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:32:37 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Mar 2008 14:32:36 EDT
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24.X: SATA/AHCI related boot delay.
Date: Sun, 9 Mar 2008 19:22:32 +0100
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_prC1HU46IH2JXNA"
Message-Id: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_prC1HU46IH2JXNA
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I have an Alive -NF5-esata2+. AM2 board with dual core AMD64 cpu.

Problem exists with latest bios 1.90 and its predecessor 1.80.

This board with nforce 520 chipset (MCP65) has three possible settings for =
the=20
sata controller:
non-raid
raid
ahci.

My default is non-raid.

With 2.6.24 based kernels I get this on cold boot:

[   49.176044] Driver 'sd' needs updating - please use bus_type methods
[   49.176117] ahci 0000:00:0a.0: version 3.0
[   49.176291] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   49.176335] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
=20
(level, low) -> IRQ 23
[   50.176871] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl IDE mode
[   50.176922] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[   50.176962] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   50.177163] scsi0 : ahci
[   50.177259] scsi1 : ahci
[   50.177325] scsi2 : ahci
[   50.177392] scsi3 : ahci
[   50.177480] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0=20
irq 315
[   50.177528] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0=20
irq 315
[   50.177575] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0=20
irq 315
[   50.177623] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0=20
irq 315
[   50.808824] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   80.743754] ata1.00: qc timeout (cmd 0xec)
[   80.743792] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[   80.743831] ata1: failed to recover some devices, retrying in 5 secs
[   86.368194] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   86.368803] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   86.368846] ata1.00: 312581808 sectors, multi 16: LBA48
[   86.369491] ata1.00: configured for UDMA/133
[   87.000153] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   87.020703] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   87.020742] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   87.022737] ata2.00: configured for UDMA/133
[   87.339415] ata3: SATA link down (SStatus 0 SControl 300)
[   87.658721] ata4: SATA link down (SStatus 0 SControl 300)
[   87.658810] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[   87.658917] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   87.658962] sd 0:0:0:0: [sda] Write Protect is off
[   87.659000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   87.659008] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   87.659078] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   87.659121] sd 0:0:0:0: [sda] Write Protect is off
[   87.659159] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   87.659166] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   87.659215]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   87.696698] sd 0:0:0:0: [sda] Attached SCSI disk
[   87.696832] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10=20
PQ: 0 ANSI: 5
[   87.696940] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   87.696985] sd 1:0:0:0: [sdb] Write Protect is off
[   87.697022] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   87.697031] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   87.697101] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   87.697144] sd 1:0:0:0: [sdb] Write Protect is off
[   87.697182] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   87.697189] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   87.697238]  sdb: sdb1 sdb2
[   87.720300] sd 1:0:0:0: [sdb] Attached SCSI disk
=2D------------------------------------------------------------------------=
=2D-------------

and this on reboots:

   30.984720] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf=
=20
impl IDE mode
[   30.984771] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[   30.984811] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   30.985012] scsi0 : ahci
[   30.985108] scsi1 : ahci
[   30.985174] scsi2 : ahci
[   30.985241] scsi3 : ahci
[   30.985329] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0=20
irq 315
[   30.985377] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0=20
irq 315
[   30.985425] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0=20
irq 315
[   30.985472] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0=20
irq 315
[   36.619135] ata1: port is slow to respond, please be patient (Status 0xd=
0)
[   40.982984] ata1: softreset failed (device not ready)
[   41.614947] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   41.615582] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   41.615625] ata1.00: 312581808 sectors, multi 16: LBA48
[   41.616251] ata1.00: configured for UDMA/133
[   42.246907] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   42.250073] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   42.250113] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   42.252112] ata2.00: configured for UDMA/133
[   42.569539] ata3: SATA link down (SStatus 0 SControl 300)
[   42.888845] ata4: SATA link down (SStatus 0 SControl 300)
[   42.888934] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[   42.889041] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   42.889086] sd 0:0:0:0: [sda] Write Protect is off
[   42.889124] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   42.889132] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   42.889202] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   42.889246] sd 0:0:0:0: [sda] Write Protect is off
[   42.889284] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   42.889291] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   42.889340]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   42.925936] sd 0:0:0:0: [sda] Attached SCSI disk
[   42.926071] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10=20
PQ: 0 ANSI: 5
[   42.926180] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   42.926224] sd 1:0:0:0: [sdb] Write Protect is off
[   42.926262] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   42.926271] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   42.926346] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   42.926389] sd 1:0:0:0: [sdb] Write Protect is off
[   42.926427] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   42.926434] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   42.926484]  sdb: sdb1 sdb2
[   42.955833] sd 1:0:0:0: [sdb] Attached SCSI disk
=2D------------------------------------------------------------------------=
=2D--------------

with 2.6.23.11 it looks like this:

[   90.956853] ide: Assuming 33MHz system bus speed for PIO modes; override=
=20
with idebus=3Dxx
[   90.957166] NFORCE-MCP65: IDE controller at PCI slot 0000:00:09.0
[   90.957335] NFORCE-MCP65: chipset revision 161
[   90.957494] NFORCE-MCP65: not 100% native mode: will probe irqs later
[   90.957658] NFORCE-MCP65: 0000:00:09.0 (rev a1) UDMA133 controller
[   90.957820]     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA,=20
hdb:pio
[   90.958166] Probing IDE interface ide0...
[   91.246150] hda: SAMSUNG SP1213N, ATA DISK drive
[   91.888005] hda: selected mode 0x45
[   91.888070] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   91.890652] hda: max request size: 512KiB
[   91.890861] hda: 234493056 sectors (120060 MB) w/8192KiB Cache,=20
CHS=3D16383/255/63, UDMA(100)
[   91.891601] hda: cache flushes supported
[   91.891777]  hda: hda1 hda2 hda3 < hda5 hda6 hda7 >
[   91.931121] ahci 0000:00:0a.0: version 2.3
[   91.931299] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   91.931465] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
=20
(level, low) -> IRQ 23
[   92.935591] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl IDE mode
[   92.935888] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[   92.936049] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   92.936263] scsi0 : ahci
[   92.936486] scsi1 : ahci
[   92.936677] scsi2 : ahci
[   92.936867] scsi3 : ahci
[   92.937048] ata1: SATA max UDMA/133 cmd 0xffffc20000020100 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   92.937342] ata2: SATA max UDMA/133 cmd 0xffffc20000020180 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   92.937636] ata3: SATA max UDMA/133 cmd 0xffffc20000020200 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   92.937930] ata4: SATA max UDMA/133 cmd 0xffffc20000020280 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   93.411080] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   93.411883] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   93.412045] ata1.00: 312581808 sectors, multi 16: LBA48
[   93.412797] ata1.00: configured for UDMA/133
[   93.727032] ata2: SATA link down (SStatus 0 SControl 300)
[   94.042987] ata3: SATA link down (SStatus 0 SControl 300)
[   94.358941] ata4: SATA link down (SStatus 0 SControl 300)
[   94.359249] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[   94.359599] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   94.359765] sd 0:0:0:0: [sda] Write Protect is off
[   94.359925] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   94.359933] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   94.360249] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   94.360414] sd 0:0:0:0: [sda] Write Protect is off
[   94.360573] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   94.360581] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   94.360873]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   94.402906] sd 0:0:0:0: [sda] Attached SCSI disk
[   94.403107] sd 0:0:0:0: Attached scsi generic sg0 type 0
=2D------------------------------------------------------------------------=
=2D-------------

I removed the pata-disk and the drivers some days ago - but that has had no=
=20
influence on the problem. The delay was there with the pata-drive and drive=
rs=20
too. There are some changes in the config - but even with the 2.6.3.11 conf=
ig=20
on a 2.6.24 and make oldconfig showed the delays.

If I change from 'non raid' to AHCI (because the handbook says that is the =
way=20
to get NCQ working) boot hangs for looong time and no harddisks are found:
(dmesg from systemrescuecd 1.0)
ahci 0000:00:0a.0: version 3.0
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -=
>=20
IRQ 18
ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio=20
PCI: Setting latency timer of device 0000:00:0a.0 to 64
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci
ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 218
ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 218
ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 218
ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 218
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 00(40)
scsi_scan_2 used greatest stack depth: 2868 bytes left
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
ata2: failed to recover some devices, retrying in 5 secs
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
ata2: failed to recover some devices, retrying in 5 secs
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
ata2: failed to recover some devices, retrying in 5 secs
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
pata_amd 0000:00:09.0: version 0.3.10
PCI: Setting latency timer of device 0000:00:09.0 to 64
scsi7 : pata_amd
scsi8 : pata_amd
ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15

I tried systemrescuecd with the 'noapic' option - same result. Long hangs, =
no=20
disks found.

lspci
00:00.0 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
00:01.0 ISA bridge: nVidia Corporation MCP65 LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP65 SMBus (rev a1)
00:01.2 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
00:02.0 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1)
00:02.1 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1)
00:08.0 PCI bridge: nVidia Corporation MCP65 PCI bridge (rev a1)
00:09.0 IDE interface: nVidia Corporation MCP65 IDE (rev a1)
00:0a.0 IDE interface: nVidia Corporation MCP65 SATA Controller (rev a1)
00:0b.0 PCI bridge: nVidia Corporation Unknown device 045b (rev a1)
00:0c.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1)
00:0d.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1)
00:0e.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRA=
M=20
Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
Miscellaneous Control
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B =
PCI=20
Express Gigabit Ethernet controller (rev 01)
02:08.0 SCSI storage controller: Adaptec AHA-2944UW / AIC-7884U (rev 01)
02:09.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
04:00.0 VGA compatible controller: nVidia Corporation Unknown device 0402 (=
rev=20
a1)

dmesg
[    0.000000] Linux version 2.6.24.2reiser4 (root@energy) (gcc version 4.2=
=2E3=20
(Gentoo 4.2.3 p1.0)) #6 SMP Tue Mar 4 17:28:59 CET 2008
[    0.000000] Command line: root=3D/dev/sda3 nmi_watchdog=3D0 console=3Dtt=
y6
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
256=20
used
[    0.000000] end_pfn_map =3D 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT =
     =20
97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT =
     =20
97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL=
=20
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT =
     =20
97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT =
     =20
97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT =
     =20
97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT =
     =20
97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD  =
      =20
1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of =
256=20
used
[    0.000000] No mptable found.
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
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 -=
=20
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 -=
=20
00000000000e6000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e6000 -=
=20
0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffb0000 -=
=20
00000000cffc0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffc0000 -=
=20
00000000cfff0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cfff0000 -=
=20
00000000d0000000
[    0.000000] swsusp: Registered nosave memory region: 00000000d0000000 -=
=20
00000000fec00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec00000 -=
=20
00000000fec01000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec01000 -=
=20
00000000fee00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fee00000 -=
=20
00000000fef00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fef00000 -=
=20
00000000ff380000
[    0.000000] swsusp: Registered nosave memory region: 00000000ff380000 -=
=20
0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap:=20
d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 31408 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l=20
pages: 1030519
[    0.000000] Kernel command line: root=3D/dev/sda3 nmi_watchdog=3D0 conso=
le=3Dtty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[   48.747446] Marking TSC unstable due to TSCs unsynchronized
[   48.747447] time.c: Detected 3013.888 MHz processor.
[   48.751279] Console: colour VGA+ 80x25
[   48.751281] console [tty6] enabled
[   48.755890] Dentry cache hash table entries: 524288 (order: 10, 4194304=
=20
bytes)
[   48.758116] Inode-cache hash table entries: 262144 (order: 9, 2097152=20
bytes)
[   48.758884] Checking aperture...
[   48.758922] CPU 0: aperture @ ecc8000000 size 32 MB
[   48.758959] Aperture too small (32 MB)
[   48.764827] No AGP bridge found
[   48.764863] Your BIOS doesn't leave a aperture memory hole
[   48.764901] Please enable the IOMMU option in the BIOS setup
[   48.764939] This costs you 64 MB of RAM
[   48.790106] Mapping aperture over 65536 KB of RAM @ 8000000
[   48.813687] Memory: 4049936k/4980736k available (2204k kernel code, 1434=
40k=20
reserved, 681k data, 172k init)
[   48.813756] SLUB: Genslabs=3D11, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D2,=20
Nodes=3D1
[   48.893771] Calibrating delay using timer specific routine.. 6034.65=20
BogoMIPS (lpj=3D10053840)
[   48.893864] Mount-cache hash table entries: 256
[   48.893972] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)
[   48.894012] CPU: L2 Cache: 1024K (64 bytes/line)
[   48.894050] CPU: Physical Processor ID: 0
[   48.894086] CPU: Processor Core ID: 0
[   48.894139] SMP alternatives: switching to UP code
[   48.894504] ACPI: Core revision 20070126
[   48.929680] Using local APIC timer interrupts.
[   48.962824] APIC timer calibration result 12557873
[   48.962826] Detected 12.557 MHz APIC timer.
[   48.962910] SMP alternatives: switching to SMP code
[   48.963141] Booting processor 1/2 APIC 0x1
[   48.973258] Initializing CPU#1
[   49.056020] Calibrating delay using timer specific routine.. 6030.92=20
BogoMIPS (lpj=3D10046281)
[   49.056024] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)
[   49.056026] CPU: L2 Cache: 1024K (64 bytes/line)
[   49.056027] CPU: Physical Processor ID: 0
[   49.056028] CPU: Processor Core ID: 1
[   49.056109] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   49.056167] Brought up 2 CPUs
[   49.056624] net_namespace: 120 bytes
[   49.056866] NET: Registered protocol family 16
[   49.056978] ACPI: bus type pci registered
[   49.057060] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   49.057099] PCI: Not using MMCONFIG.
[   49.057135] PCI: Using configuration type 1
[   49.059381] ACPI: EC: Look up EC in DSDT
[   49.062825] ACPI: Interpreter enabled
[   49.062863] ACPI: (supports S0 S1 S3 S4 S5)
[   49.063033] ACPI: Using IOAPIC for interrupt routing
[   49.063242] Error attaching device data
[   49.063281] Error attaching device data
[   49.063320] Error attaching device data
[   49.063359] Error attaching device data
[   49.068281] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   49.068803] PCI: Transparent bridge - 0000:00:08.0
[   49.069095] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   49.069228] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   49.069326] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   49.069382] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   49.069438] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   49.069494] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   49.073455] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   49.073793] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   49.074127] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0,=20
disabled.
[   49.074487] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0,=20
disabled.
[   49.074847] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0,=20
disabled.
[   49.075207] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   49.075541] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0,=20
disabled.
[   49.075902] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   49.076239] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   49.076573] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0,=20
disabled.
[   49.076933] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   49.077267] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0,=20
disabled.
[   49.077628] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0,=20
disabled.
[   49.077988] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   49.078322] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0,=20
disabled.
[   49.078683] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   49.079017] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0,=20
disabled.
[   49.079415] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0,=20
disabled.
[   49.079776] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0,=20
disabled.
[   49.080137] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0,=20
disabled.
[   49.080456] Linux Plug and Play Support v0.97 (c) Adam Belay
[   49.080509] pnp: PnP ACPI init
[   49.080548] ACPI: bus type pnp registered
[   49.083088] pnp: PnP ACPI: found 13 devices
[   49.083125] ACPI: ACPI bus type pnp unregistered
[   49.083244] SCSI subsystem initialized
[   49.083300] libata version 3.00 loaded.
[   49.083353] usbcore: registered new interface driver usbfs
[   49.083407] usbcore: registered new interface driver hub
[   49.083464] usbcore: registered new device driver usb
[   49.083546] PCI: Using ACPI for IRQ routing
[   49.083584] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it=
=20
helps, post a report
[   49.092621] PCI-DMA: Disabling AGP.
[   49.093359] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   49.093401] PCI-DMA: using GART IOMMU.
[   49.093441] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   49.093600] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   49.093739] hpet0: 3 32-bit timers, 25000000 Hz
[   49.095903] Time: hpet clocksource has been installed.
[   49.095951] Switched to high resolution mode on CPU 0
[   49.096038] Switched to high resolution mode on CPU 1
[   49.102635] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   49.102675] system 00:05: ioport range 0x800-0x80f has been reserved
[   49.102714] system 00:05: ioport range 0x2000-0x207f has been reserved
[   49.102754] system 00:05: ioport range 0x2080-0x20ff has been reserved
[   49.106152] system 00:05: ioport range 0x2400-0x247f has been reserved
[   49.106192] system 00:05: ioport range 0x2480-0x24ff has been reserved
[   49.106231] system 00:05: ioport range 0x2800-0x287f has been reserved
[   49.106270] system 00:05: ioport range 0x2880-0x28ff has been reserved
[   49.106309] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   49.106349] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[   49.106389] system 00:05: iomem range 0x0-0x0 could not be reserved
[   49.106428] system 00:05: iomem range 0xfee01000-0xfeefffff has been=20
reserved
[   49.106472] system 00:07: iomem range 0xfec00000-0xfec00fff could not be=
=20
reserved
[   49.106520] system 00:07: iomem range 0xfee00000-0xfee00fff could not be=
=20
reserved
[   49.106570] system 00:0a: ioport range 0x290-0x29f has been reserved
[   49.106613] system 00:0b: iomem range 0xe0000000-0xefffffff has been=20
reserved
[   49.106658] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   49.106698] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   49.106740] system 00:0c: iomem range 0xe0000-0xfffff could not be reser=
ved
[   49.106780] system 00:0c: iomem range 0x100000-0xcfffffff could not be=20
reserved
[   49.106827] system 00:0c: iomem range 0xff380000-0xffffffff could not be=
=20
reserved
[   49.107108] PCI: Bridge: 0000:00:08.0
[   49.107145]   IO window: d000-dfff
[   49.107182]   MEM window: f9f00000-f9ffffff
[   49.107219]   PREFETCH window: disabled.
[   49.107257] PCI: Bridge: 0000:00:0b.0
[   49.107293]   IO window: c000-cfff
[   49.107330]   MEM window: f9e00000-f9efffff
[   49.107367]   PREFETCH window: disabled.
[   49.107404] PCI: Bridge: 0000:00:0c.0
[   49.107440]   IO window: disabled.
[   49.107476]   MEM window: disabled.
[   49.107512]   PREFETCH window: disabled.
[   49.107549] PCI: Bridge: 0000:00:0d.0
[   49.107585]   IO window: e000-efff
[   49.107622]   MEM window: fa000000-febfffff
[   49.107659]   PREFETCH window: d0000000-dfffffff
[   49.107697] PCI: Bridge: 0000:00:0e.0
[   49.107733]   IO window: disabled.
[   49.107769]   MEM window: disabled.
[   49.107805]   PREFETCH window: disabled.
[   49.107848] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   49.107857] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   49.107862] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   49.107866] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   49.107871] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   49.107877] NET: Registered protocol family 2
[   49.139202] IP route cache hash table entries: 131072 (order: 8, 1048576=
=20
bytes)
[   49.139805] TCP established hash table entries: 262144 (order: 10, 41943=
04=20
bytes)
[   49.141228] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   49.141693] TCP: Hash tables configured (established 262144 bind 65536)
[   49.141733] TCP reno registered
[   49.149967] Loading Reiser4. See www.namesys.com for a description of=20
Reiser4.
[   49.150075] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor=20
254)
[   49.150123] io scheduler noop registered
[   49.150161] io scheduler cfq registered (default)
[   49.150855] Boot video device is 0000:04:00.0
[   49.150958] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   49.150975] assign_interrupt_mode Found MSI capability
[   49.151029] Allocate Port Service[0000:00:0b.0:pcie00]
[   49.151071] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   49.151087] assign_interrupt_mode Found MSI capability
[   49.151135] Allocate Port Service[0000:00:0c.0:pcie00]
[   49.151172] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   49.151187] assign_interrupt_mode Found MSI capability
[   49.151235] Allocate Port Service[0000:00:0d.0:pcie00]
[   49.151274] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   49.151290] assign_interrupt_mode Found MSI capability
[   49.151338] Allocate Port Service[0000:00:0e.0:pcie00]
[   49.151515] input: Power Button (FF) as /class/input/input0
[   49.151553] ACPI: Power Button (FF) [PWRF]
[   49.151638] input: Power Button (CM) as /class/input/input1
[   49.151676] ACPI: Power Button (CM) [PWRB]
[   49.151812] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processo=
r=20
Device is not present [20070126]
[   49.151917] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processo=
r=20
Device is not present [20070126]
[   49.175824] Real Time Clock Driver v1.12ac
[   49.175942] hpet_resources: 0xfed00000 is busy
[   49.175960] Linux agpgart interface v0.102
[   49.176044] Driver 'sd' needs updating - please use bus_type methods
[   49.176117] ahci 0000:00:0a.0: version 3.0
[   49.176291] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   49.176335] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
=20
(level, low) -> IRQ 23
[   50.176871] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl IDE mode
[   50.176922] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[   50.176962] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   50.177163] scsi0 : ahci
[   50.177259] scsi1 : ahci
[   50.177325] scsi2 : ahci
[   50.177392] scsi3 : ahci
[   50.177480] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0=20
irq 315
[   50.177528] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0=20
irq 315
[   50.177575] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0=20
irq 315
[   50.177623] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0=20
irq 315
[   50.808824] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   80.743754] ata1.00: qc timeout (cmd 0xec)
[   80.743792] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[   80.743831] ata1: failed to recover some devices, retrying in 5 secs
[   86.368194] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   86.368803] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   86.368846] ata1.00: 312581808 sectors, multi 16: LBA48
[   86.369491] ata1.00: configured for UDMA/133
[   87.000153] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   87.020703] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   87.020742] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   87.022737] ata2.00: configured for UDMA/133
[   87.339415] ata3: SATA link down (SStatus 0 SControl 300)
[   87.658721] ata4: SATA link down (SStatus 0 SControl 300)
[   87.658810] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[   87.658917] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   87.658962] sd 0:0:0:0: [sda] Write Protect is off
[   87.659000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   87.659008] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   87.659078] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   87.659121] sd 0:0:0:0: [sda] Write Protect is off
[   87.659159] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   87.659166] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   87.659215]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   87.696698] sd 0:0:0:0: [sda] Attached SCSI disk
[   87.696832] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10=20
PQ: 0 ANSI: 5
[   87.696940] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   87.696985] sd 1:0:0:0: [sdb] Write Protect is off
[   87.697022] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   87.697031] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   87.697101] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   87.697144] sd 1:0:0:0: [sdb] Write Protect is off
[   87.697182] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   87.697189] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   87.697238]  sdb: sdb1 sdb2
[   87.720300] sd 1:0:0:0: [sdb] Attached SCSI disk
[   87.720614] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   87.720659] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22=
=20
(level, low) -> IRQ 22
[   87.720952] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   87.720956] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   87.721072] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus=
=20
number 1
[   87.721146] ehci_hcd 0000:00:02.1: debug port 1
[   87.721185] PCI: cache line size of 64 is not supported by device=20
0000:00:02.1
[   87.721193] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   87.729429] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10=
=20
Dec 2004
[   87.729591] usb usb1: configuration #1 chosen from 1 choice
[   87.729657] hub 1-0:1.0: USB hub found
[   87.729698] hub 1-0:1.0: 10 ports detected
[   87.831809] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x6=
4=20
irq 1,12
[   87.834655] serio: i8042 KBD port at 0x60,0x64 irq 1
[   87.834694] serio: i8042 AUX port at 0x60,0x64 irq 12
[   87.890390] input: AT Translated Set 2 keyboard as /class/input/input2
[   88.057853] usb 1-3: new high speed USB device using ehci_hcd and addres=
s 2
[   88.182269] usb 1-3: configuration #1 chosen from 1 choice
[   88.182606] hub 1-3:1.0: USB hub found
[   88.182959] hub 1-3:1.0: 4 ports detected
[   88.510234] usb 1-5: new high speed USB device using ehci_hcd and addres=
s 3
[   88.639370] usb 1-5: configuration #1 chosen from 1 choice
[   88.826522] usb 1-3.1: new low speed USB device using ehci_hcd and addre=
ss=20
4
[   88.928973] usb 1-3.1: configuration #1 chosen from 1 choice
[   89.122483] usb 1-3.4: new high speed USB device using ehci_hcd and addr=
ess=20
5
[   89.195695] usb 1-3.4: device descriptor read/64, error -71
[   89.371925] usb 1-3.4: device descriptor read/64, error -71
[   89.541544] usb 1-3.4: new high speed USB device using ehci_hcd and addr=
ess=20
6
[   89.614755] usb 1-3.4: device descriptor read/64, error -71
[   89.790985] usb 1-3.4: device descriptor read/64, error -71
[   89.960730] usb 1-3.4: new high speed USB device using ehci_hcd and addr=
ess=20
7
[   90.366204] usb 1-3.4: device not accepting address 7, error -71
[   90.432921] usb 1-3.4: new high speed USB device using ehci_hcd and addr=
ess=20
8
[   90.838511] usb 1-3.4: device not accepting address 8, error -71
[   90.843129] input: Logitech USB Receiver as /class/input/input3
[   90.859316] input: USB HID v1.11 Mouse [Logitech USB Receiver] on=20
usb-0000:00:02.1-3.1
[   90.865040] input: Logitech USB Receiver as /class/input/input4
[   90.885926] input: USB HID v1.11 Device [Logitech USB Receiver] on=20
usb-0000:00:02.1-3.1
[   90.886029] usbcore: registered new interface driver usbhid
[   90.886068] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   90.886113] TCP cubic registered
[   90.886152] NET: Registered protocol family 1
[   90.886209] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processo=
r=20
6000+ processors (2 cpu cores) (version 2.20.00)
[   90.886262] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   90.886301] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   90.886339] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   90.886378] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   90.886416] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   90.886454] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   90.889850] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   90.889889] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   90.900783] ReiserFS: sda3: found reiserfs format "3.6" with standard=20
journal
[   90.900825] ReiserFS: sda3: using ordered data mode
[   90.910333] ReiserFS: sda3: journal params: device sda3, size 8192, jour=
nal=20
first block 18, max trans len 1024, max batch 900, max commit age 30, max=20
trans age 30
[   90.911226] ReiserFS: sda3: checking transaction log (sda3)
[   90.954640] ReiserFS: sda3: Using r5 hash to sort names
[   90.954690] VFS: Mounted root (reiserfs filesystem) readonly.
[   90.954740] Freeing unused kernel memory: 172k freed
[   91.040511] Clocksource tsc unstable (delta =3D -144182848 ns)
[   92.705141] ReiserFS: sda3: switching to journaled data mode
[   92.875659] r8169 Gigabit Ethernet driver 2.2LK loaded
[   92.875868] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   92.875873] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19=
=20
(level, low) -> IRQ 19
[   92.875881] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   92.876029] eth0: RTL8168b/8111b at 0xffffc20000172000, 00:19:66:47:f3:c=
b,=20
XID 38000000 IRQ 314
[   93.020810] reiser4: sdb2: found disk format 4.0.0.
[  101.258255] reiser4: sda6: found disk format 4.0.0.
[  101.716150] reiser4: sdb1: found disk format 4.0.0.
[  102.062717] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1=20
across:1951888k
[  103.594035] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[  103.594041] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18=
=20
(level, low) -> IRQ 18
[  103.595129] Audigy2 value: Special config.
[  105.122084] w83627ehf: Found W83627EHG chip at 0x290
[  106.260422] r8169: eth0: link up
[  106.260427] r8169: eth0: link up
[  106.747221] NET: Registered protocol family 17
[  110.231622] nvidia: module license 'NVIDIA' taints kernel.
[  110.403019] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 17
[  110.403027] ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNED] -> GSI 17=
=20
(level, low) -> IRQ 17
[  110.403032] PCI: Setting latency timer of device 0000:04:00.0 to 64
[  110.403117] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  171.06  Wed =
=46eb=20
20 09:02:26 PST 2008
[  299.415650] usb 1-3.2: new full speed USB device using ehci_hcd and addr=
ess=20
9
[  299.483823] usb 1-3.2: configuration #1 chosen from 2 choices
[  299.509674] Initializing USB Mass Storage driver...
[  299.509771] scsi4 : SCSI emulation for USB Mass Storage devices
[  299.509315] usb-storage: device found at 9
[  299.509318] usb-storage: waiting for device to settle before scanning
[  299.509821] usbcore: registered new interface driver usb-storage
[  299.509823] USB Mass Storage support registered.
[  302.973619] scsi 4:0:0:0: Direct-Access     Motorola Motorola Phone   2.=
31=20
PQ: 0 ANSI: 2
[  303.092568] sd 4:0:0:0: [sdc] 979456 512-byte hardware sectors (501 MB)
[  303.100559] sd 4:0:0:0: [sdc] Write Protect is off
[  303.100563] sd 4:0:0:0: [sdc] Mode Sense: 0b 00 00 08
[  303.100574] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[  303.130402] sd 4:0:0:0: [sdc] 979456 512-byte hardware sectors (501 MB)
[  303.138545] sd 4:0:0:0: [sdc] Write Protect is off
[  303.138548] sd 4:0:0:0: [sdc] Mode Sense: 0b 00 00 08
[  303.138550] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[  303.138552]  sdc: sdc1
[  303.161436] sd 4:0:0:0: [sdc] Attached SCSI removable disk
[  303.161600] usb-storage: device scan complete
[  303.176188] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  303.176213] sd 1:0:0:0: Attached scsi generic sg1 type 0
[  303.176238] sd 4:0:0:0: Attached scsi generic sg2 type 0

cat /proc/interrupts
           CPU0       CPU1
  0:         56          1   IO-APIC-edge      timer
  1:         11       4589   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc
  9:          0          1   IO-APIC-fasteoi   acpi
 12:          0          3   IO-APIC-edge      i8042
 17:         26      70891   IO-APIC-fasteoi   nvidia
 18:          0          0   IO-APIC-fasteoi   EMU10K1
 22:         49      30631   IO-APIC-fasteoi   ehci_hcd:usb1
314:          9       4439   PCI-MSI-edge      eth0
315:         32      27847   PCI-MSI-edge      ahci
NMI:          0          0   Non-maskable interrupts
LOC:     105026     170031   Local timer interrupts
RES:      27983      12360   Rescheduling interrupts
CAL:       1902        237   function call interrupts
TLB:       5129       4330   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 67
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
stepping        : 3
cpu MHz         : 2000.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca=
=20
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdts=
cp=20
lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy svm extapic cr8_lega=
cy
bogomips        : 4023.10
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 67
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
stepping        : 3
cpu MHz         : 2000.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca=
=20
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdts=
cp=20
lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy svm extapic cr8_lega=
cy
bogomips        : 4023.10
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

 sh /usr/src/linux/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux energy 2.6.24.2reiser4 #6 SMP Tue Mar 4 17:28:59 CET 2008 x86_64 AMD=
=20
Athlon(tm) 64 X2 Dual Core Processor 6000+ AuthenticAMD GNU/Linux

Gnu C                  4.2.3
Gnu make               3.81
binutils               2.18.50.0.4.20080208
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.4
e2fsprogs              1.40.6
reiserfsprogs          3.6.19
reiser4progs           1.0.6
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.10
udev                   118
Modules Loaded         nls_iso8859_15 nls_cp850 vfat fat nls_base sg=20
usb_storage nvidia af_packet k8temp w83627ehf hwmon_vid hwmon i2c_core=20
snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi=20
snd_seq_midi_emul snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event=
=20
snd_seq snd_emu10k1 snd_rawmidi firmware_class snd_ac97_codec ac97_bus=20
snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd=
=20
soundcore r8169

If you want/need more information or want me to do something please ask me=
=20
directly - I am not subscribed to any of the two lists. If I need to RTFM=20
please point me to the right FM.

Gl=FCck Auf,
Volker

--Boundary-00=_prC1HU46IH2JXNA
Content-Type: text/plain;
  charset="us-ascii";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24.2
# Tue Mar  4 17:20:19 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
# CONFIG_QUICKLIST is not set
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_SUPPORTS_OPROFILE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="reiser4"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=16
# CONFIG_CGROUPS is not set
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
# CONFIG_KALLSYMS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
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
# CONFIG_X86_VSMP is not set
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
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NUMA is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_SMP_POSSIBLE=y
CONFIG_SUSPEND=y
CONFIG_HIBERNATION_SMP_POSSIBLE=y
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
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
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
# CONFIG_CPU_IDLE is not set

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
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
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
CONFIG_CHR_DEV_SG=m
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
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
# CONFIG_R8169_NAPI is not set
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
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
# CONFIG_SHAPER is not set
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
CONFIG_INPUT_MOUSEDEV_PSAUX=y
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
# CONFIG_SERIAL_NONSTANDARD is not set

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
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

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

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
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
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
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

#
# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
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
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DPC is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_VIDEO_PVRUSB2 is not set
CONFIG_VIDEO_EM28XX=m
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
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_CORE=m
CONFIG_DVB_CORE_ATTACH=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET is not set
# CONFIG_DVB_BUDGET_CI is not set
# CONFIG_DVB_BUDGET_AV is not set

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
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_TDA10086 is not set

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
# CONFIG_DVB_LGDT330X is not set
# CONFIG_DVB_S5H1409 is not set

#
# Tuners/PLL support
#
# CONFIG_DVB_PLL is not set
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TDA827X is not set
# CONFIG_DVB_TUNER_QT1010 is not set
# CONFIG_DVB_TUNER_MT2060 is not set
# CONFIG_DVB_TUNER_MT2266 is not set
# CONFIG_DVB_TUNER_MT2131 is not set
# CONFIG_DVB_TUNER_DIB0070 is not set

#
# Miscellaneous devices
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DVB_TUA6100 is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_TUNER_CUSTOMIZE=y
CONFIG_TUNER_MT20XX=m
CONFIG_TUNER_TDA8290=m
CONFIG_TUNER_TEA5761=m
CONFIG_TUNER_TEA5767=m
CONFIG_TUNER_SIMPLE=m
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
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
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m

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
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
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
# SoC Audio support for SuperH
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

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_SPLIT_ISO is not set
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
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
# CONFIG_USB_STORAGE_KARMA is not set
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

#
# USB Serial Converter support
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

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y

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
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

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
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=m
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
# CONFIG_INSTRUMENTATION is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y
# CONFIG_CRYPTO_MANAGER is not set
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_XTS is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
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

--Boundary-00=_prC1HU46IH2JXNA--
