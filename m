Return-Path: <linux-kernel-owner+w=401wt.eu-S1760710AbYAaOk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbYAaOk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYAaOkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:40:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55722 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754602AbYAaOkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:40:15 -0500
Date: Thu, 31 Jan 2008 15:40:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
Message-ID: <20080131144030.GC983@elf.ucw.cz>
References: <47A0CD90.5080208@msgid.tls.msk.ru> <200801302211.10622.rjw@sisk.pl> <47A10886.5050707@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A10886.5050707@msgid.tls.msk.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  o 2.6.24 kernel fails to suspend properly.  It "saves pages",
>    prints "Suspending console", when prints "Sl" and nothing
>    more happens.  At this time, I can manually poweroff the
>    machine, and resume works.  The same happens when running
>    32bits or 64bits kernel (it's an amd x2-64 system).

Patch welcome, it certainly works here.

>  o uswsusp is unaware of 64bits kernel and 32bits userland.
>    Looking at the source, that's probably (and for sure in
>    certain places) more than just missing compat_ioctl wrappers
>    for those:
> 
>   ioctl32(s2disk:3574): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12} arg(ffa4578c) on /dev/snapshot
>   ioctl32(s2disk:3574): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} arg(00000805) on /dev/snapshot
> 
>    "probably" is where it reads the swap space - it's just
>    my guess that s2disk (and resume) will do some wrong here.
>    "for sure" is vbe code - since 32bits vbetools package
>    fails badly with 64bit kernel, it seems that it is looking
>    at the wrong place in /dev/mem.

Hmm.. yes, it would be nice to fix that.

> It's sad when while working on something you discover that
> "underlying" tools you use also don't work, and start fixing
> those, when discover that something else fails, and so on,
> until you finally gave up and abandom the whole initial
> idea...  Oh well, but c'est la vie...

:-).

> Back to the original question and a proposed solution.
> 
> I'm looking at the uswsusp source (while the kernel compiles),
> and have a question here.  Is it possible to call some external
> application (typically a shell script) to do the final work after
> when the image has been written?  I mean in principle - I
> understand there are some limitations here, but I don't know
> which exactly.

No, you can't exec() anything. That would write mtime back to disk and
cause badness.

> For the given task (send some command to the damn UPS),
> it typically involves writing/reading something to/from
> a given serial port (/dev/ttySxx), or to an USB device,
> or to a network -- depending on the UPS in use.  There
> are so many different UPSes out there, with so many different
> and stupid so-called "protocols", that it's impossible to
> teach s2disk about them all.

Create libups.so, and link s2disk to it?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
