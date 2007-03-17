Return-Path: <linux-kernel-owner+w=401wt.eu-S933724AbXCQMoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724AbXCQMoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 08:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933807AbXCQMoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 08:44:24 -0400
Received: from mail21.syd.optusnet.com.au ([211.29.133.158]:60755 "EHLO
	mail21.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933724AbXCQMoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 08:44:23 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: is RSDL an "unfair" scheduler too?
Date: Sat, 17 Mar 2007 23:43:53 +1100
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703042335.26785.a1426z@gawab.com> <200703172302.10819.kernel@kolivas.org> <20070317122831.GA28429@elte.hu>
In-Reply-To: <20070317122831.GA28429@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703172343.53480.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 23:28, Ingo Molnar wrote:
> * Con Kolivas <kernel@kolivas.org> wrote:
> > We're obviously disagreeing on what heuristics are [...]
>
> that could very well be so - it would be helpful if you could provide
> your own rough definition for the term, so that we can agree on how to
> call things?
>
> [ in any case, there's no rush here, please reply at your own pace, as
>   your condition allows. I wish you a speedy recovery! ]
>
> > You're simply cashing in on the deep pipes that do kernel work for
> > other tasks. You know very well that I dropped the TASK_NONINTERACTIVE
> > flag from rsdl which checks that tasks are waiting on pipes and you're
> > exploiting it.
>
> Con, i am not 'cashing in' on anything and i'm not 'exploiting'
> anything. The TASK_NONINTERACTIVE flag is totally irrelevant to my
> argument because i was not testing the vanilla scheduler, i was testing
> RSDL. I could have written this test using plain sockets, because i was
> testing RSDL's claim of not having heuristics, i was not testing the
> vanilla scheduler.
>
> I have simply replied to this claim of yours:
> > > Despite the claims to the contrary, RSDL does not have _less_
> > > heuristics, it does not have _any_. [...]
>
> and i showed you a workload under _RSDL_ that clearly shows that RSDL is
> an unfair scheduler too.
>
> my whole point was to counter the myth of 'RSDL has no heuristics'. Of
> course it has heuristics, which results in unfairness. (If it didnt have
> any heuristics that tilt the balance of scheduling towards sleep-intense
> tasks then a default Linux desktop would not be usable at all.)
>
> so the decision is _not_ a puristic "do we want to have heuristics or
> not", the question is a more practical "which heuristics are simpler,
> which heuristics are more flexible, which heuristics result in better
> behavior".
>
> 	Ingo

Ok but please look at how it appears from my end (illness aside).

I spend 3 years just diddling with scheduler code trying my hardest to find a 
design that fixes a whole swag of problems we still have, and a swag of 
problems we might get with other fixes.

You initially said you were pleased with this design.

..lots of code, testing, bugfixes and good feedback.

Then Mike has one testcase that most other users disagree is worthy of being 
considered a regresssion. You latched onto that and basically called it a 
showstopper in spite of who knows how many other positive things.

Then you quickly produce a counter patch designed to kill off RSDL with a 
config option for mainline.

Then you boldly announce on LKML "is RSDL an "unfair" scheduler too?" with 
some test case you whipped up to try and find fault with the design.

What am I supposed to think? Considering just how many problems I have 
addressed and tried to correct with RSDL succesfully I'm surprised that 
despite your enthusiasm for it initially you have spent the rest of the time 
trying to block it.

Please, either help me (and I'm in no shape to code at the moment despite what 
I have done so far), or say you have no intention of including it. I'm 
risking paralysis just by sitting at the computer right now so I'm dropping 
the code as is at the moment and will leave it up to your better judgement as 
to what to do with it.

-- 
-ck
