Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0CCQsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:48:32 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43906 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755122Ab0CCQsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:48:25 -0500
Date: Wed, 3 Mar 2010 18:01:03 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sched: make runtime balancing code more EDF-friendly
Message-ID: <20100303170103.GR2490@gandalf.sssup.it>
References: <cover.1266931410.git.fabio@helm.retis>
 <61a4579f9c15818ee9c878d21b9db90480f16261.1266931410.git.fabio@helm.retis>
 <1267129706.22519.562.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267129706.22519.562.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-10-28)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <peterz@infradead.org>
> Date: Thu, Feb 25, 2010 09:28:26PM +0100
>
> On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> > +               stop = move_runtime(rt_rq, iter, weight, rt_period,
> > pull);
> > +               if (stop) {
> > +                       raw_spin_unlock(&iter->rt_runtime_lock);
> > +                       break;
> >                 }
> >  next:
> >                 raw_spin_unlock(&iter->rt_runtime_lock); 
> 
> might as well put that:
> 
>   if (stop)
>     break;
> 
> right after the raw_spin_unlock() that's already there.

Will do (initializing stop to false before entering the loop), thanks.
