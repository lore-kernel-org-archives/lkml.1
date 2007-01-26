Return-Path: <linux-kernel-owner+w=401wt.eu-S1030199AbXAZETc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030199AbXAZETc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 23:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030647AbXAZETc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 23:19:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51281 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030199AbXAZETb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 23:19:31 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701251932250.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain>
	 <1169741658.3593.98.camel@shinybook.infradead.org>
	 <20070125172739.0c990a9a@localhost.localdomain>
	 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
	 <1169770985.3593.146.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
	 <1169778239.3593.195.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org>
	 <1169782107.3593.219.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701251932250.25027@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 26 Jan 2007 12:19:10 +0800
Message-Id: <1169785150.3593.231.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 20:00 -0800, Linus Torvalds wrote:
> The resource code really is totally agnostic, and you're barking up the 
> wrong tree there. In many ways, the resource code isn't even about "IO 
> resources", it could do other things too. 

Of course it could, but then again why shouldn't we special-case zero in
_all_ of those use cases, just to make life easier for those poor driver
authors who presumably can't manage to write userspace code using stdin
or open() either.

I've already _said_ I think it's barking up the wrong tree; I think we
should just fix the driver code. But you disagree, so I'm trying to
understand what _you_ think the answer is here -- how the architecture
code should cope with this new decree that PIO address zero is invalid
even though it's actually always been OK in the past.

On this particular platform I believe that the PCI I/O resources are
allocated by firmware before we boot, and they look something like
this...

00000000-007fffff : /pci@f2000000
  00000000-0000000f : pcmcia_socket0    (the CF card at zero)
  00001000-000011ff : PCI CardBus #11
  00001400-000015ff : PCI CardBus #11
00802000-01001fff : /pci@f0000000
  00802400-008024ff : 0000:00:10.0
ff7fe000-ffffdfff : /pci@f4000000

Since you don't like the idea that the resource code should special-case
zero, are you instead suggesting that we should _reassign_ the
already-assigned PCI resources when we boot, just to make sure that
driver authors don't have to deal with zeroes (at least, not until they
start to think about DMA)? Or are you thinking of some other solution?

-- 
dwmw2

