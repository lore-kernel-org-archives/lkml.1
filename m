Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab0CKSrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:47:15 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58480 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922Ab0CKSrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:47:12 -0500
Message-ID: <4B993AAF.9050507@linux.vnet.ibm.com>
Date: Thu, 11 Mar 2010 10:47:11 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [PATCH 1/1] perf: add support for arch-dependent symbolic
 event names to "perf stat"
References: <4B8F1B58.5000702@linux.vnet.ibm.com> <4B8FFE55.5070008@linux.vnet.ibm.com> <20100311124608.GG31354@elte.hu>
In-Reply-To: <20100311124608.GG31354@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2010 4:46 AM, Ingo Molnar wrote:
[snip]
> If you want extensible events you can already do it by providing an ftrace
> tracepoint event via TRACE_EVENT. They are easy to add and ad-hoc, and are
> supported throughout by perf.

Is TRACE_EVENT an appropriate way to add hardware-specific counter events?  I 
will look into this.  Thanks for the pointer.

>
> That could be librarized further by providing an /eventfs or /proc/events
> interface to enumerate them.

We can enumerate events this way, but there are other aspects to events than 
just their names (see below).

>
> Or if you want to extend the perf events namespace ABI you can send patches
> for that as well. (It's not a big issue if a particular event is currently
> only supported on Power for example - as long as you make a good effort naming
> and structuring it in a reasonably generic way.)

I'm not sure how that would work.  The issue I am trying to solve here is that 
Power arch chips have a large number of very hardware-specific events that are 
not generalizable.  Many of these events not only have names, but other 
user-configurable bits as well that select or narrow the scope of which exact 
events are recorded.  This issue is dealt with nicely in libpfm4, as it has 
mechanisms for parsing event names and attributes (aka modifiers or unit masks), 
and then produces a usable config field for the perf_events_attr struct.

Should I take it from the above that you are completely against the idea of 
using an external library for hardware-specific event and attribute naming?

-- 
Regards,

- Corey

