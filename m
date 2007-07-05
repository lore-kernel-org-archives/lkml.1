Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbXGEJSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbXGEJSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbXGEJSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:18:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57254 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758811AbXGEJSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:18:04 -0400
Date: Thu, 5 Jul 2007 11:18:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oliver@neukum.org, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070705091801.GB3084@elf.ucw.cz>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-07-05 10:17:17, Miklos Szeredi wrote:
> > > > I have discussed the benefits elsewhere.  As for the deadlocks -- do 
> > > > you still observe them if you use the version of the freezer which 
> > > > doesn't freeze kernel threads?
> > > 
> > > In general the only way to guarantee there are no deadlocks is to
> > > construct the graph of dependencies between tasks.  Those dependencies
> > > are not in practice observable from outside the tasks, so it is
> > > virtually impossible to construct the graph.
> > 
> > In which way can user space tasks depend on each other in a way that
> > allows a them members of that cycle to be in uninterruptible sleep?
> 
>  - process A calls rename() on a fuse fs
>  - process B, the fuse server, starts to process the rename request
>  - process B is frozen before it can reply
> 
> Now process A is unfreezable.  We cannot make rename() restartable,
> hence it cannot be interruptible.

Yes, we are claiming fuse is very special in this regard, and perhaps
even broken.

Let's see. If I SIGSTOP the fuse server, I can get unrelated tasks
unkillable (even for SIGKILL!) forever. That's very special, and maybe
even a FUSE bug. And that is also what makes FUSE special
w.r.t. s2ram.

So no, you can't claim "FUSE is just IPC". It is very special IPC.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
