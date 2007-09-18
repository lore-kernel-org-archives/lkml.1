Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbXIRIxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbXIRIxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXIRIxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:53:42 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:47265 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbXIRIxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:53:41 -0400
X-Greylist: delayed 2886 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 04:53:41 EDT
Message-ID: <38485.145.64.134.222.1190102719.squirrel@www.hardeman.nu>
In-Reply-To: <46EF7E82.8040503@gmx.net>
References: <46EF7DDA.2070401@gmx.net> <46EF7E82.8040503@gmx.net>
Date: Tue, 18 Sep 2007 10:05:19 +0200 (CEST)
Subject: Re: RFC: A revised timerfd API
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Michael Kerrisk" <mtk-manpages@gmx.net>
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Ulrich Drepper" <drepper@redhat.com>, geoff@gclare.org.uk,
       "lkml" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Hellwig" <hch@lst.de>, "Jonathan Corbet" <corbet@lwn.net>,
       "Randy Dunlap" <rdunlap@xenotime.net>, vda.linux@googlemail.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Lee Schermerhorn" <lee.schermerhorn@hp.com>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, September 18, 2007 09:30, Michael Kerrisk wrote:
> ====> b) Create a timerfd interface analogous to POSIX timers
>
> Create an interface analogous to POSIX timers:
> fd = timerfd_create(clockid, flags);
> timerfd_settime(fd, flags, newtimervalue, &time_to_next_expire);
> timerfd_gettime(fd, &time_to_next_expire);
...
> ====> c) Integrate timerfd with POSIX timers
>
> Make a very simple timerfd call that is integrated with the
> POSIX timers API.  The POSIX timers API is detailed here:
> http://linux.die.net/man/3/timer_create
> http://linux.die.net/man/3/timer_settime
>
> Under the POSIX timers API, a new timer is created using:
>
> int timer_create(clockid_t clockid, struct sigevent *evp,
>         timer_t *timerid);
>
> We could then have a timerfd() call that returns a file descriptor
> for the newly created 'timerid':
>
> fd = timerfd(timer_t timerid);

Wouldn't this remove some of the usefulness of the timerfd?

For example, if a timerfd is one of the fd's that is returned by a
epoll_wait syscall, you manually need to do the mapping between the
timerfd and the timerid in order to be able to modify the timer.

The advantage of solution b) above is that the fd is everything that is
needed to work with the timer. With solution c) you have to keep two
references to the same timer around and use one of them depending on what
you want to do with the timer.

Also, if the timerfd is close():d, does that remove the underlying timer
(invalidate the timerid) as well?

-- 
David Härdeman

