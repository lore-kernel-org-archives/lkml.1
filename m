Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXGIT52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXGIT52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759811AbXGIT5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:57:17 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:58873 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759822AbXGIT5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:57:17 -0400
Message-ID: <4692931B.3000309@opengridcomputing.com>
Date: Mon, 09 Jul 2007 14:57:15 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Jesper Juhl <jesper.juhl@gmail.com>, WANG Cong <xiyou.wangcong@gmail.com>,
       rolandd@cisco.com, mshefty@ichips.intel.com, halr@voltaire.com,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [-mm Patch] INFINIBAND: check the return value of kmalloc
References: <20070704163741.GA2510@localhost.localdomain>	<9a8748490707041700q18608e3ave4465f1181b97e2f@mail.gmail.com> <ada1wfm4jea.fsf@cisco.com>
In-Reply-To: <ada1wfm4jea.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.


Roland Dreier wrote:
> thanks, I added Jesper's suggestion to the original patch and queued
> this for 2.6.23:
> 
> (Steve, let me know if this looks OK or not to you)
> 
> commit 8d339921a2cb279457dce79f8a308978e0b41b27
> Author: WANG Cong <xiyou.wangcong@gmail.com>
> Date:   Thu Jul 5 14:40:32 2007 -0700
> 
>     RDMA/cxgb3: Check return of kmalloc() in iwch_register_device()
>     
>     Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>     [ Also remove cast from void * return of kmalloc() as suggested by
>       Jesper Juhl <jesper.juhl@gmail.com>. ]
>     Signed-off-by: Roland Dreier <rolandd@cisco.com>
> 
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> index e7c2c39..44b6ad2 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> @@ -1163,9 +1163,10 @@ int iwch_register_device(struct iwch_dev *dev)
>  	dev->ibdev.post_recv = iwch_post_receive;
>  
>  
> -	dev->ibdev.iwcm =
> -	    (struct iw_cm_verbs *) kmalloc(sizeof(struct iw_cm_verbs),
> -					   GFP_KERNEL);
> +	dev->ibdev.iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
> +	if (!dev->ibdev.icwm)
> +		return -ENOMEM;
> +
>  	dev->ibdev.iwcm->connect = iwch_connect;
>  	dev->ibdev.iwcm->accept = iwch_accept_cr;
>  	dev->ibdev.iwcm->reject = iwch_reject_cr;

