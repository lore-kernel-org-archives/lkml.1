Return-Path: <linux-kernel-owner+w=401wt.eu-S1751327AbYANOhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbYANOhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYANOhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:37:16 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1174 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751061AbYANOhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:37:12 -0500
Date: Sun, 13 Jan 2008 18:07:41 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, "Frank Ch. Eigler" <fche@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost Tracing
Message-ID: <20080113180740.GA4435@ucw.cz>
References: <20071231060911.GB6461@in.ibm.com> <20071231102045.GB30380@elte.hu> <y0modc4vr7a.fsf@ton.toronto.redhat.com> <20080102124734.GC11208@elte.hu> <20080102163309.GC11496@redhat.com> <20080102170157.GA11161@elte.hu> <20080107185954.GA16041@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107185954.GA16041@Krystal>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-01-07 13:59:54, Mathieu Desnoyers wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Frank Ch. Eigler <fche@redhat.com> wrote:
> > 
> > > > [...] this is a general policy matter. It is _so much easier_ to add 
> > > > markers if they _can_ have near-zero overhead (as in 1-2 
> > > > instructions). Otherwise we'll keep arguing about it, especially if 
> > > > any is added to performance-critical codepath. (where we are 
> > > > counting instructions)
> > > 
> > > The effect of the immediate-values patch, combined with gcc 
> > > CFLAGS+=-freorder-blocks, *is* to keep the overhead at 1-2 
> > > dcache-impact-free instructions.  The register saves, parameter 
> > > evaluation, the function call, can all be moved out of line.
> > 
> > well, -freorder-blocks seems to be default-enabled at -O2 on gcc 4.2, so 
> > we should already be getting that, right?
> > 
> > There's one thing that would make out-of-line tracepoints have a lot 
> > less objectionable to me: right now the 'out of line' area is put to the 
> > end of functions. That splinters the kernel image with inactive, rarely 
> > taken areas of code - blowing up its icache footprint considerably. For 
> > example sched.o has ~100 functions, with the average function size being 
> > 200 bytes. At 64 bytes L1 cacheline size that's a 10-20% icache waste 
> > already.
> 
> Hrm, I agree this can be a problem on architectures with more standard
> associative icaches, but aren't most x86_64 machines (and modern x86_32)
> using an instruction trace cache instead ? This makes the problem
> irrelevant.
> 
> But I agree that, as Frank proposed, -freorder-blocks-and-partition
> could help us in that matter for the architectures using an associative
> L1 icache.

I thought trace cache died with P4?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
