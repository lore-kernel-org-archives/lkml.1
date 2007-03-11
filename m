Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbXCKCKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbXCKCKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 21:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932601AbXCKCKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 21:10:07 -0500
Received: from sccrmhc12.comcast.net ([204.127.200.82]:61014 "EHLO
	sccrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbXCKCJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 21:09:53 -0500
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703101752360.3613@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com>
	 <1173508384.3108.1.camel@entropy>
	 <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
	 <1173509019.3108.4.camel@entropy>
	 <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
	 <1173510568.3108.17.camel@entropy>
	 <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
	 <1173556374.2958.12.camel@entropy>
	 <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
	 <1173560473.2958.23.camel@entropy>
	 <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
	 <1173563796.2958.28.camel@entropy>
	 <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
	 <1173572751.2958.107.camel@entropy>
	 <Pine.LNX.4.64.0703101630260.10330@woody.linux-foundation.org>
	 <1173577759.2958.124.camel@entropy>
	 <Pine.LNX.4.64.0703101752360.3613@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 18:09:50 -0800
Message-Id: <1173578990.2958.132.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 17:57 -0800, Davide Libenzi wrote:
> On Sat, 10 Mar 2007, Nicholas Miell wrote:
> 
> > If that's the goal, somebody should start thinking about reducing the
> > contents of struct file to the bare minimum (i.e. not much more than a
> > file_operations pointer).
> 
> That's already pretty smal, and the single inode (and maybe dentry) will 
> make it even smaller. Unless you want to create brazillions of signalfds,
> timerfds or asyncfds.
> 

Timers don't need dentry or inode pointers or readahead state, etc., do
they? (Beyond the existing VFS expectation, that is.)

> > > And the real point of the whole signalfd() is that there really *are* a 
> > > lot of UNIX interfaces that basically only work with file descriptors. Not 
> > > just read, but select/poll/epoll.
> > 
> > It'd be useful if the polling interfaces could return small datums
> > beyond just the POLL* flags -- having to do a read on timerfd just to
> > get the overrun count has a lot of overhead for just an integer, and I
> > imagine other things would like to pass back stuff too.
> ...
> 
> > You still want timeouts, creating/setting/destroying at timer just for
> > a single call to select/poll/epoll is probably too heavy weight.
> 
> Take a look at what timerfd does and what posix timers has to do to 
> implement the interface. You'll prolly stop trolling with things like "a 
> lot of overhead" or "too heavy weight".

That wasn't a troll. I was talking about the timerfd()/close() overhead
and the corresponding bookkeeping necessary to keep that fd around
compared to just passing a struct timespec to poll or a millisecond
count to epoll_wait.

> > timerfd() still leaves out the basic clock selection functionality
> > provided by both setitimer() and timer_create().
> 
> That is coming as soon as I fixed my send-serie script ...

Nice.

-- 
Nicholas Miell <nmiell@comcast.net>

