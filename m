Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbXKOUnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbXKOUnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbXKOUnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:43:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33970 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325AbXKOUnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:43:42 -0500
Date: Thu, 15 Nov 2007 21:45:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
Message-ID: <20071115204520.GA24851@uranus.ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org> <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org> <Pine.LNX.4.64.0711151616330.1817@scrub.home> <20071115192555.GD23914@uranus.ravnborg.org> <Pine.LNX.4.64.0711152036430.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711152036430.1817@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman.

> > > > The value can be supplied on the command-line so we need to validate input.
> > > 
> > > Is there a need for this?
> > Yes. We would like to set 64BIT or not in other than x86 cases.
> > And way forward was not to override ARCH as in the x86 case.
> 
> Can we please can get some consistency in this?
> We have a .config file for a reason, what's wrong with using it?

We need to set a selected few values in a few cases where we do
not have a .config file.
allmodconfig for x86 for instance. We would like to generate a
32-bit and a 64-bit version.

> 
> > > Please revert the K64BIT changes and use this instead.
> > 
> > I will finish up your patch and target it for next merge window.
> 
> Why can't this be fixed properly now? You don't even need this patch, just 
> use ARCH to set 64BIT in the Kconfig as I've shown.
Because the patch is in mainline and has been tested by a lot of people
during the last week. And as the functionality is almost equal I do not
see it as a big deal to have the less-perfect solution in one kernel release.

And the only reason the patch were applied to mainline was to fix the build
of the merged x86 architecute - otherwise it was in no way -rc material.
> 
> > > These are two different uses, when reading a .config only the basic syntax 
> > > is checked, but not the value itself.
> > This is wrong considering the amount of people that hand edit the .config file.
> 
> It's not, the actual symbol value is set later depending on the dependency 
> constraints.
My point is that the .config file is handedited so the syntax should be checked
to best possible extent. If someone specify CONFIG_64BIT=64 we should error out.

	Sam
