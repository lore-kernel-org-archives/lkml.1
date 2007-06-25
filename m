Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbXFYELW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbXFYELW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXFYELN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:11:13 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:38997 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbXFYELL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:11:11 -0400
Date: Sun, 24 Jun 2007 22:10:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 2.6.22-rc5] libata: add HTS541616J9SA00 to NCQ blacklist
In-reply-to: <467F3EF6.4000907@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, enricoss@tiscali.it,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Message-id: <467F4031.8000406@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.sspu6LOivd/touNtS2IsMKPqHa0@ifi.uio.no>
 <fa.19XJG1Asdp1zwcWLxolIH6F+5lY@ifi.uio.no> <467EC909.9040006@shaw.ca>
 <467F2495.3080509@gmail.com> <467F286B.40607@gmail.com>
 <467F2ADF.1040600@shaw.ca> <467F2D53.2000202@gmail.com>
 <467F3AE2.7010606@vc.cvut.cz> <467F3EF6.4000907@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Petr Vandrovec wrote:
>>>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>>>> index adfae9d..fbca8d8 100644
>>>>> --- a/drivers/ata/libata-core.c
>>>>> +++ b/drivers/ata/libata-core.c
>>>>> @@ -3803,6 +3803,7 @@ static const struct ata_blacklist_entry
>>>>> ata_device_blacklist [] = {
>>>>>      /* Drives which do spurious command completion */
>>>>>      { "HTS541680J9SA00",    "SB2IC7EP",    ATA_HORKAGE_NONCQ, },
>>>>>      { "HTS541612J9SA00",    "SBDIC7JP",    ATA_HORKAGE_NONCQ, },
>>>>> +    { "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
>>>>>      { "WDC WD740ADFD-00NLR1", NULL,        ATA_HORKAGE_NONCQ, },
>>>>>  
>>>>>      /* Devices with NCQ limits */
>>>>>
>>>> Is that the right ID string? Strange that that one has Hitachi at the
>>>> front and the others don't..
>>> Yeah, I realized that and asked Enrico about it.  :-)
>> I think that "new" one is correct, while old ones are incorrect (unless
>> it uses strstr()) - all my Hitachis claim to be Hitachis - like this one
>> (which seems to work fine with NCQ):
>>
>> gwy:~# hdparm -i /dev/sda
>>
>> /dev/sda:
>>
>>  Model=Hitachi HDT725032VLA380                 , FwRev=V54OA52A,
>> SerialNo=      VFA200R208LH5J
>>  Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs }
> 
> Hmmm... The last one (HTS541612J9SA00) is taken directly from hdparm
> output, and I think I verified the patch with the reporter.  Hmm... Can
> anyone verify these module strings?

Could well be that they've started attaching Hitachi to the ID strings 
now.. In the past it hasn't seemed to have been Hitachi's (and IBM's 
before that) practice to have it there, but maybe they see the advantage 
of being able to figure out who made the drive now :-)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

