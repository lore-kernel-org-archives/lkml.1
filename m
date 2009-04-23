Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbZDWT7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbZDWT7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZDWT64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:58:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753432AbZDWT6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:58:55 -0400
Date: Thu, 23 Apr 2009 12:50:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: jens.axboe@oracle.com, David.Woodhouse@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix discard requests accounting in the diskstats
Message-Id: <20090423125040.57db9968.akpm@linux-foundation.org>
In-Reply-To: <200904171144.49448.knikanth@suse.de>
References: <200904171144.49448.knikanth@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 11:44:49 +0530
Nikanth Karthikesan <knikanth@suse.de> wrote:

> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -667,7 +667,9 @@ static inline void blk_clear_queue_full(struct request_queue *q, int sync)
>  	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER)
>  #define rq_mergeable(rq)	\
>  	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
> -	 (blk_discard_rq(rq) || blk_fs_request((rq))))
> +	 (blk_discard_rq(rq) || blk_fs_request(rq)))
> +#define rq_accountable(rq)	\
> +	(blk_discard_rq(rq) || blk_fs_request(rq))

Both these macros reference their argument multiple times and are
potentially buggy and/or inefficient if passed an expression with
side-effects.

There was (afaict) no reason for them to have been implemented as
macros.

