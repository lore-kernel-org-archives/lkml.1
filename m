Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbXFEO0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbXFEO0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764345AbXFEOZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:25:50 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42370 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762931AbXFEOZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:25:49 -0400
Date: Tue, 5 Jun 2007 10:25:48 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, mroos@linux.ee,
       linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605142548.GD31565@havoc.gtf.org>
References: <Pine.SOC.4.64.0706032314590.20033@math> <20070603.174010.41894721.davem@davemloft.net> <20070604074719.GB15390@infradead.org> <20070604171952.GA3437@dhcp83-182.boston.redhat.com> <20070605122218.410d611b@the-village.bc.nu> <20070605135608.GA31565@havoc.gtf.org> <20070605141714.GA2572@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605141714.GA2572@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 03:17:14PM +0100, Russell King wrote:
> On Tue, Jun 05, 2007 at 09:56:08AM -0400, Jeff Garzik wrote:
> > On Tue, Jun 05, 2007 at 12:22:18PM +0100, Alan Cox wrote:
> > > > NAK
> > > > 
> > > > We have generic devices and generic DMA mapping.  libata already uses
> > > > the generic stuff.  Now fix the platform...
> > > 
> > > Nice theory but your generic helpers rely on the map functions working
> > > even for generic hardware that doesn't need them, so at the very least
> > > there is some clean up required.
> > 
> > Sure there is some clean up needed -- on the arch side.
> > 
> > Even !PCI dma_xxx wrappers that do nothing more than return a dma
> > mapping error are a valid platform implementation.
> 
> If you don't have DMA capabilities, does libata still need ->pad and
> ->pad_dma set?
> 
> I had a problem where a pata_platform device which wasn't DMA capable
> failed to initialise because we quite rightfully made dma_alloc_coherent()
> fail (due to the DMA masks not being set.)
> 
> It seems odd that libata requires DMA memory for non-DMA capable devices...

Now -that- is a quite valid complaint.

libata needs a bit of work to fall back to PIO-only, if dma_xxx fails.

libata also needs some work to fall back to PIO polling, if IRQ is not
present, or registration fails.

	Jeff



