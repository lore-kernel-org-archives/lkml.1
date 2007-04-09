Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbXDIOPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbXDIOPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbXDIOPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:15:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51546 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbXDIOPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:15:31 -0400
Date: Mon, 9 Apr 2007 16:15:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ten percent test
Message-ID: <20070409141516.GB11244@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu> <200704071630.25830.gene.heskett@gmail.com> <20070408104125.GB11123@elte.hu> <461939A4.2020305@gmail.com> <1176092598.6355.22.camel@Homer.simpson.net> <461A2E39.8060106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461A2E39.8060106@gmail.com>
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


* Rene Herman <rene.herman@gmail.com> wrote:

> To me, the example rather serves as confirmation of what Kolivas has 
> been saying; endlessly tweaking the tweaks isn't going anywhere.

but ... SD clearly regresses in some areas, so by that logic SD isnt 
going anywhere either?

note that i still like the basic idea about SD, that it is an experiment 
that if the only conceptual focus is on "scheduling fairness", we'll get 
a better scheduler. But for that to work out two things have to be done 
i think:

 - the code actually has to match that stated goal. Right now it
   diverges from it (it is not a "fair" scheduler), and it's not clear
   why.

note that SD at the moment produces ~10% more code in sched.o, and the 
reason is that SD is more complex than the vanilla scheduler. People 
tend to get the impression that SD is simpler, partly because it is a 
net linecount win in sched.c, but many of the removed lines are 
comments.

this "provide fairness" goal is quite important, because if SD's code is 
not only about providing fairness, what is the rest of the logic doing? 
Are they "tweaks", to achieve interactivity? If yes, why are they not 
marked as such? I.e. will we go down the _same_ road again, but this 
time with a much less clearly defined rule for what a "tweak" is?

note that under the interactivity estimator it is not that hard to 
achieve forced "fairness".

So _if_ we accept that scheduling must include a fair dose of heuristics 
(which i tend to think it has to), we are perhaps better off with an 
interactivity design that _accepts_ this fundamental fact and separates 
heuristics from core scheduling. Right now i dont see the SD proponents 
even _accepting_ that even the current SD code does include heuristics.

the other one is:

 - the code has to demonstrate that it can flexibly react to various 
   complaints of regressions.

(I identified a few problem workloads that we tend to care about and i 
havent seen much progress with them - but i really reserve judgement 
about that, given Con's medical condition.)

	Ingo
