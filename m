Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbZIYUtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbZIYUtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 16:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZIYUta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 16:49:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34271 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbZIYUta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 16:49:30 -0400
Date: Fri, 25 Sep 2009 22:49:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
	(Was: Re: [PATCH] Remove broken by design and by implementation
	devtmpfs maintenance disaster)
Message-ID: <20090925204925.GA4726@elf.ucw.cz>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org> <20090917185306.GA28635@elte.hu> <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com> <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain> <20090917203113.GA9530@elte.hu> <20090918055843.GB7104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918055843.GB7104@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > I've reproduced a bug with the following .config options:
> > > > >
> > > > > ??CONFIG_DEVTMPFS=y
> > > > > ??CONFIG_DEVTMPFS_MOUNT=y
> > > > >
> > > > > /dev/null and /dev/zero are not read/writable to ordinary users, 
> > > > > breaking normal bootup and login:
> > > > 
> > > > Udev should run long before some ordinary/non-root user can login, 
> > > > and apply the permissions as it always does. It's known to work on 
> > > > Fedora, SUSE, Ubuntu. What kind of system/environment/setup is that 
> > > > where you see this?
> > > 
> > > I don't know if this is what Ingo does, but I have a few machines 
> > > where I don't run the distro-supplied 'initrd' at all, because it's 
> > > easier to boot without it. The Fedora initrd doesn't allow me to 
> > > sanely set root filesystem parameters without totally rewriting the 
> > > initrd image, which I'm not interested in, for example (they'll take 
> > > effect for the root initrd, not the final root).
> > 
> > Correct: i'm booting raw bzImages, with /dev copied to the real /dev. To 
> > this box udev is mostly an annoyance that slows down my bootup ;-)
> 
> I use non-initrd systems as well, and this option works for me on Gentoo
> and SUSE machines.
> 
> As you are using a very old udev, and the boot infrastructure for udev
> in older Fedora releases was a bit "odd" in places, I would recommend
> not using these options on that machine.  If we need to reword the
> Kconfig help option to make it a bit more clear, do you have a
> suggestion on what we should change?

"no regressions" ?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
