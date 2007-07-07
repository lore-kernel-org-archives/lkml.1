Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbXGGL5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbXGGL5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 07:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbXGGL4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 07:56:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38281 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753964AbXGGL4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 07:56:17 -0400
Date: Sat, 7 Jul 2007 13:50:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rjw@sisk.pl, mjg59@srcf.ucam.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Message-ID: <20070707115047.GE2789@elf.ucw.cz>
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <200707051704.48137.rjw@sisk.pl> <20070705150301.GB23647@srcf.ucam.org> <200707051727.36715.rjw@sisk.pl> <E1I6TJq-000164-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I6TJq-000164-00@dorka.pomaz.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > You have processes that don't react to signals, because some
> > > > other user land task is misbehaving.  I'd call that ugly at the
> > > > very least.
> > > 
> > > It already happens with, say, NFS. Don't think about it in terms of a 
> > > userland task misbehaving - think of it in terms of a resource becoming 
> > > unavailable.
> > 
> > I think there's a difference between a userland task playing the role of a
> > resource and a "real" external resource the kernel doesn't control.
> > 
> > IMO, userland tasks should not have the power to affect each other as though
> > they were parts of the kernel.
> 
> One task doing ptrace() can basically do whatever it wants with the
> task being traced.  This is not an exact analogy to what fuse does,
> but close.

Well, IMO userland tasks should not have power to grab VFS mutexes for
indefinite ammount of time. ("fused is allowed to deadlock kernel, in
a way only write to special file helps" is ugly). Unfortunately, I
don't think there's a way to work around that deadlock within fuse
design limits... (coda was able to get around it by working on whole
files granularity, AFAICT), so we'll have to live with that.

I think we have two separate problems here, and both are
solvable, without major changes to fuse or suspend framework.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
