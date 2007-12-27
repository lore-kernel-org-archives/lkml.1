Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbXL0Scy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbXL0Scy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbXL0Scr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:32:47 -0500
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:39470 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbXL0Scq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:32:46 -0500
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: iaL9KxG65sFyH/NRHEm13ZpWIsASIz2sPdozvvFFdQCNetlf
Message-ID: <4773EF5C.8090502@tragetaschen.dyndns.org>
Date: Thu, 27 Dec 2007 19:30:52 +0100
From: Kai Ruhnau <kai@tragetaschen.dyndns.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071122)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no> <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no> <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca>
In-Reply-To: <4773EBB4.2020805@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Linus Torvalds wrote:
>>
>> On Thu, 27 Dec 2007, Jeff Garzik wrote:
>>> 2) [non-minor] hmmmm.
>>>
>>>     [jgarzik@core ~]$ lspci -n | wc -l
>>>     23
>>>
>>> So I would have to perform 23 sysfs twiddles, before I could obtain
>>> a full and
>>> unabridged 'lspci -vvvxxx'?
>>
>> Or you force it on with "pci=mmconfig" or something at boot-time.
>>
>> But yes. The *fact* is that MMCONFIG has not just been globally
>> broken, but broken on a per-device basis. I don't know why (and quite
>> frankly, I doubt anybody does), but the PCI device ID corruption
>> happened only for a specific set of devices.
>>
>> Whether it was a timing issue with particular devices or whether it
>> was a timing issue with some particular bridge (and could affect any
>> devices behind that bridge), who knows... It almost certainly was
>> brought on by a borderline (or broken) northbridge, but it apparently
>> only affected specific devices - which makes me suspect that it
>> wasn't *entirely* due to just the northbridge, and it was a
>> combination of things.
>
> Pointer to such a report? The only single-device problems I'm aware of
> are with some devices within the K8 integrated northbridge, which we
> already handle. Other than that, the only non-global problems I'm aware
> of are devices behind host bridges which can't receive/handle MMCONFIG
> requests, in which case the problem would be bus-wide.

That is my computer here. The moment I do not switch off mmconfig my
graphics and my network card show up with vendor ID 0001

lspci without mmconfig:

00:00.0 Host bridge: ATI Technologies Inc Unknown device 7930
00:02.0 PCI bridge: ATI Technologies Inc Unknown device 7933
00:06.0 PCI bridge: ATI Technologies Inc Unknown device 7936
00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
00:14.0 SMBus: ATI Technologies Inc SB600 SMBus (rev 13)
00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
00:14.2 Audio device: ATI Technologies Inc SB600 Azalia
00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
00:14.4 PCI bridge: ATI Technologies Inc SB600 PCI to PCI Bridge
01:00.0 VGA compatible controller: nVidia Corporation G80 [GeForce 8800
GTS] (rev a2)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E
Gigabit Ethernet Controller (rev 12)
03:02.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23
IEEE-1394a-2000 Controller (PHY/Link)

My network card with enabled mmconfig:

02:00.0 Ethernet controller: Unknown device 0001:4364 (rev 12)
    Subsystem: Micro-Star International Co., Ltd. Unknown device 326c
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 4 bytes
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at fddfc000 (64-bit, non-prefetchable) [size=16K]
    Region 2: I/O ports at ee00 [size=256]
    [virtual] Expansion ROM at fde00000 [disabled] [size=128K]
    Capabilities: [48] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=1 PME-
    Capabilities: [50] Vital Product Data
    Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
        LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0
<256ns, L1 unlimited
            ClockPM+ Suprise- LLActRep- BwNot-
        LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100] Advanced Error Reporting
00: 01 00 64 43 07 00 10 00 12 00 00 02 01 00 00 00
10: 04 c0 df fd 00 00 00 00 01 ee 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 62 14 6c 32
30: 00 00 00 00 48 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 f0 01 00 80 a0 01 01 50 03 fe 00 20 00 13
50: 03 5c 00 80 00 00 00 01 00 00 00 01 05 e0 80 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 82 a8 e8 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 10 00 11 00 c0 8f 00 00 00 20 19 00 11 a4 07 03
f0: 08 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00

hth
Kai

-- 
This signature is left as an exercise for the reader.

