Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYBPVpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYBPVpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 16:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbYBPVpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 16:45:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47077 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbYBPVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 16:45:24 -0500
Subject: Re: [PATCH 2/3] sched: trivial sparse warning in sched.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080216212747.GC6753@cvg>
References: <1203098196.15275.5.camel@brick>
	 <1203196289.6301.20.camel@lappy>  <20080216212747.GC6753@cvg>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 22:45:14 +0100
Message-Id: <1203198314.6298.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-17 at 00:27 +0300, Cyrill Gorcunov wrote:
> [Peter Zijlstra - Sat, Feb 16, 2008 at 10:11:29PM +0100]
> | 
> | On Fri, 2008-02-15 at 09:56 -0800, Harvey Harrison wrote:
> | > kernel/sched.c:3680:3: warning: returning void-valued expression
> | 
> | I'm wondering,... why is this wrong?
> | 
> | > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> | > ---
> | >  kernel/sched.c |    6 ++++--
> | >  1 files changed, 4 insertions(+), 2 deletions(-)
> | > 
> | > diff --git a/kernel/sched.c b/kernel/sched.c
> | > index f28f19e..824d5a9 100644
> | > --- a/kernel/sched.c
> | > +++ b/kernel/sched.c
> | > @@ -3676,8 +3676,10 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
> | >  	struct rq *rq = this_rq();
> | >  	cputime64_t tmp;
> | >  
> | > -	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0))
> | > -		return account_guest_time(p, cputime);
> | > +	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
> | > +		account_guest_time(p, cputime);
> | > +		return;
> | > +	}
> | >  
> | >  	p->stime = cputime_add(p->stime, cputime);
> | >  
> 
> Hi Peter,
> 
> dont you find 'return (void)foo();' statement a bit strange (as it was in
> original code)? ;) Am I wrong? /it's night here, so half a brain already
> tuned off ;)/

void foo(void);

void bar(void)
{
	return foo();
}

Maybe I'm just weird an twisted, but no, I don't find it odd. In my mind
its consistent with how all other return types function.

Not sure what the C std text says on the matter though.


