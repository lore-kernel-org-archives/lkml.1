Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZCPJFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZCPJFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZCPJF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:05:27 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46428 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbZCPJF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:05:26 -0400
Date: Mon, 16 Mar 2009 10:05:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Kyle McMartin <kyle@infradead.org>
Cc: mike.miller@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] cpqarray: enable bus mastering
Message-ID: <20090316090524.GM27476@kernel.dk>
References: <20090315053842.GI3167@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315053842.GI3167@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15 2009, Kyle McMartin wrote:
> From: Dave Jones <davej@redhat.com>
> 
> We've been carrying this patch for the last 3 years in Fedora,
> long past time we got it upstream...
> 
> Call pci_set_master to enable bus-mastering if the BIOS hasn't
> done it already.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> --- a/drivers/block/cpqarray.c	2006-10-06 14:23:34.000000000 -0400
> +++ b/drivers/block/cpqarray.c	2006-10-06 14:25:16.000000000 -0400
> @@ -614,6 +614,7 @@ static int cpqarray_pci_init(ctlr_info_t
>  	int i;
>  
>  	c->pci_dev = pdev;
> +	pci_set_master(pdev);
>  	if (pci_enable_device(pdev)) {
>  		printk(KERN_ERR "cpqarray: Unable to Enable PCI device\n");
>  		return -1;

Thanks Kyle, looks pretty innocent. Queued up for 2.6.30.

-- 
Jens Axboe

