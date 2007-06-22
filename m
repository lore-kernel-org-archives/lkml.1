Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbXFVOid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbXFVOid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXFVOiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:38:24 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:2025 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbXFVOiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:38:23 -0400
Date: Fri, 22 Jun 2007 08:36:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Terrible IO performance when using 4GB of RAM on a 32 bit machine
In-reply-to: <467B8855.1030007@rabbit.us>
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-kernel@vger.kernel.org
Message-id: <467BDE8A.8040609@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.8+Qu4ZH2B8PP3bRaZ5LNdUcsFIQ@ifi.uio.no>
 <fa.X6rjOVHT6SoOzt6SHEJROeRgf98@ifi.uio.no>
 <fa.qwrQSldd4OzDT6RgWE5P1BD9PJw@ifi.uio.no> <467B1100.4000401@shaw.ca>
 <467B8855.1030007@rabbit.us>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Rabbitson wrote:
> Robert Hancock wrote:
>> Peter Rabbitson wrote:
>>> H. Peter Anvin wrote:
>>>>
>>>> What does /proc/mtrr look like in the two cases?
>>>>
>>>
>>> Identical for mem=3900 and without it.
>>>
>>> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>>> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>>> reg02: base=0xc0000000 (3072MB), size= 512MB: write-back, count=1
>>> reg03: base=0xe0000000 (3584MB), size= 256MB: write-back, count=1
>>> reg04: base=0xf0000000 (3840MB), size= 128MB: write-back, count=1
>>> reg05: base=0xf8000000 (3968MB), size=  32MB: write-back, count=1
>>
>> Looks like another case of bad MTRRs on an Intel motherboard? The BIOS 
>> is marking only memory up to 4000MB as cacheable, but the actual 
>> memory extends up to about 4031MB. Therefore anything that accesses 
>> the top 31MB of memory will run very slow.
>>
> 
> Ah, it all makes sense now. In this case I assume mem=4000 is perfectly 
> safe and usable for the time being. In the beginning I tried with 
> mem=4g, which obviously did not work. If anyone is interested in adding 
> an exception/workaround for this particular motherboard, I'd be happy to 
> help with testing. I have added more information about the system: 
> current kernel config [1], output of `lspci -vv`[2], dmesg with 
> mem=4000[3].
> 
> Thank you!
> 
> Peter

There was a patch floating around recently to detect the case where the 
MTRRs don't map all of RAM as write-back, automatically cap the memory 
used by the kernel to what is mapped and print some loud warnings..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

