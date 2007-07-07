Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbXGGMRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbXGGMRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 08:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbXGGMRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 08:17:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37270 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753042AbXGGMRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 08:17:43 -0400
Date: Sat, 7 Jul 2007 14:17:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oliver@neukum.org, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070707121729.GC3111@elf.ucw.cz>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Actually fuse allows SIGKILL, because it's always fatal, and the
> > > syscall may not be restarted.
> > 
> > I think you want to stick try_to_freeze() at the same places where you
> > do SIGKILL handling. That should solve the 'syslogd is unfreezeable'
> > problem.
> 
> I could, but it would not solve the general problem.  Namely, that the
> presence of fuse imposes a certain ordering in which userspace tasks
> have to be frozen.  And it is not possible to know this ordering.

We can just wait for all fuse requests to be serviced before
proceeding further with freeze, right?

> And even if the ordering were solved, the freezer would still not work
> if the filesystem is not responding due to external events, such as a
> lost network (this affects NFS, CIFS, whatever just the same as
> fuse).

That's ok, you can't suspend if your hdd is dead, and in the same way
you can't suspend if your NFS server is dead. I agree it is ugly, but
we seem to live ok with that.

We could (and should?) handle that, probably by realizing that NFS is
not a disk and using interruptible sleep, but...

> > Plus, it would be nice to find out where suspend/hibernation is
> > triggering fuse activity. We can then decide where to fix it -- in
> > fuse or in suspend parts. You said sys_sync is not implemented... so
> > where is the problem?
> 
> I cannot say without having a sysrq-t of the situation.

Yes please. Can someone affected please produce sysrq-t?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
