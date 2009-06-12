Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZFLMyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZFLMyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZFLMxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:53:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42147 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZFLMxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:53:53 -0400
Date: Fri, 12 Jun 2009 14:53:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: origin tree build failure
Message-ID: <20090612125335.GH31845@elte.hu>
References: <20090612102427.32582baa.sfr@canb.auug.org.au> <1244768406.7172.1.camel@pasglop> <20090612092054.GB32052@elte.hu> <1244799197.7172.106.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244799197.7172.106.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> > Ah - thanks. The bug was caused by me being a bit too optimistic 
> > in applying the shiny-new Power7 support patches on the last 
> > day. (nice CPU btw.)
> 
> In that case paulus tells me it's actually Peter screwing up 
> moving something from the powerpc code to generic :-)

Yes, but i committed it and it's my task to make sure that the thing 
works as a whole so it's my fault still :)

>  .../...
> 
> > Such bugs happen, and they are easy enough to fix. What matters 
> > arent the 1-2 short-lived bugs that do happen when a new 
> > combination of trees is created, but the long-lived combination 
> > bugs and conflicts.
> 
> I'm not saying -next would fix world hunger ... but in this case 
> we have two sets of issues, perfctr and the init ordering change 
> which both got merged totally bypassing -next... We should at 
> least -try- to follow the process we've defined, don't you think ?

You are trying to define a process that does not exist in that form 
and which never existed in that form.

It was never true that new code _MUST_ go via linux-next - and i 
hope it will never be true.

linux-next has integration testing so that interactions between 
maintainer trees are mapped and that architectures that otherwise 
few people use get build-tested too (well beyond their practical 
relevance, i have to add) - but there's little critical review done 
in linux-next. Nor should it be the forum for that, it simply 
contains way too much stuff and has a weird history format with 
daily rebases that makes review hard and expensive in that form.

linux-next should not be second-guessing maintainers and should not 
act as an "approval forum" for controversial features, increasing 
the (already quite substantial) pressure on maintainers to apply 
more crap.

And that is true even if it's a new feature that i happen to support 
- as in this case - it sure would have been handy to have more 
perfcounters test coverage, every little bit of extra testing helps.

If linux-next wants to do that then it should be renamed to 
something else and not called linux-next.

	Ingo
