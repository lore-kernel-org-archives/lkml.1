Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbXIROgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbXIROgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbXIROgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:36:04 -0400
Received: from mail.dgt.com.pl ([195.117.141.2]:45731 "EHLO dgt.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337AbXIROgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:36:02 -0400
DGT-Virus-Scanned: amavisd-new at dgt.com.pl
Message-ID: <46EFE23F.8090100@dgt.com.pl>
Date: Tue, 18 Sep 2007 16:35:43 +0200
From: Wojciech Kromer <wojciech.kromer@dgt.com.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); pl-PL; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Intel-Quad on GA-P35-S3 motherboard with 4*2GB
References: <46EA4B50.7040904@dgt.com.pl> <20070914131859.GC5386@csclub.uwaterloo.ca> <46EF77D8.3090808@dgt.com.pl> <20070918142047.GF5386@csclub.uwaterloo.ca>
In-Reply-To: <20070918142047.GF5386@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> [root@kromblack ~]# cat /proc/mtrr
>> reg00: base=0x100000000 (4096MB), size=8192MB: write-back, count=1
>> reg01: base=0x280000000 (10240MB), size=2048MB: uncachable, count=1
>> reg02: base=0x260000000 (9728MB), size= 512MB: uncachable, count=1
>> reg03: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>> reg04: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
>> reg05: base=0xa0000000 (2560MB), size= 512MB: uncachable, count=1
>> reg06: base=0x9ff00000 (2559MB), size=   1MB: write-through, count=1
>>     
>
>   
Yes, it's a bit strange, but there should be a way to configure it in linux.
I found only memmap option which does selection of regions, but not 
remapping.
> So first it says there is 8GB ram at 4GB.  Then it deletes the top 2GB
> of that and then another 512MB.  So now there is 5.5GB at 4GB.  It then
> says there is 4GB at 0GB, then deletes the top 1GB of that, and then
> another 512MB, leaving 2.5GB at 0GB.  So overall that sounds like 8GB
> total.  It also seems that if it had mapped 2GB at 0GB and 6GB at 4GB
> the MTRR would have been a heck of a lot simpler (but a 32bit OS would
> have had 512MB less ram of course).
>
>   
I have 64 bit compilation of course.
>> [root@kromblack ~]# dmesg|grep mtrr
>> mtrr: your CPUs had inconsistent variable MTRR settings
>> mtrr: probably your BIOS does not setup all CPUs.
>> mtrr: corrected configuration.
>>     
>
> Now that does sound odd.  How many CPUs does the machine have?
>
>   
It's Intel-quad, so there are 4 CPUs.
> So what does the dmesg say about the memory table it got from the bios?
> That is the e820 table.
>   

It's in prevoius mail:

# dmesg|grep BIOS-e820
> BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> BIOS-e820: 0000000000100000 - 000000009fee0000 (usable)
> BIOS-e820: 000000009fee0000 - 000000009fee3000 (ACPI NVS)
> BIOS-e820: 000000009fee3000 - 000000009fef0000 (ACPI data)
> BIOS-e820: 000000009fef0000 - 000000009ff00000 (reserved)
> BIOS-e820: 00000000c0000000 - 00000000c4000000 (reserved)
> BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> BIOS-e820: 0000000100000000 - 0000000260000000 (usable)





