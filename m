Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZKWLLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZKWLLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbZKWLLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:11:05 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:34829 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756489AbZKWLLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:11:04 -0500
Message-ID: <4B0A6DCA.70805@internode.on.net>
Date: Mon, 23 Nov 2009 21:41:06 +1030
From: indexer <indexer@internode.on.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 14658] Regression in efi.c
References: <bug-14658-6666@http.bugzilla.kernel.org/> <200911212017.nALKHLSC029634@demeter.kernel.org> <alpine.LFD.2.00.0911221817200.24119@localhost.localdomain> <4B09F685.2080201@internode.on.net> <alpine.LFD.2.00.0911231034090.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911231034090.24119@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 23 Nov 2009, indexer wrote:
>   
>>> while the bisect should have be done with
>>>
>>> good 2.6.30
>>> bad  2.6.31
>>>
>>> William, could you please go through the bisect pain again?
>>>
>>>       
>> I had already done a similar bisect to this in private conversation to Huang
>> Ying, and is what prompted me to expand my bisect out. I redid it regardless
>> and will send you the information.
>>
>> commit 74fca6a42863ffacaf7ba6f1936a9f228950f657
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Wed Sep 9 15:13:59 2009 -0700
>>
>>    Linux 2.6.31
>>
>> Makefile |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>     
>
> So you are saying that 
>  
>   
>> # good: [7135a71b19be1faf48b7148d77844d03bc0717d6] aoe: allocate unused
>> request_queue for sysfs
>> git bisect good 7135a71b19be1faf48b7148d77844d03bc0717d6
>>     
>
> which is the last code changing commit before the 2.6.31 release is
> booting fine, but with the release commit which merily changes the
> Makefile it is not ?
>   
I dont know, I will test this as soon as possible. I might change the 
bisect parameters a bit, but really im quite new to all this. It may 
also be a possibility it is gen-patches breaking it as i reported 
2.6.30-gentoo was the broken kernel. Either way, the fact remains that 
on 2.6.31 and higher vanilla it is broken.
>   
>> PS - The fact remains i still cant efi boot in 2.6.32-rc7, so this bug still
>> exists, and I will keep doing what i can to help track this down.
>>     
>
> Sure, but I hope we agree that it does not make much sense to search
> 2.6.31..now when we already know that 2.6.31 is not booting and the
> change which causes the problem is between 2.6.30 and 2.6.31.
>
> Thanks,
>
> 	tglx
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
 Oh i have no issues agreeing with you, but its really confusing me, and 
i of course may have made an error in what i reported. I am after all 
only human, and i might have made a mistake, and this is the first time 
i have ever submitted a bug, let alone found one like this. The end 
product is that 2.6.32 doesn't boot, but maybe the last working version 
was not 2.6.30-rc8, maybe it was a 2.6.31 kernel. I might redo the 
bisect and try this out again, as i'm quite intent on finding the source 
of this. I will also see if i can get my hands on another x86_64 linux 
install with efi to test it on a different machine to see if it is 
hardware specific to my computer. For the record i am running a late 
2009 macbook pro gen 5 rev 3, efi version 1.7 with refit and elilo.

William
