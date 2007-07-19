Return-Path: <linux-kernel-owner+w=401wt.eu-S938286AbXGSPM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938286AbXGSPM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938922AbXGSPM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:12:27 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:39619 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S938895AbXGSPMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:12:25 -0400
Message-ID: <469F7F58.4080709@steeleye.com>
Date: Thu, 19 Jul 2007 11:12:24 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Denis Cheng <crquan@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Steven Whitehouse <steve@chygwyn.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] nbd: use list_for_each_entry_safe to make it more
 consolidated and readable
References: <11848376711601-git-send-email-crquan@gmail.com>
In-Reply-To: <11848376711601-git-send-email-crquan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Cheng wrote:
> Thus the traverse of the loop may delete nodes, use the safe version.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  drivers/block/nbd.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index c129510..86639c0 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -237,8 +237,7 @@ error_out:
>  
>  static struct request *nbd_find_request(struct nbd_device *lo, char *handle)
>  {
> -	struct request *req;
> -	struct list_head *tmp;
> +	struct request *req, *n;
>  	struct request *xreq;
>  	int err;
>  
> @@ -249,8 +248,7 @@ static struct request *nbd_find_request(struct nbd_device *lo, char *handle)
>  		goto out;
>  
>  	spin_lock(&lo->queue_lock);
> -	list_for_each(tmp, &lo->queue_head) {
> -		req = list_entry(tmp, struct request, queuelist);
> +	list_for_each_entry_safe(req, n, &lo->queue_head, queuelist) {
>  		if (req != xreq)
>  			continue;
>  		list_del_init(&req->queuelist);

Could you name "n" as "tmp" (as in the previous code) so that it's clear 
that's only a temporary variable. Other than that, this looks good.

Thanks,
Paul
