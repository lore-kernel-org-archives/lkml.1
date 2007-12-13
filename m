Return-Path: <linux-kernel-owner+w=401wt.eu-S1765995AbXLMULf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765995AbXLMULf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765990AbXLMUKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:10:38 -0500
Received: from baron.borf.com ([65.14.39.133]:27817 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765945AbXLMUKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:10:36 -0500
Date: Thu, 13 Dec 2007 15:08:14 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [Patch 3/8] Enhanced partition statistics: aoe fix
Message-ID: <20071213200814.GK30302@coraid.com>
References: <47615B29.1030108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47615B29.1030108@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 05:17:45PM +0100, Jerome Marchand wrote:
> Updates the enhanced partition statistics in ATA over Ethernet driver (not tested).

Acked-by: Ed L. Cashin <ecashin@coraid.com>

> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  aoecmd.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/drivers/block/aoe/aoecmd.c linux-2.6/drivers/block/aoe/aoecmd.c
> --- linux-2.6.orig/drivers/block/aoe/aoecmd.c	2007-12-04 17:37:13.000000000 +0100
> +++ linux-2.6/drivers/block/aoe/aoecmd.c	2007-12-05 13:45:10.000000000 +0100
> @@ -648,10 +648,10 @@ aoecmd_ata_rsp(struct sk_buff *skb)
>  			struct gendisk *disk = d->gd;
>  			const int rw = bio_data_dir(buf->bio);
>  
> -			disk_stat_inc(disk, ios[rw]);
> -			disk_stat_add(disk, ticks[rw], duration);
> -			disk_stat_add(disk, sectors[rw], n_sect);
> -			disk_stat_add(disk, io_ticks, duration);
> +			all_stat_inc(disk, ios[rw], buf->sector);
> +			all_stat_add(disk, ticks[rw], duration, buf->sector);
> +			all_stat_add(disk, sectors[rw], n_sect, buf->sector);
> +			all_stat_add(disk, io_ticks, duration, buf->sector);
>  			n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
>  			bio_endio(buf->bio, n);
>  			mempool_free(buf, d->bufpool);

-- 
  Ed L Cashin <ecashin@coraid.com>
