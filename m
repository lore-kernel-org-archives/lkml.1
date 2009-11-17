Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZKQSGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZKQSGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZKQSGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:06:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59266 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752678AbZKQSGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:06:23 -0500
Date: Tue, 17 Nov 2009 18:08:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 3/5] cmd64x: implement serialization as per notes
Message-ID: <20091117180818.0ed9ace4@lxorguk.ukuu.org.uk>
In-Reply-To: <200911171835.05232.bzolnier@gmail.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
	<20091117145122.15430.70080.stgit@localhost.localdomain>
	<200911171835.05232.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 18:35:05 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Tuesday 17 November 2009 15:51:32 Alan Cox wrote:
> 
> > +struct cmd_priv
> > +{
> > +	int dma_live;		/* Channel using DMA */
> > +	int irq_t[2];		/* Register to check for IRQ */
> > +	int irq_m[2];		/* Bit to check */
> > +};
> 
> irq_t and irq_m content will be identical for all host instances

Once I've had a look at the later chip variants I'll indeed do that
providing the 648 is ok in all revs.

> so you may as well add one instance for it, use ->private_data to
> store dma_live information and remove cmd_priv allocation
> 
> > +	/* If the other port is not live then issue the command */
> > +	if (alt == NULL || !alt->qc_active) {
> > +		if (dma)
> > +			priv->dma_live = qc->ap->port_no;
> > +		return 0;
> > +	}
> > +	/* If there is a live DMA command then wait */
> > +	if (priv->dma_live != -1)
> > +		return 	ATA_DEFER_PORT;
> > +	if (dma) {
> > +		/* Cannot overlap our DMA command */
> > +		if (alt->qc_active)
> > +			return ATA_DEFER_PORT;
> 
> no need to check alt->qc_active again here

Good point

Thanks for the review.
