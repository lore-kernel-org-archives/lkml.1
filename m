Return-Path: <linux-kernel-owner+w=401wt.eu-S1761097AbXIXTwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097AbXIXTwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXIXTwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:52:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:50201 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754597AbXIXTwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:52:39 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX18q4tIA6AoqBpK2HU5a9YanEm2+mm4+dJ6Wjzybjf
	n8RHS+AzX8uENu
Message-ID: <46F814F1.60201@gmx.net>
Date: Mon, 24 Sep 2007 21:50:09 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/3] new timerfd API - wire the new timerfd API to the
 x86 family
References: <send-serie.davidel@xmailserver.org.19354.1190587750.2> <46F75E4D.2080209@gmx.net> <Pine.LNX.4.64.0709240835030.23830@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0709240835030.23830@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

Davide Libenzi wrote:
> On Mon, 24 Sep 2007, Michael Kerrisk wrote:
>> Is it perhaps not better to group the three syscalls contiguously with
>> respect to syscall numbers?  The old timerfd slot can be re-used for some
>> other syscall later.
> 
> There's no problem if they're not contiguous. 

I realise there is no problem, in a technical sense.  But it strikes me as
more aesthetic to make related syscalls numerically contiguous.  Thus, we
see such as the following in the kernel source

#define __NR_epoll_create       254
#define __NR_epoll_ctl          255
#define __NR_epoll_wait         256

and

#define __NR_timer_create       259
#define __NR_timer_settime      (__NR_timer_create+1)
#define __NR_timer_gettime      (__NR_timer_create+2)
#define __NR_timer_getoverrun   (__NR_timer_create+3)
#define __NR_timer_delete       (__NR_timer_create+4)

and

#define __NR_inotify_init       291
#define __NR_inotify_add_watch  292
#define __NR_inotify_rm_watch   293

> Holes, unless filled 
> immediately, need to be remembered to be filled.

Well, in the past it seems they do get filled soon enough though.  There's
fair odds that you'll be the one to fill it with the next syscall you write
;-).

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

