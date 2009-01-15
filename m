Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbZAONPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbZAONPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZAONPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:15:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868AbZAONPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:15:25 -0500
Date: Thu, 15 Jan 2009 14:15:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Brian Rogers <brian@xyzw.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] How to get real-time priority using idle priority
Message-ID: <20090115131514.GF21839@elte.hu>
References: <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu> <496BE8F6.1040308@xyzw.org> <1232011723.26761.36.camel@marge.simson.net> <1232014456.8870.26.camel@laptop> <1232015423.13856.5.camel@marge.simson.net> <1232019428.5720.8.camel@marge.simson.net> <1232019686.8870.45.camel@laptop> <20090115125451.GB21839@elte.hu> <1232024701.8870.47.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232024701.8870.47.camel@laptop>
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

> On Thu, 2009-01-15 at 13:54 +0100, Ingo Molnar wrote:
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -283,10 +283,7 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
> >                                                    struct sched_entity,
> >                                                    run_node);
> >  
> > -               if (vruntime == cfs_rq->min_vruntime)
> > -                       vruntime = se->vruntime;
> > -               else
> > -                       vruntime = min_vruntime(vruntime, se->vruntime);
> > +               vruntime = min_vruntime(vruntime, se->vruntime);
> >         }
> >  
> >         cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
> 
> That's wrong

Please send a patch that makes it right, the twists and turns of patches 
in this thread is quite confusing so i probably picked up the 
last-but-good one. Thanks,

	Ingo
