Return-Path: <linux-kernel-owner+w=401wt.eu-S1751628AbXEXPYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbXEXPYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbXEXPYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:24:13 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:42403 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbXEXPYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:24:12 -0400
Date: Fri, 25 May 2007 00:23:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <Bryan.Wu@analog.com>
Subject: Re: how to allow board writers to customize driver behavior (watchdog here)
Message-ID: <20070524152318.GA4491@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Bryan Wu <Bryan.Wu@analog.com>
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com> <20070524052312.GA2447@linux-sh.org> <200705240929.51696.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705240929.51696.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 09:29:51AM -0400, Robin Getz wrote:
> On Thu 24 May 2007 01:23, Paul Mundt pondered:
> > On Thu, May 24, 2007 at 12:21:47AM -0400, Mike Frysinger wrote:
> > > is this completely bad mojo ?  is there some other mechanism that
> > > provides what i want and i just dont know about it ?  or do i just
> > > make people change the driver to fit their application, thus throwing
> > > out the idea of keeping all board-specific details in just the boards
> > > file ...
> > 
> > It sounds like your constraining your driver based on terminology.
> > Watchdogs on most embedded platforms support either a 'reset' mode or
> > otherwise act as periodic timers, trying to push both of these
> > functionalities in to a watchdog driver is rather pointless.
> > CONFIG_WATCHDOG implies 'reset' mode by definition.
> 
> I understand what you mean - typically - most people think of watchdog == 
> reset.
> 
No, not typically. This is _precisely_ what CONFIG_WATCHDOG means, and
how the entire set of drivers underneath it behave.

> But, calling it a periodic timer, and servicing it with the watchdog user 
> space demon is even more confusing - isn't it?
> 
Calling it a periodic timer when its in periodic timer mode makes sense.
Why you would want to interface that with a userspace watchdog daemon is
beyond me, they're conceptually unrelated.

Please read my original mail on the subject. I'm not advocating hiding a
clocksource somewhere in the depths of CONFIG_WATCHDOG, they're
completely unrelated.
