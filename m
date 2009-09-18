Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZIRTMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZIRTMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZIRTL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:11:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZIRTL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:11:56 -0400
Date: Fri, 18 Sep 2009 15:11:54 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>, David Strand <dpstrand@gmail.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dm: Use blk_queue_copy_limits()
Message-ID: <20090918191154.GB30063@redhat.com>
References: <4AB3B43D.9000802@ce.jp.nec.com> <4AB3B4B8.10300@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB3B4B8.10300@ce.jp.nec.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18 2009 at 12:26pm -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Use new blk_queue_copy_limits() so that invalid limits
> (max_sectors == 0) are fixed up appropriately when copied to the queue.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Reported-by: David Strand <dpstrand@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Alasdair G Kergon <agk@redhat.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/md/dm-table.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.31.work/drivers/md/dm-table.c
> ===================================================================
> --- linux-2.6.31.work.orig/drivers/md/dm-table.c
> +++ linux-2.6.31.work/drivers/md/dm-table.c
> @@ -1090,7 +1090,7 @@ void dm_table_set_restrictions(struct dm
>  	/*
>  	 * Copy table's limits to the DM device's request_queue
>  	 */
> -	q->limits = *limits;
> +	blk_queue_copy_limits(q, limits);
> 
>  	if (limits->no_cluster)
>  		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);


How about just having 2 patches in the series and folding the above DM
change into the first patch?

Doesn't _really_ matter I guess...

Anyway, these minor points aside: I like what you've done with this
series.

Acked-by: Mike Snitzer <snitzer@redhat.com>
