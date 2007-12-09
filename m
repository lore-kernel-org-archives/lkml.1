Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbXLIWr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbXLIWr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXLIWrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:47:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:51082 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbXLIWrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:47:51 -0500
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20071209222335.70e52be3@the-village.bc.nu>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	 <1196899818.7033.11.camel@pasglop>
	 <200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
	 <1196917447.7033.17.camel@pasglop>
	 <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
	 <1196922262.7033.33.camel@pasglop> <20071209021231.GA13729@linux-mips.org>
	 <1197185091.6572.38.camel@pasglop> <1197193794.6572.52.camel@pasglop>
	 <20071209133812.2d305a02@the-village.bc.nu>
	 <1197230609.6563.6.camel@pasglop>
	 <20071209222335.70e52be3@the-village.bc.nu>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 09:47:12 +1100
Message-Id: <1197240432.6563.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-09 at 22:23 +0000, Alan Cox wrote:
> 
> I think the generic code is right, up to the MIPS stuff. What the MIPS
> stuff is doing wants looking at further. If it simply can't address
> legacy ports them it should set

Yes, well, we -do- need to remove the pcibios_resource_to_bus() things
that were added to the generic code. That commit still needs to be
reverted, it is bogus, as I explained in details. But I agree, the rest
of the generic code is probably the best way to deal with those stupid
fixed resources.

> For switching quirks you should be fixing the class code in an early
> fixup. The early fixups are run before we do the BAR processing. You
> must however remember to update dev->class as well as the PCI register
> if you do so.

I would still need to clear out the BARs I suppose when switching from
legacy to native mode, so they get re-assigned later.

> See quirk_svwkrs_csb5ide() for a correct worked example going in the
> other direction. If you follow that for the PPC quirks but going
> native
> then you will get desired results, although you want to check/know the
> BAR
> resources are sane, or clear them as part of the process.

Ok.

> So in summary:
>         - MIPS resource/bar bit may be wrong - if so lets revert that
>         - Rest of the logic is just fine, but you may need to move
> your
> quirks to be 'early' ones.

I'm digging the HW that needs that stuff right now so I can experiment
with various approaches and pick up the best one. Thanks.

Cheers,
Ben.


