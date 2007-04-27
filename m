Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbXD0QfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbXD0QfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbXD0QfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:35:10 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60127 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066AbXD0QfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:35:07 -0400
Date: Fri, 27 Apr 2007 22:03:47 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] Introduce freezer flags
Message-ID: <20070427163347.GD22639@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200704271737.31192.rjw@sisk.pl> <200704271740.17972.rjw@sisk.pl> <20070427161940.GB1046@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427161940.GB1046@uranus.ravnborg.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 06:19:40PM +0200, Sam Ravnborg wrote:
> On Fri, Apr 27, 2007 at 05:40:16PM +0200, Rafael J. Wysocki wrote:
> 
> > --- linux-2.6.21-rc7-mm2.orig/kernel/fork.c
> > +++ linux-2.6.21-rc7-mm2/kernel/fork.c
> > @@ -921,11 +921,14 @@ static inline void copy_flags(unsigned l
> >  {
> >  	unsigned long new_flags = p->flags;
> >  
> > -	new_flags &= ~(PF_SUPERPRIV | PF_NOFREEZE);
> > +	new_flags &= ~PF_SUPERPRIV;
> >  	new_flags |= PF_FORKNOEXEC;
> >  	if (!(clone_flags & CLONE_PTRACE))
> >  		p->ptrace = 0;
> >  	p->flags = new_flags;
> > +#ifdef CONFIG_FREEZER
> > +	p->freezer_flags = 0;
> > +#endif
> >  }
> Could we have a dedicated clear_freeze_flag() so we could drop the ifdef?
> 
> > +		clear_freeze_flag(p);

That means something else. clear_freeze_flag() just clears the 
TFF_FREEZE flag and not necessarily everything.

Besides, this is the only place where we would need to clear all the bits
of p->freezer_flags. Not sure if having a static inline helper function 
is worth it.

> 
> Or maybe we have it already?

We don't yet. But can if badly needed :-)
> 
> 
> 	Sam

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
