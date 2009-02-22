Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZBVOQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZBVOQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 09:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbZBVOPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 09:15:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46242 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZBVOPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 09:15:49 -0500
Date: Sun, 22 Feb 2009 15:15:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Jan Kara <jack@suse.cz>,
       Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
Message-ID: <20090222141532.GC1586@ucw.cz>
References: <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp> <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <20090212212304.GA7935@duck.suse.cz> <499494E2.3060006@redhat.com> <20090213022336.GH6922@mini-me.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213022336.GH6922@mini-me.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-02-12 21:23:36, Theodore Tso wrote:
> On Thu, Feb 12, 2009 at 03:30:10PM -0600, Eric Sandeen wrote:
> > >   Yes, but OTOH we should give sysadmin a possibility to enable / disable
> > > it on just some partitions. I don't see a reasonable use for that but people
> > > tend to do strange things ;) and here isn't probably a strong reason to not
> > > allow them.
> > > 
> >
> > But nobody has asked for that, have they?  So why offer it up a this point?
> > 
> > They could use LD_PRELOAD to make fsync a no-op if they really don't
> > care for it, I guess... though that's not easily per-fs either.
> 
> Actually, Bart Samwel at FOSDEM talked to me and asked for something
> similar --- what we came up which meant his request while still being
> standards-compliant was a per-process personality flag which had three
> options:
> 
>      *)  Always honor fsync() calls (the default)
>      *)  Never honor fsync() calls
>      *)  Only honor fsync() calls if a global "honor fsync" flag
>            (which would be manipulated by the laptop mode scripts)
> 	   is set.
> 
> The flag would be reset to the default across a setuid exec, but would
> otherwise be inherited across fork()'s.  It might be possible to
> set/get the flag via a /proc interface.
> 
> The basic idea is that laptop systems where the system administrator
> wants longer battery life (and trusts the battery not to suddenly give
> out) more than they care about fsync() guarantees can set up a pam
> library which sets the flag for at login time so that all of the
> user's processes can be set up not to honor fsync() calls; however,
> all of the system daemons would still function normally.   

Sounds like posix violation to
me... '/sys/fsync_does_not_really_sync'?

Perhaps it is better done at glibc level? Environment variables
already mostly have semantics you want.....

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
