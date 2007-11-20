Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbXKTJN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbXKTJN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbXKTJNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:13:44 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:52609 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbXKTJNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:13:42 -0500
Message-ID: <4742A51D.5080009@cosmosbay.com>
Date: Tue, 20 Nov 2007 10:13:01 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 0/6] sys_indirect system call
References: <200711200653.lAK6rEYP025876@devserv.devel.redhat.com>
In-Reply-To: <200711200653.lAK6rEYP025876@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 20 Nov 2007 10:13:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> wing patches provide an alternative implementation of the
> sys_indirect system call which has been discussed a few times.
> This no system call allows us to extend existing system call
> interfaces with adding more system calls.

I am wondering if some parts are missing from your ChangeLog

You apparently added in v3 a new 'flags' parameter to indirect syscall but no 
trace of this change in Changelog, and why it was added. This seems to imply a 
future multiplexor.

And no change in the test program reflecting this 'flags' new param, so it fails.


>   fd = syscall (__NR_indirect, &r, &i, sizeof (i));

should be fd = syscall (__NR_indirect, &r, &i, sizeof (i), 0);

>   int s2 = fcntl (fd, F_GETFD);
>   int t2 = fcntl (fd, F_GETFL);
>   printf ("new: FD_CLOEXEC %s set, NONBLOCK %s set\n",
> 	  s2 == 0 ? "not" : "is", (t2 & O_NONBLOCK) ? "is" : "not");
>   close (fd);
> 
>   i.file_flags.flags = O_CLOEXEC;
>   sigset_t ss;
>   sigemptyset(&ss);
>   FILL_IN(r, __NR_signalfd, -1, (long) &ss, 8);
>   fd = syscall (__NR_indirect, &r, &i, sizeof (i));

same here ?

>   int s3 = fcntl (fd, F_GETFD);
>   printf ("signalfd: FD_CLOEXEC %s set\n", s3 == 0 ? "not" : "is");
>   close (fd);
> 
>   FILL_IN(r, __NR_eventfd, 8);
>   fd = syscall (__NR_indirect, &r, &i, sizeof (i));

and here.

>   int s4 = fcntl (fd, F_GETFD);
>   printf ("eventfd: FD_CLOEXEC %s set\n", s4 == 0 ? "not" : "is");
>   close (fd);
> 
>   return s1 != 0 || s2 == 0 || t1 != 0 || t2 == 0 || s3 == 0 || s4 == 0;
> }
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


