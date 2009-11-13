Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbZKMTYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbZKMTYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbZKMTYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:24:09 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:37572 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756916AbZKMTYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:24:07 -0500
Date: Fri, 13 Nov 2009 19:24:12 +0000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091113192412.GY15157@caffeine.csclub.uwaterloo.ca>
References: <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> <4AF4526B.4060101@zytor.com> <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com> <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca> <4AF886D4.1080108@zytor.com> <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca> <20091112121805.GF1394@ucw.cz> <20091113162301.GU15157@caffeine.csclub.uwaterloo.ca> <20091113165730.0b9b2676@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113165730.0b9b2676@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 04:57:30PM +0000, Alan Cox wrote:
> O> Calling memcpy_toio on the Geode SC1200 on anything larger than 1 byte
> > causes the data to be delivered (at least on the PCI bus) reordered in
> > that very consistent manner.
> 
> Sounds like you or your firmware have the caching and write combining
> misconfigured.

Well I can't wouch for the firmware, and unfortunately without knowing
what address the firmware placed the configuration registers at there
is no way for me to check the settings.

> > The alignment doesn't affect it (I tested that).  Simply doing more than
> > 1 byte at a time with memcpy_toio to the pci device messes up.
> 
> Which usually means some form of write gathering is enabled or something
> thinks the device is write combining on the PCI bus. What does the PCI
> bus and the RCRR MTRR set look like ?

Well there is no /proc/mtrr.

Here is lspci -vvx output.  It is device 01:08.

00:00.0 Host bridge: Cyrix Corporation PCI Master
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
00: 78 10 01 00 07 00 80 22 00 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0e.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd. RT8139
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at f800 [size=256]
        Region 1: Memory at e0000000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: ec 10 39 81 03 00 90 02 10 00 00 02 00 40 00 00
10: 01 f8 00 00 00 00 00 e0 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 ec 10 39 81
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 20 40

00:11.0 PCI bridge: Hint Corp Unknown device 0031 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: e0100000-e01fffff
        Prefetchable memory behind bridge: 00000000c0000000-00000000c03fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] Vital Product Data
00: 88 33 31 00 07 00 b0 02 01 00 04 06 08 40 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 d1 d1 a0 02
20: 10 e0 10 e0 01 c0 31 c0 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 ff 00 00 00

00:12.0 ISA bridge: National Semiconductor Corporation SCx200 Bridge
        Subsystem: National Semiconductor Corporation SCx200 Bridge
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Region 0: I/O ports at 6400 [size=64]
        Region 1: I/O ports at 6600 [size=64]
00: 0b 10 00 05 0f 00 80 02 00 00 01 06 08 00 80 00
10: 01 64 00 00 01 66 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 0b 10 00 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:12.1 Bridge: National Semiconductor Corporation SCx200 SMI
        Subsystem: National Semiconductor Corporation SCx200 SMI
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Region 0: I/O ports at 6000 [size=256]
00: 0b 10 01 05 01 00 80 02 00 00 80 06 00 00 00 00
10: 01 60 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 0b 10 01 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:12.2 IDE interface: National Semiconductor Corporation SCx200 IDE (rev 01) (prog-if 80 [Master])
        Subsystem: National Semiconductor Corporation SCx200 IDE
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at fc00 [size=16]
00: 0b 10 02 05 05 00 80 02 01 80 01 01 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 fc 00 00 00 00 00 00 00 00 00 00 0b 10 02 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:12.3 Multimedia audio controller: National Semiconductor Corporation SCx200 Audio
        Subsystem: National Semiconductor Corporation SCx200 Audio
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at 40011000 (32-bit, non-prefetchable) [size=4K]
00: 0b 10 03 05 06 00 80 02 00 00 01 04 00 00 00 00
10: 00 10 01 40 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 0b 10 03 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:12.4 VGA compatible controller: National Semiconductor Corporation SCx200 Video (rev 01) (prog-if 00 [VGA])
        Subsystem: National Semiconductor Corporation SCx200 Video
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 0
        Region 0: Memory at 40800000 (32-bit, non-prefetchable) [size=4K]
        Region 1: Memory at 40010000 (32-bit, non-prefetchable) [size=4K]
        Region 2: Memory at e0004000 (32-bit, non-prefetchable) [size=4K]
