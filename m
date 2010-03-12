Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0CLClK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 21:41:10 -0500
Received: from ozlabs.org ([203.10.76.45]:54179 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab0CLClI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 21:41:08 -0500
Date: Fri, 12 Mar 2010 13:41:00 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [PATCH 1/1] perf: add support for arch-dependent
 symbolic event names to "perf stat"
Message-ID: <20100312024100.GA2734@brick.ozlabs.ibm.com>
References: <4B8F1B58.5000702@linux.vnet.ibm.com>
 <4B8FFE55.5070008@linux.vnet.ibm.com>
 <20100311124608.GG31354@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311124608.GG31354@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 01:46:08PM +0100, Ingo Molnar wrote:
> 
> * Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> 
> > On 3/3/2010 6:30 PM, Corey Ashford wrote:
> > >For your review, this patch adds support for arch-dependent symbolic
> > >event names to the "perf stat" tool, and could be expanded to other
> > >"perf *" commands fairly easily, I suspect.

> I'm quite much against stop-gap measures like this - they tend to become 
> tomorrow's impossible-to-remove quirk.
> 
> If you want extensible events you can already do it by providing an ftrace 
> tracepoint event via TRACE_EVENT. They are easy to add and ad-hoc, and are 
> supported throughout by perf.

If I've understood correctly what Corey is doing, I think you're
missing the point.  The idea, I thought, was to provide a way to be
able to use symbolic names for raw hardware events rather than just
numbers.  I don't see how ftrace tracepoint events are relevant to
that.

Now as to whether an external .so is the best way to provide the
processor-specific mapping of names to raw events, I'm not sure.
If the kernel can provide that mapping via procfs, sysfs or eventfs,
that would be an alternative, but it does mean the kernel has those
tables in unswappable memory (and potentially the tables for all the
processors that the kernel supports), which seems unnecessary.  Or
they can just be added to the perf source code.

Paul.
