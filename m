Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbYFCHrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbYFCHrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 03:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYFCHrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 03:47:04 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:47651 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbYFCHrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 03:47:03 -0400
Date: Tue, 3 Jun 2008 09:46:46 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, benh@kernel.crashing.org,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080603094646.0dbf2911@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080602154812.GB2734@loki.buserror.net>
References: <1211924335.3286.89.camel@pasglop>
	<20080527214241.GA22636@parisc-linux.org>
	<1211926636.3286.100.camel@pasglop>
	<20080528103648.54eb8734@hskinnemo-gx745.norway.atmel.com>
	<1212110003.15633.0.camel@pasglop>
	<20080530080700.773a82cc@siona.local>
	<1212132267.15633.69.camel@pasglop>
	<20080530102706.56fca248@siona.local>
	<Pine.LNX.4.64.0805301120510.26332@anakin>
	<20080602101102.0d8979c5@hskinnemo-gx745.norway.atmel.com>
	<20080602154812.GB2734@loki.buserror.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2008 07:46:18.0085 (UTC) FILETIME=[E8513950:01C8C54D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood <scottwood@freescale.com> wrote:
> On Mon, Jun 02, 2008 at 10:11:02AM +0200, Haavard Skinnemoen wrote:
> > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Fri, 30 May 2008, Haavard Skinnemoen wrote:
> > > > Maybe we need another interface that does not do byteswapping but
> > > > provides stronger ordering guarantees?
> > > 
> > > The byte swapping depends on the device/bus.
> > 
> > Of course. But isn't it reasonable to assume that a device integrated
> > on the same silicon as the CPU is connected to a somewhat sane bus
> > which doesn't require any byte swapping?
> 
> No, unfortunately. :-(

Ok, I guess I was being naive.

> See the end of drivers/dma/fsldma.h.  Likewise with Freescale's PCI host
> bridges; for some reason the bus itself being little endian led to the host
> bridge control registers also being little endian.

Right. But still, isn't it better to handle it on a case-by-case basis
in the drivers? In some cases, it's best to explicitly use a certain
byte order, in others it's best to use whatever is native to the CPU.

Haavard
