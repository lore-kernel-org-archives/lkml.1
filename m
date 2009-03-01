Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZCAIgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZCAIgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 03:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZCAIgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 03:36:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60393 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbZCAIgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 03:36:40 -0500
Date: Sun, 1 Mar 2009 09:36:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [git-pull -tip] x86: Basic AMD Support for performance counters
Message-ID: <20090301083616.GA1742@elte.hu>
References: <1235756278.3914.9.camel@localhost.localdomain> <20090228094018.GF12095@elte.hu> <20090228134434.GA32473@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228134434.GA32473@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Seems to be working fine, here's the output from an Athlon 64 
> 3200+ (Sempron) box:
> 
>  Performance counter stats for 'ls':
> 
>       17.420811  task clock ticks     (msecs)
> 
>               0  CPU migrations       (events)
>              12  context switches     (events)
>             583  pagefaults           (events)
>        29760299  CPU cycles           (events)
>        29401642  instructions         (events)
>        12698498  cache references     (events)
>           66269  cache misses         (events)
> 
>  Wall-clock time elapsed:   687.999988 msecs

The patches cause a crash on another system - an Opteron system 
spontaneous reboots at this point during early bootup:

CPU 0/0x4 -> Node 0
tseg: 00cfe00000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
AMD Performance Monitoring support detected.
... num counters:    4
... value mask:      0000000000000000
... fixed counters:  0
... counter mask:    000000000000000f
ACPI: Core revision 20081204
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 16365 entries in 129 pages
Setting APIC routing to physical flat
masked ExtINT on CPU#0
ENABLING IO
[reboot]

this is the CPU type:

processor	: 15
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 2
model name	: Quad-Core AMD Opteron(tm) Processor 8356
stepping	: 3
cpu MHz		: 2300.000
cache size	: 512 KB
physical id	: 4
siblings	: 4
core id		: 3
cpu cores	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep 
mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall 
nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc 
rep_good pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic 
cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs
bogomips	: 4622.47
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

	Ingo
