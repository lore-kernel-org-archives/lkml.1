Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbXIDWln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbXIDWln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 18:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbXIDWlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 18:41:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4432 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbXIDWle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 18:41:34 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 4 Sep 2007 15:41:31 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Andrew Morton <akpm@linux-foundation.org>, corbet@lwn.net,
       jengelh@computergmbh.de, hch@lst.de, stable@kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, rdunlap@xenotime.net
Subject: Re: [PATCH] Revised timerfd() interface
In-Reply-To: <20070904153940.305730@gmx.net>
Message-ID: <Pine.LNX.4.64.0709041525080.7326@alien.or.mcafeemobile.com>
References: <20070825064114.107820@gmx.net> <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
 <46DD116C.4040301@gmx.net> <20070904011800.762523a4.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
 <20070904153940.305730@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2007, Michael Kerrisk wrote:

> Hi Davide,
> 
> > > <wakes up>
> > > 
> > > I'd have thought that the existing stuff would be near-useless without
> > > the capabilities which you describe?
> > 
> > Useless like it'd be a motorcycle w/out a cup-holder :)
> > Seriously, the ability to get the previous values from "something" could 
> > have a meaning if this something is a shared global resource (like 
> > signals
> > for example). In the timerfd case this makes little sense, since you can 
> > create as many timerfd as you like and you do not need to share a single 
> > one by changing/restoring the original context.
> 
> However, one can have multipe POSIX timers, just as you can 
> have multiple timerfd timers; nevertheless POSIX timers provide
> the get and get-while-setting functionality.

The fact that POSIX defined a certain API in a given way, does not 
automatically mean that every other API has to look exactly like that.
POSIX has the tendency to bloat things up at times ;)



> > and in terms of kernel code footprint.
> 
> Not sure what your concern is here.  The total amount of 
> new code for all of these options is pretty small.

>From your patch:

fs/compat.c              |   34 ++++++++--
fs/timerfd.c             |  147 +++++++++++++++++++++++++++++++++++++++--------
include/linux/compat.h   |    3 
include/linux/syscalls.h |    3 
4 files changed, 153 insertions(+), 34 deletions(-)

And the API definition becomes pretty messy. The other way is to add new 
system calls. 120+ lines of code more of new system calls wouldn't even be 
a problem in itself, if the added value was there.
IMO, as I already said, the added value does not justify them.



- Davide


