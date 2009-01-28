Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZA1VPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZA1VPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZA1VPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:15:08 -0500
Received: from n3.bullet.mail.re3.yahoo.com ([68.142.237.110]:37764 "HELO
	n3.bullet.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753656AbZA1VPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:15:04 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 1504.96952.bm@omp110.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=OIdgbi0e0gysZf8SxujCrPRkHF/H/mTGbhp3uhzVX9K1+hDXBwECNbge7wJJozK25ciYWFyc1XzNLdXm0RMp7wVm1szTUOA/oTY7s2rSMEVG/XXxSXsOx0RdMgok0/0lp51LB9//IspBFDoeX4ajnTAYdLuB8lMKRIhoppqIZHw=;
X-YMail-OSG: hWslnDQVM1mvh3cKQKVCXJKHtBUzZ9tlT9R0mw2l7YwzmkAqgbRklCtPKkZ6638fOIdZtYpsk_E9kv2mw7S4MGKfybxmXFWLruByig_PUo_WK5pVlWanb6qJtODgUlGRMEc9GqQLLKeKNxkrKAPP3l69N56i
X-Mailer: YahooMailWebService/0.7.260.1
Date: Wed, 28 Jan 2009 13:14:59 -0800 (PST)
From: Andrew Watts <akwatts@ymail.com>
Reply-To: akwatts@ymail.com
Subject: Thermal problems with newer kernels
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <863288.78002.qm@web111002.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kernel Gurus:

Below is a problem that I am unable to explain along with relevant(?) info. Please let me know if I should provide additional debugging information. Thanks in advance for your assistance!

-Andy

[1] Problem: HP Pavilion zv5000 laptop idle temp is 17 degrees higher when running most recent kernels (57C versus 40C).

[2] Brief Description

Newer kernels (noticed starting with 2.6.27.3 but could have started anytime past 2.6.26.7) result in a much higher idle CPU temp. Physical temperature reading of exhaust from primary cooling fan and the regular triggering of secondary cooling fan confirms this (it is not a readout scaling issue). The kernels and temps below:

2.6.26.7	Idle temp 40C
2.6.27.3	Idle temp 57C
2.6.28	Idle temp 57C

The only third party kernel module installed that is not part of the official kernel source is: madwifi-ng. However, the problem occurs even when this module is not loaded.

The .config file used for the newer kernels was imported from the working 2.6.26.7 .config file. 

[3] Environment (when running the hot 2.6.28 kernel)

[3a] lspci -vvv

00:00.0 Host bridge: ATI Technologies Inc Radeon 9100 IGP Host Bridge (rev 02)
	Subsystem: ATI Technologies Inc Unknown device 1234
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Region 0: Memory at d2000000 (32-bit, prefetchable) [size=32M]
	Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [a0] AGP version 3.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3+ Rate=x4,x8
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
	Kernel driver in use: agpgart-ati
	Kernel modules: ati-agp

00:01.0 PCI bridge: ATI Technologies Inc Radeon 9100 IGP AGP Bridge (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 99
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: d0100000-d01fffff
	Prefetchable memory behind bridge: e0000000-efffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Kernel modules: shpchp

00:13.0 USB Controller: ATI Technologies Inc OHCI USB Controller #1 (rev 01) (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc Unknown device 434c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at d0001000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.1 USB Controller: ATI Technologies Inc OHCI USB Controller #2 (rev 01) (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc Unknown device 434c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at d0002000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:14.0 SMBus: ATI Technologies Inc SMBus (rev 16)
	Subsystem: Hewlett-Packard Company Unknown device 006b
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: I/O ports at 8040 [size=16]
	Region 1: Memory at 98000000 (32-bit, non-prefetchable) [size=1K]
	Kernel driver in use: piix4_smbus
	Kernel modules: i2c-piix4

00:14.1 IDE interface: ATI Technologies Inc Dual Channel Bus Master PCI IDE Controller (prog-if 8a [Master SecP PriP])
	Subsystem: Hewlett-Packard Company Unknown device 006b
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort+ <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 8060 [size=16]
	Kernel driver in use: ATIIXP_IDE
	Kernel modules: pata_atiixp

00:14.3 ISA bridge: ATI Technologies Inc Unknown device 434c
	Subsystem: ATI Technologies Inc Unknown device 434c
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc IXP200 3COM 3C920B Ethernet Controller (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=02, subordinate=07, sec-latency=69
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: d0200000-d02fffff
	Prefetchable memory behind bridge: 90000000-97ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 Multimedia audio controller: ATI Technologies Inc IXP150 AC'97 Audio Controller
	Subsystem: Hewlett-Packard Company Unknown device 006b
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (500ns min), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 5
	Region 0: Memory at d0003000 (32-bit, non-prefetchable) [size=256]
	Kernel driver in use: ATI IXP AC97 controller
	Kernel modules: snd-atiixp

00:14.6 Modem: ATI Technologies Inc IXP AC'97 Modem (rev 01) (prog-if 00 [Generic])
	Subsystem: Hewlett-Packard Company Unknown device 006b
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 5
	Region 0: Memory at d0003400 (32-bit, non-prefetchable) [size=256]
	Kernel modules: snd-atiixp-modem

01:05.0 VGA compatible controller: ATI Technologies Inc RS300M AGP [Radeon Mobility 9100IGP] (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Unknown device 006b
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B+ DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 66 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at 9000 [size=256]
	Region 2: Memory at d0100000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at d0120000 [disabled] [size=128K]
	Capabilities: [58] AGP version 3.0
		Status: RQ=256 Iso- ArqSz=0 Cal=7 SBA+ ITACoh- GART64- HTrans- 64bit+ FW+ AGP3+ Rate=x4,x8
		Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: radeonfb

02:00.0 FireWire (IEEE 1394): Texas Instruments TSB43AB21 IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Unknown device 006b
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (500ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d0208000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at d0200000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ohci1394
	Kernel modules: ohci1394

02:02.0 Network controller: Broadcom Corporation BCM4306 802.11b/g Wireless LAN Controller (rev 03)
	Subsystem: Hewlett-Packard Company NX9500 Built-in Wireless
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at d0204000 (32-bit, non-prefetchable) [size=8K]
	Kernel driver in use: b43-pci-bridge
	Kernel modules: ssb

02:03.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Hewlett-Packard Company Unknown device 006b
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at a000 [size=256]
	Region 1: Memory at d0208800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: 8139too
	Kernel modules: 8139cp, 8139too

02:04.0 CardBus bridge: Texas Instruments PCI1620 PC Card Controller (rev 01)
	Subsystem: Hewlett-Packard Company Unknown device 006b
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at d0209000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=03, subordinate=03, sec-latency=176
	Memory window 0: 90000000-93fff000 (prefetchable)
	Memory window 1: 9c000000-9ffff000
	I/O window 0: 0000a800-0000a8ff
	I/O window 1: 0000ac00-0000acff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

02:04.1 CardBus bridge: Texas Instruments PCI1620 PC Card Controller (rev 01)
	Subsystem: Hewlett-Packard Company Unknown device 006b
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 16
	Region 0: Memory at d020a000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=04, subordinate=07, sec-latency=176
	Memory window 0: 94000000-97fff000 (prefetchable)
	Memory window 1: a0000000-a3fff000
	I/O window 0: 00001400-000014ff
	I/O window 1: 00001800-000018ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

02:04.2 System peripheral: Texas Instruments PCI1620 Firmware Loading Function (rev 01)
	Subsystem: Hewlett-Packard Company Unknown device 006b
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
	Region 0: I/O ports at a400 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:07.0 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
	Subsystem: NEC Corporation Hama USB 2.0 CardBus
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (250ns min, 10500ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d0206000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

02:07.1 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
	Subsystem: NEC Corporation Hama USB 2.0 CardBus
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (250ns min, 10500ns max), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 18
	Region 0: Memory at d0207000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

02:07.2 USB Controller: NEC Corporation USB 2.0 (rev 04) (prog-if 20 [EHCI])
	Subsystem: NEC Corporation USB 2.0
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (4000ns min, 8500ns max), Cache Line Size: 128 bytes
	Interrupt: pin C routed to IRQ 19
	Region 0: Memory at d0208c00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

03:00.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213 Multiprotocol MAC/baseband processor (rev 01)
	Subsystem: Atheros Communications Inc. EZ Connect g 802.11g 108Mbps Wireless PCI Adapter
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at 9c000000 (32-bit, non-prefetchable) [disabled] [size=64K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
	Kernel modules: ath_pci

[3b] /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 2.66GHz
stepping        : 9
cpu MHz         : 2666.859
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips        : 5336.38
clflush size    : 64
power management:

[3c] /proc/ioports

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:14.1
  0170-0177 : atiixp
01f0-01f7 : 0000:00:14.1
  01f0-01f7 : atiixp
0200-020f : pnp 00:07
0376-0376 : 0000:00:14.1
  0376-0376 : atiixp
0378-037a : parport0
037b-037f : parport0
03c0-03df : vesafb
03f6-03f6 : 0000:00:14.1
  03f6-03f6 : atiixp
0c14-0c14 : pnp 00:07
0c50-0c52 : pnp 00:07
0c6c-0c6c : pnp 00:07
0c6f-0c6f : pnp 00:07
0cd6-0cd7 : pnp 00:07
0cf8-0cff : PCI conf1
1080-1080 : pnp 00:07
1400-14ff : PCI CardBus 0000:04
1800-18ff : PCI CardBus 0000:04
8000-803f : pnp 00:07
  8000-8003 : ACPI PM1a_EVT_BLK
  8004-8005 : ACPI PM1a_CNT_BLK
  8008-800b : ACPI PM_TMR
  8010-8015 : ACPI CPU throttle
  8020-8027 : ACPI GPE0_BLK
8040-804f : 0000:00:14.0
  8040-8047 : piix4_smbus
8050-8050 : ACPI PM2_CNT_BLK
8060-806f : 0000:00:14.1
  8060-806f : atiixp
8800-8800 : pnp 00:07
9000-9fff : PCI Bus 0000:01
  9000-90ff : 0000:01:05.0
a000-afff : PCI Bus 0000:02
  a000-a0ff : 0000:02:03.0
    a000-a0ff : 8139too
  a400-a43f : 0000:02:04.2
  a800-a8ff : PCI CardBus 0000:03
  ac00-acff : PCI CardBus 0000:03
fe00-fe00 : pnp 00:07
fe10-fe11 : pnp 00:07

[3d] /proc/iomem

00000000-00000fff : System RAM
00001000-0000ffff : reserved
00010000-000907ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cefff : Video ROM
000d0000-000d7fff : reserved
  000d6000-000d6fff : Adapter ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-77f6ffff : System RAM
  00100000-00396ac1 : Kernel code
  00396ac2-004e66fb : Kernel data
  00539000-00573677 : Kernel bss
77f70000-77f7cfff : ACPI Tables
77f7d000-77f7ffff : ACPI Non-volatile Storage
77f80000-77ffffff : reserved
87f80000-87ffffff : reserved
90000000-97ffffff : PCI Bus 0000:02
  90000000-93ffffff : PCI CardBus 0000:03
  94000000-97ffffff : PCI CardBus 0000:04
98000000-980003ff : 0000:00:14.0
9c000000-9fffffff : PCI CardBus 0000:03
  9c000000-9c00ffff : 0000:03:00.0
a0000000-a3ffffff : PCI CardBus 0000:04
d0000000-d0000fff : 0000:00:00.0
  d0000000-d0000fff : pnp 00:07
d0001000-d0001fff : 0000:00:13.0
  d0001000-d0001fff : ohci_hcd
d0002000-d0002fff : 0000:00:13.1
  d0002000-d0002fff : ohci_hcd
d0003000-d00030ff : 0000:00:14.5
  d0003000-d00030ff : ATI IXP AC97
d0003400-d00034ff : 0000:00:14.6
d0100000-d01fffff : PCI Bus 0000:01
  d0100000-d010ffff : 0000:01:05.0
  d0120000-d013ffff : 0000:01:05.0
d0200000-d02fffff : PCI Bus 0000:02
  d0200000-d0203fff : 0000:02:00.0
  d0204000-d0205fff : 0000:02:02.0
    d0204000-d0205fff : 0000:02:02.0
  d0206000-d0206fff : 0000:02:07.0
    d0206000-d0206fff : ohci_hcd
  d0207000-d0207fff : 0000:02:07.1
    d0207000-d0207fff : ohci_hcd
  d0208000-d02087ff : 0000:02:00.0
    d0208000-d02087ff : ohci1394
  d0208800-d02088ff : 0000:02:03.0
    d0208800-d02088ff : 8139too
  d0208c00-d0208cff : 0000:02:07.2
    d0208c00-d0208cff : ehci_hcd
  d0209000-d0209fff : 0000:02:04.0
    d0209000-d0209fff : yenta_socket
  d020a000-d020afff : 0000:02:04.1
    d020a000-d020afff : yenta_socket
d2000000-d3ffffff : 0000:00:00.0
e0000000-efffffff : PCI Bus 0000:01
  e0000000-efffffff : 0000:01:05.0
    e0000000-e7ffffff : vesafb
fec00000-fec0ffff : reserved
  fec00000-fec00fff : IOAPIC 0
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
fff80000-ffffffff : reserved
  fff80000-ffffffff : pnp 00:07

[3e] /proc/modules

radeon 140064 2 - Live 0xf857c000
drm 74656 3 radeon, Live 0xf84e2000
fan 4228 0 - Live 0xf89f8000
xt_multiport 2944 2 - Live 0xf8750000
ipt_LOG 5504 9 - Live 0xf8578000
xt_state 1920 62 - Live 0xf8564000
xt_limit 1920 1 - Live 0xf8549000
xt_tcpudp 2816 59 - Live 0xf8537000
iptable_filter 2560 1 - Live 0xf84df000
ip_tables 10000 1 iptable_filter, Live 0xf84d3000
x_tables 11780 6 xt_multiport,ipt_LOG,xt_state,xt_limit,xt_tcpudp,ip_tables, Live 0xf84c5000
nf_conntrack_tftp 3988 0 - Live 0xf84b9000
nf_conntrack_ftp 6944 0 - Live 0xf84ae000
nf_conntrack_ipv4 12044 62 - Live 0xf84a1000
nf_conntrack 51648 4 xt_state,nf_conntrack_tftp,nf_conntrack_ftp,nf_conntrack_ipv4, Live 0xf8440000
nf_defrag_ipv4 1664 1 nf_conntrack_ipv4, Live 0xf843a000
snd_seq_dummy 2692 0 - Live 0xf8431000
snd_seq_oss 26112 0 - Live 0xf8424000
snd_seq_midi_event 5632 1 snd_seq_oss, Live 0xf837d000
snd_seq 39376 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live 0xf840d000
snd_seq_device 6028 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live 0xf82df000
snd_pcm_oss 34208 0 - Live 0xf833a000
snd_mixer_oss 13184 1 snd_pcm_oss, Live 0xf8328000
ipv6 215732 12 - Live 0xf844e000
sg 22704 0 - Live 0xf839b000
lp 9252 0 - Live 0xf82a1000
fuse 45084 1 - Live 0xf83ff000
usb_storage 85696 0 - Live 0xf8362000
rtc_cmos 9132 0 - Live 0xf8320000
rtc_core 13720 1 rtc_cmos, Live 0xf82f6000
rtc_lib 2432 1 rtc_core, Live 0xf807e000
ehci_hcd 31372 0 - Live 0xf82ec000
yenta_socket 22796 3 - Live 0xf828c000
rsrc_nonstatic 10240 1 yenta_socket, Live 0xf827e000
8139too 21760 0 - Live 0xf806d000
mii 4352 1 8139too, Live 0xf8043000
ohci1394 27952 0 - Live 0xf83a6000
snd_atiixp 14348 2 - Live 0xf804b000
snd_ac97_codec 93604 1 snd_atiixp, Live 0xf8382000
ieee1394 71484 1 ohci1394, Live 0xf834e000
psmouse 39184 0 - Live 0xf82d3000
ac97_bus 1536 1 snd_ac97_codec, Live 0xf82c5000
serio_raw 4868 0 - Live 0xf827a000
snd_pcm 60040 3 snd_pcm_oss,snd_atiixp,snd_ac97_codec, Live 0xf8305000
snd_timer 17156 2 snd_seq,snd_pcm, Live 0xf8262000
snd 42532 13 snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_atiixp,snd_ac97_codec,snd_pcm,snd_timer, Live 0xf82af000
snd_page_alloc 7816 2 snd_atiixp,snd_pcm, Live 0xf8050000
i2c_piix4 9104 0 - Live 0xf8032000
ohci_hcd 22672 0 - Live 0xf8076000
i2c_core 19344 1 i2c_piix4, Live 0xf8027000
ssb 34436 1 ohci_hcd, Live 0xf8315000
pcmcia 30572 1 ssb, Live 0xf82fb000
pcmcia_core 29840 4 yenta_socket,rsrc_nonstatic,ssb,pcmcia, Live 0xf82e2000
battery 9988 0 - Live 0xf82ce000
parport_pc 23716 1 - Live 0xf82bd000
parport 28744 2 lp,parport_pc, Live 0xf82a5000
ac 4100 0 - Live 0xf8293000
video 16528 0 - Live 0xf8285000
output 2560 1 video, Live 0xf8277000
thermal 15132 0 - Live 0xf826a000
processor 33328 1 thermal, Live 0xf8257000
button 5904 0 - Live 0xf8069000
shpchp 30228 0 - Live 0xf805a000
thermal_sys 9376 4 fan,video,thermal,processor, Live 0xf802d000
ati_agp 6540 1 - Live 0xf8047000
agpgart 27312 2 drm,ati_agp, Live 0xf8036000
evdev 8480 5 - Live 0xf801e000



      

