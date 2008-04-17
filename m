Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYDQTjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYDQTjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYDQTjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:39:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45870 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbYDQTjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:39:43 -0400
Message-ID: <4807A771.2020405@pobox.com>
Date: Thu, 17 Apr 2008 15:39:29 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: chris@zankel.net, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] xtensa: don't offer ATA
References: <20080414195521.GB26885@cs181133002.pp.htv.fi>
In-Reply-To: <20080414195521.GB26885@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Trying to build libata for xtensa fails with the following error:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/ata/libata-core.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c: In function 'ata_devchk':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:1034: error: implicit declaration of function 'iowrite8'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:1043: error: implicit declaration of function 'ioread8'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c: In function 'ata_data_xfer':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5027: error: implicit declaration of function 'ioread16_rep'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5029: error: implicit declaration of function 'iowrite16_rep'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5037: error: implicit declaration of function 'ioread16'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5041: error: implicit declaration of function 'iowrite16'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c: In function 'ata_wait_register':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:7700: error: implicit declaration of function 'ioread32'
> make[3]: *** [drivers/ata/libata-core.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> aa579e7ab065e41a9d1e27e1f4b7af6b0508018c diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 25aba69..f34e9d1 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -6,7 +6,7 @@ menuconfig ATA
>  	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
>  	depends on HAS_IOMEM
>  	depends on BLOCK
> -	depends on !(M32R || M68K) || BROKEN
> +	depends on !(M32R || M68K || XTENSA) || BROKEN
>  	depends on !SUN4 || BROKEN
>  	select SCSI

XTENSA offers HAS_IOMEM but not iomem functions?  That seems like the 
problem to me.

Overall, we should not be adding specific arches to an exclusion list, 
we should defining HAS_IOFOO or MISSING_IOFOO or another symbol in the 
appropriate arch.

	Jeff




