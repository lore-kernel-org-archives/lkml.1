Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0CKTPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:15:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51978 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab0CKTO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:14:58 -0500
Date: Thu, 11 Mar 2010 20:14:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [PATCH 1/1] perf: add support for arch-dependent symbolic
 event names to "perf stat"
Message-ID: <20100311191441.GA7593@elte.hu>
References: <4B8F1B58.5000702@linux.vnet.ibm.com>
 <4B8FFE55.5070008@linux.vnet.ibm.com>
 <20100311124608.GG31354@elte.hu>
 <4B993AAF.9050507@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B993AAF.9050507@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> On 3/11/2010 4:46 AM, Ingo Molnar wrote:
> [snip]
> >If you want extensible events you can already do it by providing an ftrace
> >tracepoint event via TRACE_EVENT. They are easy to add and ad-hoc, and are
> >supported throughout by perf.
> 
> Is TRACE_EVENT an appropriate way to add hardware-specific counter
> events?  I will look into this.  Thanks for the pointer.
> 
> >
> >That could be librarized further by providing an /eventfs or /proc/events
> >interface to enumerate them.
> 
> We can enumerate events this way, but there are other aspects to
> events than just their names (see below).
> 
> >
> >Or if you want to extend the perf events namespace ABI you can send patches
> >for that as well. (It's not a big issue if a particular event is currently
> >only supported on Power for example - as long as you make a good effort naming
> >and structuring it in a reasonably generic way.)
> 
> I'm not sure how that would work.  The issue I am trying to solve
> here is that Power arch chips have a large number of very
> hardware-specific events that are not generalizable.  Many of these
> events not only have names, but other user-configurable bits as well
> that select or narrow the scope of which exact events are recorded.
> This issue is dealt with nicely in libpfm4, as it has mechanisms for
> parsing event names and attributes (aka modifiers or unit masks),
> and then produces a usable config field for the perf_events_attr
> struct.
> 
> Should I take it from the above that you are completely against the
> idea of using an external library for hardware-specific event and
> attribute naming?

Could you give a few relevant examples of events in question, and the kind of 
configurability/attributes they have on Power?

Thanks,

	Ingo
