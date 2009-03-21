Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZCUKa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZCUKa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZCUKaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:30:16 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:9058 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbZCUKaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:30:15 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 3/3] perf_counter: new output ABI - part 1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <18884.46934.898678.53966@cargo.ozlabs.ibm.com>
References: <20090320151547.937040269@chello.nl>
	 <20090320151735.008338484@chello.nl> <20090320190912.GF6224@elte.hu>
	 <18884.46934.898678.53966@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 11:29:59 +0100
Message-Id: <1237631399.24626.112.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 20:45 +1100, Paul Mackerras wrote:
> Ingo Molnar writes:
> 
> > i think it would still be nice to allow plain old-fashioned 
> > poll()+read() loops ... but the logistics of that seem difficult. 
> > mmap() seems to fit this better - and it's probably faster as well. 
> > (as we have to construct the kernel-space pages anyway, so mapping 
> > them isnt that big of an issue)
> > 
> > per-CPU-ness will be handled naturally via per-cpu counters.
> > 
> > Paul, can you see any hole/quirkiness in this scheme?
> 
> The one thing I can see that we would lose is the ability to have a
> signal delivered on every event.  The PAPI developers want to be able
> to get a signal generated every time the counter overflows, and
> previously we could do that using the O_ASYNC flag, but now we'll only
> get a signal every page's worth of events.

Ah, nice, didn't know about O_ASYNC and was thinking we should perhaps
provide some signal too, seems that's already taken care of, sweet :-)

> So I think we want userspace to be able to say how often we should
> generate a poll event, i.e. provide a way for userspace to say "please
> generate a poll event every N counter events".  That would also solve
> the problem of 1 page not being a valid configuration - you could set
> the poll interval to the number of events that fit in half a page, for
> instance.

Sure, can do, sounds like s sensible extension -- except it will be hard
to guess the event size for some future events like callchains and mmap
data.



