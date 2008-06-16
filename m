Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbYFPNwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbYFPNwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFPNwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:52:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:49099 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYFPNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:52:00 -0400
Subject: Re: [BUG: NULL pointer dereference] cgroups and RT
	scheduling	interact badly.
From: Peter Zijlstra <peterz@infradead.org>
To: "Daniel K." <dk@uw.no>
Cc: mingo@elte.hu, menage@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4856671B.1020304@uw.no>
References: <485445AE.2010602@uw.no> <1213612447.16944.99.camel@twins>
	 <4856671B.1020304@uw.no>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 15:51:52 +0200
Message-Id: <1213624312.16944.104.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 15:14 +0200, Daniel K. wrote:
> Peter Zijlstra wrote:
> > Does the below work for you?
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -7784,7 +7784,6 @@ static void init_tg_rt_entry(struct task
> >  	else
> >  		rt_se->rt_rq = parent->my_q;
> >  
> > -	rt_se->rt_rq = &rq->rt;
> >  	rt_se->my_q = rt_rq;
> >  	rt_se->parent = parent;
> >  	INIT_LIST_HEAD(&rt_se->run_list);
> 
> Although this patch seems to be correct, this is what shows up on my
> netconsole, when applying it -- with an offset, do you have other fixes
> applied as well?

I had indeed, although nothing touching the rt scheduler. I popped all
my patches and pulled an update from Linus, but I fail to reproduce the
below.

/me goes look for that burnp6 thing, I used a simple while (1); loop.


