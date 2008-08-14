Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbYHNRqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbYHNRqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYHNRqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:46:15 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:39766 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbYHNRqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:46:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAKUJpEhMRKxB/2dsb2JhbACBYrUXgVU
Date: Thu, 14 Aug 2008 13:46:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with
	preemptible kernel and CPU hotplug
Message-ID: <20080814174612.GB4697@Krystal>
References: <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A465BA.5050406@goop.org> <48A468F5.4050308@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A468F5.4050308@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:32:05 up 70 days, 22:12,  7 users,  load average: 0.25, 0.51,
	0.66
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Jeremy Fitzhardinge wrote:
>>> Xeon 2.0GHz
>>>
>>>
>>> Summary
>>>
>>>                   no lock prefix (s)   with lock prefix (s)    Speedup
>>> make -j1 kernel/      33.94 +/- 0.07         34.91 +/- 0.27      2.8 %
>>> hackbench 50           2.99 +/- 0.01          3.74 +/- 0.01     25.1 %
>>>   
>> Yeah, that's more severe than I would have expected.  Perhaps I have AMD 
>> numbers in my head.
>
> He doesn't specify what kind of Xeon it is (there are three completely 
> different CPUs under the Xeon brand name: P3 Xeon, P4 Xeon, and Core 2 
> Xeon), but I think it's a P4 Xeon.
>
> Netburst sucked in so many ways, and this is one of them.
>

Here are the specs. It's a brand new 64bits dual quad-core (Christmas in
August) :-) None of the specs seems to talk about neither Core2 or
Pentium 4 though. Those appellations seems to hold for desktop
processors, not server processors...

processor : 0
vendor_id : GenuineIntel
cpu family  : 6
model   : 23
model name  : Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
stepping  : 6
cpu MHz   : 2000.109
cache size  : 6144 KB
physical id : 0
siblings  : 1
core id   : 0
cpu cores : 1
apicid    : 0
initial apicid  : 0
fpu   : yes
fpu_exception : yes
cpuid level : 10
wp    : yes
flags   : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc up arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx
tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
bogomips  : 4000.21
clflush size  : 64
cache_alignment : 64
address sizes : 38 bits physical, 48 bits virtual
power management:


Booting processor 7/7 ip 6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 4000.26 BogoMIPS (lpj=8000538)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
CPU7: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#7]: passed.

Mathieu

> 	-hpa
>
>

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
