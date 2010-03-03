Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0CCQq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:46:29 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43692 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754865Ab0CCQq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:46:26 -0500
Date: Wed, 3 Mar 2010 17:59:04 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sched: use EDF to schedule groups
Message-ID: <20100303165904.GL2490@gandalf.sssup.it>
References: <cover.1266931410.git.fabio@helm.retis>
 <4aed689fbdd9a7e4c625d4dd4f85533ec61722ef.1266931410.git.fabio@helm.retis>
 <1267129700.22519.557.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267129700.22519.557.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-10-28)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <peterz@infradead.org>
> Date: Thu, Feb 25, 2010 09:28:20PM +0100
>
> On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> > @@ -36,7 +29,8 @@ static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
> >  
> >  static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
> >  {
> > -       return container_of(rt_rq, struct rq, rt);
> > +       struct rt_root_rq *rt = container_of(rt_rq, struct rt_root_rq, rt_rq);
> > +       return container_of(rt, struct rq, rt);
> >  } 
> 
> I think you can write that double container_of() as a single:
> 
>  return container_of(rt_rq, struct rq, rt.rt_rq);
> 

I'll fix it, thanks.
