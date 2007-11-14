Return-Path: <linux-kernel-owner+w=401wt.eu-S1761479AbXKNSOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479AbXKNSOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbXKNSN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:13:59 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60263 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbXKNSN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:13:56 -0500
Date: Wed, 14 Nov 2007 10:13:37 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Alex Chiang <achiang@hp.com>, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114181337.GA6269@us.ibm.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com> <20071113201102.GK17785@parisc-linux.org> <20071113230804.GA14570@us.ibm.com> <20071114144237.GB7523@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114144237.GB7523@ldl.fc.hp.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 07:42:37AM -0700, Alex Chiang wrote:
> Hi Gary,
> 
> * Gary Hade <garyhade@us.ibm.com>:
> > 
> > I am not fundamentally opposed to this new capability but share
> > the same concerns that Greg and others have expressed.  So far,
> > I have only tried the changes on one single node system (IBM
> > x3850) but the below NAK-worthy result supports the idea that
> > the changes need to be well and widely tested.
> 
> Can you send me the lspci -vv and lspci -vt output from this
> machine?

Alex, I added some slot number hints to the below `lspci -vt`
output.

I am still looking at your other message and will have some 
hopefully helpful comments soon.  I did apply all 5 patches,
4 was a typo.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc


Script started on Wed 14 Nov 2007 03:38:14 AM PST
0;root@elm3a9:~[root@elm3a9 ~]# lspci -vt
-+-[0000:19]---00.0-[0000:1a-1d]--+-00.0  Intel Corporation 82571EB Gigabit Ethernet Controller    <- slot 6
 |				  \-00.1  Intel Corporation 82571EB Gigabit Ethernet Controller
 +-[0000:14]---00.0-[0000:15-18]--                                                                 <- slot 5
 +-[0000:0f]---00.0-[0000:10-13]--                                                                 <- slot 4
 +-[0000:0a]---00.0-[0000:0b-0e]----00.0-[0000:0c]----04.0  Adaptec ASC-29320ALP U320              <- slot 3
 +-[0000:06]---00.0  IBM Calgary PCI-X Host Bridge                                                 <- slot 2
 +-[0000:02]-+-00.0  IBM Calgary PCI-X Host Bridge                                                 <- slot 1
 |	     \-01.0  S2io Inc. Xframe II 10Gbps Ethernet
 +-[0000:01]-+-00.0  IBM Calgary PCI-X Host Bridge
 |	     +-01.0  Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet
 |	     +-01.1  Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet
 |	     \-02.0  Adaptec AIC-9410W SAS (Razor ASIC non-RAID)
 \-[0000:00]-+-00.0  IBM Calgary PCI-X Host Bridge
	     +-01.0  ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE]
	     +-03.0  NEC Corporation USB
	     +-03.1  NEC Corporation USB
	     +-03.2  NEC Corporation USB 2.0
	     +-0f.0  Broadcom CSB6 South Bridge
	     +-0f.1  Broadcom CSB6 RAID/IDE Controller
	     \-0f.3  Broadcom GCLE-2 Host Bridge
0;root@elm3a9:~[root@elm3a9 ~]# lspci -vvv
00:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 04)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 240
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=2
		Status: Dev=00:00.0 64bit+ 133MHz+ SCD- USC- DC=bridge DMMRBC=512 DMOST=2 DMCRS=8 RSCEM- 266MHz+ 533MHz-

00:01.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE] (prog-if 00 [VGA])
	Subsystem: IBM IBM eServer xSeries server mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 240 (2000ns min), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at 1800 [size=256]
	Region 2: Memory at f1c00000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at f1c20000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:03.0 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
	Subsystem: NEC Corporation Hama USB 2.0 CardBus
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 240 (250ns min, 10500ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at f1c10000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

00:03.1 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
	Subsystem: NEC Corporation Hama USB 2.0 CardBus
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 240 (250ns min, 10500ns max), Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 20
	Region 0: Memory at f1c11000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:03.2 USB Controller: NEC Corporation USB 2.0 (rev 04) (prog-if 20 [EHCI])
	Subsystem: NEC Corporation USB 2.0
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 240 (4000ns min, 8500ns max), Cache Line Size: 128 bytes
	Interrupt: pin C routed to IRQ 20
	Region 0: Memory at f1c12000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0f.0 Host bridge: Broadcom CSB6 South Bridge (rev a0)
	Subsystem: Broadcom Unknown device 0201
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 240

00:0f.1 IDE interface: Broadcom CSB6 RAID/IDE Controller (rev a0) (prog-if 82 [Master PriP])
	Subsystem: Broadcom Unknown device 0212
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 0700 [size=16]

00:0f.3 ISA bridge: Broadcom GCLE-2 Host Bridge
	Subsystem: Broadcom Unknown device 0230
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

01:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 04)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 240
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=2
		Status: Dev=01:00.0 64bit+ 133MHz+ SCD- USC- DC=bridge DMMRBC=512 DMOST=2 DMCRS=8 RSCEM- 266MHz+ 533MHz-

