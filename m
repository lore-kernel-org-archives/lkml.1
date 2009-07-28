Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZG1HKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZG1HKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbZG1HKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:10:44 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47912 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZG1HKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:10:43 -0400
Date: Tue, 28 Jul 2009 09:10:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix improper kobject release in
	blk_integrity_unregister
Message-ID: <20090728071043.GP4148@kernel.dk>
References: <1248425548-30600-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248425548-30600-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24 2009, Xiaotian Feng wrote:
> blk_integrity_unregister should use kobject_put to release the kobject,
> otherwise after bi is freed, memory of bi->kobj->name is leaked.

Applied, thanks.

> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> ---
>  block/blk-integrity.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-integrity.c b/block/blk-integrity.c
> index 73e28d3..15c6308 100644
> --- a/block/blk-integrity.c
> +++ b/block/blk-integrity.c
> @@ -379,6 +379,7 @@ void blk_integrity_unregister(struct gendisk *disk)
>  
>  	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
>  	kobject_del(&bi->kobj);
> +	kobject_put(&bi->kobj);
>  	kmem_cache_free(integrity_cachep, bi);
>  	disk->integrity = NULL;
>  }
> -- 
> 1.6.2.5
> 

-- 
Jens Axboe

