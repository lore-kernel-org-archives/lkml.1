Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZC1HvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZC1HvA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 03:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZC1Huu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 03:50:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:39087 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751432AbZC1Hut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 03:50:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Qxd85LTXQ5QTuEUHkzqM/ujN6mk4KRjLjkKwhVU
	Nw0yVhuzcdf6Jx
Subject: Re: Linux 2.6.29
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0903270852070.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	 <200903271435.23116.hpj@urpla.net>
	 <alpine.LRH.2.00.0903271552080.11064@vixen.sonytel.be>
	 <1238168777.5969.18.camel@marge.simson.net>
	 <alpine.LFD.2.00.0903270852070.3994@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 08:50:42 +0100
Message-Id: <1238226642.6837.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 09:02 -0700, Linus Torvalds wrote:
> 
> On Fri, 27 Mar 2009, Mike Galbraith wrote:
> > > 
> > > If you're using the kernel-of-they-day, you're probably using git, and
> > > CONFIG_LOCALVERSION_AUTO=y should be mandatory.
> > 
> > I sure hope it never becomes mandatory, I despise that thing.  I don't
> > even do -rc tags.  .nn is .nn until baked and nn.1 appears.
> 
> If you're a git user that changes kernels frequently, then enabling 
> CONFIG_LOCALVERSION_AUTO is _really_ convenient when you learn to use it.
> 
> This is quite common for me:
> 
> 	gitk v$(uname -r)..
> 
> and it works exactly due to CONFIG_LOCALVERSION_AUTO (and because git is 
> rather good at figuring out version numbers). It's a great way to say 
> "ok, what is in my git tree that I'm not actually running right now".
> 
> Another case where CONFIG_LOCALVERSION_AUTO is very useful is when you're 
> noticing some new broken behavior, but it took you a while to notice. 
> You've rebooted several times since, but you know it worked last Tuesday. 
> What do you do?
> 
> The thing to do is
> 
> 	grep "Linux version" /var/log/messages*
> 
> and figure out what the good version was, and then do 
> 
> 	git bisect start
> 	git bisect good ..that-version..
> 	git bisect bad v$(uname -r)
> 
> and off you go. This is _very_ convenient if you are working with some 
> "random git kernel of the day" like I am (and like hopefully others are 
> too, in order to get test coverage).

That's why it irritates me.  I build/test a lot, and do the occasional
bisection, which makes a mess in /boot and /lib/modules.  I use a quilt
stack of git pull diffs as reference/rummage points.  Awkward maybe, but
effective (so no need for autoversion), and no mess.

	-Mike

