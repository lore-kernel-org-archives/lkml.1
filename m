Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbXFKOFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbXFKOFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 10:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXFKOE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 10:04:57 -0400
Received: from mx27.mail.ru ([194.67.23.64]:13401 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbXFKOEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 10:04:55 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Mon, 11 Jun 2007 18:04:47 +0400
User-Agent: KMail/1.9.7
Cc: Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706101047.12118.arvidjaar@mail.ru> <200706101503.29156.bjorn.helgaas@hp.com>
In-Reply-To: <200706101503.29156.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1833067.fIVP9kEsHE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706111804.49752.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1833067.fIVP9kEsHE
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 11 June 2007, Bjorn Helgaas wrote:
> > {pts/1}% lspnp -vv 00:0a
> > 00:0a SMCf010 SMC Fast Infrared Port
> >     state =3D active
> >     allocated resources:
> >         io 0x100-0x107
> > ...
> >
> > {pts/1}% cat /proc/ioports
> > ...
> > 0100-013f : pcmcia_socket0
> > ...
> >
> > {pts/1}% sudo cat
> > /sys/class/pcmcia_socket/pcmcia_socket0/available_resources_io 0x000001=
00
> > - 0x000003af
> > 0x000003e0 - 0x000004ff
> > 0x00000820 - 0x000008ff
> > 0x00000a00 - 0x00000aff
> > 0x00000c00 - 0x00000cf7
>
> It's indeed very interesting that pcmcia_socket0 seems to have its
> fingers in the same ioport range the IR device thinks it's using.
> I don't know much about PCMCIA, but I can see I'm going to have to
> learn something :-)
>

=46or the record - I tried to completely unload PCMCIA driver for slot 0 (a=
nd=20
verified that 0x100 IO port is free) and tried to load smsc, but it did not=
=20
change anything whether I used first or second port for FIR.

> Can you send me your "lspci -vv" output, the whole /proc/ioports and
> /proc/iomem, and your dmesg log?  And maybe your pcmcia_socket
> available_resources_io and available_resources_mem for good measure.
>

Sure.

lspci:
00:00.0 Host bridge: ALi Corporation M1644/M1644T Northbridge+Trident (rev =
01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort+ >SERR- <PERR+
	Latency: 0
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=3D64M]
	Capabilities: [b0] AGP version 2.0
		Status: RQ=3D28 Iso- ArqSz=3D0 Cal=3D0 SBA+ ITACoh- GART64- HTrans- 64bit=
=2D FW-=20
AGP3- Rate=3Dx1,x2,x4
		Command: RQ=3D1 ArqSz=3D0 Cal=3D0 SBA- AGP- GART64- 64bit- FW- Rate=3D<no=
ne>
	Capabilities: [a4] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:01.0 PCI bridge: ALi Corporation PCI to AGP Controller (prog-if 00 [Norm=
al=20
decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbort-=
=20
<MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
	Memory behind bridge: f7f00000-fdffffff
	Prefetchable memory behind bridge: 48000000-480fffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-

00:02.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-i=
f=20
10 [OHCI])
	Subsystem: Toshiba America Info Systems Unknown device 0004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 64 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f7eff000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:04.0 IDE interface: ALi Corporation M5229 IDE (rev c3) (prog-if f0)
	Subsystem: Toshiba America Info Systems Unknown device 0004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 64 (500ns min, 1000ns max)
	Interrupt: pin A routed to IRQ 255
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disable=
d]=20
[size=3D8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disable=
d]=20
[size=3D1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disable=
d]=20
[size=3D8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disable=
d]=20
[size=3D1]
	Region 4: I/O ports at eff0 [size=3D16]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:06.0 Multimedia audio controller: ALi Corporation M5451 PCI AC-Link=20
Controller Audio Device (rev 01)
	Subsystem: Toshiba America Info Systems Unknown device 0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR+ <PERR+
	Latency: 64 (500ns min, 6000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at ed00 [size=3D256]
	Region 1: Memory at f7efe000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2+,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:07.0 ISA bridge: ALi Corporation M1533/M1535 PCI to ISA Bridge [Aladdin=
=20
IV/V/V+]
	Subsystem: Toshiba America Info Systems Unknown device 0004
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [a0] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:08.0 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
	Subsystem: Toshiba America Info Systems Unknown device 0001
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-

00:0a.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100]=
=20
(rev 08)
	Subsystem: Toshiba America Info Systems 8255x-based Fast Ethernet
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f7efd000 (32-bit, non-prefetchable) [size=3D4K]
	Region 1: I/O ports at eb40 [size=3D64]
	Region 2: Memory at f7d00000 (32-bit, non-prefetchable) [size=3D1M]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

