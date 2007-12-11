Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbXLKAG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbXLKAG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 19:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXLKAGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 19:06:20 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:50546 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXLKAGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 19:06:19 -0500
Date: Tue, 11 Dec 2007 00:05:37 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071211000536.GA4067@linux-mips.org>
References: <1197193794.6572.52.camel@pasglop> <20071209133812.2d305a02@the-village.bc.nu> <1197230609.6563.6.camel@pasglop> <20071209222335.70e52be3@the-village.bc.nu> <1197260962.6563.46.camel@pasglop> <20071210112050.0bd6ac28@the-village.bc.nu> <20071210134056.GC12913@linux-mips.org> <20071210150126.7cec9cbc@the-village.bc.nu> <20071210154732.GB19384@linux-mips.org> <1197319383.8692.18.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197319383.8692.18.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 07:43:03AM +1100, Benjamin Herrenschmidt wrote:

> > > 0000:00:09.1 IDE interface: VIA Technologies, Inc.
> > > VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> > > (prog-if 8a [Master SecP PriP])
> > >         Flags: bus master, fast Back2Back, medium devsel, latency 64
> > >         I/O ports at 1820 [size=16]
> > 
> > And that's lspci -v -b:
> > 
> > > 0000:00:09.1 IDE interface: VIA Technologies, Inc.
> > > VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> > > (prog-if 8a [Master SecP PriP])
> > >         Flags: bus master, fast Back2Back, medium devsel, latency 64
> > >         I/O ports at 10001820
> > 
> > So the IDE controller already seems to be in native mode?
> > 
> 
> No, native mode is 5 not A in the low 4 bits of progif.
> 
> You need to be a bit careful about those VIA, I remember having issues
> on Pegasos where we left it in legacy mode. It think the problem is that
> even when switched, the IRQ routing might be done based on some other
> setting in the chipset, possibly a strap. But that's nothing you can't
> deal with an appropriate quirk in the arch code.
> 
> Also, double check the level/edge setting of the interrupts as it can be
> different between legacy and native (native is level low, legacy is
> rising edge).
> 
> I'm surprised however that one would use such a legacy southbridge on a
> platform that can't issue low IO ports, that doesn't seem to make sense
> to me ... there's a whole lot of things on this such as the 8259 PIC
> etc.. that can only be addressed via low IOs, unless the ISA space can
> be somewhat remapped ?

The GT-64111 system controller doesn't provide any kind of mapping
functionality that would help here.  So legacy port addressing can only
work by exploiting aliases due to incomplete decoding of legacy ioport
addreses by the VT82C586 - but direct addressing is impossible.

  Ralf
