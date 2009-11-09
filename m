Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZKIJ5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZKIJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbZKIJ5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:57:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:57541 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754780AbZKIJ5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:57:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19PqwR1qhhPPwnLS/99Lqlfad6rlWwTreDHueIQvU
	na8VpPD7QigHzp
Subject: Re: specjbb2005 and aim7 regression with 2.6.32-rc kernels
From: Mike Galbraith <efault@gmx.de>
To: ego@in.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091109094425.GA26733@in.ibm.com>
References: <1257493130.16282.109.camel@ymzhang>
	 <20091106080418.GB28227@elte.hu> <1257747597.16282.120.camel@ymzhang>
	 <1257750573.6414.29.camel@marge.simson.net>
	 <1257758104.4108.152.camel@laptop>  <20091109094425.GA26733@in.ibm.com>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 10:57:17 +0100
Message-Id: <1257760637.7124.26.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 15:14 +0530, Gautham R Shenoy wrote:
> On Mon, Nov 09, 2009 at 10:15:04AM +0100, Peter Zijlstra wrote:
> > On Mon, 2009-11-09 at 08:09 +0100, Mike Galbraith wrote:
> > > +       smp_read_barrier_depends();
> > >         cpumask_setall(cpus);
> > > +       cpumask_and(cpus, cpus, cpu_online_mask);
> > 
> > 
> > how about: cpumask_copy(cpus, cpu_online_mask); ?
> > 
> > Also, iirc cpu_online_mask is guaranteed stable when preemption is
> > disabled, otherwise you need to use get/put_online_cpus(), an
> > rmb_depends() won't do.
> 
> preempt_disable() guarantees that any cpus won't go offline, since we
> use stop_machine() to take CPUs offline. I don't think it provides cover
> against new cpus coming online.

That's exactly the problem I'm having with newidle.  Without that
barrier, even with the cpumask_and(), it still balances offline cpus.

	-Mike

