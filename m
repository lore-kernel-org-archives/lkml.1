Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbXICIxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbXICIxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbXICIxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:53:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:37276 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXICIxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:53:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tKW9bp1PXj120pmC2ZaeJRj/dRyOUlI+vEeZ7Qu5B01ghUlCNVaJ0hfXewx+z6BjA2Ea3EaGxNNGZMfUurWbcWKn7RNnFRMFZBw7v45sKl6pCyUUr0TaVb/ziUbzLJ6QUCRvJv9kZiV9cCCbyyVc0ZStdccyoCy7mmOlT8LIPuc=
Message-ID: <46DBCB6C.8080206@gmail.com>
Date: Mon, 03 Sep 2007 17:53:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: bryan@arbores.ca, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Stardom SATA HSM violation
References: <46CFA08E.6090604@arbores.ca> <6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>
In-Reply-To: <6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Hi,
> 
> [Adding linux-ide to CC]
> 
> On 25/08/07, Bryan Woods <bryan@arbores.ca> wrote:
>> Hi KML
>>
>> I am installing gentoo 2007.0 (kernel 2.6.19) on a dual AMD Opteron server (total of 4 cores). The hard disk is a Stardom 2611-2S-S1 device: actually two 250GB drives in a RAID0 config managed by the device itself - it should appear to the kernel as one SATA drive. If it matters, the underlying HDs are "Seagate Barracuda 7200 10"s. Here's the device:
>>
>>  http://www.synetic.net/Synetic-Products/Stardoms/SR-2611-SA/Stardom-2611.htm
>>
>> During the install and at different points in the process I get an "HSM violation" and the system becomes unresponsive. It looks like a similar situation to:
>>
>>   http://lkml.org/lkml/2007/6/6/195
>>
>> Will more recent kernels work with this hardware (should I keep it and try the install again) or should I switch hardware to something more compatible (like an Adaptec card)?
>>
>> Thanks!
>> Bryan
>>
>> --
>> console output:
>>
>> tag 0 cmd 0x39 Emask 0x2 stat 0x58 err 0x0 (HSM violation)
>> exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>
>> --
>> Output from hdparm -I /dev/sda:
>>
>> /dev/sda:
>>
>> ATA device, with non-removable media
>>         Model Number:   STARDOM V.36.A0B
>>         Serial Number:
>>         Firmware Revision:      V.36.A0B
>> Standards:
>>         Used: ATA/ATAPI-6 T13 1410D revision 0
>>
>> [snip]
>>
>> Commands/features:
>>         Enabled Supported:
>>         *       SMART feature set
>>         *       Power Management feature set
>>         *       Advanced Power Management feature set
>>         *       48-bit Address feature set
>>         *       Mandatory FLUSH_CACHE
>>         *       SATA-I signaling speed (1.5 Gb/s)
>>         *       SATA-II signaling speed (3.0 Gb/s)
>>
>> --
>> Parts of dmesg:
>> libata version 2.00 loaded
>> sata_nv 0000:00:05.0: version 2.0
>> ata1: SATA max UDMA/133 cmd 0xD480 ctl 0xD402 bmdma 0xCC00 irq 21
>> ata2: SATA max UDMA/133 cmd 0xD080 ctl 0xD002 bmdma 0xCC08 irq 21
>> scsi0 : sata_nv
>> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> ata1.00: ATA-6, max UDMA/133,976794112 sectors: LBA48
>> ata1.00: ata1: dev 0 multi count 1
>> ata1.00: applying bridge limits
>> ata1.00: configured for UDMA/100

Please post full dmesg and full 'hdparm -I' result.  Also, if possible,
please try 2.6.22.5.  Even if it doesn't fix the problem, it would
report error conditions better.

-- 
tejun
