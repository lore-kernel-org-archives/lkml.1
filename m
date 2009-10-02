Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbZJBJza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbZJBJza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757484AbZJBJz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:55:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34853 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471AbZJBJzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:55:24 -0400
Date: Fri, 2 Oct 2009 11:54:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [this_cpu_xx V4 00/20] Introduce per cpu atomic operations and
	avoid per cpu address arithmetic
Message-ID: <20091002095455.GC21427@elte.hu>
References: <20091001212521.123389189@gentwo.org> <4AC5C836.8000502@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC5C836.8000502@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> cl@linux-foundation.org wrote:
> > V3->V4:
> > - Fix various macro definitions.
> > - Provider experimental percpu based fastpath that does not disable
> >   interrupts for SLUB.
> 
> The series looks very good to me. [...]

Seconded, very nice series!

One final step/cleanup seems to be missing from it: it should replace 
current uses of percpu_op() [percpu_read(), etc.] in the x86 tree and 
elsewhere with the new this_cpu_*() primitives. this_cpu_*() is using 
per_cpu_from_op/per_cpu_to_op directly, we dont need those percpu_op() 
variants anymore.

There should also be a kernel image size comparison done for that step, 
to make sure all the new primitives are optimized to the max on the 
instruction level.

> [...] percpu#for-next now has ia64 bits included and the legacy 
> allocator is gone there so it can carry this series.  Sans the last 
> one, they seem they can be stable and incremental from now on, right?  
> Shall I include this series into the percpu tree?

I'd definitely recommend doing that - it should be tested early and wide 
for v2.6.33, and together with other percpu bits.

	Ingo
