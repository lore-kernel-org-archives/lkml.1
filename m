Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbYBXUK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbYBXUK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 15:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYBXUKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 15:10:48 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55163 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752525AbYBXUKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 15:10:47 -0500
Date: Sun, 24 Feb 2008 21:11:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Message-ID: <20080224201105.GC18908@elf.ucw.cz>
References: <20080224182120.GB3886@ucw.cz> <Pine.LNX.4.44L0.0802241358080.11145-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802241358080.11145-100000@netrider.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > @@ -25,6 +25,7 @@
> > >  #include <linux/pm.h>
> > >  #include <linux/resume-trace.h>
> > >  #include <linux/rwsem.h>
> > > +#include <linux/sched.h>
> > >  
> > >  #include "../base.h"
> > >  #include "power.h"
> > > @@ -59,6 +60,13 @@ static DECLARE_RWSEM(pm_sleep_rwsem);
> > >  
> > >  int (*platform_enable_wakeup)(struct device *dev, int is_on);
> > >  
> > > +static struct task_struct *suspending_task;
> > 
> > What locking protects this variable? What happens when suspending_task
> > exits? (Hmm, that would probably be bug, anyway?)
> 
> It's protected by whatever existing locking scheme allows only one
> task to start a system sleep at a time.  For example, the suspending 
> task has to get a write lock on pm_sleep_rwsem.

And readers of suspending_task are protected by?

At the very least, you'd need rmb() before reading it and wmb() after
writing to it, but I'm not sure if that's enough on every obscure
architecture out there.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
