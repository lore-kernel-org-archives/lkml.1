Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbYANPfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbYANPfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYANPfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:35:10 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:32984 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbYANPfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:35:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAGsQi0dMROHU/2dsb2JhbACBVpAGlwM
Date: Mon, 14 Jan 2008 10:35:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, "Frank Ch. Eigler" <fche@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost
	Tracing
Message-ID: <20080114153505.GA11522@Krystal>
References: <20071231060911.GB6461@in.ibm.com> <20071231102045.GB30380@elte.hu> <y0modc4vr7a.fsf@ton.toronto.redhat.com> <20080102124734.GC11208@elte.hu> <20080102163309.GC11496@redhat.com> <20080102170157.GA11161@elte.hu> <20080107185954.GA16041@Krystal> <20080113180740.GA4435@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080113180740.GA4435@ucw.cz>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:34:05 up 71 days, 20:39,  4 users,  load average: 0.46, 0.51,
	0.53
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@ucw.cz) wrote:
> On Mon 2008-01-07 13:59:54, Mathieu Desnoyers wrote:
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Frank Ch. Eigler <fche@redhat.com> wrote:
> > > 
> > > > > [...] this is a general policy matter. It is _so much easier_ to add 
> > > > > markers if they _can_ have near-zero overhead (as in 1-2 
> > > > > instructions). Otherwise we'll keep arguing about it, especially if 
> > > > > any is added to performance-critical codepath. (where we are 
> > > > > counting instructions)
> > > > 
> > > > The effect of the immediate-values patch, combined with gcc 
> > > > CFLAGS+=-freorder-blocks, *is* to keep the overhead at 1-2 
> > > > dcache-impact-free instructions.  The register saves, parameter 
> > > > evaluation, the function call, can all be moved out of line.
> > > 
> > > well, -freorder-blocks seems to be default-enabled at -O2 on gcc 4.2, so 
> > > we should already be getting that, right?
> > > 
> > > There's one thing that would make out-of-line tracepoints have a lot 
> > > less objectionable to me: right now the 'out of line' area is put to the 
> > > end of functions. That splinters the kernel image with inactive, rarely 
> > > taken areas of code - blowing up its icache footprint considerably. For 
> > > example sched.o has ~100 functions, with the average function size being 
> > > 200 bytes. At 64 bytes L1 cacheline size that's a 10-20% icache waste 
> > > already.
> > 
> > Hrm, I agree this can be a problem on architectures with more standard
> > associative icaches, but aren't most x86_64 machines (and modern x86_32)
> > using an instruction trace cache instead ? This makes the problem
> > irrelevant.
> > 
> > But I agree that, as Frank proposed, -freorder-blocks-and-partition
> > could help us in that matter for the architectures using an associative
> > L1 icache.
> 
> I thought trace cache died with P4?
> -- 

And you are absolutely right.

We would have to figure out if enabling -freorder-blocks-and-partition
makes sense kernel-wide.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
