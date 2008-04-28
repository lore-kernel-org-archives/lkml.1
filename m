Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbYD1Ovh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbYD1Ovh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbYD1OvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:51:24 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:16200 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118AbYD1OvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:51:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r2NUD/7pdoYMrH3eOaeo2RXMTY+zL/MKeeota0kuvWpKfqFUAhl46HwJBCIoLB90Zdc8VoxGxeJsuGxqPk8gDJ/O6zk1h1ylGCYcjSNpjlNp20vY2GvtDYpy5szKWfKdCzwiBeq/Yc04vYKCvw07e8M6OTyH94XvvxcZtUJsmwA=
Message-ID: <cfd18e0f0804280751x21833b51y4b1f6f7ce3201d0d@mail.gmail.com>
Date: Mon, 28 Apr 2008 16:51:21 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: [PATCH] paccept, socket, socketpair w/flags
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <4815DB8B.7060606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804262224.m3QMOP3a006296@devserv.devel.redhat.com>
	 <517f3f820804280252h753c8cacv7fe9580f96dcf1ce@mail.gmail.com>
	 <4815DB8B.7060606@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 4:13 PM, Ulrich Drepper <drepper@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Michael Kerrisk wrote:
> > This is ugly.  Why invent a diffent set of flags here.  I agree with
> > your earlier statement that new syscalls would be cleaner.
>
> Don't lay words in my mouth.  I do think that different flags are
> needed.

Okay -- to some extent I seem to have misunderstood you.  I'll step
back a little and start again.

You have said it would be cleaner to have new syscalls for socket()
and socketpair().  I understand your reasoning for that to be that
doing so is cleaner than overloading the type argument of the existing
versions of these syscalls.  I agree.  So, since you are adding new
syscalls for all of the other interfaces, why not do it for these two
syscalls also?

> The name of the flag must indicate what it is for and you don't
> want to mix flags with different prefixes for the same flags parameter.
>  Not introducing separate flags would mean all the functions would have
> to accept the same set of flags which will sooner or later create
> problems.  I really don't see the problem here.
>
>
> > then *please* let's go the hwole way cleanly, and have new syscalls
> > also for socketpair() and socket(), and make all of the new syscalls
> > use the same flags.
>
> Hell, no, that's worse than everything else proposed.  We don't have the
> luxury to have a separate parameter to indicate close-on-exec or not.
> For efficiency it has to be a multi-purpose flags parameter and the
> flags each syscall takes are different since the functionality is different.

Okay -- I see your point (and I didn't read your patches closely
enough).  However, the rationale for the implementations proposed to
date isn't very clear.  So far we have the following new flags:

timerfd_create() -- TFD_CLOEXEC
signalfd4() -- SFD_CLOEXEC
eventfd2() -- EFD_CLOEXEC
epoll_create2() -- EPOLL_CLOEXEC
open() (and openat()), dup3() -- all use O_CLOEXEC
socketpair(), socket(), paccept -- all use SOCK_CLOEXEC
pipe2() -- to be determined
inotify_init2() -- to be determined

It would help if you laid out your reasoning for creating distinct
flags for some syscalls but not others.  For example, is the
assumption here that socketpair(), socket(), and paccept() will always
use the same set of flags?  If so, what makes that group special with
respect to your arguments about the need for separate flags for each
syscall?
