Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbXIDUto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbXIDUto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 16:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbXIDUtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 16:49:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:38914 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753628AbXIDUte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 16:49:34 -0400
Cc: corbet@lwn.net, jengelh@computergmbh.de, hch@lst.de, stable@kernel.org,
       drepper@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rdunlap@xenotime.net
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 04 Sep 2007 22:49:32 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
Message-ID: <20070904204932.208520@gmx.net>
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
X-Provags-ID: V01U2FsdGVkX19LYmxlIKRLPg63TInrcqdV8CsK1j9cFPRNkmirmV
 qJG454gCyvEXPaX0ajwiCY4VqmaoNyibBD9A== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: s7G0dTkfeWUkU9T5Em5nhUcjL0tsZs1I
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The ABI change doesn't really matter, since timerfd() was broken in
> > > 2.6.22 anyway.
> > > 
> > > Both previous APIs provided the features I have described provide:
> > > 
> > > * the ability to fetch the old timer value when applying
> > >   a new setting
> > > 
> > > * the ability to non-destructively fetch the amount of time remaining
> > >   on a timer.
> > > 
> > > This is clearly useful for timers -- but you have not explained why
> > > you think this is not necessary for timerfd timers.
> > 
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

Davide,

As I think about this more, I see more problems with
your argument.  timerfd needs the ability to get and 
get-while-setting just as much as the earlier APIs.
Consider a library that creates a timerfd file descriptor that
is handed off to an application: that library may want
to modify the timer settings without having to create a
new file descriptor (the app mey not be able to be told about
the new fd).  Your argument just doesn't hold, AFAICS.

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

