Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbYFXAYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbYFXAYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYFXAYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:24:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:12013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYFXAYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aeaF7gPvDUS9u+naLCWJ7fCR1Y8G8g5qhfcedDBdCt1HbA6NRIIamMWfNMsEORhU+8
         ljeToNRTdhM5HosvLPljY8xq620q00gxhjD5fPaJQuJXDeUgj6qI5PVLEUyYxRvCbTcl
         XMiqn436fsyr5Nal+/byxui05/MYD2gc6CxPY=
Date: Tue, 24 Jun 2008 04:20:10 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: Re: [RFC] Tracepoint proposal
Message-ID: <20080624002010.GA4777@martell.zuzino.mipt.ru>
References: <485BE2C6.1080901@redhat.com> <20080620174529.GB10943@Krystal> <1213992446.3223.195.camel@lappy.programming.kicks-ass.net> <20080622171135.GA19432@Krystal> <20080622175928.GA5022@martell.zuzino.mipt.ru> <20080622182705.GA23301@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622182705.GA23301@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 02:27:05PM -0400, Mathieu Desnoyers wrote:
> * Alexey Dobriyan (adobriyan@gmail.com) wrote:
> > On Sun, Jun 22, 2008 at 01:11:35PM -0400, Mathieu Desnoyers wrote:
> > > Tracepoint proposal
> > > 
> > > - Tracepoint infrastructure
> > >   - In-kernel users
> > >   - Complete typing, verified by the compiler
> > >   - Dynamically linked and activated
> > > 
> > > - Marker infrastructure
> > >   - Exported API to userland
> > >   - Basic types only
> > > 
> > > - Dynamic vs static
> > >   - In-kernel probes are dynamically linked, dynamically activated, connected to
> > >     tracepoints. Type verification is done at compile-time. Those in-kernel
> > >     probes can be a probe extracting the information to put in a marker or a
> > >     specific in-kernel tracer such as ftrace.
> > >   - Information sinks (LTTng, SystemTAP) are dynamically connected to the
> > >     markers inserted in the probes and are dynamically activated.
> > > 
> > > - Near instrumentation site vs in a separate tracer module
> > > 
> > > A probe module, only if provided with the kernel tree, could connect to internal
> > > tracing sites. This argues for keeping the tracepoing probes near the
> > > instrumentation site code. However, if a tracer is general purpose and exports
> > > typing information to userspace through some mechanism, it should only export
> > > the "basic type" information and could be therefore shipped outside of the
> > > kernel tree.
> > > 
> > > In-kernel probes should be integrated to the kernel tree. They would be close to
> > > the instrumented kernel code and would translate between the in-kernel
> > > instrumentation and the "basic type" exports. Other in-kernel probes could
> > > provide a different output (statistics available through debugfs for instance).
> > > ftrace falls into this category.
> > > 
> > > Generic or specialized information "sinks" (LTTng, systemtap) could be connected
> > > to the markers put in tracepoint probes to extract the information to userspace.
> > > They would extract both typing information and the per-tracepoint execution
> > > information to userspace.
> > > 
> > > Therefore, the code would look like :
> > > 
> > > kernel/sched.c:
> > > 
> > > #include "sched-trace.h"
> > > 
> > > schedule()
> > > {
> > >   ...
> > >   trace_sched_switch(prev, next);
> > >   ...
> > > }
> > 
> > Once this is accepted you're going to add hundreds of such calls to every
> > core subsystem, right?
> > 
> 
> The LTTng instrumentation has about 125 of such calls. Tests have
> revealed that adding such dormant tracepoints to the kernel often
> increase kernel performances rather than decreasing it (see the ia64
> benchmarks posted on lkml a few weeks ago).

We're not adding this for performance increase, you do realize this?

> The core subsystem maintainers are being involved in the process.

NAK this from proc if you about this.

> Actually, marking up the source code has the interesting effect of
> letting knowledgeable people influence the trace point decisions.

I'd say that maximum source code overhead any tracing facility should be
allowed is "__xxx" annotation at very start of function definition.
Anything beyond should be rejected and there are good reasons for that.

