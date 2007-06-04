Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbXFDKqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbXFDKqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 06:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbXFDKq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 06:46:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48497 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752280AbXFDKq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 06:46:29 -0400
Date: Mon, 4 Jun 2007 12:46:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: A kexec approach to hibernation
Message-ID: <20070604104621.GB4405@elf.ucw.cz>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl> <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl> <87k5un9l4n.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5un9l4n.fsf@jbms.ath.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> But kernel threads also rely on userspace, due to e.g. fuse and usermode
> >> helpers.
> 
> > Yes, I know that and I think these issues are solvable within the current
> > approach.
> 
> It seems like it would be very hard to get writing of an image to a
> fuse filesystem working under the current scheme.
> 
> Trying to image a system while it is running seems fundamentally broken.
> As another example, I believe currently although devices are "quiesced"
> or stopped while the atomic snapshot is made, they are all then started
> again afterward while the image is written to disk.  As a result, the
> network drivers will continue acking TCP packets that are received after
> the snapshot, but these packets will be lost.
> 
> You might claim then that the solution is to simply keep the network
> driver quiesced or stopped.  But then it is impossible to write the
> image over the network.  The way to get around this problem is to write
> the image over the network using a fresh network stack.

The "fresh network stack" will RST any connections that were going,
which is ugly, too.

> >> Grub, its configuration, and the kernel used to resume the system had
> >> better be on a "safe" filesystem already (i.e. a separate, unmounted
> >> before hibernation /boot).
> 
> > Currently, you don't need to do that.
> 
> Some people get away with it, but fundamentally it is broken to do so.
> (The fact that the current software suspend implementations tell the
> filesystems to sync to disk increases its chances of working.)  You are
> accessing a filesystem that is in an unknown state.  Consider that the
> user might make a change to grub.conf, but the kernel caches the write.
> If the filesystem containing grub.conf is left mounted, the write might
> never reach disk before the system is hibernated.  As a result, when
> grub attempts to read it, it doesn't get the expected data.

sync is perfectly safe way of telling the fs to store data on disk.

> >> That is why I think the kexec solution is the elegant solution.
> 
> > Frankly, I think it's tricky. ;-)
> 
> To me, it seems a lot easier to get right than the current approaches.

Well, you are certainly welcome to create the patch. "suspend3" name
is still free, AFAICT.

If _I_ were willing to add some runtime overhead to make hibernation
simpler, I'd just use some virtualization to do that... with added
advantage of "hibernate here, resume on different hw".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
