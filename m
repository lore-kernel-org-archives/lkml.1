Return-Path: <linux-kernel-owner+w=401wt.eu-S1763243AbZCYQRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763243AbZCYQRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZCYQRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:17:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41509 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZCYQRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:17:24 -0400
Date: Wed, 25 Mar 2009 17:17:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       bharata@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, nickpiggin@yahoo.com.au, svaidy@linux.vnet.ibm.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/balancing] sched: Add comments to
	find_busiest_group() function
Message-ID: <20090325161700.GA1411@elte.hu>
References: <20090325091427.13992.18933.stgit@sofia.in.ibm.com> <tip-b7bb4c9bb01941fe8feb653f3410e7ed0c9bb786@git.kernel.org> <2c0942db0903250904x799271b5s78a1007d0fdbbb77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c0942db0903250904x799271b5s78a1007d0fdbbb77@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ray Lee <ray-lk@madrabbit.org> wrote:

> This commit says it's just adding comments, but...
> 
> On Wed, Mar 25, 2009 at 5:30 AM, Gautham R Shenoy <ego@in.ibm.com> wrote:
> > Commit-ID:  b7bb4c9bb01941fe8feb653f3410e7ed0c9bb786
> > Gitweb:     http://git.kernel.org/tip/b7bb4c9bb01941fe8feb653f3410e7ed0c9bb786
> > Author:     Gautham R Shenoy <ego@in.ibm.com>
> > AuthorDate: Wed, 25 Mar 2009 14:44:27 +0530
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 25 Mar 2009 13:28:30 +0100
> >
> > sched: Add comments to find_busiest_group() function
> >
> > Impact: cleanup
> >
> > Add /** style comments around find_busiest_group(). Also add a few
> > explanatory comments.
> 
> ...but there are actual code changes. Hard to know if you intended to
> do that and forgot to changelog it, or if it's an unexpected hunk that
> accidentally got included:
> 
> >        if (balance && !(*balance))
> >                goto ret;
> >
> > -       if (!sds.busiest || sds.this_load >= sds.max_load
> > -               || sds.busiest_nr_running == 0)
> > +       if (!sds.busiest || sds.busiest_nr_running == 0)
> > +               goto out_balanced;
> > +
> > +       if (sds.this_load >= sds.max_load)
> >                goto out_balanced;
> >
> >        sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
> >
> > -       if (sds.this_load >= sds.avg_load ||
> > -                       100*sds.max_load <= sd->imbalance_pct * sds.this_load)
> > +       if (sds.this_load >= sds.avg_load)
> > +               goto out_balanced;
> > +
> > +       if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
> >                goto out_balanced;
> >
> >        sds.busiest_load_per_task /= sds.busiest_nr_running;

yeah.

Note that it does not actually change the resulting logic, it splits 
out an over-long (and hard to read) series of conditions into an 
equivalent set of two if() statements. [the first one changes the 
order of two conditions - but that is harmless]

It indeed would have been nice to declare this in the changelog 
though.

	Ingo
