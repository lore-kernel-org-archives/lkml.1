Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbZCUQVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbZCUQVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757947AbZCUQVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:21:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757933AbZCUQVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:21:22 -0400
Date: Sat, 21 Mar 2009 17:21:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/3] perf_counter: new output ABI - part 1
Message-ID: <20090321162110.GD11183@elte.hu>
References: <20090320151547.937040269@chello.nl> <20090320151735.008338484@chello.nl> <20090320190912.GF6224@elte.hu> <18884.46934.898678.53966@cargo.ozlabs.ibm.com> <1237631399.24626.112.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237631399.24626.112.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sat, 2009-03-21 at 20:45 +1100, Paul Mackerras wrote:
> > Ingo Molnar writes:
> > 
> > > i think it would still be nice to allow plain old-fashioned 
> > > poll()+read() loops ... but the logistics of that seem difficult. 
> > > mmap() seems to fit this better - and it's probably faster as well. 
> > > (as we have to construct the kernel-space pages anyway, so mapping 
> > > them isnt that big of an issue)
> > > 
> > > per-CPU-ness will be handled naturally via per-cpu counters.
> > > 
> > > Paul, can you see any hole/quirkiness in this scheme?
> > 
> > The one thing I can see that we would lose is the ability to have a
> > signal delivered on every event.  The PAPI developers want to be able
> > to get a signal generated every time the counter overflows, and
> > previously we could do that using the O_ASYNC flag, but now we'll only
> > get a signal every page's worth of events.
> 
> Ah, nice, didn't know about O_ASYNC and was thinking we should perhaps
> provide some signal too, seems that's already taken care of, sweet :-)
> 
> > So I think we want userspace to be able to say how often we should
> > generate a poll event, i.e. provide a way for userspace to say "please
> > generate a poll event every N counter events".  That would also solve
> > the problem of 1 page not being a valid configuration - you could set
> > the poll interval to the number of events that fit in half a page, for
> > instance.
> 
> Sure, can do, sounds like s sensible extension -- except it will 
> be hard to guess the event size for some future events like 
> callchains and mmap data.

Agreed. Looks like a perfect fit for yet another ioctl/fcntl method?

	Ingo
