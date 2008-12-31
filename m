Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYLaRl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYLaRl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbYLaRlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:41:49 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:16826 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYLaRls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:41:48 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=GnT71H-rknH9riOOM8kA:9 a=oLVX-dHF6CIjOHcTqbAA:7 a=SAOJ9bIJnnVRn-r1F8toM7toBQMA:4
Message-ID: <495BAEDC.9080809@shaw.ca>
Date: Wed, 31 Dec 2008 11:41:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: yogeshwar sonawane <yogyas@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCI resource collision message
References: <b681c62b0812302251p195debf5v360e1058de5c18e1@mail.gmail.com> <495B1C94.7040907@shaw.ca> <b681c62b0812310100j3f79de73nf3f24ce5672345b5@mail.gmail.com>
In-Reply-To: <b681c62b0812310100j3f79de73nf3f24ce5672345b5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yogeshwar sonawane wrote:
> Hi Robert,
> 
> Currently card is inserted in PCI slot 06:00.0 & working fine. The
> above said problem is observed very few times like 2 or 3. So, i am
> sending today's lspci -vv output.
> The lspci -vv output follows & it is attached also: -

(snip)

> 
> 06:00.0 Network controller: Centre for Development of Advanced
> Computing: Unknown device 0102
> 	Subsystem: Centre for Development of Advanced Computing: Unknown device 0102
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
> 	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0, Cache Line Size 08
> 	Interrupt: pin A routed to IRQ 114
> 	Region 0: Memory at de000000 (64-bit, non-prefetchable) [size=16M]
> 	Region 2: Memory at d8000000 (64-bit, prefetchable) [size=64M]
> 	Region 4: Memory at dc000000 (64-bit, prefetchable) [size=32M]
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> 	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
> 		Address: 00000000fee02000  Data: 4072
> 	Capabilities: [58] Express Endpoint IRQ 0
> 		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
> 		Device: Latency L0s unlimited, L1 unlimited
> 		Device: AtnBtn- AtnInd- PwrInd-
> 		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> 		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 0
> 		Link: Latency L0s unlimited, L1 unlimited
> 		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
> 		Link: Speed 2.5Gb/s, Width x4
> 	Capabilities: [100] Device Serial Number 00-00-00-00-00-00-00-00

Well, everything seems pretty much fine here.. think we'd really need 
the lspci and dmesg output when the problem actually shows up. I'm not 
sure why the BIOS wouldn't have been able to allocate resources for the 
card only sometimes.. The only thing that seems unusual is that you 
don't often see devices with a 16MB non-prefetchable BAR (the big ones 
are usually prefetchable video RAM from a graphics card), and the 
non-prefetchable and prefetchable regions may have to go into different 
bridge windows.. it could be that is tripping up the BIOS.

> On Wed, Dec 31, 2008 at 12:47 PM, Robert Hancock <hancockr@shaw.ca> wrote:
>> yogeshwar sonawane wrote:
>>> Hi all,
>>>
>>> I have seen the following message in /var/log/messages file :-
>>>
>>> PCI: Device 0000:01:00.0 not available because of resource collisions
>>>
>>> Whenever this msg comes, the PCI card which is present in 0000:01:00.0
>>> is not useful/accessible.
>>> While detection of card, pci_set_master() fails.
>>> But after reboot, that msg goes & card is working fine.
>>>
>>> This card is a Network controller PCI-Express based card.
>>> The above problem comes very rarely & not on all the test nodes. The
>>> situation may be difficult to reproduce.
>>>
>>> So, my question is, what to interpret from the above message ?
>>> PCI bios allocates the PCI resources. So where to look to remove this
>>> error ?
>> Is there something overlapping in the PCI resource allocations? Can you post
>> the lspci -vv output?
>>
