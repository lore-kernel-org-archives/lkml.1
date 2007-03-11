Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbXCKB5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbXCKB5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 20:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932459AbXCKB5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 20:57:46 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46314 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbXCKB5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 20:57:45 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Mar 2007 17:57:39 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <1173577759.2958.124.camel@entropy>
Message-ID: <Pine.LNX.4.64.0703101752360.3613@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com> 
 <1173508384.3108.1.camel@entropy>  <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
  <1173509019.3108.4.camel@entropy>  <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
  <1173510568.3108.17.camel@entropy>  <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
  <1173556374.2958.12.camel@entropy>  <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
  <1173560473.2958.23.camel@entropy>  <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
  <1173563796.2958.28.camel@entropy>  <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
  <1173572751.2958.107.camel@entropy>  <Pine.LNX.4.64.0703101630260.10330@woody.linux-foundation.org>
 <1173577759.2958.124.camel@entropy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Nicholas Miell wrote:

> If that's the goal, somebody should start thinking about reducing the
> contents of struct file to the bare minimum (i.e. not much more than a
> file_operations pointer).

That's already pretty smal, and the single inode (and maybe dentry) will 
make it even smaller. Unless you want to create brazillions of signalfds,
timerfds or asyncfds.



> > And the real point of the whole signalfd() is that there really *are* a 
> > lot of UNIX interfaces that basically only work with file descriptors. Not 
> > just read, but select/poll/epoll.
> 
> It'd be useful if the polling interfaces could return small datums
> beyond just the POLL* flags -- having to do a read on timerfd just to
> get the overrun count has a lot of overhead for just an integer, and I
> imagine other things would like to pass back stuff too.
...

> You still want timeouts, creating/setting/destroying at timer just for
> a single call to select/poll/epoll is probably too heavy weight.

Take a look at what timerfd does and what posix timers has to do to 
implement the interface. You'll prolly stop trolling with things like "a 
lot of overhead" or "too heavy weight".



> timerfd() still leaves out the basic clock selection functionality
> provided by both setitimer() and timer_create().

That is coming as soon as I fixed my send-serie script ...




- Davide


