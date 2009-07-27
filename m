Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbZG0NfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbZG0NfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZG0NfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:35:21 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:56119 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbZG0NfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:35:21 -0400
Message-ID: <4A6DAD16.7050809@billgatliff.com>
Date: Mon, 27 Jul 2009 08:35:18 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Peter Zijlstra <peterz@infradead.org>, sen wang <wangsen.linux@gmail.com>,
       mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: report a bug about sched_rt
References: <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com> <1248443656.6987.61.camel@twins> <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com> <1248446910.6987.111.camel@twins> <20090724154036.GG27755@shareable.org> <1248451279.6987.138.camel@twins> <20090724233057.GO27755@shareable.org> <4A6A96AB.7030609@billgatliff.com> <20090725224848.GA15260@shareable.org> <4A6BC2FC.7020700@billgatliff.com> <20090726190343.GB12916@shareable.org>
In-Reply-To: <20090726190343.GB12916@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Bill Gatliff wrote:
>   
>> Jamie Lokier wrote:
>>     
>>> I agree with communicting the desire explicitly to the scheduler.
>>>
>>> In the above example, the exact desire is "give me as much CPU as I
>>> ask for, because my hardware servicing will be adversely but
>>> non-fatally affected if you don't, and the amount of CPU needed to
>>> service the hardware cannot be determined in advance, but prevent me
>>>       
>> >from blocking progress in the rest of the system by limiting my
>>     
>>> exclusive ownership of the CPU".
>>>
>>> How do you propose to communicate that to the scheduler, if not by
>>> something rather like RT-bandwidth with downgrading to SCHED_OTHER
>>> when a policy limit is exceeded?
>>>       
>> This is a great real-world problem.  And there's no one-size-fits-all 
>> answer, unfortunately.
>>
>> RT-bandwidth will give you the system behavior you are after, but it's a 
>> pretty blunt instrument.
>>     
>
> I'm under the impression that RT-bandwidth will *not* give the above
> system behaviour, and that is the whole reason for this thread.
>   

I think I misspoke.  What I meant to say is that RT-bandwidth will 
(probably) prevent the hardware handler from eating 100% of the CPU.  
But the system will suffer quite a, um, "discontinuity" when the 
throttling happens.

>   
>> I'd consider putting some throttling in your interrupt handler that 
>> prevents it from running more than a certain amount of calculation per 
>> interrupt event.
>>     
>
> There is no interrupt handler in my specification above...
>   

True.  But in practice, I think such devices are typically 
interrupt-driven at some level.


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

