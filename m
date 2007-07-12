Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbXGLMkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbXGLMkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXGLMjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:39:54 -0400
Received: from pool-70-109-119-137.alb.east.verizon.net ([70.109.119.137]:50894
	"EHLO gaimboi.tmr.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754667AbXGLMjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:39:53 -0400
Message-ID: <46962173.2050603@tmr.com>
Date: Thu, 12 Jul 2007 08:41:23 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v19
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu>
In-Reply-To: <20070711205556.GA27266@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Bill Davidsen <davidsen@tmr.com> wrote:
>
>   
>>> I've taken mainline git tree (freshly integrated CFS!) out for a 
>>> multimedia spin.  I tested watching movies and listenign to music in 
>>> the presence of various sleep/burn loads, pure burn loads, and mixed 
>>> loads. All was peachy here.. I saw no frame drops or sound skips or 
>>> other artifacts under any load where the processor could possibly 
>>> meet demand.
>>>       
>> I would agree with preliminary testing, save that if you get a lot of 
>> processes updating the screen at once, there seems to be a notable 
>> case of processes getting no CPU for 100-300ms, followed by a lot of 
>> CPU.
>>
>> I see this clearly with the "glitch1" test with four scrolling xterms 
>> and glxgears, but also watching videos with little busy processes on 
>> the screen. The only version where I never see this in test or with 
>> real use is cfs-v13.
>>     
>
> just as a test, does this go away if you:
>
> 	renice -20 pidof `Xorg`
>
> i.e. is this connected to the way X is scheduled?
>
>   
Partial answer: -10 didn't help with v16, I'll try more boost ASAP, but 
power has been spotty in upstate NY, 20k+ customers with none and the 
rest of us subject to "load shedding" with zero warning, and the test 
machines have UPS but no generator, so I hesitate to use them while 
power is unstable.
> Another thing to check would be whether it goes away if you set the 
> granularity to some really finegrained value:
>
>     echo 0 > /proc/sys/kernel/sched_wakeup_granularity_ns
>     echo 500000 > /proc/sys/kernel/sched_granularity_ns
>
> this really pushes things - but it tests the theory whether this is 
> related to granularity.
>   

Will do, you suggested dropping sched_granularity_ns to 1000000 earlier, 
and that didn't do it, but I didn't change the wakeup, and will test 
these values later today.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

