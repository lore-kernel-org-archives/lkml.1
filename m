Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYL3Pi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYL3Pi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 10:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYL3PiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 10:38:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36103 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYL3PiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 10:38:07 -0500
Date: Tue, 30 Dec 2008 16:37:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081230153752.GA2984@elte.hu>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081229220937.GC5829@nowhere> <1230623364.6091.9.camel@penberg-laptop> <20081230081600.GD2455@elte.hu> <20081230141608.GA5722@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230141608.GA5722@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Dec 30, 2008 at 09:16:00AM +0100, Ingo Molnar wrote:
> > 
> > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > 
> > > Hi Frederic,
> > > 
> > > On Mon, 2008-12-29 at 23:09 +0100, Frederic Weisbecker wrote:
> > > > Pekka, note that I would be pleased to add statistical tracing on
> > > > this tracer, but I would need a hashtable, or an array, or a list, or whatever
> > > > iterable to insert the data into the stat tracing api.
> > > > 
> > > > But I don't know your projects about this... whether you wanted to use a section
> > > > or something else...
> > > 
> > > It really depends on what we're tracing. If we're interested in just the 
> > > allocation hotspots, a section will do just fine. However, if we're 
> > > tracing memory footprint, we need to take into store the object pointer 
> > > returned from kmalloc() and kmem_cache_alloc() so we can update 
> > > call-site statistics properly upon kfree().
> > > 
> > > So I suppose we need both, a section for per call-site statistics and a 
> > > hash table for the object -> call-site mapping.
> > 
> > 1)
> > 
> > i think the call_site based tracking should be a built-in capability - the 
> > branch tracer needs that too for example. That would also make it very 
> > simple on the usage place: you wouldnt have to worry about sections in 
> > slub.c/etc.
> 
> 
> I think that too. Can we use sections here? The traced functions are not 
> directly kmalloc/kmem_cache_alloc and to use a section which contains 
> the per site allocation requests, such a thing is required (we can't 
> build a section with per site allocations requests by using intermediate 
> level allocation function I fear...).

i think initially this should be a fixed-size allocation array + hash as 
well. (like lockdep uses) The number of allocation sites is even the most 
extreme case at most a few thousand - and is typically at most a couple of 
hundred.

	Ingo
