Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbYJSXLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbYJSXLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 19:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYJSXLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 19:11:22 -0400
Received: from mail.anarazel.de ([217.115.131.40]:35200 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbYJSXLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 19:11:14 -0400
From: Andres Freund <andres@anarazel.de>
To: Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
Date: Mon, 20 Oct 2008 01:11:05 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-andres-04904-gc813b4e; KDE/4.1.2; x86_64; ; )
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_K67+I2J/SHnsUnF"
Message-Id: <200810200111.06461.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_K67+I2J/SHnsUnF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Dave,

On Thursday 16 October 2008 08:59:57 Dave Airlie wrote:
> Please pull the 'agp-next' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git
> agp-next
>
> This just contains some suspend/resume fixes for the SiS, Intel memory
> sizing fix for new hw, and support for more memory types on the nvidia
> AGP.
One of those patches breaks X on my laptop with:

(II) intel(0): xf86BindGARTMemory: bind key 0 at 0x01f7f000 (pgoffset 8063)
(WW) intel(0): xf86BindGARTMemory: binding of gart memory with key 0
    at offset 0x1f7f000 failed (Invalid argument)

Fatal server error:
Couldn't bind memory for exa offscreen

(Found via bisect with some guessing)

If neccessary I can bisect further, but I guess you know what the problem is.

Andres


Xorg is: 1.5.2-2
Xorg Intel: 2.4.1-1ubuntu9




--Boundary-00=_K67+I2J/SHnsUnF
Content-Type: text/plain;
  charset="iso-8859-1";
  name="lspci-vv"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci-vv"

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
	Subsystem: Lenovo Device 20e0
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
	Subsystem: Lenovo Device 2114
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f4400000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 1800 [size=8]
	Capabilities: <access denied>

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
	Subsystem: Lenovo Device 2114
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at f4200000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: <access denied>

00:03.0 Communication controller: Intel Corporation Mobile 4 Series Chipset MEI Controller (rev 07)
	Subsystem: Lenovo Device 20e6
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fc226800 (64-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>

00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
	Subsystem: Lenovo Device 20ee
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 2298
	Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at fc025000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 1840 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: e1000e
	Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 1860 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 1880 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 22
	Region 4: I/O ports at 18a0 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20)
	Subsystem: Lenovo Device 20f1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at fc226c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
	Subsystem: Lenovo Device 20f2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fc020000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Memory behind bridge: f4300000-f43fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f8000000-f9ffffff
	Prefetchable memory behind bridge: 00000000f4000000-00000000f40fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0d, subordinate=14, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: fa000000-fbffffff
	Prefetchable memory behind bridge: 00000000f4100000-00000000f41fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 18c0 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 18e0 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 1c00 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20)
	Subsystem: Lenovo Device 20f1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fc227000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=15, subordinate=18, sec-latency=32
	I/O behind bridge: 00004000-00007fff
	Memory behind bridge: f4800000-f7ffffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f3ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
	Subsystem: Lenovo Device 20f5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03) (prog-if 01)
	Subsystem: Lenovo Device 20f8
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 2299
	Region 0: I/O ports at 1c48 [size=8]
	Region 1: I/O ports at 183c [size=4]
	Region 2: I/O ports at 1c40 [size=8]
	Region 3: I/O ports at 1838 [size=4]
	Region 4: I/O ports at 1c20 [size=32]
	Region 5: Memory at fc226000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
	Subsystem: Lenovo Device 20f9
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fc227400 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 1c60 [size=32]
	Kernel modules: i2c-i801

03:00.0 Network controller: Intel Corporation Wireless WiFi Link 5100
	Subsystem: Intel Corporation Device 1011
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at f4300000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
	Subsystem: Lenovo Device 20c6
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f4800000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=15, secondary=16, subordinate=17, sec-latency=176
	Memory window 0: f0000000-f3fff000 (prefetchable)
	Memory window 1: c4000000-c7fff000
	I/O window 0: 00004000-000040ff
	I/O window 1: 00004400-000044ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

15:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04) (prog-if 10)
	Subsystem: Lenovo Device 20c7
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at f4801000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci

15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
	Subsystem: Lenovo Device 20c8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f4801800 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci

15:00.3 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev ff) (prog-if ff)
	!!! Unknown header type 7f
	Kernel driver in use: ricoh-mmc
	Kernel modules: ricoh_mmc

15:00.4 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 11)
	Subsystem: Lenovo Device 20ca
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f4802000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>

15:00.5 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 11)
	Subsystem: Lenovo Device 20cb
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f4802400 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>


--Boundary-00=_K67+I2J/SHnsUnF
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="Xorg.0.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Xorg.0.log"


X.Org X Server 1.5.2
Release Date: 10 October 2008
X Protocol Version 11, Revision 0
Build Operating System: Linux 2.6.24-15-server x86_64 Ubuntu
Current Operating System: Linux alap2 2.6.27-andres-04909-ga45fbc3 #28 SMP =
Mon Oct 20 00:27:52 CEST 2008 x86_64
Build Date: 18 October 2008  10:30:27AM
xorg-server 2:1.5.2-2build1 (buildd@crested.buildd)=20
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Module Loader present
Markers: (--) probed, (**) from config file, (=3D=3D) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(=3D=3D) Log file: "/var/log/Xorg.0.log", Time: Mon Oct 20 00:33:27 2008
(=3D=3D) Using config file: "/etc/X11/xorg.conf"
(=3D=3D) ServerLayout "Default Layout"
(**) |-->Screen "Default Screen" (0)
(**) |   |-->Monitor "Configured Monitor"
(**) |   |-->Device "Configured Video Device"
(**) |-->Input Device "Generic Mouse"
(**) |-->Input Device "Generic Keyboard"
(=3D=3D) Automatically adding devices
(=3D=3D) Automatically enabling devices
(=3D=3D) No FontPath specified.  Using compiled-in default.
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(=3D=3D) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType
(=3D=3D) ModulePath set to "/usr/lib/xorg/modules"
(II) Cannot locate a core pointer device.
(II) Cannot locate a core keyboard device.
(II) The server relies on HAL to provide the list of input devices.
	If no devices become available, reconfigure HAL or disable AllowEmptyInput.
(II) Open ACPI successful (/var/run/acpid.socket)
(II) Loader magic: 0x7b7320
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.4
	X.Org Video Driver: 4.1
	X.Org XInput driver : 2.1
	X.Org Server Extension : 1.1
	X.Org Font Renderer : 0.6
(II) Loader running on linux
(++) using VT number 7

(--) PCI:*(0@0:2:0) Intel Corporation Mobile 4 Series Chipset Integrated Gr=
aphics Controller rev 7, Mem @ 0xf4400000/4194304, 0xd0000000/268435456, I/=
O @ 0x00001800/8
(--) PCI: (0@0:2:1) Intel Corporation Mobile 4 Series Chipset Integrated Gr=
aphics Controller rev 7, Mem @ 0xf4200000/1048576
(II) System resource ranges:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) LoadModule: "extmod"

(II) Loading /usr/lib/xorg/modules/extensions//libextmod.so
(II) Module extmod: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 1.1
(II) Loading extension SHAPE
(II) Loading extension MIT-SUNDRY-NONSTANDARD
(II) Loading extension BIG-REQUESTS
(II) Loading extension SYNC
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XC-MISC
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-Misc
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension TOG-CUP
(II) Loading extension Extended-Visual-Information
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "dbe"

(II) Loading /usr/lib/xorg/modules/extensions//libdbe.so
(II) Module dbe: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 1.1
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "glx"

(II) Loading /usr/lib/xorg/modules/extensions//libglx.so
(II) Module glx: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.0.0
	ABI class: X.Org Server Extension, version 1.1
(=3D=3D) AIGLX enabled
(=3D=3D) Exporting typical set of GLX visuals
(II) Loading extension GLX
(II) LoadModule: "freetype"

(II) Loading /usr/lib/xorg/modules//fonts/libfreetype.so
(II) Module freetype: vendor=3D"X.Org Foundation & the After X-TT Project"
	compiled for 1.5.2, module version =3D 2.1.0
	Module class: X.Org Font Renderer
	ABI class: X.Org Font Renderer, version 0.6
(II) Loading font FreeType
(II) LoadModule: "record"

(II) Loading /usr/lib/xorg/modules/extensions//librecord.so
(II) Module record: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 1.1
(II) Loading extension RECORD
(II) LoadModule: "dri"

(II) Loading /usr/lib/xorg/modules/extensions//libdri.so
(II) Module dri: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.0.0
	ABI class: X.Org Server Extension, version 1.1
(II) Loading extension XFree86-DRI
(II) Scanning /usr/share/xserver-xorg/pci directory for additional PCI ID's=
 supported by the drivers
(II) Matched intel from file name intel.ids
(=3D=3D) Matched intel for the autoconfigured driver
(=3D=3D) Assigned the driver to the xf86ConfigLayout
(II) LoadModule: "intel"

(II) Loading /usr/lib/xorg/modules/drivers//intel_drv.so
(II) Module intel: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 2.4.1
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 4.1
(II) LoadModule: "synaptics"

(II) Loading /usr/lib/xorg/modules/input//synaptics_drv.so
(II) Module synaptics: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 0.15.2
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 2.1
(II) LoadModule: "kbd"

