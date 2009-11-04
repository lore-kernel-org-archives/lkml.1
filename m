Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZKDKZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZKDKZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 05:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZKDKZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 05:25:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56729 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbZKDKZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 05:25:13 -0500
Date: Wed, 4 Nov 2009 11:24:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
Message-ID: <20091104102436.GB15086@elte.hu>
References: <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com> <4AEEBE65.3070202@linux.intel.com> <4AEF3143.2030701@sgi.com> <20091102193445.GA9948@elte.hu> <4AEF41C5.6010503@sgi.com> <4AF0C958.6010103@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF0C958.6010103@sgi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

>
> ...
>>> So please go with the simple solution i suggested days ago: print  
>>> stuff on the boot CPU but after that only a single line per AP CPU.
>>>
>>>     Ingo
>>
>
> Hi Ingo,
>
> Here is some timing info I collected...  Would you accept the first
> format (line per node) as a compromise?
>
> (Note there will be 256 node systems w/4096 threads as well as
> 512 node systems w/HT disabled thus still 4096 threads.)
>
> Btw, I think we should keep the processor summary as it does show some
> useful information.  Agreed?  
>
> (... I'll clean up the BogoMIPS line a bit:
>
> 	BogoMIPS(lpj):  MIN xxx (yyy)   AVG xxx (yyy)   MAX xxx (yyy)
> ...)
>
> Thanks,
> Mike
>
> 64 Nodes/512 cores/1024 threads...
>
> By Node:
>  1 [   27.998414] Booting Node   0, Processors 1-7,512-519
>  2 [   28.645066] Booting Node   1, Processors 8-15,520-527
>  3 [   29.389359] Booting Node   2, Processors 16-23,528-535
>  4 [   30.160646] Booting Node   3, Processors 24-31,536-543
> ...
> 62 [   75.013459] Booting Node  61, Processors 488-495,1000-1007
> 63 [   75.789663] Booting Node  62, Processors 496-503,1008-1015
> 64 [   76.565430] Booting Node  63, Processors 504-511,1016-1023
> 65 [  126.860204] Brought up 1024 CPUs

Yeah, this portion certainly looks good. The important thing is to make 
this the default - i.e. we dont want some weird switch (or other hw 
dependent flaggery) to turn on two styles of bootup output.

We have trouble keeping a single variant sane already, we definitely 
dont want to have multiple variants.

> 66 [  126.865392] Summary Processor Information for CPUS: 0-143,256-383,448-655,768-895,960-1023
> 67 [  126.876033] Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 04
> 68 [  126.881404] BogoMIPS: MIN 3980.53 MAX 4268.28 AVG 4265.85
> 69 [  126.888032] Loops/Jiffy: MIN 7961074 MAX 8536570 AVG 8531701
> 70 [  126.896875] Summary Processor Information for CPUS: 144-239,384-447,656-751,896-959
> 71 [  126.904032] Intel(R) Xeon(R) CPU           X7560  @ 2.27GHz stepping 05
> 72 [  126.913404] BogoMIPS: MIN 4528.51 MAX 4762.75 AVG 4535.89
> 73 [  126.920032] Loops/Jiffy: MIN 9057030 MAX 9525505 AVG 9071785
> 74 [  126.924217] Summary Processor Information for CPUS: 240-255,752-767
> 75 [  126.932032] Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 03
> 76 [  126.937404] BogoMIPS: MIN 4267.31 MAX 4268.24 AVG 4267.66
> 77 [  126.944032] Loops/Jiffy: MIN 8534632 MAX 8536490 AVG 8535338
> 78 [  126.952425] Total of 1024 processors activated (4454702.72 BogoMIPS).

4.4 million bogomips. Nice ;-)

>
> By CPU:
>   1 [   28.010255] Booting Processor 1 APIC 0x2 ip 0x6000
>   2 [   28.106191] Booting Processor 2 APIC 0x4 ip 0x6000
>   3 [   28.204705] Booting Processor 3 APIC 0x6 ip 0x6000
>   4 [   28.300709] Booting Processor 4 APIC 0x10 ip 0x6000
>   5 [   28.400707] Booting Processor 5 APIC 0x12 ip 0x6000
> ...
> 1020 [  131.440341] Booting Processor 1020 APIC 0x7f1 ip 0x6000
> 1021 [  131.544366] Booting Processor 1021 APIC 0x7f3 ip 0x6000
> 1022 [  131.648354] Booting Processor 1022 APIC 0x7f5 ip 0x6000
> 1023 [  131.752350] Booting Processor 1023 APIC 0x7f7 ip 0x6000
> 1024 [  131.852202] Brought up 1024 CPUs

i'd suggest some cleanups to this single line output.

The 'ip' printout is very lame an comes from ancient times, from our 
first attempts to boot Linux in SMP mode on dual 100 MHz pentia ;-)

Something like:

        Booting CPU #1020 ... ok.

Would be more than enough. Any other info can be made a debug boot flag, 
dependent on apic=verbose.

Please send a new iteration of the arch/x86 (and scheduler/timer) 
patches in a separate series instead of mixed into this thread.

Thanks,

	Ingo
