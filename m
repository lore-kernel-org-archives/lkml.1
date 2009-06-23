Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbZFWKPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbZFWKPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZFWKPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:15:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60381
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbZFWKPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:15:01 -0400
Date: Tue, 23 Jun 2009 03:15:06 -0700 (PDT)
Message-Id: <20090623.031506.214747802.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: elendil@planet.nl, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: cmd64x: irq 14: nobody cared - system is dreadfully slow
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906222335.06700.bzolnier@gmail.com>
References: <200906221938.27574.bzolnier@gmail.com>
	<200906222101.38586.elendil@planet.nl>
	<200906222335.06700.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 22 Jun 2009 23:35:06 +0200

> On Monday 22 June 2009 21:01:37 Frans Pop wrote:
>> yet have the DMA problem. The commit above is from the 2.6.30 development 
>> cycle, so that fits. I expect you can verify it from the identify data.
> 
> I had the same idea initially, unfortunately bit 1 is set for word 53 so this
> must be something else...

So this change should have had zero effect for Frans's case.

I double checked everything with test programs going over his
ID dump and it all checks out.

We might need to bisect this one.  But Frans, just for the record
could you simply test reverting just that hunk?  Thanks!

>> @@ -396,15 +393,14 @@ int ide_id_dma_bug(ide_drive_t *drive)
>>  
>>  	if (id[ATA_ID_FIELD_VALID] & 4) {
>>  		if ((id[ATA_ID_UDMA_MODES] >> 8) &&
>>  		    (id[ATA_ID_MWDMA_MODES] >> 8))
>>  			goto err_out;
>> -	} else if (id[ATA_ID_FIELD_VALID] & 2) {
>> -		if ((id[ATA_ID_MWDMA_MODES] >> 8) &&
>> -		    (id[ATA_ID_SWDMA_MODES] >> 8))
>> -			goto err_out;
>> -	}
>> +	} else if ((id[ATA_ID_MWDMA_MODES] >> 8) &&
>> +		   (id[ATA_ID_SWDMA_MODES] >> 8))
>> +		goto err_out;