(II) Loading /usr/lib/xorg/modules/input//kbd_drv.so
(II) Module kbd: vendor=3D"X.Org Foundation"
	compiled for 1.4.99.905, module version =3D 1.3.1
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 2.1
(II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, 965G, G35, 965Q, 946GZ,
	965GM, 965GME/GLE, G33, Q35, Q33,
	Mobile Intel=C2=AE GM45 Express Chipset,
	Intel Integrated Graphics Device, G45/G43, Q45/Q43
(II) Primary Device is: PCI 00@00:02:0
(II) resource ranges after xf86ClaimFixedResources() call:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) resource ranges after probing:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B]
	[5] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B]
	[6] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B]
	[7] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[8] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[9] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B]
	[10] 0	0	0x000003c0 - 0x000003df (0x20) IS[B]
(II) Loading sub module "int10"
(II) LoadModule: "int10"

(II) Loading /usr/lib/xorg/modules//libint10.so
(II) Module int10: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.0.0
	ABI class: X.Org Video Driver, version 4.1
(II) Loading sub module "vbe"
(II) LoadModule: "vbe"

(II) Loading /usr/lib/xorg/modules//libvbe.so
(II) Module vbe: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.1.0
	ABI class: X.Org Video Driver, version 4.1
(II) Loading sub module "vgahw"
(II) LoadModule: "vgahw"

(II) Loading /usr/lib/xorg/modules//libvgahw.so
(II) Module vgahw: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 0.1.0
	ABI class: X.Org Video Driver, version 4.1
(II) intel(0): Creating default Display subsection in Screen section
	"Default Screen" for depth/fbbpp 24/32
(=3D=3D) intel(0): Depth 24, (=3D=3D) framebuffer bpp 32
(=3D=3D) intel(0): RGB weight 888
(=3D=3D) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) Mobile Intel=C2=AE GM4=
5 Express Chipset
(--) intel(0): Chipset: "Mobile Intel=C2=AE GM45 Express Chipset"
(--) intel(0): Linear framebuffer at 0xD0000000
(--) intel(0): IO registers at addr 0xF4400000
(II) intel(0): 2 display pipes available.
(=3D=3D) intel(0): Using EXA for acceleration
(II) Loading sub module "int10"
(II) LoadModule: "int10"

