Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbZENOFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbZENOFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbZENOFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:05:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:60063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZENOFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:05:21 -0400
Message-ID: <4A0C2515.9060602@kernel.org>
Date: Thu, 14 May 2009 23:05:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] block: completion related functions cleanup
References: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <4A0C2297.5040001@panasas.com>
In-Reply-To: <4A0C2297.5040001@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 14 May 2009 14:05:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> ---
>  drivers/scsi/scsi_lib.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e410d66..f8600d6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -789,7 +789,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	 */
>  	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
>  		return;
> -	this_count = blk_rq_bytes(req);
>  
>  	error = -EIO;
>  

Nice spotting.  Looks like the variable can be killed completely?

Thanks.

-- 
tejun
