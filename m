Return-Path: <linux-kernel-owner+w=401wt.eu-S933197AbXKOVYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197AbXKOVYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbXKOVYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:24:14 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:4690 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbXKOVYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:24:13 -0500
Date: Thu, 15 Nov 2007 22:24:05 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
In-Reply-To: <20071115204520.GA24851@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0711152158310.1817@scrub.home>
References: <20071110204038.GA13140@uranus.ravnborg.org>
 <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org>
 <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711151616330.1817@scrub.home> <20071115192555.GD23914@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711152036430.1817@scrub.home> <20071115204520.GA24851@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 15 Nov 2007, Sam Ravnborg wrote:

> > Can we please can get some consistency in this?
> > We have a .config file for a reason, what's wrong with using it?
> 
> We need to set a selected few values in a few cases where we do
> not have a .config file.
> allmodconfig for x86 for instance. We would like to generate a
> 32-bit and a 64-bit version.

This can already be set via all.config/allmod.config.
Where is this need coming from? The point is that I don't like to add an 
interface, which is maybe used by two people, who should be perfectly 
capable using an existing superior mechanism.

> > > > Please revert the K64BIT changes and use this instead.
> > > 
> > > I will finish up your patch and target it for next merge window.
> > 
> > Why can't this be fixed properly now? You don't even need this patch, just 
> > use ARCH to set 64BIT in the Kconfig as I've shown.
> Because the patch is in mainline and has been tested by a lot of people
> during the last week. And as the functionality is almost equal I do not
> see it as a big deal to have the less-perfect solution in one kernel release.
> 
> And the only reason the patch were applied to mainline was to fix the build
> of the merged x86 architecute - otherwise it was in no way -rc material.

I showed you a solution, which requires no patch at all, while your patch 
adds extra functionality which is questionable.
Why is a quick hack preferable over a proper solution? 
Either explain why my solution isn't usable or _please_ revert the K64BIT 
changes.

> > > > These are two different uses, when reading a .config only the basic syntax 
> > > > is checked, but not the value itself.
> > > This is wrong considering the amount of people that hand edit the .config file.
> > 
> > It's not, the actual symbol value is set later depending on the dependency 
> > constraints.
> My point is that the .config file is handedited so the syntax should be checked
> to best possible extent. If someone specify CONFIG_64BIT=64 we should error out.

The other function doesn't complain about it either. There is already 
only limited error checking, e.g. there is no complaint that the value 
isn't really set (because it was selected by something else), otherwise 
the .config check during a kernel upgrades would be a lot noisier than it 
already is. Anyone directly editing .config should know what he is doing.

bye, Roman
