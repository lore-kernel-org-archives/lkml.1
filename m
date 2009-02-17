Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbZBQAgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbZBQAgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 19:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbZBQAgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 19:36:04 -0500
Received: from h155.mvista.com ([63.81.120.155]:4231 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750729AbZBQAgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 19:36:01 -0500
Message-ID: <499A066A.7060509@ru.mvista.com>
Date: Tue, 17 Feb 2009 03:35:54 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       =?UTF-8?B?SGFubm8gQsO2Y2s=?= <hanno@hboeck.de>
Subject: Re: [PATCH] libata: Don't trust current capacity values in identify
 words 57-58
References: <4999CA54.1060306@gmail.com> <4999F032.6060107@rtr.ca>
In-Reply-To: <4999F032.6060107@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mark Lord wrote:

>> Hanno Böck reported a problem where an old Conner CP30254 240MB hard 
>> drive
>> was reported as 1.1TB in capacity by libata:
>>
>> http://lkml.org/lkml/2009/2/13/134
>>
>> This was caused by libata trusting the drive's reported current 
>> capacity in sectors in identify words 57 and 58 if the drive does not 
>> support LBA and the
>> current CHS translation values appear valid. Unfortunately it seems 
>> older
>> ATA specs were vague about what this field should contain and a 
>> number of drives
>> used values with wrong byte order or that were totally bogus. There's no
>> unique information that it conveys and so we can just calculate the 
>> number
>> of sectors from the reported current CHS values.
>>
>> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
> ..
>>      } else {
>>          if (ata_id_current_chs_valid(id))
>> -            return ata_id_u32(id, 57);
>> +            return id[54] * id[55] * id[56];
>>          else
>>              return id[1] * id[3] * id[6];
> ..
>
> NAK.  That's not quite correct, either.
>
> The LBA capacity can be larger than the CHS capacity,
> so we have to use the reported LBA values if at all possible.
>
> That's why ata_id_is_lba_capacity_ok() exists,
> and why it looks so peculiar.

   I think that checking LBA validity is a matter of another patch. This 
patch in itself should be sufficient.

> Some of those early drives really did require that kind of logic.

   I hightly doubt that this 240 MB drive is LBA capable at all.

> Cheers

MBR, Sergei


