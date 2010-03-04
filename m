Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0CDPzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:55:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62545 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab0CDPzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:55:39 -0500
X-Authority-Analysis: v=1.0 c=1 a=JmiDjSKT-SYA:10 a=7U3hwN5JcxgA:10 a=8d6VPHx2p93kJCR7aSwA:9 a=ienCycG46pfz8r4UL8YFLSoKL3gA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
 events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Greg KH <greg@kroah.com>
In-Reply-To: <20100304153606.GA32496@elte.hu>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
	 <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
	 <1267632387.10871.59.camel@gandalf.stny.rr.com>
	 <1267634258.25158.88.camel@laptop>
	 <1267636046.10871.74.camel@gandalf.stny.rr.com>
	 <1267636595.25158.93.camel@laptop> <20100304112531.GF21977@elte.hu>
	 <1267715801.10871.191.camel@gandalf.stny.rr.com>
	 <20100304153606.GA32496@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 04 Mar 2010 10:55:31 -0500
Message-ID: <1267718131.10871.240.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 16:36 +0100, Ingo Molnar wrote:

> > This should be done anyway. But it would also let you decouple ftrace trace 
> > events from perf trace events but still let the two use the same trace 
> > points.
> 
> I think the main thing would be to have a decoupled /eventfs - basically 
> /debug/tracing/events/ moved to "/eventfs" or maybe to "/proc/events/". This 
> would make them available more widely, and in a standardized way.

I know Greg once proposed a /tracefs directory. I don't really care how
things work as long as we don't lose functionality. Perhaps we should
have a standard tracefs dir, and have:

/sys/kernel/trace
/sys/kernel/trace/events
/sys/kernel/trace/ftrace
/sys/kernel/trace/perf

This would keep things nicely grouped but separate.

I could also decouple the printing of the formats from ftrace.h and then
in in the define_trace.h:

#ifdef CONFIG_EVENTS
# include <trace/events.h>
# ifdef CONFIG_FTRACE_EVENTS
#  include <trace/ftrace.h>
# endif
# ifdef CONFIG_PERF_EVENTS
#  include <trace/perf.h>
# endif
#endif

Have the trace/events.h file create the files for the event directory.

But what about the enable and filter files in the event directory. How
would they be attached? Currently these modify the way ftrace works. I'm
assuming that perf enables these with the syscall. Should these files
still be specific to ftrace if enabled?

-- Steve



