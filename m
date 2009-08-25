Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZHYGmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZHYGmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZHYGmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:42:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:55998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZHYGmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:42:32 -0400
Subject: Re: [PATCH 8/15] sched: Add parameter sched_mn_power_savings to
 control MN domain sched policy
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham Shenoy <ego@in.ibm.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
In-Reply-To: <20090825062432.GB20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820133914.GW29327@alberich.amd.com> <1251125778.7538.268.camel@twins>
	 <20090825062432.GB20811@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Aug 2009 08:41:36 +0200
Message-Id: <1251182496.7538.1055.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 08:24 +0200, Andreas Herrmann wrote:
> On Mon, Aug 24, 2009 at 04:56:18PM +0200, Peter Zijlstra wrote:
> > On Thu, 2009-08-20 at 15:39 +0200, Andreas Herrmann wrote:
> > > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > > ---
> > 
> > > +#ifdef CONFIG_SCHED_MN
> > > +	if (!err && mc_capable())
> > > +		err = sysfs_create_file(&cls->kset.kobj,
> > > +					&attr_sched_mn_power_savings.attr);
> > > +#endif
> > 
> > *sigh* another crappy sysfs file
> > 
> > Guys, can't we come up with anything better than sched_*_power_saving=n?
> 
> Thought this is a settled thing. At least there are already two
> such parameters. So using the existing convention is an obvious
> thing, no?

Well, yes its the obvious thing, but I'm questioning whether its the
best thing ;-)

> > This configuration space is _way_ too large, and now it gets even
> > crazier.
> 
> I don't fully agree.
> 
> Having one control interface for each domain level is just one
> approach. It gives the user full control of scheduling policies.
> It just might have to be properly documented.
> 
> In another mail Vaidy mentioned that
> 
>   "at some point we wanted to change the interface to
>    sched_power_savings=N and and set the flags according to system
>    topology".
> 
> But how you'll decide at which domain level you have to do power
> savings scheduling?

The user isn't interested in knowing about domains and cpu topology in
99% of the cases, all they want is the machine not burning power like
there's no tomorrow.

Users (me including) have no interest exploring a 27-state power
configuration space in order to find out what works best for them, I'd
throw up my hands and not bother, really.

> Using sched_mn_power_savings=1 is quite different from
> sched_smt_power_savings=1. Probably, the most power you save if you
> switch on power saving scheduling on each domain level. I.e. first
> filling threads of one core, then filling all cores on one internal
> node, then filling all internal nodes of one socket.
> 
> But for performance reasons a user might just want to use power
> savings in the MN domain. How you'd allow the user to configure that
> with just one interface? Passing the domain level to
> sched_power_savings, e.g.  sched_power_savings=MC instead of the power
> saving level?

Sure its different, it reduces the configuration space, that gives less
choice, but does make it accessible.

Ask joe-admin what he prefers.

If you're really really worried people might miss the joy of fine tuning
their power scheduling, then we can provide a dual interface, one for
dumb people like me, and one for crazy people like you ;-)

> Besides that, don't we have to keep the user-interface stable, i.e.
> stick to sched_smt_power_savings and sched_mc_power_savings?

Don't ever defend crappy stuff with interface stability, that's just
lame ;-)
