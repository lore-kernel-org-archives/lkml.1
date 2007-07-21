Return-Path: <linux-kernel-owner+w=401wt.eu-S933278AbXGUBAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbXGUBAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762486AbXGUBAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:00:45 -0400
Received: from web.n-guiza.net ([67.15.10.95]:36225 "EHLO web.n-guiza.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762522AbXGUBAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:00:44 -0400
X-Greylist: delayed 139099 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 21:00:44 EDT
Date: Fri, 20 Jul 2007 22:00:15 -0300
From: Diego Woitasen <diegows@lanux.org.ar>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Diego Woitasen <diego@woitasen.com.ar>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the tsk argument in init_new_context()
Message-ID: <20070721010014.GA5503@motherbox.xtechq.com.ar>
References: <1183946108509-git-send-email-diego@woitasen.com.ar> <20070719174238.fab0d079.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719174238.fab0d079.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - web.n-guiza.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - lanux.org.ar
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 05:42:38PM -0700, Andrew Morton wrote:
> On Sun,  8 Jul 2007 22:55:08 -0300
> Diego Woitasen <diego@woitasen.com.ar> wrote:
> 
> > Signed-off-by: Diego Woitasen <diego@woitasen.com.ar>
> > ---
> >  arch/i386/kernel/ldt.c   |    2 +-
> >  arch/x86_64/kernel/ldt.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/i386/kernel/ldt.c b/arch/i386/kernel/ldt.c
> > index e0b2d17..c2eb4fb 100644
> > --- a/arch/i386/kernel/ldt.c
> > +++ b/arch/i386/kernel/ldt.c
> > @@ -96,7 +96,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
> >  
> >  	init_MUTEX(&mm->context.sem);
> >  	mm->context.size = 0;
> > -	old_mm = current->mm;
> > +	old_mm = tsk->mm;
> >  	if (old_mm && old_mm->context.size > 0) {
> >  		down(&old_mm->context.sem);
> >  		retval = copy_ldt(&mm->context, &old_mm->context);
> > diff --git a/arch/x86_64/kernel/ldt.c b/arch/x86_64/kernel/ldt.c
> > index bc9ffd5..99a92ed 100644
> > --- a/arch/x86_64/kernel/ldt.c
> > +++ b/arch/x86_64/kernel/ldt.c
> > @@ -100,7 +100,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
> >  
> >  	init_MUTEX(&mm->context.sem);
> >  	mm->context.size = 0;
> > -	old_mm = current->mm;
> > +	old_mm = tsk->mm;
> >  	if (old_mm && old_mm->context.size > 0) {
> >  		down(&old_mm->context.sem);
> >  		retval = copy_ldt(&mm->context, &old_mm->context);
> 
> 
> When called from dup_mm(), `tsk' refers to the new task and `current'
> refers to the old one.  I'd have expected this to crash during your testing?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Yes, sorry... that patch is bad. Now my question is, why all
architectures have the task argument and neither use it? I undertand now
that init_new_context() work with current but what about the *tsk arg.



-- 

--------------
Diego Woitasen
