Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbXKGCGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbXKGCGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbXKGCGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:06:10 -0500
Received: from smtp-12.smtp.ucla.edu ([169.232.46.248]:51649 "EHLO
	smtp-12.smtp.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbXKGCGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:06:09 -0500
X-Greylist: delayed 1369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Nov 2007 21:06:09 EST
Date: Tue, 6 Nov 2007 17:42:51 -0800 (PST)
From: Chris Stromsoe <cbs@cts.ucla.edu>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Adrian Bunk <bunk@kernel.org>, Bill Davidsen <davidsen@tmr.com>,
       James Corey <ploversegg@yahoo.com>, Rob Sims <lkml-z@robsims.com>,
       Kyle Rose <krose@akamai.com>, linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
In-Reply-To: <20071106142320.710ddc29@freepuppy.rosehill>
Message-ID: <Pine.LNX.4.64.0711061713490.10687@potato.cts.ucla.edu>
References: <20070905102230.10b0bdcf@oldman> <782111.42803.qm@web90413.mail.mud.yahoo.com>
 <46E2DF74.7040307@tmr.com> <20070908191132.GD3563@stusta.de>
 <Pine.LNX.4.64.0709090542350.2617@potato.cts.ucla.edu>
 <20071106142320.710ddc29@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Probable-Spam: no
X-Spam-Report: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007, Stephen Hemminger wrote:
> On Sun, 9 Sep 2007 05:54:45 -0700 (PDT)
> Chris Stromsoe <cbs@cts.ucla.edu> wrote:
>
>> On Sat, 8 Sep 2007, Adrian Bunk wrote:
>>> On Sat, Sep 08, 2007 at 01:44:20PM -0400, Bill Davidsen wrote:
>>>
>>>> Haven't tried later kernels, don't intend to, while no network is
>>>> really secure, it not really useful.
>>>
>>> You are a regular reader of linux-kernel, and therefore the sk98lin
>>> removal can hardly be a surprise for you. If you prefer whining over
>>> helping to improve the kernel that's your choice...
>>
>> I've been trying to migrate off sk98lin to skge since earlier this year,
>> without success, starting with 2.6.18 or .19.
>>
>> I have several of these cards in production using the sk98lin driver:
>>
>> fresno:~# lspci -vv -s 02:01
>> 02:01.0 Ethernet controller: SysKonnect SK-9872 Gigabit Ethernet Server Adapter (SK-NET GE-ZX dual link) (rev 11)
>>          Subsystem: SysKonnect SK-9844 Gigabit Ethernet Server Adapter (SK-NET GE-SX dual link)
>>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
>>          Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>>          Latency: 64 (5750ns min, 7750ns max), Cache Line Size: 32 bytes
>>          Interrupt: pin A routed to IRQ 22
>>          Region 0: Memory at febfc000 (32-bit, non-prefetchable) [size=16K]
>>          Region 1: I/O ports at e800 [size=256]
>>          Expansion ROM at febc0000 [disabled] [size=128K]
>>          Capabilities: [48] Power Management version 1
>>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                  Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>>          Capabilities: [50] Vital Product Data
>>
>> They are dual port SX fiber.  Both ports are connected.  If I do this:
>>
>> fresno:~# modprobe skge
>> fresno:~# ip li set eth2 up
>> fresno:~# ip li set eth2 down
>> fresno:~# ip li set eth3 up
>>
>> the system locks up and I have to power cycle it.  The order doesn't
>> matter (if I do eth3 up/down, then eth2 up kills it).
>>
>> I don't have any problems with sk98lin.  This works fine:
>>
>> fresno:~# modprobe sk98lin RlmtMode=DualNet
>> fresno:~# ip li set eth2 up
>> fresno:~# ip li set eth2 down
>> fresno:~# ip li set eth3 up
>> fresno:~# ip li set eth3 down
>>
>>
>> I am more than happy to test various driver changes, and have tried a few
>> suggested patches but nothing has worked so far.  I would like to be using
>> skge instead of sk98lin, but so far haven't had any success.
>
> Please test 2.6.24-rc1 (or -rc2) because there were several fixes for skge
> that made it work correctly for dual port fiber board. The worst bug in skge
> was that it configured the ram buffer incorrectly.
>
> I just submitted these for next 2.6.23.X stable release as well


I tested 2.6.24-rc1.  This series of commands

   fresno:~# modprobe skge
   fresno:~# ip li set eth2 up
   fresno:~# ip li set eth2 down
   fresno:~# ip li set eth3 up

still hard-locks the box in the same place.  Was there anything in the 
-rc2 patch for skge?



-Chris
