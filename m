Return-Path: <linux-kernel-owner+w=401wt.eu-S933873AbXKOWFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873AbXKOWFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765790AbXKOWFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:05:01 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:42744 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757809AbXKOWFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:05:00 -0500
Date: Thu, 15 Nov 2007 23:06:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
Message-ID: <20071115220640.GA25265@uranus.ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org> <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org> <Pine.LNX.4.64.0711151616330.1817@scrub.home> <20071115192555.GD23914@uranus.ravnborg.org> <Pine.LNX.4.64.0711152036430.1817@scrub.home> <20071115204520.GA24851@uranus.ravnborg.org> <Pine.LNX.4.64.0711152158310.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711152158310.1817@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 10:24:05PM +0100, Roman Zippel wrote:
> Hi,
> 
> On Thu, 15 Nov 2007, Sam Ravnborg wrote:
> 
> > > Can we please can get some consistency in this?
> > > We have a .config file for a reason, what's wrong with using it?
> > 
> > We need to set a selected few values in a few cases where we do
> > not have a .config file.
> > allmodconfig for x86 for instance. We would like to generate a
> > 32-bit and a 64-bit version.
> 
> This can already be set via all.config/allmod.config.
> Where is this need coming from? The point is that I don't like to add an 
> interface, which is maybe used by two people, who should be perfectly 
> capable using an existing superior mechanism.

When you say "two people" I am afraid we are not talking about the same case.

> 
> > > > > Please revert the K64BIT changes and use this instead.
> > > > 
> > > > I will finish up your patch and target it for next merge window.
> > > 
> > > Why can't this be fixed properly now? You don't even need this patch, just 
> > > use ARCH to set 64BIT in the Kconfig as I've shown.
> > Because the patch is in mainline and has been tested by a lot of people
> > during the last week. And as the functionality is almost equal I do not
> > see it as a big deal to have the less-perfect solution in one kernel release.
> > 
> > And the only reason the patch were applied to mainline was to fix the build
> > of the merged x86 architecute - otherwise it was in no way -rc material.
> 
> I showed you a solution, which requires no patch at all, while your patch 
> adds extra functionality which is questionable.
> Why is a quick hack preferable over a proper solution? 
> Either explain why my solution isn't usable or _please_ revert the K64BIT 
> changes.
You suggest just to check ARCH value and not apply your patch. This was
not my initial understanding as was hopefully obvious from my reply.

So you suggest to make the ARCH= setting on the command line mandatory
again even for a configured kernel which is a step backward.

I assume your patch also has this drawback - no?

If user did NOT specify ARCH we should use the kernel configuration - which
your solution fail to do.

If user did specify ARCH and the kernel is configured then what?
-> Ignore the ARCH= setting
-> Warn if they do not match
-> Always adhere to the ARCH setting

Accepting the solution where we check the ARCH as you suggested and
loose the benefits of letting the configuration be the master should
be OK for upcoming kernel release.

	Sam
