Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbZCCPoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbZCCPoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZCCPoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:44:06 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33569 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbZCCPoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:44:03 -0500
Date: Tue, 3 Mar 2009 21:15:37 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Gautham R Shenoy <ego@in.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, efault@gmx.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2 2/3] sched: Fix the wakeup nomination for
	sched_mc/smt_power_savings.
Message-ID: <20090303154537.GI4708@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090303114648.605.86920.stgit@sofia.in.ibm.com> <20090303115149.605.92140.stgit@sofia.in.ibm.com> <1236083033.5330.4204.camel@laptop> <20090303135907.GA23822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090303135907.GA23822@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2009-03-03 14:59:07]:

> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Tue, 2009-03-03 at 17:21 +0530, Gautham R Shenoy wrote:
> > > +/* Assign the sched-domain level which can nominate preferred wake-up cpu */
> > > +       rd->sched_mc_preferred_wakeup_cpu = UINT_MAX;
> > > +       rd->authorized_nomination_level = SD_LV_NONE;
> > > +
> > > +       if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
> > > +               struct sched_domain *sd;
> > > +               enum sched_domain_level authorized_nomination_level =
> > > +                                                               SD_LV_NONE;
> > > +
> > > +               for_each_domain(first_cpu(*cpu_map), sd) {
> > > +                       if (!(sd->flags & SD_POWERSAVINGS_BALANCE))
> > > +                               continue;
> > > +                       authorized_nomination_level = sd->level;
> > > +               }
> > > +
> > > +               rd->authorized_nomination_level = authorized_nomination_level;
> > > +       }
> > 
> > Very odd looking comments there, and that enum init wrapping looks
> > weird. Either exceed 80 chars, or write it in a second line like:
> > 
> >  enum sched_domain_level authorized_nomination_level;
> > 
> >  authorized_nomination_level = SD_LV_NONE;
> 
> I think find_busiest_group() needs to be split up into several 
> helper functions first, before we add more to it. I.e. first a 
> couple of cleanup patches that factor it out into 3-4 helper 
> functions plus a really easy-to-read find_busiest_group() main 
> function.

Hi Ingo,

I had earlier posted cleanup for find_busiest_group(), but Peter
mentioned that he is changing the cpu_power infrastructure and I can
rework the cleanup after that.

[RFC PATCH v1 0/5] Modular find_busiest_group()
V1: http://lkml.org/lkml/2008/9/24/201
V2: http://lkml.org/lkml/2008/10/9/176

Peter did post an RFD for his new proposal:
http://lkml.org/lkml/2008/10/14/148

I think we can revive the discussion thread and start cleaning up.

> Then can we do the above change - and i bet we'll win at least 
> one indentation level as well so that weird line break goes 
> away.

The above code is in __build_sched_domains() and I think we can
shorten the variable names and make the code look better.  Indentation
level here is not as bad as in find_busiest_group().

Thanks,
Vaidy