01:01.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
	Subsystem: IBM Unknown device 02e7
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 240 (16000ns min), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 24
	Region 0: Memory at f1dc0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=2048 OST=1
		Status: Dev=01:01.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-
		Address: 00000000fee00000  Data: 4056

01:01.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
	Subsystem: IBM Unknown device 02e7
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 240 (16000ns min), Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 28
	Region 0: Memory at f1dd0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=1
		Status: Dev=01:01.1 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D3 PME-Enable+ DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-
		Address: 00000000fee00000  Data: 4056

01:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC non-RAID) (rev 08)
	Subsystem: IBM Unknown device 02e7
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 240 (32000ns min, 26750ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 25
	Region 0: Memory at f1d80000 (64-bit, non-prefetchable) [size=256K]
	Region 2: Memory at f0c00000 (64-bit, prefetchable) [size=128K]
	Region 4: I/O ports at 1900 [size=256]
	[virtual] Expansion ROM at f1d00000 [disabled] [size=512K]
	Capabilities: [40] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=4096 OST=8
		Status: Dev=01:02.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=4096 DMOST=8 DMCRS=128 RSCEM- 266MHz- 533MHz-
	Capabilities: [58] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [e0] Message Signalled Interrupts: 64bit+ Queue=0/2 Enable-
		Address: 00000000fee00000  Data: 4055

02:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 04)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 240
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=2
		Status: Dev=02:00.0 64bit+ 133MHz+ SCD- USC- DC=bridge DMMRBC=512 DMOST=2 DMCRS=8 RSCEM- 266MHz+ 533MHz-

02:01.0 Ethernet controller: S2io Inc. Xframe II 10Gbps Ethernet (rev 02)
	Subsystem: S2io Inc. Unknown device 6020
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 240 (63750ns min, 250ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at f0e00000 (64-bit, prefetchable) [size=32K]
	Region 2: Memory at f0d00000 (64-bit, prefetchable) [size=1M]
	Region 4: Memory at f0e08000 (64-bit, prefetchable) [size=2K]
	[virtual] Expansion ROM at f1e00000 [disabled] [size=1M]
	Capabilities: [40] Message Signalled Interrupts: 64bit+ Queue=0/5 Enable-
		Address: 00000000fee00000  Data: 4056
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE+ ERO+ RBC=4096 OST=8
		Status: Dev=02:01.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=4096 DMOST=32 DMCRS=1024 RSCEM- 266MHz+ 533MHz-
	Capabilities: [80] Vital Product Data
	Capabilities: [90] MSI-X: Enable- Mask- TabSize=64
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000400
	Capabilities: [a0] Power Management version 3
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-

06:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 04)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 240
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=2
		Status: Dev=06:00.0 64bit+ 133MHz+ SCD- USC- DC=bridge DMMRBC=512 DMOST=2 DMCRS=8 RSCEM- 266MHz+ 533MHz-

0a:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=0a, secondary=0b, subordinate=0e, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 256 bytes, MaxReadReq 4096 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 0
		Link: Latency L0s <256ns, L1 <2us
		Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
		Slot: AtnBtn- PwrCtrl+ MRL+ AtnInd+ PwrInd+ HotPlug+ Surpise+
		Slot: Number 3, PowerLimit 25.000000
		Slot: Enabled AtnBtn- PwrFlt+ MRL+ PresDet- CmdCplt- HPIrq+
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable+ Non-Fatal+ Fatal+ PME+
	Capabilities: [100] Advanced Error Reporting

