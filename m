Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbXIMO2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbXIMO2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbXIMO2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:28:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50018 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbXIMO2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:28:46 -0400
Date: Thu, 13 Sep 2007 16:28:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070913142842.GA26016@elte.hu>
References: <20070911200459.GA6974@elte.hu> <Pine.LNX.4.64.0709120242040.1817@scrub.home> <20070913075258.GA9173@elte.hu> <Pine.LNX.4.64.0709131419170.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709131419170.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> Then you had the time to reimplement the very things you've just asked 
> me about and what do I get credit for - "two cleanups from RFS".

i'm sorry to say this, but you must be reading some other email list and 
a different git tree than what i am reading.

Firstly, about communications - in the past 3 months i've written you 40 
emails regarding CFS - and that's more emails than my wife (or any 
member of my family) got in that timeframe :-( I just ran a quick 
script: i sent more CFS related emails to you than to any other person 
on this planet. I bent backwards trying to somehow get you to cooperate 
with us (and i still havent given up on that!) - instead of you 
disparaging CFS and me frequently :-(

Secondly, i prominently credited you as early as in the second sentence 
of our announcement:

 | fresh back from the Kernel Summit, Peter Zijlstra and me are pleased 
 | to announce the latest iteration of the CFS scheduler development 
 | tree. Our main focus has been on simplifications and performance - 
 | and as part of that we've also picked up some ideas from Roman 
 | Zippel's 'Really Fair Scheduler' patch as well and integrated them 
 | into CFS. We'd like to ask people go give these patches a good 
 | workout, especially with an eye on any interactivity regressions.

   http://lkml.org/lkml/2007/9/11/395

And you are duly credited in 3 patches:

   ------------------->

   Subject: sched: introduce se->vruntime

   introduce se->vruntime as a sum of weighted delta-exec's, and use 
   that as the key into the tree.

   the idea to use absolute virtual time as the basic metric of 
   scheduling has been first raised by William Lee Irwin, advanced by 
   Tong Li and first prototyped by Roman Zippel in the "Really Fair 
   Scheduler" (RFS) patchset.

   also see:

      http://lkml.org/lkml/2007/9/2/76

   for a simpler variant of this patch.

   ------------------->

   Subject: sched: track cfs_rq->curr on !group-scheduling too

   Noticed by Roman Zippel: use cfs_rq->curr in the !group-scheduling 
   case too. Small micro-optimization and cleanup effect:

   ------------------->

   Subject: sched: uninline __enqueue_entity()/__dequeue_entity()

   suggested by Roman Zippel: uninline __enqueue_entity() and 
   __dequeue_entity().

   ------------------->

We could not add you as the author, because you unfortunately did not 
make your changes applicable to CFS. I've asked you _three_ separate 
times to send a nicely split up series so that we can apply your code:

  " it's far easier to review and merge stuff if it's nicely split up. "

   http://lkml.org/lkml/2007/9/2/38

  " I also think that the core math changes should be split from the 
    Breshenham optimizations. "

   http://lkml.org/lkml/2007/9/2/43

   " That's also why i've asked for a split-up patch series - it makes 
     it far easier to review and test the code and it makes it far 
     easier to quickly apply the obviously correct bits. "

   http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg204094.html

You never directly replied to these pretty explicit requests, all you 
did was this side remark 5 days later in one of your patch 
announcements:

   " For a split version I'm still waiting for some more explanation
     about the CFS tuning parameter. "

     http://lkml.org/lkml/2007/9/7/87

You are an experienced kernel hacker. How you can credibly claim that 
while you were capable of writing a new scheduler along with a series of 
25 complex mathematical equations that few if any lkml readers are able 
to understand (and which scheduler came in one intermixed patch that 
added no new comments at all!), and that you are able to maintain the 
m68k Linux architecture code, but that at the same time some supposed 
missing explanation from _me_ makes you magically incapable to split up 
_your own fine code_? This is really beyond me.

I even gave you the first baby step of the split-up by sending this:

    http://lkml.org/lkml/2007/9/2/76

And your reaction to this was dismissive:

  " It simplifies the math too much, the nice level weighting is an 
    essential part of the math and without it one can't really 
    understand the problem I'm trying to solve. "

    http://lkml.org/lkml/2007/9/3/174

So we advanced this whole issue by trying the vruntime concept in CFS 
and adding the 2 cleanups from RFS (we couldnt actually use any code 
from you, due to the way you shaped your patch - but we'd certainly be 
glad to!). You've seen the earliest iteration of that at:

    http://lkml.org/lkml/2007/9/2/76

So far you've sent 3 updates of your patch without addressing any of the 
structural feedback we gave. We virtually begged you to make your code 
finegrained and applicable - but you did not do that.

And please understand, splitting up patches is paramount when 
cooperating with others: we are not against adding code that makes sense 
(to the contrary and we do that every day), but it has to be done 
gradually, in order of utility and impact, so please do send finegrained 
patches if you wish to contribute. (but plain verbal feedback is useful 
too - whichever you prefer.)

I asked you to send a split-up queue repeatedly and finally we ended up 
extracting _one_ concept from your patch (which concept was suggested by 
others months ago already, in the CFS discussions) and two cleanups. You 
are credited for that in the patches. Please send us your other changes 
as a finegrained series and if they are applied you are (of course) 
credited as the author. Does this sound good to you?

	Ingo
