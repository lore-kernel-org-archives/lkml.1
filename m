Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbZHXIBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbZHXIBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZHXIBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:01:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45732 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZHXIBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:01:13 -0400
Date: Mon, 24 Aug 2009 10:01:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mike Miller <mike.miller@hp.com>,
       linux kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] cciss: memory leak in cciss_init_one()
Message-ID: <20090824080115.GA12579@kernel.dk>
References: <4A7961DE.1090702@gmail.com> <4A91058F.3050708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A91058F.3050708@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23 2009, Eric Dumazet wrote:
> Andrew, I originally sent this 18 days ago and got no reply yet,
> maybe could you get the baby ?

I'll add it for 2.6.32.

> 
> Thanks
> 
> [PATCH] cciss: memory leak in cciss_init_one()
> 
> commit 22bece00dc1f28dd3374c55e464c9f02eb642876
> (cciss: fix regression firmware not displayed in procfs)
> added a small memory leak in cciss_init_one()
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index a52cc7f..0589dfb 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3889,7 +3889,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>  	int j = 0;
>  	int rc;
>  	int dac, return_code;
> -	InquiryData_struct *inq_buff = NULL;
> +	InquiryData_struct *inq_buff;
>  
>  	if (reset_devices) {
>  		/* Reset the controller with a PCI power-cycle */
> @@ -4029,6 +4029,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>  		printk(KERN_WARNING "cciss: unable to determine firmware"
>  			" version of controller\n");
>  	}
> +	kfree(inq_buff);
>  
>  	cciss_procinit(i);
>  
> @@ -4045,7 +4046,6 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>  	return 1;
>  
>  clean4:
> -	kfree(inq_buff);
>  	kfree(hba[i]->cmd_pool_bits);
>  	if (hba[i]->cmd_pool)
>  		pci_free_consistent(hba[i]->pdev,
> 

-- 
Jens Axboe

