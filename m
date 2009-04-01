Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZDAFE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZDAFE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 01:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZDAFEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 01:04:48 -0400
Received: from relay.atmel.no ([80.232.32.139]:59303 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZDAFEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 01:04:47 -0400
Date: Wed, 1 Apr 2009 07:04:40 +0200
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] dw_dmac: set CAP_PRIVATE capability for DW DMA
 controller
Message-ID: <20090401070440.326f6e7f@hcegtvedt>
In-Reply-To: <129600E5E5FB004392DDC3FB599660D790F8C3EB@irsmsx504.ger.corp.intel.com>
References: <1237894506-11622-1-git-send-email-hans-christian.egtvedt@atmel.com>
	<129600E5E5FB004392DDC3FB599660D790F8C3EB@irsmsx504.ger.corp.intel.com>
Organization: Atmel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 15:01:49 +0100
"Sosnowski, Maciej" <maciej.sosnowski@intel.com> wrote:

> Hans-Christian Egtvedt wrote:
> > This patch adds the private capability for the DW DMA controller.
> > This allows the DMA controller to do other DMA transfers than
> > memory-to-memory. For example when the DMA controller is used by
> > peripherals to transfer data between memory and peripheral.
> > 
> > Signed-off-by: Hans-Christian Egtvedt
> > <hans-christian.egtvedt@atmel.com> ---
> >  drivers/dma/dw_dmac.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index a97c07e..1c5e31d 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -994,6 +994,7 @@ static int __init dw_probe(struct
> > platform_device *pdev) channel_clear_bit(dw, MASK.DST_TRAN,
> > dw->all_chan_mask); channel_clear_bit(dw, MASK.ERROR,
> > dw->all_chan_mask);
> > 
> > +	dma_cap_set(DMA_PRIVATE, dw->dma.cap_mask);
> >  	dma_cap_set(DMA_MEMCPY, dw->dma.cap_mask);
> >  	dma_cap_set(DMA_SLAVE, dw->dma.cap_mask);
> >  	dw->dma.dev = &pdev->dev;
> 
> Hi Hans,
> 
> Adding Dan...
> 
> Please note that this way you permenently exclude the device from
> public use. If that's your intent that's fine.
>

No, my intention was to be able to use dma_request_channel in the ALSA
driver I was working on in parallel.

> Remember however that you can leave the device generally non-private
> and attempt as needed to allocate a channel for exclusive usage by
> dma_request_channel()
>

The weird part was that when testing this, the dma_request_channel()
would not return any channel before DMA_PRIVATE flag was set. I think I
did this some time ago, I can do a retest with the current 2.6.29 and
see how it behaves.

> - it would set DMA_PRIVATE flag if private channel candidate has been
> found.
> 

Which I think was the reason I added the private flag.

-- 
Best regards,
Hans-Christian Egtvedt
