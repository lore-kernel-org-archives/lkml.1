Return-Path: <linux-kernel-owner+w=401wt.eu-S1751212AbZAEWcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbZAEWcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZAEWcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:32:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:38978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbZAEWcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:32:24 -0500
Message-ID: <49628A54.10403@kernel.org>
Date: Mon, 05 Jan 2009 14:31:48 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: david@lang.hm
CC: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
References: <20090102174845.GD5372@localhost> <20090102203058.GH5372@localhost>  <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm>  <20090103161052.GB11093@localhost>  <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm>  <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost>  <496001A3.1040201@gmail.com> <20090104112919.GC7632@localhost>  <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm> <86802c440901051355o60bef5bai2a33ea5f7e4dc5f7@mail.gmail.com> <alpine.DEB.1.10.0901051516060.27641@asgard.lang.hm> <496289E3.6010407@kernel.org>
In-Reply-To: <496289E3.6010407@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> david@lang.hm wrote:
>> On Mon, 5 Jan 2009, Yinghai Lu wrote:
>>
>>> Can you send out boot log with working kernel before 2.6.28?
>>>
>>> need to look at the e820 table.
>>
>> here is the 32 bit kernel I'm running now (from dmesg )
>>
>> Linux version 2.6.25.14 (root@dlang) (gcc version 3.3.6) #1 SMP PREEMPT
>> Mon Aug 4 18:22:50 PDT 2008
>> BIOS-provided physical RAM map:
>>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>>  BIOS-e820: 0000000000100000 - 000000004cff0000 (usable)
>>  BIOS-e820: 000000004cff0000 - 000000004cfff000 (ACPI data)
>>  BIOS-e820: 000000004cfff000 - 000000004d000000 (ACPI NVS)
>>  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
>>  BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
>> Warning only 4GB will be used.
>> Use a HIGHMEM64G enabled kernel.
>> 3200MB HIGHMEM available.
>> 896MB LOWMEM available.
>> Scan SMP from c0000000 for 1024 bytes.
>> Scan SMP from c009fc00 for 1024 bytes.
>> Scan SMP from c00f0000 for 65536 bytes.
>> found SMP MP-table at [c00ff780] 000ff780
>> Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
>> Zone PFN ranges:
>>   DMA             0 ->     4096
>>   Normal       4096 ->   229376
>>   HighMem    229376 ->  1048576
>> Movable zone start PFN for each node
>> early_node_map[1] active PFN ranges
>>     0:        0 ->  1048576
>> On node 0 totalpages: 1048576
>>   DMA zone: 32 pages used for memmap
>>   DMA zone: 0 pages reserved
>>   DMA zone: 4064 pages, LIFO batch:0
>>   Normal zone: 1760 pages used for memmap
>>   Normal zone: 223520 pages, LIFO batch:31
>>   HighMem zone: 6400 pages used for memmap
>>   HighMem zone: 812800 pages, LIFO batch:31
>>   Movable zone: 0 pages used for memmap
> 
> 
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000004cff0000 (usable)
>  BIOS-e820: 000000004cff0000 - 000000004cfff000 (ACPI data)
>  BIOS-e820: 000000004cfff000 - 000000004d000000 (ACPI NVS)
>  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
> 
> and for pci mem route: node0 [0, 2g), node1 is [4g, 6g)
> 
> and e820 said only 3g can be used... [0, 1g), and [4g, 6g)
> 
> please check if you can change HW memhole setup to 3g instead 2g.
in BIOS, to get 1g back.

YH
