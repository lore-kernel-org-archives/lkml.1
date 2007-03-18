Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbXCRB3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbXCRB3E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 21:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbXCRB2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 21:28:40 -0400
Received: from mail.tmr.com ([64.65.253.246]:41968 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbXCRB0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 21:26:22 -0400
Message-ID: <45FC9624.5080905@tmr.com>
Date: Sat, 17 Mar 2007 20:30:12 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.ck
To: Con Kolivas <kernel@kolivas.org>
CC: Al Boldi <a1426z@gawab.com>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
 scheduler
References: <200703042335.26785.a1426z@gawab.com> <200703121553.30462.kernel@kolivas.org> <200703121426.00854.a1426z@gawab.com> <200703122352.51257.kernel@kolivas.org>
In-Reply-To: <200703122352.51257.kernel@kolivas.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Monday 12 March 2007 22:26, Al Boldi wrote:
>> Con Kolivas wrote:
>>> On Monday 12 March 2007 15:42, Al Boldi wrote:
>>>> Con Kolivas wrote:
>>>>> On Monday 12 March 2007 08:52, Con Kolivas wrote:
>>>>>> And thank you! I think I know what's going on now. I think each
>>>>>> rotation is followed by another rotation before the higher priority
>>>>>> task is getting a look in in schedule() to even get quota and add
>>>>>> it to the runqueue quota. I'll try a simple change to see if that
>>>>>> helps. Patch coming up shortly.
>>>>> Can you try the following patch and see if it helps. There's also one
>>>>> minor preemption logic fix in there that I'm planning on including.
>>>>> Thanks!
>>>> Applied on top of v0.28 mainline, and there is no difference.
>>>>
>>>> What's it look like on your machine?
>>> The higher priority one always get 6-7ms whereas the lower priority one
>>> runs 6-7ms and then one larger perfectly bound expiration amount.
>>> Basically exactly as I'd expect. The higher priority task gets precisely
>>> RR_INTERVAL maximum latency whereas the lower priority task gets
>>> RR_INTERVAL min and full expiration (according to the virtual deadline)
>>> as a maximum. That's exactly how I intend it to work. Yes I realise that
>>> the max latency ends up being longer intermittently on the niced task but
>>> that's -in my opinion- perfectly fine as a compromise to ensure the nice
>>> 0 one always gets low latency.
>> I think, it should be possible to spread this max expiration latency across
>> the rotation, should it not?
> 
> There is a way that I toyed with of creating maps of slots to use for each 
> different priority, but it broke the O(1) nature of the virtual deadline 
> management. Minimising algorithmic complexity seemed more important to 
> maintain than getting slightly better latency spreads for niced tasks. It 
> also appeared to be less cache friendly in design. I could certainly try and 
> implement it but how much importance are we to place on latency of niced 
> tasks? Are you aware of any usage scenario where latency sensitive tasks are 
> ever significantly niced in the real world?
> 
It depends on how you reconcile "completely fair" and "order of 
magnitude blips in latency." It looks (from the results, not the code) 
as if nice is implemented by round-robin scheduling followed by once in 
a while just not giving the CPU to the nice task for a while. Given the 
smooth nature of the performance otherwise, it's more obvious than if 
you weren't doing such a good job most of the time.

Ugly stands out more on something beautiful!

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
