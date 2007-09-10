Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbXIJDSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbXIJDSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 23:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbXIJDSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 23:18:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:34705 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754193AbXIJDSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 23:18:00 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1+0ttx+sne0yqKHmNrpR2df3RZlLS3AWyG9GIE0hx
	Ij/M7T2n3YI6HB
Message-ID: <46E4B6D1.6080909@gmx.net>
Date: Mon, 10 Sep 2007 05:15:29 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Andrew Morton <akpm@linux-foundation.org>, corbet@lwn.net,
       jengelh@computergmbh.de, hch@lst.de, stable@kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, rdunlap@xenotime.net
Subject: Re: [PATCH] Revised timerfd() interface
References: <20070825064114.107820@gmx.net> <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com> <46DD116C.4040301@gmx.net> <20070904011800.762523a4.akpm@linux-foundation.org> <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com> <20070904204932.208520@gmx.net> <Pine.LNX.4.64.0709041541500.7326@alien.or.mcafeemobile.com> <20070905000831.313400@gmx.net> <Pine.LNX.4.64.0709050901420.11426@alien.or.mcafeemobile.com> <20070905162352.236680@gmx.net> <Pine.LNX.4.64.0709051251290.11804@alien.or.mcafeemobile.com> <20070905225033.236700@gmx.net> <Pine.LNX.4.64.0709051604320.5320@alien.or.mcafeemobile.com> <20070906065816.194530@gmx.net> <Pine.LNX.4.64.0709061629250.14600@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0709061629250.14600@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

>> This function is *not at all* equivalent to the "get"
>> functionality of the previous APIs.  The "get" functionality
>> of POSIX timers (for example) returns a structure that contains
>> the timer interval and the *time until the next expiration of
>> the timer* (not the initial timer string, as your code above
>> does).
>> So come up with a reliable, race-free way of doing that in
>> userspace.  Then make it work for both CLOCK_MONOTONIC and
>> CLOCK_REALTIME timers.  (You'll certainly need to be making
>> some additional system calls, by the way: at least some
>> calls to clock_gettime().)
> 
> No, I don't think I will. Since 1) it's so trivial it's not even 
> challenging 

Well, it seems to me that the proposed library wrapper code
could start to get rather verbose by the time one adds in
these changes (plus the mutexes).

> 2) you know it can be done (I assume) 

Sorry -- I was probably speaking too rhetorically.  In fact, it's
not completely clear to me that it can (always) be done.  For
example, the answer depends on knowing the clockid.  But
what if the file descriptor has been handed off to some code
that doesn't know the clock type (i.e., isn't accessing the fd
via your suggested library)?

Cheers,

Michael

> 3) it solves a non-case 
> made up to justify an API/kernel-code bloating.
> But you don't need *my* signoff. Cook a working patch, make a case for it, 
> and gather support and signoffs. I won't be acking it because, as I said 
> many times, I think it's useless bloating.

