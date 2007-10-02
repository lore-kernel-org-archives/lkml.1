Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbXJBGqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbXJBGqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 02:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbXJBGqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 02:46:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55271 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbXJBGqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 02:46:39 -0400
Date: Tue, 2 Oct 2007 08:46:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Schwartz <davids@webmaster.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: yield API
Message-ID: <20071002064620.GA26638@elte.hu>
References: <20071001173159.GB2492@elte.hu> <MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Schwartz <davids@webmaster.com> wrote:

> > These are generic statements, but i'm _really_ interested in the 
> > specifics. Real, specific code that i can look at. The typical Linux 
> > distro consists of in execess of 500 millions of lines of code, in 
> > tens of thousands of apps, so there really must be some good, valid 
> > and "right" use of sched_yield() somewhere in there, in some 
> > mainstream app, right? (because, as you might have guessed it, in 
> > the past decade of sched_yield() existence i _have_ seen my share of 
> > sched_yield() utilizing user-space code, and at the moment i'm not 
> > really impressed by those examples.)
> 
> Maybe, maybe not. Even if so, it would be very difficult to find. 
> Simply grepping for sched_yield is not going to help because 
> determining whether a given use of sched_yield is smart is not going 
> to be easy.

sched_yield() has been around for a decade (about three times longer 
than futexes were around), so if it's useful, it sure should have grown 
some 'crown jewel' app that uses it and shows off its advantages, 
compared to other locking approaches, right?

For example, if you asked me whether pipes are the best thing for 
certain apps, i could immediately show you tons of examples where they 
are. Same for sockets. Or RT priorities. Or nice levels. Or futexes. Or 
just about any other core kernel concept or API. Your notion that 
showing a good example of an API would be "difficult" because it's hard 
to determine "smart" use is not tenable i believe and does not 
adequately refute my pretty plain-meaning "it does not exist" assertion.

If then this is one more supporting proof for the fundamental weakness 
of the sched_yield() API. Rarely are we able to so universally condemn 
an API: real-life is usually more varied and even for theoretically 
poorly defined APIs _some_ sort of legitimate use does grow up.

APIs that are not in any real, meaningful use, despite a decade of 
presence are not really interesting to me personally. (especially in 
this case where we know exactly _why_ the API is used so rarely.) Sure 
we'll continue to support it in the best possible way, with the usual 
kernel maintainance policy: without hurting other, more commonly used 
APIs. That was the principle we followed in previous schedulers too. And 
if anyone has a patch to make sched_yield() better than it is today, i'm 
of course interested in it.

	Ingo
