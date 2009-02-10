Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZBJAxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZBJAxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 19:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZBJAwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 19:52:51 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:50329 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZBJAwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 19:52:51 -0500
Date: Mon, 9 Feb 2009 18:52:44 -0600
From: David Fries <david@fries.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide.c 'clear' fix, ide=nodma documentation
Message-ID: <20090210005244.GE2524@spacedout.fries.net>
References: <20090208220956.GA3278@spacedout.fries.net> <200902092057.54850.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902092057.54850.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 09 Feb 2009 18:52:45 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 08:57:54PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > I pretty much wasted my Saturday on this.  This is an older VIA
> > vt82c586b (rev 41) IDE UDMA33 and I've seen disk corruption in the
> > past with dma enabled, I can't use hdparm because those settings don't
> > persist across hibernate and restore (that should be another bug
> > report).  ide=nodma was working on the last 2.6.24 kernel, and
> > kernel-parameters.txt still lists it.  I had to go through the change
> > logs to figure out what happened to ide=nodma, then ide.c to figure
> > out what replaced it and what %d.%d:%d means (so I documented it so
> > other would have an easier time), then figure out how to set a module
> > parameter on the kernel command line when Kconfig said the module name
> > was ide and ide.nodma=0.0 didn't work, it was ide-core.nodma=0.0.
> > 
> > Now instead of,
> > ide=nodma
> > I have the following.
> > ide-core.nodma=0.0 ide-core.nodma=0.1 ide-core.nodma=1.0 ide-core.nodma=1.1
> 
> The important question is why do you have to use debug "=nodma" option?

> What disk is it?  Do we need to add it to DMA blacklist?

Model=Maxtor 6Y120P0, FwRev=YAR41BW0
Model=PLEXTOR CD-R PX-W4012A, FwRev=1.06

But I've had the same model in another computer without any issue and
each are on their own ribben cable.

> I don't recall any reports about such issues and via82cxxx host driver,
> have you tried to verify that this is not a faulty hardware?

I was expecting it to be faulty hardware, this isn't the only issue
with this FIC VA-503 motherboard.  I'm running one dimm because when I
had two memcheck passed everything but block moves and failed (alone
either dimm would pass).  I've been told the PCI controller doesn't
honor the don't do write combining which has taken driver work
arounds, I've had problems running a 3Com network card but had a hack
that would get it to work, another network card would randomly trash
memory and crash the computer, but infrequently enough that it took me
a while to finger it and switching to yet another card to solve it.

> Is the corruption present in any recent kernels?

I haven't tried.  At the time I had a formula for 'do this', and
sometimes it comes out corrupted.  The test case was reliable enough
that dma on corruption, off no corruption.  I looked and I couldn't
find it.  My time would be better spent replacing the system than
risking my filesystem and data in order to potentially get some
performance.  If I turn on dma and see a corruption I could positively
say it was still there, if I don't, well, I might have just not hit
the case.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
