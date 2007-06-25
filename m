Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbXFYEFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbXFYEFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXFYEFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:05:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:12588 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbXFYEFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:05:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UK7/Kkl9bOYMIWPu2WcuF46Fdw2kg8hcxoCnRi+k/uKk8H/X/hWxmhvqG9c5IZ/K2rghtcNkjLwxVOMibhy/60f4ZQyHac7wmsRmyoPf1Z+CiqKkwMqXzKKX5waLpalya4hBz/Pv3AYzwXMuXlFCX43bFaUWqYvnsMoByAueioE=
Message-ID: <467F3EF6.4000907@gmail.com>
Date: Mon, 25 Jun 2007 13:05:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Petr Vandrovec <vandrove@vc.cvut.cz>
CC: Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, enricoss@tiscali.it,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2.6.22-rc5] libata: add HTS541616J9SA00 to NCQ blacklist
References: <fa.sspu6LOivd/touNtS2IsMKPqHa0@ifi.uio.no> <fa.19XJG1Asdp1zwcWLxolIH6F+5lY@ifi.uio.no> <467EC909.9040006@shaw.ca> <467F2495.3080509@gmail.com> <467F286B.40607@gmail.com> <467F2ADF.1040600@shaw.ca> <467F2D53.2000202@gmail.com> <467F3AE2.7010606@vc.cvut.cz>
In-Reply-To: <467F3AE2.7010606@vc.cvut.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Vandrovec wrote:
>>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>>> index adfae9d..fbca8d8 100644
>>>> --- a/drivers/ata/libata-core.c
>>>> +++ b/drivers/ata/libata-core.c
>>>> @@ -3803,6 +3803,7 @@ static const struct ata_blacklist_entry
>>>> ata_device_blacklist [] = {
>>>>      /* Drives which do spurious command completion */
>>>>      { "HTS541680J9SA00",    "SB2IC7EP",    ATA_HORKAGE_NONCQ, },
>>>>      { "HTS541612J9SA00",    "SBDIC7JP",    ATA_HORKAGE_NONCQ, },
>>>> +    { "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
>>>>      { "WDC WD740ADFD-00NLR1", NULL,        ATA_HORKAGE_NONCQ, },
>>>>  
>>>>      /* Devices with NCQ limits */
>>>>
>>> Is that the right ID string? Strange that that one has Hitachi at the
>>> front and the others don't..
>>
>> Yeah, I realized that and asked Enrico about it.  :-)
> 
> I think that "new" one is correct, while old ones are incorrect (unless
> it uses strstr()) - all my Hitachis claim to be Hitachis - like this one
> (which seems to work fine with NCQ):
> 
> gwy:~# hdparm -i /dev/sda
> 
> /dev/sda:
> 
>  Model=Hitachi HDT725032VLA380                 , FwRev=V54OA52A,
> SerialNo=      VFA200R208LH5J
>  Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs }

Hmmm... The last one (HTS541612J9SA00) is taken directly from hdparm
output, and I think I verified the patch with the reporter.  Hmm... Can
anyone verify these module strings?

-- 
tejun
