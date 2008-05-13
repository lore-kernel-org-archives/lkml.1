Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbYEMVUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbYEMVUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759518AbYEMVTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:19:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44845 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164AbYEMVTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:19:50 -0400
Message-ID: <482A05F3.7020408@firstfloor.org>
Date: Tue, 13 May 2008 23:19:47 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       =?UTF-8?B?IlMuw4dhxJ9sYXIgT251ciI=?= <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
References: <20080513204206.GA17781@damson.getinternet.no>	 <873aol9b73.fsf@basil.nowhere.org> <19f34abd0805131409w2914fbedgb608c7b87c234e2e@mail.gmail.com>
In-Reply-To: <19f34abd0805131409w2914fbedgb608c7b87c234e2e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The desktop is a P4:
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 6
> model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> stepping        : 5
> cpu MHz         : 2992.624
> cache size      : 2048 KB

> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> lm constant_tsc pebs bts pni monitor ds_cpl est tm2 cid cx16 xtpr
> lahf_lm
> bogomips        : 5990.81
> clflush size    : 64
> 
> (similar for processor 1)
> 
> # msr
> 0

Ok the CPU reports it doesn't support any C states in MWAIT. If that is
correct then it would be correct to not use MWAIT idle and might
actually save more power to not use it.

I don't know if that's true or not. Do you have a power meter perhaps?
If yes can you measure if there's a difference between mwait=idle /
default on your box when it is idle?

[cc Arjan he might now if that CPU is supposed to support C1 in MWAIT]

> 
> The laptop is a Pentium Dual-Core:
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Pentium(R) Dual  CPU  T2310  @ 1.46GHz
> stepping        : 13
> cpu MHz         : 800.000
> cache size      : 1024 KB
...
> flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
> constant_tsc arch_perfmon pebs bts pni monitor ds_cpl est tm2 ssse3
> cx16 xtpr lahf_lm
> bogomips        : 2930.23
> clflush size    : 64
> 
> (similar for processor 1)
> 
> # ./msr
> 1110

CPU reports it supports C1/C2/C3. Are you sure there is a difference on
that box? The code should have kept using MWAIT because it checks C1.
Please double check.

-Andi

