Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYKOQ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYKOQ7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 11:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYKOQ7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 11:59:11 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50551 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751476AbYKOQ7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 11:59:10 -0500
Date: Sat, 15 Nov 2008 17:58:51 +0100
From: Pavel Machek <pavel@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: stern@rowland.harvard.edu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
Message-ID: <20081115165851.GA1523@ucw.cz>
References: <Pine.LNX.4.44L0.0810300943001.2401-100000@iolanthe.rowland.org> <E1KvYgR-0002Cx-AZ@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KvYgR-0002Cx-AZ@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > I don't know.  There are other interfaces too, like sysfs attributes, 
> > > > that would have to be handled specially.  On the whole, the freezer 
> > > > seems much, much simpler.
> > > 
> > > OK, then non-device files on "regular" filesystems.
> > 
> > Would you like to write a first-pass patch?  I don't think it will 
> > work.
> 
> If somebody doesn't beat me to it, I'll do that (first implemented
> with a global rw-sem).

Cool!
l
> > Doing that seems like a lot of work, just as modifying every driver 
> > does.  Changing a few kernel entry points is simpler, but I'm pretty
> > sure it won't work.  For instance, tasks can block arbitrarily long on 
> > read calls (waiting for data to arrive); you can't allow such things to 
> > prevent the system from suspending.
> 
> But we already do: either
> 
>  a) it's in interruptible sleep (I/O on sockets, pipes, etc), and
>     freezing simply interrupts it, or
> 
>  b) it's in uninterruptible sleep and suspend will wait it out (or
>     time out).
> 
> In the new scheme we could retain that part of the freezer: interrupt
> all tasks which are inside the critical region and wait for them to
> exit the critical region.
> 
> To put it in another way: it's still the freezer, it does all the same
> things as the old freezer, except that the condition for freezing is
> not that the task is out of the kernel, rather that it's out of the
> disable_supend - enable_suspend region.  As such it's not a big change
> to the whole suspend system, and so there shouldn't be anything big
> going wrong there.

Disadvantage is it will add overhead to regular syscalls, at least
initialy. That's why I implemented freezer initialy...

Of course, suspend is more important than it was back then, and
disadvantages of freezer are now well known, so maybe a little
overhead in exchange of cleaner design is worth it...?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
