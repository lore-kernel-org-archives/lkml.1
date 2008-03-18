Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbYCRLAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbYCRLAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYCRLAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:00:21 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:52262 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYCRK7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 06:59:53 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Tue, 18 Mar 2008 11:59:48 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803170816.50597.volker.armin.hemmann@tu-clausthal.de> <47DF70F3.9080305@gmail.com>
In-Reply-To: <47DF70F3.9080305@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kC63HF2ic1vWsby"
Message-Id: <200803181159.48327.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_kC63HF2ic1vWsby
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Dienstag, 18. M=E4rz 2008, Tejun Heo wrote:
> Hello,
>
> Volker Armin Hemmann wrote:
> > I tried some more stuff, replaced the cables, played with bios settings.
> >
> > No change.
> >
> > Then I updated to 2.6.24.3 - and no hangs or 'softreset' failures
> > anymore.
>
> I don't see any libata changes which can cause such difference.  Weird.
>  Is this result reliably reproducible?

it was for a little bit more than 24h. I booted and rebooted several times =
to=20
make sure - and everything was fine, but after a good night and on the Xth=
=20
boot, the hang occured again - and since then it is there. Reliable on ever=
y=20
boot :(=20
(and the softreset failed message on reboots).
Of course, I booted and rebooted several times. And it stays.

Maybe it is the hardware. But I replaced the cables already and smart says =
the=20
disk is ok.

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)=
 =20
LBA
_of_first_error
# 1  Short offline       Completed without error       00%      8124       =
  -
# 2  Short offline       Completed without error       00%      8067       =
  -
# 3  Short offline       Completed without error       00%      3402       =
  -
# 4  Extended offline    Completed without error       00%      3374       =
  -
<snip>



>
> > 2.6.24.2 and 2.6.24.3 both have the reiser4 patch added.
> >
> > So
> > 2.6.24.2 =3D bad
> > 2.6.24.3 =3D good

it only was good for a couple of boots.=20

> > 2.6.25-rc5 =3D bad
> >
> > Setting AHCI in bios still results in timeouts and harddisks not found.
>
> Does pci=3Dnomsi help?

oh yes!
 It does. I changed the 'Sata operation mode' setting from 'non raid' to AH=
CI,=20
booted with that option:

[   35.026629] Driver 'sd' needs updating - please use bus_type methods
[   35.026702] ahci 0000:00:0a.0: version 3.0
[   35.026877] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   35.026922] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
=20
(level, low) -> IRQ 23
[   36.029726] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl SATA mode
[   36.029777] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[   36.029817] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   36.030019] scsi0 : ahci
[   36.030114] scsi1 : ahci
[   36.030180] scsi2 : ahci
[   36.030245] scsi3 : ahci
[   36.030333] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0=20
irq 23
[   36.030381] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0=20
irq 23
[   36.030428] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0=20
irq 23
[   36.030476] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0=20
irq 23
[   36.659406] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   36.660019] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   36.660062] ata1.00: 312581808 sectors, multi 16: LBA48
[   36.660680] ata1.00: configured for UDMA/133
[   37.291368] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   37.311928] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   37.311968] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   37.313968] ata2.00: configured for UDMA/133
[   37.630631] ata3: SATA link down (SStatus 0 SControl 300)
[   37.949937] ata4: SATA link down (SStatus 0 SControl 300)
[   37.950026] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[   37.950136] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   37.950181] sd 0:0:0:0: [sda] Write Protect is off
[   37.950219] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   37.950227] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   37.950297] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   37.950340] sd 0:0:0:0: [sda] Write Protect is off
[   37.950378] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   37.950385] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   37.950434]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   37.984324] sd 0:0:0:0: [sda] Attached SCSI disk
[   37.984459] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10=20
PQ: 0 ANSI: 5
[   37.984568] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   37.984612] sd 1:0:0:0: [sdb] Write Protect is off
[   37.984650] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   37.984659] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   37.984729] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   37.984772] sd 1:0:0:0: [sdb] Write Protect is off
[   37.984810] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   37.984817] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   37.984866]  sdb: sdb1 sdb2
[   37.994164] sd 1:0:0:0: [sdb] Attached SCSI disk

the most obvious change are the different interrupts: 23 instead of 315=20
(non-raid, without nosmi) or 218 (systemrescuecd 1.0, ahci setting, without=
=20
nosmi)

full dmesg is attached.

Thanks for looking into this mess.

Gl=FCck Auf,
Volker

--Boundary-00=_kC63HF2ic1vWsby
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg_2.6.24.3_nosmi"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.24.3_nosmi"

