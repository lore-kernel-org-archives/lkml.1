Return-Path: <linux-kernel-owner+w=401wt.eu-S933852AbXGQSz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbXGQSz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbXGQSzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:55:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:54210 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840AbXGQSzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,547,1175497200"; 
   d="scan'208";a="251600343"
Message-ID: <469D1093.9070801@intel.com>
Date: Tue, 17 Jul 2007 11:55:15 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: William Montgomery <william@opinicus.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com>	<m33azrt5a6.fsf@maximus.localdomain> <46995998.70706@opinicus.com> <m3d4yuczqw.fsf@maximus.localdomain> <469D0A81.3000001@opinicus.com>
In-Reply-To: <469D0A81.3000001@opinicus.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jul 2007 18:55:15.0582 (UTC) FILETIME=[031DB9E0:01C7C8A4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Montgomery wrote:
> Krzysztof Halasa wrote:
> 
>> William Montgomery <william@opinicus.com> writes:
>>
>>  
>>
>>> I am using a PCI analyzer and it shows the bus in an idle state after
>>> the lockup.  The PCI transactions just prior to the lockup show a
>>> couple of interrupts from the card which appear to be handled
>>> correctly.  Anything I should be looking for in particular?
>>>    
>>>
>> I'd try to check with other machine using "secondary" bus slot.
>> BTW: Are you able to analyze the "primary" bus transactions while
>> using the card in "secondary" bus? Perhaps there is something
>> wrong in front of the motherboard bridge?
>>
>>  
>>
> I am able to analyze the primary bus while the using the card in the 
> secondary and I see a very interesting thing on lockup - the primary 
> side appears to be stuck on a read access to the memory mapped control 
> regs of the LAN chip (82559) in what appears to be infinite target 
> retries to the same address.  Unfortunately I havent been able to 
> capture what occurs just prior to this happening.  This is quite 
> different from what I capture on the secondary side; which is an idle bus
> 
> I have posted the lspci -vv listing below...
> 
>> A broken motherboard may be hard to diagnose, unfortunately.
>>
>> Can you post something like "lspci -vv" taken on both machines?
>>  
>>
> Here is the lspci -vv on the machine with lockups (edited for brevity):
> 
> 00:00.0 Host bridge: Intel Corp. 82845G/GL[Brookdale-G]/GE/PE DRAM 
> Controller/Ho
>         Subsystem: Intel Corp. 82845G/GL[Brookdale-G]/GE/PE DRAM 
> Controller/Host
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Step
>         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort-
>         Latency: 0
>         Region 0: Memory at f0000000 (32-bit, prefetchable) [size=64M]
>         Capabilities: [e4] #09 [1105]
> 00:1e.0 PCI bridge: Intel Corp. 82801BA/CA/DB/EB/ER Hub interface to PCI 
> Bridge (rev 82) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR+

PERR+ set... not good - this certainly will cause major issues


Auke
