Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbYKTHg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbYKTHg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 02:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYKTHgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 02:36:51 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:57349 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbYKTHgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 02:36:51 -0500
Date: Thu, 20 Nov 2008 08:35:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: crquan@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [GENDISK] fix disk_part_tbl always alloced in node 0: set node_id before refered in alloc_disk
Message-ID: <20081120073501.GZ26308@kernel.dk>
References: <1227110965-12606-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227110965-12606-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20 2008, crquan@gmail.com wrote:
> From: Cheng Renquan <crquan@gmail.com>
> 
> disk->node_id will be refered in allocating in disk_expand_part_tbl, so we
> should set it before disk->node_id is refered.
> 
> Signed-off-by: Cheng Renquan <crquan@gmail.com>
> ---
>  block/genhd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 27549e4..2f7feda 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1102,6 +1102,7 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
>  			kfree(disk);
>  			return NULL;
>  		}
> +		disk->node_id = node_id;
>  		if (disk_expand_part_tbl(disk, 0)) {
>  			free_part_stats(&disk->part0);
>  			kfree(disk);
> @@ -1116,7 +1117,6 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
>  		device_initialize(disk_to_dev(disk));
>  		INIT_WORK(&disk->async_notify,
>  			media_change_notify_thread);
> -		disk->node_id = node_id;
>  	}
>  	return disk;
>  }

Good spotting, applied!

-- 
Jens Axboe

