Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZHCVTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZHCVTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZHCVTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:19:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48455 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZHCVTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:19:49 -0400
Message-ID: <4A775474.8000705@linux.vnet.ibm.com>
Date: Mon, 03 Aug 2009 16:19:48 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Sage Weil <sage@newdream.net>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ibmvscsi: avoid unnecessary use of kzalloc_pool
References: <1249332888-13440-1-git-send-email-sage@newdream.net> <1249332888-13440-2-git-send-email-sage@newdream.net>
In-Reply-To: <1249332888-13440-2-git-send-email-sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Sage Weil wrote:
> The allocated struct is manually zeroed after allocation, so avoid using
> the (broken) kzalloc mempool (which does not re-zero previously used items
> when they are returned to the pool).
> 
> CC: linux-scsi@vger.kernel.org
> CC: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 166d964..bb2c696 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -4217,7 +4217,7 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
>  	if (!vhost->trace)
>  		goto free_disc_buffer;
> 
> -	vhost->tgt_pool = mempool_create_kzalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
> +	vhost->tgt_pool = mempool_create_kmalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
>  						      sizeof(struct ibmvfc_target));
> 
>  	if (!vhost->tgt_pool) {


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


