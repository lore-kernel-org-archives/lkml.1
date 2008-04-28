Return-Path: <linux-kernel-owner+w=401wt.eu-S932148AbYD1HMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbYD1HMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765098AbYD1HMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:12:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:54588 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbYD1HMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:12:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dh2b4Mjx/H/cXC2TZ5RuUTpfa+OR/fjrEsBBq/n0h4zyokNJUSacQ6vgVOIFJeksC92CDqjbHhHgQlL0igNakW5Pb5yR8NyOzrLFFRkF+BeNkC8Fj99VzeaflE2tjedrH8qOE+0HrErAYTRJhO//boAkluwCiIv8sA506hsBHR8=
Message-ID: <517f3f820804280012n3e289db7mb23950cfd3ac04b1@mail.gmail.com>
Date: Mon, 28 Apr 2008 09:12:20 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [PATCH] eventfd, signalfd, timerfd, epoll_create w/flags
Cc: "Ulrich Drepper" <drepper@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804271614240.18184@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272217.m3RMHZ0S021481@devserv.devel.redhat.com>
	 <Pine.LNX.4.64.0804271614240.18184@alien.or.mcafeemobile.com>
X-Google-Sender-Auth: 1f4a5e65a94c564e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/08, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Sun, 27 Apr 2008, Ulrich Drepper wrote:
>
>  > In the absence of sys_indirect we need the following patches as well.  These
>  > are all the event handling functions: epoll_create, signalfd, timerfd, eventd.
>  >
>  > There is good news and bad.  The good news is that the timerfd interface
>  > already has a flags parameter.  We just have to put it to use.  It's IMO
>  > not a good idea to use the O_* values for any of the flag parameters so I
>  > introduced new macros for all the functions.
>  >
>  > For signalfd and eventfd no flags parameter is available in the syscall.
>  > But for the userlevel interfaces I have added such a parameter back when.
>  > They are just required to be zero so far.  This means the new syscalls
>  > will completely transparently be used once glibc knows about them.
>  > Programs can start using the new flags and get told when the implementation
>  > doesn't support it.
>  >
>  > The bad case is epoll_create.  Neither the kernel nor the userlevel interface
>  > has a flags parameter.  So we need a new, additional interface.  We could have
>  > one which differs from epoll_create only in that it returns a file descriptor
>  > with close-on-exec already set.  I don't like that.  Instead, the patch adds
>  > a new interface with a flags parameter.  More flexibility in future.
>
>
> Ok, I asked this myself for about ten minutes, than I gave up. But why
>  sys_epoll_createp() instead of sys_epoll_create2()? There MUST be a reason
>  to deviate from the standard of all the other ones...
>  The one between sys_indirect and syscall explosion is the battle of the
>  ugly.
>  Besides that, patches look fine to me (though w/out a very good reason, I
>  prefer sys_epoll_create2() instead of sys_epoll_createp()).

This "p" doesn't follow convention.  The "p" that has appeared on some
syscalls is by analogy with pselect().

pselect() = select() + a sigset parama=ter.

I seem to recall that the "p" is because this was a POSIX invention.

Anyway, the "p" has been added to a number of other Linux syscalls
that have likewise added a sigset:

poll() --> ppoll()
epoll_wait() --> epoll_pwait()
and now: accept() --> paccept()

Adding a "p" to the name epoll_create() would be a mistake by this convention.
