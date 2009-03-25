Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZCYTRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZCYTRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZCYTRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:17:45 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:45665 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZCYTRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:17:44 -0400
Date: Thu, 26 Mar 2009 00:47:08 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       bharata@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, nickpiggin@yahoo.com.au, svaidy@linux.vnet.ibm.com,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/balancing] sched: Add comments to
	find_busiest_group()  function
Message-ID: <20090325191708.GA25896@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090325091427.13992.18933.stgit@sofia.in.ibm.com> <tip-b7bb4c9bb01941fe8feb653f3410e7ed0c9bb786@git.kernel.org> <2c0942db0903250904x799271b5s78a1007d0fdbbb77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c0942db0903250904x799271b5s78a1007d0fdbbb77@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ray,
On Wed, Mar 25, 2009 at 09:04:05AM -0700, Ray Lee wrote:
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

These code changes are intentional. They improve readability and help us
categorize the various cases for which we're pretty sure that we don't
have a need to calculate the imbalance.

The fact that the code was reorganized should have been mentioned in the
changelog. My bad. Sorry :(

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

-- 
Thanks and Regards
gautham