00:10.0 CardBus bridge: Texas Instruments PCI1410 PC card Cardbus Controlle=
r=20
(rev 01)
	Subsystem: Lucent Technologies Unknown device ab01
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 168, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 48100000 (32-bit, non-prefetchable) [size=3D4K]
	Bus: primary=3D00, secondary=3D02, subordinate=3D05, sec-latency=3D176
	Memory window 0: 30000000-33fff000 (prefetchable)
	Memory window 1: 34000000-37fff000
	I/O window 0: 00001000-000010ff
	I/O window 1: 00001400-000014ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt- PostWrite+
	16-bit legacy interface ports at 0001

00:11.0 CardBus bridge: Toshiba America Info Systems ToPIC100 PCI to Cardbu=
s=20
Bridge with ZV Support (rev 32)
	Subsystem: Toshiba America Info Systems Unknown device 0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dslow >TAbort- <TAbort-=
=20
<MAbort- >SERR- <PERR-
	Latency: 168
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 48101000 (32-bit, non-prefetchable) [size=3D4K]
	Bus: primary=3D00, secondary=3D06, subordinate=3D09, sec-latency=3D0
	Memory window 0: 38000000-3bfff000 (prefetchable)
	Memory window 1: 3c000000-3ffff000
	I/O window 0: 00001800-000018ff
	I/O window 1: 00001c00-00001cff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

00:11.1 CardBus bridge: Toshiba America Info Systems ToPIC100 PCI to Cardbu=
s=20
Bridge with ZV Support (rev 32)
	Subsystem: Toshiba America Info Systems Unknown device 0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dslow >TAbort- <TAbort-=
=20
<MAbort- >SERR- <PERR-
	Latency: 168
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at 48102000 (32-bit, non-prefetchable) [size=3D4K]
	Bus: primary=3D00, secondary=3D0a, subordinate=3D0d, sec-latency=3D0
	Memory window 0: 40000000-43fff000 (prefetchable)
	Memory window 1: 44000000-47fff000
	I/O window 0: 00002000-000020ff
	I/O window 1: 00002400-000024ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

00:12.0 System peripheral: Toshiba America Info Systems SD TypA Controller=
=20
(rev 03)
	Subsystem: Toshiba America Info Systems Unknown device 0001
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f7cffe00 (32-bit, non-prefetchable) [size=3D512]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

01:00.0 VGA compatible controller: Trident Microsystems CyberBlade XPAi1 (r=
ev=20
82) (prog-if 00 [VGA])
	Subsystem: Toshiba America Info Systems Unknown device 0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 8
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=3D32M]
	Region 1: Memory at fbc00000 (32-bit, non-prefetchable) [size=3D4M]
	Region 2: Memory at f8000000 (32-bit, non-prefetchable) [size=3D32M]
	Region 3: Memory at f7ff8000 (32-bit, non-prefetchable) [size=3D32K]
	[virtual] Expansion ROM at 48000000 [disabled] [size=3D64K]
	Capabilities: [80] AGP version 2.0
		Status: RQ=3D33 Iso- ArqSz=3D0 Cal=3D0 SBA+ ITACoh- GART64- HTrans- 64bit=
=2D FW-=20
AGP3- Rate=3Dx1,x2,x4
		Command: RQ=3D1 ArqSz=3D0 Cal=3D0 SBA- AGP- GART64- 64bit- FW- Rate=3D<no=
ne>
	Capabilities: [90] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-


/proc/ioports:

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0100-013f : pcmcia_socket0
0170-0177 : 0000:00:04.0
  0170-0177 : libata
01f0-01f7 : 0000:00:04.0
  01f0-01f7 : libata
0376-0376 : 0000:00:04.0
  0376-0376 : libata
03c0-03df : vesafb
03f6-03f6 : 0000:00:04.0
  03f6-03f6 : libata
03f8-03ff : serial
0cf8-0cff : PCI conf1
1000-10ff : PCI CardBus #02
1400-14ff : PCI CardBus #02
1800-18ff : PCI CardBus #06
1c00-1cff : PCI CardBus #06
2000-20ff : PCI CardBus #0a
2400-24ff : PCI CardBus #0a
eb40-eb7f : 0000:00:0a.0
  eb40-eb7f : e100
ed00-edff : 0000:00:06.0
  ed00-edff : ALI 5451
ee00-ee3f : 0000:00:08.0
  ee00-ee03 : ACPI PM1a_EVT_BLK
  ee04-ee05 : ACPI PM1a_CNT_BLK
  ee08-ee0b : ACPI PM_TMR
  ee10-ee15 : ACPI CPU throttle
  ee18-ee27 : ACPI GPE0_BLK
  ee34-ee34 : ACPI PM2_CNT_BLK
