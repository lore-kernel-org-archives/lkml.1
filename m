Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYIIQ0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYIIQ0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYIIQ0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:26:25 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:16318 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbYIIQ0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:26:24 -0400
From: Frans Pop <elendil@planet.nl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap" messages
Date: Tue, 9 Sep 2008 18:26:17 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200809091250.08620.elendil@planet.nl> <200809090930.27583.bjorn.helgaas@hp.com>
In-Reply-To: <200809090930.27583.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_qOqxIhID8kZ0wGO"
Message-Id: <200809091826.18876.elendil@planet.nl>
X-OriginalArrivalTime: 09 Sep 2008 16:26:21.0051 (UTC) FILETIME=[CB377CB0:01C91298]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_qOqxIhID8kZ0wGO
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks for your quick replies Bjorn and Rene!

On Tuesday 09 September 2008, Bjorn Helgaas wrote:
> On Tuesday 09 September 2008 04:50:06 am Frans Pop wrote:
> > The only thing I used to get for pnp 00:08 on my Toshiba Satellite
> > A40 up to 2.6.26 was this single line:
> > pnp 00:08: can't add resource for IO 0xa8-0xa9
[...]
> > Was it expected that that change could lead to a message
> > disappearing? I don't really read that from the commit description.
>
> Yep.  This commit removed the fixed limit (40), so we shouldn't see
> messages like that any more.  The commit log mentioned these:

Right, that explains. Thanks.
The old message text led me to think that only that particular resource 
was problematic, while actually it was the listed one and all following. 
The message you did quote was clearer in that respect.

> What do "lspci -vv" and /proc/ioports and /proc/iomem show for you?

Thanks for the background info and data for comparison.
Here's what I have (full info attached). AFAICT it looks equally sane and 
consistent.

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller [8086:24c5] (rev 03)
        Region 0: I/O ports at 1000 [size=256]
        Region 1: I/O ports at 1880 [size=64]
        Region 2: Memory at 28080800 (32-bit, non-prefetchable) [size=512]
        Region 3: Memory at 28080a00 (32-bit, non-prefetchable) [size=256]

00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
AC'97 Modem Controller [8086:24c6] (rev 03)
        Region 0: I/O ports at 1400 [size=256]
        Region 1: I/O ports at 1800 [size=128]

/proc/ioports:
1000-10ff : 0000:00:1f.5
  1000-10ff : Intel 82801DB-ICH4
1400-14ff : 0000:00:1f.6
  1400-14ff : Intel 82801DB-ICH4 Modem
1800-187f : 0000:00:1f.6
  1800-187f : Intel 82801DB-ICH4 Modem
1880-18bf : 0000:00:1f.5
  1880-18bf : Intel 82801DB-ICH4

/proc/iomem:
28080800-280809ff : 0000:00:1f.5
  28080800-280809ff : Intel 82801DB-ICH4
28080a00-28080aff : 0000:00:1f.5
  28080a00-28080aff : Intel 82801DB-ICH4

Cheers,
FJP


--Boundary-00=_qOqxIhID8kZ0wGO
Content-Type: text/plain;
  charset="iso-8859-15";
  name="device.info"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="device.info"

00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at <unassigned> (32-bit, prefetchable)
	Capabilities: [40] Vendor Specific Information <?>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:02.0 VGA compatible controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
	Subsystem: Toshiba America Info Systems Device 0002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=512K]
	Region 2: I/O ports at eff8 [size=8]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: intelfb

00:02.1 Display controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
	Subsystem: Toshiba America Info Systems Device 0002
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at 20000000 (32-bit, prefetchable) [disabled] [size=128M]
	Region 1: Memory at 28000000 (32-bit, non-prefetchable) [disabled] [size=512K]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 18c0 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 18e0 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 03) (prog-if 20)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at 28080000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=0080
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR+ INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=03, sec-latency=64
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: cff00000-cfffffff
	Prefetchable memory behind bridge: 2c000000-2fffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Kernel modules: shpchp

00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Kernel modules: iTCO_wdt, intel-rng

00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at bfa0 [size=16]
	Region 5: Memory at 28080400 (32-bit, non-prefetchable) [size=1K]
	Kernel driver in use: PIIX_IDE
	Kernel modules: piix, ata_piix

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
	Subsystem: Toshiba America Info Systems Device 0241
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at 1000 [size=256]
	Region 1: I/O ports at 1880 [size=64]
	Region 2: Memory at 28080800 (32-bit, non-prefetchable) [size=512]
	Region 3: Memory at 28080a00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: Intel ICH
	Kernel modules: snd-intel8x0

