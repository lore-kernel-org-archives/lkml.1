Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbYFDKBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbYFDKBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbYFDKA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:00:59 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:50472 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbYFDKA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:00:58 -0400
Message-ID: <48466745.5050802@cfl.rr.com>
Date: Wed, 04 Jun 2008 05:58:29 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Oeser <ioe-lkml@rameria.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Max Krasnyansky <maxk@qualcomm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com> <200806030035.58387.ioe-lkml@rameria.de> <1212446707.6269.26.camel@lappy.programming.kicks-ass.net> <200806031603.40731.nickpiggin@yahoo.com.au>
In-Reply-To: <200806031603.40731.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 03 June 2008 08:45, Peter Zijlstra wrote:
>> On Tue, 2008-06-03 at 00:35 +0200, Ingo Oeser wrote:
>>> Hi Paul,
>>>
>>> in short: NAK!
>>>
>>> On Monday 02 June 2008, Paul Jackson wrote:
>>>> (Aside to the RealTime folks -- is there a 'realtime'
>>>> email list which I should include in this discussion?)
>>>>
>>>> The kernel has a "isolcpus=" kernel boot time parameter.  This
>>>> parameter isolates CPUs from scheduler load balancing, minimizing the
>>>> impact of scheduler latencies on realtime tasks running on those CPUs.
>>> I used it to mask out a defect CPU on a 8-CPU node of a
>>> HPC-cluster at a customer site, until the $BIG_VENDOR
>>> sent a replacement. And to prove $BIG_VENDOR, that we actually
>>> have a problem on THAT CPU.
>>>
>>> So I would really like to keep this fault isolation capability.
>>> I made my customer happy with that.
>>>
>>> I wish Linux had more such "mask out bad hardware" features
>>> to faciliate fault isolation and boot and runtime.
>> Yeah - except that its not meant to be used as such - it will still
>> brings the cpu up, and it is still usable for the OS.
>>
>> So sorry, your abuse doesn't make for a case to keep this abomination.
> 
> How come it is an abonination? It is an easy way to do what it does,
> and it's actually not a bad thing for some uses not to have to use
> cpusets.
> 
> Given that it's all __init code anyway, is there a real reason _to_
> remove it?

IMHO,

What is an abonination, is that cpusets are equired for this type of 
isolation to begin with, even on a 2 processor machine.

I would like the option to stay and be extended like Max originally
proposed. If cpusets/hotplug are configured isolation would be obtained 
using them. If not then isolcpus could be used to get the same isolation.

 From a user land point of view, I just want an easy way to fully 
isolate a particular cpu. Even a new syscall or extension to 
sched_setaffinity would make me happy. Cpusets and hotplug don't.

Again this is just MHO.

Regards
Mark

