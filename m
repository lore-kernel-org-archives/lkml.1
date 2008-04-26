Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbYDZRce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbYDZRce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbYDZRcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:32:25 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59759 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYDZRcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:32:25 -0400
Date: Sat, 26 Apr 2008 19:32:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [git pull] generic bitops, take 2
Message-ID: <20080426173255.GA29451@uranus.ravnborg.org>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426172222.GD17345@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 07:22:22PM +0200, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Sat, 26 Apr 2008, Ingo Molnar wrote:
> > > 
> > > i've added Alexander's patch that does the cleanup suggested by you
> > 
> > Well.. Not really:
> > 
> > > diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
> > > index 3fbe69e..7a75043 100644
> > > --- a/arch/um/Kconfig.x86_64
> > > +++ b/arch/um/Kconfig.x86_64
> > > @@ -27,6 +27,14 @@ config SMP_BROKEN
> > >  	bool
> > >  	default y
> > >  
> > > +config GENERIC_FIND_FIRST_BIT
> > > +	bool
> > > +	default y
> > > +
> > > +config GENERIC_FIND_NEXT_BIT
> > > +	bool
> > > +	default y
> > > +
> > 
> > It still declares this GENERIC_FIND_*_BIT thing separately for UM.
> > 
> > Yes, that may _work_, but it's wrong to define it in two different places. 
> > 
> > It also makes me wonder why Kconfig.i386 can just include 
> > arch/x86/Kconfig.cpu, but x86_64 cannot?
> 
> hm, indeed arch/um/Kconfig.i386 is assymetric to Kconfig.x86_64. Jeff 
> Cc:-ed.

I may be able to explain why..
Before the x68 merge we had an arch/i386/Kconfig.cpu but we did
not have any arch/x86_64/Kconfig.cpu.
When we merged i386 and x86_64 we included the 64 bit stuff in
arch/x86/Kconfig.cpu and thus it became used by both 32bit and 64bit
x86. But during this process we did not do the proper unification
of um - so here we live with the old style.
Blame the one who did the Kconfig unification..

I would assume um should do similar unifaction and get rid of the
i386/x86_64 split (bot I have not looked at doing it).

	Sam
