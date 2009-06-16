Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbZFPQ5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbZFPQ5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbZFPQ5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:57:39 -0400
Received: from mail.oxtel.com ([193.200.114.15]:2576 "EHLO oxtel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752307AbZFPQ5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:57:39 -0400
Message-ID: <4A37CF02.5080906@oxtel.com>
Date: Tue, 16 Jun 2009 17:57:38 +0100
From: Chris Pringle <chris.pringle@oxtel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: linux-kernel@vger.kernel.org,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
References: <4A37A503.3030209@oxtel.com>
 <20090616162114.GA5051@loki.buserror.net> <4A37C97A.5050508@oxtel.com>
 <4A37CC72.3060709@freescale.com>
In-Reply-To: <4A37CC72.3060709@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: chris.pringle
X-Server: VPOP3 Enterprise V2.6.0b - Registered
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
>
> Check asm/cputable.h for CPU_FTR_NEED_COHERENT.  Make sure that 
> CONFIG_8260 is one of the #ifdefs that turns that on.  It looks like 
> that was in place by 2.6.26 in arch/powerpc.  I'm not sure what to 
> look for in arch/ppc.
I've just checked that and it's definitely switched on in CPU_FTR_COMMON 
(CONFIG_8260 is also being used).
>
>>> Also make sure that you park the bus on PCI and raise its arbitration
>>> priority, as done at the end of fixup_pci in 
>>> arch/powerpc/boot/cuboot-pq2.c.
>>>   
>> Since this is a reasonably recent kernel,
>
> Not really, there was a fair amount of 82xx work in the mid-2.6.20s. 
> The addition of CPU_FTR_NEED_COHERENT to 82xx was somewhere in that time.
>
> Can you try 2.6.30?
I'll give it a try, but that won't be a quick thing to do - will 
hopefully manage to get that done tomorrow if it patches without too 
many issues. I should point out that we've got the low latency patches 
on this kernel too; I guess it'd be worth trying it without them before 
I move kernels.
>
>> I'd guess that both of these things are correct. I've had a quick 
>> look in that file and there is code in there raising arbitartion 
>> priority and parking the bus.
>
> Just because the code is there doesn't mean you're using it -- are you 
> using cuImage?  Are you using arch/ppc or arch/powerpc?
>
> Typically this would be done by firmware; it's only in cuboot because 
> u-boot wasn't doing it.
Just checked this is being called and it is. We're using arch/powerpc.
>
>
>> Interestingly, I've just turned off cache snooping and the problem 
>> has got much worse. This has surprised me as I thought that part of 
>> the job done by pci_map_sg was to flush the CPU cache
>
> It only flushes the cache on hardware that doesn't do coherent DMA.
>
Ah right - that would explain what we're seeing then... Doh. Thought I 
might have been onto something then. Is there any way to force a cache 
flush? That'd at least prove it was a caching issue if it resolved the 
problem.

Thanks,
Chris

-- 

______________________________
Chris Pringle
Software Engineer

Miranda Technologies Ltd.
Hithercroft Road
Wallingford
Oxfordshire OX10 9DG
UK

Tel. +44 1491 820206
Fax. +44 1491 820001
www.miranda.com

____________________________

Miranda Technologies Limited
Registered in England and Wales CN 02017053
Registered Office: James House, Mere Park, Dedmere Road, Marlow, Bucks, SL7 1FJ
