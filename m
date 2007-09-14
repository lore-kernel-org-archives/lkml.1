Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbXINMEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbXINMEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXINMD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:03:58 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3601 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbXINMD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:03:57 -0400
Date: Fri, 14 Sep 2007 14:04:28 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
In-Reply-To: <1189703165.21778.258.camel@twins>
Message-ID: <Pine.LNX.4.64.0709141352430.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu>  <Pine.LNX.4.64.0709120242040.1817@scrub.home>
  <20070913075258.GA9173@elte.hu>  <Pine.LNX.4.64.0709131419170.1817@scrub.home>
  <20070913142842.GA26016@elte.hu>  <Pine.LNX.4.64.0709131706100.1817@scrub.home>
 <1189703165.21778.258.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 13 Sep 2007, Peter Zijlstra wrote:

> On Thu, 2007-09-13 at 18:50 +0200, Roman Zippel wrote:
> 
> > I never claimed to understand every detail of CFS, I can _guess_ what 
> > _might_ have been intended, but from that it's impossible to know for 
> > certain how important they are. Let's take this patch fragment:
> > 
> 
> 	delta_fair = se->delta_fair_sleep;
> 
> we slept that much
> 
> > -       /*
> > -        * Fix up delta_fair with the effect of us running
> > -        * during the whole sleep period:
> > -        */
> > -       if (sched_feat(SLEEPER_AVG))
> > -               delta_fair = div64_likely32((u64)delta_fair * load,
> > -                                               load + se->load.weight);
> 
> if we would have ran we would not have been removed from the rq and the
> weight would have been: rq_weight + weight
> 
> so compensate for us having been removed from the rq by scaling the
> delta with: rq_weight/(rq_weight + weight)
> 
> > -       delta_fair = calc_weighted(delta_fair, se);
> 
> scale for nice levels

AFAICT the compensation part is already done by the scaling part, without 
the load part it largely mirrors what __update_stats_wait_end() does, i.e. 
it gets the same time as other tasks, which have been on the rq.

bye, Roman
