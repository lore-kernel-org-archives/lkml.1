Return-Path: <linux-kernel-owner+w=401wt.eu-S1762287AbXGRJq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762287AbXGRJq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXGRJqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:46:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41420 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbXGRJqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:46:48 -0400
Date: Wed, 18 Jul 2007 11:46:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Message-ID: <20070718094641.GA22651@elte.hu>
References: <46946E39.5090108@bigpond.net.au> <20070716082025.GA29529@elte.hu> <469C08BF.5010406@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469C08BF.5010406@bigpond.net.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> Ingo Molnar wrote:
> > * Peter Williams <pwil3058@bigpond.net.au> wrote:
> > 
> >> Probably the last one now that CFS is in the main line :-(.
> > 
> > hm, why is CFS in mainline a problem?
> 
> It means a major rewrite of the plugsched interface and I'm not sure 
> that it's worth it (if CFS works well).  However, note that I did say 
> probably not definitely :-).  I'll play with it and see what happens.

i think it's very useful as a constant reality check. Yes, i did 
periodically boot your Zaphod scheduler too on a testbox ;-)
"CFS works well" cannot be determined reliably if there's nothing to
compare it against. One goal behind the CFS changes was to remove the
need for massive scheduler rewrites and to ease prototyping. Somehow
there are lots of people who really love to hack the scheduler,
those weirdos ;-)

> > The CFS merge should make the life of development/test patches like 
> > plugsched conceptually easier. (it will certainly cause a lot of 
> > churn, but that's for the better i think.)
> 
> I don't think that is necessarily the case.

well, kernel/sched_rt.c and kernel/sched_fair.c are already more 
different on a conceptual angle than any of the two schedulers in 
PlugSched i think. But ... i dont expect the initial port of PlugSched 
to be easy at all.

> > Most of the schedulers in plugsched should be readily adaptable to 
> > the modular scheduling-policy scheme of the upstream scheduler.
> 
> I don't think that this necessarily true.  Ingosched and ingo_ll are 
> definitely out and I don't feel like converting staircase and 
> nicksched as I have no real interest in them.  Perhaps I'll just 
> create the interface and some schedulers based on my own ideas and let 
> others such as Con and Nick add schedulers if they're still that way 
> inclined.

Yeah, i think starting with a smaller subset is the right approach - i 
think people _will_ fill the gaps ;-) I agree that preserving 
"Ingosched" would not make much sense. (Although it could still be 
useful to someone who finds some regression and suspects CFS, and wants 
to try with the old scheduler. Or just to test/prove that the 
modularization is strong enough to even include those scheduler 
heuristics the old scheduler did. Or out of historic interest.)

> > I'm sure there will be some minor issues as isolation of the modules 
> > is not enforced right now - and i'd be happy to review (and 
> > potentially apply) common-sense patches that improve the framework.
> 
> Thanks for the offer of support (it may sway my decision),

you are welcome :) Dmitry Adamushko and Srivatsa Vaddagiri already did 
lots of nice "policy module isolation" work in CFS (since the first 
crude cut i did in CFS v1), both for the cleanup factor and to enable 
features like group-scheduling.

	Ingo
