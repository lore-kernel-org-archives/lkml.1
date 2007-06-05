Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbXFEPxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbXFEPxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbXFEPwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:52:30 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2930 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbXFEPw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:52:28 -0400
Date: Tue, 5 Jun 2007 16:52:19 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, mroos@linux.ee,
       linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605155219.GB29508@flint.arm.linux.org.uk>
References: <Pine.SOC.4.64.0706032314590.20033@math> <20070603.174010.41894721.davem@davemloft.net> <20070604074719.GB15390@infradead.org> <20070604171952.GA3437@dhcp83-182.boston.redhat.com> <20070605122218.410d611b@the-village.bc.nu> <20070605135608.GA31565@havoc.gtf.org> <20070605141714.GA2572@flint.arm.linux.org.uk> <20070605165056.1d9d3815@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605165056.1d9d3815@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 04:50:56PM +0100, Alan Cox wrote:
> > If you don't have DMA capabilities, does libata still need ->pad and
> > ->pad_dma set?
> 
> It shouldn't - nor the prd. You don't need to use the default
> ata_port_start in this case. I've just added ata_sff_port_start to my
> tree which figures out which to allocate for SFF devices.

I had already sorted out the PRD, but I couldn't convince myself that
the pad stuff wasn't used, so for pata_icside I had:

static int pata_icside_port_start(struct ata_port *ap)
{
        /* No PRD to alloc */
        return ata_pad_alloc(ap, ap->dev);
}

Therefore, I can just arrange for this to do nothing and just return
zero.  A similar fix for pata_platform should probably also be in order
as well.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
