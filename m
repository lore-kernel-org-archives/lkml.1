Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYICA3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYICA3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYICA2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:28:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35688 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754172AbYICA2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:28:50 -0400
Date: Wed, 3 Sep 2008 01:27:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: torvalds@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ahci: Fix long standing Marvell regressions
Message-ID: <20080903012728.14b19d9b@lxorguk.ukuu.org.uk>
In-Reply-To: <48BDCF09.7000603@garzik.org>
References: <20080903000538.7500eaf8@lxorguk.ukuu.org.uk>
	<48BDCF09.7000603@garzik.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Completely and utterly false.  libata-dev.git#mv-ahci-pata has not yet 
> gone upstream, as is blatantly clear if you had bothered to LOOK.

Oh I beg your pardon - you only pushed the PCI identifiers that broke
stuff rather than the code that went with it you never finished. So does
that actually sound better "hey this was broken, not merged but I pushed
the IDs part *knowing* it would cause serious regressions" ?

Bit rich telling me to LOOK (emphasis yours) when your last email says

"Situation before ahci mod:

	Users with PATA may use pata_marvell.
	Users wanting SATA screwed."

Jeff - pata_marvell has always supported SATA.

> You omit details that hurt your case, namely that a ton of users were 
> asking for AHCI support EVEN IF IT IS SATA ONLY, because the SATA 
> support via pata_marvell legacy mode was so poor and problematic.

Actually it just works. You don't get Phy diagnostics that is about all
you lose (and NCQ for performance).

> Among the pata_marvell complaints I received that were solved were:
 
> * bloody awful error handling, with no hotplug support

Full SFF error handling. Warmplug but not automatic hotplug detect. But
hey at least you *can install the damned machine* and the machine that
was working in FC 8 might actually still be working.

(But you clearly didn't know this because your last email to linux-ide
claimed the pata_marvell driver didn't support the SATA ports)

> * problems with suspend/resume (apparently some BIOS assumed you were in 
> AHCI/enhanced mode)

Some assume you are not too.

> > +#if  !defined(CONFIG_PATA_MARVELL) && !defined(CONFIG_PATA_MARVELL_MODULE)
> >  	/* Marvell */
> 
> this prevents users from choosing the driver that works best for them, 
> including bringing back all the SATA problems just as you bring back PATA.

Not really, its in the config script. Oh that hard for users, then tell
me why 'editing the initrd' before installing is acceptable ?

At runtime it might make sense to allow ahci.marvell=1. I can add that in
about 60 seconds if you want now you've finally been forced to stop
ignoring the issue. That would allow the distros to ship pata_marvell and
users to say "actually I want full SATA support".

Unfortunately there isn't a documented way to check the 6121 PATA port
has a drive attached so pata_marvell can punt if it isn't.

> The attached patch is more reasonable, but neither your nor my patch 
> actually address the relevant problem:  distros choosing the module.

Currently distributions can't compile in pata_marvell and remove the
broken ahci support for it. That is a *huge* problem.

> So at this point, applying your patch would create regressions just as 
> it purports to solve regressions, since Marvell AHCI is out there in 
> active use as well.

A mess *you* created by repeatedly ignoring the problems that were
pointed out to you and then ignoring attempts to raise it. Meanwhile I've
been getting zillions of bug reports and emails about it. You dug the
hole and ran away with your fingers in your ears while I got all the bugs
and complaints.

> 1) Applying my attached patch

Your patch is a no-op. No distribution of any note builds them
non-modular. You know this so I find it incredulous you propose this
no-op change. Trying to pull the wool over Linus eyes ?

> 2) Communicating with distros

Well you've been ignoring bugzilla for months so doing something about
that would be a start. It isn't the distros who've not been communicating.

> 3) See if we can get Marvell docs to someone willing to code in support. 
>   Marvell has been very responsive in the past year with regards to 
> 'mvsas', so maybe they can help here too.

or to provide docs on the pata port. I'm assuming its probably as trivial
as "issue one command at a time". In SFF mode the chip does all the
management itself so it's obvious smart enough to do the work.

But your proposed patch is a joke and you *know* it.

Alan
