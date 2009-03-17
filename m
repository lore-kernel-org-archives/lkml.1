Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbZCQM6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbZCQM6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbZCQM6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:58:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:6248 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbZCQM6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:58:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,378,1233561600"; 
   d="scan'208";a="395160899"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Tue, 17 Mar 2009 12:57:39 +0000
Subject: RE: [patch 1/5] x86, bts: detect size of DS fields
Thread-Topic: [patch 1/5] x86, bts: detect size of DS fields
Thread-Index: Acmm/NOiijrhTk/gSoehVHQcmoTHDAAAEWlw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E4A6642C7@irsmsx504.ger.corp.intel.com>
References: <20090313104218.A30096@sedona.ch.intel.com>
 <20090313110357.GC31094@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77E4A663C47@irsmsx504.ger.corp.intel.com>
 <20090317105558.GK6477@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77E4A664285@irsmsx504.ger.corp.intel.com>
 <20090317123442.GB22759@elte.hu>
In-Reply-To: <20090317123442.GB22759@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: AZr2 EyUD Y6rN nwMq qXqK qjtp rmfF 2Bed 2I0p +5N5
 AABBrA== ABAgHw== ABvBLQ== AB8inw== ADzl4Q==
 AJdPcA==;9;YQBrAEAAbABpAG4AdQB4AC4AagBmAC4AaQBuAHQAZQBsAC4AYwBvAG0AOwBlAHIAYQBuAGkAYQBuAEAAZwBvAG8AZwBsAGUAbQBhAGkAbAAuAGMAbwBtADsAaABwAGEAQAB6AHkAdABvAHIALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGEAcgBrAHUAcwAuAHQALgBtAGUAdAB6AGcAZQByAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBtAGkAbgBnAG8AQABlAGwAdABlAC4AaAB1ADsAbwBsAGUAZwBAAHIAZQBkAGgAYQB0AC4AYwBvAG0AOwByAG8AbABhAG4AZABAAHIAZQBkAGgAYQB0AC4AYwBvAG0AOwB0AGcAbAB4AEAAbABpAG4AdQB0AHIAbwBuAGkAeAAuAGQAZQA=;Sosha1_v1;7;{44E790CA-160B-4DCD-B339-388149263F37};bQBhAHIAawB1AHMALgB0AC4AbQBlAHQAegBnAGUAcgBAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Tue,
 17 Mar 2009 12:57:39
 GMT;UgBFADoAIABbAHAAYQB0AGMAaAAgADEALwA1AF0AIAB4ADgANgAsACAAYgB0AHMAOgAgAGQAZQB0AGUAYwB0ACAAcwBpAHoAZQAgAG8AZgAgAEQAUwAgAGYAaQBlAGwAZABzAA==
x-cr-puzzleid: {44E790CA-160B-4DCD-B339-388149263F37}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Tuesday, March 17, 2009 1:35 PM
>To: Metzger, Markus T

>> I think I found the problem:
>>   ds_request_bts() needs to allocate a small amount of memory.
>>   It uses GFP_KERNEL.
>>
>> Hw-branch-tracer essentially does on_each_cpu(ds_request_bts()).
>>
>> Since ds_request_bts() is meant to be called on the cpu that
>> should be traced, it should use GFP_ATOMIC to allow calls from
>> smp_call_function() and friends.
>>
>> Would that be acceptable?
>
>That's not really a good solution - GFP_ATOMIC is not a reliable
>form of allocation.

In that case, I would need to double the interface. So far, I used
task == NULL to indicate tracing on the current cpu. I could turn
this into:
  ds_request_bts_task(struct task_struct *task, ....) and
  ds_request_bts_cpu(int cpu, ....)

This way, I could do the allocation using GFP_KERNEL and then
do the wrmsrl() to enable tracing using smp_call_function().

Does that sound better?


>the other callsites are buggy too:
>
>                smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
>
>done under the bts_tracer_lock in addition to an atomic IPI
>context.

That lock synchronizes the on_each_cpu initialization calls with the
hotplug handler.
The for_each_online_cpu iteration in smp_call_function_many() may
race with the smp_call_function_single() when a new cpu arrives or
departs.



>for_each_online_cpu() done under the mutex would be better i
>guess, plus you can allocate any memory before you do the SMP
>cross-call, and pass it to the IPI handler via the data
>parameter. (NULL in the sequence above)

The memory is allocated by ds_request_bts(). It holds the tracer
struct returned to the caller. The struct is private to ds.c.


regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

