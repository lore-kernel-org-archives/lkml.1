Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZCCN7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZCCN7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZCCN7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:59:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZCCN7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:59:23 -0500
Date: Tue, 3 Mar 2009 14:59:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, efault@gmx.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2 2/3] sched: Fix the wakeup nomination for
	sched_mc/smt_power_savings.
Message-ID: <20090303135907.GA23822@elte.hu>
References: <20090303114648.605.86920.stgit@sofia.in.ibm.com> <20090303115149.605.92140.stgit@sofia.in.ibm.com> <1236083033.5330.4204.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236083033.5330.4204.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-03-03 at 17:21 +0530, Gautham R Shenoy wrote:
> > +/* Assign the sched-domain level which can nominate preferred wake-up cpu */
> > +       rd->sched_mc_preferred_wakeup_cpu = UINT_MAX;
> > +       rd->authorized_nomination_level = SD_LV_NONE;
> > +
> > +       if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
> > +               struct sched_domain *sd;
> > +               enum sched_domain_level authorized_nomination_level =
> > +                                                               SD_LV_NONE;
> > +
> > +               for_each_domain(first_cpu(*cpu_map), sd) {
> > +                       if (!(sd->flags & SD_POWERSAVINGS_BALANCE))
> > +                               continue;
> > +                       authorized_nomination_level = sd->level;
> > +               }
> > +
> > +               rd->authorized_nomination_level = authorized_nomination_level;
> > +       }
> 
> Very odd looking comments there, and that enum init wrapping looks
> weird. Either exceed 80 chars, or write it in a second line like:
> 
>  enum sched_domain_level authorized_nomination_level;
> 
>  authorized_nomination_level = SD_LV_NONE;

I think find_busiest_group() needs to be split up into several 
helper functions first, before we add more to it. I.e. first a 
couple of cleanup patches that factor it out into 3-4 helper 
functions plus a really easy-to-read find_busiest_group() main 
function.

Then can we do the above change - and i bet we'll win at least 
one indentation level as well so that weird line break goes 
away.

	Ingo