ef00-ef1f : 0000:00:08.0
  ef00-ef1f : ali1535_smbus
eff0-efff : 0000:00:04.0
  eff0-efff : libata

/proc/iomem:

00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cbfff : Video ROM
000e0000-000eedff : reserved
000eee00-000eefff : ACPI Non-volatile Storage
000f0000-000fffff : System ROM
00100000-1ef5ffff : System RAM
  00100000-002d1409 : Kernel code
  002d140a-003a2c63 : Kernel data
1ef60000-1ef6ffff : ACPI Tables
1ef70000-1fffffff : reserved
30000000-33ffffff : PCI CardBus #02
34000000-37ffffff : PCI CardBus #02
38000000-3bffffff : PCI CardBus #06
3c000000-3fffffff : PCI CardBus #06
40000000-43ffffff : PCI CardBus #0a
44000000-47ffffff : PCI CardBus #0a
48000000-480fffff : PCI Bus #01
  48000000-4800ffff : 0000:01:00.0
48100000-48100fff : 0000:00:10.0
  48100000-48100fff : yenta_socket
48101000-48101fff : 0000:00:11.0
  48101000-48101fff : yenta_socket
48102000-48102fff : 0000:00:11.1
  48102000-48102fff : yenta_socket
60000000-60000fff : pcmcia_socket0
f0000000-f3ffffff : 0000:00:00.0
f7cffe00-f7cfffff : 0000:00:12.0
f7d00000-f7dfffff : 0000:00:0a.0
  f7d00000-f7dfffff : e100
f7efd000-f7efdfff : 0000:00:0a.0
  f7efd000-f7efdfff : e100
f7efe000-f7efefff : 0000:00:06.0
  f7efe000-f7efefff : ALI 5451
f7eff000-f7efffff : 0000:00:02.0
  f7eff000-f7efffff : ohci_hcd
f7f00000-fdffffff : PCI Bus #01
  f7ff8000-f7ffffff : 0000:01:00.0
  f8000000-f9ffffff : 0000:01:00.0
  fbc00000-fbffffff : 0000:01:00.0
  fc000000-fdffffff : 0000:01:00.0
    fc000000-fcffffff : vesafb
fff80000-ffffffff : reserved

dmesg (I played around with smsc so you will see several attempts):

