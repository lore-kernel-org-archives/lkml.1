Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbXCaQzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbXCaQzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbXCaQzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:55:52 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:1207 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbXCaQzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:55:51 -0400
Message-ID: <460E9294.3020005@rtr.ca>
Date: Sat, 31 Mar 2007 12:55:48 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: libata bugfix: preserve LBA bit for HDIO_DRIVE_TASK
References: <20070330205938.984247529@mini.kroah.org> <20070330210659.GK29450@kroah.com> <460D8510.1050102@pobox.com> <460DD725.1040607@gmail.com>
In-Reply-To: <460DD725.1040607@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Mark Lord wrote:
>> Ideally, this would go into linux-2.6.21.
>>
>> Preserve the LBA bit in the DevSel/Head register for HDIO_DRIVE_TASK.
>>
>> Signed-off-by:  Mark Lord <mlord@pobox.com>
>> ---
>> --- linux/drivers/ata/libata-scsi.c.orig    2007-03-21
>> 13:35:02.000000000 -0400
>> +++ linux/drivers/ata/libata-scsi.c    2007-03-30 17:40:58.000000000 -0400
>> @@ -333,7 +333,7 @@
>>     scsi_cmd[8]  = args[3];
>>     scsi_cmd[10] = args[4];
>>     scsi_cmd[12] = args[5];
>> -    scsi_cmd[13] = args[6] & 0x0f;
>> +    scsi_cmd[13] = args[6] & 0x4f;
>>     scsi_cmd[14] = args[0];
>>
>>     /* Good values for timeout and retries?  Values below
> 
> IDE seems to be just overriding devsel (0x10) and leaving the rest
> alone.  Maybe we should do (args[6] & ~0x10) here?  Or is it safer this way?

Same thoughts here.  I went "conservative" on this one,
because the entire field has been all zeros until this patch,
and I didn't want to trigger any possible latent bugs in libata.

Whatever.

Cheers
