Return-Path: <linux-kernel-owner+w=401wt.eu-S2992945AbXCCE1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992945AbXCCE1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 23:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992948AbXCCE1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 23:27:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47084
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992945AbXCCE1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 23:27:08 -0500
Date: Fri, 02 Mar 2007 20:27:06 -0800 (PST)
Message-Id: <20070302.202706.95898424.davem@davemloft.net>
To: jeff@garzik.org
Cc: christopher.leech@intel.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/9] ioatdma: Push pending transactions to hardware
 more frequently
From: David Miller <davem@davemloft.net>
In-Reply-To: <45E8E81F.8070805@garzik.org>
References: <20070303022238.31033.84558.stgit@gitlost.site>
	<20070303022417.31033.72244.stgit@gitlost.site>
	<45E8E81F.8070805@garzik.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 02 Mar 2007 22:14:39 -0500

> Chris Leech wrote:
> > Every 20 descriptors turns out to be to few append commands with
> > newer/faster CPUs.  Pushing every 4 still cuts down on MMIO writes to an
> > acceptable level without letting the DMA engine run out of work.
> > 
> > Signed-off-by: Chris Leech <christopher.leech@intel.com>
> > ---
> > 
> >  drivers/dma/ioatdma.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
> > index 8e87261..0f77a9d 100644
> > --- a/drivers/dma/ioatdma.c
> > +++ b/drivers/dma/ioatdma.c
> > @@ -310,7 +310,7 @@ static dma_cookie_t do_ioat_dma_memcpy(struct ioat_dma_chan *ioat_chan,
> >  	list_splice_init(&new_chain, ioat_chan->used_desc.prev);
> >  
> >  	ioat_chan->pending += desc_count;
> > -	if (ioat_chan->pending >= 20) {
> > +	if (ioat_chan->pending >= 4) {
> 
> This sounds like something that will always be wrong -- or in other 
> words, always be right for only the latest CPUs.  Can this be made 
> dynamic, based on some timing factor?

In fact I think this has been tweaked twice in the vanilla tree
already.
