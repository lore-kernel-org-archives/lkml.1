Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYHNR3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYHNR3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYHNR3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:29:04 -0400
Received: from gw.goop.org ([64.81.55.164]:33992 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYHNR3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:29:01 -0400
Message-ID: <48A46B41.5000409@goop.org>
Date: Thu, 14 Aug 2008 10:28:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>,
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
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with	preemptible
 kernel and CPU hotplug
References: <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A465BA.5050406@goop.org> <48A468F5.4050308@zytor.com>
In-Reply-To: <48A468F5.4050308@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>>
>>> Xeon 2.0GHz
>>>
>>>
>>> Summary
>>>
>>>                   no lock prefix (s)   with lock prefix (s)    Speedup
>>> make -j1 kernel/      33.94 +/- 0.07         34.91 +/- 0.27      2.8 %
>>> hackbench 50           2.99 +/- 0.01          3.74 +/- 0.01     25.1 %
>>>   
>>
>> Yeah, that's more severe than I would have expected.  Perhaps I have 
>> AMD numbers in my head.
>>
>
> He doesn't specify what kind of Xeon it is (there are three completely 
> different CPUs under the Xeon brand name: P3 Xeon, P4 Xeon, and Core 2 
> Xeon), but I think it's a P4 Xeon.
>
> Netburst sucked in so many ways, and this is one of them.

I presume it's this one:
> Xeon cpuinfo :
>
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 23
> model name	: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
> stepping	: 6
> cpu MHz		: 2000.126
> cache size	: 6144 KB
> physical id	: 0
> siblings	: 4
> core id		: 0
> cpu cores	: 4
> apicid		: 0
> initial apicid	: 0
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
> bogomips	: 4000.25
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 38 bits physical, 48 bits virtual
> power management:

I've given up trying to remember what "E5405" might mean, but that 
feature list suggests a relatively modern microarchitecture.


    J
