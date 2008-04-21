Return-Path: <linux-kernel-owner+w=401wt.eu-S1761420AbYDUTkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420AbYDUTkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYDUTkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:40:01 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54491 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbYDUTj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:39:59 -0400
Date: Mon, 21 Apr 2008 22:39:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: chris@zankel.net, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] xtensa: don't offer ATA
Message-ID: <20080421193927.GA2633@cs181133002.pp.htv.fi>
References: <20080414195521.GB26885@cs181133002.pp.htv.fi> <4807A771.2020405@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4807A771.2020405@pobox.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 03:39:29PM -0400, Jeff Garzik wrote:
> Adrian Bunk wrote:
>> Trying to build libata for xtensa fails with the following error:
>>
>> <--  snip  -->
>>
>> ...
>>   CC [M]  drivers/ata/libata-core.o
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c: In function 'ata_devchk':
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:1034: error: implicit declaration of function 'iowrite8'
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:1043: error: implicit declaration of function 'ioread8'
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c: In function 'ata_data_xfer':
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5027: error: implicit declaration of function 'ioread16_rep'
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5029: error: implicit declaration of function 'iowrite16_rep'
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5037: error: implicit declaration of function 'ioread16'
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5041: error: implicit declaration of function 'iowrite16'
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c: In function 'ata_wait_register':
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:7700: error: implicit declaration of function 'ioread32'
>> make[3]: *** [drivers/ata/libata-core.o] Error 1
>>
>> <--  snip  -->
>>
>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>>
>> ---
>> aa579e7ab065e41a9d1e27e1f4b7af6b0508018c diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
>> index 25aba69..f34e9d1 100644
>> --- a/drivers/ata/Kconfig
>> +++ b/drivers/ata/Kconfig
>> @@ -6,7 +6,7 @@ menuconfig ATA
>>  	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
>>  	depends on HAS_IOMEM
>>  	depends on BLOCK
>> -	depends on !(M32R || M68K) || BROKEN
>> +	depends on !(M32R || M68K || XTENSA) || BROKEN
>>  	depends on !SUN4 || BROKEN
>>  	select SCSI
>
> XTENSA offers HAS_IOMEM but not iomem functions?  That seems like the  
> problem to me.

Chris, can you comment on this?

> Overall, we should not be adding specific arches to an exclusion list,  
> we should defining HAS_IOFOO or MISSING_IOFOO or another symbol in the  
> appropriate arch.
>
> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

