Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZBPXy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZBPXy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbZBPXrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:47:07 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:14443 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbZBPXrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:47:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AdmOPzgMQ3Munj/M9xUXPw5bl+oZVComZcnr6jrWO2vcs8iGt9QJT16T8kZSc+o77I
         No8Ga9012QLMbP3+tIn58QobQZUu515rqpYgUDi6dcCkLaGJtEbj2IIn+4ZdKCbik1uH
         clIpLH2L8B80ski2Nqy+3bz3PAodOcBJQrFk4=
Message-ID: <4999FAF2.1000800@gmail.com>
Date: Mon, 16 Feb 2009 17:46:58 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
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

Mark Lord wrote:
> Robert Hancock wrote:
>> Hanno Böck reported a problem where an old Conner CP30254 240MB hard 
>> drive
>> was reported as 1.1TB in capacity by libata:
>>
>> http://lkml.org/lkml/2009/2/13/134
>>
>> This was caused by libata trusting the drive's reported current 
>> capacity in sectors in identify words 57 and 58 if the drive does not 
>> support LBA and the
>> current CHS translation values appear valid. Unfortunately it seems older
>> ATA specs were vague about what this field should contain and a number 
>> of drives
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
> 
> Some of those early drives really did require that kind of logic.

This is the !ata_id_has_lba code path. If the drive supports LBA then 
the LBA capacity will always be used, that hasn't changed.
