Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbXKAL1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbXKAL1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 07:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757319AbXKAL1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 07:27:11 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20176 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322AbXKAL1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 07:27:10 -0400
Date: Thu, 1 Nov 2007 12:24:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-ide@vger.kernel.org
Subject: Re: Suspend to ram regression (2.6.24-rc1-git)
Message-ID: <20071101112419.GE5037@kernel.dk>
References: <20071031201308.GK11514@kernel.dk> <20071101084145.GA5037@kernel.dk> <20071101092155.GB5037@kernel.dk> <4729B670.7090403@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4729B670.7090403@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01 2007, Jeff Garzik wrote:
> Jens Axboe wrote:
>> Reverting just the default AHCI flags makes it work again. IOW, with the
>> below patch I can suspend properly with current -git.
>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>> index ed9b407..77f7631 100644
>> --- a/drivers/ata/ahci.c
>> +++ b/drivers/ata/ahci.c
>> @@ -190,8 +190,7 @@ enum {
>>   	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
>>  					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
>> -					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
>> -					  ATA_FLAG_IPM,
>> +					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN,
>>  	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
>
>
> sounds like the easy thing to do, in light of this breakage, might be to 
> default it to off, add a module parameter turning it on by setting that 
> flag.

Wouldn't it be better to just get this bug fixed? IOW, is there a reason
for disabling ALPM if it's Bug Free?

I'd suggest committing the patch disabling IPM, then Kristen can debug
the thing in piece in quiet. Once confident it works with ahci again, we
can revert that commit.

-- 
Jens Axboe

