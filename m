Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXCRCKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXCRCKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 22:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXCRCKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 22:10:11 -0400
Received: from mail.tmr.com ([64.65.253.246]:42005 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbXCRCKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 22:10:09 -0400
Message-ID: <45FCA051.2080008@tmr.com>
Date: Sat, 17 Mar 2007 21:13:37 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.ck,gmane.linux.kernel
To: Con Kolivas <kernel@kolivas.org>
CC: Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: is RSDL an "unfair" scheduler too?
References: <200703042335.26785.a1426z@gawab.com>	<200703172302.10819.kernel@kolivas.org>	<20070317122831.GA28429@elte.hu> <200703172343.53480.kernel@kolivas.org>
In-Reply-To: <200703172343.53480.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Saturday 17 March 2007 23:28, Ingo Molnar wrote:
>> * Con Kolivas <kernel@kolivas.org> wrote:
>>> We're obviously disagreeing on what heuristics are [...]
>> that could very well be so - it would be helpful if you could provide
>> your own rough definition for the term, so that we can agree on how to
>> call things?
>>
>> [ in any case, there's no rush here, please reply at your own pace, as
>>   your condition allows. I wish you a speedy recovery! ]
>>
>>> You're simply cashing in on the deep pipes that do kernel work for
>>> other tasks. You know very well that I dropped the TASK_NONINTERACTIVE
>>> flag from rsdl which checks that tasks are waiting on pipes and you're
>>> exploiting it.
>> Con, i am not 'cashing in' on anything and i'm not 'exploiting'
>> anything. The TASK_NONINTERACTIVE flag is totally irrelevant to my
>> argument because i was not testing the vanilla scheduler, i was testing
>> RSDL. I could have written this test using plain sockets, because i was
>> testing RSDL's claim of not having heuristics, i was not testing the
>> vanilla scheduler.
>>
>> I have simply replied to this claim of yours:
>>>> Despite the claims to the contrary, RSDL does not have _less_
>>>> heuristics, it does not have _any_. [...]
>> and i showed you a workload under _RSDL_ that clearly shows that RSDL is
>> an unfair scheduler too.
>>
>> my whole point was to counter the myth of 'RSDL has no heuristics'. Of
>> course it has heuristics, which results in unfairness. (If it didnt have
>> any heuristics that tilt the balance of scheduling towards sleep-intense
>> tasks then a default Linux desktop would not be usable at all.)
>>
>> so the decision is _not_ a puristic "do we want to have heuristics or
>> not", the question is a more practical "which heuristics are simpler,
>> which heuristics are more flexible, which heuristics result in better
>> behavior".
>>
>> 	Ingo
> 
> Ok but please look at how it appears from my end (illness aside).
> 
> I spend 3 years just diddling with scheduler code trying my hardest to find a 
> design that fixes a whole swag of problems we still have, and a swag of 
> problems we might get with other fixes.
> 
> You initially said you were pleased with this design.
> 
> ..lots of code, testing, bugfixes and good feedback.
> 
> Then Mike has one testcase that most other users disagree is worthy of being 
> considered a regresssion. You latched onto that and basically called it a 
> showstopper in spite of who knows how many other positive things.
> 
> Then you quickly produce a counter patch designed to kill off RSDL with a 
> config option for mainline.
> 
> Then you boldly announce on LKML "is RSDL an "unfair" scheduler too?" with 
> some test case you whipped up to try and find fault with the design.

No damn it! He's pointing out that you do have heuristics, they are just 
built into the design. And of course he's whipping up test cases, how 
else can anyone help you find corner cases where it behaves in an 
unexpected or undesirable manner?

I think he's trying to help, please stop taking it personally.
> 
> What am I supposed to think? Considering just how many problems I have 
> addressed and tried to correct with RSDL succesfully I'm surprised that 
> despite your enthusiasm for it initially you have spent the rest of the time 
> trying to block it.
> 
> Please, either help me (and I'm in no shape to code at the moment despite what 
> I have done so far), or say you have no intention of including it. I'm 
> risking paralysis just by sitting at the computer right now so I'm dropping 
> the code as is at the moment and will leave it up to your better judgement as 
> to what to do with it.
> 
Actually I think Ingo has tried to help get it in, that's his patch 
offered for CONFIG_SCHED_FAIR, lets people try it and all.

Now for something constructive... by any chance is Mike running KDE 
instead of GNOME? I only had a short time to play because I had to look 
at another problem in 2.6.21-rc3 (nbd not working), so the test machine 
is in use. But it looked as if behavior was not as smooth with KDE. May 
that thought be useful.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
