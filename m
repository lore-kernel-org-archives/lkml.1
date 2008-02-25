Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbYBYU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbYBYU4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbYBYU4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:56:10 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:56805 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbYBYU4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:56:09 -0500
Message-ID: <1a9da18c0802251256u64636505y9f04af8a121ab766@mail.gmail.com>
Date: Mon, 25 Feb 2008 12:56:01 -0800
From: "=?UTF-8?Q?Masoud_Sharbiani?=
	=?UTF-8?Q?_\"=D9=85=D8=B3=D8=B9=D9=88=D8=AF_?=
	=?UTF-8?Q?=D8=B4=D8=B1=D8=A8=DB=8C=D8=A7=D9=86=DB=8C\"?=" 
	<masouds@masoud.ir>
To: "Ady Wicaksono" <ady.wicaksono@gmail.com>
Subject: Re: Patch kernel: I have 8 Gbytes RAM, but why I can only allocate 2.8 Gbytes RAM for a single process?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2743ae110802242344s4406cd5eq3c5e8d0a6e69101b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2743ae110802242344s4406cd5eq3c5e8d0a6e69101b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/08, Ady Wicaksono <ady.wicaksono@gmail.com> wrote:
> I have 8 Gbytes RAM, but why I can allocate 2.8 Gbytes RAM for a single process?
>  How to patch kernel so I have more than 2.8 Gbytes limitation?
>
>  Kernel:
>  ---------------------------
>  Linux xxx.com 2.6.9-023stab046.2-enterprise #1 SMP Mon Dec 10 15:22:33
>  MSK 2007 i686 i686 i386 GNU/Linux

You really need to use 64 bit kernel AND 64 bit userspace to use more
than 3gigs per process.

Masoud

>  Mem:
>  ---------------------------
>  # cat /proc/meminfo
>  MemTotal:      8296484 kB
>  MemFree:         50416 kB
>  Buffers:         64412 kB
>  Cached:        4927328 kB
>  SwapCached:          0 kB
>  Active:        6710828 kB
>  Inactive:      1065384 kB
>  HighTotal:     4980736 kB
>  HighFree:         1024 kB
>  LowTotal:      3315748 kB
>  LowFree:         49392 kB
>  SwapTotal:    10256376 kB
>  SwapFree:     10255732 kB
>  Dirty:              64 kB
>  Writeback:           0 kB
>  Mapped:        3054960 kB
>  Slab:           393224 kB
>  CommitLimit:  14404616 kB
>  Committed_AS:  6318152 kB
>  PageTables:      34892 kB
>  VmallocTotal:   303096 kB
>  VmallocUsed:     22360 kB
>  VmallocChunk:   280496 kB
>
>
>  CPU (8 processor id from 0-7), one of them is:
>  ---------------------------
>  processor       : 0
>  vendor_id       : GenuineIntel
>  cpu family      : 15
>  model           : 6
>  model name      : Intel(R) Xeon(TM) CPU 3.00GHz
>  stepping        : 4
>  cpu MHz         : 2993.054
>  cache size      : 2048 KB
>  physical id     : 0
>  siblings        : 4
>  core id         : 0
>  cpu cores       : 2
>  fdiv_bug        : no
>  hlt_bug         : no
>  f00f_bug        : no
>  coma_bug        : no
>  fpu             : yes
>  fpu_exception   : yes
>  cpuid level     : 6
>  wp              : yes
>  flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>  mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
>  lm constant_tsc pni monitor ds_cpl est cid xtpr
>  bogomips        : 5989.55
>
>  App to test memory limit:
>  ---------------------------
>  #include <stdio.h>
>  #include <stdlib.h>
>
>  int main(){
>         size_t siz = 100 * 1024 * 1024 ;
>         size_t idx = 1 ;
>         void *ptr;
>
>         for (;;){
>                 ptr = malloc ( siz * idx );
>                 if(!ptr)
>                         break ;
>                 free(ptr);
>                 idx++;
>         }
>         printf ("Max malloc %d * 100 MB \n", idx - 1 );
>         return (0);
>  }
>
>  App result: Max malloc 28 * 100 MB ==> 2.8 Gbytes
>
>
>  --
>  Regards,
>
>  Ady Wicaksono
>  Email:
>  ady.wicaksono at gmail.com
>  http://adywicaksono.wordpress.com/
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
