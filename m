Return-Path: <linux-kernel-owner+w=401wt.eu-S965440AbXCLJiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440AbXCLJiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965389AbXCLJiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:38:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:39133 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965440AbXCLJiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:38:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/sjw9RM2Dsg3Sb4NueBlozEUbC10en2OKaFLfl8j
	pDPL87b+6C1dfc
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703122022.43021.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703121929.39702.kernel@kolivas.org>
	 <1173689733.6748.18.camel@Homer.simpson.net>
	 <200703122022.43021.kernel@kolivas.org>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 10:38:06 +0100
Message-Id: <1173692286.20540.12.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 20:22 +1100, Con Kolivas wrote:
> On Monday 12 March 2007 19:55, Mike Galbraith wrote:
> > On Mon, 2007-03-12 at 19:29 +1100, Con Kolivas wrote:
> > > I'll save you the trouble. I just checked myself and indeed the load is
> > > only 1. What this means is that although there are 2 tasks running, only
> > > one is running at any time making a total load of 1. So, if we add two
> > > other tasks that add 2 more to the load the total load is 3. However if
> > > we weight the other two tasks at nice 5, they only add .75 each to the
> > > load making a weighted total of 2.5. This means that X+Gforce together
> > > should get a total of 1/2.5 or 40% of the overall cpu. That sounds like
> > > exactly what you're describing is happening.
> >
> > Hmm.  So... anything that's client/server is going to suffer horribly
> > unless niced tasks are niced all the way down to 19?
> 
> Fortunately most client server models dont usually have mutually exclusive cpu 
> use like this X case. There are many things about X that are still a little 
> (/me tries to think of a relatively neutral term)... wanting. :(

But the reality of X is what we have to deal with.

This scheduler seems to close the corner cases of the interactivity
estimator, but this "any background load is palpable" thing is decidedly
detrimental to interactive feel.

When I looked into keeping interactive tasks responsive, I came to the
conclusion that I just couldn't get there from here across the full
spectrum of cpu usage without a scheduler hint.  Interactive feel is
absolutely dependent upon unfairness in many cases, and targeting that
unfairness gets it right where heuristics sometimes can't.

	-Mike

