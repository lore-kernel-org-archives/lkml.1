Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZGOO7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZGOO7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZGOO7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:59:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:59570 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbZGOO7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:59:09 -0400
Date: Wed, 15 Jul 2009 16:59:07 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, fche@redhat.com, cl@linux-foundation.org
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already using mudflap
Message-ID: <20090715145907.GE7298@wotan.suse.de>
References: <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop> <20090710090351.GD14666@wotan.suse.de> <1247217263.771.8.camel@penberg-laptop> <20090710092921.GF14666@wotan.suse.de> <1247218826.771.15.camel@penberg-laptop> <alpine.DEB.2.00.0907100243010.14601@chino.kir.corp.google.com> <1247219506.771.22.camel@penberg-laptop> <alpine.DEB.2.00.0907100253560.14601@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907100253560.14601@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 03:03:19AM -0700, David Rientjes wrote:
> On Fri, 10 Jul 2009, Pekka Enberg wrote:
> 
> > Hey, I said SLAB is on its way out (yes, it really is). But I didn't say
> > we're going to blindly remove it if performs better than the
> > alternatives. I don't see any reason why SQLB can't reach the same
> > performance as SLAB after on fundamental level, though. Can you?
> > 
> 
> I'm not really interested in making predictions on which design has the 
> greatest potential for pure performance, I'm interested in what is proven 
> to work and does the job better than any alternative.  Right now, for 
> certain workloads, that's undeniably slab.  So I'd disagree that slab is 
> on its way out until another allocator is shown to at least have parity 
> with it (at which time I'd become more interested in the cleanliness of 
> the code, the debugging support, etc.).
> 
> It's my opinion that slab is on its way out when there's no benchmark that 
> shows it is superior by any significant amount.  If that happens (and if 
> its successor is slub, slqb, or a yet to be implemented allocator), we can 
> probably start a discussion on what's in and what's out at that time.

How are you running your netperf test? Over localhost or remotely?
It is a 16 core system? NUMA?

It seems pretty variable when I run it here, although there seems
to be a pretty clear upper bound on performance, where a lot of the
results land around (then others go anywhere down to less than half
that performance).

Anyway, tried to get an idea of performance on my 8 core NUMA system,
over localhost, and just at 64 threads. Ran the test 60 times for
each allocator.

Rates for 2.6.31-rc2 (+slqb from Pekka's tree)
SLAB: 1869710
SLQB: 1859710
SLUB: 1769400

Slab did have slightly higher maximal numbers too, although slqb
SLQB had the highest minimum. But both were fairly similar there.
SLUB's minimum went down to around 13% lower than the others.

Now I didn't reboot or restart netperf server during runs, so there
is possibility of results drifting for some reason (eg. due to
cache/node placment).

I can't say SLQB beats SLAB here, but it's fairly good. I'll see
if any tweaks can improve it further...

