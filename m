Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbYE0OWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbYE0OWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbYE0OWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:22:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36461 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbYE0OWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:22:41 -0400
Date: Tue, 27 May 2008 16:22:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC: 2.6 patch] let GROUP_SCHED depend on BROKEN
Message-ID: <20080527142212.GA9076@elte.hu>
References: <20080527085830.GA20938@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527085830.GA20938@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> I know that this is controversial, [...]

NAK.

The regressions you've listed should all be fixed by Peter and Mike in 
the current scheduler queue either via fixes or via reverts. Basically 
all the group scheduling ones revolve around a single technical issue: 
group-aware load-balancing which got touched in .26-rc1 and which is not 
fully cooked yet.

You are distorting reality: there's not a single kernel crash/hang or 
app crash open in -rc4 and the fixes (or reverts) are all in the v2.6.26 
scheduler pipeline and performance/scalability and interactivity is back 
to .25 levels or better.

But more generally, beyond this specific incident that you generated, i 
can see a big problem in another area: lately you have visibly 
intensified your attempts to boss people around on lkml.
 
Doing small janitorial fixes is fine (and useful), but you are now also 
actively wasting people's time, you are frequently showing an attitude, 
you are exaggerating bugs and you are interfering with the workflow of 
kernel developers.

Furthermore, you've now also upset a MAJOR contributor (Peter Zijstra), 
and upsetting Peter is quite a feat i have to say.

You do all that while the shocking reality is that you have no real 
experience and no real track record _at all_ in writing more complex 
kernel code yourself! How do you expect to be able to judge such issues 
without having the first-hand experience?

To make sure i'm accurate about this i just spent 15 minutes
reviewing all your past commits to the Linux kernel using
"git-shortlog --author=Bunk", and the rather sobering truth
appears to be that:

  - you've _never_ before fixed a complex Linux kernel bug/problem
  - you've never before written a _single_ Linux kernel feature
  - you've never before written a _single_ Linux driver
  - you've never before done any true self-driven functional 
    changes/improvements to Linux

What you did are 1500+ trivial commits that all revolve around the same
janitorial topics: symbol fixes, trivial fixes (often gleaned off
Coverity logs, sparse or namespacecheck output) and dead code removal.

The method i used to review your past contributions was to first exclude 
the main body of your commits via this shell pattern:

git-shortlog --author=Bunk | grep -viE "remov|static|build|license|\
extern|export|syntax|off by|overflow|cleanup|prototype|inline|select|\
bool|tristate|include|depend|init|section|config|scheduled|marked|#if|\
text|off-by-one|\.h|firmware|NULL|global|return|compare|leak|use-after|\
typo|dead|compil|delete|trivial|check after|spelling|small|update|\
check|kill|=|indent|tiny|deprecated|obsolete|endian|default|__dev|renam"

this eliminated 94.8% of your 1607 commits of the past 3 years. I 
reviewed the remaining 83 commits manually, and they all, without 
exception, appeared trivial too. I also have direct experience with you 
as the maintainer of various subsystems: you never before approched me 
about any non-trivial technical issue about _anything_ in the kernel.

So it appears to me - and all facts i have show it - that you appear to 
have no desire _at all_ to write true kernel code. You appear to have no 
ideas of your own (that you express publicly) and you appear to have no 
technical wishes or intellectual curiosity about Linux that rises beyond 
the level of trivialities.

... which might still all be fine and you could still be useful to Linux 
even if you are never able to rise above that trivial level, but the 
difference is that you also do appear to have a very strong desire to be 
seen as an "important person".

Worse than that, you now have also decided to become a major obstacle in 
other people's workflow. And _that_ is a VERY big problem. You are quite 
delusive if you think people will tolerate that kind of behavior.

I used to be a defender of your trivial commits in the past, because i'm 
strongly convinced that the path towards more complex code is through 
doing trivial changes. But you appear to be the exception that proves 
the rule: you stubbornly remained at the intellectual level of trivial 
commits.

Adrian, the thing is, if you have the desire to become a maintainer, the 
very first basic step towards maintaining any kernel code is to start 
_writing_ kernel code, then you can maintain the code you wrote. Linux 
is not a project where you can get away without actually being able to 
write code.

This total, 100% lack of substantial commits from you is OK as long as 
someone only has tangential (or initial) interest in Linux, but it is 
rather shocking from someone like you who has been around for years and 
who tries to be a force in kernel development. I dont really understand 
how you can think that this will fly with us.

You also seem to have a track record of ... similar incidents and a 
crusade in another space - here is this 2002 mail from you on one of the 
Debian lists:

  http://lists.debian.org/debian-devel/2002/01/msg02160.html

  " I do hereby completely retire from Debian. [...] "

You've recently asked on lkml whether you should quit kernel hacking too 
- and my answer is that you need to start kernel hacking before you can 
quit it. You are now on the path to become the equivalent of a 
self-important buerocrat who creates his own work and who plays petty 
office politics. Which is quite a feat i have to say, given the tons of 
real technical work that is still to be done in Linux.

	Ingo
