Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXLIUEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXLIUEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 15:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXLIUEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 15:04:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:41784 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbXLIUEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 15:04:33 -0500
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
In-Reply-To: <20071209133812.2d305a02@the-village.bc.nu>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	 <1196899818.7033.11.camel@pasglop>
	 <200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
	 <1196917447.7033.17.camel@pasglop>
	 <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
	 <1196922262.7033.33.camel@pasglop> <20071209021231.GA13729@linux-mips.org>
	 <1197185091.6572.38.camel@pasglop> <1197193794.6572.52.camel@pasglop>
	 <20071209133812.2d305a02@the-village.bc.nu>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 07:03:29 +1100
Message-Id: <1197230609.6563.6.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-09 at 13:38 +0000, Alan Cox wrote:
> > has, I don't know for sure), we have a quirk that puts those
> controller
> > back into native mode. But so far, those quirks didn't change the
> > resources as they were supposed to contain the proper BAR values
> that
> > would, from then, be used.
> 
> Then your quirk is faulty (for the general case). The BAR values are
> undefined at that point, they may not even be writable.

Possibly, however, the fact is that those quirks "just worked" on all HW
where we used them in the past, so while in "theory" they are incorrect,
in practice, this is a regression and thus needs to be fixed.

> Improbable unless its willing to rely on entirely undefined behaviour.

I would argue to you that the whole legacy PCI thing is mostly
"undefined behaviour" from day 1. We rely on what worked in practice for
us, period. It's broken now, this is a regression. I'm not saying we
should revert the change in the generic code, I'm just raising an alarm
here as I doubt we are the only platform to do that (heh, I didn't even
write those quirks in the first place) and some fixing is needed in that
area. I'm totally fine with changing the quirks to do the "right"
though.

> If you kick the device out of legacy mode (itself very very board
> dependant) then you must find a suitable new resource allocation for
> the controller. 

Quite possibly, though as I said in practice, what we did so far
happened to "just work" on pretty much everything we were faced with
(which iirc is basically winbond and VIA controllers, possibly a few
others).

Anyway, I'll scrub around. Again, I'm not saying the approach is wrong
in the generic code.

Ben.


