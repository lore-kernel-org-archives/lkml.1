Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327Ab0AETBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0AETBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239Ab0AETAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:00:55 -0500
Received: from mga12.intel.com ([143.182.124.36]:47821 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755156Ab0AETAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:00:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229487511"
Date: Tue, 5 Jan 2010 20:02:31 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] sm501.c: use resource_size()
Message-ID: <20100105190231.GG4274@sortiz.org>
References: <BD79186B4FD85F4B8E60E381CAEE190901FB1105@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB1105@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 06:55:41PM -0500, H Hartley Sweeten wrote:
> The requested memory region is smaller than the actual ioremap().
> Use resource_size() to get the correct size.
Patch applied, thanks.

 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> 
> ---
> 
> diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
> index 0cc5eef..dc9ea95 100644
> --- a/drivers/mfd/sm501.c
> +++ b/drivers/mfd/sm501.c
> @@ -1430,7 +1430,7 @@ static int __devinit sm501_plat_probe(struct platform_device *dev)
>  	}
>  
>  	sm->regs_claim = request_mem_region(sm->io_res->start,
> -					    0x100, "sm501");
> +					    resource_size(sm->io_res), "sm501");
>  
>  	if (sm->regs_claim == NULL) {
>  		dev_err(&dev->dev, "cannot claim registers\n");
> @@ -1440,8 +1440,7 @@ static int __devinit sm501_plat_probe(struct platform_device *dev)
>  
>  	platform_set_drvdata(dev, sm);
>  
> -	sm->regs = ioremap(sm->io_res->start,
> -			   (sm->io_res->end - sm->io_res->start) - 1);
> +	sm->regs = ioremap(sm->io_res->start, resource_size(sm->io_res));
>  
>  	if (sm->regs == NULL) {
>  		dev_err(&dev->dev, "cannot remap registers\n");
> @@ -1645,7 +1644,7 @@ static int __devinit sm501_pci_probe(struct pci_dev *dev,
>  	sm->mem_res = &dev->resource[0];
>  
>  	sm->regs_claim = request_mem_region(sm->io_res->start,
> -					    0x100, "sm501");
> +					    resource_size(sm->io_res), "sm501");
>  	if (sm->regs_claim == NULL) {
>  		dev_err(&dev->dev, "cannot claim registers\n");
>  		err= -EBUSY; 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
