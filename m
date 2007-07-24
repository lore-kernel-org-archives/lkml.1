Return-Path: <linux-kernel-owner+w=401wt.eu-S1765671AbXGXHkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765671AbXGXHkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757556AbXGXHkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:40:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:48480 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754274AbXGXHke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:40:34 -0400
Cc: drepper@redhat.com, davidel@xmailserver.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 24 Jul 2007 09:40:32 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <2c0942db0707230955l20f7aeeenfc481d89e5a80d4b@mail.gmail.com>
Message-ID: <20070724074032.298410@gmx.net>
MIME-Version: 1.0
References: <46A44B7D.3030700@gmx.net>
 <2c0942db0707230955l20f7aeeenfc481d89e5a80d4b@mail.gmail.com>
Subject: Re: Problems with timerfd()
To: "Ray Lee" <ray-lk@madrabbit.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19X4r4Nj61Xtvc6A+gS77Ho89I0qU3lg2UO5IMajL
 kfQPkSNNZJ91AKR914S1O0Q7hfpJ8SViQ8tA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: uOrDLPkCaHIte9zNXSQlztNiamdhZAQY
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray,

> On 7/22/07, Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> > Problem 1
> > ---------
> >
> > The value returned by read(2)ing from a timerfd file descriptor is 
> > the
> > number of timer overruns.  In 2.6.22, this value is 4 bytes, limiting
> > the overrun count  to 2^32.  Consider an application where the timer
> > frequency
> > was 100 kHz (feasible in the not-too-distant future, I would guess),
> > then
> > the overrun counter would cycle after ~40000 seconds (~11 hours).
> > Furthermore returning 4 bytes from the read() is inconsistent with
> > eventfd
> > file descriptors, which return 8 byte integers from a read().
> 
> I'm feeling slow, and think I'm missing something. Why is this an
> issue? Wouldn't userspace just keep track of the last overrun count,
> and subtract the two to get the overruns-since-last-read? 

The value returned by read() is the number of overruns since
the last read().

> That makes
> it oblivious to rollovers, unless it can't manage to do a read once
> every 11 hours.

That's the point that the change is meant to address.

> (This is the same sort of thing we already have to deal with in
> certain situations, such as network stat counters on 32 bit
> platforms.)

But userspace can't deal with the condition accurately, so why
require userspace to worry about this when we could just use
a 64-bit value instead?

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

