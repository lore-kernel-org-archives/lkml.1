Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbXKSOB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbXKSOB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbXKSOBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:01:48 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:48708 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbXKSOBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:01:47 -0500
Date: Mon, 19 Nov 2007 08:57:09 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Paul Mundt <lethal@linux-sh.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: even *more* unused CONFIG variables at no extra charge
In-Reply-To: <20071119134316.GA12158@linux-sh.org>
Message-ID: <alpine.LFD.0.9999.0711190850540.23579@localhost.localdomain>
References: <alpine.LFD.0.9999.0711160555530.13454@localhost.localdomain> <20071119134316.GA12158@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, Paul Mundt wrote:

> On Fri, Nov 16, 2007 at 06:15:48AM -0500, Robert P. J. Day wrote:
> > ==== sh64 ====
> > >>>>> DEVICE_MEMORY_START
> > >>>>> FLASH_MEMORY_START
> > >>>>> HDSP253_LED
> > >>>>> PCI_BLOCK_START
> > >>>>> PCIDEVICE_MEMORY_START
>
> Yeah, these are mostly bogus and just never got removed. I'll poke
> through it and kill them off or fix up the Makefiles to actually use
> them (as in the HDSP253_LED case). Thanks for catching these, these
> sorts of reports are really useful.
>
> Have you considered tidying up your config checker and adding it as
> a static analyser target with the existing set? 'make configcheck'
> or something would be a reasonable addition.

i've thought about that but, really, i doubt it's worth it for a
couple reasons.  first is that this sort of cleanup isn't what you'd
call life or death.  it's rare that dealing with any of this output
actually fixes a bug -- it's mostly for aesthetics so even i'll be the
first to admit that it's not high priority.

also, some of those checks take a looooooooong time.  i mean, we're
talking *hours* as each CONFIG variable might invoke a tree-wide grep.
you don't start some of these checks and go for coffee; you start some
of them and drive into toronto for a leafs game, if you catch my
drift.

and it's not like you need to run these checks on a really regular
basis.  i've come to realize it's sufficient to do the entire suite
shortly after each merge window, post the results, and let people take
it from there until the next merge window.  in between, it's not like
things are going to change drastically.

however, having said all that, one thing that would make a *huge*
difference in reducing false positives is if people would stop naming
their hard-coded Makefile variables with a "CONFIG_" prefix.  man,
that's irritating.  :-)

rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
