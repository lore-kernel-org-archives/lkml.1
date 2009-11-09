Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZKIJzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZKIJzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbZKIJzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:55:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:55182 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754890AbZKIJy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:54:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+CIGtfgtiC/GKTpOFhzrho9JeyJzYZ8Nx77OJ6k5
	iqcNYTlf36fCjb
Subject: Re: specjbb2005 and aim7 regression with 2.6.32-rc kernels
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1257758104.4108.152.camel@laptop>
References: <1257493130.16282.109.camel@ymzhang>
	 <20091106080418.GB28227@elte.hu>  <1257747597.16282.120.camel@ymzhang>
	 <1257750573.6414.29.camel@marge.simson.net>
	 <1257758104.4108.152.camel@laptop>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 10:55:01 +0100
Message-Id: <1257760501.7124.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 10:15 +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-09 at 08:09 +0100, Mike Galbraith wrote:
> > +       smp_read_barrier_depends();
> >         cpumask_setall(cpus);
> > +       cpumask_and(cpus, cpus, cpu_online_mask);
> 
> 
> how about: cpumask_copy(cpus, cpu_online_mask); ?

Yeah, better.

> Also, iirc cpu_online_mask is guaranteed stable when preemption is
> disabled, otherwise you need to use get/put_online_cpus(), an
> rmb_depends() won't do.

Ok..  I do need a barrier though.  I don't see how it can be stable when
three other CPUs diddle it.  It looks to me like it's stable only when
all diddlers serialize on the runqueue lock.  (which iff correct means
31 has bugs too, so I'm very likely dead wrong) 

/me has very little experience with smp memory woes.  Tripping over one
is one thing, fixing the bugger is an entirely different matter.

(what I'm about to compile would probably get me spanked on lkml;)

	-Mike

