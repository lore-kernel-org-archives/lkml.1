Return-Path: <linux-kernel-owner+w=401wt.eu-S1761097AbXIXT4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097AbXIXT4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbXIXT4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:56:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:44567 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXIXT4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:56:33 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 24 Sep 2007 12:56:27 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/3] new timerfd API - wire the new timerfd API to the
 x86 family
In-Reply-To: <46F814F1.60201@gmx.net>
Message-ID: <Pine.LNX.4.64.0709241255001.24423@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.19354.1190587750.2>
 <46F75E4D.2080209@gmx.net> <Pine.LNX.4.64.0709240835030.23830@alien.or.mcafeemobile.com>
 <46F814F1.60201@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007, Michael Kerrisk wrote:

> Hi Davide,
> 
> Davide Libenzi wrote:
> > On Mon, 24 Sep 2007, Michael Kerrisk wrote:
> >> Is it perhaps not better to group the three syscalls contiguously with
> >> respect to syscall numbers?  The old timerfd slot can be re-used for some
> >> other syscall later.
> > 
> > There's no problem if they're not contiguous. 
> 
> I realise there is no problem, in a technical sense.  But it strikes me as
> more aesthetic to make related syscalls numerically contiguous.  Thus, we
> see such as the following in the kernel source
> 
> #define __NR_epoll_create       254
> #define __NR_epoll_ctl          255
> #define __NR_epoll_wait         256
> 
> and
> 
> #define __NR_timer_create       259
> #define __NR_timer_settime      (__NR_timer_create+1)
> #define __NR_timer_gettime      (__NR_timer_create+2)
> #define __NR_timer_getoverrun   (__NR_timer_create+3)
> #define __NR_timer_delete       (__NR_timer_create+4)
> 
> and
> 
> #define __NR_inotify_init       291
> #define __NR_inotify_add_watch  292
> #define __NR_inotify_rm_watch   293
> 
> > Holes, unless filled 
> > immediately, need to be remembered to be filled.
> 
> Well, in the past it seems they do get filled soon enough though.  There's
> fair odds that you'll be the one to fill it with the next syscall you write
> ;-).

You have to talk to arch mantainers. I do not care. I simply provided the 
x86 hooks because I tested on x86.



- Davide


