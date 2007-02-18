Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbXBRL3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbXBRL3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 06:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933234AbXBRL3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 06:29:32 -0500
Received: from noname.neutralserver.com ([70.84.186.210]:32271 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217AbXBRL3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 06:29:31 -0500
Date: Sun, 18 Feb 2007 13:29:03 +0200
From: Dan Aloni <da-x@monatomic.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: e2b2rom_init_one():  Unable to register resource
Message-ID: <20070218112903.GA5102@localdomain>
References: <20070217212918.GA26554@localdomain> <20070218104222.GC10865@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218104222.GC10865@cvg>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 01:42:22PM +0300, Cyrill Gorcunov wrote:
> Hi,
> 
> here is a patch attached to the mail. You may test it. Actually
> I have no 64bit machine to test it and I'm worried about the
> patch accuracy. So be carefull testing it. I sent a copy of the
> message to Andi Kleen (who is a maintainer of X86-64 port) may be
> we should wait for its answer ;)

Thanks, I'll give it a try soon.

BTW, wouldn't it be better just to change the type of phys and size
to u32?

> diff --git a/drivers/mtd/maps/esb2rom.c b/drivers/mtd/maps/esb2rom.c
> index a9d808a..d63c060 100644
> --- a/drivers/mtd/maps/esb2rom.c
> +++ b/drivers/mtd/maps/esb2rom.c
> @@ -214,6 +214,9 @@ static int __devinit esb2rom_init_one(struct pci_dev *pdev,
>  
>  	/* reserved  0x0020 and 0x0010 */
>  	window->phys -= 0x400000UL;
> +#ifdef CONFIG_64BIT
> +	window->phys &= 0xffffffffUL;
> +#endif
>  	window->size = (0xffffffffUL - window->phys) + 1UL;
>  
>  	/* Enable writes through the rom window */


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
