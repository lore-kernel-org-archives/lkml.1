Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0CLGyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 01:54:00 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41479 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0CLGx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 01:53:58 -0500
Message-ID: <4B99E502.1070204@linux.vnet.ibm.com>
Date: Thu, 11 Mar 2010 22:53:54 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [PATCH 1/1] perf: add support for arch-dependent symbolic
 event names to "perf stat"
References: <4B8F1B58.5000702@linux.vnet.ibm.com> <4B8FFE55.5070008@linux.vnet.ibm.com> <20100311124608.GG31354@elte.hu> <20100312024100.GA2734@brick.ozlabs.ibm.com>
In-Reply-To: <20100312024100.GA2734@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 06:41 PM, Paul Mackerras wrote:
> On Thu, Mar 11, 2010 at 01:46:08PM +0100, Ingo Molnar wrote:
>>
>> * Corey Ashford<cjashfor@linux.vnet.ibm.com>  wrote:
>>
>>> On 3/3/2010 6:30 PM, Corey Ashford wrote:
>>>> For your review, this patch adds support for arch-dependent symbolic
>>>> event names to the "perf stat" tool, and could be expanded to other
>>>> "perf *" commands fairly easily, I suspect.
>
>> I'm quite much against stop-gap measures like this - they tend to become
>> tomorrow's impossible-to-remove quirk.
>>
>> If you want extensible events you can already do it by providing an ftrace
>> tracepoint event via TRACE_EVENT. They are easy to add and ad-hoc, and are
>> supported throughout by perf.
>
> If I've understood correctly what Corey is doing, I think you're
> missing the point.  The idea, I thought, was to provide a way to be
> able to use symbolic names for raw hardware events rather than just
> numbers.

Yes, that's what I meant.

 > I don't see how ftrace tracepoint events are relevant to
 > that.
>
> Now as to whether an external .so is the best way to provide the
> processor-specific mapping of names to raw events, I'm not sure.
> If the kernel can provide that mapping via procfs, sysfs or eventfs,
> that would be an alternative, but it does mean the kernel has those
> tables in unswappable memory (and potentially the tables for all the
> processors that the kernel supports), which seems unnecessary.  Or
> they can just be added to the perf source code.

In addition to the names and attributes, we'd also need text-based 
descriptions of the events and attributes.

I'm not opposed to the idea of placing them in sysfs (or other pseudo 
fs), but it's also not clear to me how to represent the event data in a 
clean, extensible, and space/performance efficient way.  That said, I do 
like the idea of being able to navigate events by looking through a 
directory structure which is possibly organized by the physical topology 
of the system and its PMUs.

- Corey


