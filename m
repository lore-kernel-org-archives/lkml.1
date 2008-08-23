Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYHWHc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYHWHc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 03:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYHWHct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 03:32:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59971 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYHWHct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 03:32:49 -0400
Date: Sat, 23 Aug 2008 09:34:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather than rcu
Message-ID: <20080823073457.GV23334@one.firstfloor.org>
References: <48AE0883.6050701@goop.org> <20080822062800.GQ14110@elte.hu> <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <48AEC6B2.1080701@linux-foundation.org> <20080822151156.GA6744@linux.vnet.ibm.com> <48AEF3FD.70906@linux-foundation.org> <20080822182915.GG6744@linux.vnet.ibm.com> <20080822183346.GS23334@one.firstfloor.org> <48AF0702.8040303@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AF0702.8040303@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 11:35:46AM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Right now my impression is that it is not well understood why
> > the kmalloc makes the IPI that much slower. In theory a kmalloc
> > shouldn't be all that slow, it's essentially just a 
> > "disable interrupts; unlink object from cpu cache; enable interrupts"
> > with some window dressing. kfree() is similar.
> >
> > Does it bounce a cache line on freeing perhaps?
> 
> I think it's just an assumption that it would be slower.  Has anyone
> measured it?

It's likely slower than no kmalloc because
there will be more instructions executed, the question is just how much.

> 
> (Note: The measurements I posted do not cover this path, because it was
> on a two cpu system, and it was always using the call-single path.)

Ah so it was already 25% slower even without kmalloc? I thought
that was with already. That doesn't sound good. Any idea where that slowdown 
comes from?

-Andi
