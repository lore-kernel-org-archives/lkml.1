Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZJKJzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZJKJzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbZJKJz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:55:29 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:59762 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbZJKJz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=YNC569e+eAL3rTu3K90Zarh1dMBHPgliINwbx0hK60DiqXoJ7xBJkufxN5P5ArRmHx
         IWub8e0QWxSxfDAl5WA7UcfOpchuhZqKhbg6pwT35blFDlhTBf30sAv6aXdHV5jh47W9
         4wTOsY+WO/xxMhgx0RlHeXvRwiAeLX/oR/XMM=
MIME-Version: 1.0
Date: Sun, 11 Oct 2009 11:54:49 +0200
Message-ID: <71cd59b00910110254q2e5318cfw30ac0a4f86770487@mail.gmail.com>
Subject: VT6421 problems with sata_via
From: Corentin Chary <corentin.chary@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I recently needed some more space and bought a Deskstar 7K1000.B for my server.
The motherboard is old, and did not have SATA port, so I added a
VT6421 PCI SATA controller.
I was first able to run cfdisk to setup the partition table.
The I tried to run hdparm -tT on it (mkfs.ext4 did'nt work either) but
I doesn't work (I/O errors).
Note that I dowgraded the disk to SATA I using hitachi tools. Also
tested the disk on a motherboard with SATA and it seems ok.

Any idea ?
Thanks

lspci + dmesg below:

00:0f.0 RAID bus controller: VIA Technologies, Inc. VT6421 IDE RAID
Controller (rev 50)
        Subsystem: VIA Technologies, Inc. VT6421 IDE RAID Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at d000 [size=16]
        Region 1: I/O ports at b800 [size=16]
        Region 2: I/O ports at b400 [size=16]
        Region 3: I/O ports at b000 [size=16]
        Region 4: I/O ports at a800 [size=32]
        Region 5: I/O ports at a400 [size=256]
        [virtual] Expansion ROM at 40010000 [disabled] [size=64K]
        Capabilities: [e0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: sata_via

[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1916.734 MHz processor.
[    0.001217] Console: colour VGA+ 80x25
[    0.001220] console [tty0] enabled
[    0.004000] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3833.46 BogoMIPS (lpj=7666936)
[    0.004000] Mount-cache hash table entries: 512
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] mce: CPU supports 4 MCE banks
[    0.004000] Checking 'hlt' instruction... OK.
[    0.016354] SMP alternatives: switching to UP code
[    0.019735] Freeing SMP alternatives: 15k freed
[    0.019815] ACPI: Core revision 20090521
[    0.029040] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068811] CPU0: AMD Athlon(TM) XP 2600+ stepping 00
[    0.072001] Brought up 1 CPUs
[    0.072001] Total of 1 processors activated (3833.46 BogoMIPS).
[    0.072001] NET: Registered protocol family 16
[    0.072001] ACPI: bus type pci registered
[    0.072001] PCI: Using configuration type 1 for base access
[    0.072176] bio: create slab <bio-0> at 0
[    0.072820] ACPI: EC: Look up EC in DSDT
[    0.081700] ACPI: Interpreter enabled
[    0.081772] ACPI: (supports S0 S5)
[    0.081916] ACPI: Using IOAPIC for interrupt routing
[    0.098369] ACPI: No dock devices found.
[    0.098598] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.098749] pci 0000:00:00.0: reg 10 32bit mmio:
[0xf8000000-0xfbffffff]
[    0.098833] pci 0000:00:01.0: supports D1
[    0.098873] pci 0000:00:0d.0: reg 10 io port: [0xd800-0xd8ff]
[    0.098880] pci 0000:00:0d.0: reg 14 32bit mmio:
[0xed800000-0xed8000ff]
[    0.098901] pci 0000:00:0d.0: reg 30 32bit mmio:
[0x000000-0x00ffff]
[    0.098917] pci 0000:00:0d.0: supports D1 D2
[    0.098920] pci 0000:00:0d.0: PME# supported from D1 D2 D3hot
D3cold
[    0.098996] pci 0000:00:0d.0: PME# disabled
[    0.099093] pci 0000:00:0e.0: reg 10 io port: [0xd400-0xd4ff]
[    0.099099] pci 0000:00:0e.0: reg 14 32bit mmio:
[0xed000000-0xed0000ff]
[    0.099133] pci 0000:00:0e.0: supports D1 D2
[    0.099135] pci 0000:00:0e.0: PME# supported from D1 D2 D3hot
D3cold
[    0.099210] pci 0000:00:0e.0: PME# disabled
[    0.099309] pci 0000:00:0f.0: reg 10 io port: [0xd000-0xd00f]
[    0.099315] pci 0000:00:0f.0: reg 14 io port: [0xb800-0xb80f]
[    0.099322] pci 0000:00:0f.0: reg 18 io port: [0xb400-0xb40f]
[    0.099328] pci 0000:00:0f.0: reg 1c io port: [0xb000-0xb00f]
[    0.099335] pci 0000:00:0f.0: reg 20 io port: [0xa800-0xa81f]
[    0.099341] pci 0000:00:0f.0: reg 24 io port: [0xa400-0xa4ff]
[    0.099348] pci 0000:00:0f.0: reg 30 32bit mmio:
[0x000000-0x00ffff]
[    0.099405] pci 0000:00:10.0: reg 20 io port: [0xa000-0xa01f]
[    0.099427] pci 0000:00:10.0: supports D1 D2
[    0.099429] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot
D3cold
[    0.099505] pci 0000:00:10.0: PME# disabled
[    0.099620] pci 0000:00:10.1: reg 20 io port: [0x9800-0x981f]
[    0.099642] pci 0000:00:10.1: supports D1 D2
[    0.099644] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot
D3cold
[    0.099721] pci 0000:00:10.1: PME# disabled
[    0.099834] pci 0000:00:10.2: reg 20 io port: [0x9400-0x941f]
[    0.099856] pci 0000:00:10.2: supports D1 D2
[    0.099858] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot
D3cold
[    0.099934] pci 0000:00:10.2: PME# disabled
[    0.100031] pci 0000:00:10.3: reg 10 32bit mmio:
[0xec800000-0xec8000ff]
[    0.100068] pci 0000:00:10.3: supports D1 D2
[    0.100071] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot
D3cold
[    0.100146] pci 0000:00:10.3: PME# disabled
[    0.100271] HPET not enabled in BIOS. You might try hpet=force boot
option
[    0.100351] pci 0000:00:11.0: quirk: region e400-e47f claimed by
vt8235 PM
[    0.100428] pci 0000:00:11.0: quirk: region e800-e80f claimed by
vt8235 SMB
[    0.100557] pci 0000:00:11.1: reg 20 io port: [0x9000-0x900f]
[    0.100613] pci 0000:00:11.5: reg 10 io port: [0xe000-0xe0ff]
[    0.100651] pci 0000:00:11.5: supports D1 D2
[    0.100683] pci 0000:00:12.0: reg 10 io port: [0x8800-0x88ff]
[    0.100689] pci 0000:00:12.0: reg 14 32bit mmio:
[0xec000000-0xec0000ff]
[    0.100723] pci 0000:00:12.0: supports D1 D2
[    0.100725] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot
D3cold
[    0.100803] pci 0000:00:12.0: PME# disabled
[    0.100922] pci 0000:01:00.0: reg 10 32bit mmio:
[0xee000000-0xeeffffff]
[    0.100928] pci 0000:01:00.0: reg 14 32bit mmio:
[0xf0000000-0xf7ffffff]
[    0.100934] pci 0000:01:00.0: reg 18 32bit mmio:
[0xef800000-0xef87ffff]
[    0.100948] pci 0000:01:00.0: reg 30 32bit mmio:
[0xef7e0000-0xef7fffff]
[    0.100994] pci 0000:00:01.0: bridge 32bit mmio:
[0xee000000-0xef5fffff]
[    0.100999] pci 0000:00:01.0: bridge 32bit mmio pref:
[0xef700000-0xf7ffffff]
[    0.101006] pci_bus 0000:00: on NUMA node 0
[    0.101012] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.101226] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.PCI1._PRT]
[    0.206605] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10
*11 12)
[    0.207149] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10
11 12)
[    0.207689] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11
*12)
[    0.208215] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11
12) *0, disabled.
[    0.208865] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10
11 12)
[    0.209488] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 9 10
11 12)
[    0.210040] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 *6 7 10 11
12 14 15)
[    0.210788] SCSI subsystem initialized
[    0.210900] libata version 3.00 loaded.
[    0.211050] PCI: Using ACPI for IRQ routing
[    0.211735] pnp: PnP ACPI init
[    0.211813] ACPI: bus type pnp registered
[    0.217363] pnp: PnP ACPI: found 13 devices
[    0.217436] ACPI: ACPI bus type pnp unregistered
[    0.217519] system 00:00: iomem range 0x0-0x9ffff could not be
reserved
[    0.217596] system 00:00: iomem range 0xf0000-0xfffff could not be
reserved
[    0.217671] system 00:00: iomem range 0x100000-0x3fffffff could not
be reserved
[    0.217778] system 00:00: iomem range 0xfec00000-0xfec000ff could
not be reserved
[    0.217885] system 00:00: iomem range 0xfee00000-0xfee00fff has
been reserved
[    0.217964] system 00:02: ioport range 0xe400-0xe47f has been
reserved
[    0.218039] system 00:02: ioport range 0xe800-0xe81f could not be
reserved
[    0.218115] system 00:02: iomem range 0xfff80000-0xffffffff could
not be reserved
[    0.218223] system 00:02: iomem range 0xffb80000-0xffbfffff has
been reserved
[    0.218303] system 00:03: ioport range 0x4d0-0x4d1 has been
reserved
[    0.218384] system 00:0c: ioport range 0x290-0x297 has been
reserved
[    0.218458] system 00:0c: ioport range 0x370-0x375 has been
reserved
[    0.253113] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.253188] pci 0000:00:01.0:   IO window: disabled
[    0.253264] pci 0000:00:01.0:   MEM window: 0xee000000-0xef5fffff
[    0.253340] pci 0000:00:01.0:   PREFETCH window:
0xef700000-0xf7ffffff
[    0.253427] pci 0000:00:01.0: setting latency timer to 64
[    0.253432] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.253435] pci_bus 0000:00: resource 1 mem:
[0x000000-0xffffffffffffffff]
[    0.253439] pci_bus 0000:01: resource 1 mem:
[0xee000000-0xef5fffff]
[    0.253442] pci_bus 0000:01: resource 2 pref mem
[0xef700000-0xf7ffffff]
[    0.253463] NET: Registered protocol family 2
[    0.253578] IP route cache hash table entries: 32768 (order: 5,
131072 bytes)
[    0.253954] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.256042] TCP bind hash table entries: 65536 (order: 7, 524288
bytes)
[    0.257150] TCP: Hash tables configured (established 131072 bind
65536)
[    0.257225] TCP reno registered
[    0.257407] NET: Registered protocol family 1
[    0.257726] Simple Boot Flag at 0x3a set to 0x1
[    0.258482] microcode: CPU0: AMD CPU family 0x6 not supported
[    0.258594] Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.263022] Installing knfsd (copyright (C) 1996
okir@monad.swb.de).
[    0.263333] msgmni has been set to 1763
[    0.263582] alg: No test for stdrng (krng)
[    0.263666] io scheduler noop registered
[    0.263822] io scheduler cfq registered (default)
[    0.263907] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
[    0.264129] pci 0000:01:00.0: Boot video device
[    0.264161] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.298870] Real Time Clock Driver v1.12b
[    0.299150] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180
seconds, margin is 60 seconds).
[    0.299823] Hangcheck: Using get_cycles().
[    0.300318] processor LNXCPU:00: registered as cooling_device0
[    0.300499] Serial: 8250/16550 driver, 4 ports, IRQ sharing
disabled
[    0.300681] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.301549] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.755957] Switched to NOHz mode on CPU #0
[    3.316010] floppy0: no floppy controllers found
[    3.317786] brd: module loaded
[    3.318694] loop: module loaded
[    3.318938] sata_via 0000:00:0f.0: version 2.4
[    3.318969] sata_via 0000:00:0f.0: PCI INT A -> GSI 18 (level, low)
-> IRQ 18
[    3.319104] sata_via 0000:00:0f.0: routed to hard irq line 12
[    3.319268] scsi0 : sata_via
[    3.319474] scsi1 : sata_via
[    3.319621] scsi2 : sata_via
[    3.319752] ata1: SATA max UDMA/133 port i16@0xd000 bmdma 0xa800
irq 18
[    3.319828] ata2: SATA max UDMA/133 port i16@0xb800 bmdma 0xa808
irq 18
[    3.319902] ata3: PATA max UDMA/133 port i16@0xb400 bmdma 0xa810
irq 18
[    3.320053] pata_via 0000:00:11.1: version 0.3.4
[    3.320070] pata_via 0000:00:11.1: can't derive routing for PCI INT
A
[    3.320381] scsi3 : pata_via
[    3.320525] scsi4 : pata_via
[    3.321443] ata4: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma
0x9000 irq 14
[    3.321519] ata5: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma
0x9008 irq 15
[    3.321673] <6>8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22,
2004)
[    3.321749] 8139cp 0000:00:0d.0: This (id 10ec:8139 rev 10) is not
an 8139C+ compatible chip, use 8139too
[    3.321868] 8139cp 0000:00:0e.0: This (id 10ec:8139 rev 10) is not
an 8139C+ compatible chip, use 8139too
[    3.322128] 8139too Fast Ethernet driver 0.9.28
[    3.322217] 8139too 0000:00:0d.0: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[    3.322672] eth0: RealTek RTL8139 at 0xf873a000, 00:e0:4c:02:25:33,
IRQ 16
[    3.322765] 8139too 0000:00:0e.0: PCI INT A -> GSI 17 (level, low)
-> IRQ 17
[    3.323163] eth1: RealTek RTL8139 at 0xf873e000, 00:50:bf:e0:d3:62,
IRQ 17
[    3.323424] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.323499] PNP: PS/2 appears to have AUX port disabled, if this is
incorrect please boot with i8042.nopnp
[    3.323973] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.324387] mice: PS/2 mouse device common for all mice
[    3.324587] cpuidle: using governor ladder
[    3.324659] cpuidle: using governor menu
[    3.324936] TCP cubic registered
[    3.325008] NET: Registered protocol family 17
[    3.325211] RPC: Registered udp transport module.
[    3.325284] RPC: Registered tcp transport module.
[    3.325359] Using IPI Shortcut mode
[    3.346864] input: AT Translated Set 2 keyboard as
/class/input/input0
[    3.493910] ata4.00: ATA-7: Maxtor 6L160P0, BAH41G10, max UDMA/133
[    3.493987] ata4.00: 312581808 sectors, multi 16: LBA48
[    3.494293] ata4.01: ATA-7: Hitachi HDS721616PLAT80, P22OA85A, max
UDMA/133
[    3.494369] ata4.01: 321672960 sectors, multi 16: LBA48
[    3.509756] ata4.00: configured for UDMA/133
[    3.524390] ata4.01: configured for UDMA/133
[    3.650459] ata1: SATA link down (SStatus 0 SControl 310)
[    3.968033] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    3.992344] ata2.00: ATA-8: Hitachi HDT721010SLA360, ST6OA3AA, max
UDMA/133
[    3.992419] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth
0/32)
[    4.008361] ata2.00: configured for UDMA/133
[    4.008583] scsi 1:0:0:0: Direct-Access     ATA      Hitachi
HDT72101 ST6O PQ: 0 ANSI: 5
[    4.008880] sd 1:0:0:0: [sda] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    4.009035] sd 1:0:0:0: [sda] Write Protect is off
[    4.009111] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.009135] sd 1:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.009375]  sda:
[    4.009642] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    4.022505]  sda1 sda2
[    4.022933] sd 1:0:0:0: [sda] Attached SCSI disk
[    4.175093] scsi 3:0:0:0: Direct-Access     ATA      Maxtor 6L160P0
  BAH4 PQ: 0 ANSI: 5
