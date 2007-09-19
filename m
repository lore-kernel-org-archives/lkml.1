Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbXISJ2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbXISJ2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 05:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbXISJ2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 05:28:47 -0400
Received: from mail.dgt.com.pl ([195.117.141.2]:52372 "EHLO dgt.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbXISJ2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 05:28:46 -0400
DGT-Virus-Scanned: amavisd-new at dgt.com.pl
Message-ID: <46F0EBB0.9030909@dgt.com.pl>
Date: Wed, 19 Sep 2007 11:28:16 +0200
From: Wojciech Kromer <wojciech.kromer@dgt.com.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); pl-PL; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Intel-Quad on GA-P35-S3 motherboard with 4*2GB
References: <46EA4B50.7040904@dgt.com.pl> <20070914131859.GC5386@csclub.uwaterloo.ca> <46EF77D8.3090808@dgt.com.pl> <20070918142047.GF5386@csclub.uwaterloo.ca> <46EFE23F.8090100@dgt.com.pl> <20070918145009.GH5386@csclub.uwaterloo.ca>
In-Reply-To: <20070918145009.GH5386@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>   
>> It's Intel-quad, so there are 4 CPUs.
>>     
>
> Weird.  The message about the MTRR on all the CPUs not maching sound
> like a strange bios bug.  Are you running the latest bios version?
>   
>   
See the story below.
> Looks to match the MTRR setup at least.  So how much ram does the kernel
> actually want to use?
>
>   
a)With mem=8GB parameter I had:

#free -m
total used free shared buffers cached
Mem: 6473 474 5999 0 29 278


b) Without mem=8GM system slows down while booting and sometimes restart...


==== So the story begins ===========================

It's strange GIGABYTE missinformation, but:
- my board came with F2 release
- after detecting memory problem, I've upgraded it to F4 (latest at this 
moment)
- next day came with F5 release ,
there was only one info: "Fix PS2 keyboard compatibility issues",
so I decided *not* to upgrade BIOS

But yesterday I've finally upgraded to F5 release.
... and here is *surrprise*: MTRR changed to:

#cat /proc/mtrr
reg00: base=0x00000000 ( 0MB), size=4096MB: write-back, count=1
reg01: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
reg02: base=0xa0000000 (2560MB), size= 512MB: uncachable, count=1
reg03: base=0x100000000 (4096MB), size=4096MB: write-back, count=1
reg04: base=0x200000000 (8192MB), size=2048MB: write-back, count=1
reg05: base=0x260000000 (9728MB), size= 512MB: uncachable, count=1
reg06: base=0x9ff00000 (2559MB), size= 1MB: write-through, count=1

Now there are no complains about MTRR in dmesg.

E820 seems to be the same:

BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 000000009fee0000 (usable)
BIOS-e820: 000000009fee0000 - 000000009fee3000 (ACPI NVS)
BIOS-e820: 000000009fee3000 - 000000009fef0000 (ACPI data)
BIOS-e820: 000000009fef0000 - 000000009ff00000 (reserved)
BIOS-e820: 00000000c0000000 - 00000000c4000000 (reserved)
BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
BIOS-e820: 0000000100000000 - 0000000260000000 (usable)

And finally I have my 8GB working without any kernel parameter,

# free -m
total used free shared buffers cached
Mem: 7988 1120 6868 0 88 612

Now i need to rerun memory tests.
Thank you for helping me with this stuff.


