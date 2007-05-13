Return-Path: <linux-kernel-owner+w=401wt.eu-S934439AbXEMQpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439AbXEMQpm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934423AbXEMQpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:45:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2558 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131AbXEMQpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:45:33 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 13 May 2007 09:44:43 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: undefined reference to `__clear_user' (was: Re: [patch 2/13]
 signal/timer/event fds v10 - signalfd core ...)
In-Reply-To: <20070513034442.52f81fff.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705130938570.2979@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0704021555430.26489@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0705131222410.2271@anakin> <20070513034442.52f81fff.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007, Andrew Morton wrote:

> On Sun, 13 May 2007 12:28:23 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > 	Hi Davide,
> > 
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
> > 
> 
> The vfs does the access_ok() checking on entry to read, write, readv,
> writev, pread and pwrite.

Maybe deserves a comment? Given that even Al "VFS" Viro missed that at 
first sight yesterday :)
Al was also mentioning that some archs (among them FRV, IIRC) do not 
have __clear_user, so we may want to align them to all the other ones.


- Davide


