Return-Path: <linux-kernel-owner+w=401wt.eu-S1764411AbXFEN4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764411AbXFEN4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760591AbXFEN4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:56:14 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42120 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760512AbXFEN4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:56:14 -0400
Date: Tue, 5 Jun 2007 09:56:08 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, David Miller <davem@davemloft.net>,
       mroos@linux.ee, linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605135608.GA31565@havoc.gtf.org>
References: <Pine.SOC.4.64.0706032314590.20033@math> <20070603.174010.41894721.davem@davemloft.net> <20070604074719.GB15390@infradead.org> <20070604171952.GA3437@dhcp83-182.boston.redhat.com> <20070605122218.410d611b@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605122218.410d611b@the-village.bc.nu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 12:22:18PM +0100, Alan Cox wrote:
> > NAK
> > 
> > We have generic devices and generic DMA mapping.  libata already uses
> > the generic stuff.  Now fix the platform...
> 
> Nice theory but your generic helpers rely on the map functions working
> even for generic hardware that doesn't need them, so at the very least
> there is some clean up required.

Sure there is some clean up needed -- on the arch side.

Even !PCI dma_xxx wrappers that do nothing more than return a dma
mapping error are a valid platform implementation.

Even !HAS_DMA (s/390?) arches should be using the aforementioned
return-error wrappers, mimicing the implementation of PCI functions
in linux/pci.h for the !PCI case.

libata core for DMA mapping is already generic enough such that, #ifdefs
are not needed in the code.


OTOH.....  further work in libata _is_ need for I/O accessors, to
isolate those from the core code.

	Jeff



