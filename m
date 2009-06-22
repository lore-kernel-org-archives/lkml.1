Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbZFVWES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbZFVWES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZFVWEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:04:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42625 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZFVWEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:04:02 -0400
Message-ID: <4A3FFFD3.3090008@linux.vnet.ibm.com>
Date: Mon, 22 Jun 2009 15:04:03 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: eranian@gmail.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, cel@linux.vnet.ibm.com,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.2 - Grouping
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622115017.GC24366@elte.hu> <7c86c4470906221245m6b1c2bc5nb03e4f5730db6396@mail.gmail.com>
In-Reply-To: <7c86c4470906221245m6b1c2bc5nb03e4f5730db6396@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian wrote:
> On Mon, Jun 22, 2009 at 1:50 PM, Ingo Molnar<mingo@elte.hu> wrote:
>>> 2/ Grouping
>>>
>>> By design, an event can only be part of one group at a time.
> 
> As I read this again, another question came up. Is the statement
> above also true for the group leader?
> 
> 
>>> Events in a group are guaranteed to be active on the PMU at the
>>> same time. That means a group cannot have more events than there
>>> are available counters on the PMU. Tools may want to know the
>>> number of counters available in order to group their events
>>> accordingly, such that reliable ratios could be computed. It seems
>>> the only way to know this is by trial and error. This is not
>>> practical.
>> Groups are there to support heavily constrained PMUs, and for them
>> this is the only way, as there is no simple linear expression for
>> how many counters one can load on the PMU.
>>
> But then, does that mean that users need to be aware of constraints
> to form groups. Group are formed by users. I thought, the whole point
> of the API was to hide that kind of hardware complexity.
> 
> Groups are needed when sampling, e.g., PERF_SAMPLE_GROUP.
> For instance, I sample the IP and the values of the other events in
> my group.  Grouping looks like the only way to sampling on Itanium
> branch buffers (BTB), for instance. You program an event in a generic
> counter which counts the number of entries recorded in the buffer.
> Thus, to sample the BTB, you sample on this event, when it overflows
> you grab the content of the BTB. Here, the event and the BTB are tied
> together. You cannot count the event in one group, and have the BTB
> in another one (BTB = 1 config reg + 32 data registers + 1 position reg).
> 
> 
>

With getting these posts from several different sources, I missed Stephane's reply.

I can see the issue is deeper and more subtle than I had imagined.

Stephane, if you were to just place into groups those events which must be 
correlated, and just leave all of the others not grouped, wouldn't this solve 
the problem?  The kernel would be free to schedule the other events how and when 
it can, but would guarantee that your correlated events are on the PMU 
simultaneously.

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
cjashfor@us.ibm.com

