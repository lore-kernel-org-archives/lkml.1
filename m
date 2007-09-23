Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbXIWTDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbXIWTDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 15:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXIWTDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 15:03:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:33360 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754670AbXIWTDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 15:03:05 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX18rpWQesiwrjZzna/Bj7Q+ByFoM5fasd+QPzhYTw/
	R2cWe/mv83K6QK
Message-ID: <46F6B864.9080902@gmx.net>
Date: Sun, 23 Sep 2007 21:03:00 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@xenotime.net>,
       vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, david@hardeman.nu
Subject: Re: RFC: A revised timerfd API
References: <46EF7DDA.2070401@gmx.net> <Pine.LNX.4.64.0709180936480.22956@alien.or.mcafeemobile.com> <46F514C9.5010208@gmx.net> <Pine.LNX.4.64.0709221359190.22085@alien.or.mcafeemobile.com> <46F6A37C.9010009@gmx.net> <Pine.LNX.4.64.0709231128070.22989@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0709231138260.22989@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0709231138260.22989@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Sun, 23 Sep 2007, Davide Libenzi wrote:
> 
>> On Sun, 23 Sep 2007, Michael Kerrisk wrote:
>>
>>> I applied this patch against 2.6.27-rc7, and wired up the syscalls as shown
>>> in the definitions below.  When I ran the the program below, my system
>>> immediately froze.  Can you try it on your system please.
>> There's an hrtimer_init() missing in timerfd_create(). I'll refactor the 
>> patch.
> 
> There's the case of a timerfd_gettime return status when the timerfd has 
> not been set yet (ie, soon after a timerfd_create), to handle.
> Current way is to return an (itimerspec) { 0, 0 }. Ok?

Seems reasonable.  In the analogous situation, the POSIX timers API 
returns a structure containing all zeros, at least on Linux.
