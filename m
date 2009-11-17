Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbZKQRga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbZKQRga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZKQRga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:36:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46885 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751198AbZKQRg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:36:29 -0500
Date: Tue, 17 Nov 2009 17:38:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/5] pata_sis: Implement MWDMA for the UDMA 133 capable
 chips
Message-ID: <20091117173823.217b95a7@lxorguk.ukuu.org.uk>
In-Reply-To: <200911171827.29891.bzolnier@gmail.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
	<20091117145111.15430.67106.stgit@localhost.localdomain>
	<200911171827.29891.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int mwdma_clip_to_pio(struct ata_device *adev)
> > +{
> > +	const int mwdma_to_pio[3] = {
> > +		XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
> > +	};
> > +	return min(mwdma_to_pio[adev->dma_mode - XFER_MW_DMA_0],
> > +				adev->pio_mode - XFER_PIO_0);
> > +}
> 
> This wants to be in the generic libata code.

I'm not convinced because for the majority of drivers the libata timing
interface handles it. SiS needs it just because it does things by
precomputed tables. It's a one off interface.

Alan
