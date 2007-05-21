Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbXEUIFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbXEUIFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbXEUIEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:04:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:59020 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755323AbXEUIEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:04:37 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1/upLcHzn3u6Gpn/3bO7zdumKse3qHfrce6IP0wo8
	yeapWe7WizioHw
From: Uwe Bugla <uwe.bugla@gmx.de>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Date: Mon, 21 May 2007 09:59:49 +0200
User-Agent: KMail/1.9.5
References: <464F42F3.1080300@madrabbit.org> <b040c32a0705202308h7fda56c1r85bac3ce4c172488@mail.gmail.com> <2c0942db0705202340j4dade008v321d605585231d6@mail.gmail.com>
In-Reply-To: <2c0942db0705202340j4dade008v321d605585231d6@mail.gmail.com>
Cc: "Ken Chen" <kenchen@google.com>, "Andrey Borzenkov" <arvidjaar@mail.ru>,
       "Uwe Bugla" <uwe.bugla@gmx.de>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705210959.49571.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 21. Mai 2007 08:40 schrieben Sie:
> On 5/20/07, Ken Chen <kenchen@google.com> wrote:
> > On 5/19/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> > > Yeah, that's the only one left. I was hoping it wasn't that one, as it
> > > claimed to have been tested extensively. Guess it wasn't tested with
> > > udev.
> > >
> > > Ken? Ball's in your court. As the patch isn't providing a killer
> > > feature for 2.6.22, I'd suggest just reverting it for now until the
> > > issues are ironed out.
> >
> > The real solution is to have the user space tool to create these
> > device nodes in advance.
>
> Maybe. But requiring people upgrade their userspace tools or setup for
> 2.6.22 isn't a reasonable solution.
>
> > The original loop patch was coded such that when we open a loop device
> > N, the immediate adjacent device "N + 1" is created.  This will keep
> > "mount -o loop" happy because it typically does a linear scan to find
> > a free device.  This might be somewhat hackary, but certainly will be
> > backward compatible before user space solution is deployed.
>
> Except userspace is currently expecting 8 loop nodes upon bootup.
> Creating n+1 when n is opened is good, but racy if userspace tries to
> mount serveral loop devices in parallel.
>
> If the loop device instantiates 8 (or max_loop) upon init, then we're
> compatible with how things are being done in 2.6.21 and earlier.
>
> > However, the code was removed by Al in this commit:
> >
> > commit 07002e995638b83a6987180f43722a0eb39d4932
> > Author: Al Viro <viro@zeniv.linux.org.uk>
> > Date:   Sat May 12 16:23:15 2007 -0400
> >
> >   fix the dynamic allocation and probe in loop.c
>
> No, backing that code out wasn't good enough -- the reporter tested
> reverting both of Al's patches out and was still getting errors on
> boot. It took reverting your original one out as well to make it work.

Yes. I reverted three in fact. Please see my latest entry in this thread to 
read what I did to make this work for now.

>
> So, a compromise? Let's start with 8 (or max_loop) populated, and then
> we can move forward separately with teaching userspace new loop
> tricks.

Yes. Good idea!

The reason why I need 2.6.22-rc2 and why I cannot work with 2.6.21.1 is that I 
get a kernel oops (hangup) with 2.6.21.1 about 20 seconds after login.
The machine is an AMD K7 with but SiS chipsets / controllers onboard.
Responsible for that kernel oops with 2.6.21.1 is supposedly the whole ide 
layer plus sis5513.c.
In so far, pulling all ide layer changes plus the sis5513.c patch from 
2.6.22-rc2 into mainline of 2.6.21 would definitely be a very good idea.

Thanks for the quick help, especially to Ray.

Best Regards

Uwe
