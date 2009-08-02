Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbZHBTqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbZHBTqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZHBTqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:46:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60639 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbZHBTqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:46:47 -0400
Date: Sun, 2 Aug 2009 21:46:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Anton Blanchard <anton@samba.org>, paulus@samba.org, fweisbec@gmail.com,
       rdreier@cisco.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: perf_counter: Track all mmaps, heap and stack extensions
Message-ID: <20090802194637.GC24486@elte.hu>
References: <20090728084612.GA4603@kryten> <1248778622.6987.2983.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248778622.6987.2983.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-07-28 at 18:46 +1000, Anton Blanchard wrote:
> > Hi,
> > 
> > Right now perf_counter only logs executable mmaps. While this is enough
> > for instruction profiling, at some stage we are also going to want
> > to do data profiling. This will require us to log non-executable mmaps as
> > well as stack and heap extensions.
> > 
> > Why would we care about heap and stack? A few examples:
> > 
> > 1. We can monitor TLB miss rates to suggest what regions of memory should be
> >    put into hugepages.
> >  
> > 2. We can look into various TLB miss issues. On PowerPC a data prefetch
> >    that goes to an unmapped area takes a significant amount of time (it
> >    initiates a tablewalk that may take 40+ cycles). With accurate mapping
> >    data we can catch areas of code with bad prefetch instructions.
> 
> Agreed.
> 
> > Taking it a bit further, since in some sense perf_counter is a channel for
> > getting events out to userspace, I wonder if we could solve Roland's RDMA
> > address space unmap issue with perf_counter:
> > 
> > http://patchwork.kernel.org/patch/37267/
> 
> Yeah, saw some of that, Andrew has some good points there. Haven't had
> time to see the reply yet.
> 
> Not sure its a good match, but if so, very nice.
> 
> > Below is a dodgy hack I've been using to prototype tracking of 
> > all mmaps and heap/stack extensions. Naturally we'd want a 
> > perf_counter feature to turn this on and keep instruction 
> > profiles more compact. We'd also want munmap events.
> 
> I used to have an munmap hook in there at some point. We could 
> restore that.
> 
> > Thoughts?
> 
> Seems like a good direction, go for it ;-)

Seconded! Please submit the full patch once you are happy with it, 
with some tools/perf/ variant/feature that makes use of it and we 
are golden.

	Ingo