00: 0b 10 04 05 02 00 80 02 01 00 00 03 00 00 00 00
10: 00 00 80 40 00 00 01 40 00 40 00 e0 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 0b 10 04 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 fe 03 00 00

00:12.5 Bridge: National Semiconductor Corporation SCx200 XBus
        Subsystem: National Semiconductor Corporation SCx200 XBus
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Region 0: I/O ports at 6200 [size=64]
00: 0b 10 05 05 03 00 80 02 00 00 80 06 00 00 00 00
10: 01 62 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 0b 10 05 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.0 USB Controller: Compaq Computer Corporation ZFMicro Chipset USB (rev 08) (prog-if 10 [OHCI])
        Subsystem: Compaq Computer Corporation ZFMicro Chipset USB
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (20000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at e0005000 (32-bit, non-prefetchable) [size=4K]
00: 11 0e f8 a0 07 00 80 02 08 10 03 0c 08 00 00 00
10: 00 50 00 e0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 11 0e f8 a0
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 50

01:04.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970 [PCnet32 LANCE] (rev 36)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (6000ns min, 6000ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at dc00 [size=32]
        Region 1: Memory at e0100000 (32-bit, non-prefetchable) [size=32]
        Expansion ROM at c0000000 [disabled] [size=1M]
        Capabilities: [40] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 22 10 00 20 07 00 90 02 36 00 00 02 00 40 00 00
10: 01 dc 00 00 00 00 10 e0 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 ff 40 00 00 00 00 00 00 00 0b 01 18 18

01:05.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970 [PCnet32 LANCE] (rev 36)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (6000ns min, 6000ns max)
        Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at d800 [size=32]
        Region 1: Memory at e0100020 (32-bit, non-prefetchable) [size=32]
        Expansion ROM at c0100000 [disabled] [size=1M]
        Capabilities: [40] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 22 10 00 20 07 00 90 02 36 00 00 02 00 40 00 00
10: 01 d8 00 00 20 00 10 e0 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 ff 40 00 00 00 00 00 00 00 0a 01 18 18

01:06.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970 [PCnet32 LANCE] (rev 36)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at d400 [size=32]
        Region 1: Memory at e0100040 (32-bit, non-prefetchable) [size=32]
        Expansion ROM at c0200000 [disabled] [size=1M]
        Capabilities: [40] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 22 10 00 20 03 00 90 02 36 00 00 02 00 40 00 00
10: 01 d4 00 00 40 00 10 e0 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 ff 40 00 00 00 00 00 00 00 0b 01 18 18

01:07.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970 [PCnet32 LANCE] (rev 36)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at d000 [size=32]
        Region 1: Memory at e0100060 (32-bit, non-prefetchable) [size=32]
        Expansion ROM at c0300000 [disabled] [size=1M]
        Capabilities: [40] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 22 10 00 20 03 00 90 02 36 00 00 02 00 40 00 00
10: 01 d0 00 00 60 00 10 e0 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 ff 40 00 00 00 00 00 00 00 0a 01 18 18

01:08.0 Serial controller: Unknown device 5243:0001 (rev 04) (prog-if 02 [16550])
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at e0100800 (32-bit, non-prefetchable) [size=2K]
00: 43 52 01 00 02 00 80 00 04 02 00 07 00 00 00 00
10: 00 08 10 e0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00

01:09.0 Network controller: Sangoma Technologies Corp. A104u Quad T1/E1 AFT
        Subsystem: Unknown device a013:1400
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (1250ns min, 3750ns max)
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at e0110000 (32-bit, non-prefetchable) [size=64K]
00: 23 19 00 04 06 00 00 02 00 00 80 02 00 40 00 00
10: 00 00 11 e0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 13 a0 00 14
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 05 0f

Anything else I can grab that might give a clue?

-- 
Len Sorensen
