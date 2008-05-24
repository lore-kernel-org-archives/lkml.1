Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbYEXU7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbYEXU7x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761521AbYEXU7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:59:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40575 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761603AbYEXU7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:59:44 -0400
Date: Sat, 24 May 2008 23:00:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
Message-ID: <20080524210023.GA3264@uranus.ravnborg.org>
References: <20080524192540.GA28067@uranus.ravnborg.org> <20080524125316.4b969936.akpm@linux-foundation.org> <20080524202427.GA879@uranus.ravnborg.org> <20080524134815.116feb9d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080524134815.116feb9d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 01:48:15PM -0700, Andrew Morton wrote:
> On Sat, 24 May 2008 22:24:27 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > It could help to get us out of the occasional sticky situation, but it
> > > does seem a bit risky.  What happens with Kconfig variables which are
> > > just not known about at all with some .configs?
> > > 
> > > Silly example, one could add
> > > 
> > > 	if (KCONFIG_DVB_VES1820)
> > > 
> > > to kernel/sched.c and that would work happily until someone sets DVB=n,
> > > in which case I assume KCONFIG_DVB_VES1820 doesn't get defined
> > > anywhere?
> > It would have helped if I had applied the correct patch...
> > All boolean and tristate symbols in the konfiguration have
> > their symbols defined as KCONFIG_* no matter their values.
> > So KCONFIG_DVB_VES1820 would get defined.
> 
> But there are still holes - KCONFIG_ARCH_FOOTBRIDGE wouldn't be defined
> on x86, for example.
Not today where we have one configuration definition per architecture.

I hope we one day can change that so we have one for the whole
kernel.
This would for example allow us to detect when someone do
a misspelled "depends on FOOBAR" because it will no longer be
a normal situation to depend on unknow symbols.


> Anything which is inside an `if' or inside an
> if/source/endif will not be known about?  I assume?
These symbols would be know of - their value would just be 0.
The correct patch (last one posted) does this.

	Sam
