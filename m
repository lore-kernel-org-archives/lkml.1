Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYACXM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYACXM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYACXMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:12:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYACXMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:12:14 -0500
Date: Thu, 3 Jan 2008 18:11:27 -0500
From: Rik van Riel <riel@redhat.com>
To: David Dillow <dillowda@ornl.gov>
Cc: Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
Message-ID: <20080103181127.054dd917@cuia.boston.redhat.com>
In-Reply-To: <1199391609.7561.46.camel@lap75545.ornl.gov>
References: <adak5mqu5i8.fsf@cisco.com>
	<1199385590.7561.11.camel@lap75545.ornl.gov>
	<adafxxeu495.fsf@cisco.com>
	<1199391187.7561.38.camel@lap75545.ornl.gov>
	<1199391609.7561.46.camel@lap75545.ornl.gov>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jan 2008 15:20:09 -0500
David Dillow <dillowda@ornl.gov> wrote:

> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 950228f..6e7e3c8 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -423,8 +423,8 @@ static void srp_remove_work(struct work_struct *work)
>  	list_del(&target->list);
>  	spin_unlock(&target->srp_host->target_lock);
>  
> -	srp_remove_host(target->scsi_host);
>  	scsi_remove_host(target->scsi_host);
> +	srp_remove_host(target->scsi_host);
>  	ib_destroy_cm_id(target->cm_id);
>  	srp_free_target_ib(target);
>  	scsi_host_put(target->scsi_host);

These last two look suspicious.  Are you freeing target before
freeing target->scsi_host or does the code simply not do what
it looks like it's doing? :)

(no, I haven't looked at the IB code - I'm probably wrong)

-- 
All Rights Reversed
