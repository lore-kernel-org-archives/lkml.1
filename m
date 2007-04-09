Return-Path: <linux-kernel-owner+w=401wt.eu-S1750848AbXDIJxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750848AbXDIJxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 05:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXDIJxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 05:53:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58974 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750848AbXDIJxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 05:53:51 -0400
Date: Mon, 9 Apr 2007 10:56:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] pata_icside driver
Message-ID: <20070409105638.6b131b72@the-village.bc.nu>
In-Reply-To: <461990CE.8080609@pobox.com>
References: <20070330110022.GA21653@flint.arm.linux.org.uk>
	<20070330110800.GB21653@flint.arm.linux.org.uk>
	<20070408101826.GA5431@flint.arm.linux.org.uk>
	<20070408195956.4e7d50c0@the-village.bc.nu>
	<461990CE.8080609@pobox.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Apr 2007 21:03:10 -0400
Jeff Garzik <jgarzik@pobox.com> wrote:
> > ata_irq_ack is part of the SFF layer so its fine that it assumes SFF but
> > its wrong that it is used unconditionally and it shouldn't be used this
> > way. It just needs a (!ap->ioaddr.bmdma_addr) test adding (assuming thats
> > valid for iomap)
> 
> No.  It does not need such a test, as it requires BMDMA, not just an 
> SFF-style Status register.  It is up to the driver to decide whether or 
> not ata_irq_ack() is appropriate for your hardware.

Then no SFF hardware can use ata_irq_ack. Not one card: Because in every
case it is permissible that BAR4 is not allocated and the device is
running non-DMA, or that the SFF hardware does not support DMA.

> pata_icside needs its own ata_irq_ack -- which may just be as simple as 
> reading the Status register to clear the interrupt condition.
> 
> If others need this as well, ata_sff_irq_ack() would be a good generic 
> function to create.

We should just rename ata_irq_ack(). It is in libata-sff, so it's either
wrong (missing a test), or in the wrong file completely.

Alan
