Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbXKJIWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbXKJIWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 03:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXKJIWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 03:22:23 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:56591 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751064AbXKJIWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 03:22:22 -0500
Date: Sat, 10 Nov 2007 17:21:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-ID: <20071110082152.GA18632@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>, Jeff Garzik <jeff@garzik.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <20071110075444.GA5707@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071110075444.GA5707@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 08:54:44AM +0100, Sam Ravnborg wrote:
> On Fri, Nov 09, 2007 at 10:23:23PM -0500, Jeff Garzik wrote:
> > Sam Ravnborg wrote:
> > >This is the patch that get rid of ARCH=i386 and ARCH=x86_64
> > >and introduce ARCH=x86.
> > >It touches several files but the changes are all one or two-liners.
> > >
> > >      x86: drop backward compatibility symlinks to i386/boot and 
> > >      x86_64/boot
> > >      kbuild: sanity check the specified arch
> > 
> > 
> > IMO it negatives impacts the workflow when you -remove- the ability to 
> > set 32/64-bit on the make command line.
> > 
> > Building and testing for both architectures now requires the additional 
> > step of editing .config, which is a clear workflow negative impact at 
> > least for me.
> When it was decided to unify i386 and x86_64 it was at the same time
> decided to handle them as a *single* architecture.
> 
> Keeping ARCH=i386 and ARCH=x86_64 around is just a way to pretend
> this is two diffrent architectures which is no longer the case.
> 
If you do that, then things like randconfigs will randomly break if you
happen to use a toolchain targetted specifically at i386 or so.

randconfigs are pretty useful for testing, it would be nice to have a
facility to keep these working without having to have a script grep the
.config to figure out which toolchain prefix to use.

This is one of the things I've been wondering about with an sh/sh64
unification, as we have no option but having completely different
toolchains, and CONFIG_64BIT=y won't work there when they are both
using a 32-bit ABI.
