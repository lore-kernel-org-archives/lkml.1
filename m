Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYJPVyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYJPVyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbYJPVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:53:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755079AbYJPVx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:53:57 -0400
Date: Thu, 16 Oct 2008 14:53:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Miller <mike.miller@hp.com>
Cc: JensAxboejens.axboe@oracle.com, alan.brunelle@hp.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] cciss: fix sysfs regression, obsoletes previous
 patch
Message-Id: <20081016145301.0d117cdf.akpm@linux-foundation.org>
In-Reply-To: <20081016212956.GA25704@roadking.ldev.net>
References: <20081016212956.GA25704@roadking.ldev.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 16:29:56 -0500
Mike Miller <mike.miller@hp.com> wrote:

> 
> Patch 1 of 2
> 
> This patch obsoletes the one I sent yesterday. It fixes a broken symlink in
> sysfs. The previous patch appeared to work but was wrong as reported by Alan
> Brunelle.
> Please consider this for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 1e1f915..0f367b1 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -1365,6 +1365,7 @@ static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
>  	disk->first_minor = drv_index << NWD_SHIFT;
>  	disk->fops = &cciss_fops;
>  	disk->private_data = &h->drv[drv_index];
> +	disk->driverfs_dev = &h->pdev->dev;
>  
>  	/* Set up queue information */
>  	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);

Without knowing what caused this regression nor when it occurred, I am
unable to determine whether this fix is needed in 2.6.27.x.  Or indeed
2.6.26.x, etc.

