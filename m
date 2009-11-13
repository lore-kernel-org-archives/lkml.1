Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZKMV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZKMV2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 16:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZKMV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 16:28:14 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36384 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753147AbZKMV2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 16:28:13 -0500
Date: Fri, 13 Nov 2009 21:30:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Message-ID: <20091113213007.774e75e3@lxorguk.ukuu.org.uk>
In-Reply-To: <200911132039.06929.bzolnier@gmail.com>
References: <4AFCC0D4.9020708@gmail.com>
	<200911131715.24377.bzolnier@gmail.com>
	<20091113182515.38fb3793@lxorguk.ukuu.org.uk>
	<200911132039.06929.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Not experimental as we default to not doing ATAPI DMA. Glancing over the
> 
> Which is a regression compared to the "old IDE" driver.

And given the two drivers show the difference when exactly the sequence
of I/O writes/reads occurs one that nobody plans to worry about as its
clearly some kind of hardware timing issue.

> > code I notice the ALI C2/C3 workaround probably wants adding to the old
> > driver as it can do nasty things otherwise. (See the reset function in
> > the pata_ali driver)
> 
> Please let the driver's maintainer know about it.
> 
> One would wonder why workaround hasn't been back-ported to stable driver

It's in the stable driver, might not be in drivers/ide. The note about it
being missing was posted out to various people at the time so I guess it
got missed

> > > PATA_CMD64X: EXPERIMENTAL
> > > - potential data corruption issues remains unfixed for CMD64[3,6]
> > 
> > Patch in testing, and unlike the old IDE one it doesn't cripple the
> > controller but implements the proper workaround in full including
> > permitting parallel PIO command streams. I'll push that back through
> > stable once done.
> 
> This patch is way too complex and risky for -rc, let alone -stable.

How would you know - I've not posted it yet ? And btw I don't plan to
post it for the -rc. Nor would simply posting a serializing hack fix it.
It might make it less likely to occur but that isn't a fix.

> > it. Trivial and fixed.
> 
> I can't see a fix anywhere but I'll assume that I can't look for it
> properly (I'm really sorry for it).

Fixed as in I fixed it now. Which is why I just noticed the old IDE ones
are buggy. I'll add it to the next patch sets for Jeff, along with the
Toshiba driver and some other bits.

Alan