[    0.000000] Linux version 2.6.22-rc4-2avb (bor@cooker) (gcc version 4.1.=
2=20
20070302 (prerelease) (4.1.2-1mdv2007.1)) #13 Sun Jun 10 21:04:18 MSD 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
[    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ef60000 (usable)
[    0.000000]  BIOS-e820: 000000001ef60000 - 000000001ef70000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001ef70000 - 0000000020000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] 495MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 126816) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   126816
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   126816
[    0.000000] On node 0 totalpages: 126816
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 958 pages used for memmap
[    0.000000]   Normal zone: 121762 pages, LIFO batch:31
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
[    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT =
=20
100000A)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] ACPI: PM-Timer IO Port: 0xee08
[    0.000000] Allocating PCI resources starting at 30000000 (gap:=20
20000000:dff80000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 -=
=20
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 -=
=20
00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 -=
=20
00000000000ee000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ee000 -=
=20
00000000000ef000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ef000 -=
=20
0000000000100000
[    0.000000] Built 1 zonelists.  Total pages: 125826
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.22-rc4-kbd-2avb=20
root=3DLABEL=3D/ resume=3D/dev/sda1 vga=3D791
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 747.678 MHz processor.
[   62.470759] Console: colour dummy device 80x25
[   62.471005] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
=20
Ingo Molnar
[   62.471023] ... MAX_LOCKDEP_SUBCLASSES:    8
[   62.471033] ... MAX_LOCK_DEPTH:          30
[   62.471043] ... MAX_LOCKDEP_KEYS:        2048
[   62.471053] ... CLASSHASH_SIZE:           1024
[   62.471063] ... MAX_LOCKDEP_ENTRIES:     8192
[   62.471073] ... MAX_LOCKDEP_CHAINS:      16384
[   62.471083] ... CHAINHASH_SIZE:          8192
[   62.471093]  memory used by lock dependency info: 992 kB
[   62.471104]  per task-struct memory footprint: 1200 bytes
[   62.471116] ------------------------
[   62.471125] | Locking API testsuite:
[  =20
62.471135] ----------------------------------------------------------------=
=2D-----------
[   62.471151]                                  | spin |wlock |rlock |mutex=
 |=20
wsem | rsem |
[  =20
62.471167]   --------------------------------------------------------------=
=2D-----------
[   62.471213]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[   62.473811]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[   62.475664]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[   62.477554]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[   62.479448]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[   62.481400]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[   62.483358]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[   62.485325]                     double unlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[   62.487123]                   initialize held:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[   62.488913]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  =20
62.490761]   --------------------------------------------------------------=
=2D-----------
[   62.490777]               recursive read-lock:             | =20
ok  |             |  ok  |
[   62.491390]            recursive read-lock #2:             | =20
ok  |             |  ok  |
[   62.492001]             mixed read-write-lock:             | =20
ok  |             |  ok  |
[   62.492618]             mixed write-read-lock:             | =20
ok  |             |  ok  |
[  =20
62.493235]   --------------------------------------------------------------=
=2D-----------
[   62.493251]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   62.494162]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   62.495081]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   62.495984]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   62.496891]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[   62.497798]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[   62.498705]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   62.499612]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   62.500524]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   62.501432]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   62.502339]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   62.503273]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   62.504207]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   62.505137]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   62.506067]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   62.506997]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   62.507929]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   62.508855]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   62.509782]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   62.510695]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   62.511611]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   62.512538]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   62.513465]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   62.514395]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   62.515330]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   62.516258]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   62.517192]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   62.518121]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   62.519053]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   62.519978]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   62.520907]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   62.521834]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   62.522768]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   62.523696]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   62.524626]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   62.525557]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   62.526493]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   62.527420]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   62.528355]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   62.529287]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   62.530223]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   62.531149]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   62.532082]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   62.533011]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   62.533948]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   62.534875]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   62.535806]       hard-irq read-recursion/123:  ok  |
[   62.536124]       soft-irq read-recursion/123:  ok  |
[   62.536444]       hard-irq read-recursion/132:  ok  |
[   62.536762]       soft-irq read-recursion/132:  ok  |
[   62.537082]       hard-irq read-recursion/213:  ok  |
[   62.537400]       soft-irq read-recursion/213:  ok  |
[   62.537719]       hard-irq read-recursion/231:  ok  |
[   62.538036]       soft-irq read-recursion/231:  ok  |
[   62.538354]       hard-irq read-recursion/312:  ok  |
[   62.538671]       soft-irq read-recursion/312:  ok  |
[   62.538990]       hard-irq read-recursion/321:  ok  |
[   62.539308]       soft-irq read-recursion/321:  ok  |
[   62.539629] -------------------------------------------------------
[   62.539643] Good, all 218 testcases passed! |
[   62.539653] ---------------------------------
[   62.541298] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[   62.544144] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[   62.648193] Memory: 495900k/507264k available (1861k kernel code, 10784k=
=20
reserved, 838k data, 184k init, 0k highmem)
[   62.648272] virtual kernel memory layout:
[   62.648277]     fixmap  : 0xffff8000 - 0xfffff000   (  28 kB)
[   62.648282]     vmalloc : 0xdf800000 - 0xffff6000   ( 519 MB)
[   62.648286]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[   62.648290]       .init : 0xc03a6000 - 0xc03d4000   ( 184 kB)
[   62.648294]       .data : 0xc02d140a - 0xc03a2c64   ( 838 kB)
[   62.648298]       .text : 0xc0100000 - 0xc02d140a   (1861 kB)
[   62.648344] Checking if this processor honours the WP bit even in=20
supervisor mode... Ok.
[   62.732548] Calibrating delay using timer specific routine.. 1497.68=20
BogoMIPS (lpj=3D2495503)
[   62.732851] Mount-cache hash table entries: 512
[   62.733789] CPU: After generic identify, caps: 0383f9ff 00000000 0000000=
0=20
00000000 00000000 00000000 00000000
[   62.733825] CPU: L1 I cache: 16K, L1 D cache: 16K
[   62.733844] CPU: L2 cache: 256K
[   62.733861] CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000=
040=20
00000000 00000000 00000000
[   62.733898] Compat vDSO mapped to ffffe000.
[   62.733953] CPU: Intel Pentium III (Coppermine) stepping 0a
[   62.733982] Checking 'hlt' instruction... OK.
[   62.746236] ACPI: Core revision 20070126
[   62.766712] Parsing all Control Methods:
[   62.767183] Table [DSDT](id 0001) - 683 Objects with 60 Devices 195 Meth=
ods=20
10 Regions
[   62.767216]  tbxface-0587 [02] tb_load_namespace     : ACPI Tables=20
successfully acquired
[   62.767245] ACPI: setting ELCR to 0200 (from 0a00)
[   62.767811] evxfevnt-0091 [02] enable                : Transition to ACP=
I=20
mode successful
[   62.769429] NET: Registered protocol family 16
[   62.770649] ACPI: bus type pci registered
[   62.771700] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[   62.771716] PCI: Using configuration type 1
[   62.771726] Setting up standard PCI resources
[   62.780975] evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 3F [_GP=
E]=20
8 regs on int 0x9
[   62.784458] evgpeblk-1048 [03] ev_initialize_gpe_bloc: Found 3 Wake,=20
Enabled 0 Runtime GPEs in this block
[   62.785892] Completing Region/Field/Buffer/Package=20
initialization:........................................
[   62.790995] Initialized 8/10 Regions 0/0 Fields 16/16 Buffers 16/27=20
Packages (692 nodes)
[   62.791019] Initializing Device/Processor/Thermal objects by executing _=
INI=20
methods:.
[   62.795837] Executed 1 _INI methods requiring 0 _STA executions (examine=
d=20
64 objects)
[   62.795947] ACPI: Interpreter enabled
[   62.795963] ACPI: (supports S0 S3 S4 S5)
[   62.796153] ACPI: Using PIC for interrupt routing
[   62.839902] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   62.840045] PCI: Probing PCI hardware (bus 00)
[   62.841201] PCI quirk: region ee00-ee3f claimed by ali7101 ACPI
[   62.841225] PCI quirk: region ef00-ef1f claimed by ali7101 SMB
[   62.842978] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   62.843697] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[   62.882557] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[   62.883832] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[   62.885042] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[   62.886305] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[   62.887525] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[   62.888737] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[   62.890370] ACPI: Power Resource [PFAN] (off)
[   62.890436] Linux Plug and Play Support v0.97 (c) Adam Belay
[   62.890562] pnp: PnP ACPI init
[   62.890691] ACPI: bus type pnp registered
[   62.954051] pnp: PnP ACPI: found 12 devices
[   62.954101] ACPI: ACPI bus type pnp unregistered
[   62.954430] PCI: Using ACPI for IRQ routing
[   62.954448] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it=
=20
helps, post a report
[   62.965460] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[   62.965489] pnp: 00:00: iomem range 0xe0000-0xeffff could not be reserved
[   62.965506] pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
[   62.965524] pnp: 00:00: iomem range 0x100000-0x1ef5ffff could not be=20
reserved
[   62.965785] Time: tsc clocksource has been installed.
[   62.997630] PCI: Bridge: 0000:00:01.0
[   62.997661]   IO window: disabled.
[   62.997682]   MEM window: f7f00000-fdffffff
[   62.997699]   PREFETCH window: 48000000-480fffff
[   62.997720] PCI: Bus 2, cardbus bridge: 0000:00:10.0
[   62.997733]   IO window: 00001000-000010ff
[   62.997749]   IO window: 00001400-000014ff
[   62.997765]   PREFETCH window: 30000000-33ffffff
[   62.997781]   MEM window: 34000000-37ffffff
[   62.997797] PCI: Bus 6, cardbus bridge: 0000:00:11.0
[   62.997809]   IO window: 00001800-000018ff
[   62.997824]   IO window: 00001c00-00001cff
[   62.997841]   PREFETCH window: 38000000-3bffffff
[   62.997857]   MEM window: 3c000000-3fffffff
[   62.997874] PCI: Bus 10, cardbus bridge: 0000:00:11.1
[   62.997885]   IO window: 00002000-000020ff
[   62.997901]   IO window: 00002400-000024ff
[   62.997917]   PREFETCH window: 40000000-43ffffff
[   62.997934]   MEM window: 44000000-47ffffff
[   62.997972] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   62.998018] PCI: Enabling device 0000:00:10.0 (0000 -> 0003)
[   63.000663] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   63.000694] PCI: setting IRQ 11 as level-triggered
[   63.000703] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 11=
=20
(level, low) -> IRQ 11
[   63.000762] PCI: Enabling device 0000:00:11.0 (0000 -> 0003)
[   63.002889] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[   63.002906] ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11=
=20
(level, low) -> IRQ 11
[   63.002961] PCI: Enabling device 0000:00:11.1 (0000 -> 0003)
[   63.005055] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[   63.005071] ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11=
=20
(level, low) -> IRQ 11
[   63.005213] NET: Registered protocol family 2
[   63.036018] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[   63.036544] TCP established hash table entries: 16384 (order: 7, 720896=
=20
bytes)
[   63.043090] TCP bind hash table entries: 16384 (order: 7, 720896 bytes)
[   63.049915] TCP: Hash tables configured (established 16384 bind 16384)
[   63.050082] TCP reno registered
[   63.059914] checking if image is initramfs... it is
[   63.277188] Freeing initrd memory: 1171k freed
[   63.279813] audit: initializing netlink socket (disabled)
[   63.279958] audit(1181566616.319:1): initialized
[   63.281313] io scheduler noop registered
[   63.281345] io scheduler anticipatory registered
[   63.281357] io scheduler deadline registered
[   63.281416] io scheduler cfq registered (default)
[   63.281501] Activating ISA DMA hang workarounds.
[   63.281548] Boot video device is 0000:01:00.0
[   63.282463] vesafb: framebuffer at 0xfc000000, mapped to 0xdf880000, usi=
ng=20
3072k, total 16384k
[   63.282499] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[   63.282513] vesafb: protected mode interface info at c000:775e
[   63.282527] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
=20
c00c77e2
[   63.282539] vesafb: scrolling: redraw
[   63.282553] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[   63.353029] Console: switching to colour frame buffer device 128x48
[   63.416464] fb0: VESA VGA frame buffer device
[   63.499013] Switched to high resolution mode on CPU 0
[   63.720982] Real Time Clock Driver v1.12ac
[   63.726162] RAMDISK driver initialized: 16 RAM disks of 32000K size 1024=
=20
blocksize
[   63.728972] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
=20
irq 1,12
[   63.734870] serio: i8042 KBD port at 0x60,0x64 irq 1
[   63.735602] serio: i8042 AUX port at 0x60,0x64 irq 12
[   63.737242] mice: PS/2 mouse device common for all mice
[   63.738753] NET: Registered protocol family 1
[   63.739484] Using IPI Shortcut mode
[   63.741458] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[   63.743207] Freeing unused kernel memory: 184k freed
[   63.744180] Write protecting the kernel text: 1864k
[   63.744842] Write protecting the kernel read-only data: 684k
[   63.778506] SCSI subsystem initialized
[   63.795649] input: AT Translated Set 2 keyboard as /class/input/input0
[   63.857915] libata version 2.21 loaded.
[   63.890575] ACPI: Unable to derive IRQ for device 0000:00:04.0
[   63.915820] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[   63.941192] scsi0 : pata_ali
[   63.966093] scsi1 : pata_ali
[   63.990183] ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma=
=20
0x0001eff0 irq 14
[   64.014754] ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma=
=20
0x0001eff8 irq 15
[   64.199340] ata1.00: ata_hpa_resize 1: sectors =3D 39070080, hpa_sectors=
 =3D=20
