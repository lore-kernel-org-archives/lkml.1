Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbXGEWE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbXGEWE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760779AbXGEWEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:04:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54277 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760001AbXGEWEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:04:50 -0400
Date: Fri, 6 Jul 2007 00:04:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oliver@neukum.org, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070705220444.GD3881@elf.ucw.cz>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > > I have discussed the benefits elsewhere.  As for the deadlocks -- do 
> > > > > > you still observe them if you use the version of the freezer which 
> > > > > > doesn't freeze kernel threads?
> > > > > 
> > > > > In general the only way to guarantee there are no deadlocks is to
> > > > > construct the graph of dependencies between tasks.  Those dependencies
> > > > > are not in practice observable from outside the tasks, so it is
> > > > > virtually impossible to construct the graph.
> > > > 
> > > > In which way can user space tasks depend on each other in a way that
> > > > allows a them members of that cycle to be in uninterruptible sleep?
> > > 
> > >  - process A calls rename() on a fuse fs
> > >  - process B, the fuse server, starts to process the rename request
> > >  - process B is frozen before it can reply
> > > 
> > > Now process A is unfreezable.  We cannot make rename() restartable,
> > > hence it cannot be interruptible.
> > 
> > Yes, we are claiming fuse is very special in this regard, and perhaps
> > even broken.
> > 
> > Let's see. If I SIGSTOP the fuse server, I can get unrelated tasks
> > unkillable (even for SIGKILL!) forever.
> 
> Actually fuse allows SIGKILL, because it's always fatal, and the
> syscall may not be restarted.

Okay, and you should handle refrigerator in the same paths where you
handle SIGKILL. Just add try_to_freeze() there...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
