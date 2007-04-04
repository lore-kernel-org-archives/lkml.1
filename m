Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbXDDO0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbXDDO0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbXDDO0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:26:37 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:45730 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbXDDO0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:26:34 -0400
Date: Wed, 04 Apr 2007 08:26:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] libata: add NCQ blacklist entries from Silicon Image
 Windows driver (v2)
In-reply-to: <46134137.2010102@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <4613B58E.5020000@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
 <20070331181940.GV14134@stusta.de> <4611D289.5090209@shaw.ca>
 <46134137.2010102@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Robert Hancock wrote:
>> This adds some NCQ blacklist entries taken from the Silicon Image 
>> 3124/3132
>> Windows driver .inf files. There are some confirming reports of problems
>> with these drives under Linux (for example 
>> http://lkml.org/lkml/2007/3/4/178)
>> so let's disable NCQ on these drives.
>>
>> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>>
>> --- linux-2.6.21-rc5-git9/drivers/ata/libata-core.c    2007-04-02 
>> 21:03:29.000000000 -0600
>> +++ linux-2.6.21-rc5-git9edit/drivers/ata/libata-core.c    2007-04-02 
>> 21:26:23.000000000 -0600
>> @@ -3363,6 +3363,11 @@ static const struct ata_blacklist_entry     { 
>> "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
>>     /* NCQ hard hangs device under heavier load, needs hard power 
>> cycle */
>>     { "Maxtor 6B250S0",    "BANC1B70",    ATA_HORKAGE_NONCQ },
>> +    /* Blacklist entries taken from Silicon Image 3124/3132
>> +       Windows driver .inf file - also several Linux problem reports */
>> +    { "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
>> +    { "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
>> +    { "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
> 
> The thread you link to seems like an irq problem, especially because it 
> worked in 2.6.20 and prior?
> 
>     Jeff

According to this post:

http://lkml.org/lkml/2007/3/9/475

with 2.6.21-rc3, it started working after the kernel disabled NCQ 
because of too many errors. That seems to point away from it being an 
IRQ problem, as you'd expect it to not work at all. I don't expect the 
interrupts would be handled any differently between NCQ and non-NCQ 
commands. However, apparently disabling ACPI also prevents the problem, 
which does seem a bit odd.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

