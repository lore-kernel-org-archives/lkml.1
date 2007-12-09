Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbXLIUL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbXLIUL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 15:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbXLIULw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 15:11:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:45297 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXLIULv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 15:11:51 -0500
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071209133923.4c35147b@the-village.bc.nu>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	 <1197185091.6572.38.camel@pasglop> <1197193794.6572.52.camel@pasglop>
	 <200712091346.25532.bzolnier@gmail.com>
	 <20071209133923.4c35147b@the-village.bc.nu>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 07:11:08 +1100
Message-Id: <1197231068.6563.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-09 at 13:39 +0000, Alan Cox wrote:
> > > In fact, I see a deeper problem with Bart's original patch that moved
> > > the "fixup" the PCI probe.
> > 
> > I don't remember changing anything there, could you remind me what it was
> > exactly (commit number or patch name)?
> 
> I'm pretty sure he means the code I added a while ago to actually correct
> our IDE/ATA handling for legacy devices, fix the resource tree being
> wrong and remove tons of special cases from drivers.

Yup, that one, sorry Bart, I thought it was from you.

So far, a quirk grep shows such quirks only in powerpc code though, in
the chrp and powermac platforms (mostly the same one copied over). I'll
do a fix that re-allocate all resources on these instead (though I
suppose another option would be to just write the legacy addresses to
the BARs after turning it into native mode... probably even better).

Ben.


