Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbXEJKke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbXEJKke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbXEJKk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:40:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992AbXEJKk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:40:26 -0400
Date: Thu, 10 May 2007 03:39:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/13] Add sg helpers for iterating over a scatterlist
 table
Message-Id: <20070510033956.9eebe437.akpm@linux-foundation.org>
In-Reply-To: <11787925152357-git-send-email-jens.axboe@oracle.com>
References: <11787925152319-git-send-email-jens.axboe@oracle.com>
	<11787925152357-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 12:21:44 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> First step to being able to change the scatterlist setup without
> having to modify drivers (a lot :-)
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  include/linux/scatterlist.h |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 4efbd9c..c5bffde 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -20,4 +20,13 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
>  	sg_set_buf(sg, buf, buflen);
>  }
>  
> +#define sg_next(sg)		((sg) + 1)
> +#define sg_last(sg, nents)	(&(sg[nents - 1]))

Looks a bit underparenthesised.

> +/*
> + * Loop over each sg element, following the pointer to a new list if necessary
> + */
> +#define for_each_sg(sglist, sg, nr, __i)	\
> +	for (__i = 0, sg = (sglist); __i < nr; __i++, sg = sg_next(sg))
> +

So does this.

I don't see how it "follows the pointer to a new list".  All it's doing is
iterating across an array?

