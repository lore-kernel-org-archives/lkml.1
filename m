Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbYG1Q6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbYG1Q6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYG1Q55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:57:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37937 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYG1Q5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:57:55 -0400
Date: Mon, 28 Jul 2008 10:57:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Pierre Ossman <drzeus-list@drzeus.cx>, Alex Chiang <achiang@hp.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Kristen Accardi <kristen.c.accardi@intel.com>
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080728165753.GA16059@parisc-linux.org>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <20080725012916.06679a6d@mjolnir.drzeus.cx> <48895BA1.1030606@jp.fujitsu.com> <200807251518.53462.jbarnes@virtuousgeek.org> <488D86EC.1010903@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488D86EC.1010903@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 05:44:28PM +0900, Kenji Kaneshige wrote:
> But, I think simply checking for _RMV method first is dangerous because
> I think there are many systems that doesn't implement _RMV for PCIe
> hotplug slots (at least, my system doesn't implement that. Anyway,
> I would like to look at the documents/specifications that mention _RMV
> method for determining whether a given slot is hot pluggable. Do you
> have any information about that? I think PCI Local Bus, PCI Express and
> PCI Firmware specification don't mention that. I think hot pluggable slots
> on your, Pierre's and Matthew's system are ExpressCard slots. So I guess
> ExpressCard specification might define something about this. But
> unfortunately, I don't have ExpressCard specification. Can anyone access
> ExpressCard spec?

My only externally visible slot is CardBus, not ExpressCard.  It's this
laptop:

http://store.shopfujitsu.com/ca/EcomCA/buildseriesbean.do?series=P8010

full lspci:

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 03)
        Subsystem: Fujitsu Limited. Device 13f2
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information <?>
        Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
        Subsystem: Fujitsu Limited. Device 13fe
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fc000000 (64-bit, non-prefetchable) [size=1M]
        Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 1800 [size=8]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
        Subsystem: Fujitsu Limited. Device 13fe
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at fc100000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03)
        Subsystem: Fujitsu Limited. Device 1414
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 22
        Region 4: I/O ports at 1820 [size=32]
        Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03)
        Subsystem: Fujitsu Limited. Device 1414
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 22
        Region 4: I/O ports at 1840 [size=32]
        Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20)
        Subsystem: Fujitsu Limited. Device 1415
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 23
        Region 0: Memory at fc704800 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
        Subsystem: Fujitsu Limited. Device 142d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at fc700000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [130] Root Complex Link <?>
        Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=04, subordinate=07, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: fc200000-fc2fffff
        Prefetchable memory behind bridge: 00000000a8000000-00000000a80fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
                        Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
                Address: fee0100c  Data: 41b1
        Capabilities: [90] Subsystem: Fujitsu Limited. Device 1416
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 (rev 03)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=14, subordinate=1b, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fc300000-fc3fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
                        Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
                Address: fee0100c  Data: 41b9
        Capabilities: [90] Subsystem: Fujitsu Limited. Device 1416
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
        Subsystem: Fujitsu Limited. Device 1414
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 22
        Region 4: I/O ports at 1860 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
        Subsystem: Fujitsu Limited. Device 1414
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 22
        Region 4: I/O ports at 1880 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20)
        Subsystem: Fujitsu Limited. Device 1415
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 23
        Region 0: Memory at fc704c00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) (prog-if 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=1c, subordinate=20, sec-latency=32
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: fc400000-fc4fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Subsystem: Fujitsu Limited. Device 140c

00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
        Subsystem: Fujitsu Limited. Device 140e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information <?>

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
        Subsystem: Fujitsu Limited. Device 140f
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 1810 [size=16]
        Kernel driver in use: ata_piix

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03) (prog-if 01)
        Subsystem: Fujitsu Limited. Device 1411
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 220
        Region 0: I/O ports at 18e0 [size=8]
        Region 1: I/O ports at 18b4 [size=4]
        Region 2: I/O ports at 18b8 [size=8]
        Region 3: I/O ports at 18b0 [size=4]
        Region 4: I/O ports at 18c0 [size=32]
        Region 5: Memory at fc704000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/2 Enable+
                Address: fee0100c  Data: 41d1
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] SATA HBA <?>
        Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
        Subsystem: Fujitsu Limited. Device 1413
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 21
        Region 0: Memory at a8100000 (32-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at 1c00 [size=32]
        Kernel driver in use: i801_smbus

04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8055 PCI-E Gigabit Ethernet Controller (rev 14)
        Subsystem: Fujitsu Limited. Device 139a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 221
        Region 0: Memory at fc200000 (64-bit, non-prefetchable) [size=16K]
        Region 2: I/O ports at 2000 [size=256]
        [virtual] Expansion ROM at a8000000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Vital Product Data <?>
        Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
                Address: 00000000fee0100c  Data: 41c1
        Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 unlimited
                        ClockPM+ Suprise- LLActRep- BwNot-
                LnkCtl: ASPM L0s Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting <?>
        Kernel driver in use: sky2

14:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)
        Subsystem: Intel Corporation Device 1100
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 219
        Region 0: Memory at fc300000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [c8] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
                Address: 00000000fee0300c  Data: 4138
        Capabilities: [e0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
                        ClockPM+ Suprise- LLActRep- BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [140] Device Serial Number 97-62-84-ff-ff-3b-1f-00
        Kernel driver in use: iwl4965

1c:03.0 CardBus bridge: O2 Micro, Inc. OZ711SP1 Memory CardBus Controller (rev 01)
        Subsystem: Fujitsu Limited. Device 143d
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fc402000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=1c, secondary=1d, subordinate=20, sec-latency=176
        Memory window 0: a8400000-a87ff000 (prefetchable)
        Memory window 1: ac000000-affff000
        I/O window 0: 00003000-000030ff
        I/O window 1: 00003400-000034ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001
        Kernel driver in use: yenta_cardbus

1c:03.2 SD Host controller: O2 Micro, Inc. Integrated MMC/SD Controller (rev 02) (prog-if 01)
        Subsystem: Fujitsu Limited. Device 143d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fc401800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci

1c:03.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02) (prog-if 10)
        Subsystem: Fujitsu Limited. Device 143e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fc400000 (32-bit, non-prefetchable) [size=4K]
        Region 1: Memory at fc401000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+
        Kernel driver in use: ohci1394



-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
