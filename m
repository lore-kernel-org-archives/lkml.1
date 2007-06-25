Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbXFYEW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbXFYEW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXFYEWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:22:17 -0400
Received: from mailgw.cvut.cz ([147.32.3.235]:36358 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbXFYEWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:22:16 -0400
Message-ID: <467F42F3.1000609@vc.cvut.cz>
Date: Sun, 24 Jun 2007 21:22:11 -0700
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, enricoss@tiscali.it,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2.6.22-rc5] libata: add HTS541616J9SA00 to NCQ blacklist
References: <fa.sspu6LOivd/touNtS2IsMKPqHa0@ifi.uio.no> <fa.19XJG1Asdp1zwcWLxolIH6F+5lY@ifi.uio.no> <467EC909.9040006@shaw.ca> <467F2495.3080509@gmail.com> <467F286B.40607@gmail.com> <467F2ADF.1040600@shaw.ca> <467F2D53.2000202@gmail.com> <467F3AE2.7010606@vc.cvut.cz> <467F3EF6.4000907@gmail.com> <467F4031.8000406@shaw.ca>
In-Reply-To: <467F4031.8000406@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Tejun Heo wrote:
>> Petr Vandrovec wrote:
>>>>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>>>>> index adfae9d..fbca8d8 100644
>>>>>> --- a/drivers/ata/libata-core.c
>>>>>> +++ b/drivers/ata/libata-core.c
>>>>>> @@ -3803,6 +3803,7 @@ static const struct ata_blacklist_entry
>>>>>> ata_device_blacklist [] = {
>>>>>>      /* Drives which do spurious command completion */
>>>>>>      { "HTS541680J9SA00",    "SB2IC7EP",    ATA_HORKAGE_NONCQ, },
>>>>>>      { "HTS541612J9SA00",    "SBDIC7JP",    ATA_HORKAGE_NONCQ, },
>>>>>> +    { "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
>>>>>>      { "WDC WD740ADFD-00NLR1", NULL,        ATA_HORKAGE_NONCQ, },
>>>>>>  
>>>>>>      /* Devices with NCQ limits */
>>>>>>
>>>>> Is that the right ID string? Strange that that one has Hitachi at the
>>>>> front and the others don't..
>>>> Yeah, I realized that and asked Enrico about it.  :-)
>>> I think that "new" one is correct, while old ones are incorrect (unless
>>> it uses strstr()) - all my Hitachis claim to be Hitachis - like this one
>>> (which seems to work fine with NCQ):
>>>
>>> gwy:~# hdparm -i /dev/sda
>>>
>>> /dev/sda:
>>>
>>>  Model=Hitachi HDT725032VLA380                 , FwRev=V54OA52A,
>>> SerialNo=      VFA200R208LH5J
>>>  Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs }
>>
>> Hmmm... The last one (HTS541612J9SA00) is taken directly from hdparm
>> output, and I think I verified the patch with the reporter.  Hmm... Can
>> anyone verify these module strings?
> 
> Could well be that they've started attaching Hitachi to the ID strings 
> now.. In the past it hasn't seemed to have been Hitachi's (and IBM's 
> before that) practice to have it there, but maybe they see the advantage 
> of being able to figure out who made the drive now :-)

Perhaps ones sold directly by Hitachi are Hitachi, while ones sold 
through OEMs are no-name?
							Petr




