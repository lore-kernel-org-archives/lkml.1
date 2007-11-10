Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbXKJWsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbXKJWsb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbXKJWsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:48:23 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53939 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbXKJWsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:48:23 -0500
Date: Sat, 10 Nov 2007 23:50:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/5] introduce K64BIT=y and backward compatibility ARCH={i386,x86_64} for x86
Message-ID: <20071110225001.GB13815@uranus.ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <20071110143302.73b571d6.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071110143302.73b571d6.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 02:33:02PM -0800, Randy Dunlap wrote:
> On Sat, 10 Nov 2007 21:40:38 +0100 Sam Ravnborg wrote:
> 
> > As discussed in another thread the right thing is to add a generic solution
> > to select between 32 and 64 bit - useable for powerpc, s390, ppc et al.
> > 
> > First step was to teach kconfig how to force 64BIT to a specific value.
> > The x86 Kconfig file needed a small twist to use 64BIT as the symbol
> > to seelct 32 or 64 bit.
> > Then it was simple to add backward compatibility ARCH= settings.
> > 
> > The patchset is not yet pushed out - I will await a bit feedback first.
> > 
> > Shortlog and diffstat.
> >       kconfig: factor out code in confdata.c
> >       kconfig: use $K64BIT to set 64BIT with all*config targets
> >       x86: Use CONFIG_64BIT to select between 32 and 64 bit in Kconfig
> >       kconfig: document make K64BIT=y in README
> >       x86: introduce ARCH=i386,ARCH=x86_64 to select 32/64 bit
> 
> Hi Sam,
> Looks good to me and should satisfy our habits^w usages models.
> 
> The one minor question is the environment variable name (K64BIT or
> something else, like Guillaume brought up).  Personally I don't
> care how it's spelled.  IOW, K64BIT is sufficient, but if there is a
> goal to be able to place any CONFIG_symbol on the command line or
> as an env. variable, they might as well all be named with CONFIG_*.

The K64BIT varibale came up because it is more unique than CONFIG_64BIT.
Google turned up less than 20 hits[1] on K64BIT but 14900 on CONFIG_64BIT.
And I dunno if some people source their .config or other crazy stuff.

And then K64BIT was easier to type...
But if we assume this is internal stuff only then we could go
for the longer version and I will then suggest to prefix
the CONFIG_ symbol with K like in KCONFIG_64BIT which
has no hits with google right now!

I do not see this extended to 'any' CONFIG_ symbol
but maybe the 4 most important ones.
[64BIT, SMP, PREEMPT, ?]

[1] before my posting - now we are up to ~80.

	Sam
