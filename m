Return-Path: <linux-kernel-owner+w=401wt.eu-S934024AbXC1IjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024AbXC1IjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 04:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934015AbXC1IjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 04:39:00 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:34280 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934014AbXC1Ii6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 04:38:58 -0400
X-Greylist: delayed 57946 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2007 04:38:57 EDT
Message-ID: <460A297A.2030200@free.fr>
Date: Wed, 28 Mar 2007 10:38:18 +0200
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Lee Revell <rlrevell@joe-job.com>, mingo@elte.hu, akpm@osdl.org,
       linux-apps@vger.kernel.org, linux.kernel@free.fr
Subject: Re: 2.6.20.3-rt8 - DMA suffers excessive delay periodically
References: <46094728.40300@free.fr> <75b66ecd0703271341x34463c49w64bdac21a9741355@mail.gmail.com>
In-Reply-To: <75b66ecd0703271341x34463c49w64bdac21a9741355@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050102030609040301070504"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050102030609040301070504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Lee Revell wrote:

> John wrote:
>
>> I'm runnning 2.6.20.3 patched with -rt8 (and glibc 2.3.6).
>> http://people.redhat.com/mingo/realtime-preempt/older/patch-2.6.20-rt8
>>
>> I've written a program to highlight a phenomenon I don't understand.
>>
>> This system includes a PCI board that provides data at ~38 Mbit/s.
>> I request data in lumps of 1316 bytes.
>> In other words, a new request should complete every 277 µs.
>>
>> However, if I time stamp each packet as soon as I receive it, I notice
>> that almost exactly every 2 seconds, the packet is received 30-100
>> microseconds late.
> 
> Sounds like periodic SMM traps.  There's not much you can do about
> them other than to avoid such hardware if you have tight RT
> constraints.  The RTAI people have some code to disable SMM but it
> does not work on all chipsets and may render some of your hardware
> inoperable.

The motherboard is an EBC-2000T.
http://www.adlinktech.com/PD/web/PD_detail.php?pid=213

lspci -vvv output provided as an attachment.

VIA Pro133T chipset:
http://www.via.com.tw/en/products/chipsets/legacy/pro133/
http://www.via.com.tw/en/products/chipsets/legacy/pro133a/

dmesg mentions:
DMI 2.3 present.

Is this related to SMM?

As far as I can tell, the BIOS is Phoenix AwardBIOS v6.00PG.

Would someone know how to disable SMM in this BIOS?

> Is this a laptop?  They are plagued with SMM problems...

No it is an "indutrial" motherboard.
Although I don't know what makes it "industrial".

Regards.

--------------050102030609040301070504
Content-Type: text/plain;
 name="adlink.lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="adlink.lspci"

00:00.0 Host bridge: VIA Technologies, Inc. VT82C693A/694x [Apollo PRO133x] (rev c4)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Latency: 8
        Region 0: Memory at e0000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [a0] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT82C598/694x [Apollo MVP3/Pro133x AGP] (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (rev 40)
        Subsystem: VIA Technologies, Inc. VT82C686/A PCI to ISA Bridge
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if 8a [Master SecP PriP])
        Subsystem: VIA Technologies, Inc. VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
        Region 4: I/O ports at e400 [size=16]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 1a) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, cache line size 08
        Interrupt: pin D routed to IRQ 5
        Region 4: I/O ports at d000 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.4 Bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 40)
        Subsystem: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI]
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin ? routed to IRQ 9
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:08.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 08)
        Subsystem: Intel Corporation EtherExpress PRO/100B (TX)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 14000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at e6401000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at d400 [size=64]
        Region 2: Memory at e6200000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at 20000000 [disabled] [size=1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:09.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 08)
        Subsystem: Intel Corporation EtherExpress PRO/100B (TX)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 14000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at e6400000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at d800 [size=64]
        Region 2: Memory at e6000000 (32-bit, non-prefetchable) [size=1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:0a.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 08)
        Subsystem: Intel Corporation EtherExpress PRO/100B (TX)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 14000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 12
        Region 0: Memory at e6403000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at dc00 [size=64]
        Region 2: Memory at e6100000 (32-bit, non-prefetchable) [size=1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:0b.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27) (prog-if 00 [VGA])
        Subsystem: ATI Technologies Inc Rage XL
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min), cache line size 08
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at e5000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: I/O ports at e000 [size=256]
        Region 2: Memory at e6402000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at 20100000 [disabled] [size=128K]
        Capabilities: [5c] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0d.0 PCI bridge: Intel Corporation 21152 PCI-to-PCI Bridge (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, cache line size 08
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: e6300000-e63fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+

02:0f.0 Multimedia controller: PLX Technology, Inc. Francois
        Subsystem: PHILIPS Business Electronics B.V.: Unknown device d128
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (4000ns min, 6500ns max), cache line size 08
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at e6300000 (32-bit, non-prefetchable) [size=512]
        Region 1: [virtual] I/O ports at c000 [size=256]
        Region 2: Memory at e6301000 (32-bit, non-prefetchable) [size=512]
        Capabilities: [40] Power Management version 1
                Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1+,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [48] #06 [0000]
        Capabilities: [4c] Vital Product Data

--------------050102030609040301070504--
