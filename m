Return-Path: <linux-kernel-owner+w=401wt.eu-S1761479AbYCYWCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479AbYCYWCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761277AbYCYWCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:02:39 -0400
Received: from www17.your-server.de ([213.133.104.17]:36657 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761237AbYCYWCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:02:37 -0400
Message-ID: <47E97667.1080603@m3y3r.de>
Date: Tue, 25 Mar 2008 23:02:15 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080310)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu> <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu> <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de> <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds schrieb:
> On Tue, 25 Mar 2008, Thomas Meyer wrote:
>   
>> and compare lspci -vv from 2.6.25 and 2.6.24:
>>
>> 2.6.25:
>>
>>    Region 0: [virtual] Memory at 100000000 (32-bit, non-prefetchable) [size=4K]
>>
>> 2.6.24:
>>
>>    Region 0: Memory at 8c000000 (32-bit, non-prefetchable) [size=4K]
>>     
>
> Ok, so it didn't use to be at the 4GB mark.
>
> This seems to be a PCI and resource alloc issue. It would be really 
> interesting to see where the 4GB allocation started. Ie ignore anything 
> else (warnings, driver loadings etc), and _just_ look at lspci -vv output 
> for where the memory got allocated.
>
> Did you already bisect that and I just missed it?
>   
I didn't bisect this.But  I recompiled with CONFIG_RESOURCES_64BIT 
*unset* and everything is fine now, i.e. no error occurs anymore.

lspci -vv output:
0c:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 61) (prog-if 10 
[OHCI])
        Subsystem: Agere Systems FW323
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B+ DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 248 (3000ns min, 6000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at 94406000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+
        Kernel driver in use: ohci1394
        Kernel modules: firewire-ohci, ohci1394

This is on ingo's git tree (branch: x86-latest) (commit 
0fef904c33841be92f5ebdbdb9339dd11a133c92 - x86: ioremap of 64-bit 
resource on 32-bit kernel fix)

mfg
thomas
