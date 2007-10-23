Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbXJWOcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbXJWOcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXJWOcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:32:46 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:43953 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbXJWOcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:32:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18206.1517.703650.1006@stoffel.org>
Date: Tue, 23 Oct 2007 10:32:13 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 02/10] [SG] Update block layer to use sg helpers
In-Reply-To: <1193076664-13652-3-git-send-email-jens.axboe@oracle.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
	<1193076664-13652-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Jens> ---
Jens>  block/ll_rw_blk.c |    8 ++++++--
Jens>  1 files changed, 6 insertions(+), 2 deletions(-)

Jens> diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
Jens> index 8025d64..61c2e39 100644
Jens> --- a/block/ll_rw_blk.c
Jens> +++ b/block/ll_rw_blk.c
Jens> @@ -1354,8 +1354,9 @@ new_segment:
Jens>  			else
Jens>  				sg = sg_next(sg);
 
Jens> -			memset(sg, 0, sizeof(*sg));
Jens> -			sg->page = bvec->bv_page;
Jens> +			sg_dma_len(sg) = 0;
Jens> +			sg_dma_address(sg) = 0;

Why don't you call these something like sg_set_dma_len() and
sg_set_dma_address() instead, to make it clear these set the values
and don't read them?

Jens> +			sg_set_page(sg, bvec->bv_page);

Esp since you have the sg_set_page() right below it.


sg-> length = nbytes;
sg-> offset = bvec->bv_offset;
Jens>  			nsegs++;
Jens> @@ -1363,6 +1364,9 @@ new_segment:
Jens>  		bvprv = bvec;
Jens>  	} /* segments in rq */
 
Jens> +	if (sg)
Jens> +		__sg_mark_end(sg);
Jens> +
Jens>  	return nsegs;
Jens>  }
 
Jens> -- 
Jens> 1.5.3.GIT

Jens> -
Jens> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Jens> the body of a message to majordomo@vger.kernel.org
Jens> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Jens> Please read the FAQ at  http://www.tux.org/lkml/


Jens> !DSPAM:471ce899205391598813817!
