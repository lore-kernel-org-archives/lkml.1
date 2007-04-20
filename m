Return-Path: <linux-kernel-owner+w=401wt.eu-S1767252AbXDTUhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767252AbXDTUhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767261AbXDTUhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:37:08 -0400
Received: from mail.tmr.com ([64.65.253.246]:43781 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767252AbXDTUhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:37:06 -0400
Message-ID: <4629244E.60408@tmr.com>
Date: Fri, 20 Apr 2007 16:36:30 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Nick Piggin <npiggin@suse.de>, Peter Williams <pwil3058@bigpond.net.au>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
   Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu>	 <200704151327.13589.kernel@kolivas.org>	 <1176619384.6222.70.camel@Homer.simpson.net>	 <46240F98.3020800@bigpond.net.au>	 <1176776941.6222.21.camel@Homer.simpson.net>	 <20070417034050.GD25513@wotan.suse.de> <1176782489.13059.15.camel@Homer.simpson.net>
In-Reply-To: <1176782489.13059.15.camel@Homer.simpson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Tue, 2007-04-17 at 05:40 +0200, Nick Piggin wrote:
>> On Tue, Apr 17, 2007 at 04:29:01AM +0200, Mike Galbraith wrote:
>  
>>> Yup, and progress _is_ happening now, quite rapidly.
>> Progress as in progress on Ingo's scheduler. I still don't know how we'd
>> decide when to replace the mainline scheduler or with what.
>>
>> I don't think we can say Ingo's is better than the alternatives, can we?
> 
> No, that would require massive performance testing of all alternatives.
> 
>> If there is some kind of bakeoff, then I'd like one of Con's designs to
>> be involved, and mine, and Peter's...
> 
> The trouble with a bakeoff is that it's pretty darn hard to get people
> to test in the first place, and then comes weighting the subjective and
> hard performance numbers.  If they're close in numbers, do you go with
> the one which starts the least flamewars or what?
> 
Here we disagree... I picked a scheduler not by running benchmarks, but 
by running loads which piss me off with the mainline scheduler. And then 
I ran the other schedulers for a while to find the things, normal things 
I do, which resulted in bad behavior. And when I found one which had (so 
far) no such cases I called it my winner, but I haven't tested it under 
server load, so I can't begin to say it's "the best."

What we need is for lots of people to run every scheduler in real life, 
and do "worst case analysis" by finding the cases which cause bad 
behavior. And if there were a way to easily choose another scheduler, 
call it plugable, modular, or Russian Roulette, people who found a worst 
case would report it (aka bitch about it) and try another. But the 
average user is better able to boot with an option like "sched=cfs" (or 
sc, or nick, or ...) than to patch and build a kernel. So if we don't 
get easily switched schedulers people will not test nearly as well.

The best scheduler isn't the one 2% faster than the rest, it's the one 
with the fewest jackpot cases where it sucks. And if the mainline had 
multiple schedulers this testing would get done, authors would get more 
reports and have a better chance of fixing corner cases.

Note that we really need multiple schedulers to make people happy, 
because fairness is not the most desirable behavior on all machines, and 
adding knobs probably isn't the answer. I want a server to degrade 
gently, I want my desktop to show my movie and echo my typing, and if 
that's hard on compiles or the file transfer, so be it. Con doesn't want 
to compromise his goals, I agree but want to have an option if I don't 
share them.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
