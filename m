Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbXIRLIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbXIRLIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 07:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbXIRLIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 07:08:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:50864 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755257AbXIRLIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 07:08:45 -0400
Cc: david@hardeman.nu, davidel@xmailserver.org, drepper@redhat.com,
       geoff@gclare.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@lst.de, corbet@lwn.net,
       rdunlap@xenotime.net, vda.linux@googlemail.com,
       torvalds@linux-foundation.org, Lee.Schermerhorn@hp.com
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 18 Sep 2007 13:08:41 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <1190108542.2995.112.camel@chaos>
Message-ID: <20070918110841.235150@gmx.net>
MIME-Version: 1.0
References: <46EF7DDA.2070401@gmx.net>  <46EF7E82.8040503@gmx.net>	
 <1190106607.2995.97.camel@chaos>  <20070918093007.223350@gmx.net>
 <1190108542.2995.112.camel@chaos>
Subject: Re: RFC: A revised timerfd API
To: Thomas Gleixner <tglx@linutronix.de>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19VnLgkrKtVHMgMBkeS22kLS86HyqyvhGIBPPkesr
 zSpE/9uSCqnefyLpE/pE8w7pL1bUp+fwsdTg== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: i4jcfu5vMmA6fc3zEGBnB7Y5MjQ1N91P
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> Von: Thomas Gleixner <tglx@linutronix.de>
> On Tue, 2007-09-18 at 11:30 +0200, Michael Kerrisk wrote:
> > > This way we have it nicely integrated into the posix timer code and keep
> > > the existing semantics of posix timers intact.
> > > 
> > > We need to think about the open file descriptor in the timer_delete()
> > > case as well, but this should be not too hard to sort out.
> > 
> > This seems like a workable idea also.  But note David Härdeman's
> > critique of options c & d: the existence of a coupled timerfd 
> > and a timerid means that the application must maintain a mapping
> > between the two, so that after an epoll call (for example) that 
> > says the timerfd is ready, the timer can be manipulated using
> > the corresponding timerfd.  This isn't IMO a fatal flaw, but
                      ^^^^^^^
hmmm, of course I meant "timerid" in that last line.

> > it does make the API a little more clumsy.
> 
> Hmm, we might do something like:
> 
> 	timer_gettime(fd | POSIX_TIMER_FD, .....);
> 
> So the kernel looks up the fd in order to figure out the timer_id, which
> needs to be referenced in filep->private_data anyway.

And you'd need similar for timer_settime() and, perhaps,
timer_getoverrun().  But it seems slightly ugly, in the same way that
my idea in option (d) of returning a file descriptor from
timer_create() seems a slightly ugly.  (And can we guarantee that
the [timerid] space is distinct from the [fd|POSIX_TIMER_FD] space?)

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

