Return-Path: <linux-kernel-owner+w=401wt.eu-S932834AbYCGVHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834AbYCGVHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbYCGVG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:06:56 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44898 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933164AbYCGVGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:06:54 -0500
Message-ID: <47D1AE64.2000405@pobox.com>
Date: Fri, 07 Mar 2008 16:06:44 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/7] Convert open coded reference in libata to q->bounce_gfp
 to blk_kmalloc
References: <200803071013.837692778@firstfloor.org> <20080307091322.EF4311B419C@basil.firstfloor.org>
In-Reply-To: <20080307091322.EF4311B419C@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Only difference in behaviour is that GFP_NOIO is not passed here now,
> but I think that is ok in this case because this is not in a write out path.
> 
> Cc: jgarzik@pobox.com
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  drivers/ata/libata-scsi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/ata/libata-scsi.c
> ===================================================================
> --- linux.orig/drivers/ata/libata-scsi.c
> +++ linux/drivers/ata/libata-scsi.c
> @@ -868,7 +868,7 @@ static int ata_scsi_dev_config(struct sc
>  		blk_queue_dma_pad(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
>  
>  		/* configure draining */
> -		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
> +		buf = blk_kmalloc(q, ATAPI_MAX_DRAIN, GFP_KERNEL);

I think that's a fair assessment... ACK


