Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbXGOJRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbXGOJRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbXGOJRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:17:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:33051 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756133AbXGOJRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:17:39 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 15 Jul 2007 11:17:38 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0707141151500.31255@alien.or.mcafeemobile.com>
Message-ID: <20070715091738.193100@gmx.net>
MIME-Version: 1.0
References: <20070714074145.277260@gmx.net>
 <Pine.LNX.4.64.0707141151500.31255@alien.or.mcafeemobile.com>
Subject: Re: signalfd() semantics after execve()
To: Davide Libenzi <davidel@xmailserver.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19KZWQFOaFK/UTCPHFUgVjZiO7g3yKxf5wFh1adxR
 d7OhaqURmhcDfwGuSsA+7XqquW7rOyXdV/GQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: CtSqcgQCX1V6GJLyF2ByzN5/SDc4NEyD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

> > I'm working on the signalfd(2) man page, and I've come
> > acorss some puzzling behaviour...  
> > 
> > What are the intended semantics of a signalfd file descriptor
> > after an execve()?
> > 
> > As far as I can work out, after an execve() the file descriptor
> > is still available, but reads from it always return 0, even if:
> > 
> > a) there were signals pending before the execve().
> >    However, sigpending() shows the signal as pending,
> >    and the signal can be accepted using sigwaitinfo().
> > 
> > b) we generate a signal after the execve().
> >  
> > Is this intended behavior (the "orphaned sighand" condition
> > mentioned in the draft man page you sent me?)?  Is it a bug?
> 
> It is the intended behaviour. Just like reading from a socket where the 
> remote peer disconnected. 

I don't think this analogy is good; what is the "peer" in this 
situation?

IMO, A better analogy is: signalfd() should provide 
similar semantics to sigwaitinfo()/sigtimedwait() (and/or
handling signals with a signal handler).

> A return 0 from a read from a signalfd should be
> interpreted as the "virtual connection" with the signal source has been 
> dropped.

Yes, but in this case why has the '"virtual connection" with the 
signal source' been dropped?  

Why shouldn't one be allowed to continue reading signals from
the signalfd file descriptor after the execve()?  

After all, I can still fetch those signals with sigwaitinfo() 
after the execve().  Not being able to also dothat with signalfd 
just isn't consistent.

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

