Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbXIDIGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbXIDIGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 04:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbXIDIGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 04:06:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:35449 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752698AbXIDIF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 04:05:58 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX19G2yg7yPpGV5hpy1mna+K562CxFkmQH9n6iLe9WQ
	oAmmeZhKXeClx4
Message-ID: <46DD116C.4040301@gmx.net>
Date: Tue, 04 Sep 2007 10:03:56 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, stable@kernel.org,
       Christoph Hellwig <hch@lst.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Revised timerfd() interface
References: <20070825064114.107820@gmx.net> <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

>> Davide -- ping!  Can you please offer your comments about this change, and
>> also thoughts on Jon's and my comments about a more radical API change
>> later  in this thread.
> 
> IMO the complexity of the resulting API (and resulting patch), and the ABI 
> change, is not justified by the added value.

Neither of the proposed APIs (either my multiplexed version of timerfd()
or Jon's/my idea of using three system calls (like POSIX timers), or
the notion of timerfd() integrated with POSIX timers) is more
complicated than the existing POSIX timers API.

The ABI change doesn't really matter, since timerfd() was broken in 2.6.22
anyway.

Both previous APIs provided the features I have described provide:

* the ability to fetch the old timer value when applying
  a new setting

* the ability to non-destructively fetch the amount of time remaining
  on a timer.

This is clearly useful for timers -- but you have not explained why
you think this is not necessary for timerfd timers.

Please -- let's do timerfd() better.  Either three syscalls like:

timerfd_create()
timerfd_settime()
timer_gettime()

(the analogs of timer_create(), timer_settime(), timer_gettime()).

Or (if possible, and even better) timerfd() integrated with POSIX timers.

Then we have a good API for the coming decades.  I'm prepared to help
out with patches (for what my help is worth ;-)).

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
