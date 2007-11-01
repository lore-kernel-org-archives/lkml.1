Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbXKALzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbXKALzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 07:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbXKALzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 07:55:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38841 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbXKALzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 07:55:35 -0400
Message-ID: <4729BEB5.5080504@garzik.org>
Date: Thu, 01 Nov 2007 07:55:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-ide@vger.kernel.org
Subject: Re: Suspend to ram regression (2.6.24-rc1-git)
References: <20071031201308.GK11514@kernel.dk> <20071101084145.GA5037@kernel.dk> <20071101092155.GB5037@kernel.dk> <4729B670.7090403@garzik.org> <20071101112419.GE5037@kernel.dk>
In-Reply-To: <20071101112419.GE5037@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Nov 01 2007, Jeff Garzik wrote:
>> Jens Axboe wrote:
>>> Reverting just the default AHCI flags makes it work again. IOW, with the
>>> below patch I can suspend properly with current -git.
>>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>>> index ed9b407..77f7631 100644
>>> --- a/drivers/ata/ahci.c
>>> +++ b/drivers/ata/ahci.c
>>> @@ -190,8 +190,7 @@ enum {
>>>   	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
>>>  					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
>>> -					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
>>> -					  ATA_FLAG_IPM,
>>> +					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN,
>>>  	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
>>
>> sounds like the easy thing to do, in light of this breakage, might be to 
>> default it to off, add a module parameter turning it on by setting that 
>> flag.
> 
> Wouldn't it be better to just get this bug fixed? IOW, is there a reason
> for disabling ALPM if it's Bug Free?
> 
> I'd suggest committing the patch disabling IPM, then Kristen can debug
> the thing in piece in quiet. Once confident it works with ahci again, we
> can revert that commit.

Right -- if you are going to commit a patch "disabling" it, it is best 
to do so via a simple module option, which allows users to easily try 
the feature in parallel with Intel's debugging.

	Jeff



