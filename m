Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbZCYM3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbZCYM3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760889AbZCYM30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:29:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37044 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719AbZCYM3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:29:25 -0400
Date: Wed, 25 Mar 2009 13:29:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 11/11] sched: Add comments to find_busiest_group()
	function.
Message-ID: <20090325122913.GA28639@elte.hu>
References: <20090325091239.13992.96090.stgit@sofia.in.ibm.com> <20090325091427.13992.18933.stgit@sofia.in.ibm.com> <20090325114314.GC11302@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325114314.GC11302@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> On Wed, Mar 25, 2009 at 02:44:27PM +0530, Gautham R Shenoy wrote:
> > Add /** style comments around find_busiest_group(). Also add a few explanatory
> >   */
> 
> <snip>
> 
> >  static struct sched_group *
> >  find_busiest_group(struct sched_domain *sd, int this_cpu,
> > @@ -3593,17 +3613,31 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
> >  	update_sd_lb_stats(sd, this_cpu, idle, sd_idle, cpus,
> >  					balance, &sds);
> > 
> > +	/* Cases where imbalance does not exist from POV of this_cpu */
> > +	/* 1) this_cpu is not the appropriate cpu to perform load balancing
> > +	 *    at this level.
> > +	 * 2) There is no busy sibling group to pull from.
> > +	 * 3) This group is the busiest group.
> > +	 * 4) This group is more busy than the avg busieness at this
> > +	 *    sched_domain.
> > +	 * 5) The imbalance is within the specified limit.
> > +	 * 6) Any rebalance would lead to ping-pong
> > +	 */
> >  	if (balance && !(*balance))
> >  		goto ret;
> > 
> > -	if (!sds.busiest || sds.this_load >= sds.max_load
> > -		|| sds.busiest_nr_running == 0)
> > +	if (!sds.busiest || sd.busiest_nr_running == 0)
> 			    ^^^^^^^^^^^^^^^^^^^^
> should have been sds.busiest_nr_running. Hence the build failure on tip.
> 
> I think I missed compile testing this last patch.
> 
> Ingo, could you revert commit 7b6340ef884aff69a54f8a530c73ad9da0a7c388 in
> tip/balancing and commit the following patch instead?

sure - i've amended it and started testing it locally. If it passes 
testing it should show up in tip:master.

	Ingo
