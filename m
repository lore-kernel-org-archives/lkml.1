Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZJBRdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZJBRdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757740AbZJBRdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:33:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38810 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757635AbZJBRdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:33:02 -0400
Date: Fri, 2 Oct 2009 19:32:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [this_cpu_xx V4 00/20] Introduce per cpu atomic operations and
	avoid per cpu address arithmetic
Message-ID: <20091002173246.GB4884@elte.hu>
References: <20091001212521.123389189@gentwo.org> <4AC5C836.8000502@kernel.org> <20091002095455.GC21427@elte.hu> <alpine.DEB.1.10.0910021313270.26189@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910021313270.26189@gentwo.org>
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


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Fri, 2 Oct 2009, Ingo Molnar wrote:
> 
> > One final step/cleanup seems to be missing from it: it should 
> > replace current uses of percpu_op() [percpu_read(), etc.] in the x86 
> > tree and elsewhere with the new this_cpu_*() primitives. 
> > this_cpu_*() is using per_cpu_from_op/per_cpu_to_op directly, we 
> > dont need those percpu_op() variants anymore.
> 
> Well after things settle with this_cpu_xx we can drop those.
> 
> > There should also be a kernel image size comparison done for that 
> > step, to make sure all the new primitives are optimized to the max 
> > on the instruction level.
> 
> Right. There will be a time period in which other arches will need to 
> add support for this_cpu_xx first.

Size comparison should be only on architectures that support it (i.e. 
x86 right now). The generic fallbacks might be bloaty, no argument about 
that. ( => the more reason for any architecture to add optimizations for 
this_cpu_*() APIs. )

	Ingo
