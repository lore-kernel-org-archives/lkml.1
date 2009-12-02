Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZLBOIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZLBOIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZLBOIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:08:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZLBOIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:08:36 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 01/21] blkio: Set must_dispatch only if we decided to not dispatch the request
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
	<1259549968-10369-2-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 02 Dec 2009 09:06:28 -0500
In-Reply-To: <1259549968-10369-2-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Sun, 29 Nov 2009 21:59:08 -0500")
Message-ID: <x49iqcplbbv.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> o must_dispatch flag should be set only if we decided not to run the quue
>   dispatch the request.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/cfq-iosched.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index a5de31f..9adfa48 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2494,9 +2494,9 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  			if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE ||
>  			    cfqd->busy_queues > 1) {
>  				del_timer(&cfqd->idle_slice_timer);
> -			__blk_run_queue(cfqd->queue);
> -			}
> -			cfq_mark_cfqq_must_dispatch(cfqq);
> +				__blk_run_queue(cfqd->queue);
> +			} else
> +				cfq_mark_cfqq_must_dispatch(cfqq);
>  		}
>  	} else if (cfq_should_preempt(cfqd, cfqq, rq)) {
>  		/*

This makes sense, but could be submitted as a bugfix on its own.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
