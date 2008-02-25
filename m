Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYBYUa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYBYUa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbYBYUav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:30:51 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:35313 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbYBYUau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:30:50 -0500
Date: Mon, 25 Feb 2008 21:31:18 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: Re: Patch kernel: I have 8 Gbytes RAM,
 but why I can only allocate 2.8 Gbytes RAM for a single process?
In-reply-to: <998d0e4a0802250922p518ec043m1abae3a3a407be0f@mail.gmail.com>
To: "J.C. Pizarro" <jcpiza@gmail.com>
Cc: Ady Wicaksono <ady.wicaksono@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <47C32596.8010205@nets.rwth-aachen.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
X-IronPort-AV: E=Sophos;i="4.25,403,1199660400";   d="scan'208";a="32730481"
References: <2743ae110802242344s4406cd5eq3c5e8d0a6e69101b@mail.gmail.com>
 <998d0e4a0802250922p518ec043m1abae3a3a407be0f@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.C. Pizarro schrieb:
> 2008/2/25, Ady Wicaksono <ady.wicaksono@gmail.com>:
>> I have 8 Gbytes RAM, but why I can allocate 2.8 Gbytes RAM for a single process?
>>  How to patch kernel so I have more than 2.8 Gbytes limitation?
>>
>>  Kernel:
>>  ---------------------------
>>  Linux xxx.com 2.6.9-023stab046.2-enterprise #1 SMP Mon Dec 10 15:22:33
>>  MSK 2007 i686 i686 i386 GNU/Linux
>>
>>  Mem:
>>  ---------------------------
>>  # cat /proc/meminfo
>>  MemTotal:      8296484 kB
>>  MemFree:         50416 kB
>>  Buffers:         64412 kB
>>  Cached:        4927328 kB
>>  SwapCached:          0 kB
>>  Active:        6710828 kB
>>  Inactive:      1065384 kB
>>  HighTotal:     4980736 kB
>>  HighFree:         1024 kB
>>  LowTotal:      3315748 kB
>>  LowFree:         49392 kB
>>  SwapTotal:    10256376 kB
>>  SwapFree:     10255732 kB
>>  Dirty:              64 kB
>>  Writeback:           0 kB
>>  Mapped:        3054960 kB
>>  Slab:           393224 kB
>>  CommitLimit:  14404616 kB
>>  Committed_AS:  6318152 kB
>>  PageTables:      34892 kB
>>  VmallocTotal:   303096 kB
>>  VmallocUsed:     22360 kB
>>  VmallocChunk:   280496 kB
>>
>>
>>  CPU (8 processor id from 0-7), one of them is:
>>  ---------------------------
>>  processor       : 0
>>  vendor_id       : GenuineIntel
>>  cpu family      : 15
>>  model           : 6
>>  model name      : Intel(R) Xeon(TM) CPU 3.00GHz
>>  stepping        : 4
>>  cpu MHz         : 2993.054
>>  cache size      : 2048 KB
>>  physical id     : 0
>>  siblings        : 4
>>  core id         : 0
>>  cpu cores       : 2
>>  fdiv_bug        : no
>>  hlt_bug         : no
>>  f00f_bug        : no
>>  coma_bug        : no
>>  fpu             : yes
>>  fpu_exception   : yes
>>  cpuid level     : 6
>>  wp              : yes
>>  flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>>  mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
>>  lm constant_tsc pni monitor ds_cpl est cid xtpr
>>  bogomips        : 5989.55
>>
>>  App to test memory limit:
>>  ---------------------------
>>  #include <stdio.h>
>>  #include <stdlib.h>
>>
>>  int main(){
>>         size_t siz = 100 * 1024 * 1024 ;
>>         size_t idx = 1 ;
>>         void *ptr;
>>
>>         for (;;){
>>                 ptr = malloc ( siz * idx );
>>                 if(!ptr)
>>                         break ;
>>                 free(ptr);
>>                 idx++;
>>         }
>>         printf ("Max malloc %d * 100 MB \n", idx - 1 );
>>         return (0);
>>  }
>>
>>  App result: Max malloc 28 * 100 MB ==> 2.8 Gbytes
> 
> 1. It's a 32-bit processor Xeon with 8 GiB of RAM. OK?
No, its not. cpuinfo indicates that it understands 64 bit (X86_FEATURE_LM)

> 2. The 32-bit userspace's process is always limited to <3.0 GiB ( < 0xC0000000 )
Yep thats right.

> 3. Enable PAE (64 GB option in the kernel) to address the 8 GiB of RAM
> using PAE,
He did already enable it as indicated by /proc/meminfo...

>     also you can have many processes of ~3 GiB per process.
>     I'm not sure if the PAE's three-level paging works efficient in linux.
> 
>    ;)

I'm not sure either.

Best regard,
Arnd

