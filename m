Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbXJBGG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbXJBGG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 02:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXJBGGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 02:06:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52318 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbXJBGGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 02:06:19 -0400
Date: Tue, 2 Oct 2007 08:06:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Schwartz <davids@webmaster.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071002060607.GA18588@elte.hu>
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
	[score: 0.0000]
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
> [...]

google.com/codesearch is your friend. Really, 

> Note that I'm not saying this is a particularly big deal. And I'm not 
> calling CFS' behavior a regression, since it's not really better or 
> worse than the old behavior, simply different.

yes, and that's the core point.

> I'm not familiar enough with CFS' internals to help much on the 
> implementation, but there may be some simple compromise yield that 
> might work well enough. How about simply acting as if the task used up 
> its timeslice and scheduling the next one? (Possibly with a slight 
> reduction in penalty or reward for not really using all the time, if 
> possible?)

firstly, there's no notion of "timeslices" in CFS. (in CFS tasks "earn" 
a right to the CPU, and that "right" is not sliced in the traditional 
sense) But we tried a conceptually similar thing: to schedule not to the 
end of the tree but into the next position. That too was bad for _some_ 
apps. CFS literally cycled through 5-6 different yield implementations 
in its 22 versions so far. The current flag solution was achieved in 
such an iterative fashion and gives an acceptable solution to all app 
categories that came up so far. [ and this is driven by compatibility 
goals - regardless of how broken we consider yield use. The ideal 
solution is of course to almost never use yield. Fortunately 99%+ of 
Linux apps follow that ideal solution ;-) ]

	Ingo
