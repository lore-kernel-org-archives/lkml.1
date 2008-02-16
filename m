Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbYBPV2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbYBPV2c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 16:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbYBPV2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 16:28:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:17350 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbYBPV2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 16:28:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rtN65G37mQnRrxk7tIJ/he1KKYjSWUCFlKVWQUoUGtBunm8Nak6C5HuFmGpodq1oGXb8WRZ5sZHe8miygNQhkcYZjuAGBnDi7d1IC+084ypOdJ4MLHaWpyaKbMkNR67AWPv03W3TTkgZa46BrDOB67D16A9DssWDL0YB4XwyrTg=
Date: Sun, 17 Feb 2008 00:27:47 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: trivial sparse warning in sched.c
Message-ID: <20080216212747.GC6753@cvg>
References: <1203098196.15275.5.camel@brick> <1203196289.6301.20.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203196289.6301.20.camel@lappy>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Peter Zijlstra - Sat, Feb 16, 2008 at 10:11:29PM +0100]
| 
| On Fri, 2008-02-15 at 09:56 -0800, Harvey Harrison wrote:
| > kernel/sched.c:3680:3: warning: returning void-valued expression
| 
| I'm wondering,... why is this wrong?
| 
| > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
| > ---
| >  kernel/sched.c |    6 ++++--
| >  1 files changed, 4 insertions(+), 2 deletions(-)
| > 
| > diff --git a/kernel/sched.c b/kernel/sched.c
| > index f28f19e..824d5a9 100644
| > --- a/kernel/sched.c
| > +++ b/kernel/sched.c
| > @@ -3676,8 +3676,10 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
| >  	struct rq *rq = this_rq();
| >  	cputime64_t tmp;
| >  
| > -	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0))
| > -		return account_guest_time(p, cputime);
| > +	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
| > +		account_guest_time(p, cputime);
| > +		return;
| > +	}
| >  
| >  	p->stime = cputime_add(p->stime, cputime);
| >  

Hi Peter,

dont you find 'return (void)foo();' statement a bit strange (as it was in
original code)? ;) Am I wrong? /it's night here, so half a brain already
tuned off ;)/

		- Cyrill -
