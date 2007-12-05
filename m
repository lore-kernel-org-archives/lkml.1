Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbXLEE4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbXLEE4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 23:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXLEE4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 23:56:01 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:27802 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbXLEE4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 23:56:00 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <47562F5A.8050403@am.sony.com>
Date: Tue, 04 Dec 2007 20:55:54 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: Christoph Lameter <clameter@sgi.com>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
References: <47537F2E.2070204@am.sony.com> <b91f94dd5b35247fecf52090c0b3890f@bga.com>
In-Reply-To: <b91f94dd5b35247fecf52090c0b3890f@bga.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Dec 2007 04:55:56.0972 (UTC) FILETIME=[1F4A66C0:01C836FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milton Miller wrote:
> On Dec 2, 2007, at 9:59 PM, Geoff Levand wrote:
> 
>> Hi.
>>
>> I'm finding that recently kexec'ed kernels on PS3 will
>> panic on startup.  It seems the trouble was introduced
>> with the ppc64 SPARSEMEM_VMEMMAP support.  The problem
>> is the same when starting either new or old kernels:
>>
>> 2.6.24 -> 2.6.23 ok
>> 2.6.24 -> 2.6.23 panic
>> 2.6.24 -> 2.6.24 panic
> 
> I'm not sure I completely follow this.  What is the difference between 
> 1 and 2 ?   


Sorry, '2.6.23 -> 2.6.24 ok', but it really doesn't have much meaning,
considering what the actual problem is.


> Also, you are talking about starting with kexec, but I 
> don't see how that fits in the failure you have below.


I think just buy chance the kexec'ed kernel hits because
the 2.6.24 kernel is just at the point of hitting the condition,
and the memory usage of the kexe'ed kernel hits.

If I just reduce the size of the kernel a small amount kexec
works ok, and as Geert pointed out, if you increase the size
of the first stage kernel it will hit it.


>> DMA free:72376kB min:0kB low:0kB high:0kB active:0kB inactive:0kB 
>> present:129280kB pages_scanned:0 all_unreclaimable? no
>> lowmem_reserve[]: 0 0 0
>> DMA: 8*4kB 5*8kB 5*16kB 7*32kB 3*64kB 5*128kB 4*256kB 3*512kB 5*1024kB 
>> 3*2048kB 4*4096kB 5*8192kB 0*16384kB = 72376kB
>> Swap cache: add 0, delete 0, find 0/0, race 0+0
>> Free swap  = 0kB
>> Total swap = 0kB
>> Free swap:            0kB
>> 32768 pages of RAM
>> 10403 reserved pages
>> 0 pages shared
>> 0 pages swap cached
> 
> The kernel is using 16MB pages for the linear mapping and, since its in 
> the same region, the sparse virtural memmap.  PS3 uses hotplug for all 
> most all of its memory.   In this case, its trying to allocate an 
> additional page to cover a new region of the memory map.   However, the 
> initial 128 MB is fragmented, we have 8 8M chunks but no 16MB ones.


Yes, I see this is the problem.

-Geoff


