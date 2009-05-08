Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZEHCgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZEHCgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 22:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZEHCgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:36:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:30292 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbZEHCf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mk8t8tPsFqAdq2gaEbxbvjOwAB9lO45Om8midzpGV5Vl6kfv0zpnZyzs52g5BTjp90
         i8J+O7YWt+jBQZvNC3n2z0jGwKohwhntbeP/aLwS2wmnGaccA0QCag204iNtjWXVnhm0
         jMKN03Z8jl0/Vs04z/mlKA9oe0HK89Uo3mma8=
MIME-Version: 1.0
In-Reply-To: <200904300939.31754.henrik@austad.us>
References: <164c92d827cbee86ba2c5621716309e6@localhost>
	 <200904300939.31754.henrik@austad.us>
Date: Fri, 8 May 2009 11:35:58 +0900
Message-ID: <49b7c2350905071935kbd2aa22v9d39cf41c537c24b@mail.gmail.com>
Subject: Re: SCHED_EDF infos
From: GeunSik Lim <leemgs1@gmail.com>
To: henrik@austad.us
Cc: finarfin@dreamos.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henlik,

Thank you for explanation and your doc(PDF) about SCHED_EDF implementation
 in Linux.

2009/4/30 Henrik Austad <henrik@austad.us>:
> On Wednesday 29. April 2009 23.36.13 finarfin@dreamos.org wrote:
>> Hi,
>> I'm new to this list,
>
> If you're new to Linux, may I suggest kernelnewbies as well? This is not really the place to ask beginners questions, for that, kn is really the place.
>
> And, if you are going to look at rt-tasks, look at linux-rt:
>
>       http://rt.wiki.kernel.org/index.php/Main_Page
>
>> Actually i'm near to BS degree in computer science, and for thesis my
>> Operating System Professor suggested to complete (or begin?) SCHED_EDF for
>> linux.
>
> Se comment at the very end about EDF vs. other policies.
>
> As a first step, I would have evaluated the benefits and limitations of EDF in a multicore environment.
> - What will be the major restrictions?
> - What will be the major improvements? (why should the kernel care about yet another scheduling policy)
> - Are there better ways of doing this? (like pfair)
> - are you going for partitioned, clustered or global edf? (and remember that they all have good and bad sides).
> - why is a global approcah the only way of getting an optimal scheduler, but a horrible approach from a practical point of view?
> - and a lot of other issues that will be apparent once you start looking at this.
>
> I did some work on this last year, you are more than welcome to look at that.
>
>       http://folk.ntnu.no/henrikau/sched/rt_sched_pro.pdf
>

I think so.
How can we approach  EDF implementation like Pfair as a generic solution
for Multicore in Linux?

>> Now i don't know if i'm able to do that, i'm new to linux-kernel
>> development:
>> 1. Someone is already working on that? This task is still available?
>
> I'm working on SCHED_PFAIR :-) Which is a multicore, ratebased deadline driven global scheduling policy where I use the PD^2 rules to solve tie-breaks. In theory, it can reach 100% utilization on all cores without missing deadlines (but in practice you will only get close to 100% as it is not perfect).
>
>> 2. Now there was something implemented about sched_edf?
>
> No, nothing deadline driven is implemented as of yet.
>
>> 3. Into sched-rt-groups.txt there was something that was not very clear (in
>> my opinion):
>
> If you are going to implement something deadline driven and have some sort of deadline guarantees, I'd suggest going for a policy *above* sched_rt and let SCHED_(RR|FIFO) be best effort tasks.
>
>>    The next project will be SCHED_EDF (Earliest Deadline First scheduling)
>> to bring
>>    full deadline scheduling to the linux kernel. Deadline scheduling the
>> above
>>    groups and treating end of the period as a deadline will ensure that
>> they both
>>    get their allocated time.
>
> Are you aware that this is actually very difficult to get right? There are a *lot* of other things going on in the kernel, you will have unexpected latencies etc.
>
>>    Implementing SCHED_EDF might take a while to complete. Priority
>> Inheritance is
>>    the biggest challenge as the current linux PI infrastructure is geared
>> towards
>>    the limited static priority levels 0-139. With deadline scheduling you
>> need to
>>    do deadline inheritance (since priority is inversely proportional to the
>>    deadline delta (deadline - now).
>
> I'd suggest getting the scheduler running first, then look at those problems later. If you spend all your time trying to learn the scheduler and design in every little feature you need, you'll never finish in time.
In fact, I also  don't have perfect know how to solve PI in Multicore.

>
> deadline inversion will be a problem, in fact, whatever you chooose to be the 'key' for picking tasks (priority, niceness, deadlines, wind direction,                  <whatever>), you can pretty much take that and add a -inversion after it. :)
>
>>    Priority inheritance is a different task?
>> 4. In your opinion three months will be sufficient for that task? (yeah
>> probably this seems a silly question, but if working on that take me a too
>> long time i think i have to find another thesis :D i wish to have my degree
>> before the end of this year)
>
> That depends on how much you know about the scheduler. And believe me, it is a *lot* of things to take care of.
>
>> 5. For implement that algorithm the general EDF documentation will be
>> sufficient? There are some special requisites?
>> 6. if you have any suggestion i'll be glad to receive it :)
>
> The problem with EDF is that it is not multicore aware. Sure, you can implement a global EDF and have it move to all cores, but then you're basically stuck at 50% utilization if you want to have any form of deadline handling. Sure there  are ways of increasing this if you make sure that all the deadlines are not a factor of another, that the hyperperiod is sufficiently large etc etc.
>
>> I hope that this mail doesn't sound useless.
>
> No silly questions, just silly answers.
> (well, here *are* silly questions, but they tend to be ignored)
>
>> Thank you,
>> Ivan
>
> Henrik
>



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
