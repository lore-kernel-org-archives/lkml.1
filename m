Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbZF3Hdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbZF3Hdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 03:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZF3HdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 03:33:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:8468 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbZF3HdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 03:33:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,315,1243839600"; 
   d="scan'208";a="426438880"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Markus Metzger <markus.t.metzger@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 30 Jun 2009 08:32:45 +0100
Subject: bts & perf_counters
Thread-Topic: bts & perf_counters
Thread-Index: Acn49wicfM3R2CZmRBSVYnf20+xk7wAUyEpQ
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EBE519AE5@irsmsx504.ger.corp.intel.com>
References: <20090611214124.GA4133@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EBBC65961@irsmsx504.ger.corp.intel.com>
 <928CFBE8E7CB0040959E56B4EA41A77EBBD00DC5@irsmsx504.ger.corp.intel.com>
 <928CFBE8E7CB0040959E56B4EA41A77EBE2DB8EB@irsmsx504.ger.corp.intel.com>
 <20090624133645.GE6224@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EBE2DB9B9@irsmsx504.ger.corp.intel.com>
 <20090624153229.GA24346@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EBE2DC3D9@irsmsx504.ger.corp.intel.com>
 <20090626122948.GC10850@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EBE519869@irsmsx504.ger.corp.intel.com>
 <20090629202002.GF31577@elte.hu>
In-Reply-To: <20090629202002.GF31577@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: AfSj Anpa JKRj JaZb RPBo Xw8C aLeL aT3J fkWx jDT/ kvaR
 tuqB 0gP9 6fYE 6opM
 6/py;6;YQAuAHAALgB6AGkAagBsAHMAdAByAGEAQABjAGgAZQBsAGwAbwAuAG4AbAA7AGgAcABhAEAAegB5AHQAbwByAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbQBhAHIAawB1AHMALgB0AC4AbQBlAHQAegBnAGUAcgBAAGcAbwBvAGcAbABlAG0AYQBpAGwALgBjAG8AbQA7AG0AaQBuAGcAbwBAAGUAbAB0AGUALgBoAHUAOwB0AGcAbAB4AEAAbABpAG4AdQB0AHIAbwBuAGkAeAAuAGQAZQA=;Sosha1_v1;7;{4A549F92-E33B-4DB7-B087-7D2B56BF8A58};bQBhAHIAawB1AHMALgB0AC4AbQBlAHQAegBnAGUAcgBAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Tue,
 30 Jun 2009 07:32:45 GMT;YgB0AHMAIAAmACAAcABlAHIAZgBfAGMAbwB1AG4AdABlAHIAcwA=
x-cr-puzzleid: {4A549F92-E33B-4DB7-B087-7D2B56BF8A58}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Monday, June 29, 2009 10:20 PM
>To: Metzger, Markus T
>Cc: Thomas Gleixner; H. Peter Anvin; Peter Zijlstra; Markus Metzger
>Subject: Re: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"


>> Would you want to re-add klml when we're discussing technical
>> things?
>
>Sure - feel free to start new threads with lkml Cc:-ed.

[cc-ing lkml]


>> I looked at the user-mode code and a little bit at the kernel
>> code. I'm not yet finished but I already have a handful of
>> questions.
>>
>> In general, I think that it might indeed make sense to use the
>> perfcounter interface for branch tracing if we can clarify a few
>> open points.
>
>Note, i consider the BTS (and PEBS) use-case a primary future
>component of perfcounters, so 'clarify' can (and should) mean the
>changing of perfcounters to suit the BTS model better, when needed.

That sounds good. I hope it is not necessary in too many places.


