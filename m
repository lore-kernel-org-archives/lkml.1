Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbXIZHQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbXIZHQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 03:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbXIZHQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 03:16:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:46908 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750773AbXIZHQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 03:16:43 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX18jJu8EgXIjCgGEAuYo1834uP0Cs8DGWWjGsaI73Y
	KSxefkOKE/5Dgp
Message-ID: <46FA06C6.5090703@gmx.net>
Date: Wed, 26 Sep 2007 09:14:14 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] new timerfd API v2 - new timerfd API
References: <12492.1190738426@lwn.net> <Pine.LNX.4.64.0709251035330.9111@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0709251035330.9111@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Davide Libenzi wrote:
> On Tue, 25 Sep 2007, Jonathan Corbet wrote:
> 
>> One quick question:
>>
>>> Like the previous timerfd API implementation, read(2) and poll(2) are supported
>>> (with the same interface).
>> Looking at that interface, it appears that a process doing a read() on a
>> timerfd with no timer set will block for a very long time.  It's an
>> obvious "don't do that" situation, but perhaps we could help an
>> occasional developer get a clue by returning something like -EINVAL when
>> the timer has not been set?
> 
> That is the same as you try to read once more after an expired timer. You 
> won't wake up until the next timer event will show up. That is, after at 
> most TP time for periodic timers, or after the time  the next 
> timerfd_settime() will setup.
> I'd like to keep the "timerfd not set yet" and the "timerfd already 
> expired and not re-armed" acting the same way. That is, wait till next 
> event happen (unless O_NONBLOCK of course).

Yes.  The timer_settime() and read() might for example be done in separate
threads, and it would make sense for the read() to block until the timer
has been armed.

Cheers,

Michael


-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
