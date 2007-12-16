Return-Path: <linux-kernel-owner+w=401wt.eu-S1763121AbXLPVzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763121AbXLPVzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759619AbXLPVzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:55:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:12528 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759548AbXLPVzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:55:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=ZW0Vptd9/cH0zrbWwY7X8vQUbOCNATBUvaeke5Vh9/osOXe0wfNmngRY+4uXU0TWko2q6o/TjuQYq8ixWk4X781l3lxuyBprIJK6FPqQ/rG/hrsFiRuCj+W/hg3UCIHaiiT9BygfByJyr23RIy95r1G0rvq9vLXEbegD+bAncYg=
Date: Mon, 17 Dec 2007 00:55:00 +0300
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>,
       Neil Brown <neilb@suse.de>, David Chinner <dgc@sgi.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] umem nvram driver: clean up style
Message-ID: <20071216215500.GB2419@martell.zuzino.mipt.ru>
References: <20071203213558.GP115527101@sgi.com> <18260.39892.215075.795664@notabene.brown> <20071204093716.GB4541@elte.hu> <20071216131558.8e3d57e1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216131558.8e3d57e1.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 01:15:58PM -0800, Randy Dunlap wrote:
> > btw., if anyone feels so inclined, this file has quite a number of 
> > coding style issues, as per scripts/checkpatch.pl output:
> > 
> >  total: 28 errors, 54 warnings, 1221 lines checked

> Cleanup umem driver: fix all checkpatch warnings, conform to kernel
> coding style.

> --- linux-2.6.24-rc5-git3.orig/drivers/block/umem.c
> +++ linux-2.6.24-rc5-git3/drivers/block/umem.c

>  static void check_batteries(struct cardinfo *card);
>  
>  /*
> ------------------------------------------------------------------------------------
> ---                           get_userbit
> ------------------------------------------------------------------------------------
> -*/
> + *                           get_userbit
> + */

useless comments, they aren't becoming useful after prettifying, right. ;-)

>  static void dump_dmastat(struct cardinfo *card, unsigned int dmastat)
>  {
>  	dev_printk(KERN_DEBUG, &card->dev->dev, "DMAstat - ");
>  	if (dmastat & DMASCR_ANY_ERR)
> -		printk("ANY_ERR ");
> +		printk(KERN_CONT "ANY_ERR ");
>  	if (dmastat & DMASCR_MBE_ERR)
> -		printk("MBE_ERR ");
> +		printk(KERN_CONT "MBE_ERR ");
>  	if (dmastat & DMASCR_PARITY_ERR_REP)
> -		printk("PARITY_ERR_REP ");
> +		printk(KERN_CONT "PARITY_ERR_REP ");
>  	if (dmastat & DMASCR_PARITY_ERR_DET)
> -		printk("PARITY_ERR_DET ");
> +		printk(KERN_CONT "PARITY_ERR_DET ");
>  	if (dmastat & DMASCR_SYSTEM_ERR_SIG)
> -		printk("SYSTEM_ERR_SIG ");
> +		printk(KERN_CONT "SYSTEM_ERR_SIG ");
>  	if (dmastat & DMASCR_TARGET_ABT)
> -		printk("TARGET_ABT ");
> +		printk(KERN_CONT "TARGET_ABT ");
>  	if (dmastat & DMASCR_MASTER_ABT)
> -		printk("MASTER_ABT ");
> +		printk(KERN_CONT "MASTER_ABT ");
>  	if (dmastat & DMASCR_CHAIN_COMPLETE)
> -		printk("CHAIN_COMPLETE ");
> +		printk(KERN_CONT "CHAIN_COMPLETE ");
>  	if (dmastat & DMASCR_DMA_COMPLETE)
> -		printk("DMA_COMPLETE ");
> +		printk(KERN_CONT "DMA_COMPLETE ");

KERN_NOISE, it's pretty hard to not notice transformation of
bitmask to string representation, isn't it?

> @@ -889,7 +866,8 @@ static int __devinit mm_pci_probe(struct
>  		return -ENODEV;
>  
>  	dev_printk(KERN_INFO, &dev->dev,
> -		"Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))\n");
> +		"Micro Memory(tm) controller found "
> +		"(PCI Mem Module (Battery Backup))\n");

For the record, string splitting occasionaly makes grepping much more annoying:
grep. nothing? kernel in bugreport definitely spit it! [minute later]
Oh, I need to grep for smaller strings.

> @@ -1030,18 +1011,18 @@ static int __devinit mm_pci_probe(struct
>  	data = ~data;
>  	data += 1;
>  
> -	if (request_irq(dev->irq, mm_interrupt, IRQF_SHARED, DRIVER_NAME, card)) {
> +	if (request_irq(dev->irq, mm_interrupt, IRQF_SHARED, DRIVER_NAME,
> +			card)) {

Oh, c'mon!



And my pet peeve with checkpatch.pl crap: why does it force me to _add_
KERN_ markers when my patch changes code leaving printk intact, because
the patch wasn't about printk at all?

Or more philosophically, why a tool which doesn't parse C compiler-style
suddenly starts making suggestions on how C code should look like?
