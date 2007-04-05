Return-Path: <linux-kernel-owner+w=401wt.eu-S2992502AbXDELbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992502AbXDELbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 07:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992511AbXDELbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 07:31:15 -0400
Received: from mail.screens.ru ([213.234.233.54]:39203 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992502AbXDELbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 07:31:15 -0400
Date: Thu, 5 Apr 2007 15:30:55 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 1/8] Enhance process freezer interface for usage beyond software suspend
Message-ID: <20070405113055.GA729@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402053705.GA12962@in.ibm.com> <20070405094633.GA609@tv-sign.ru> <20070405105923.GB16173@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405105923.GB16173@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05, Gautham R Shenoy wrote:
>
> On Thu, Apr 05, 2007 at 01:46:33PM +0400, Oleg Nesterov wrote:
> > 
> > > --- linux-2.6.21-rc5.orig/kernel/sched.c
> > > +++ linux-2.6.21-rc5/kernel/sched.c
> > > @@ -5057,6 +5057,7 @@ static int migration_thread(void *data)
> > >  	BUG_ON(rq->migration_thread != current);
> > >
> > >  	set_current_state(TASK_INTERRUPTIBLE);
> > > +	freezer_exempt(FE_ALL);
> > 
> > This is a real nitpick, but it was hard to me to understand this change.
> > Because it looks as if we have a subtle reason to set TASK_INTERRUPTIBLE
> > before freezer_exempt(). Unless I missed something, I'd suggest to move
> > freezer_exempt() up, before set_current_state().
> > 
> > The same for apm_mainloop().
> 
> Ok, no subtle reasons for freezer_exempt()ing after set_current_state().
> So no problems changing the order. But (just curious), is there any specific
> problem with this particular order ?

No, no, it was just a nitpick :) May be this is just me, but when I see the
code like

	set_current_state(TASK_XXX);
	something_which_doesnt_need_TASK_XXX();

, I can't read the code further, trying to understand where I was wrong
and why do we need to change task->state here.

Oleg.

