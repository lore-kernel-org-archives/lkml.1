Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbXIMRKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbXIMRKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 13:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760425AbXIMRJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 13:09:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34576 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760138AbXIMRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 13:09:51 -0400
Subject: Re: [announce] CFS-devel, performance improvements
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1189703165.21778.258.camel@twins>
References: <20070911200459.GA6974@elte.hu>
	 <Pine.LNX.4.64.0709120242040.1817@scrub.home>
	 <20070913075258.GA9173@elte.hu>
	 <Pine.LNX.4.64.0709131419170.1817@scrub.home>
	 <20070913142842.GA26016@elte.hu>
	 <Pine.LNX.4.64.0709131706100.1817@scrub.home>
	 <1189703165.21778.258.camel@twins>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 19:09:42 +0200
Message-Id: <1189703382.21778.260.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 19:06 +0200, Peter Zijlstra wrote:
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
> 

Or at least, I think that is how to read it :-)

