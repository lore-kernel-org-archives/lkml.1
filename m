Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYHXIoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYHXIoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 04:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYHXIoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 04:44:03 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:59391 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYHXIoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 04:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rpfwnoE+efdb0CpTk+rr2hRfZvnF0MO6dheSE3TFyknrxq94+BE8F8erKvHtpemw2J
         mttMIVF1NzDvsoDc5gMR9i/LUVp3bzM0ClLmGvV4avXEyAh4pbcQPFNt/tl57B4iAvBV
         veG2eLFBWh9w2kc3nCO0iGojlp30Jbtv3wGsE=
Message-ID: <19f34abd0808240143y10b143c6s6f2b6753490d652f@mail.gmail.com>
Date: Sun, 24 Aug 2008 10:43:59 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: 9a2d43b: __alloc_bootmem_core(): zero-sized request
Cc: "Johannes Weiner" <hannes@saeurebad.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440808240122r64ac91beu68e7782d5056bbb3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808221224s4674e5aaq34bd0a874dfba699@mail.gmail.com>
	 <87myj4yzll.fsf@skyscraper.fehenstaub.lan>
	 <19f34abd0808240058h3d286151x18cba0939f175edd@mail.gmail.com>
	 <86802c440808240122r64ac91beu68e7782d5056bbb3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 10:22 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> nr_kernel_pages = 13869392367443771392
>>
>> ...it looks very, very big. I think this is initialized via
>> free_area_init_*() functions, which come from arch code. Does x86
>> experts know if any of this changed recently (i.e. after July 15)?
>>
>> The whole dmesg and config can be seen here:
>> http://userweb.kernel.org/~vegard/bugs/20080824-numa/
>>
>
> seems something wrong about apic probe...
>
> MPTABLE: OEM ID: Intel    Product ID: Lakeport     Warning!  May not
> be a NUMA-Q system!

It is not a NUMA-Q system, it's a normal desktop-class Pentium 4
machine with HT. But still, this kernel is expected to work, isn't it?
(At least expected to tell me "cannot boot" instead of giving
unexplainable errors.)

> MPTABLE: Product ID: Lakeport     <6>MPTABLE: APIC at: 0xFEE00000
> Processor #0 15:6 APIC version 20 (quad 0, apic 1)
> Processor #0 (Bootup-CPU)
> Bus #0 is PCI    (node 0)
> Bus #1 is PCI    (node 0)
> Bus #2 is PCI    (node 0)
> Bus #3 is ISA    (node 0)
> I/O APIC #2 Version 32 at 0xFEC00000.
> Enabling APIC mode:  NUMA-Q.  Using 1 I/O APICs
>
>
> please check with tip/master to see if it is fixed already...

Yes, the v2.6.27-rc4 boots fine. I was wondering if you knew that this
problem had occurred in the past (and if so, which commits I can
cherry-pick to fix it). But I guess there is not much to do. It is
also hard to test this same config with newer kernels, because
something in the Kconfig changed in an incompatible way (e.g. NUMAQ
setting changes when I change kernel versions).

Unless anybody can think of something, I think I will leave this
problem alone. It's an older version after all. Thanks for looking at
it! :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