[    4.175361] sd 3:0:0:0: [sdb] 312581808 512-byte logical blocks:
(160 GB/149 GiB)
[    4.175509] sd 3:0:0:0: [sdb] Write Protect is off
[    4.175582] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.175604] sd 3:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.175826]  sdb:
[    4.176044] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    4.209190]  sdb1
[    4.209360] scsi 3:0:1:0: Direct-Access     ATA      Hitachi
HDS72161 P22O PQ: 0 ANSI: 5
[    4.209710] sd 3:0:1:0: [sdc] 321672960 512-byte logical blocks:
(164 GB/153 GiB)
[    4.209861] sd 3:0:1:0: [sdc] Write Protect is off
[    4.209933] sd 3:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[    4.209955] sd 3:0:1:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.210165]  sdc:
[    4.210390] sd 3:0:1:0: Attached scsi generic sg2 type 0
[    4.220707]  sdc1 sdc2
[    4.220963] sd 3:0:0:0: [sdb] Attached SCSI disk
[    4.221257] sd 3:0:1:0: [sdc] Attached SCSI disk
[    4.375829] REISERFS (device sdc1): found reiserfs format "3.6"
with standard journal
[    4.375953] REISERFS (device sdc1): using ordered data mode
[    4.386195] REISERFS (device sdc1): journal params: device sdc1,
size 8192, journal first block 18, max trans len 1024, max batch 900,
max commit age 30, max trans age 30
[    4.387850] REISERFS (device sdc1): checking transaction log (sdc1)
[    4.848572] REISERFS (device sdc1): replayed 15 transactions in 0
seconds
[    4.869310] REISERFS (device sdc1): Using r5 hash to sort names
[    4.869424] VFS: Mounted root (reiserfs filesystem) readonly on
device 8:33.
[    4.869536] Freeing unused kernel memory: 384k freed
[    7.448690] udev: starting version 141
[    7.448729] udev: deprecated sysfs layout; update the kernel or
disable CONFIG_SYSFS_DEPRECATED; some udev features will not work
correctly
[    7.956400] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[    7.956405] ata2.00: BMDMA stat 0x4
[    7.956410] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[    7.956420] ata2.00: cmd c8/00:20:00:08:00/00:00:00:00:00/e0 tag 0
dma 16384 in
[    7.956422]          res 51/84:00:1f:08:00/00:00:00:00:00/e0 Emask
0x12 (ATA bus error)
[    7.956426] ata2.00: status: { DRDY ERR }
[    7.956428] ata2.00: error: { ICRC ABRT }
[    7.956439] ata2: hard resetting link
[    8.276541] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    8.300891] ata2.00: configured for UDMA/133
[    8.300956] ata2: EH complete
[    8.306329] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[    8.306334] ata2.00: BMDMA stat 0x5
[    8.306339] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[    8.306349] ata2.00: cmd c8/00:20:00:08:00/00:00:00:00:00/e0 tag 0
dma 16384 in
[    8.306351]          res 51/84:00:1f:08:00/00:00:00:00:00/e0 Emask
0x12 (ATA bus error)
[    8.306354] ata2.00: status: { DRDY ERR }
[    8.306357] ata2.00: error: { ICRC ABRT }
[    8.306368] ata2: hard resetting link
[    8.624043] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    8.648362] ata2.00: configured for UDMA/133
[    8.648385] ata2: EH complete
[    8.656260] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[    8.656264] ata2.00: BMDMA stat 0x5
[    8.656269] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[    8.656278] ata2.00: cmd c8/00:20:00:08:00/00:00:00:00:00/e0 tag 0
dma 16384 in
[    8.656280]          res 51/84:00:1f:08:00/00:00:00:00:00/e0 Emask
0x12 (ATA bus error)
[    8.656284] ata2.00: status: { DRDY ERR }
[    8.656286] ata2.00: error: { ICRC ABRT }
[    8.656296] ata2: hard resetting link
[    8.976032] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    9.000360] ata2.00: configured for UDMA/133
[    9.000367] ata2: EH complete
[    9.006004] ata2.00: limiting speed to UDMA/100:PIO4
[    9.006008] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[    9.006011] ata2.00: BMDMA stat 0x4
[    9.006014] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[    9.006021] ata2.00: cmd c8/00:20:00:08:00/00:00:00:00:00/e0 tag 0
dma 16384 in
[    9.006023]          res 51/84:00:1f:08:00/00:00:00:00:00/e0 Emask
0x12 (ATA bus error)
[    9.006026] ata2.00: status: { DRDY ERR }
[    9.006028] ata2.00: error: { ICRC ABRT }
[    9.006035] ata2: hard resetting link
[    9.324032] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    9.348898] ata2.00: configured for UDMA/100
[    9.348904] ata2: EH complete
[    9.355898] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1280500
action 0x6
[    9.355901] ata2.00: BMDMA stat 0x4
[    9.355904] ata2: SError: { UnrecovData Proto 10B8B BadCRC
TrStaTrns }
[    9.355912] ata2.00: cmd c8/00:20:00:08:00/00:00:00:00:00/e0 tag 0
dma 16384 in
[    9.355913]          res 51/84:00:1f:08:00/00:00:00:00:00/e0 Emask
0x12 (ATA bus error)
[    9.355917] ata2.00: status: { DRDY ERR }
[    9.355919] ata2.00: error: { ICRC ABRT }
[    9.355926] ata2: hard resetting link
[    9.672032] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    9.696360] ata2.00: configured for UDMA/100
[    9.696366] ata2: EH complete
[    9.705768] ata2.00: limiting speed to UDMA/33:PIO4
[    9.705772] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[    9.705775] ata2.00: BMDMA stat 0x5
[    9.705778] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[    9.705785] ata2.00: cmd c8/00:20:00:08:00/00:00:00:00:00/e0 tag 0
dma 16384 in
[    9.705787]          res 51/84:00:1f:08:00/00:00:00:00:00/e0 Emask
0x12 (ATA bus error)
[    9.705790] ata2.00: status: { DRDY ERR }
[    9.705793] ata2.00: error: { ICRC ABRT }
[    9.705800] ata2: hard resetting link
[   10.024610] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   10.048360] ata2.00: configured for UDMA/33
[   10.048375] sd 1:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
[   10.048379] sd 1:0:0:0: [sda] Sense Key : 0xb [current]
[descriptor]
[   10.048384] Descriptor sense data with sense descriptors (in hex):
[   10.048387]         72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[   10.048395]         00 00 08 1f
[   10.048398] sd 1:0:0:0: [sda] ASC=0x47 ASCQ=0x0
[   10.048402] end_request: I/O error, dev sda, sector 2048
[   10.048408] Buffer I/O error on device sda1, logical block 0
[   10.048414] Buffer I/O error on device sda1, logical block 1
[   10.048418] Buffer I/O error on device sda1, logical block 2
[   10.048421] Buffer I/O error on device sda1, logical block 3
[   10.048436] ata2: EH complete
[   10.060522] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[   10.060526] ata2.00: BMDMA stat 0x5
[   10.060530] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[   10.060538] ata2.00: cmd c8/00:20:00:88:38/00:00:00:00:00/e1 tag 0
dma 16384 in
[   10.060540]          res 51/84:00:1f:88:38/00:00:00:00:00/e1 Emask
0x12 (ATA bus error)
[   10.060543] ata2.00: status: { DRDY ERR }
[   10.060545] ata2.00: error: { ICRC ABRT }
[   10.060554] ata2: hard resetting link
[   10.376035] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   10.400361] ata2.00: configured for UDMA/33
[   10.400372] ata2: EH complete
[   10.410412] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[   10.410415] ata2.00: BMDMA stat 0x5
[   10.410418] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[   10.410426] ata2.00: cmd c8/00:20:00:88:38/00:00:00:00:00/e1 tag 0
dma 16384 in
[   10.410427]          res 51/84:00:1f:88:38/00:00:00:00:00/e1 Emask
0x12 (ATA bus error)
[   10.410431] ata2.00: status: { DRDY ERR }
[   10.410433] ata2.00: error: { ICRC ABRT }
[   10.410440] ata2: hard resetting link
[   10.728032] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   10.752987] ata2.00: configured for UDMA/33
[   10.752993] ata2: EH complete
[   10.760309] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[   10.760313] ata2.00: BMDMA stat 0x4
[   10.760316] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[   10.760323] ata2.00: cmd c8/00:20:00:88:38/00:00:00:00:00/e1 tag 0
dma 16384 in
[   10.760325]          res 51/84:00:1f:88:38/00:00:00:00:00/e1 Emask
0x12 (ATA bus error)
[   10.760328] ata2.00: status: { DRDY ERR }
[   10.760330] ata2.00: error: { ICRC ABRT }
[   10.760338] ata2: hard resetting link
[   11.080032] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   11.104359] ata2.00: configured for UDMA/33
[   11.104365] ata2: EH complete
[   11.110213] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[   11.110217] ata2.00: BMDMA stat 0x5
[   11.110220] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[   11.110227] ata2.00: cmd c8/00:20:00:88:38/00:00:00:00:00/e1 tag 0
dma 16384 in
[   11.110229]          res 51/84:00:1f:88:38/00:00:00:00:00/e1 Emask
0x12 (ATA bus error)
[   11.110232] ata2.00: status: { DRDY ERR }
[   11.110235] ata2.00: error: { ICRC ABRT }
[   11.110242] ata2: hard resetting link
[   11.428698] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   11.452365] ata2.00: configured for UDMA/33
[   11.452371] ata2: EH complete
[   36.534034] REISERFS (device sdb1): found reiserfs format "3.6"
with standard journal
[   36.534061] REISERFS (device sdb1): using ordered data mode
[   36.548375] REISERFS (device sdb1): journal params: device sdb1,
size 8192, journal first block 18, max trans len 1024, max batch 900,
max commit age 30, max trans age 30
[   36.549794] REISERFS (device sdb1): checking transaction log (sdb1)
[   36.566360] REISERFS (device sdb1): Using r5 hash to sort names
[   36.759675] Adding 674720k swap on /dev/sdc2.  Priority:-1
extents:1 across:674720k
[   41.087727] ip_tables: (C) 2000-2006 Netfilter Core Team
[   41.194335] nf_conntrack version 0.5.0 (14321 buckets, 57284 max)
[   41.194606] CONFIG_NF_CT_ACCT is deprecated and will be removed
soon. Please use
[   41.194609] nf_conntrack.acct=1 kernel parameter, acct=1
nf_conntrack module option or
[   41.194612] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   41.818616] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x180000
action 0x6 frozen
[   41.818624] ata2: SError: { 10B8B Dispar }
[   41.818633] ata2.00: cmd c8/00:20:00:88:38/00:00:00:00:00/e1 tag 0
dma 16384 in
[   41.818635]          res 40/00:00:1f:88:38/00:00:00:00:00/e1 Emask
0x4 (timeout)
[   41.818639] ata2.00: status: { DRDY }
[   41.818650] ata2: hard resetting link
[   42.138653] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   42.163006] ata2.00: configured for UDMA/33
[   42.163033] ata2: EH complete
[   42.167969] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[   42.167975] ata2.00: BMDMA stat 0x5
[   42.167980] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[   42.167990] ata2.00: cmd c8/00:20:00:88:38/00:00:00:00:00/e1 tag 0
dma 16384 in
[   42.167991]          res 51/84:00:1f:88:38/00:00:00:00:00/e1 Emask
0x12 (ATA bus error)
[   42.167995] ata2.00: status: { DRDY ERR }
[   42.167998] ata2.00: error: { ICRC ABRT }
[   42.168009] ata2: hard resetting link
[   42.486693] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   42.511044] ata2.00: configured for UDMA/33
[   42.511072] sd 1:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
[   42.511076] sd 1:0:0:0: [sda] Sense Key : 0xb [current]
[descriptor]
[   42.511082] Descriptor sense data with sense descriptors (in hex):
[   42.511084]         72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[   42.511092]         01 38 88 1f
[   42.511096] sd 1:0:0:0: [sda] ASC=0x47 ASCQ=0x0
[   42.511100] end_request: I/O error, dev sda, sector 20482048
[   42.511106] Buffer I/O error on device sda2, logical block 0
[   42.511112] Buffer I/O error on device sda2, logical block 1
[   42.511116] Buffer I/O error on device sda2, logical block 2
[   42.511119] Buffer I/O error on device sda2, logical block 3
[   42.511142] ata2: EH complete
[   43.898662] eth0: link down
[   47.533238] eth1: link down
[  100.814847] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1300500
action 0x6
[  100.814852] ata2.00: BMDMA stat 0x5
[  100.814857] ata2: SError: { UnrecovData Proto Dispar BadCRC
TrStaTrns }
[  100.814867] ata2.00: cmd 25/00:00:00:00:00/00:02:00:00:00/e0 tag 0
dma 262144 in
[  100.814869]          res 51/84:80:80:01:00/84:00:00:00:00/e0 Emask
0x12 (ATA bus error)
[  100.814872] ata2.00: status: { DRDY ERR }
[  100.814875] ata2.00: error: { ICRC ABRT }
[  100.814886] ata2: hard resetting link
[  101.132036] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  101.156362] ata2.00: configured for UDMA/33
[  101.156375] ata2: EH complete
[  101.173825] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1300500
action 0x6
[  101.173831] ata2.00: BMDMA stat 0x5
[  101.173836] ata2: SError: { UnrecovData Proto Dispar BadCRC
TrStaTrns }
[  101.173845] ata2.00: cmd 25/00:00:00:06:00/00:02:00:00:00/e0 tag 0
dma 262144 in
[  101.173847]          res 51/84:90:70:07:00/84:00:00:00:00/e0 Emask
0x12 (ATA bus error)
[  101.173851] ata2.00: status: { DRDY ERR }
[  101.173853] ata2.00: error: { ICRC ABRT }
[  101.173864] ata2: hard resetting link
[  101.492043] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  101.516362] ata2.00: configured for UDMA/33
[  101.516380] ata2: EH complete
[  101.529902] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[  101.529908] ata2.00: BMDMA stat 0x5
[  101.529913] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[  101.529923] ata2.00: cmd 25/00:00:00:08:00/00:02:00:00:00/e0 tag 0
dma 262144 in
[  101.529925]          res 51/84:e0:20:08:00/84:01:00:00:00/e0 Emask
0x12 (ATA bus error)
[  101.529928] ata2.00: status: { DRDY ERR }
[  101.529931] ata2.00: error: { ICRC ABRT }
[  101.529942] ata2: hard resetting link
[  101.848036] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  101.857593] ata2.00: failed to read native max address
(err_mask=0x1)
[  101.857597] ata2.00: HPA support seems broken, skipping HPA
handling
[  101.936194] ata2.00: configured for UDMA/33
[  101.936206] ata2: EH complete
[  101.953932] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500
action 0x6
[  101.953935] ata2.00: BMDMA stat 0x5
[  101.953938] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC
TrStaTrns }
[  101.953946] ata2.00: cmd 25/00:00:00:08:00/00:02:00:00:00/e0 tag 0
dma 262144 in
[  101.953947]          res 51/84:e0:20:08:00/84:01:00:00:00/e0 Emask
0x12 (ATA bus error)
[  101.953951] ata2.00: status: { DRDY ERR }
[  101.953953] ata2.00: error: { ICRC ABRT }
[  101.953960] ata2: hard resetting link
[  102.272033] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  102.296192] ata2.00: configured for UDMA/33
[  102.296199] ata2: EH complete
[  102.303830] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1280500
action 0x6
[  102.303834] ata2.00: BMDMA stat 0x5
[  102.303837] ata2: SError: { UnrecovData Proto 10B8B BadCRC
TrStaTrns }
[  102.303845] ata2.00: cmd 25/00:00:00:08:00/00:02:00:00:00/e0 tag 0
dma 262144 in
[  102.303846]          res 51/84:e0:20:08:00/84:01:00:00:00/e0 Emask
0x12 (ATA bus error)
[  102.303850] ata2.00: status: { DRDY ERR }
[  102.303852] ata2.00: error: { ICRC ABRT }
[  102.303859] ata2: hard resetting link
[  102.622398] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  102.644192] ata2.00: configured for UDMA/33
[  102.644198] ata2: EH complete
[  102.653732] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500 action 0x6
[  102.653736] ata2.00: BMDMA stat 0x5
[  102.653739] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC TrStaTrns }
[  102.653747] ata2.00: cmd 25/00:00:00:08:00/00:02:00:00:00/e0 tag 0
dma 262144 in
[  102.653748]          res 51/84:e0:20:08:00/84:01:00:00:00/e0 Emask
0x12 (ATA bus error)
[  102.653752] ata2.00: status: { DRDY ERR }
[  102.653754] ata2.00: error: { ICRC ABRT }
[  102.653761] ata2: hard resetting link
[  102.972033] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  102.996192] ata2.00: configured for UDMA/33
[  102.996198] ata2: EH complete
[  103.003636] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500 action 0x6
[  103.003639] ata2.00: BMDMA stat 0x5
[  103.003642] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC TrStaTrns }
[  103.003650] ata2.00: cmd 25/00:00:00:08:00/00:02:00:00:00/e0 tag 0
dma 262144 in
[  103.003651]          res 51/84:e0:20:08:00/84:01:00:00:00/e0 Emask
0x12 (ATA bus error)
[  103.003655] ata2.00: status: { DRDY ERR }
[  103.003657] ata2.00: error: { ICRC ABRT }
[  103.003664] ata2: hard resetting link
[  103.320043] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  103.344194] ata2.00: configured for UDMA/33
[  103.344216] ata2: EH complete
[  103.353544] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x1380500 action 0x6
[  103.353548] ata2.00: BMDMA stat 0x5
[  103.353552] ata2: SError: { UnrecovData Proto 10B8B Dispar BadCRC TrStaTrns }
[  103.353561] ata2.00: cmd 25/00:00:00:08:00/00:02:00:00:00/e0 tag 0
dma 262144 in
[  103.353563]          res 51/84:e0:20:08:00/84:01:00:00:00/e0 Emask
0x12 (ATA bus error)
[  103.353567] ata2.00: status: { DRDY ERR }
[  103.353569] ata2.00: error: { ICRC ABRT }
[  103.353579] ata2: hard resetting link
[  103.672032] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  103.696192] ata2.00: configured for UDMA/33
[  103.696220] sd 1:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
[  103.696224] sd 1:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
[  103.696230] Descriptor sense data with sense descriptors (in hex):
[  103.696233]         72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[  103.696240]         00 00 08 20
[  103.696244] sd 1:0:0:0: [sda] ASC=0x47 ASCQ=0x0
[  103.696248] end_request: I/O error, dev sda, sector 2048
[  103.696254] Buffer I/O error on device sda, logical block 256
[  103.696260] Buffer I/O error on device sda, logical block 257
[  103.696263] Buffer I/O error on device sda, logical block 258
[  103.696267] Buffer I/O error on device sda, logical block 259
[  103.696270] Buffer I/O error on device sda, logical block 260
[  103.696273] Buffer I/O error on device sda, logical block 261
[  103.696276] Buffer I/O error on device sda, logical block 262
[  103.696279] Buffer I/O error on device sda, logical block 263
[  103.696282] Buffer I/O error on device sda, logical block 264
[  103.696285] Buffer I/O error on device sda, logical block 265
[  103.696322] ata2: EH complete

-- 
Corentin Chary
http://xf.iksaif.net
