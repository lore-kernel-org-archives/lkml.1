Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbXLKMOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbXLKMOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 07:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXLKMOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 07:14:18 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:51925 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXLKMOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 07:14:18 -0500
Date: Tue, 11 Dec 2007 12:13:43 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071211121343.GA10930@linux-mips.org>
References: <1197230609.6563.6.camel@pasglop> <20071209222335.70e52be3@the-village.bc.nu> <1197260962.6563.46.camel@pasglop> <20071210112050.0bd6ac28@the-village.bc.nu> <20071210134056.GC12913@linux-mips.org> <20071210150126.7cec9cbc@the-village.bc.nu> <20071210154732.GB19384@linux-mips.org> <1197319383.8692.18.camel@pasglop> <20071211000536.GA4067@linux-mips.org> <1197332844.9071.19.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197332844.9071.19.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 11:27:24AM +1100, Benjamin Herrenschmidt wrote:

> > The GT-64111 system controller doesn't provide any kind of mapping
> > functionality that would help here.  So legacy port addressing can only
> > work by exploiting aliases due to incomplete decoding of legacy ioport
> > addreses by the VT82C586 - but direct addressing is impossible.
> 
> Ok, that explains how the "fix" that we reverted worked. It caused crap
> to be added to the top bits of the address :-)
> 
> So here, what you really want to do is not a call to
> pcibios_resource_to_bus(), but you actually want to use a different bus
> address in the first place, that you know the HW will decode the same
> way.
> 
> The best way to achieve that imho, is to do a header quirk that is run
> just after the generic probe code, which offsets the fixed legacy
> resources by 0x10000000 since that's really the bus address you are
> going to emit.
> 
> Later on, your pcibios_fixup code should take that remove 0x10000000
> from all IO resources, since your 0xd0000000 mapping already maps
> 0x10000000 as you probably already do.
> 
> The trick is, you don't want to convert a "resource" into a "bus
> address" here, but really issue a different bus address.

Oh well, I've cooked up a patch and posted it to linux-mips for testing.

  Ralf
