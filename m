Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbXE3Ltn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbXE3Ltn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbXE3Ltf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:49:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42956 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751795AbXE3Lte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:49:34 -0400
Date: Wed, 30 May 2007 13:49:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>, Mark Lord <lkml@rtr.ca>,
       Romano Giannetti <romanol@upcomillas.es>,
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
Message-ID: <20070530114920.GB26326@elf.ucw.cz>
References: <1180058123.3997.91.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org> <1180059605.3997.100.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org> <1180062040.3997.112.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org> <1180067587.3997.136.camel@nigel.suspend2.net> <465C366C.2070900@rtr.ca> <1180473765.20718.47.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705291428410.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705291428410.26602@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > How about blocking brk() and mmap(MAP_ANONYMOUS) in addition to
> > > the filesystem VFS callers?   Or is that starting to get messy again?
> > 
> > Yeah. Getting messy again :)
> 
> Indeed. And also misses the point - the point being that we don't actually 
> need to freeze anything at all most of the time. There's nothing wrong 
> with making memory allocations etc.
> 
> And yes, suspend is different from hibernate. I can see how hibernate 
> people are worried about people writing to things after doing the 
> snapshot, but those concerns don't exist with suspend. With suspend, the 
> biggest concern is accessing a device after it has been suspended, but on 
> the other hand, also the fact that we end up having driver writers used 
> to the system being "runnable", so they do things that really do require a 
> full-fledged system (and sometimes that means just some delayed action 
> using a kernel thread, other times it seems to rely on more complex 
> behaviour like firmware loading :^p )

Notice that we want to be able to suspend while hibernating -- for
suspend to both behaviour. So drivers may _not_ rely on system being
runnable.

(Suspend to both is: write image to disk, then suspend to RAM. If you
do not run out of battery, resume is from RAM and fast, if you do, you
still can do resume from disk, not loosing your data).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
