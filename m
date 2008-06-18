Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbYFRI1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbYFRI1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 04:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYFRI1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 04:27:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37730 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbYFRI1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 04:27:15 -0400
Date: Wed, 18 Jun 2008 10:26:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080618082651.GF4135@elte.hu>
References: <48493CBD.1000202@sgi.com> <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com> <19f34abd0806060707x7570c835u4b1837b54dfa36ba@mail.gmail.com> <484947A9.5050804@sgi.com> <19f34abd0806060736m10424455kfbc3e6272d18646e@mail.gmail.com> <20080606145717.GA5300@elte.hu> <20080606150102.GA14141@elte.hu> <19f34abd0806060813t10d422fel10dcb25c71f3b032@mail.gmail.com> <20080606152326.GA18359@elte.hu> <48495D4E.2070203@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48495D4E.2070203@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > 
> >>>> AFAICS this is not yet required for v2.6.26, as the requirement to 
> >>>> never iterate to MAX_NUMNODES and call nr_cpus_node() with the 
> >>>> index only got introduced by Mike's patch.
> >>> the one below is needed as well i think.
> >> Yeah. I think you had better take Mike's patches, I don't trust even 
> >> that my patch and your fixlet does everything correctly.
> > 
> > yep, just discovered that we had them already ;-)
> > 
> > Thomas has just scripted up a new "detect if a commit is not in 
> > linux-next yet" script that should avoid such problems in the future.
> > 
> > your second patch is still wanted, it would have detected the problem 
> > earlier.
> > 
> > 	Ingo
> 
> Thanks, yes, I agree.  However I would like to modify it slightly:
> ---
> Subject: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask
> 
>   * When CONFIG_DEBUG_PER_CPU_MAPS is set, the node passed to
>     node_to_cpumask and node_to_cpumask_ptr should be validated.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  arch/x86/kernel/setup.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> --- linux-2.6.tip.orig/arch/x86/kernel/setup.c
> +++ linux-2.6.tip/arch/x86/kernel/setup.c
> @@ -399,6 +399,10 @@ int early_cpu_to_node(int cpu)
>  	return per_cpu(x86_cpu_to_node_map, cpu);
>  }
>  
> +
> +/* empty cpumask */
> +static cpumask_t cpu_mask_none;

hm, this should be __read_mostly, maybe even const so that it becomes 
readonly?

	Ingo
