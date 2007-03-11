Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbXCKFf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbXCKFf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 00:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbXCKFf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 00:35:58 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36889 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933176AbXCKFf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 00:35:57 -0500
Date: Sat, 10 Mar 2007 21:35:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <Pine.LNX.4.64.0703101938150.3613@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703102132240.10330@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com> 
 <1173508384.3108.1.camel@entropy>  <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
  <1173509019.3108.4.camel@entropy>  <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
  <1173510568.3108.17.camel@entropy>  <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
  <1173556374.2958.12.camel@entropy>  <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
  <1173560473.2958.23.camel@entropy>  <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
 <1173563796.2958.28.camel@entropy> <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703101938150.3613@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Mar 2007, Davide Libenzi wrote:

> On Sat, 10 Mar 2007, Linus Torvalds wrote:
> 
> > (That said, using "struct itimerspec" might be a good idea. That would 
> > also obviate the need for TFD_TIMER_SEQ, since an itimerspec automatically 
> > has both "base" and "incremental" parts).
> 
> But TFD_TIMER_SEQ is a simple auto-rearm case of TFD_TIMER_REL. So the 
> timespec is sufficent too (in all three cases we just need *one* time). 

Well, people actually do use itimers like "give me a timer every second, 
starting five seconds from now".

> Actually, the only place where I can find the itimerspec usefull, is 
> indeed with TFD_TIMER_SEQ. In cases where you want you clock starting at a 
> given time (it_value) *and* with the given frequency (it_interval).

.. and this is where itimerspec is even better: once you have absolute 
time, *and* a process that might miss ticks (because it does something 
else), the "absolute time start + interval" thing can avoid drifting 
(which a "relative interval" has a really hard time doing).

So if you want a "timer tick every second, *on* the second" kind of 
interface, you really do want a absolute time starting point, and then a 
fixed interval. Two different times.

		Linus
