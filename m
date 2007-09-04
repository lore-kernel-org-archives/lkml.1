Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbXIDPju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbXIDPju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 11:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbXIDPjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 11:39:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:33869 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754395AbXIDPjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 11:39:42 -0400
Cc: corbet@lwn.net, jengelh@computergmbh.de, hch@lst.de, stable@kernel.org,
       drepper@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rdunlap@xenotime.net
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 04 Sep 2007 17:39:40 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
Message-ID: <20070904153940.305730@gmx.net>
MIME-Version: 1.0
References: <20070825064114.107820@gmx.net>
 <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
 <46DD116C.4040301@gmx.net>
 <20070904011800.762523a4.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
Subject: Re: [PATCH] Revised timerfd() interface
To: Davide Libenzi <davidel@xmailserver.org>, akpm@linux-foundation.org
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18log0pSw4lEnmlMY6M6RKm5AUE3n+KVsm5U4Wllc
 DbAwe6ppB1DsXz6hOYiWT/f/dJBsyn0BFFRg== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: BEvuci8Ff2IsEfH2F21oT5R4dWxlc9bA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

> > <wakes up>
> > 
> > I'd have thought that the existing stuff would be near-useless without
> > the capabilities which you describe?
> 
> Useless like it'd be a motorcycle w/out a cup-holder :)
> Seriously, the ability to get the previous values from "something" could 
> have a meaning if this something is a shared global resource (like 
> signals
> for example). In the timerfd case this makes little sense, since you can 
> create as many timerfd as you like and you do not need to share a single 
> one by changing/restoring the original context.

However, one can have multipe POSIX timers, just as you can 
have multiple timerfd timers; nevertheless POSIX timers provide
the get and get-while-setting functionality.

> On top of that, the cup-holder addition would cost in terms of API 
> clarity

I agree my proposed API is not as clean as it could be, that's why
I would favour:

> (or in terms of two additional system calls in the other case),

Or better still, have timerfd() integrated with POSIX tiemrs (if
this is feasible).  This givesus a simple API, exactly one new
syscall, and all of the functionality of the existing POSIX
timers API.

> and in terms of kernel code footprint.

Not sure what your concern is here.  The total amount of 
new code for all of these options is pretty small.

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

