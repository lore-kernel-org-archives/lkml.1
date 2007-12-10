Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbXLJPsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbXLJPsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXLJPr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:47:58 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:52687 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbXLJPr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:47:57 -0500
Date: Mon, 10 Dec 2007 15:47:32 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: benh@kernel.crashing.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071210154732.GB19384@linux-mips.org>
References: <20071209021231.GA13729@linux-mips.org> <1197185091.6572.38.camel@pasglop> <1197193794.6572.52.camel@pasglop> <20071209133812.2d305a02@the-village.bc.nu> <1197230609.6563.6.camel@pasglop> <20071209222335.70e52be3@the-village.bc.nu> <1197260962.6563.46.camel@pasglop> <20071210112050.0bd6ac28@the-village.bc.nu> <20071210134056.GC12913@linux-mips.org> <20071210150126.7cec9cbc@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210150126.7cec9cbc@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 03:01:26PM +0000, Alan Cox wrote:

> > It seems the whole MIPS resource managment is complicated enough (out of
> > necessity) that only a few people actually grok it.  Ioports being
> > actually memory mapped on MIPS only makes the confusion worse, sigh.
> 
> If the hardware cannot map the low PCI space then set
> CONFIG_NO_ATA_LEGACY and the ATA layer will leave legacy ports alone.
> Unfortunately its not clear we can make that mode try and force
> controllers into native. We could try that if the MIPS and PPC people
> want ?

It sounds like a reasonable thing to try at this stage.

this btw is the lspci -v output for the IDE controller from a recent Cobalt
kernel:

> 0000:00:09.1 IDE interface: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> (prog-if 8a [Master SecP PriP])
>         Flags: bus master, fast Back2Back, medium devsel, latency 64
>         I/O ports at 1820 [size=16]

And that's lspci -v -b:

> 0000:00:09.1 IDE interface: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> (prog-if 8a [Master SecP PriP])
>         Flags: bus master, fast Back2Back, medium devsel, latency 64
>         I/O ports at 10001820

So the IDE controller already seems to be in native mode?

   Ralf
