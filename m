Return-Path: <linux-kernel-owner+w=401wt.eu-S2992970AbXCCDOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992970AbXCCDOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 22:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992962AbXCCDOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 22:14:43 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56301 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992961AbXCCDOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 22:14:42 -0500
Message-ID: <45E8E81F.8070805@garzik.org>
Date: Fri, 02 Mar 2007 22:14:39 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Chris Leech <christopher.leech@intel.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/9] ioatdma: Push pending transactions to hardware more
 frequently
References: <20070303022238.31033.84558.stgit@gitlost.site> <20070303022417.31033.72244.stgit@gitlost.site>
In-Reply-To: <20070303022417.31033.72244.stgit@gitlost.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Leech wrote:
> Every 20 descriptors turns out to be to few append commands with
> newer/faster CPUs.  Pushing every 4 still cuts down on MMIO writes to an
> acceptable level without letting the DMA engine run out of work.
> 
> Signed-off-by: Chris Leech <christopher.leech@intel.com>
> ---
> 
>  drivers/dma/ioatdma.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
> index 8e87261..0f77a9d 100644
> --- a/drivers/dma/ioatdma.c
> +++ b/drivers/dma/ioatdma.c
> @@ -310,7 +310,7 @@ static dma_cookie_t do_ioat_dma_memcpy(struct ioat_dma_chan *ioat_chan,
>  	list_splice_init(&new_chain, ioat_chan->used_desc.prev);
>  
>  	ioat_chan->pending += desc_count;
> -	if (ioat_chan->pending >= 20) {
> +	if (ioat_chan->pending >= 4) {

This sounds like something that will always be wrong -- or in other 
words, always be right for only the latest CPUs.  Can this be made 
dynamic, based on some timing factor?

	Jeff



