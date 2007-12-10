Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbXLJUko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbXLJUko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 15:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbXLJUkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 15:40:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:41359 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbXLJUkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 15:40:36 -0500
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
In-Reply-To: <20071210150126.7cec9cbc@the-village.bc.nu>
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
Content-Type: text/plain
Date: Tue, 11 Dec 2007 07:39:14 +1100
Message-Id: <1197319154.8692.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-10 at 15:01 +0000, Alan Cox wrote:
> 
> If the hardware cannot map the low PCI space then set
> CONFIG_NO_ATA_LEGACY and the ATA layer will leave legacy ports alone.
> Unfortunately its not clear we can make that mode try and force
> controllers into native. We could try that if the MIPS and PPC people
> want ?

Forcing controllers into native mode tends to be something that really
only works on -some- controllers. I'm happy to have a hack to try to do
that on all of them on powermacs, because the range of controllers that
might not be in native mode in the first place there is pretty small,
and for CHRP briq, I do it for a specific known controller only.

I think if we start trying to do it for all of them, we'll get into
trouble. Some can't, some might look like they did but still route
interrupts the legacy way, etc...

I think that for that specific problem, a quirk might be the solution
MIPS wants. You can maybe use the same quirk I've posted in my other
patch for CHRP...

Cheers,
Ben.

