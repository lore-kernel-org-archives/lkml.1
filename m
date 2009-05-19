Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZESKFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZESKFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZESKEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:04:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:34665 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZESKEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:04:53 -0400
Message-ID: <4A128484.4000708@kernel.org>
Date: Tue, 19 May 2009 19:05:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       James Smart <James.Smart@Emulex.Com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <tomof@acm.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <Jens.Axboe@oracle.com>
Subject: Re: [PATCH] [SQUASHME] "FC Pass Thru support" fixed for block/for-2.6.31
 tree
References: <4A12797B.2060901@panasas.com>
In-Reply-To: <4A12797B.2060901@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 19 May 2009 10:04:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Just two minor things.

Boaz Harrosh wrote:
>  	/* we assume all request payload was transferred, residual == 0 */
> -	req->data_len = 0;
> +	req->resid_len = 0;
>  
>  	if (rsp) {
> -		rsp_len = blk_rq_bytes(rsp);
> -		BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);

Maybe convert it to WARN_ON() instead of removing?

>  		/* set reply (bidi) residual */
> -		rsp->data_len = (rsp_len - job->reply->reply_payload_rcv_len);
> +		rsp->resid_len = blk_rq_bytes(rsp) -
> +					job->reply->reply_payload_rcv_len;

With the fix-fallouts patchset it, this can be

	rsp->resid_len -= job->reply->reply_payload_rcv_len;

Other than above misc points,

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
