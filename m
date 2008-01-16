Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYAPNuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYAPNuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYAPNur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:50:47 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:51915 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbYAPNuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:50:46 -0500
Date: Wed, 16 Jan 2008 14:50:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, david-b@pacbell.net,
       linux-kernel@vger.kernel.org
Subject: Re: non-choice related config entries within choice
Message-ID: <20080116135050.GA27546@uranus.ravnborg.org>
References: <478DF61E.76E4.0078.0@novell.com> <20080116115233.GA26776@uranus.ravnborg.org> <478E18E1.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478E18E1.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 01:46:57PM +0000, Jan Beulich wrote:
> >But one feature I really would like to see is named chocies so we can do stuff like:
> >
> >choice X86_PROCESSOR
> >
> >config GENERIC_PROCESSOR
> >	bool "A generic X86 processor"
> >endchoice
> >
> >
> >...
> >
> >choice PPC_PROCESSOR
> >
> >config GENERIC_PROCESSOR
> >	bool "A generic PowerPC processor
> >
> >endchoice
> >
> >The issue here is that we do not today allow the same config option
> >to appear if more than one choice.
> 
> I want named choices, too, but for a different purpose (and not
> unconditionally): Currently, a choice really can just be a selection
> between individual boolean settings or (as the current intended
> extension) a mixture of boolean and tristate values. String or
> numerical values aren't permitted (and iirc they even cause the config
> process to crash). Nevertheless there are a couple of example where
> choosing between individual string or numeric values is intended (but
> needs to be made work with the current infrastructure, meaning that
> one first chooses between boolean values and then selects (or sets
> through default values in prompt-less config options) the intended
> string or numeric value.
> 
> What you want seems much more fundamental a change, and as I
> understand it you really want the name just as a name space
> separation mechanism.
> 
> >This is a mandatory feature before we can do a Kconfig covering all architectures.
> >I guess there are other issues when we do:
> >
> >if X86
> >source foo/bar/Kconfig
> >endif
> >
> >if PPC
> >source foo/bar/Kconfig
> >endif
> >
> >Where we in foo/bar/Kconfig has a choice list.
> 
> That you be done with
> 
> if X86 || PPC
> source foo/bar/Kconfig
> endif

The problem is that the two source happens in different places as they
are part of a menu structure. So the Kconfig files cannot easily be refactored
to use a sinlge source per file.

	Sam
