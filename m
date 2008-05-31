Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbYEaB4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbYEaB4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 21:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbYEaBza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 21:55:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36732 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbYEaBzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 21:55:14 -0400
Message-ID: <4840AFFD.1000606@pobox.com>
Date: Fri, 30 May 2008 21:55:09 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1 of 5] xen/blkfront: Make sure we don't use bounce buffers,
 we don't need them
References: <967afd96e8ece92cb863.1212192091@localhost>
In-Reply-To: <967afd96e8ece92cb863.1212192091@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> From: Ian Campbell <ian.campbell@xensource.com>
> 
> [ linux-2.6.18-xen changeset 667228bf8fc5 ]
> 
> Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  drivers/block/xen-blkfront.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -324,6 +324,9 @@
>  	/* Make sure buffer addresses are sector-aligned. */
>  	blk_queue_dma_alignment(rq, 511);
>  
> +	/* Make sure we don't use bounce buffers. */
> +	blk_queue_bounce_limit(rq, BLK_BOUNCE_ANY);
> +
>  	gd->queue = rq;

ACK


