Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbXI0IfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbXI0IfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 04:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbXI0IfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 04:35:08 -0400
Received: from mail1.gclare.org.uk ([217.155.142.121]:1252 "EHLO
	squonk.masqnet" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752707AbXI0IfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 04:35:05 -0400
X-Greylist: delayed 802 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2007 04:35:04 EDT
Date: Thu, 27 Sep 2007 09:20:31 +0100
From: Geoff Clare <geoff@gclare.org.uk>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>,
       David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Man page for revised timerfd API
Message-ID: <20070927082031.GA20641@squonk.masqnet>
References: <46FA0657.20700@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FA0657.20700@gmx.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk-manpages@gmx.net> wrote, on 26 Sep 2007:
>
> .TH TIMERFD_CREATE 2 2007-09-26 Linux "Linux Programmer's Manual"
> .SH NAME
> timerfd_create, timerfd_settime, timer_gettime \-

s/timer_/timerfd_/

> timers that notify via file descriptors
> .SH SYNOPSIS
> .\" FIXME . This header file may well change
> .\" FIXME . Probably _GNU_SOURCE will be required
> .\" FIXME . May require: Link with \fI\-lrt\f
> .nf
> .B #include <sys/timerfd.h>
> .sp
> .BI "int timerfd_create(int " clockid );
> .sp
> .BI "int timerfd_settime(int " fd ", int " flags ,
> .BI "                    const struct itimerspec *" new_value ,
> .BI "                    struct itimerspec *" curr_value );
> .sp
> .BI "int timerfd_gettime(int " fd ", struct itimerspec *" curr_value );
> .fi
> .SH DESCRIPTION
> These system calls create and operate on a timer
> that delivers timer expiration notifications via a file descriptor.
> They provide an alternative to the use of
> .BR setitimer (2)
> or
> .BR timer_create (3),
> with the advantage that the file descriptor may be monitored by
> .BR poll (2)
> and
> .BR select (2).
> 
> The use of these three system calls is analogous to the use of
> .BR timer_create (2),
> .BR timer_settime (2),
> and
> .BR timer_gettime (2).

It might be worth mentioning here that there is no timerfd function
analogous to timer_getoverrun() because the equivalent information
is available when the file descriptor is read.

[...]
> .SS Operating on a timer file descriptor
> The file descriptor returned by
> .BR timerfd_create (2)
> supports the following operations:
> .TP
> .BR read (2)
> If the timer has already expired one or more times since it was created,
> or since the last
> .BR read (2),

Nit-pick: this should say "last successful read(2)".  Presumably a
read() that failed with EINVAL would not reset the count.

> then the buffer given to
> .BR read (2)
> returns an unsigned 8-byte integer
> .RI ( uint64_t )
> containing the number of expirations that have occurred.
> .IP
> If no timer expirations have occurred at the time of the
> .BR read (2),
> then the call either blocks until the next timer expiration,
> or fails with the error
> .B EAGAIN
> if the file descriptor has been made non-blocking
> (via the use of the
> .BR fcntl (2)
> .B F_SETFL
> operation to set the
> .B O_NONBLOCK
> flag).
> .IP
> A
> .BR read (2)
> will fail with the error
> .B EINVAL
> if the size of the supplied buffer is less than 8 bytes.

You should also add this error to your read(2) man page.

[...]
> .SH "RETURN VALUE"
> On success,
> .BR timerfd_create ()
> returns a new file descriptor.
> On error, \-1 is returned and
> .I errno
> is set to indicate the error.
> 
> .BR timer_settime ()
> and
> .BR timer_gettime ()
> return 0 on success;

s/timer_/timerfd_/ on the two .BR lines above.

> on error they return \-1, and set
> .I errno
> to indicate the error.
> .SH ERRORS
> .\" FIXME -- there need to be errors for all syscalls here
> .BR tinerfd_create ()

s/tiner/timer/

> can fail with the following errors:
> .\" FIXME Davide, are there any other errors for timerfd_create()?
> .TP
> .B EINVAL
> The
> .I clockid
> argument is neither
> .B CLOCK_MONOTONIC
> nor
> .BR CLOCK_REALTIME .
> .TP
> .B EMFILE
> The per-process limit of open file descriptors has been reached.
> .TP
> .B ENFILE
> The system-wide limit on the total number of open files has been
> reached.
> .TP
> .B ENODEV
> Could not mount (internal) anonymous i-node device.
> .TP
> .B ENOMEM
> There was insufficient kernel memory to create the timer.
> .PP
> .BR timer_settime ()
> and
> .BR timer_gettime ()
> can fail with the following errors:

s/timer_/timerfd_/ on the two .BR lines above.

[...]
>         printf("read: %llu; total=%d\\n", exp, tot_exp);

Another nit-pick, but you should really cast the exp argument to
(unsigned long long) to match the format %llu.  Although uint64_t is
the same size as unsigned long long on all current Linux systems (as
far as I know), one day there might be a system where unsigned long
long is, say, 128 bit.

Regards,
Geoff.
