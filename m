Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXLHQPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXLHQPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 11:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbXLHQP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 11:15:26 -0500
Received: from mail.tmr.com ([64.65.253.246]:45028 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbXLHQPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 11:15:25 -0500
Message-ID: <475AC72B.1070508@tmr.com>
Date: Sat, 08 Dec 2007 11:32:43 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Pavol Cvengros <pavol.cvengros@primeinteractive.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: ICH9 & Core2 Duo - kernel crash
References: <200712041331.24678.pavol.cvengros@primeinteractive.net> <47585879.7010305@tmr.com> <200712070701.55283.pavol.cvengros@primeinteractive.net> <47598E1B.7010907@tmr.com> <47599734.1030505@primeinteractive.net>
In-Reply-To: <47599734.1030505@primeinteractive.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavol Cvengros wrote:
> Bill Davidsen wrote:
>> Pavol Cvengros wrote:
>>> On Thursday 06 December 2007 21:15:53 Bill Davidsen wrote:
>>>  
>>>> Pavol Cvengros wrote:
>>>>   
>>>>> Hello,
>>>>>
>>>>> I am trying LKML to get some help on one linux kernel related 
>>>>> problem.
>>>>> Lately we got a machine with new HW from Intel. CPU is Intel Core2 
>>>>> Duo
>>>>> E6850 3GHz with 2GB of RAM. Motherboard is Intel DG33BU with G33 
>>>>> chipset.
>>>>>
>>>>> After long fight with kernel crashes on different things, we 
>>>>> figured out
>>>>> that if the multicore is disabled in bios, everything is ok and 
>>>>> machine
>>>>> is running good. No kernel crashes no problems, but with one core 
>>>>> only.
>>>>>
>>>>> This small table will maybe explain:
>>>>>
>>>>> Cores   -     kernel   -   state
>>>>>    2  -   nonsmp or smp  - crash
>>>>>    1  -  smp or nonsmp  - ok
>>>>>
>>>>> All crashes have been different (swaper, rcu, irq, init.....) or 
>>>>> we just
>>>>> got internal gcc compiler error while compiling kernel/glibc/.... 
>>>>> and the
>>>>> machine was frozen.
>>>>>
>>>>> Please can somebody advise what to do to identify that problem more
>>>>> precisely. (debug kernel options?)
>>>>>
>>>>> Our immpresion - ICH9 & ICH9R support in kernel is bad... sorry to 
>>>>> say..
>>>>>       
>>>> I have seen unusual memory behavior under heavy load, in the cases 
>>>> I saw
>>>> it was heavy DMA load from multiple SCSI controllers, and one case 
>>>> with
>>>> FFT on the CPU and heavy network load with gigE. Have you run 
>>>> memtest on
>>>> this hardware? Just a thought, but I see people running Linux on that
>>>> chipset, if not that particular board.
>>>>
>>>> A cheap test even if it shows nothing. Of course it could be a CPU 
>>>> cache
>>>> issue in that one CPU, although that's unlikely.
>>>>     
>>>
>>> yes, memtest was running all his tests without problems. The wierd 
>>> thing is that all kernel crashes we have seen were different (as 
>>> stated in original mail)....
>>>
>>>   
>> The problem with memtest, unless I underestimate it, is that it 
>> doesn't use all core and siblings, so it doesn't quite load the 
>> memory system the way regular usage would. Needless to say, if this 
>> does turn out to be a memory loading issue I don't know of any tools 
>> to really test it. I fall back on part swapping, but that only helps 
>> if it's the memory DIMM itself.
>>
>
> right now that machine has 2 x 1GB DDR2 - 800MHz.... do you think I 
> should test the machine with only one DDR? (I hope to put there 4GB 
> all together)
>
Well, odd memory problems are rare, did you look for a BIOS update? It 
could be that the chipset isn't being set properly, and would explain 
why it might work differently with another BIOS. But if there's nothing 
else to try, it won't hurt to see if it works differently with only one DDR.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


