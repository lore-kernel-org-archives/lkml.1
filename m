Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXKJHxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXKJHxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 02:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXKJHxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 02:53:07 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46557 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbXKJHxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 02:53:06 -0500
Date: Sat, 10 Nov 2007 08:54:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-ID: <20071110075444.GA5707@uranus.ravnborg.org>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4735242B.1010801@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 10:23:23PM -0500, Jeff Garzik wrote:
> Sam Ravnborg wrote:
> >This is the patch that get rid of ARCH=i386 and ARCH=x86_64
> >and introduce ARCH=x86.
> >It touches several files but the changes are all one or two-liners.
> >
> >      x86: drop backward compatibility symlinks to i386/boot and 
> >      x86_64/boot
> >      kbuild: sanity check the specified arch
> 
> 
> IMO it negatives impacts the workflow when you -remove- the ability to 
> set 32/64-bit on the make command line.
> 
> Building and testing for both architectures now requires the additional 
> step of editing .config, which is a clear workflow negative impact at 
> least for me.
When it was decided to unify i386 and x86_64 it was at the same time
decided to handle them as a *single* architecture.

Keeping ARCH=i386 and ARCH=x86_64 around is just a way to pretend
this is two diffrent architectures which is no longer the case.

Do we need a way to say "build a kernel that is 64 bit"?
If we need this then we should look at the most intuitive way
to say so and this should work across x86, powerpc and s390.

	make 64BIT=y ARCH=x86

looks so much more intuitive. And it is generic.
This is just a proposal.

But lets focus on finding a generic solution and not try
to hang around in old habbits.


I can certainly look into enabling a generic syntax but
that is a bit down on my TODO list (and most items above
this has something to do with the kids and not Linux btw).

If we go for the proposed syntax then it
should be a matter of teaching kconfig to look for
"64BIT" and set the 64BIT symbol accordingly.
And thenthe Kconfig files needs to be modified
so the they use "64BIT" to select between kernel
bit size.

	Sam