0b:00.0 PCI bridge: PLX Technology, Inc. PEX 8114 PCI Express-to-PCI/PCI-X Bridge (rev bc) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Region 0: Memory at f2000000 (32-bit, non-prefetchable) [size=8K]
	Bus: primary=0b, secondary=0c, subordinate=0c, sec-latency=240
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f1f00000-f1ffffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk+ DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 00000000fee00000  Data: 4052
	Capabilities: [58] PCI-X bridge device
		Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
		Status: Dev=0b:00.0 64bit- 133MHz- SCD- USC- SCO+ SRD-
		Upstream: Capacity=16 CommitmentLimit=16
		Downstream: Capacity=16 CommitmentLimit=16
	Capabilities: [68] Express PCI/PCI-X Bridge IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: AtnBtn+ AtnInd+ PwrInd+
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 256 bytes, MaxReadReq 2048 bytes
		Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 0
		Link: Latency L0s <2us, L1 <32us
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
	Capabilities: [100] Device Serial Number df-0e-00-00-01-00-00-00
	Capabilities: [fb4] Advanced Error Reporting
	Capabilities: [138] Power Budgeting
	Capabilities: [148] Virtual Channel

0c:04.0 SCSI storage controller: Adaptec ASC-29320ALP U320 (rev 10)
	Subsystem: Adaptec Unknown device 0045
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 240 (10000ns min, 6250ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 52
	Region 0: I/O ports at 3000 [disabled] [size=256]
	Region 1: Memory at f1f80000 (64-bit, non-prefetchable) [size=8K]
	Region 3: I/O ports at 3100 [disabled] [size=256]
	[virtual] Expansion ROM at f1f00000 [disabled] [size=512K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
		Address: 00000000fee00000  Data: 4052
	Capabilities: [94] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=2048 OST=8
		Status: Dev=0c:04.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=8 DMCRS=64 RSCEM- 266MHz- 533MHz-

0f:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=0f, secondary=10, subordinate=13, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 512 bytes, MaxReadReq 4096 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 1
		Link: Latency L0s <256ns, L1 <2us
		Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
		Slot: AtnBtn- PwrCtrl+ MRL+ AtnInd+ PwrInd+ HotPlug+ Surpise+
		Slot: Number 4, PowerLimit 25.000000
		Slot: Enabled AtnBtn- PwrFlt+ MRL+ PresDet- CmdCplt- HPIrq+
		Slot: AttnInd Off, PwrInd Off, Power+
		Root: Correctable+ Non-Fatal+ Fatal+ PME+
	Capabilities: [100] Advanced Error Reporting

14:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=14, secondary=15, subordinate=18, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 512 bytes, MaxReadReq 4096 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 2
		Link: Latency L0s <256ns, L1 <2us
		Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
		Slot: AtnBtn- PwrCtrl+ MRL+ AtnInd+ PwrInd+ HotPlug+ Surpise+
		Slot: Number 5, PowerLimit 25.000000
		Slot: Enabled AtnBtn- PwrFlt+ MRL+ PresDet- CmdCplt- HPIrq+
		Slot: AttnInd Off, PwrInd Off, Power+
		Root: Correctable+ Non-Fatal+ Fatal+ PME+
	Capabilities: [100] Advanced Error Reporting

19:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=19, secondary=1a, subordinate=1d, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 3
		Link: Latency L0s <256ns, L1 <2us
		Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
		Slot: AtnBtn- PwrCtrl+ MRL+ AtnInd+ PwrInd+ HotPlug+ Surpise+
		Slot: Number 6, PowerLimit 25.000000
		Slot: Enabled AtnBtn- PwrFlt+ MRL+ PresDet- CmdCplt- HPIrq+
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable+ Non-Fatal+ Fatal+ PME+
	Capabilities: [100] Advanced Error Reporting

1a:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
	Subsystem: Intel Corporation PRO/1000 PT Dual Port Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 55
	Region 0: Memory at f2100000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at f2120000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at 1a00 [size=32]
	[virtual] Expansion ROM at f2140000 [disabled] [size=128K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 00000000fee00000  Data: 407b
	Capabilities: [e0] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <64us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 0
		Link: Latency L0s <4us, L1 <64us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number ce-c4-0b-ff-ff-17-15-00

1a:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
	Subsystem: Intel Corporation PRO/1000 PT Dual Port Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 59
	Region 0: Memory at f2160000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at f2180000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at 1a20 [size=32]
	[virtual] Expansion ROM at f21a0000 [disabled] [size=128K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 00000000fee00000  Data: 4083
	Capabilities: [e0] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <64us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 0
		Link: Latency L0s <4us, L1 <64us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number ce-c4-0b-ff-ff-17-15-00

0;root@elm3a9:~[root@elm3a9 ~]# exit
exit

Script done on Wed 14 Nov 2007 03:38:23 AM PST
