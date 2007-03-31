Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbXCaRFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbXCaRFW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 13:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXCaRFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 13:05:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:61743 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbXCaRFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 13:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=rU1eZaovazN4Ew6CLmj1n+i7x23VdSatZ91r7HD7zRLX9aECH/wtySosfqg/QYQK3JeBIbexeQ+jS5Ok8GUMABVQzKK/kY/7V+Nu295xF4kzpXciP6OwtBQee0BjbeMA3JMKdhNAJ5GSt9yTGGwxhCyPnrb7IQfgOwdp80SkUs4=
Message-ID: <460E94C9.1040509@gmail.com>
Date: Sun, 01 Apr 2007 02:05:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: libata bugfix: preserve LBA bit for HDIO_DRIVE_TASK
References: <20070330205938.984247529@mini.kroah.org> <20070330210659.GK29450@kroah.com> <460D8510.1050102@pobox.com> <460DD725.1040607@gmail.com> <460E9294.3020005@rtr.ca>
In-Reply-To: <460E9294.3020005@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Tejun Heo wrote:
>> Mark Lord wrote:
>>> Ideally, this would go into linux-2.6.21.
>>>
>>> Preserve the LBA bit in the DevSel/Head register for HDIO_DRIVE_TASK.
>>>
>>> Signed-off-by:  Mark Lord <mlord@pobox.com>
>>> ---
>>> --- linux/drivers/ata/libata-scsi.c.orig    2007-03-21
>>> 13:35:02.000000000 -0400
>>> +++ linux/drivers/ata/libata-scsi.c    2007-03-30 17:40:58.000000000 
>>> -0400
>>> @@ -333,7 +333,7 @@
>>>     scsi_cmd[8]  = args[3];
>>>     scsi_cmd[10] = args[4];
>>>     scsi_cmd[12] = args[5];
>>> -    scsi_cmd[13] = args[6] & 0x0f;
>>> +    scsi_cmd[13] = args[6] & 0x4f;
>>>     scsi_cmd[14] = args[0];
>>>
>>>     /* Good values for timeout and retries?  Values below
>>
>> IDE seems to be just overriding devsel (0x10) and leaving the rest
>> alone.  Maybe we should do (args[6] & ~0x10) here?  Or is it safer 
>> this way?
> 
> Same thoughts here.  I went "conservative" on this one,
> because the entire field has been all zeros until this patch,
> and I didn't want to trigger any possible latent bugs in libata.
> 
> Whatever.

Yeah, I agree 'whatever' should work here.  :-)

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
