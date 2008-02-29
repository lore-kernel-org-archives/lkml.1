Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbYB2Qtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbYB2Qtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYB2Qta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:49:30 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:56358 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbYB2Qt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:49:29 -0500
Message-ID: <47C83798.3090702@opengridcomputing.com>
Date: Fri, 29 Feb 2008 10:49:28 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Jon Mason <jon@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [PATCH] iwch_create_cq off by one error
References: <1204158583-22858-1-git-send-email-jon@opengridcomputing.com>
In-Reply-To: <1204158583-22858-1-git-send-email-jon@opengridcomputing.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Steve Wise <swise@opengridcomputing.com>


Jon Mason wrote:
> The cxbg3 driver is unnecessarily decreasing the number of cq entries
> by one when creating a cq.  This will cause an error of not having as
> many cqs as requested by the user, if the user requests a power of 2
> cq length.
> 
> Thanks,
> Jon
> 
> Signed-off-by: Jon Mason <jon@opengridcomputing.com>
> ---
>  drivers/infiniband/hw/cxgb3/iwch_provider.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> index f0c7775..800ef6d 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> @@ -188,7 +188,7 @@ static struct ib_cq *iwch_create_cq(struct ib_device *ibdev, int entries, int ve
>  		return ERR_PTR(-ENOMEM);
>  	}
>  	chp->rhp = rhp;
> -	chp->ibcq.cqe = (1 << chp->cq.size_log2) - 1;
> +	chp->ibcq.cqe = 1 << chp->cq.size_log2;
>  	spin_lock_init(&chp->lock);
>  	atomic_set(&chp->refcnt, 1);
>  	init_waitqueue_head(&chp->wait);

