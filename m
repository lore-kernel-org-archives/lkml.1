Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbZIIBgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbZIIBgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZIIBgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:36:22 -0400
Received: from nbd.name ([88.198.39.176]:36069 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbZIIBgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:36:21 -0400
Message-ID: <4AA70688.5000203@openwrt.org>
Date: Wed, 09 Sep 2009 03:36:08 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Michael Buesch <mb@bu3sch.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu> <20090908074825.GA11413@elte.hu> <1252403400.4950.81.camel@pasglop> <20090908130943.GA10637@linux-mips.org>
In-Reply-To: <20090908130943.GA10637@linux-mips.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
>> I remember at some stage we spotted an expensive multiply in there,
>> maybe there's something similar, or some unaligned or non-cache friendly
>> vs. the MIPS cache line size data structure, that sort of thing ...
>> 
>> Is this a SW loaded TLB ? Does it misses on kernel space ? That could
>> also be some differences in how many pages are touched by each scheduler
>> causing more TLB pressure. This will be mostly invisible on x86.
> 
> Software refilled.  No misses ever for kernel space or low-mem; think of
> it as low-mem and kernel executable living in a 512MB page that is mapped
> by a mechanism outside the TLB.  Vmalloc ranges are TLB mapped.  Ioremap
> address ranges only if above physical address 512MB.
> 
> An emulated unaligned load/store is very expensive; one that is encoded
> properly by GCC for __attribute__((packed)) is only 1 cycle and 1
> instruction ( = 4 bytes) extra.
CFS definitely isn't causing any emulated unaligned load/stores on these
devices, we've tested that.

- Felix
