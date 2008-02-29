Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbYB2QuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbYB2QuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbYB2Qtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:49:53 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:56364 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104AbYB2Qtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:49:53 -0500
Message-ID: <47C837B0.2040803@opengridcomputing.com>
Date: Fri, 29 Feb 2008 10:49:52 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Jon Mason <jon@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [PATCH] update max_inline_data when creating a qp
References: <1204158583-22858-1-git-send-email-jon@opengridcomputing.com> <1204158583-22858-2-git-send-email-jon@opengridcomputing.com>
In-Reply-To: <1204158583-22858-2-git-send-email-jon@opengridcomputing.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Steve Wise <swise@opengridcomputing.com>

Jon Mason wrote:
> mthca modifies the attributes passed in when creating the qp to have
> (amongst other things) the max_inline_data.  While cxgb3 does modify
> the attributes of some of the parameters, it does not modify the
> max_inline_data to be what the adapter supports.  cxgb should conform
> to the same behavior as mthca (as some user space programs are
> expecting this) and return the max_inline_data.
> 
> Signed-off-by: Jon Mason <jon@opengridcomputing.com>
> ---
>  drivers/infiniband/hw/cxgb3/iwch_provider.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> index 800ef6d..5f0c9d3 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> @@ -818,8 +818,11 @@ static struct ib_qp *iwch_create_qp(struct ib_pd *pd,
>  		kfree(qhp);
>  		return ERR_PTR(-ENOMEM);
>  	}
> +
>  	attrs->cap.max_recv_wr = rqsize - 1;
>  	attrs->cap.max_send_wr = sqsize;
> +	attrs->cap.max_inline_data = T3_MAX_INLINE;
> +
>  	qhp->rhp = rhp;
>  	qhp->attr.pd = php->pdid;
>  	qhp->attr.scq = ((struct iwch_cq *) attrs->send_cq)->cq.cqid;