[    0.000000] Linux version 2.6.24.3reiser4 (root@energy) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Sun Mar 16 20:32:58 CET 2008
[    0.000000] Command line: root=/dev/sda3 nmi_watchdog=0 console=tty6 pci=nomsi
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
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT       97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL 20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT       97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT       97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT       97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT       97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
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
[    0.000000]   DMA zone: 853 pages reserved
[    0.000000]   DMA zone: 3090 pages, LIFO batch:0
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
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e6000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e6000 - 0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffb0000 - 00000000cffc0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffc0000 - 00000000cfff0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cfff0000 - 00000000d0000000
[    0.000000] swsusp: Registered nosave memory region: 00000000d0000000 - 00000000fec00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec00000 - 00000000fec01000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec01000 - 00000000fee00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fef00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fef00000 - 00000000ff380000
[    0.000000] swsusp: Registered nosave memory region: 00000000ff380000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 31408 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030522
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0 console=tty6 pci=nomsi
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[   34.594710] Marking TSC unstable due to TSCs unsynchronized
[   34.594711] time.c: Detected 3013.887 MHz processor.
[   34.598537] Console: colour VGA+ 80x25
[   34.598539] console [tty6] enabled
[   34.603172] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[   34.605402] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   34.606172] Checking aperture...
[   34.606210] CPU 0: aperture @ ecca000000 size 32 MB
[   34.606247] Aperture too small (32 MB)
[   34.612116] No AGP bridge found
[   34.612152] Your BIOS doesn't leave a aperture memory hole
[   34.612190] Please enable the IOMMU option in the BIOS setup
[   34.612228] This costs you 64 MB of RAM
[   34.637460] Mapping aperture over 65536 KB of RAM @ 8000000
[   34.661594] Memory: 4049948k/4980736k available (2192k kernel code, 143428k reserved, 681k data, 176k init)
[   34.661662] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   34.744360] Calibrating delay using timer specific routine.. 6034.68 BogoMIPS (lpj=10053891)
[   34.744453] Mount-cache hash table entries: 256
[   34.744559] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   34.744599] CPU: L2 Cache: 1024K (64 bytes/line)
[   34.744637] CPU: Physical Processor ID: 0
[   34.744673] CPU: Processor Core ID: 0
[   34.744726] SMP alternatives: switching to UP code
[   34.745090] ACPI: Core revision 20070126
[   34.780262] Using local APIC timer interrupts.
[   34.813406] APIC timer calibration result 12557872
[   34.813408] Detected 12.557 MHz APIC timer.
[   34.813493] SMP alternatives: switching to SMP code
[   34.813723] Booting processor 1/2 APIC 0x1
[   34.823842] Initializing CPU#1
[   34.906605] Calibrating delay using timer specific routine.. 6030.92 BogoMIPS (lpj=10046281)
[   34.906609] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   34.906611] CPU: L2 Cache: 1024K (64 bytes/line)
[   34.906612] CPU: Physical Processor ID: 0
[   34.906613] CPU: Processor Core ID: 1
[   34.906694] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   34.906751] Brought up 2 CPUs
[   34.907209] net_namespace: 120 bytes
[   34.907441] NET: Registered protocol family 16
[   34.907553] ACPI: bus type pci registered
[   34.907635] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   34.907674] PCI: Not using MMCONFIG.
[   34.907710] PCI: Using configuration type 1
[   34.909951] ACPI: EC: Look up EC in DSDT
[   34.913397] ACPI: Interpreter enabled
[   34.913434] ACPI: (supports S0 S1 S3 S4 S5)
[   34.913604] ACPI: Using IOAPIC for interrupt routing
[   34.913814] Error attaching device data
[   34.913853] Error attaching device data
[   34.913892] Error attaching device data
[   34.913930] Error attaching device data
[   34.918844] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   34.919369] PCI: Transparent bridge - 0000:00:08.0
[   34.919663] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   34.919795] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   34.919892] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   34.919948] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   34.920002] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   34.920058] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   34.923995] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   34.924331] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   34.924666] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[   34.925027] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[   34.925387] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[   34.925747] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   34.926081] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[   34.926441] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   34.926777] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   34.927112] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[   34.927472] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   34.927807] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[   34.928167] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[   34.928528] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   34.928862] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
[   34.929223] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   34.929557] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[   34.929954] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[   34.930315] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
[   34.930676] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
[   34.930995] Linux Plug and Play Support v0.97 (c) Adam Belay
[   34.931048] pnp: PnP ACPI init
[   34.931087] ACPI: bus type pnp registered
[   34.933625] pnp: PnP ACPI: found 13 devices
[   34.933662] ACPI: ACPI bus type pnp unregistered
[   34.933785] SCSI subsystem initialized
[   34.933842] libata version 3.00 loaded.
[   34.933892] usbcore: registered new interface driver usbfs
[   34.933948] usbcore: registered new interface driver hub
[   34.934004] usbcore: registered new device driver usb
[   34.934088] PCI: Using ACPI for IRQ routing
[   34.934125] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   34.943200] PCI-DMA: Disabling AGP.
[   34.943936] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   34.943978] PCI-DMA: using GART IOMMU.
[   34.944017] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   34.944176] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   34.944316] hpet0: 3 32-bit timers, 25000000 Hz
[   34.946485] Time: hpet clocksource has been installed.
[   34.946534] Switched to high resolution mode on CPU 0
[   34.946623] Switched to high resolution mode on CPU 1
[   34.953217] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   34.956617] system 00:05: ioport range 0x800-0x80f has been reserved
[   34.956656] system 00:05: ioport range 0x2000-0x207f has been reserved
[   34.956696] system 00:05: ioport range 0x2080-0x20ff has been reserved
[   34.956735] system 00:05: ioport range 0x2400-0x247f has been reserved
[   34.956774] system 00:05: ioport range 0x2480-0x24ff has been reserved
[   34.956814] system 00:05: ioport range 0x2800-0x287f has been reserved
[   34.956853] system 00:05: ioport range 0x2880-0x28ff has been reserved
[   34.956892] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   34.956931] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[   34.956971] system 00:05: iomem range 0x0-0x0 could not be reserved
[   34.957011] system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[   34.957055] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[   34.957102] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[   34.957153] system 00:0a: ioport range 0x290-0x29f has been reserved
[   34.957196] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[   34.957241] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   34.957280] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   34.957323] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   34.957363] system 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[   34.957410] system 00:0c: iomem range 0xff380000-0xffffffff could not be reserved
[   34.957692] PCI: Bridge: 0000:00:08.0
[   34.957729]   IO window: d000-dfff
[   34.957766]   MEM window: f9f00000-f9ffffff
[   34.957804]   PREFETCH window: disabled.
[   34.957841] PCI: Bridge: 0000:00:0b.0
[   34.957878]   IO window: c000-cfff
[   34.957914]   MEM window: f9e00000-f9efffff
[   34.957951]   PREFETCH window: disabled.
[   34.957988] PCI: Bridge: 0000:00:0c.0
[   34.958024]   IO window: disabled.
[   34.958061]   MEM window: disabled.
[   34.958097]   PREFETCH window: disabled.
[   34.958134] PCI: Bridge: 0000:00:0d.0
[   34.958171]   IO window: e000-efff
[   34.958207]   MEM window: fa000000-febfffff
[   34.958244]   PREFETCH window: d0000000-dfffffff
[   34.958282] PCI: Bridge: 0000:00:0e.0
[   34.958318]   IO window: disabled.
[   34.958354]   MEM window: disabled.
[   34.958391]   PREFETCH window: disabled.
[   34.958433] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   34.958442] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   34.958447] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   34.958452] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   34.958456] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   34.958462] NET: Registered protocol family 2
[   34.989784] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   34.990379] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[   34.991804] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   34.992283] TCP: Hash tables configured (established 262144 bind 65536)
[   34.992323] TCP reno registered
[   35.000566] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[   35.000670] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[   35.000717] io scheduler noop registered
[   35.000756] io scheduler cfq registered (default)
[   35.001452] Boot video device is 0000:04:00.0
[   35.001555] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   35.001572] assign_interrupt_mode Found MSI capability
[   35.001613] Allocate Port Service[0000:00:0b.0:pcie00]
[   35.001655] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   35.001671] assign_interrupt_mode Found MSI capability
[   35.001709] Allocate Port Service[0000:00:0c.0:pcie00]
[   35.001745] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   35.001761] assign_interrupt_mode Found MSI capability
[   35.001800] Allocate Port Service[0000:00:0d.0:pcie00]
[   35.001837] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   35.001853] assign_interrupt_mode Found MSI capability
[   35.001891] Allocate Port Service[0000:00:0e.0:pcie00]
[   35.002065] input: Power Button (FF) as /class/input/input0
[   35.002103] ACPI: Power Button (FF) [PWRF]
[   35.002188] input: Power Button (CM) as /class/input/input1
[   35.002227] ACPI: Power Button (CM) [PWRB]
[   35.002361] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
[   35.002466] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
[   35.026407] Real Time Clock Driver v1.12ac
[   35.026526] hpet_resources: 0xfed00000 is busy
[   35.026543] Linux agpgart interface v0.102
[   35.026629] Driver 'sd' needs updating - please use bus_type methods
[   35.026702] ahci 0000:00:0a.0: version 3.0
[   35.026877] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   35.026922] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[   36.029726] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[   36.029777] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[   36.029817] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   36.030019] scsi0 : ahci
[   36.030114] scsi1 : ahci
[   36.030180] scsi2 : ahci
[   36.030245] scsi3 : ahci
[   36.030333] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 23
[   36.030381] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 23
[   36.030428] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 23
[   36.030476] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 23
[   36.659406] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   36.660019] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   36.660062] ata1.00: 312581808 sectors, multi 16: LBA48 
[   36.660680] ata1.00: configured for UDMA/133
[   37.291368] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   37.311928] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   37.311968] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   37.313968] ata2.00: configured for UDMA/133
[   37.630631] ata3: SATA link down (SStatus 0 SControl 300)
[   37.949937] ata4: SATA link down (SStatus 0 SControl 300)
[   37.950026] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 PQ: 0 ANSI: 5
[   37.950136] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   37.950181] sd 0:0:0:0: [sda] Write Protect is off
[   37.950219] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   37.950227] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.950297] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   37.950340] sd 0:0:0:0: [sda] Write Protect is off
[   37.950378] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   37.950385] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.950434]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   37.984324] sd 0:0:0:0: [sda] Attached SCSI disk
[   37.984459] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[   37.984568] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   37.984612] sd 1:0:0:0: [sdb] Write Protect is off
[   37.984650] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   37.984659] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.984729] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   37.984772] sd 1:0:0:0: [sdb] Write Protect is off
[   37.984810] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   37.984817] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.984866]  sdb: sdb1 sdb2
[   37.994164] sd 1:0:0:0: [sdb] Attached SCSI disk
[   37.994301] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   37.996942] serio: i8042 KBD port at 0x60,0x64 irq 1
[   37.996982] serio: i8042 AUX port at 0x60,0x64 irq 12
[   38.027362] usbcore: registered new interface driver usbhid
[   38.027401] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   38.027445] TCP cubic registered
[   38.027484] NET: Registered protocol family 1
[   38.027539] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[   38.027584] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   38.027624] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   38.027662] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   38.027700] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   38.027738] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   38.027776] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   38.027815] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   38.027853] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   38.053987] input: AT Translated Set 2 keyboard as /class/input/input2
[   38.146929] ReiserFS: sda3: found reiserfs format "3.6" with standard journal
[   38.146972] ReiserFS: sda3: using ordered data mode
[   38.156481] ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   38.157392] ReiserFS: sda3: checking transaction log (sda3)
[   38.200787] ReiserFS: sda3: Using r5 hash to sort names
[   38.200838] VFS: Mounted root (reiserfs filesystem) readonly.
[   38.200887] Freeing unused kernel memory: 176k freed
[   38.480137] Clocksource tsc unstable (delta = -135289750 ns)
[   40.000024] ReiserFS: sda3: switching to journaled data mode
[   40.140567] r8169 Gigabit Ethernet driver 2.2LK loaded
[   40.140772] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   40.140777] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[   40.140785] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   40.140790] r8169 0000:01:00.0: no MSI. Back to INTx.
[   40.140914] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, XID 38000000 IRQ 19
[   40.146015] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   40.146021] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
[   40.146171] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   40.146174] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   40.146248] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   40.146269] ehci_hcd 0000:00:02.1: debug port 1
[   40.146271] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   40.146278] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   40.149046] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   40.149116] usb usb1: configuration #1 chosen from 1 choice
[   40.149131] hub 1-0:1.0: USB hub found
[   40.149136] hub 1-0:1.0: 10 ports detected
[   40.258499] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   40.296057] reiser4: sdb2: found disk format 4.0.0.
[   40.301115] usb 1-3: configuration #1 chosen from 1 choice
[   40.301307] hub 1-3:1.0: USB hub found
[   40.302020] hub 1-3:1.0: 4 ports detected
[   40.398307] usb 1-3.1: new low speed USB device using ehci_hcd and address 3
[   40.428288] usb 1-3.1: configuration #1 chosen from 1 choice
[   40.431891] input: Logitech USB Receiver as /class/input/input3
[   40.437320] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   40.439385] input: Logitech USB Receiver as /class/input/input4
[   40.455077] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   40.463944] mice: PS/2 mouse device common for all mice
[   48.714006] reiser4: sda6: found disk format 4.0.0.
[   49.173963] reiser4: sdb1: found disk format 4.0.0.
[   49.537860] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
[   52.661003] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   52.661012] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   52.663793] Audigy2 value: Special config.
[   54.558692] w83627ehf: Found W83627EHG chip at 0x290
[   55.654993] r8169: eth0: link up
[   55.655000] r8169: eth0: link up
[   56.073125] NET: Registered protocol family 17
[   59.453903] nvidia: module license 'NVIDIA' taints kernel.
[   59.625059] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 17
[   59.625067] ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNED] -> GSI 17 (level, low) -> IRQ 17
[   59.625072] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   59.625155] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  171.06  Wed Feb 20 09:02:26 PST 2008

--Boundary-00=_kC63HF2ic1vWsby--