>> Both perf-record and perf-top try to read the data while the
>> profiled process is running. They start at offset zero; if they
>> detect they're falling behind too much, they drop samples. This
>> requires that tracer and tracee run tightly interleaved or truly
>> in parallel - at least when the sampling intervals get smaller.
>
>The alternative is to use a larger buffer when needed. The default
>limit is 512K buffer per unprivileged user. Privileged or power
>users can have an mlock limit of a few megs easily.
>
>> What if they're behind from the very beginning, say, after the
>> first buffer overflow? Would they be able to detect that they're
>> reading nonsense data? Would it be possible to stop the traced
>> process to guarantee a full trace?
>
>The latest perfcounters code (already upstream as of .31-rc1)
>implements a 'precise' and 'reliable' eventing flow: the kernel
>never overwrites records but stops and increases a 'lost events'
>counter. User-space should never get 'nonsense' data and will always
>be able to get a measure of how good the data is.
>
>We could add a new attribute to 'struct perf_counter_attr' that puts
>the kernel into 'tail overwrite' mode.

That would improve things for profilers but it would not help branch
tracers, e.g. debuggers.

A debugger needs the tail of the trace. It needs it to be precise,
i.e. without holes. And the debugger needs to be able to reliably
identify the beginning of that tail in the event stream.


>> A debugger is interested in the tail of the execution trace. It
>> won't poll the trace data (which would be far too much overhead).
>> How would a user synchronize on the profile stream when the
>> profiled process is stopped?
>
>Yeah, with a new perf_attr flag that activates overwrite this
>usecase would be solved, right? The debugger has to make sure the
>task is stopped before reading out the buffer, but that's pretty
>much all.

I'm not sure about that. The way I read struct perf_counter_mmap_page,
data_head points to the end of the stream (I would guess one byte
beyond the last record).

I think we can ignore data_tail in the debug scenario since debuggers
won't poll. We can further assume a buffer overflow no matter how big
the ring buffer - branch trace grows terribly fast and we don't want
normal uses to lock megabytes of memory, do we?

How would a debugger find the beginning of the event stream to start
reading?


>The profile stream will be serialized by ptrace if ptrace is used to
>stop the task.

Are you saying that we need ptrace to make sure the profile stream is
completely filled before notifying the tracer?


>> The mmap buffer that is used by perf is rather big, i.e. 128
>> pages. Don't you need to lock that buffer? The mlock rlimit is 64
>> pages.
>
>perfcounters has a per user allowance beyond the mlock limit. This
>is one of the reasons why i think it's better for BTS to use this
>facility: you get 512K of 'free' locked space, and that is a pretty
>practical amount of buffering/execution-history already.


Hmmm, couldn't that allowance be implemented anywhere in the kernel?
In fact, should this allowance not be per-user instead of per-feature?

I do agree that 64k (not pages, sorry, my mistake) is not enough for
branch-tracing (or profiling) multi-threaded apps.


>> The way I understand tools/perf/design.txt, you collect the
>> profile for child tasks into the same ring buffer; you just add
>> the task's pid as part of the sampling data. Is this correct?
>>
>> That won't work very well for branch tracing. Since we're sampling
>> every single branch, the buffer grows very fast. The branch trace
>> of a single thread will likely evict the trace for all other
>> threads. A debugger, on the other hand, would need an equally long
>> tail for each thread.
>
>A debugger knows all the child tasks and can create counters in each
>of them. (or in any desired sub-set of tasks - according to debugger
>settings/policy)
>
>The 'all child task events go into the parent buffer' portion is
>only true if you use inherited counter (perf_attr.inherit == 1). For
>normal PID counters you can mmap a separate buffer for each task.


We would lose one of the big improvements that comes with using the
perf_counter framework, though.


>> We will face the same problem if we want to combine branch tracing
>> with profiling, or - and you should have this problem already
>> today - if we want to sample different data using significantly
>> different sampling intervals. If we use a single buffer to hold
>> the combined data, the data with the smallest sampling interval
>> will evict all other data from that buffer.
>
>Could you clarify this use-case a bit more please? The basic BTS
>model is to use BTS as a 'flight recorder', to be read out when the
>debugger wants it. That model has no notion of interval.
>
>How does 'interval' get mixed with BTS?