39070080
[   64.223901] ata1.00: ATA-5: IC25N020ATDA04-0, DA3OA70A, max UDMA/100
[   64.248487] ata1.00: 39070080 sectors, multi 0: LBA=20
[   64.272985] ata1.00: limited to UDMA/33 due to 40-wire cable
[   64.309244] ata1.00: ata_hpa_resize 1: sectors =3D 39070080, hpa_sectors=
 =3D=20
39070080
[   64.334495] ata1.00: configured for UDMA/33
[   64.688923] ata2.00: ATAPI, max UDMA/33
[   64.895513] ata2.00: configured for UDMA/33
[   64.921423] scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATDA04-0 DA=
3O=20
PQ: 0 ANSI: 5
[   64.949936] scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502 13=
13=20
PQ: 0 ANSI: 5
[   65.009344] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 =
MB)
[   65.035141] sd 0:0:0:0: [sda] Write Protect is off
[   65.060285] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   65.060389] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   65.086647] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 =
MB)
[   65.112551] sd 0:0:0:0: [sda] Write Protect is off
[   65.137989] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   65.138122] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   65.164116]  sda: sda1 sda2
[   65.207818] sd 0:0:0:0: [sda] Attached SCSI disk
[   65.584173] swsusp: Marking nosave pages: 000000000009f000 -=20
0000000000100000
[   65.584199] swsusp: Basic memory bitmaps created
[   65.620553] swsusp: Basic memory bitmaps freed
[   65.749800] ReiserFS: sda2: found reiserfs format "3.6" with standard=20
journal
[   65.775054] ReiserFS: sda2: using ordered data mode
[   65.817514] ReiserFS: sda2: journal params: device sda2, size 8192, jour=
nal=20
first block 18, max trans len 1024, max batch 900, max commit age 30, max=20
trans age 30
[   65.877779] ReiserFS: sda2: checking transaction log (sda2)
[   65.933489] ReiserFS: sda2: Using r5 hash to sort names
[   74.272441] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   74.272528] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   74.490146] Linux agpgart interface v0.102 (c) Dave Jones
[   74.542589] usbcore: registered new interface driver usbfs
[   74.542854] usbcore: registered new interface driver hub
[   74.543072] usbcore: registered new device driver usb
[   74.711847] agpgart: Detected ALi M1644 chipset
[   74.721726] agpgart: AGP aperture is 64M @ 0xf0000000
[   74.772905] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I)=20
Driver
[   74.775874] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[   74.775892] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
=20
(level, low) -> IRQ 11
[   74.775956] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   74.777721] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus=
=20
number 1
[   74.777815] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[   74.831804] usb usb1: configuration #1 chosen from 1 choice
[   74.832118] hub 1-0:1.0: USB hub found
[   74.832217] hub 1-0:1.0: 3 ports detected
[   74.955768] Yenta: CardBus bridge found at 0000:00:10.0 [12a3:ab01]
[   74.955818] Yenta: Enabling burst memory read transactions
[   74.955830] Yenta: Using CSCINT to route CSC interrupts to PCI
[   74.955836] Yenta: Routing CardBus interrupts to PCI
[   74.955848] Yenta TI: socket 0000:00:10.0, mfunc 0x01000002, devctl 0x60
[   74.977822] e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
[   74.977838] e100: Copyright(c) 1999-2006 Intel Corporation
[   75.063210] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   75.063234] Uniform CD-ROM driver Revision: 3.20
[   75.063700] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   75.185635] Yenta: ISA IRQ mask 0x0000, PCI irq 11
[   75.185652] Socket status: 30000011
[   75.186622] Yenta: CardBus bridge found at 0000:00:11.0 [1179:0001]
[   75.315688] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[   75.315703] Socket status: 30000007
[   75.316398] Yenta: CardBus bridge found at 0000:00:11.1 [1179:0001]
[   75.442242] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[   75.442259] Socket status: 30000007
[   75.448429] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   75.448457] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11=
=20
(level, low) -> IRQ 11
[   75.477665] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr=20
00:00:39:D7:14:A1
[   75.491638] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[   75.491664] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
=20
(level, low) -> IRQ 11
[   75.563140] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ=20
sharing enabled
[   75.715360] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   75.818143] pccard: PCMCIA card inserted into slot 0
[   76.208122] NET: Registered protocol family 23
[   79.924209] cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcbff=
f=20
0xe0000-0xfffff
[   79.927926] cs: memory probe 0x60000000-0x60ffffff: clean.
[   79.939570] cs: memory probe 0xa0000000-0xa0ffffff: clean.
[   79.951819] pcmcia: registering new device pcmcia0.0
[   80.382434] wlags49_h1_cs v7.18 for PCMCIA, 03/31/2004 14:31:00 by Agere=
=20
Systems, http://www.agere.com
[   80.382454] *** Modified for kernel 2.6 by Andrey Borzenkov=20
<arvidjaar@mail.ru> $Revision: 39 $
[   80.382463] *** Station Mode (STA) Support: YES
[   80.382469] *** Access Point Mode (AP) Support: YES
[   80.871844] eth1: PRI 31 variant 2 version 9.48
[   80.871913] eth1: NIC 5 variant 2 version 1.02
[   80.875729] eth1: Wireless, io_addr 0x100, irq 11, mac_address=20
00:02:2D:26:95:6C
[   81.373545] Toshiba System Managment Mode driver v1.11 26/9/2001
[   81.579468] Non-volatile memory driver v1.2
[   81.641830] input: ImPS/2 Generic Wheel Mouse as /class/input/input1
[   82.480744] ACPI: AC Adapter [ADP1] (off-line)
[   82.503628] ACPI: Battery Slot [BAT1] (battery present)
[   82.503904] ACPI: Battery Slot [BAT2] (battery absent)
[   82.565695] input: Power Button (FF) as /class/input/input2
[   82.696658] ACPI: Power Button (FF) [PWRF]
[   82.723225] input: Lid Switch as /class/input/input3
[   82.812408] ACPI: Lid Switch [LID]
[   82.932730] ACPI: Transitioning device [FAN] to D3
[   82.932747] ACPI: Transitioning device [FAN] to D3
[   82.932762] ACPI: Fan [FAN] (off)
[   82.967034] ACPI: CPU0 (power states: C1[C1] C2[C2])
[   83.033930] ACPI: Thermal Zone [THRM] (39 C)
[   20.443331] Marking TSC unstable due to: possible TSC halt in C2.
[   20.446664] Time: acpi_pm clocksource has been installed.
[   20.449997] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
[   20.449997] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[   20.486664] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: n=
o)
[   20.653331] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:=
=20
dm-devel@redhat.com
[   20.849997] Clocksource tsc unstable (delta =3D -90684000 ns)
[   21.019997] loop: module loaded
[   25.353330] Adding 500432k swap on /dev/sda1.  Priority:-1 extents:1=20
across:500432k
[   38.063329] usbcore: registered new interface driver usbhid
[   38.063329] /home/bor/src/linux-git/drivers/hid/usbhid/hid-core.c: v2.6:=
USB=20
HID core driver
[   40.703329] process `syslogd' is using obsolete setsockopt SO_BSDCOMPAT
[   43.983328] Bluetooth: Core ver 2.11
[   43.983328] NET: Registered protocol family 31
[   43.983328] Bluetooth: HCI device and connection manager initialized
[   43.983328] Bluetooth: HCI socket layer initialized
[   44.436662] Bluetooth: L2CAP ver 2.8
[   44.436662] Bluetooth: L2CAP socket layer initialized
[   45.383328] Bluetooth: RFCOMM socket layer initialized
[   45.383328] Bluetooth: RFCOMM TTY layer initialized
[   45.383328] Bluetooth: RFCOMM ver 1.8
[   46.743328] NET: Registered protocol family 17
[   50.486661] eth1: PRI 31 variant 2 version 9.48
[   50.486661] eth1: NIC 5 variant 2 version 1.02
[   51.476661] eth1: PRI 31 variant 2 version 9.48
[   51.476661] eth1: NIC 5 variant 2 version 1.02
[   51.796661] eth1: PRI 31 variant 2 version 9.48
[   51.796661] eth1: NIC 5 variant 2 version 1.02
[ 2932.806373] pccard: card ejected from slot 0
[ 3021.556364] pnp: Device 00:0a activated.
[ 3021.556364] smsc_ircc_present(), addr 0x02e8 - no device found!
[ 3021.556364] PnP probe failed
[ 3021.556364] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[ 3021.556364] Activated ALi 1533 ISA bridge port 0x02e8.
[ 3021.556364] Activated ALi 1533 ISA bridge port 0x02f8.
[ 3021.556364] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[ 3021.556364] smsc_superio_flat(): IrDA not enabled
[ 3021.556364] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
,=20
mode: 0x02
[ 3021.556364] SMsC IrDA Controller found
[ 3021.556364]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=
=3D7
[ 3021.559697] No transceiver found. Defaulting to Fast pin select
[ 3044.583028] pnp: Device 00:0a disabled.
[ 3543.909645] pnp: Device 00:0a activated.
[ 3543.909645] printk: 1 messages suppressed.
[ 3543.909645] smsc_ircc_present(), addr 0x0100 - no device found!
[ 3543.909645] PnP probe failed
[ 3543.912978] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[ 3543.912978] Activated ALi 1533 ISA bridge port 0x02e8.
[ 3543.912978] Activated ALi 1533 ISA bridge port 0x02f8.
[ 3543.912978] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[ 3543.912978] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
,=20
mode: 0x0a
[ 3543.912978] SMsC IrDA Controller found
[ 3543.912978]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=
=3D7
[ 3543.912978] No transceiver found. Defaulting to Fast pin select
[ 3543.922978] IrDA: Registered device irda0
[ 3605.166306] pnp: Device 00:0a disabled.
[ 3615.652971] pccard: PCMCIA card inserted into slot 0
[ 3615.652971] pcmcia: registering new device pcmcia0.0
[ 3615.949638] wlags49_h1_cs v7.18 for PCMCIA, 03/31/2004 14:31:00 by Agere=
=20
Systems, http://www.agere.com
[ 3615.949638] *** Modified for kernel 2.6 by Andrey Borzenkov=20
<arvidjaar@mail.ru> $Revision: 39 $
[ 3615.949638] *** Station Mode (STA) Support: YES
[ 3615.949638] *** Access Point Mode (AP) Support: YES
[ 3615.996305] eth1: PRI 31 variant 2 version 9.48
[ 3615.996305] eth1: NIC 5 variant 2 version 1.02
[ 3616.456305] eth1: Wireless, io_addr 0x100, irq 11, mac_address=20
00:02:2D:26:95:6C
[ 3617.152971] eth1: PRI 31 variant 2 version 9.48
[ 3617.152971] eth1: NIC 5 variant 2 version 1.02
[ 3617.539638] eth1: PRI 31 variant 2 version 9.48
[ 3617.539638] eth1: NIC 5 variant 2 version 1.02
[ 3617.906304] eth1: PRI 31 variant 2 version 9.48
[ 3617.906304] eth1: NIC 5 variant 2 version 1.02

available_resources_io:

0x00000100 - 0x000003af
0x000003e0 - 0x000004ff
0x00000820 - 0x000008ff
0x00000a00 - 0x00000aff
0x00000c00 - 0x00000cf7

available_resources_mem:

0x000cc000 - 0x000dffff
0x60000000 - 0x60ffffff
0xa0000000 - 0xa0ffffff




--nextPart1833067.fIVP9kEsHE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGbVaBR6LMutpd94wRAorLAJ9FYJBBQ15j09vhEPHIxPfSvgwVXACgkW/s
bDK01qu0kDK8xd4zJFqtgNs=
=rs5j
-----END PGP SIGNATURE-----

--nextPart1833067.fIVP9kEsHE--
