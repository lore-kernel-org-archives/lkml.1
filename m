Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbXENUYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbXENUYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXENUYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:24:43 -0400
Received: from assei2bl6.telenet-ops.be ([195.130.133.69]:50885 "EHLO
	assei2bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759925AbXENUYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:24:42 -0400
Date: Mon, 14 May 2007 22:24:29 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: undefined reference to `__clear_user' (was: Re: [patch 2/13]
 signal/timer/event fds v10 - signalfd core ...)
In-Reply-To: <20070513034442.52f81fff.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705142224080.21397@anakin>
References: <Pine.LNX.4.64.0704021555430.26489@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0705131222410.2271@anakin> <20070513034442.52f81fff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007, Andrew Morton wrote:
> On Sun, 13 May 2007 12:28:23 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Mon, 2 Apr 2007, Davide Libenzi wrote:
> > > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > > +++ linux-2.6.21-rc5.fds/fs/signalfd.c	2007-04-02 15:06:29.000000000 -0700
> > 
> > > +/*
> > > + * Copied from copy_siginfo_to_user() in kernel/signal.c
> > > + */
> > > +static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
> > > +			     siginfo_t const *kinfo)
> > > +{
> > > +	long err;
> > > +
> > > +	BUILD_BUG_ON(sizeof(struct signalfd_siginfo) != 128);
> > > +
> > > +	/*
> > > +	 * Unused memebers should be zero ...
> > > +	 */
> > > +	err = __clear_user(uinfo, sizeof(*uinfo));
> >               ^^^^^^^^^^^^
> > 
> > Shouldn't this be `clear_user()'? I don't see any access_ok() calls
> > before this call (I do see them in copy_siginfo_to_user() in
> > kernel/signal.c), but of course I may miss something...
> > 
> > I only noticed because m68k doesn't have __clear_user(), as this routine
> > was never needed by generic code before your change.
> 
> The vfs does the access_ok() checking on entry to read, write, readv,
> writev, pread and pwrite.
> 
> I _think_ that covers everything, in which case all the code which
> implements reading and writing can use the __ functions.  We have a lot of
> code which doesn't avail itself of that optimisation though: 12 zillion
> sysfs and proc handlers, for a start.
> 
> (I think.  I only recently noticed this and might have missed a path).

OK, in that case, I'll add __clear_user().

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