(II) Reloading /usr/lib/xorg/modules//libint10.so
(II) intel(0): initializing int10
(WW) intel(0): Bad V_BIOS checksum
(II) intel(0): Primary V_BIOS segment is: 0xc000
(II) intel(0): VESA BIOS detected
(II) intel(0): VESA VBE Version 3.0
(II) intel(0): VESA VBE Total Mem: 32704 kB
(II) intel(0): VESA VBE OEM: Intel(r)Cantiga Graphics Chip Accelerated VGA =
BIOS
(II) intel(0): VESA VBE OEM Software Rev: 1.0
(II) intel(0): VESA VBE OEM Vendor: Intel Corporation
(II) intel(0): VESA VBE OEM Product: Intel(r)Cantiga Graphics Controller
(II) intel(0): VESA VBE OEM Product Rev: Hardware Version 0.0
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"
(II) Module "ddc" already built-in
(II) Loading sub module "i2c"
(II) LoadModule: "i2c"
(II) Module "i2c" already built-in
(II) intel(0): Output VGA using monitor section Configured Monitor
(II) intel(0): I2C bus "CRTDDC_A" initialized.
(II) intel(0): Output LVDS has no monitor section
(II) intel(0): I2C bus "LVDSDDC_C" initialized.
(II) intel(0): Attempting to determine panel fixed mode.
(II) intel(0): I2C device "LVDSDDC_C:ddc2" registered at address 0xA0.
(II) intel(0): EDID vendor "LEN", prod id 16467
(II) intel(0): found backlight control method /sys/class/backlight/acpi_vid=
eo1
(II) intel(0): I2C device "CRTDDC_A:ddc2" registered at address 0xA0.
(II) intel(0): EDID vendor "SAM", prod id 952
(II) intel(0): Using EDID range info for horizontal sync
(II) intel(0): Using EDID range info for vertical refresh
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 =
1053 1059 1080 +hsync -vsync (64.7 kHz)
(II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 60=
5 628 +hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 60=
3 625 +hsync +vsync (35.2 kHz)
(II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484=
 500 -hsync -vsync (37.5 kHz)
(II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 491=
 520 -hsync -vsync (37.9 kHz)
(II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486=
 525 -hsync -vsync (35.0 kHz)
(II) intel(0): Modeline "640x480"x0.0   25.20  640 656 752 800  480 490 492=
 525 -hsync -vsync (31.5 kHz)
(II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414=
 449 -hsync +vsync (31.5 kHz)
(II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 =
1025 1028 1066 +hsync +vsync (80.0 kHz)
(II) intel(0): Modeline "1024x768"x0.0   78.80  1024 1040 1136 1312  768 76=
9 772 800 +hsync +vsync (60.1 kHz)
(II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 77=
1 777 806 -hsync -vsync (56.5 kHz)
(II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 77=
1 777 806 -hsync -vsync (48.4 kHz)
(II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 62=
8 667 -hsync -vsync (49.7 kHz)
(II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 60=
4 625 +hsync +vsync (46.9 kHz)
(II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 64=
3 666 +hsync +vsync (48.1 kHz)
(II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 86=
5 868 900 +hsync +vsync (67.5 kHz)
(II) intel(0): Modeline "1680x1050"x60.0  147.14  1680 1784 1968 2256  1050=
 1051 1054 1087 -hsync +vsync (65.2 kHz)
(II) intel(0): Modeline "1280x1024"x60.0  108.88  1280 1360 1496 1712  1024=
 1025 1028 1060 -hsync +vsync (63.6 kHz)
(II) intel(0): Modeline "1280x960"x60.0  102.10  1280 1360 1496 1712  960 9=
61 964 994 -hsync +vsync (59.6 kHz)
(II) intel(0): Modeline "1152x864"x75.0  104.99  1152 1224 1352 1552  864 8=
65 868 902 -hsync +vsync (67.7 kHz)
(II) intel(0): EDID vendor "SAM", prod id 952
(II) intel(0): EDID vendor "LEN", prod id 16467
(II) intel(0): Output VGA connected
(II) intel(0): Output LVDS connected
(II) intel(0): Using exact sizes for initial modes
(II) intel(0): Output VGA using initial mode 1680x1050
(II) intel(0): Output LVDS using initial mode 1680x1050
(II) intel(0): Monitoring connected displays enabled
(II) intel(0): detected 512 kB GTT.
(II) intel(0): detected 32252 kB stolen memory.
(=3D=3D) intel(0): video overlay key set to 0x101fe
(=3D=3D) intel(0): Will not try to enable page flipping
(=3D=3D) intel(0): Triple buffering disabled
(=3D=3D) intel(0): Intel XvMC decoder disabled
(=3D=3D) intel(0): Using gamma correction (1.0, 1.0, 1.0)
(**) intel(0): Display dimensions: (470, 300) mm
(**) intel(0): DPI set to (90, 142)
(II) Loading sub module "fb"
(II) LoadModule: "fb"

(II) Loading /usr/lib/xorg/modules//libfb.so
(II) Module fb: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(II) Loading sub module "exa"
(II) LoadModule: "exa"

(II) Loading /usr/lib/xorg/modules//libexa.so
(II) Module exa: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 2.4.0
	ABI class: X.Org Video Driver, version 4.1
(II) Loading sub module "ramdac"
(II) LoadModule: "ramdac"
(II) Module "ramdac" already built-in
(II) intel(0): Comparing regs from server start up to After PreInit
(WW) intel(0): Register 0x321b (FBC_FENCE_OFF) changed from 0x71034000 to 0=
x56020e00
(=3D=3D) Depth 24 pixmap format is 32 bpp
(II) do I need RAC?  No, I don't.
(II) resource ranges after preInit:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B](OprD)
	[5] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B](OprD)
	[6] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B](OprD)
	[7] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[8] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[9] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B](OprU)
	[10] 0	0	0x000003c0 - 0x000003df (0x20) IS[B](OprU)
(II) intel(0): Kernel reported 1248000 total, 1 used
(II) intel(0): I830CheckAvailableMemory: 4991996 kB available
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 11, (OK)
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 11, (OK)
drmOpenByBusid: Searching for BusID pci:0000:00:02.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 11, (OK)
drmOpenByBusid: drmOpenMinor returns 11
drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
(II) [drm] DRM interface version 1.3
(II) [drm] DRM open master succeeded.
(II) intel(0): [drm] Using the DRM lock SAREA also for drawables.
(II) intel(0): [drm] framebuffer mapped by ddx driver
(II) intel(0): [drm] added 1 reserved context for kernel
(II) intel(0): X context handle =3D 0x1
(II) intel(0): [drm] installed DRM signal handler
(**) intel(0): Framebuffer compression enabled
(**) intel(0): Tiling enabled
(=3D=3D) intel(0): VideoRam: 262144 KB
(II) intel(0): Attempting memory allocation with tiled buffers.
(II) intel(0): Tiled allocation successful.
(II) intel(0): [drm] Registers =3D 0xf4400000
(II) intel(0): [drm] ring buffer =3D 0xd0000000
(II) intel(0): [drm] mapped front buffer at 0xd0100000, handle =3D 0xd01000=
00
(II) intel(0): [drm] mapped back buffer at 0xd2ef1000, handle =3D 0xd2ef1000
(II) intel(0): [drm] mapped depth buffer at 0xd3a6d000, handle =3D 0xd3a6d0=
00
(II) intel(0): [drm] mapped classic textures at 0xd45e9000, handle =3D 0xd4=
5e9000
(II) intel(0): [drm] Initialized kernel agp heap manager, 33554432
(II) intel(0): [dri] visual configs initialized
(II) intel(0): Page Flipping disabled
(II) intel(0): vgaHWGetIOBase: hwp->IOBase is 0x03d0, hwp->PIOOffset is 0x0=
000
(II) EXA(0): Offscreen pixmap area of 36126720 bytes
(II) EXA(0): Driver registered support for the following operations:
(II)         Solid
(II)         Copy
(II)         Composite (RENDER acceleration)
(=3D=3D) intel(0): Backing store disabled
(=3D=3D) intel(0): Silken mouse enabled
(II) intel(0): Initializing HW Cursor
(II) intel(0): [DRI] installation complete
(II) intel(0): xf86BindGARTMemory: bind key 0 at 0x01f7f000 (pgoffset 8063)
(WW) intel(0): xf86BindGARTMemory: binding of gart memory with key 0
	at offset 0x1f7f000 failed (Invalid argument)

=46atal server error:
Couldn't bind memory for exa offscreen


Backtrace:
0: /usr/X11R6/bin/X(xf86SigHandler+0x65) [0x480f35]
1: /lib/libc.so.6 [0x7fcd73c5e060]
2: /usr/lib/xorg/modules/drivers//intel_drv.so(gen4_render_state_cleanup+0x=
e) [0x7fcd726a092e]
3: /usr/lib/xorg/modules/drivers//intel_drv.so [0x7fcd7267c668]
4: /usr/X11R6/bin/X(AbortDDX+0x8d) [0x4681ed]
5: /usr/X11R6/bin/X(AbortServer+0x18) [0x4f8248]
6: /usr/X11R6/bin/X(FatalError+0xd5) [0x4f8915]
7: /usr/lib/xorg/modules/drivers//intel_drv.so [0x7fcd72684ea5]
8: /usr/lib/xorg/modules/drivers//intel_drv.so [0x7fcd7267ce97]
9: /usr/lib/xorg/modules/drivers//intel_drv.so [0x7fcd7267e75d]
10: /usr/X11R6/bin/X(AddScreen+0x1c9) [0x432d89]
11: /usr/X11R6/bin/X(InitOutput+0x241) [0x469a61]
12: /usr/X11R6/bin/X(main+0x286) [0x433526]
13: /lib/libc.so.6(__libc_start_main+0xe6) [0x7fcd73c49466]
14: /usr/X11R6/bin/X [0x432ad9]
Saw signal 11.  Server aborting.

--Boundary-00=_K67+I2J/SHnsUnF
Content-Type: text/plain;
  charset="iso-8859-1";
  name="bisect-config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="bisect-config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.27
# Mon Oct 20 00:17:14 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
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
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
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
CONFIG_LOCALVERSION="-andres"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_IBS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
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
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=32
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_MEMTEST=y
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
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
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
CONFIG_MMU_NOTIFIER=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_BAY=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_WMI=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_PCI_SLOT=m
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
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
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_PIMSM_V2 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
# CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
# CONFIG_IP_NF_MANGLE is not set
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
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
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_NL80211=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=m
CONFIG_IEEE80211_CRYPT_CCMP=m
CONFIG_IEEE80211_CRYPT_TKIP=m
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
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
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
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
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_XEN_BLKDEV_FRONTEND is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_INTEL_MENLOW=m
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_SGI_XP is not set
# CONFIG_HP_ILO is not set
# CONFIG_SGI_GRU is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
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
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
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
CONFIG_ATA_GENERIC=y
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
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
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
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=m
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IP1000=m
CONFIG_IGB=m
# CONFIG_IGB_LRO is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=m
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
CONFIG_IWLAGN_LEDS=y
CONFIG_IWL4965=y
CONFIG_IWL5000=y
CONFIG_IWL3945=m
CONFIG_IWL3945_RFKILL=y
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_LEDS=y
# CONFIG_IWL3945_DEBUG is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=m
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_HSO=m
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_XEN_NETDEV_FRONTEND is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOL2TP=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VIRTIO_NET is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_HVC_XEN is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_AT24=m
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
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
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
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
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set

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
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
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
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
# CONFIG_DVB_USB_A800 is not set
# CONFIG_DVB_USB_DIBUSB_MB is not set
# CONFIG_DVB_USB_DIBUSB_MC is not set
# CONFIG_DVB_USB_DIB0700 is not set
# CONFIG_DVB_USB_UMT_010 is not set
# CONFIG_DVB_USB_CXUSB is not set
# CONFIG_DVB_USB_M920X is not set
# CONFIG_DVB_USB_GL861 is not set
# CONFIG_DVB_USB_AU6610 is not set
# CONFIG_DVB_USB_DIGITV is not set
# CONFIG_DVB_USB_VP7045 is not set
# CONFIG_DVB_USB_VP702X is not set
# CONFIG_DVB_USB_GP8PSK is not set
CONFIG_DVB_USB_NOVA_T_USB2=m
# CONFIG_DVB_USB_TTUSB2 is not set
# CONFIG_DVB_USB_DTT200U is not set
# CONFIG_DVB_USB_OPERA1 is not set
# CONFIG_DVB_USB_AF9005 is not set
# CONFIG_DVB_USB_DW2102 is not set
# CONFIG_DVB_USB_CINERGY_T2 is not set
# CONFIG_DVB_USB_ANYSEE is not set
# CONFIG_DVB_USB_DTV5100 is not set
# CONFIG_DVB_USB_AF9015 is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_SIANO_SMS1XXX is not set

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
# Supported SDMC DM1105 Adapters
#
# CONFIG_DVB_DM1105 is not set

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
# CONFIG_DVB_STV0288 is not set
# CONFIG_DVB_STB6000 is not set
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_TDA10086 is not set
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TUA6100 is not set
# CONFIG_DVB_CX24116 is not set
# CONFIG_DVB_SI21XX is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_DRX397XD is not set
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
# CONFIG_DVB_ZL10353 is not set
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
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
# CONFIG_DVB_AU8522 is not set
# CONFIG_DVB_S5H1411 is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_ISL6405 is not set
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DVB_LGS8GL5 is not set

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set
# CONFIG_DVB_AF9013 is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
CONFIG_DRM_I915=m
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=y
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_INTEL=y
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=m
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_MBP_NVIDIA=m

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
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
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
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
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# Special HID drivers
#
# CONFIG_HID_COMPAT is not set
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_BRIGHT=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DELL=m
CONFIG_HID_EZKEY=m
CONFIG_HID_GYRATION=m
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SUNPLUS=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y

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
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_GADGET_MUSB_HDRC is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m

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
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

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
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
CONFIG_USB_GADGET_NET2280=y
CONFIG_USB_NET2280=m
# CONFIG_USB_GADGET_PXA25X is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_PXA27X is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_S3C2410 is not set
# CONFIG_USB_GADGET_AT91 is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=m
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_GADGETFS=m
CONFIG_USB_FILE_STORAGE=m
# CONFIG_USB_FILE_STORAGE_TEST is not set
CONFIG_USB_G_SERIAL=m
CONFIG_USB_MIDI_GADGET=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=m
# CONFIG_UIO is not set
# CONFIG_XEN_BALLOON is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_EFI_VARS is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_GENERIC_ACL=y

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
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_REGISTER_V4 is not set
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
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
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
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
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_TRACING=y
CONFIG_FTRACE=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
# CONFIG_KVM_TRACE is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-00=_K67+I2J/SHnsUnF
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

[    0.000000] BIOS EBDA/lowmem at: 0009ec00/0009ec00
[    0.000000] Linux version 2.6.27-andres-04904-gc813b4e (andres@alap2) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu10) ) #29 SMP Mon Oct 20 00:47:28 CEST 2008
[    0.000000] Command line: root=/dev/mapper/root_crypt rootfstype=ext4dev ro  
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd5b7000 - 00000000bd60f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbda00 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00bda00000 page 2M
[    0.000000] kernel direct mapping tables up to bda00000 @ 8000-c000
[    0.000000] last_map_addr: bda00000 end: bda00000
[    0.000000] init_memory_mapping
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ a000-10000
[    0.000000] last_map_addr: 13c000000 end: 13c000000
[    0.000000] RAMDISK: 36aac000 - 37fef111
[    0.000000] ACPI: RSDP 000F6550, 0024 (r2 LENOVO)
[    0.000000] ACPI: XSDT BD96A4DE, 009C (r1 LENOVO TP-6F        1130  LTP        0)
[    0.000000] ACPI: FACP BD96A600, 00F4 (r3 LENOVO TP-6F        1130 LNVO        1)
[    0.000000] ACPI: DSDT BD96A9DB, F190 (r1 LENOVO TP-6F        1130 MSFT  3000000)
[    0.000000] ACPI: FACS BD98E000, 0040
[    0.000000] ACPI: SSDT BD96A7B4, 0227 (r1 LENOVO TP-6F        1130 MSFT  3000000)
[    0.000000] ACPI: ECDT BD979B6B, 0052 (r1 LENOVO TP-6F        1130 LNVO        1)
[    0.000000] ACPI: APIC BD979BBD, 0078 (r1 LENOVO TP-6F        1130 LNVO        1)
[    0.000000] ACPI: MCFG BD979C35, 003C (r1 LENOVO TP-6F        1130 LNVO        1)
[    0.000000] ACPI: HPET BD979C71, 0038 (r1 LENOVO TP-6F        1130 LNVO        1)
[    0.000000] ACPI: SLIC BD979DC2, 0176 (r1 LENOVO TP-6F        1130  LTP        0)
[    0.000000] ACPI: BOOT BD979F38, 0028 (r1 LENOVO TP-6F        1130  LTP        1)
[    0.000000] ACPI: ASF! BD979F60, 00A0 (r16 LENOVO TP-6F        1130 PTL         1)
[    0.000000] ACPI: SSDT BD98D213, 054F (r1 LENOVO TP-6F        1130 INTL 20050513)
[    0.000000] ACPI: TCPA BD707000, 0032 (r0                        0             0)
[    0.000000] ACPI: DMAR BD706000, 0120 (r1                       1             0)
[    0.000000] ACPI: SSDT BD6D3000, 0655 (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] ACPI: SSDT BD6D2000, 0274 (r1  PmRef  Cpu0Tst     3000 INTL 20050624)
[    0.000000] ACPI: SSDT BD6D1000, 0242 (r1  PmRef    ApTst     3000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 013c000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000097982c]    TEXT DATA BSS ==> [0000200000 - 000097982c]
[    0.000000]   #3 [0036aac000 - 0037fef111]          RAMDISK ==> [0036aac000 - 0037fef111]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #6 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f6590] 000f6590
[    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002c7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd4a1
[    0.000000]     0: 0x000bd4a7 -> 0x000bd5b7
[    0.000000]     0: 0x000bd60f -> 0x000bd6c6
[    0.000000]     0: 0x000bd9ff -> 0x000bda00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021447
[    0.000000]   DMA zone: 1924 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 757409 pages, LIFO batch:31
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd4a1000 - 00000000bd4a7000
[    0.000000] PM: Registered nosave memory: 00000000bd5b7000 - 00000000bd60f000
[    0.000000] PM: Registered nosave memory: 00000000bd6c6000 - 00000000bd6d1000
[    0.000000] PM: Registered nosave memory: 00000000bd6d1000 - 00000000bd6d4000
[    0.000000] PM: Registered nosave memory: 00000000bd6d4000 - 00000000bd6d8000
[    0.000000] PM: Registered nosave memory: 00000000bd6d8000 - 00000000bd6dc000
[    0.000000] PM: Registered nosave memory: 00000000bd6dc000 - 00000000bd6df000
[    0.000000] PM: Registered nosave memory: 00000000bd6df000 - 00000000bd706000
[    0.000000] PM: Registered nosave memory: 00000000bd706000 - 00000000bd708000
[    0.000000] PM: Registered nosave memory: 00000000bd708000 - 00000000bd90f000
[    0.000000] PM: Registered nosave memory: 00000000bd90f000 - 00000000bd99f000
[    0.000000] PM: Registered nosave memory: 00000000bd99f000 - 00000000bd9ff000
[    0.000000] PM: Registered nosave memory: 00000000bda00000 - 00000000bdc00000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
[    0.000000] PERCPU: Allocating 64096 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1001733
[    0.000000] Kernel command line: root=/dev/mapper/root_crypt rootfstype=ext4dev ro  
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2393.765 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.003333] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.003333] Memory: 3911124k/5177344k available (3704k kernel code, 173756k reserved, 1933k data, 492k init)
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.003333] hpet clockevent registered
[    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 4789.01 BogoMIPS (lpj=7979216)
[    0.003333] Security Framework initialized
[    0.003333] Mount-cache hash table entries: 256
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 3072K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] CPU0: Thermal monitoring enabled (TM2)
[    0.003333] using mwait in idle threads.
[    0.003333] ACPI: Core revision 20080609
[    0.026704] Setting APIC routing to flat
[    0.027156] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.060691] CPU0: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 06
[    0.063330] APIC timer calibration result 16623379
[    0.063332] Detected 16.623 MHz APIC timer.
[    0.063506] Booting processor 1/1 ip 6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 5428.97 BogoMIPS (lpj=9043157)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 3072K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] CPU1: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.158427] CPU1: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 06
[    0.159592] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.160017] Brought up 2 CPUs
[    0.160075] Total of 2 processors activated (10217.98 BogoMIPS).
[    0.160175] CPU0 attaching sched-domain:
[    0.160177]  domain 0: span 0-1 level MC
[    0.160180]   groups: 0 1
[    0.160184] CPU1 attaching sched-domain:
[    0.160186]  domain 0: span 0-1 level MC
[    0.160188]   groups: 1 0
[    0.163526] net_namespace: 1752 bytes
[    0.163588] Booting paravirtualized kernel on bare hardware
[    0.163920] xor: automatically using best checksumming function: generic_sse
[    0.176942]    generic_sse:  8335.200 MB/sec
[    0.177003] xor: using function: generic_sse (8335.200 MB/sec)
[    0.177086] Time: 22:51:32  Date: 10/19/08
[    0.177184] NET: Registered protocol family 16
[    0.180904] ACPI: ACPI Dock Station Driver
[    0.181651] ACPI: \_SB_.PCI0.SATA.PRT1: found ejectable bay
[    0.181659] ACPI: \_SB_.PCI0.SATA.PRT1: Adding notify handler
[    0.181713] ACPI: Bay [\_SB_.PCI0.SATA.PRT1] Added
[    0.182222] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.182316] ACPI: bus type pci registered
[    0.182497] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
[    0.182564] PCI: MCFG area at e0000000 reserved in E820
[    0.195567] PCI: Using MMCONFIG at e0000000 - e3ffffff
[    0.195630] PCI: Using configuration type 1 for base access
[    0.199348] ACPI: EC: EC description table is found, configuring boot EC
[    0.214948] ACPI: BIOS _OSI(Linux) query ignored
[    0.215011] ACPI: DMI System Vendor: LENOVO
[    0.215072] ACPI: DMI Product Name: 208252G
[    0.215132] ACPI: DMI Product Version: ThinkPad T500
[    0.215194] ACPI: DMI Board Name: 208252G
[    0.215254] ACPI: DMI BIOS Vendor: LENOVO
[    0.215315] ACPI: DMI BIOS Date: 08/19/2008
[    0.215375] ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
[    0.215440] ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
[    0.216669] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.253706] ACPI: Interpreter enabled
[    0.253767] ACPI: (supports S0 S3 S4 S5)
[    0.253961] ACPI: Using IOAPIC for interrupt routing
[    0.300788] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.300854] ACPI: EC: driver started in interrupt mode
[    0.300979] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.301172] PCI: 0000:00:02.0 reg 10 64bit mmio: [f4400000, f47fffff]
[    0.301180] PCI: 0000:00:02.0 reg 18 32bit mmio: [d0000000, dfffffff]
[    0.301189] PCI: 0000:00:02.0 reg 20 io port: [1800, 1807]
[    0.301227] PCI: 0000:00:02.1 reg 10 64bit mmio: [f4200000, f42fffff]
[    0.301289] PCI: 0000:00:03.0 reg 10 64bit mmio: [fc226800, fc22680f]
[    0.301324] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.301391] pci 0000:00:03.0: PME# disabled
[    0.301535] PCI: 0000:00:19.0 reg 10 32bit mmio: [fc000000, fc01ffff]
[    0.301545] PCI: 0000:00:19.0 reg 14 32bit mmio: [fc025000, fc025fff]
[    0.301554] PCI: 0000:00:19.0 reg 18 io port: [1840, 185f]
[    0.301599] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.301666] pci 0000:00:19.0: PME# disabled
[    0.301780] PCI: 0000:00:1a.0 reg 20 io port: [1860, 187f]
[    0.301862] PCI: 0000:00:1a.1 reg 20 io port: [1880, 189f]
[    0.301945] PCI: 0000:00:1a.2 reg 20 io port: [18a0, 18bf]
[    0.302030] PCI: 0000:00:1a.7 reg 10 32bit mmio: [fc226c00, fc226fff]
[    0.302092] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.302160] pci 0000:00:1a.7: PME# disabled
[    0.302262] PCI: 0000:00:1b.0 reg 10 64bit mmio: [fc020000, fc023fff]
[    0.302311] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.302378] pci 0000:00:1b.0: PME# disabled
[    0.302501] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.302567] pci 0000:00:1c.0: PME# disabled
[    0.302689] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.302756] pci 0000:00:1c.1: PME# disabled
[    0.302879] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.302946] pci 0000:00:1c.3: PME# disabled
[    0.303067] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.303323] pci 0000:00:1c.4: PME# disabled
[    0.303441] PCI: 0000:00:1d.0 reg 20 io port: [18c0, 18df]
[    0.303524] PCI: 0000:00:1d.1 reg 20 io port: [18e0, 18ff]
[    0.303607] PCI: 0000:00:1d.2 reg 20 io port: [1c00, 1c1f]
[    0.303695] PCI: 0000:00:1d.7 reg 10 32bit mmio: [fc227000, fc2273ff]
[    0.303757] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.303825] pci 0000:00:1d.7: PME# disabled
[    0.304079] PCI: 0000:00:1f.2 reg 10 io port: [1c48, 1c4f]
[    0.304088] PCI: 0000:00:1f.2 reg 14 io port: [183c, 183f]
[    0.304097] PCI: 0000:00:1f.2 reg 18 io port: [1c40, 1c47]
[    0.304106] PCI: 0000:00:1f.2 reg 1c io port: [1838, 183b]
[    0.304115] PCI: 0000:00:1f.2 reg 20 io port: [1c20, 1c3f]
[    0.304124] PCI: 0000:00:1f.2 reg 24 32bit mmio: [fc226000, fc2267ff]
[    0.304157] pci 0000:00:1f.2: PME# supported from D3hot
[    0.304222] pci 0000:00:1f.2: PME# disabled
[    0.304305] PCI: 0000:00:1f.3 reg 10 64bit mmio: [fc227400, fc2274ff]
[    0.304325] PCI: 0000:00:1f.3 reg 20 io port: [1c60, 1c7f]
[    0.304521] PCI: 0000:03:00.0 reg 10 64bit mmio: [f4300000, f4301fff]
[    0.304640] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.304731] pci 0000:03:00.0: PME# disabled
[    0.304839] PCI: bridge 0000:00:1c.1 32bit mmio: [f4300000, f43fffff]
[    0.304900] PCI: bridge 0000:00:1c.3 io port: [2000, 2fff]
[    0.304906] PCI: bridge 0000:00:1c.3 32bit mmio: [f8000000, f9ffffff]
[    0.304916] PCI: bridge 0000:00:1c.3 64bit mmio pref: [f4000000, f40fffff]
[    0.304973] PCI: bridge 0000:00:1c.4 io port: [3000, 3fff]
[    0.304979] PCI: bridge 0000:00:1c.4 32bit mmio: [fa000000, fbffffff]
[    0.304989] PCI: bridge 0000:00:1c.4 64bit mmio pref: [f4100000, f41fffff]
[    0.305037] PCI: 0000:15:00.0 reg 10 32bit mmio: [f4800000, f4800fff]
[    0.305059] pci 0000:15:00.0: supports D1
[    0.305062] pci 0000:15:00.0: supports D2
[    0.305065] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.305134] pci 0000:15:00.0: PME# disabled
[    0.305233] PCI: 0000:15:00.1 reg 10 32bit mmio: [f4801000, f48017ff]
[    0.305295] pci 0000:15:00.1: supports D1
[    0.305298] pci 0000:15:00.1: supports D2
[    0.305301] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.305370] pci 0000:15:00.1: PME# disabled
[    0.305469] PCI: 0000:15:00.2 reg 10 32bit mmio: [f4801800, f48018ff]
[    0.305531] pci 0000:15:00.2: supports D1
[    0.305534] pci 0000:15:00.2: supports D2
[    0.305537] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.305605] pci 0000:15:00.2: PME# disabled
[    0.305704] PCI: 0000:15:00.3 reg 10 32bit mmio: [f4801c00, f4801cff]
[    0.305766] pci 0000:15:00.3: supports D1
[    0.305769] pci 0000:15:00.3: supports D2
[    0.305772] pci 0000:15:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.305841] pci 0000:15:00.3: PME# disabled
[    0.305939] PCI: 0000:15:00.4 reg 10 32bit mmio: [f4802000, f48020ff]
[    0.306001] pci 0000:15:00.4: supports D1
[    0.306003] pci 0000:15:00.4: supports D2
[    0.306007] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.306075] pci 0000:15:00.4: PME# disabled
[    0.306174] PCI: 0000:15:00.5 reg 10 32bit mmio: [f4802400, f48024ff]
[    0.306235] pci 0000:15:00.5: supports D1
[    0.306238] pci 0000:15:00.5: supports D2
[    0.306241] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.306310] pci 0000:15:00.5: PME# disabled
[    0.306431] pci 0000:00:1e.0: transparent bridge
[    0.306494] PCI: bridge 0000:00:1e.0 io port: [4000, 7fff]
[    0.306501] PCI: bridge 0000:00:1e.0 32bit mmio: [f4800000, f7ffffff]
[    0.306510] PCI: bridge 0000:00:1e.0 64bit mmio pref: [f0000000, f3ffffff]
[    0.306565] bus 00 -> node 0
[    0.306576] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.307389] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.307848] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.308308] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.308770] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.309231] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.320617] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.321629] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.322639] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.323660] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.324681] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.325689] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.326708] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.327725] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.328296] ACPI: Power Resource [PUBS] (on)
[    0.328296] ACPI: WMI: Mapper loaded
[    0.328296] SCSI subsystem initialized
[    0.330017] libata version 3.00 loaded.
[    0.330241] PCI: Using ACPI for IRQ routing
[    0.346668] NetLabel: Initializing
[    0.346728] NetLabel:  domain hash size = 128
[    0.346789] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.346871] NetLabel:  unlabeled traffic allowed by default
[    0.346967] PCI-GART: No AMD northbridge found.
[    0.347037] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.347236] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.350862] tracer: 1286 pages allocated for 65536 entries of 80 bytes
[    0.350928]    actual entries 65586
[    0.359981] pnp: PnP ACPI init
[    0.360054] ACPI: bus type pnp registered
[    0.429449] pnp: PnP ACPI: found 12 devices
[    0.429512] ACPI: ACPI bus type pnp unregistered
[    0.429585] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.429650] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.429716] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.429782] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.429848] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.429913] system 00:00: iomem range 0xdc000-0xdffff could not be reserved
[    0.429991] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.430057] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.430124] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.430190] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.430257] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.430323] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
[    0.430416] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
[    0.430509] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
[    0.430610] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.430676] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.430742] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.430807] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.430872] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.430938] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.431003] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.431069] system 00:02: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.431163] system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
[    0.431256] system 00:02: iomem range 0xfed10000-0xfed13fff could not be reserved
[    0.431350] system 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
[    0.431444] system 00:02: iomem range 0xfed19000-0xfed19fff could not be reserved
[    0.431538] system 00:02: iomem range 0xfed45000-0xfed4bfff could not be reserved
[    0.437473] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.437538] pci 0000:00:1c.0:   IO window: disabled
[    0.437604] pci 0000:00:1c.0:   MEM window: disabled
[    0.437669] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.437737] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.437801] pci 0000:00:1c.1:   IO window: disabled
[    0.437867] pci 0000:00:1c.1:   MEM window: 0xf4300000-0xf43fffff
[    0.437933] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.438001] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.438067] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.438133] pci 0000:00:1c.3:   MEM window: 0xf8000000-0xf9ffffff
[    0.438200] pci 0000:00:1c.3:   PREFETCH window: 0x000000f4000000-0x000000f40fffff
[    0.438298] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0d
[    0.438363] pci 0000:00:1c.4:   IO window: 0x3000-0x3fff
[    0.438430] pci 0000:00:1c.4:   MEM window: 0xfa000000-0xfbffffff
[    0.438497] pci 0000:00:1c.4:   PREFETCH window: 0x000000f4100000-0x000000f41fffff
[    0.438600] pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
[    0.438665] pci 0000:15:00.0:   IO window: 0x004000-0x0040ff
[    0.438732] pci 0000:15:00.0:   IO window: 0x004400-0x0044ff
[    0.438799] pci 0000:15:00.0:   PREFETCH window: 0xf0000000-0xf3ffffff
[    0.438867] pci 0000:15:00.0:   MEM window: 0xc4000000-0xc7ffffff
[    0.438935] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
[    0.439000] pci 0000:00:1e.0:   IO window: 0x4000-0x7fff
[    0.439067] pci 0000:00:1e.0:   MEM window: 0xf4800000-0xf7ffffff
[    0.439134] pci 0000:00:1e.0:   PREFETCH window: 0x000000f0000000-0x000000f3ffffff
[    0.439243] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.439312] pci 0000:00:1c.0: setting latency timer to 64
[    0.439324] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.439392] pci 0000:00:1c.1: setting latency timer to 64
[    0.439404] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.439472] pci 0000:00:1c.3: setting latency timer to 64
[    0.439482] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.439549] pci 0000:00:1c.4: setting latency timer to 64
[    0.439559] pci 0000:00:1e.0: setting latency timer to 64
[    0.439573] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.439642] bus: 00 index 0 io port: [0, ffff]
[    0.439714] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.439777] bus: 02 index 0 mmio: [0, 0]
[    0.439837] bus: 02 index 1 mmio: [0, 0]
[    0.440440] bus: 02 index 2 mmio: [0, 0]
[    0.440500] bus: 02 index 3 mmio: [0, 0]
[    0.440560] bus: 03 index 0 mmio: [0, 0]
[    0.440620] bus: 03 index 1 mmio: [f4300000, f43fffff]
[    0.440683] bus: 03 index 2 mmio: [0, 0]
[    0.440743] bus: 03 index 3 mmio: [0, 0]
[    0.440803] bus: 05 index 0 io port: [2000, 2fff]
[    0.440865] bus: 05 index 1 mmio: [f8000000, f9ffffff]
[    0.440927] bus: 05 index 2 mmio: [f4000000, f40fffff]
[    0.440989] bus: 05 index 3 mmio: [0, 0]
[    0.441050] bus: 0d index 0 io port: [3000, 3fff]
[    0.441111] bus: 0d index 1 mmio: [fa000000, fbffffff]
[    0.441173] bus: 0d index 2 mmio: [f4100000, f41fffff]
[    0.441235] bus: 0d index 3 mmio: [0, 0]
[    0.441296] bus: 15 index 0 io port: [4000, 7fff]
[    0.441358] bus: 15 index 1 mmio: [f4800000, f7ffffff]
[    0.441420] bus: 15 index 2 mmio: [f0000000, f3ffffff]
[    0.441483] bus: 15 index 3 io port: [0, ffff]
[    0.441544] bus: 15 index 4 mmio: [0, ffffffffffffffff]
[    0.441607] bus: 16 index 0 io port: [4000, 40ff]
[    0.441669] bus: 16 index 1 io port: [4400, 44ff]
[    0.441730] bus: 16 index 2 mmio: [f0000000, f3ffffff]
[    0.441793] bus: 16 index 3 mmio: [c4000000, c7ffffff]
[    0.441864] NET: Registered protocol family 2
[    0.473082] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.473744] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.475435] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.475983] TCP: Hash tables configured (established 262144 bind 65536)
[    0.476050] TCP reno registered
[    0.483152] NET: Registered protocol family 1
[    0.483365] checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
[    0.546643] Switched to high resolution mode on CPU 0
[    1.370243]  it is
[    2.306792] Freeing initrd memory: 21772k freed
[    2.318708] Simple Boot Flag at 0x35 set to 0x1
[    2.319508] audit: initializing netlink socket (disabled)
[    2.319578] type=2000 audit(1224456694.317:1): initialized
[    2.319963] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.321825] VFS: Disk quotas dquot_6.5.1
[    2.321948] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.322531] fuse init (API version 7.9)
[    2.322717] msgmni has been set to 7683
[    2.322921] alg: No test for stdrng (krng)
[    2.322992] async_tx: api initialized (async)
[    2.323052] io scheduler noop registered
[    2.323110] io scheduler anticipatory registered
[    2.323168] io scheduler deadline registered
[    2.323273] io scheduler cfq registered (default)
[    2.323351] pci 0000:00:02.0: Boot video device
[    2.323588] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    2.323625] pcieport-driver 0000:00:1c.0: found MSI capability
[    2.323724] pci_express 0000:00:1c.0:pcie00: allocate port service
[    2.323762] pci_express 0000:00:1c.0:pcie02: allocate port service
[    2.323793] pci_express 0000:00:1c.0:pcie03: allocate port service
[    2.323875] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    2.323911] pcieport-driver 0000:00:1c.1: found MSI capability
[    2.324005] pci_express 0000:00:1c.1:pcie00: allocate port service
[    2.324036] pci_express 0000:00:1c.1:pcie02: allocate port service
[    2.324065] pci_express 0000:00:1c.1:pcie03: allocate port service
[    2.324150] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    2.324185] pcieport-driver 0000:00:1c.3: found MSI capability
[    2.324279] pci_express 0000:00:1c.3:pcie00: allocate port service
[    2.324311] pci_express 0000:00:1c.3:pcie02: allocate port service
[    2.324340] pci_express 0000:00:1c.3:pcie03: allocate port service
[    2.324424] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    2.324460] pcieport-driver 0000:00:1c.4: found MSI capability
[    2.324554] pci_express 0000:00:1c.4:pcie00: allocate port service
[    2.324586] pci_express 0000:00:1c.4:pcie02: allocate port service
[    2.324615] pci_express 0000:00:1c.4:pcie03: allocate port service
[    2.324744] vmlfb: initializing
[    2.324777] Could not find Carillo Ranch MCH device.
[    2.324950] vga16fb: initializing
[    2.324952] vga16fb: mapped to 0xffff8800000a0000
[    2.325055] fb0: VGA16 VGA frame buffer device
[    2.325810] ACPI: AC Adapter [AC] (on-line)
[    2.363580] ACPI: Battery Slot [BAT0] (battery present)
[    2.363773] input: Power Button (FF) as /class/input/input0
[    2.363835] ACPI: Power Button (FF) [PWRF]
[    2.363982] input: Lid Switch as /class/input/input1
[    2.368334] ACPI: Lid Switch [LID]
[    2.368446] input: Sleep Button (CM) as /class/input/input2
[    2.368509] ACPI: Sleep Button (CM) [SLPB]
[    2.369156] ACPI: SSDT BD6D6C20, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
[    2.369904] ACPI: SSDT BD6D4020, 087A (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
[    2.372616] Monitor-Mwait will be used to enter C-1 state
[    2.372619] Monitor-Mwait will be used to enter C-2 state
[    2.372621] Monitor-Mwait will be used to enter C-3 state
[    2.372654] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    2.372848] processor ACPI0007:00: registered as cooling_device0
[    2.372911] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.373467] ACPI: SSDT BD6D5CA0, 01CF (r1  PmRef    ApIst     3000 INTL 20050624)
[    2.374109] ACPI: SSDT BD6D5F20, 008D (r1  PmRef    ApCst     3000 INTL 20050624)
[    2.375675] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    2.375868] processor ACPI0007:01: registered as cooling_device1
[    2.375930] ACPI: Processor [CPU1] (supports 8 throttling states)
[    2.419066] thermal LNXTHERM:01: registered as thermal_zone0
[    2.421783] ACPI: Thermal Zone [THM0] (49 C)
[    2.422767] thermal LNXTHERM:02: registered as thermal_zone1
[    2.424027] ACPI: Thermal Zone [THM1] (48 C)
[    2.470202] Linux agpgart interface v0.103
[    2.470284] agpgart-intel 0000:00:00.0: Intel Mobile Intel? GM45 Express Chipset
[    2.471449] agpgart-intel 0000:00:00.0: detected 32252K stolen memory
[    2.481619] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    2.481727] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    2.481818] Hangcheck: Using get_cycles().
[    2.481877] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[    2.481970] intelfb: Version 0.9.6
[    2.482064] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    2.482262] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.482987] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.484247] brd: module loaded
[    2.484329] console [netcon0] enabled
[    2.484387] netconsole: network logging started
[    2.484462] ahci 0000:00:1f.2: version 3.0
[    2.484474] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.484620] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.484710] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part 
[    2.484802] ahci 0000:00:1f.2: setting latency timer to 64
[    2.484910] scsi0 : ahci
[    2.485052] scsi1 : ahci
[    2.485163] scsi2 : ahci
[    2.485275] scsi3 : ahci
[    2.486079] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 2299
[    2.486169] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 2299
[    2.486258] ata3: DUMMY
[    2.486313] ata4: DUMMY
[    2.803351] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.805190] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    2.805192] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    2.805253] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    2.806947] ata1.00: ATA-8: WDC WD3200BEKT-22F3T0, 11.01A11, max UDMA/133
[    2.807009] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.808886] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    2.808888] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    2.808948] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    2.810632] ata1.00: configured for UDMA/133
[    2.826652] ata1.00: configured for UDMA/133
[    2.826715] ata1: EH complete
[    3.146680] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.148959] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    3.148961] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    3.149022] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    3.149886] ata2.00: ATA-8: Hitachi HTS722020K9SA00, DC4OC54P, max UDMA/133
[    3.149948] ata2.00: 390721968 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.152355] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    3.152358] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    3.152418] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    3.153284] ata2.00: configured for UDMA/133
[    3.168474] ata2.00: configured for UDMA/133
[    3.168533] ata2: EH complete
[    3.168700] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200BEKT-2 11.0 PQ: 0 ANSI: 5
[    3.168927] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HTS72202 DC4O PQ: 0 ANSI: 5
[    3.169280] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.177782] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.177844] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.178026] mice: PS/2 mouse device common for all mice
[    3.178141] rtc_cmos 00:07: RTC can wake from S4
[    3.178251] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.178335] rtc0: alarms up to one month, y3k, hpet irqs
[    3.178421] md: linear personality registered for level -1
[    3.178481] md: raid0 personality registered for level 0
[    3.178540] md: raid1 personality registered for level 1
[    3.178599] md: raid10 personality registered for level 10
[    3.233333] raid6: int64x1   2171 MB/s
[    3.290003] raid6: int64x2   2932 MB/s
[    3.346680] raid6: int64x4   2760 MB/s
[    3.403339] raid6: int64x8   1964 MB/s
[    3.460003] raid6: sse2x1    3732 MB/s
[    3.516675] raid6: sse2x2    4305 MB/s
[    3.573331] raid6: sse2x4    6814 MB/s
[    3.573388] raid6: using algorithm sse2x4 (6814 MB/s)
[    3.573448] md: raid6 personality registered for level 6
[    3.573507] md: raid5 personality registered for level 5
[    3.573566] md: raid4 personality registered for level 4
[    3.573626] md: multipath personality registered for level -4
[    3.573686] md: faulty personality registered for level -5
[    3.574072] device-mapper: uevent: version 1.0.3
[    3.574228] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    3.574438] device-mapper: multipath: version 1.0.5 loaded
[    3.574498] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.574777] cpuidle: using governor ladder
[    3.575197] cpuidle: using governor menu
[    3.575311] Netfilter messages via NETLINK v0.30.
[    3.575587] TCP cubic registered
[    3.575780] registered taskstats version 1
[    3.575954]   Magic number: 12:127:907
[    3.576063] tty ptyz3: hash matches
[    3.576203] rtc_cmos 00:07: setting system clock to 2008-10-19 22:51:36 UTC (1224456696)
[    3.576366] Marking TSC unstable due to TSC halts in idle
[    3.576381] Freeing unused kernel memory: 492k freed
[    3.576538] Write protecting the kernel read-only data: 1596k
[    3.579456] input: AT Translated Set 2 keyboard as /class/input/input3
[    4.129246] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    4.129317] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    4.129419] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.129492] e1000e 0000:00:19.0: setting latency timer to 64
[    4.158524] usbcore: registered new interface driver usbfs
[    4.158607] usbcore: registered new interface driver hub
[    4.158701] usbcore: registered new device driver usb
[    4.170381] USB Universal Host Controller Interface driver v3.0
[    4.196318] firewire_ohci 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.205026] Driver 'sd' needs updating - please use bus_type methods
[    4.205190] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320GB/298GiB)
[    4.205303] sd 0:0:0:0: [sda] Write Protect is off
[    4.205366] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.205397] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.205554] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320GB/298GiB)
[    4.205658] sd 0:0:0:0: [sda] Write Protect is off
[    4.205718] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.205747] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.205840]  sda:<6>0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:21:86:60:5d:d6
[    4.229251] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.229333] 0000:00:19.0: eth0: MAC: 6, PHY: 8, PBA No: 1008ff-0ff
[    4.230109] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.230176] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.230246] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.230250] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.230343] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.230466] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    4.230665] usb usb1: configuration #1 chosen from 1 choice
[    4.230750] hub 1-0:1.0: USB hub found
[    4.230815] hub 1-0:1.0: 2 ports detected
[    4.243673]  sda1 sda2 sda3
[    4.244207] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.244335] sd 1:0:0:0: [sdb] 390721968 512-byte hardware sectors: (200GB/186GiB)
[    4.244437] sd 1:0:0:0: [sdb] Write Protect is off
[    4.244493] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.244523] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.244660] sd 1:0:0:0: [sdb] 390721968 512-byte hardware sectors: (200GB/186GiB)
[    4.244760] sd 1:0:0:0: [sdb] Write Protect is off
[    4.244817] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.244846] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.244935]  sdb:<5>firewire_ohci: Added fw-ohci device 0000:15:00.1, OHCI version 1.10
[    4.333541] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.333610] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.333698] usb usb1: Product: UHCI Host Controller
[    4.333756] usb usb1: Manufacturer: Linux 2.6.27-andres-04904-gc813b4e uhci_hcd
[    4.333844] usb usb1: SerialNumber: 0000:00:1a.0
[    4.335662] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.335735] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    4.335810] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.335813] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.335893] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 2
[    4.339886] ehci_hcd 0000:00:1a.7: debug port 1
[    4.339948] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    4.339960] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
[    4.353399] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    4.353571] usb usb2: configuration #1 chosen from 1 choice
[    4.353650] hub 2-0:1.0: USB hub found
[    4.353711] hub 2-0:1.0: 6 ports detected
[    4.500062] Clocksource tsc unstable (delta = -255335965 ns)
[    4.560134] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.560196] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.560289] usb usb2: Product: EHCI Host Controller
[    4.560348] usb usb2: Manufacturer: Linux 2.6.27-andres-04904-gc813b4e ehci_hcd
[    4.560436] usb usb2: SerialNumber: 0000:00:1a.7
[    4.560512] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.560578] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.560581] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.560655] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[    4.560769] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    4.560896] usb usb3: configuration #1 chosen from 1 choice
[    4.560973] hub 3-0:1.0: USB hub found
[    4.561034] hub 3-0:1.0: 2 ports detected
[    4.591351]  sdb1 sdb2 sdb3
[    4.591601] sd 1:0:0:0: [sdb] Attached SCSI disk
[    4.595749] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.595847] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    4.766871] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.766943] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.767031] usb usb3: Product: UHCI Host Controller
[    4.767089] usb usb3: Manufacturer: Linux 2.6.27-andres-04904-gc813b4e uhci_hcd
[    4.767177] usb usb3: SerialNumber: 0000:00:1a.1
[    4.768316] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.768387] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.768464] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.768467] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.768545] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[    4.770511] firewire_core: created device fw0: GUID 00061b032a2f5b28, S400
[    4.772539] ehci_hcd 0000:00:1d.7: debug port 1
[    4.772601] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.772615] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
[    4.880070] usb 2-5: new high speed USB device using ehci_hcd and address 4
[    4.884276] Monitor-Mwait will be used to enter C-3 state
[    4.890463] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    4.890593] usb usb4: configuration #1 chosen from 1 choice
[    4.890616] hub 4-0:1.0: USB hub found
[    4.890624] hub 4-0:1.0: 6 ports detected
[    5.013794] usb 2-5: configuration #1 chosen from 1 choice
[    5.014192] hub 2-5:1.0: USB hub found
[    5.014321] hub 2-5:1.0: 4 ports detected
[    5.096871] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    5.096874] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.096877] usb usb4: Product: EHCI Host Controller
[    5.096879] usb usb4: Manufacturer: Linux 2.6.27-andres-04904-gc813b4e ehci_hcd
[    5.096881] usb usb4: SerialNumber: 0000:00:1d.7
[    5.098539] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    5.098549] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    5.098557] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.098560] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.098585] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    5.098618] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    5.098704] usb usb5: configuration #1 chosen from 1 choice
[    5.098724] hub 5-0:1.0: USB hub found
[    5.098730] hub 5-0:1.0: 2 ports detected
[    5.120708] usb 2-5: New USB device found, idVendor=04b3, idProduct=4485
[    5.120710] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.226741] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    5.303536] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.303539] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.303541] usb usb5: Product: UHCI Host Controller
[    5.303544] usb usb5: Manufacturer: Linux 2.6.27-andres-04904-gc813b4e uhci_hcd
[    5.303546] usb usb5: SerialNumber: 0000:00:1a.2
[    5.304620] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    5.304629] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.304637] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.304641] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.304679] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    5.304712] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    5.304786] usb usb6: configuration #1 chosen from 1 choice
[    5.304807] hub 6-0:1.0: USB hub found
[    5.304812] hub 6-0:1.0: 2 ports detected
[    5.385975] usb 3-1: configuration #1 chosen from 1 choice
[    5.388068] usb 3-1: New USB device found, idVendor=08ff, idProduct=2810
[    5.388071] usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.388074] usb 3-1: Product: Fingerprint Sensor
[    5.510205] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.510208] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.510211] usb usb6: Product: UHCI Host Controller
[    5.510213] usb usb6: Manufacturer: Linux 2.6.27-andres-04904-gc813b4e uhci_hcd
[    5.510215] usb usb6: SerialNumber: 0000:00:1d.0
[    5.510243] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.510248] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.510250] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.510265] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    5.510286] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    5.510355] usb usb7: configuration #1 chosen from 1 choice
[    5.510373] hub 7-0:1.0: USB hub found
[    5.510377] hub 7-0:1.0: 2 ports detected
[    5.613397] usb 3-2: new full speed USB device using uhci_hcd and address 3
[    5.716807] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    5.716810] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.716813] usb usb7: Product: UHCI Host Controller
[    5.716815] usb usb7: Manufacturer: Linux 2.6.27-andres-04904-gc813b4e uhci_hcd
[    5.716817] usb usb7: SerialNumber: 0000:00:1d.1
[    5.716843] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.716854] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.716857] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.716872] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    5.716899] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    5.716964] usb usb8: configuration #1 chosen from 1 choice
[    5.716982] hub 8-0:1.0: USB hub found
[    5.716987] hub 8-0:1.0: 2 ports detected
[    5.774976] usb 3-2: configuration #1 chosen from 1 choice
[    5.777186] usb 3-2: New USB device found, idVendor=0a5c, idProduct=2145
[    5.777188] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.777190] usb 3-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    5.777191] usb 3-2: Manufacturer: Lenovo Computer Corp
[    5.820206] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    5.820209] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.820212] usb usb8: Product: UHCI Host Controller
[    5.820214] usb usb8: Manufacturer: Linux 2.6.27-andres-04904-gc813b4e uhci_hcd
[    5.820216] usb usb8: SerialNumber: 0000:00:1d.2
[    5.883418] usb 4-2: new high speed USB device using ehci_hcd and address 2
[    6.008876] usb 4-2: configuration #1 chosen from 1 choice
[    6.009498] usb 4-2: New USB device found, idVendor=2040, idProduct=9301
[    6.009500] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    6.009502] usb 4-2: Product: SOHO-FX2
[    6.009503] usb 4-2: Manufacturer: Hauppau?? 
[    6.009505] usb 4-2: SerialNumber: 9301-00-F007422D
[    6.113410] usb 4-4: new high speed USB device using ehci_hcd and address 3
[    6.317856] usb 4-4: configuration #1 chosen from 2 choices
[    6.360993] usb 4-4: New USB device found, idVendor=0bdb, idProduct=1900
[    6.360995] usb 4-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    6.360997] usb 4-4: Product: Ericsson F3507g Mobile Broadband Minicard Composite Device
[    6.360999] usb 4-4: Manufacturer: Ericsson
[    6.361000] usb 4-4: SerialNumber: 3541430202682800
[   11.294543] PM: Starting manual resume from disk
[   11.294603] PM: Resume from partition 253:1
[   11.294605] PM: Checking hibernation image.
[   11.294795] PM: Resume from disk failed.
[   11.297557] EXT4-fs: Update your userspace programs to mount using ext4
[   11.297620] EXT4-fs: ext4dev backwards compatibility will go away by 2.6.31
[   11.401128] EXT4-fs: barriers enabled
[   11.413286] kjournald2 starting.  Commit interval 5 seconds
[   11.413382] EXT4-fs: mounted filesystem with ordered data mode.
[   11.413447] EXT4-fs: delayed allocation enabled
[   11.413506] EXT4-fs: file extents enabled
[   11.454727] EXT4-fs: mballoc enabled
[   18.517990] udevd version 124 started
[   18.875759] Non-volatile memory driver v1.2
[   19.206068] thinkpad_acpi: ThinkPad ACPI Extras v0.21
[   19.206134] thinkpad_acpi: http://ibm-acpi.sf.net/
[   19.206193] thinkpad_acpi: ThinkPad BIOS 6FET43WW (1.13 ), EC 7VHT12WW-1.01
[   19.206255] thinkpad_acpi: Lenovo ThinkPad T500, model 208252G
[   19.208675] thinkpad_acpi: radio switch found; radios are enabled
[   19.208847] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   19.208942] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   19.287763] acpi device:03: registered as cooling_device2
[   19.288033] input: Video Bus as /class/input/input4
[   19.322745] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   19.324190] acpi device:0a: registered as cooling_device3
[   19.324419] input: Video Bus as /class/input/input5
[   19.331085] Registered led device: tpacpi::thinklight
[   19.331199] Registered led device: tpacpi::power
[   19.331271] Registered led device: tpacpi:orange:batt
[   19.331340] Registered led device: tpacpi:green:batt
[   19.331433] Registered led device: tpacpi::dock_active
[   19.331504] Registered led device: tpacpi::bay_active
[   19.331574] Registered led device: tpacpi::dock_batt
[   19.331644] Registered led device: tpacpi::unknown_led
[   19.332260] Registered led device: tpacpi::standby
[   19.350561] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[   19.374580] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   19.375192] thinkpad_acpi: Lenovo BIOS switched to ACPI backlight control mode
[   19.375281] thinkpad_acpi: standard ACPI backlight interface available, not loading native one...
[   19.375682] input: ThinkPad Extra Buttons as /class/input/input6
[   19.446240] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   19.665737] sdhci: Secure Digital Host Controller Interface driver
[   19.665817] sdhci: Copyright(c) Pierre Ossman
[   19.749199] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[   19.761022] ricoh-mmc: Ricoh MMC Controller disabling driver
[   19.761085] ricoh-mmc: Copyright(c) Philip Langdale
[   19.876889] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[   19.876957] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[   19.877019] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x7fff
[   19.877115] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf4800000 - 0xf7ffffff
[   19.877206] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf0000000 - 0xf3ffffff
[   19.877489] ricoh-mmc: Ricoh MMC controller found at 0000:15:00.3 [1180:0843] (rev 11)
[   19.877599] ricoh-mmc: Controller is now disabled.
[   19.947411] cfg80211: Calling CRDA to update world regulatory domain
[   19.979038] sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
[   19.979162] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   19.980411] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[   19.982840] mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
[   20.201410] Bluetooth: Core ver 2.13
[   20.201543] NET: Registered protocol family 31
[   20.201602] Bluetooth: HCI device and connection manager initialized
[   20.201666] Bluetooth: HCI socket layer initialized
[   20.240256] cdc_acm 4-4:1.1: ttyACM0: USB ACM device
[   20.242542] cdc_acm 4-4:1.3: ttyACM1: USB ACM device
[   20.243315] cdc_acm 4-4:1.9: ttyACM2: USB ACM device
[   20.243877] usbcore: registered new interface driver cdc_acm
[   20.243947] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[   20.399476] Bluetooth: Generic Bluetooth USB driver ver 0.3
[   20.399634] usbcore: registered new interface driver btusb
[   20.536072] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04791/0xb00000
[   20.536175] serio: Synaptics pass-through port at isa0060/serio1/input0
[   20.583963] input: SynPS/2 Synaptics TouchPad as /class/input/input7
[   20.996995] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[   20.997108] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[   20.997331] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   20.997423] iwlagn 0000:03:00.0: setting latency timer to 64
[   20.997472] iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
[   21.029190] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[   21.029623] iwlagn 0000:03:00.0: PCI INT A disabled
[   21.029982] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   21.098214] dvb-usb: found a 'Hauppauge WinTV-NOVA-T usb2' in warm state.
[   21.100183] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   21.102292] DVB: registering new adapter (Hauppauge WinTV-NOVA-T usb2)
[   21.103492] dvb-usb: MAC address: 00:0d:fe:07:42:2d
[   21.105121] DVB: registering frontend 0 (DiBcom 3000MC/P)...
[   21.379189] input: IR-receiver inside an USB DVB receiver as /class/input/input8
[   21.397236] dvb-usb: schedule remote query interval to 100 msecs.
[   21.397305] dvb-usb: Hauppauge WinTV-NOVA-T usb2 successfully initialized and connected.
[   21.397417] usbcore: registered new interface driver dvb_usb_nova_t_usb2
[   21.928774] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   21.928888] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   22.341571] loop: module loaded
[   22.873730] EXT4 FS on dm-0, internal journal on dm-0:8
[   23.312403] kjournald starting.  Commit interval 5 seconds
[   23.312904] EXT3 FS on sda2, internal journal
[   23.312912] EXT3-fs: mounted filesystem with ordered data mode.
[   23.355648] Adding 3903236k swap on /dev/mapper/swap_crypt.  Priority:-1 extents:1 across:3903236k
[   26.375342] NET: Registered protocol family 10
[   26.375759] lo: Disabled Privacy Extensions
[   26.420568] JBD: barrier-based sync failed on dm-0:8 - disabling barriers
[   26.734433] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   26.984873] input: TPPS/2 IBM TrackPoint as /class/input/input9
[   38.871700] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[   40.073922] Bluetooth: L2CAP ver 2.11
[   40.073925] Bluetooth: L2CAP socket layer initialized
[   40.117240] Bluetooth: SCO (Voice Link) ver 0.6
[   40.117244] Bluetooth: SCO socket layer initialized
[   40.256249] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   40.256253] Bluetooth: BNEP filters: protocol multicast
[   40.422218] Bluetooth: RFCOMM socket layer initialized
[   40.422230] Bluetooth: RFCOMM TTY layer initialized
[   40.422232] Bluetooth: RFCOMM ver 1.10
[   40.595935] Bridge firewalling registered
[   40.596187] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
[   42.747666] [drm] Initialized drm 1.1.0 20060810
[   42.816917] pci 0000:00:02.0: power state changed by ACPI to D0
[   42.816926] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   42.816930] pci 0000:00:02.0: setting latency timer to 64
[   42.817305] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   43.449435] set status page addr 0x02ef0000
[   44.771203] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   44.771885] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   44.772339] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
[   44.772472] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.ucode
[   47.057372] 0000:00:19.0: eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   47.057377] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   47.083421] Registered led device: iwl-phy0:radio
[   47.083448] Registered led device: iwl-phy0:assoc
[   47.083471] Registered led device: iwl-phy0:RX
[   47.083492] Registered led device: iwl-phy0:TX
[   47.105376] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   47.114894] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   47.227601] NET: Registered protocol family 17
[   55.621314] tun: Universal TUN/TAP device driver, 1.6
[   55.621319] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   55.622162] tun0: Disabled Privacy Extensions
[   56.756742] tun1: Disabled Privacy Extensions
[   57.200504] eth0: no IPv6 routers present
[   72.459549] CPU0 attaching NULL sched-domain.
[   72.459555] CPU1 attaching NULL sched-domain.
[   72.466739] CPU0 attaching sched-domain:
[   72.466746]  domain 0: span 0-1 level MC
[   72.466749]   groups: 0 1
[   72.466754] CPU1 attaching sched-domain:
[   72.466756]  domain 0: span 0-1 level MC
[   72.466758]   groups: 1 0
[   80.933147] iwlagn 0000:03:00.0: PCI INT A disabled
[  113.962191] dtv_property_cache_sync()
[  127.149585] dtv_property_cache_sync()
[  220.191520] dtv_property_cache_sync()
[  455.924629] dtv_property_cache_sync()
[  863.332424] dtv_property_cache_sync()

--Boundary-00=_K67+I2J/SHnsUnF--
