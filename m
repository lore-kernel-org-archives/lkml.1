Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbXEXXXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbXEXXXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbXEXXX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:23:28 -0400
Received: from omta03ps.mx.bigpond.com ([144.140.82.155]:35710 "EHLO
	omta03ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbXEXXX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:23:27 -0400
Message-ID: <46561E67.3030207@bigpond.net.au>
Date: Fri, 25 May 2007 09:23:19 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, colpatch@us.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>, Con Kolivas <kernel@kolivas.org>,
       Christoph Lameter <clameter@sgi.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <464A6698.3080400@bigpond.net.au> <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au> <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com> <46523081.6050007@bigpond.net.au> <465275EF.8060905@bigpond.net.au> <4652DC03.60801@bigpond.net.au> <4655423E.6000202@bigpond.net.au> <20070524164538.GA13301@linux-os.sc.intel.com>
In-Reply-To: <20070524164538.GA13301@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta03ps.mx.bigpond.com from [60.231.45.148] using ID pwil3058@bigpond.net.au at Thu, 24 May 2007 23:23:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> On Thu, May 24, 2007 at 12:43:58AM -0700, Peter Williams wrote:
>> Peter Williams wrote:
>>> The relevant code, find_busiest_group() and find_busiest_queue(), has a 
>>> lot of code that is ifdefed by CONFIG_SCHED_MC and CONFIG_SCHED_SMT and, 
>>> as these macros were defined in the kernels I was testing with, I built 
>>> a kernel with these macros undefined and reran my tests.  The 
>>> problems/anomalies were not present in 10 consecutive tests on this new 
>>> kernel.  Even better on the few occasions that a 3/1 split did occur it 
>>> was quickly corrected to 2/2 and top was reporting approx 49% of CPU for 
>>> all spinners throughout each of the ten tests.
>>>
>>> So all that is required now is an analysis of the code inside the ifdefs 
>>> to see why it is causing a problem.
>>
>> Further testing indicates that CONFIG_SCHED_MC is not implicated and
>> it's CONFIG_SCHED_SMT that's causing the problem.  This rules out the
>> code in find_busiest_group() as it is common to both macros.
>>
>> I think this makes the scheduling domain parameter values the most
>> likely cause of the problem.  I'm not very familiar with this code so 
>> I've added those who've modified this code in the last year or 
>> so to the 
>> address of this e-mail.
> 
> What platform is this? I remember you mentioned its a 2 cpu box. Is it
> dual core or dual package or one with HT?

It's a single CPU HT box i.e. 2 virtual CPUs.  "cat /proc/cpuinfo" produces:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 3
model name      : Intel(R) Pentium(R) 4 CPU 3.20GHz
stepping        : 4
cpu MHz         : 3201.145
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
constant_tsc pni monitor ds_cpl cid xtpr
bogomips        : 6403.97
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 3
model name      : Intel(R) Pentium(R) 4 CPU 3.20GHz
stepping        : 4
cpu MHz         : 3201.145
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
constant_tsc pni monitor ds_cpl cid xtpr
bogomips        : 6400.92
clflush size    : 64


Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