We could view BTS as event-based sampling with interval=1. The sample
we collect is the <from, to> address pair of an executed branch and
the sampling interval is 1, i.e. we store a sample for every branch.
Wouldn't this be how BTS integrates into perf_counters?


One of the big advantages that comes with using the perf_counter
framework is that you could mix branch tracing with other forms
of profiling and sampling.


>> Would it be possible for a user to profile the same task twice? He
>> could then use different buffers for different sampling intervals.
>
>It's possibe to open multiple counters to the same task, yes.


That's good. And users could mmap every counter they open in order
to get multiple perf event streams?


>> I looked at the kernel code under the aspect how we could
>> integrate branch tracing.
>>
>> For one, we would need a separate locked buffer to collect BTS
>> (and later PEBS) and we would need to copy the data when either
>> the buffer overflows or the traced task is scheduled out. Do you
>> have an idea how big this copy overhead would be? At least for
>> BTS, users would likely never look at most of the trace.
>
>The best model for BTS is to 'drain' all BTS entries in the DS area
>when the counter overflows or when the task schedules out.
>
>To 'drain' means shuffling the entries from the per CPU DS area into
>the per counter mmap area. This will be very fast on any reasonably
>modern CPU - the DS area is already in the cache and the mmap
>bufferng area will be write-allocated.


OK. The existing implementation reconfigured DS area to have the h/w
already collect the trace into the correct buffer. The only copying
that is ever needed is to copy it into user-space while translating
the arch-specific format into an arch-independent format.

This is obviously only possible for a single user. Copying the data
is definitely more flexible if we expect multiple users of that data
with different-sized buffers.


>> We would need to extend the format to add a BTS record and we
>> would need to change generic code to not expect a counter value.
>> While we could omit the from address and only store the to address
>> using existing functionality, user code would not have a way to
>> re-sync if they do not understand an instruction, so I'd rather
>> keep the <from, to> pair.
>
>How about reusing these two existing sampling formats:
>
> PERF_SAMPLE_IP
> PERF_SAMPLE_ADDR
>
>For example for page-faul events, 'IP' is the faulting RIP, 'ADDR'
>is the faulting linear address.
>
>For BTS, 'IP' would the 'from' RIP, 'ADDR' could be the 'to' RIP.
>
>I.e. if you set the counter to:
>
>	attr->sample_type |= PERF_SAMPLE_IP;
>	attr->sample_type |= PERF_SAMPLE_DATA
>
>You'd get both the from-RIP and the to-RIP, without any BTS specific
>format extensions. Existing tooling uses the IP samples so we could
>get a branch profile via 'perf report' out of box.


That sounds good.


>> Sampling does not need to write the counters when the profiled
>> task schedules out, but I guess that those hooks can be added
>> easily. We might need to schedule_work() the stuff, though, so a
>> ptracer might see changes to the tracee's buffer even if the
>> tracee is currently stopped. I'm not sure how much of a problem
>> this could be, since debuggers read the trace from back to front.
>
>If a task schedules out then it will have its DS area drained
>already to the mmap buffer - i.e. it's all properly synchronized.


When is that draining done? Somewhere in schedule()? Wouldn't that
be quite expensive for a few pages of BTS buffer?


>> That's it, for now. I think it makes sense to continue the
>> discussion some more before I actually start with any code
>> changes.
>
>I'm quite sure about the model - i'm more sure about it than about
>any of the ptrace based BTS variants before ... so i'd suggest you
>try to send me a 'minimally working' prototype ASAP (within a few
>days), so that we can productize this ASAP. If you send me something
>i will try to tidy it up for upstream reactivation of the BTS code.

Hmmm, I'll see what I can do. Please don't expect a minimally working
prototype to be bug-free from the beginning.

I see identifying the beginning of the stream as well as random
accesses into the stream as bigger open points.

Maybe we could add a mode where records are zero-extended to a fixed size.
This would leave the choice to the user: compact format or random access.


thanks and regards,
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

