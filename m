Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbXEYJUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbXEYJUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbXEYJTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:19:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53907 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752321AbXEYJTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:19:54 -0400
Date: Fri, 25 May 2007 11:19:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Message-ID: <20070525091930.GI9604@elf.ucw.cz>
References: <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org> <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org> <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org> <20070524221743.GD9604@elf.ucw.cz> <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org> <20070524231852.GG9604@elf.ucw.cz> <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > 2) we need to preload firmware during _suspend_. I AM TELLING THAT TO
> > PEOPLE FOR FIVE YEARS NOW.
> 
> And people aren't listening. Have you thought about _why_?
> 
> The thing is, it should just work. Even without pre-loading.

But it does not work, and as you demonstrated, getting it to work w/o
preloading is awful lot of work. Feel free to send a patch. Unless you
are ready to do that, stop confusing driver authors.

> > Imageine we killed freezer. Also imagine Romano has IDE card his
> > PCMCIA slot. Kaboom, we solved nothing.
> 
> Don't be silly. We solved it. The firmware has to be loadable from 
> somewhere else, since otherwise his IDE card wouldn't have been accessible 
> in the first place! 

Firmware loader is complex userspace process. That's not silly. It is
userland, and I'd hate to explain to its authors detailed rules. 

It could do 'find / -name "pcmcia-card-firmware"' for example. It
could do dbus message to tell gnome-graphical-crap to display window
to say that it is loading firmware. Maybe it also writes to syslog
when syslogd is available.

It is userland process, so it is allowed to do stupid stuff.

[If you do not agree, please try to write up
"Doc*/what-firmware-loader-must-do.txt" -- at that point you should
realize how ugly the solution you are suggesting is.]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
