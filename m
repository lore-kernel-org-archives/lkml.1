Return-Path: <linux-kernel-owner+w=401wt.eu-S1030329AbXAYQXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030329AbXAYQXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030304AbXAYQXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:23:15 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2519 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030299AbXAYQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:23:13 -0500
Date: Thu, 25 Jan 2007 16:22:55 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable controllers
Message-ID: <20070125162255.GF31145@flint.arm.linux.org.uk>
Mail-Followup-To: Jeff Garzik <jgarzik@pobox.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Alan <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070125150905.652f9ce2@localhost.localdomain> <1169741658.3593.98.camel@shinybook.infradead.org> <45B8D810.3030501@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B8D810.3030501@pobox.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 11:17:20AM -0500, Jeff Garzik wrote:
> David Woodhouse wrote:
> >On Thu, 2007-01-25 at 15:09 +0000, Alan wrote:
> >>diff -u --new-file --recursive --exclude-from /usr/src/exclude 
> >>linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-sff.c 
> >>linux-2.6.20-rc4-mm1/drivers/ata/libata-sff.c
> >>--- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-sff.c       
> >>2007-01-22 16:26:50.000000000 +0000
> >>+++ linux-2.6.20-rc4-mm1/drivers/ata/libata-sff.c       2007-01-24 
> >>17:31:40.000000000 +0000
> >>@@ -827,7 +827,8 @@
> >>  */
> >> void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc)
> >> {
> >>-       ata_bmdma_stop(qc);
> >>+       if (qc->ap->ioaddr.bmdma_addr)
> >>+               ata_bmdma_stop(qc);
> >> }
> >
> >But what if the bmdma_addr _is_ zero? Please, let's not allow the "zero
> >is not a valid number" braindamage to spread any further than the IRQ
> >setup it's already broken.
> 
> Read the code...  This test is already widely in use in libata.

Ditto.  The only interpretation that can be placed upon DMA addresses
is done by dma_mapping_error(), which _is_ a per-architecture defined
test because these things aren't defined in the API.

The zero DMA address is absolutely and totally valid.  It might not
correspond with physical address zero on platforms.

Also, DMA address zero is not the same as NULL.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
