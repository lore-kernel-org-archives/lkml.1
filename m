Return-Path: <linux-kernel-owner+w=401wt.eu-S1763933AbYD0XUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763933AbYD0XUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764829AbYD0XUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:20:33 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53177 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYD0XUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:20:32 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 27 Apr 2008 16:20:30 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] eventfd, signalfd, timerfd, epoll_create w/flags
In-Reply-To: <200804272217.m3RMHZ0S021481@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0804271614240.18184@alien.or.mcafeemobile.com>
References: <200804272217.m3RMHZ0S021481@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008, Ulrich Drepper wrote:

> In the absence of sys_indirect we need the following patches as well.  These
> are all the event handling functions: epoll_create, signalfd, timerfd, eventd.
> 
> There is good news and bad.  The good news is that the timerfd interface
> already has a flags parameter.  We just have to put it to use.  It's IMO
> not a good idea to use the O_* values for any of the flag parameters so I
> introduced new macros for all the functions.
> 
> For signalfd and eventfd no flags parameter is available in the syscall.
> But for the userlevel interfaces I have added such a parameter back when.
> They are just required to be zero so far.  This means the new syscalls
> will completely transparently be used once glibc knows about them.
> Programs can start using the new flags and get told when the implementation
> doesn't support it.
> 
> The bad case is epoll_create.  Neither the kernel nor the userlevel interface
> has a flags parameter.  So we need a new, additional interface.  We could have
> one which differs from epoll_create only in that it returns a file descriptor
> with close-on-exec already set.  I don't like that.  Instead, the patch adds
> a new interface with a flags parameter.  More flexibility in future.

Ok, I asked this myself for about ten minutes, than I gave up. But why 
sys_epoll_createp() instead of sys_epoll_create2()? There MUST be a reason 
to deviate from the standard of all the other ones...
The one between sys_indirect and syscall explosion is the battle of the 
ugly.
Besides that, patches look fine to me (though w/out a very good reason, I 
prefer sys_epoll_create2() instead of sys_epoll_createp()).



- Davide


