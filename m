Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbXFVI3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbXFVI3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 04:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXFVI3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 04:29:13 -0400
Received: from arx.rabbit.us ([68.251.127.6]:4559 "EHLO arx.rabbit.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbXFVI3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 04:29:12 -0400
Message-ID: <467B8855.1030007@rabbit.us>
Date: Fri, 22 Jun 2007 10:29:09 +0200
From: Peter Rabbitson <rabbit@rabbit.us>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: Terrible IO performance when using 4GB of RAM on a 32 bit machine
References: <fa.8+Qu4ZH2B8PP3bRaZ5LNdUcsFIQ@ifi.uio.no> <fa.X6rjOVHT6SoOzt6SHEJROeRgf98@ifi.uio.no> <fa.qwrQSldd4OzDT6RgWE5P1BD9PJw@ifi.uio.no> <467B1100.4000401@shaw.ca>
In-Reply-To: <467B1100.4000401@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Peter Rabbitson wrote:
>> H. Peter Anvin wrote:
>>>
>>> What does /proc/mtrr look like in the two cases?
>>>
>>
>> Identical for mem=3900 and without it.
>>
>> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>> reg02: base=0xc0000000 (3072MB), size= 512MB: write-back, count=1
>> reg03: base=0xe0000000 (3584MB), size= 256MB: write-back, count=1
>> reg04: base=0xf0000000 (3840MB), size= 128MB: write-back, count=1
>> reg05: base=0xf8000000 (3968MB), size=  32MB: write-back, count=1
> 
> Looks like another case of bad MTRRs on an Intel motherboard? The BIOS 
> is marking only memory up to 4000MB as cacheable, but the actual memory 
> extends up to about 4031MB. Therefore anything that accesses the top 
> 31MB of memory will run very slow.
> 

Ah, it all makes sense now. In this case I assume mem=4000 is perfectly 
safe and usable for the time being. In the beginning I tried with 
mem=4g, which obviously did not work. If anyone is interested in adding 
an exception/workaround for this particular motherboard, I'd be happy to 
help with testing. I have added more information about the system: 
current kernel config [1], output of `lspci -vv`[2], dmesg with mem=4000[3].

Thank you!

Peter

[1] http://rabbit.us/pool/4g/config-2.6.21.5.arzamas.6.txt
[2] http://rabbit.us/pool/4g/lspci_4000.txt
[3] http://rabbit.us/pool/4g/dmesg_4000.txt
