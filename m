Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbZBPJas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbZBPJas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 04:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZBPJak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 04:30:40 -0500
Received: from brick.kernel.dk ([93.163.65.50]:8314 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZBPJaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 04:30:39 -0500
Date: Mon, 16 Feb 2009 10:28:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Subhash Peddamallu <subhash.peddamallu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/bio: bio_alloc_bioset: pass right object ptr to mempool_free
Message-ID: <20090216092818.GM30821@kernel.dk>
References: <3d7ff8e60902152015i1245f7byab20b9eef9425a84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d7ff8e60902152015i1245f7byab20b9eef9425a84@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15 2009, Subhash Peddamallu wrote:
> When freeing from bio pool use right ptr to account for bs->front_pad,
> instead of bio ptr,
> 
> Signed-off-by: Subhash Peddamallu <subhash.peddamallu@gmail.com>
> ---
>  fs/bio.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 062299a..72ab251 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -302,9 +302,10 @@ void bio_init(struct bio *bio)
>  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  {
>  	struct bio *bio = NULL;
> +	void *p;
> 
>  	if (bs) {
> -		void *p = mempool_alloc(bs->bio_pool, gfp_mask);
> +		p = mempool_alloc(bs->bio_pool, gfp_mask);
> 
>  		if (p)
>  			bio = p + bs->front_pad;
> @@ -329,7 +330,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int
> nr_iovecs, struct bio_set *bs)
>  			}
>  			if (unlikely(!bvl)) {
>  				if (bs)
> -					mempool_free(bio, bs->bio_pool);
> +					mempool_free(p, bs->bio_pool);
>  				else
>  					kfree(bio);
>  				bio = NULL;
> -- 
> 1.5.6.3

Thanks, applied.

-- 
Jens Axboe

