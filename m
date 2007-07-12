Return-Path: <linux-kernel-owner+w=401wt.eu-S932360AbXGLTtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbXGLTtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbXGLTtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:49:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2507 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755613AbXGLTtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:49:15 -0400
Date: Thu, 12 Jul 2007 15:31:12 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oliver@neukum.org, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Message-ID: <20070712153112.GB5139@ucw.cz>
References: <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu> <20070707121729.GC3111@elf.ucw.cz> <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu> <20070707233315.GB3820@elf.ucw.cz> <E1I7vx0-0002Fn-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I7vx0-0002Fn-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So you want me to handle _malicious_ filesystems now?
> > 
> > That should be easy... :-). You already have nasty deadlocks in FUSE,
> > and you solve them by "root can echo 1 > abort"... so allow me the
> > same possibility.
> > 
> > We can tell fused we are freezing, and if all the requests are not
> > serviced within, say, 30 seconds, we call the filesystem malicious and
> > do echo 1 > abort.
> > 
> > Not ideal, but neither is allowing malicious filesystems in the first
> > place...
> 
> Actually there's also a non-malicious case in which waiting for
> requests to finish won't work: when one fuse filesystem is accessing
> another.
> 
> Since we are blocking new fuse requests, that might block a fuse
> daemon, which in turn makes it impossible to finish the pending
> request.

Hmm, yes, this is ugly. But will it hurt? We'll just wait for number
of active fuse requests to go down to 0 before proceeding. It may
still livelock on system with busy fused-s, but we'll detect that with
timeout, and I believe it is 'don't do that' situation.

> And this is not at all theoretical, I know that encfs is used over
> various other fuse filesystems like sshfs or ntfs-3g.
> 
> Yeah, stacking userspace filesystems could be done entirely in
> userspace, and I'm actually working on that (with fuse-2.7.0 already
> supporting some basic stacking).

Great.

> But the point is, that the "wait for fuse to quiescence" hack would
> not work in todays environment.

Ok, I'll just blame fuse here. 'You have to write to /sys
files for SIGKILL to work' is not funny.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
