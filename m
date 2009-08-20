Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbZHTPKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbZHTPKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZHTPKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:10:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbZHTPKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:10:47 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       zach.brown@oracle.com
Subject: Re: [PATCH 5/6] aio: use lazy workqueues
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com>
	<1250763604-24355-6-git-send-email-jens.axboe@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 20 Aug 2009 11:09:34 -0400
In-Reply-To: <1250763604-24355-6-git-send-email-jens.axboe@oracle.com> (Jens
	Axboe's message of "Thu, 20 Aug 2009 12:20:03 +0200")
Message-ID: <x49k50yjzdd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  fs/aio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index d065b2c..4103b59 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -72,7 +72,7 @@ static int __init aio_setup(void)
>  	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
>  	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
>  
> -	aio_wq = create_workqueue("aio");
> +	aio_wq = create_lazy_workqueue("aio");
>  
>  	pr_debug("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));

So far as I can tell, the aio workqueue isn't used for much these days.
We could probably get away with switching to keventd.  Zach, isn't
someone working on a patch to get rid of all of the -EIOCBRETRY
infrastructure?  That patch would probably make things clearer in this
area.

Cheers,
Jeff
