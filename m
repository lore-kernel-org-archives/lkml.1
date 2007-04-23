Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbXDWWnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbXDWWnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbXDWWnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:43:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47092 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbXDWWnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:43:10 -0400
Date: Tue, 24 Apr 2007 04:11:42 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Message-ID: <20070423224142.GA30024@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com> <200704222139.27128.rjw@sisk.pl> <20070423222358.GA627@tv-sign.ru> <200704240040.18312.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704240040.18312.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 12:40:17AM +0200, Rafael J. Wysocki wrote:
> On Tuesday, 24 April 2007 00:23, Oleg Nesterov wrote:
> > On 04/22, Rafael J. Wysocki wrote:
> > > 
> > > Move all of the freezer-related flags to a separate field in task_struct and
> > > introduce functions to operate them using set_bit() etc.
> > >
> > > [...snip...]
> > >
> > > --- linux-2.6.21-rc6-mm1.orig/kernel/fork.c	2007-04-22 19:37:42.000000000 +0200
> > > +++ linux-2.6.21-rc6-mm1/kernel/fork.c	2007-04-22 20:55:01.000000000 +0200
> > > @@ -922,7 +922,7 @@ static inline void copy_flags(unsigned l
> > >  {
> > >  	unsigned long new_flags = p->flags;
> > >  
> > > -	new_flags &= ~(PF_SUPERPRIV | PF_NOFREEZE);
> > > +	new_flags &= ~PF_SUPERPRIV;
> > >  	new_flags |= PF_FORKNOEXEC;
> > >  	new_flags |= PF_STARTING;
> > >  	p->flags = new_flags;
> > 
> > OK, but you forgot to clear p->freezer_flags on copy_process()->dup_task_struct()
> > path ?
> 
> Yes, thanks for pointing that out.

That reminds me, shouldn't we set the child's TFF_FREEZE flag if the parent
is freezing or frozen? 

> 
> Should I clear it in dup_task_struct() or is there a better place?

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
