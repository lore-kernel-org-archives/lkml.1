Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbXGQSaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbXGQSaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbXGQSaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:30:05 -0400
Received: from opinicus.com ([24.73.193.242]:50419 "EHLO thing2.opinicus.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751961AbXGQSaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:30:04 -0400
Message-ID: <469D0A81.3000001@opinicus.com>
Date: Tue, 17 Jul 2007 14:29:21 -0400
From: William Montgomery <william@opinicus.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com>	<m33azrt5a6.fsf@maximus.localdomain> <46995998.70706@opinicus.com> <m3d4yuczqw.fsf@maximus.localdomain>
In-Reply-To: <m3d4yuczqw.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:

>William Montgomery <william@opinicus.com> writes:
>
>  
>
>>I am using a PCI analyzer and it shows the bus in an idle state after
>>the lockup.  The PCI transactions just prior to the lockup show a
>>couple of interrupts from the card which appear to be handled
>>correctly.  Anything I should be looking for in particular?
>>    
>>
>
>I'd try to check with other machine using "secondary" bus slot.
>BTW: Are you able to analyze the "primary" bus transactions while
>using the card in "secondary" bus? Perhaps there is something
>wrong in front of the motherboard bridge?
>
>  
>
I am able to analyze the primary bus while the using the card in the 
secondary and I see a very interesting thing on lockup - the primary 
side appears to be stuck on a read access to the memory mapped control 
regs of the LAN chip (82559) in what appears to be infinite target 
retries to the same address.  Unfortunately I havent been able to 
capture what occurs just prior to this happening.  This is quite 
different from what I capture on the secondary side; which is an idle bus

I have posted the lspci -vv listing below...

>A broken motherboard may be hard to diagnose, unfortunately.
>
>Can you post something like "lspci -vv" taken on both machines?
>  
>
Here is the lspci -vv on the machine with lockups (edited for brevity):

00:00.0 Host bridge: Intel Corp. 82845G/GL[Brookdale-G]/GE/PE DRAM 
Controller/Ho
        Subsystem: Intel Corp. 82845G/GL[Brookdale-G]/GE/PE DRAM 
Controller/Host
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Step
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort-
        Latency: 0
        Region 0: Memory at f0000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [e4] #09 [1105]
00:1e.0 PCI bridge: Intel Corp. 82801BA/CA/DB/EB/ER Hub interface to PCI 
Bridge (rev 82) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR+
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=03, sec-latency=32
        I/O behind bridge: 00009000-0000afff
        Memory behind bridge: f4000000-f6ffffff
        Prefetchable memory behind bridge: 10000000-103fffff
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-

01:0c.0 PCI bridge: Pericom Semiconductor: Unknown device 8150 (rev 02) 
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, cache line size 08
        Bus: primary=01, secondary=02, subordinate=03, sec-latency=32
        I/O behind bridge: 00009000-00009fff
        Memory behind bridge: f4000000-f5ffffff
        Prefetchable memory behind bridge: 0000000010000000-0000000010300000
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [b0] Slot ID: 0 slots, First-, chassis 00

02:06.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge 
(non-transparent mode) (rev 15) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, cache line size 08
        Bus: primary=02, secondary=03, subordinate=03, sec-latency=32
        I/O behind bridge: 00009000-00009fff
        Memory behind bridge: f4000000-f5ffffff
        Prefetchable memory behind bridge: 0000000010000000-0000000010300000
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] #06 [0080]
        Capabilities: [a0] Vital Product Data03:04.0 Ethernet 
controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 08)
        Subsystem: Intel Corp. EtherExpress PRO/100+ Management Adapter 
with Alert On LAN*
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 14000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f5403000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 9000 [size=64]
        Region 2: Memory at f5000000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at 10000000 [disabled] [size=1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:05.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] 
(rev 08)
        Subsystem: Intel Corp. EtherExpress PRO/100+ Management Adapter 
with Alert On LAN*
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 14000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at f5401000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 9400 [size=64]
        Region 2: Memory at f5100000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at 10100000 [disabled] [size=1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:06.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] 
(rev 08)
        Subsystem: Intel Corp. EtherExpress PRO/100+ Management Adapter 
with Alert On LAN*
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 14000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f5400000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 9800 [size=64]
        Region 2: Memory at f5200000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at 10200000 [disabled] [size=1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:07.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] 
(rev 08)
        Subsystem: Intel Corp. EtherExpress PRO/100+ Management Adapter 
with Alert On LAN*
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 14000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f5402000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 9c00 [size=64]
        Region 2: Memory at f5300000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at 10300000 [disabled] [size=1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

======================





