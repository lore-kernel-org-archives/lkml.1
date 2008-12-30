Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYL3Irn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYL3Irn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYL3Irf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:47:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53394 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbYL3Ire (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:47:34 -0500
Date: Tue, 30 Dec 2008 09:47:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081230084724.GA24637@elte.hu>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081229220937.GC5829@nowhere> <1230623364.6091.9.camel@penberg-laptop> <20081230081600.GD2455@elte.hu> <20081230084127.GE10635@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230084127.GE10635@localhost>
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


* Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> On Tue, Dec 30, 2008 at 09:16:00AM +0100, Ingo Molnar wrote:
> > 3)
> > 
> > the most lowlevel (and hence most allocation-footprint sensitive) object 
> > to track would be the memory object itself. I think the best approach 
> > would be to do a static, limited size hash that could track up to N memory 
> > objects.
> > 
> > The advantage of such an approach is that it does not impact allocation 
> > patterns at all (besides the one-time allocation cost of the hash itself 
> > during tracer startup).
> 
> kmemtrace-user handles this by analysing offline :). I presume you could 
> get around this by discarding every hash collision in a well-sized 
> hashtable. The hashing algo in kmemtrace-user performs okay, considering 
> it fills the hashtable almost entirely, but I presume you're doing that 
> in-kernel and using other available code.

yeah - this is not a replacement for kmemtrace-user - analyzing raw trace 
events offline is still possible of course.

> > And this too would be driven from ftrace mainly - the SLAB code would 
> > only offer the alloc+free callbacks with the object IDs. [ and this 
> > means that we could detect memory leaks by looking at the hash table 
> > and print out the age of entries :-) ]
> 
> Some time ago I dropped timestamps because they were not providing a 
> good way to reorder packets in userspace. We're currently relying on a 
> sequence number to do that. You could take that as 'age', but it's not 
> temporally-meaningful.

yeah - ftrace entries generally have a timestamp so it should be rather 
easy.

	Ingo
