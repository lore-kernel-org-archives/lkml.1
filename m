Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbXCQQex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbXCQQex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 12:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXCQQex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 12:34:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47492 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbXCQQew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 12:34:52 -0400
Date: Sat, 17 Mar 2007 17:34:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>, Al Boldi <a1426z@gawab.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: is RSDL an "unfair" scheduler too?
Message-ID: <20070317163434.GB30162@elte.hu>
References: <200703042335.26785.a1426z@gawab.com> <200703172302.10819.kernel@kolivas.org> <20070317122831.GA28429@elte.hu> <200703172343.53480.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703172343.53480.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> Ok but please look at how it appears from my end (illness aside).

( i really think we should continue this debate after you get better. 
  Everything looks much darker when you are ill! )

> You initially said you were pleased with this design.

I said that 2 years ago about the staircase scheduler and i am still 
saying this about RSDL today. That doesnt make my position automatically 
correct though :-) For example i wrote and maintained the 4g:4g patchset 
for over 2 years and still that was no guarantee of it making sense 
upstream ;) And it was a hell of a lot of work (much uglier and nastier 
work than any scheduler hacking and tuning, believe me), and it was 
thrown away as a cute but unnecessary complication we dont need. So 
what? To me what matters is the path you walk, not the destination you 
reach.

in terms of RSDL design, i like it, still i'm kind of asking myself 
'couldnt something in this direction be done in a much simpler and less 
revolutionary way'? For example couldnt we introduce per-priority level 
timeslice quotas in the current scheme as well, instead of the very 
simplistic and crude STARVATION_LIMIT approach? Furthermore, couldnt we 
make the timeslices become smaller as the runqueue length increases, to 
make starvation less of a problem? It seems like the problem cases with 
the current scheduler arent so much centered around the interactivity 
estimator, it is more that timeslices get distributed too coarsely, 
while RSDL distributes timeslices in a more finegrained way and is thus 
less suspect to starvation under certain workloads.

in any case, regardless the technical picture, i do get nervous when a 
group of people tries to out-shout clearly valid feedback like Mike's, 
and i'll try to balance such effects out a bit. _Of course_ those people 
that are not happy with the current scheduler have a higher likelyhood 
to try out another scheduler and be happy about it - but we should not 
allow that natural bias (which, btw., could easily be the _truth_, so 
i'm not assuming anything) to stand in the way of critical thinking. I 
also get slightly nervous about what appears to be dubious technical 
claims like "this is X's fault and if you rewrite X it will work much 
better so go away and do not stand in the way of progress" or "this new 
scheduler does away with all those ugly heuristics". I'm almost getting 
a reiser4 de ja vu :-/

we should really let this sit through in -mm for at least one more 
kernel iteration, let more folks be exposed to it and keep an eye on 
regression reports. [ An _eye_, not a machine gun ;-) ]

	Ingo
