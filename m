Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYIEEDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYIEEDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 00:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbYIEEDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 00:03:38 -0400
Received: from 1wt.eu ([62.212.114.60]:3191 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYIEEDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 00:03:37 -0400
Date: Fri, 5 Sep 2008 06:03:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: ivaylo@bglans.net, linux-kernel@vger.kernel.org
Subject: Re: Marvel IDE 88SE6101 2.4.XX support
Message-ID: <20080905040326.GB17104@1wt.eu>
References: <Pine.LNX.4.62.0708102357470.24424@mail.bglans.net> <Pine.LNX.4.64.0809042115350.11281@mail.bglans.net> <20080904193625.652bf013@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904193625.652bf013@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, Sep 04, 2008 at 07:36:25PM +0100, Alan Cox wrote:
> On Thu, 4 Sep 2008 21:26:12 +0300 (EEST)
> ivaylo@bglans.net wrote:
> 
> > 
> > Another one small patch to support Marvel IDE 88SE6101 controler. I have 
> > one on Intel DG33BU motherboard. It is detect as
> > 02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101 single-port 
> > PATA133 interface (rev b2)
> 
> Its a pretty generic device - see drivers/ata/pata_marvell.c so IDE
> generic will probably do roughly the right things. The pata_marvell
> driver documents how to do cable detect, which you may want to add and
> make it its own driver.

Indeed, your driver is clear enough to serve as a doc. Looking at
ata_piix.c in 2.4, I see that the libata core has evolved a lot,
but backporting your work should not be hard at all. Among other
things, the driver needs to set ap->cbl itself during reset, for
instance.

However, I wonder if it's really worth doing it if the IDE generic
driver already works. The PATA port on such motherboards today is
mostly used by CD/DVD, and I think that even if we limit ourselves
to 40-pin, it's not dramatic (all my IDE CD drives have always been
running that way for ages).

Or maybe this would be more interesting for other chips of the same
family ?

Ivaylo, if you're interested in trying to backport pata_marvell.c
from 2.6 to 2.4, that's fine for me, just inform me so that I know
I'm waiting for you. Otherwise I can merge your IDE generic patch.
In this case, could you repost your patch after fixing the name
"MARVEL" in the PCI IDs (=> "MARVELL") ?

Thanks,
Willy

