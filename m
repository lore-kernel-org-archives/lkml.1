Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbXGXP42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbXGXP42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXGXP4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:56:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:51592 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750941AbXGXP4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:56:19 -0400
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, torvalds@osdl.org,
       davidel@xmailserver.org, drepper@redhat.com
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 24 Jul 2007 17:56:18 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <2c0942db0707240822g35d13bb3r5acd2f361275fd06@mail.gmail.com>
Message-ID: <20070724155618.136490@gmx.net>
MIME-Version: 1.0
References: <46A44B7D.3030700@gmx.net>	
 <2c0942db0707230955l20f7aeeenfc481d89e5a80d4b@mail.gmail.com>	
 <20070724074032.298410@gmx.net>
 <2c0942db0707240822g35d13bb3r5acd2f361275fd06@mail.gmail.com>
Subject: Re: Problems with timerfd()
To: "Ray Lee" <ray-lk@madrabbit.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/qP6s1NNDqR6wNSoIUaiV+zjS+U7VW1/cKvA5fun
 nIH9Fb3wBisMGlFA/w/u94I8PMT4p+HmnUhQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: R1DPKSMNMydhZ/HKEWtl2/hjaGRhZtot
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > (This is the same sort of thing we already have to deal with in
> > > certain situations, such as network stat counters on 32 bit
> > > platforms.)
> >
> > But userspace can't deal with the condition accurately,
> 
> Okay, perhaps this is where I'm missing something? If userspace wakes
> up once every hour, checks the overrun counter against the previous
> (new-old), and goes back to sleep, that'd be good enough, right?

Yes.

> > so why
> > require userspace to worry about this when we could just use
> > a 64-bit value instead?
> 
> <shrug> I don't have strong feelings either way. It just seemed like
> something that could already be taken care of with today's interface.
> Given that the discussion was about an API change between 2.6.22 and
> 2.6.23, I was looking for options to avoid that.

In fact I don't have strong feelings on this part of the interface
design either.  I pointed out the limitation to Davide, and 
pointed out that the related eventfd interface read()s an 8-byte 
integer, and Davide then just fired off a patch to Andrew which 
went into --mm.

It's the other problems with the interface that bother me more
(inability to retrieve previous setting when changing
the timer; inability to retrieve time until next expiration
without changing the current setting).

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

