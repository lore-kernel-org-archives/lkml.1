Return-Path: <linux-kernel-owner+w=401wt.eu-S1030460AbXAYRQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030460AbXAYRQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030462AbXAYRQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:16:43 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52641 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030460AbXAYRQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:16:42 -0500
Date: Thu, 25 Jan 2007 17:27:39 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: jgarzik@pobox.com, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
Message-ID: <20070125172739.0c990a9a@localhost.localdomain>
In-Reply-To: <1169741658.3593.98.camel@shinybook.infradead.org>
References: <20070125150905.652f9ce2@localhost.localdomain>
	<1169741658.3593.98.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >  void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc)
> >  {
> > -       ata_bmdma_stop(qc);
> > +       if (qc->ap->ioaddr.bmdma_addr)
> > +               ata_bmdma_stop(qc);
> >  }
> 
> But what if the bmdma_addr _is_ zero? Please, let's not allow the "zero
> is not a valid number" braindamage to spread any further than the IRQ
> setup it's already broken.

The fix matches the rest of libata on this and fixes a bug that wants
fixing urgently for 2.6.20.

If you want to put your bmdma address at zero then libata-sff won't help
you at the moment, and assumes zero is a safe "not in use" value because
the PCI layer also takes a similar view in places.

libata-sff and thus ata_bmdma_post_internal_cmd() aren't used by non PCI
devices so the bmdma test is ok providing it stays within libata-sff. I
don't think its a problem, although clearly its an assumption that the
core code rather than the SFF code cannot make.

drivers/ide uses roughly the same assumptions without problem.

Alan
