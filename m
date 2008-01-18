Return-Path: <linux-kernel-owner+w=401wt.eu-S1763215AbYARRL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763215AbYARRL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762046AbYARRLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:11:10 -0500
Received: from waste.org ([66.93.16.53]:43874 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761808AbYARRLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:11:08 -0500
Subject: Re: [PATCH] x86:
	fix	unconditional	arch/x86/kernel/pcspeaker.c?compiling
From: Matt Mackall <mpm@selenic.com>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4790D3E3.4060409@free-electrons.com>
References: <200801171643.49301.michael-lists@free-electrons.com>
	 <478F8AEC.1080209@free-electrons.com>
	 <1200590031.5332.19.camel@cinder.waste.org>
	 <200801172315.29976.michael-lists@free-electrons.com>
	 <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com>
	 <20080118122540.GH11044@elte.hu> <20080118122926.GA15216@elte.hu>
	 <4790A385.800@free-electrons.com>
	 <1200664214.4001.24.camel@cinder.waste.org>
	 <4790D3E3.4060409@free-electrons.com>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 11:10:19 -0600
Message-Id: <1200676219.3835.8.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 17:29 +0100, Michael Opdenacker wrote:
> On 01/18/2008 02:50 PM, Matt Mackall wrote:
> > On Fri, 2008-01-18 at 14:03 +0100, Michael Opdenacker wrote:
> >   
> >> However, wouldn't the Makefile look nicer if we introduced a
> >> CONFIG_PCSPEAKER setting as in the mips platform? We would just have:
> >>
> >> obj-$(CONFIG_PCSPEAKER)		+= pcspeaker.o
> >>     
> >
> > Yes, that would be cleaner. Not worth it for just x86, but there are
> > about 6 other arches that use CONFIG_INPUT_PCSPKR. Do that in one patch
> > on top of this one and send it to Andrew (who will pull the above into
> > his tree from Ingo shortly).
> >   
> Well, sorry for consuming your time with this very small change, but I'm
> not sure I understand what you're suggesting... Here's what I'd do:
> 
>     * I'd define  CONFIG_PCSPEAKER for x86 (typically in
>       arch/x86/Kconfig), to be set to "y"  when CONFIG_INPUT_SPKR is
>       set. This is what minimizes the changes to make.
>     * This way, we can just have:
>       obj-$(CONFIG_PCSPEAKER) += pcspeaker.o

Probably makes sense to define it right next to INPUT_PCSPKR in
drivers/input/Kconfig.

Then do the appropriate fix for all arches mentioned in INPUT_PCSPKR.

For extra points, you can move the duplicate pcspeaker.c code out of all
those arches and stash it somewhere in drivers/input. Presumably it's
possible to get it to link into the kernel even when INPUT is modular.

> Sounds fine! Don't hesitate to let us know about the lower-hanging fruit
> you're thinking about. Here are the main things I have so far:
> 
>     * Ideas in the existing Linux-Tiny patchset.
>     * Disable support for non-Intel processors in x86 (cyrix.c,
>       centaur.c, transmeta.c, nexgen.c, umc.c in arch/x86/kernel/cpu).
>       As far as I remember, I saved 15 KB when I first experimented with
>       this).

Isn't that already in -tiny?

>     * Disable support for readahead, page writeback, pdflush and swap
>       when we have no storage at all (typically booting from an
>       initramfs). This corresponds to 69 KB of source code!

That'd be nice, yes. It would probably make sense to be able to disable
just readahead support when we're working with only solid-state devices.

-- 
Mathematics is the supreme nostalgia of our time.

