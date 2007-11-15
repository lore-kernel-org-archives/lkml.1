Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbXKOTYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbXKOTYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759300AbXKOTYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:24:16 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:49422 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbXKOTYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:24:15 -0500
Date: Thu, 15 Nov 2007 20:25:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
Message-ID: <20071115192555.GD23914@uranus.ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org> <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org> <Pine.LNX.4.64.0711151616330.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711151616330.1817@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 04:43:03PM +0100, Roman Zippel wrote:
> Hi,
> 
> On Wed, 14 Nov 2007, Sam Ravnborg wrote:
> 
> > The value can be supplied on the command-line so we need to validate input.
> 
> Is there a need for this?
Yes. We would like to set 64BIT or not in other than x86 cases.
And way forward was not to override ARCH as in the x86 case.


> BTW ARCH was already available as a value in the Kconfig files, so setting 
> the 64BIT option was already possible without any changes the kconfig 
> system, e.g.:
> 
> config 64BIT
> 	bool "64 Bit kernel" if ARCH!="i386" && ARCH!="x86_64"
> 	default ARCH="x86_64"

I thought this was not possible but it must have been the limitation
of choice symbols I have hit when I played with it.


> The patch below adds some features to it:
> - it allows to import any environment variable by specifying "option env=..."
> - it generates a dependency on it, so the kernel config is updated if it 
> changes.
> 
> Please revert the K64BIT changes and use this instead.

I will finish up your patch and target it for next merge window.
Thanks.

> 
> > The code is a copy of what happen when reading a all.config file and
> > the functionality should be equal.
> > Can we make that part simpler too?
> 
> These are two different uses, when reading a .config only the basic syntax 
> is checked, but not the value itself.
This is wrong considering the amount of people that hand edit the .config file.


> > By the way - I have never understood the purpose of the flags (S_DEF_USER etc.)
> > Can we have a few comments added to their definition?
> 
> It allows to hold multiple configs, a user of it is conf_split_config() 
> which loads another config and compares to the current config and updates 
> the files under include/config as needed.
> It could also be used by front ends to display what actually changed 
> compared to e.g. the saved config.

Took a deeper look.
So we can have 4 different set of vlaues where the value indexed by S_DEF_USER
is the one that is actually used and the other three can be used to hold values.

I will try to document this in expr.h
Patch will be sent to you for review.

> > One of the blockers are that kconfig does not support more than one prompt
> > for a choice symbol. Is this something you can fix - or sketch how to fix it?
> 
> The basic idea is to add a name to the choice, so multiple choices can be 
> grouped together. This requires some changes to the dependency check to 
> make sure one choice option doesn't depend on another (which is currently 
> enforced by the syntax).
Do you have any suggestions how to properly fix this?

	Sam
