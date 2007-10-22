Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbXJVN5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbXJVN5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbXJVN4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:56:54 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58889 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbXJVN4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:56:53 -0400
Subject: Re: [bug] block subsystem related crash on Legacy iSeries 
	viodasd.c
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
In-Reply-To: <20071021124426.GS10674@kernel.dk>
References: <1192829614.11003.30.camel@farscape.rchland.ibm.com>
	 <20071021124426.GS10674@kernel.dk>
Content-Type: text/plain
Organization: IBM
Date: Mon, 22 Oct 2007 08:56:45 -0500
Message-Id: <1193061405.11003.33.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-10-21 at 14:44 +0200, Jens Axboe wrote:
> On Fri, Oct 19 2007, Will Schmidt wrote:
> > Hi Jens, Stephen, and Everyone else.
...
> You need this, will remember to fix that up for the new branch as well.
> 
> diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
> index e824b67..2ce3622 100644
> --- a/drivers/block/viodasd.c
> +++ b/drivers/block/viodasd.c
> @@ -270,6 +270,7 @@ static int send_request(struct request *req)
>          d = req->rq_disk->private_data;
> 
>  	/* Now build the scatter-gather list */
> +	memset(sg, 0, sizeof(sg));
>  	nsg = blk_rq_map_sg(req->q, req, sg);
>  	nsg = dma_map_sg(d->dev, sg, nsg, direction);
> 

That appears to do the trick.     Thanks!  

Tested-By: Will Schmidt <will_schmidt@vnet.ibm.com>