00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 03)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at 1400 [size=256]
	Region 1: I/O ports at 1800 [size=128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: Intel ICH Modem
	Kernel modules: snd-intel8x0m

01:08.0 Ethernet controller: Intel Corporation 82801DB PRO/100 VE (MOB) Ethernet Controller (rev 83)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at cffff000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at cf40 [size=64]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: e100

01:0b.0 CardBus bridge: Toshiba America Info Systems ToPIC100 PCI to Cardbus Bridge with ZV Support (rev 33)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at cff00000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=01, secondary=02, subordinate=02, sec-latency=0
	Memory window 0: 2c000000-2ffff000 (prefetchable)
	Memory window 1: 30000000-33fff000
	I/O window 0: 0000c000-0000c0ff
	I/O window 1: 0000c400-0000c4ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

02:00.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213 Multiprotocol MAC/baseband processor (rev 01)
	Subsystem: Global Sun Technology Inc Device 7103
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at 30000000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: ath5k_pci
	Kernel modules: ath5k


0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : piix
01e0-01ef : pnp 00:08
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : piix
0376-0376 : 0000:00:1f.1
  0376-0376 : piix
0378-037a : parport0
03c0-03df : vesafb
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : piix
0480-048f : pnp 00:08
04d0-04d1 : pnp 00:08
0680-06ff : pnp 00:08
0778-077a : parport0
0800-080f : pnp 00:08
0cf8-0cff : PCI conf1
1000-10ff : 0000:00:1f.5
  1000-10ff : Intel 82801DB-ICH4
1400-14ff : 0000:00:1f.6
  1400-14ff : Intel 82801DB-ICH4 Modem
1800-187f : 0000:00:1f.6
  1800-187f : Intel 82801DB-ICH4 Modem
1880-18bf : 0000:00:1f.5
  1880-18bf : Intel 82801DB-ICH4
18c0-18df : 0000:00:1d.0
  18c0-18df : uhci_hcd
18e0-18ff : 0000:00:1d.1
  18e0-18ff : uhci_hcd
bfa0-bfaf : 0000:00:1f.1
  bfa0-bfaf : piix
c000-cfff : PCI Bus 0000:01
  c000-c0ff : PCI CardBus 0000:02
  c400-c4ff : PCI CardBus 0000:02
  cf40-cf7f : 0000:01:08.0
    cf40-cf7f : e100
d800-d87f : 0000:00:1f.0
  d800-d87f : pnp 00:08
    d800-d803 : ACPI PM1a_EVT_BLK
    d804-d805 : ACPI PM1a_CNT_BLK
    d808-d80b : ACPI PM_TMR
    d810-d815 : ACPI CPU throttle
    d820-d820 : ACPI PM2_CNT_BLK
    d828-d82f : ACPI GPE0_BLK
    d860-d87f : iTCO_wdt
d880-d89f : pnp 00:08
d8a0-d8bf : pnp 00:08
e000-e07f : pnp 00:08
e080-e0ff : pnp 00:08
e400-e47f : pnp 00:08
e480-e4ff : pnp 00:08
e800-e87f : pnp 00:08
e880-e8ff : pnp 00:08
ec00-ec7f : pnp 00:08
ec80-ecff : pnp 00:08
eeac-eeac : pnp 00:08
eeb0-eebf : pnp 00:08
eec0-eeff : 0000:00:1f.0
  eec0-eeff : pnp 00:08
eff8-efff : 0000:00:02.0

00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cffff : Video ROM
000e0000-000eedff : reserved
000eee00-000eefff : ACPI Non-volatile Storage
000ef000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-1ef3ffff : System RAM
  00100000-002b93a8 : Kernel code
  002b93a9-003a8207 : Kernel data
  003eb000-0043e1fb : Kernel bss
1ef40000-1ef4ffff : ACPI Tables
1ef50000-1effffff : reserved
20000000-27ffffff : 0000:00:02.1
28000000-2807ffff : 0000:00:02.1
28080000-280803ff : 0000:00:1d.7
  28080000-280803ff : ehci_hcd
28080400-280807ff : 0000:00:1f.1
28080800-280809ff : 0000:00:1f.5
  28080800-280809ff : Intel 82801DB-ICH4
28080a00-28080aff : 0000:00:1f.5
  28080a00-28080aff : Intel 82801DB-ICH4
2c000000-2fffffff : PCI Bus 0000:01
  2c000000-2fffffff : PCI CardBus 0000:02
30000000-33ffffff : PCI CardBus 0000:02
  30000000-3000ffff : 0000:02:00.0
    30000000-3000ffff : ath5k
cff00000-cfffffff : PCI Bus 0000:01
  cff00000-cff00fff : 0000:01:0b.0
    cff00000-cff00fff : yenta_socket
  cffff000-cfffffff : 0000:01:08.0
    cffff000-cfffffff : e100
d0000000-d007ffff : 0000:00:02.0
d8000000-dfffffff : 0000:00:02.0
  d8000000-d8fcffff : vesafb
fec00000-fec00fff : reserved
fec10000-fec1ffff : reserved
feda0000-fedbffff : reserved
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ffb00000-ffbfffff : reserved
ffe80000-ffffffff : reserved

--Boundary-00=_qOqxIhID8kZ0wGO--
