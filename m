Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbXKUCuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbXKUCuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 21:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbXKUCtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 21:49:53 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49157 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbXKUCtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 21:49:52 -0500
Message-Id: <47439CDB.4080004@mxs.nes.nec.co.jp>
Date: Wed, 21 Nov 2007 11:50:03 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: kexec-ml <kexec@lists.infradead.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] Fix the configuration dependencies
References: <473CFE14.3010400@mxs.nes.nec.co.jp>	<473D0170.1060304@mxs.nes.nec.co.jp> <20071116162511.GB2658@verge.net.au>
In-Reply-To: <20071116162511.GB2658@verge.net.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Simon,

Thank you for reviewing and your "Acked-by" signs.

Simon Horman wrote:
> On Fri, Nov 16, 2007 at 11:33:20AM +0900, Ken'ichi Ohmichi wrote:
>> This patch fixes the configuration dependencies in the vmcoreinfo data.
>>
>> i386's "node_data" is defined in arch/x86/mm/discontig_32.c,
>> and x86_64's one is defined in arch/x86/mm/numa_64.c.
>> They depend on CONFIG_NUMA:
>>   arch/x86/mm/Makefile_32:7
>>     obj-$(CONFIG_NUMA) += discontig_32.o
>>   arch/x86/mm/Makefile_64:7
>>     obj-$(CONFIG_NUMA) += numa_64.o
>>
>> ia64's "pgdat_list" is defined in arch/ia64/mm/discontig.c,
>> and it depends on CONFIG_DISCONTIGMEM and CONFIG_SPARSEMEM:
>>   arch/ia64/mm/Makefile:9-10
>>     obj-$(CONFIG_DISCONTIGMEM) += discontig.o
>>     obj-$(CONFIG_SPARSEMEM)    += discontig.o
>>
>> ia64's "node_memblk" is defined in arch/ia64/mm/numa.c,
>> and it depends on CONFIG_NUMA:
>>   arch/ia64/mm/Makefile:8
>>     obj-$(CONFIG_NUMA)         += numa.o
>>
>> Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
> 
> This appears correct to me, checking through the symbols and the
> location of their deffinitions, though I have not had a chance to run
> many build checks.
> 
> I also note that CONFIG_ARCH_DISCONTIGMEM_ENABLE does not even
> appear to exist on i386, so it looks that without this change
> the code in question whould never be enabled.

If you enable "Numa Memory Allocation and Scheduler Support" in i386's
menuconfig, CONFIG_ARCH_DISCONTIGMEM_ENABLE is enabled.


Thanks
Ken'ichi Ohmichi 

