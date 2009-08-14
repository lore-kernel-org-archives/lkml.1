Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbZHNBlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbZHNBlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 21:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZHNBlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 21:41:05 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:61453 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447AbZHNBlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 21:41:04 -0400
From: Frans Pop <elendil@planet.nl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: PCI resources allocation problem on Toshiba Satellite A40
Date: Fri, 14 Aug 2009 03:40:58 +0200
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, mano@roarinelk.homelinux.net, rjw@sisk.pl,
       willy@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, akpm@linux-foundation.org,
       andrew.patterson@hp.com
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net> <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain> <20090805155102.GA31646@roarinelk.homelinux.net> <alpine.LFD.2.01.0908050902300.3390@localhost.localdomain> <alpine.LFD.2.01.0908050931390.3390@localhost.localdomain> <20090805170934.GA32274@roarinelk.homelinux.net> <alpine.LFD.2.01.0908071051300.3390@localhost.localdomain> <alpine.LFD.2.01.0908071116520.3390@localhost.localdomain> <20090811184740.49f52b57@scarran.roarinelk.net> <20090811184740.49f52b57@scarran.roarinelk.net> <alpine.LFD.2.01.0908131113580.28882@localhost.localdomain> <alpine.LFD.2.01.0908131113580.28882@localhost.localdomain> <200908132128.31439.elendil@planet.nl>
In-reply-To: <200908132128.31439.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_uCMhKpZhNYu2juG"
Message-Id: <200908140341.02210.elendil@planet.nl>
X-OriginalArrivalTime: 14 Aug 2009 01:41:02.0532 (UTC) FILETIME=[4825F840:01CA1C80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_uCMhKpZhNYu2juG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Frans Pop wrote:
> With pre-2.6.31 kernels I always had the following in dmesg:
> pci 0000:00:1d.0: BAR 4: can't allocate resource
> pci 0000:00:1d.1: BAR 4: can't allocate resource
> [...]
> pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.0 BAR 4 (0x0-0x1f), disabling
> pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.1 BAR 4 (0x0-0x1f), disabling
> 
> I was very happy to see that for 2.6.31-rc2 those messages were gone.

The commit that resulted in the messages disappearing was:
commit a76117dfd687ec4be0a9a05214f3009cc5f73a42
Author: Matthew Wilcox <willy@linux.intel.com>
Date:   Wed Jun 17 16:33:35 2009 -0400
    x86: Use pci_claim_resource

> But with .31-rc5 they are back again, with added "address space collision":
> pci 0000:00:1d.0: BAR 4: address space collision on of device [0xcfe0-0xcfff]
> pci 0000:00:1d.0: BAR 4: can't allocate resource 
> pci 0000:00:1d.1: BAR 4: address space collision on of device [0xcf80-0xcf9f]
> pci 0000:00:1d.1: BAR 4: can't allocate resource 
> [...]
> pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.0 BAR 4 (0x0-0x1f), disabling
> pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.1 BAR 4 (0x0-0x1f), disabling

The commit that caused the messages to return is:
commit 79896cf42f6a96d7e14f2dc3473443d68d74031d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Aug 2 14:04:19 2009 -0700
    Make pci_claim_resource() use request_resource() rather than insert_resource()

The affected devices are the two USB UHCI controllers.

Cheers,
FJP


--Boundary-00=_uCMhKpZhNYu2juG
Content-Type: text/plain;
  charset="us-ascii";
  name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="lspci"

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

00:02.0 VGA compatible controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02) (prog-if 00 [VGA controller])
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

00:02.1 Display controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
	Subsystem: Toshiba America Info Systems Device 0002
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at 20000000 (32-bit, prefetchable) [disabled] [size=128M]
	Region 1: Memory at 2c000000 (32-bit, non-prefetchable) [disabled] [size=512K]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 18c0 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 18e0 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 03) (prog-if 20 [EHCI])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at 2c080000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=0080
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR+ INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=03, sec-latency=64
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: cff00000-cfffffff
	Prefetchable memory behind bridge: 28000000-2bffffff
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
	Region 5: Memory at 2c080400 (32-bit, non-prefetchable) [size=1K]
	Kernel driver in use: PIIX_IDE
	Kernel modules: piix, ata_piix

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
	Subsystem: Toshiba America Info Systems Device 0241
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 255
	Region 0: I/O ports at 1000 [disabled] [size=256]
	Region 1: I/O ports at 1880 [disabled] [size=64]
	Region 2: Memory at 2c080800 (32-bit, non-prefetchable) [disabled] [size=512]
	Region 3: Memory at 2c080a00 (32-bit, non-prefetchable) [disabled] [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 03) (prog-if 00 [Generic])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at 1400 [size=256]
	Region 1: I/O ports at 1800 [size=128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

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
	Memory window 0: 28000000-2bfff000 (prefetchable)
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
	Kernel driver in use: ath5k
	Kernel modules: ath5k


--Boundary-00=_uCMhKpZhNYu2juG--
