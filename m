Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab0CDVxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:53:45 -0500
Received: from www.tglx.de ([62.245.132.106]:54348 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab0CDVxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:53:44 -0500
Date: Thu, 4 Mar 2010 22:52:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Greg KH <greg@kroah.com>
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
 events
In-Reply-To: <20100304213725.GA8169@nowhere>
Message-ID: <alpine.LFD.2.00.1003042251510.2014@localhost.localdomain>
References: <1267632387.10871.59.camel@gandalf.stny.rr.com> <1267634258.25158.88.camel@laptop> <1267636046.10871.74.camel@gandalf.stny.rr.com> <1267636595.25158.93.camel@laptop> <20100304112531.GF21977@elte.hu> <1267715801.10871.191.camel@gandalf.stny.rr.com>
 <20100304153606.GA32496@elte.hu> <1267718131.10871.240.camel@gandalf.stny.rr.com> <20100304211741.GB3643@elte.hu> <1267738238.10871.582.camel@gandalf.stny.rr.com> <20100304213725.GA8169@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Frederic Weisbecker wrote:

> On Thu, Mar 04, 2010 at 04:30:38PM -0500, Steven Rostedt wrote:
> > On Thu, 2010-03-04 at 22:17 +0100, Ingo Molnar wrote:
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > 
> > > No, we want to decouple it from 'tracing'. It's events, not tracing. Events 
> > > are more broader, they can be used for RAS, profiling, counting, etc. - not 
> > > just tracing.
> > > 
> > > Furthermore, we only want /debug/tracing/events really, not the various 
> > > dynamic ftrace controls - those could remain in /debug/tracing/.
> > 
> > I was talking about the files in the events directory:
> > 
> > events/sched/sched_switch/{id,format,enable,filter}
> > 
> > 
> > Seems only the format file should go in, and perhaps the id.
> > 
> > I can keep the debug/tracing/events/* as is too, where the format and id
> > just call the same routines that the eventfs calls, but add the enable
> > and filter to be specific to ftrace.
> 
> 
> The /debug/tracing/events could contain symlinks for the format
> files so that the rest can stay there.

Are you proposing to create another sysfs symlink maze ?

Thanks,

	tglx
