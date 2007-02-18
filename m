Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbXBRTZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbXBRTZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 14:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXBRTZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 14:25:29 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:43301 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbXBRTZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 14:25:28 -0500
Date: Sun, 18 Feb 2007 20:25:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: kbuild question
Message-ID: <20070218192535.GA2425@uranus.ravnborg.org>
References: <930B9C2E-DCE3-4E9E-AA6B-2C58E16736B2@kernel.crashing.org> <Pine.LNX.4.64.0702161121540.14458@scrub.home> <9AF725F4-FE65-4357-B7EB-CC03808C105D@kernel.crashing.org> <Pine.LNX.4.64.0702181811220.14457@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702181811220.14457@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Sure, on powerpc for some of the embedded sub-architectures you can only
> > select a single board to build for.  For a lot of people this is sufficient,
> > however we are moving towards a world where you can easily build in support
> > for multiple boards into a single kernel.
> > 
> > I'd like to have it such that if I'm only building support for one board
> > (CONFIG_ONLY_HAVE_ONE, not going to call it that, but for this discussion its
> > sufficient), you get a choice menu from Kconfig enforcing the ability to only
> > select one board.  However if !CONFIG_ONLY_HAVE_ONE than you can select
> > multiple boards to build into your kernel.
> > 
> > if CONFIG_ONLY_HAVE_ONE is set we can optimize out the runtime checks that get
> > added for handling the multiple board case.
> 
> On m68k we have the same problem, but what I'm what I'm considering is to 
> add a new mode for choice groups - at least one must be selected and 
> kconfig generates the extra information if only one is selected.

How about extendign the current 'option' syntax to do this?
So we could do something like:

choice
	prompt "choice prompt"
	default VAL_FIRST
	option multivalue if !CONFIG_ONLY_HAVE_ONE

config VAL_FIRST
	bool "first"

config VAL_SECOND
	bool "second"

endchoice

It seems to fit well with how option is used today, and extends current
syntax nicely.

	Sam
