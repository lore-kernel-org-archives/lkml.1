Return-Path: <linux-kernel-owner+w=401wt.eu-S965549AbXG1Bhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbXG1Bhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 21:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938773AbXG1Bhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 21:37:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:57408 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938772AbXG1Bhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 21:37:31 -0400
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <1185345850.8197.64.camel@twins>
References: <20070724083855.GA858@elte.hu>
	 <20070724015441.8604d85d.akpm@linux-foundation.org>
	 <1185270045.5439.249.camel@localhost.localdomain>
	 <p73abtmt2y7.fsf@bingen.suse.de>
	 <1185312559.5439.276.camel@localhost.localdomain>
	 <1185345850.8197.64.camel@twins>
Content-Type: text/plain
Date: Sat, 28 Jul 2007 11:36:41 +1000
Message-Id: <1185586601.5495.299.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > So I'll first do patch #1, which will not fix the problem, but will make
> > the fix easier to fit in, in the meantime, please provide feedback of
> > your preferred solution for avoiding the get/put_cpu of the 2 above,
> > unless you find a good 3rd one.
> 
> I too would prefer the former solution. I think preemption notifiers are
> a particular iffy hack.
> 
> You could perhaps use C99 variable length arrays to avoid the stack
> waste when not needed, however Andi once told me that generates rather
> dubious code.

As I'm sweeping through arch code etc... preparing the ground for the
proper mmu_gather surgery, I've been thinking about the way to deal with
that per-cpu page list and finally came up with the idea that the best
we can do is around the lines of trying to allocate the list via gfp,
and if that fails, fallback to a (smaller than now) per-cpu. I'm
reworking the interfaces such that the higher level code doesn't have to
care whether preemption is enabled or disabled at a given point.

Ben.


