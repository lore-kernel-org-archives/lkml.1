Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYKEDe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYKEDe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 22:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbYKEDes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 22:34:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:41207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbYKEDer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 22:34:47 -0500
Message-ID: <4911144E.3030404@kernel.org>
Date: Wed, 05 Nov 2008 12:34:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Block: use round_jiffies_up()
References: <Pine.LNX.4.44L0.0811041114180.3614-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0811041114180.3614-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Nov 2008 03:34:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alan Stern wrote:
> @@ -78,13 +78,14 @@ void blk_delete_timer(struct request *re
>  	/*
>  	 * Nothing to detach
>  	 */
> -	if (!q->rq_timed_out_fn || !req->deadline)
> +	if (!req->deadline)
>  		return;
>  
>  	list_del_init(&req->timeout_list);
>  
>  	if (list_empty(&q->timeout_list))
>  		del_timer(&q->timeout);
> +	req->deadline = 0;
>  }

Actually, this can just be

blk_delete_timer()
{
	list_del_init(&req->timeout_list);
	if (list_empty(&q->timeout_list))
		del_timer(&q->timeout);
}

and none of req->deadline trick is necessary.

Thanks.

-- 
tejun
