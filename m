Return-Path: <linux-kernel-owner+w=401wt.eu-S1762994AbXKHXeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbXKHXeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 18:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762787AbXKHXeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 18:34:09 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:61853 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762722AbXKHXeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 18:34:07 -0500
Date: Thu, 08 Nov 2007 17:32:24 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata NCQ blacklist entry
In-reply-to: <fa.N0UZia/Lx8cvsvXXK1g9So2J6rk@ifi.uio.no>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, jeff@garzik.org,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Message-id: <47339C88.9050300@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GsS7Kps/lQSHlhBlf0yXpLzcPLQ@ifi.uio.no>
 <fa.V2tP3GajMjY9gJUCTCoOjOocw+0@ifi.uio.no>
 <fa.N0UZia/Lx8cvsvXXK1g9So2J6rk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> On Nov 7, 2007 1:55 PM, Tejun Heo <htejun@gmail.com> wrote:
>> Florian La Roche wrote:
>>> Hello all,
>>>
>>> I've taking email addresses from the last NCQ blacklist changes going
>>> into the kernel.
>>> This Fujitsu drive also gives me spurious command completions. Detailed
>>> output also available at https://bugzilla.redhat.com/show_bug.cgi?id=366181.
>>>
>>> Let me know if you need more info or anything else.
>>>
>>> --- drivers/ata/libata-core.c
>>> +++ drivers/ata/libata-core.c
>>> @@ -4222,6 +4222,7 @@
>>>       { "WDC WD740ADFD-00NLR1", NULL,         ATA_HORKAGE_NONCQ, },
>>>       { "WDC WD3200AAJS-00RYA0", "12.01B01",  ATA_HORKAGE_NONCQ, },
>>>       { "FUJITSU MHV2080BH",  "00840028",     ATA_HORKAGE_NONCQ, },
>>> +     { "FUJITSU MHW2160BJ G2",       NULL,           ATA_HORKAGE_NONCQ },
>>>       { "ST9120822AS",        "3.CLF",        ATA_HORKAGE_NONCQ, },
>>>       { "ST9160821AS",        "3.CLF",        ATA_HORKAGE_NONCQ, },
>>>       { "ST9160821AS",        "3.ALD",        ATA_HORKAGE_NONCQ, },
>> Thanks.  We're currently trying to find out what's actually going on
>> with all these drives.  At first, drives which got blacklisted aren't
>> many and made sense (had other problems with NCQ, etc..) but with new
>> generation drives from many vendors showing the same symptom, we aren't
>> too sure now.
> 
> Is there a way to tell whether Windows is using NCQ or not? I checked
> the system log (or whatever it's called) on my notebook and is clean
> but I'm not sure it's using NCQ (I don't even know if it'd log
> spurious completions somewhere).

Which driver is installed for the SATA controller in Windows, the 
chipset-manufacturer-provided AHCI driver or the default Microsoft 
driver? You'd need the AHCI driver installed for NCQ to be used.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

