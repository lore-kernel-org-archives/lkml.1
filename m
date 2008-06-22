Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYFVS1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYFVS1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 14:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYFVS1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 14:27:09 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:53657 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbYFVS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 14:27:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQEAKA1XkhMQW1O/2dsb2JhbACBW6to
Date: Sun, 22 Jun 2008 14:27:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: Re: [RFC] Tracepoint proposal
Message-ID: <20080622182705.GA23301@Krystal>
References: <485BE2C6.1080901@redhat.com> <20080620174529.GB10943@Krystal> <1213992446.3223.195.camel@lappy.programming.kicks-ass.net> <20080622171135.GA19432@Krystal> <20080622175928.GA5022@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080622175928.GA5022@martell.zuzino.mipt.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:21:12 up 17 days, 23:02,  4 users,  load average: 0.95, 0.73,
	0.61
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexey Dobriyan (adobriyan@gmail.com) wrote:
> On Sun, Jun 22, 2008 at 01:11:35PM -0400, Mathieu Desnoyers wrote:
> > Tracepoint proposal
> > 
> > - Tracepoint infrastructure
> >   - In-kernel users
> >   - Complete typing, verified by the compiler
> >   - Dynamically linked and activated
> > 
> > - Marker infrastructure
> >   - Exported API to userland
> >   - Basic types only
> > 
> > - Dynamic vs static
> >   - In-kernel probes are dynamically linked, dynamically activated, connected to
> >     tracepoints. Type verification is done at compile-time. Those in-kernel
> >     probes can be a probe extracting the information to put in a marker or a
> >     specific in-kernel tracer such as ftrace.
> >   - Information sinks (LTTng, SystemTAP) are dynamically connected to the
> >     markers inserted in the probes and are dynamically activated.
> > 
> > - Near instrumentation site vs in a separate tracer module
> > 
> > A probe module, only if provided with the kernel tree, could connect to internal
> > tracing sites. This argues for keeping the tracepoing probes near the
> > instrumentation site code. However, if a tracer is general purpose and exports
> > typing information to userspace through some mechanism, it should only export
> > the "basic type" information and could be therefore shipped outside of the
> > kernel tree.
> > 
> > In-kernel probes should be integrated to the kernel tree. They would be close to
> > the instrumented kernel code and would translate between the in-kernel
> > instrumentation and the "basic type" exports. Other in-kernel probes could
> > provide a different output (statistics available through debugfs for instance).
> > ftrace falls into this category.
> > 
> > Generic or specialized information "sinks" (LTTng, systemtap) could be connected
> > to the markers put in tracepoint probes to extract the information to userspace.
> > They would extract both typing information and the per-tracepoint execution
> > information to userspace.
> > 
> > Therefore, the code would look like :
> > 
> > kernel/sched.c:
> > 
> > #include "sched-trace.h"
> > 
> > schedule()
> > {
> >   ...
> >   trace_sched_switch(prev, next);
> >   ...
> > }
> 
> Once this is accepted you're going to add hundreds of such calls to every
> core subsystem, right?
> 

The LTTng instrumentation has about 125 of such calls. Tests have
revealed that adding such dormant tracepoints to the kernel often
increase kernel performances rather than decreasing it (see the ia64
benchmarks posted on lkml a few weeks ago).

The core subsystem maintainers are being involved in the process.
Actually, marking up the source code has the interesting effect of
letting knowledgeable people influence the trace point decisions.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
