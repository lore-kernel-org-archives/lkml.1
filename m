Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXLKALg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXLKALg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 19:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbXLKAL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 19:11:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:57506 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbXLKAL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 19:11:28 -0500
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20071210230716.38da105a@the-village.bc.nu>
References: <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
	 <1196922262.7033.33.camel@pasglop> <20071209021231.GA13729@linux-mips.org>
	 <1197185091.6572.38.camel@pasglop> <1197193794.6572.52.camel@pasglop>
	 <20071209133812.2d305a02@the-village.bc.nu>
	 <1197230609.6563.6.camel@pasglop>
	 <20071209222335.70e52be3@the-village.bc.nu>
	 <1197260962.6563.46.camel@pasglop>
	 <20071210112050.0bd6ac28@the-village.bc.nu>
	 <20071210134056.GC12913@linux-mips.org>
	 <20071210150126.7cec9cbc@the-village.bc.nu>
	 <1197319154.8692.13.camel@pasglop>
	 <20071210230716.38da105a@the-village.bc.nu>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 11:10:53 +1100
Message-Id: <1197331853.9071.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-10 at 23:07 +0000, Alan Cox wrote:
> > Forcing controllers into native mode tends to be something that really
> > only works on -some- controllers. I'm happy to have a hack to try to do
> > that on all of them on powermacs, because the range of controllers that
> > might not be in native mode in the first place there is pretty small,
> > and for CHRP briq, I do it for a specific known controller only.
> 
> I'm thinking of doing this solely if the platform has
> CONFIG_ATA_NO_LEGACY set. In other words we'd only try this stunt on a
> system we *know* cannot address the low PCI space ports.

Allright. I don't set CONFIG_ATA_NO_LEGACY on powerpc anyway, as I do
support legacy ATA just fine on a range of machines. 

For example, Pegasos does the a quirk the other way around which is to
put it back the VIA IDE into legacy mode as there are issues with the
way that VIA chipset is configured on those machines.

It's mostly a matter of making sure for me that the IRQ routing match
what the platform code is set to deal with or that sort of thing as
unfortunately, anything that involves legacy stuff is still pretty much
full of hacks.

Ben.


