Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYFVSDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYFVSDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 14:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYFVSDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 14:03:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:45401 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbYFVSDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 14:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sXKRrBADJtwq1jNWeW3qxsFfJRP01eiDMp2PrbYI/++2doDLbGsLduHv4tgWGGiU9l
         dPjJk/EtXL61pYRvMjyNeHrEOBDWCn5aoc2EQe4pJR2iJVQObkiAINwb4n7Ml1ZI4NnM
         zq8kxjb3oMASzYaw2SWYnnKTlRMWhFiGbAD78=
Date: Sun, 22 Jun 2008 21:59:28 +0400
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
Message-ID: <20080622175928.GA5022@martell.zuzino.mipt.ru>
References: <485BE2C6.1080901@redhat.com> <20080620174529.GB10943@Krystal> <1213992446.3223.195.camel@lappy.programming.kicks-ass.net> <20080622171135.GA19432@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622171135.GA19432@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 01:11:35PM -0400, Mathieu Desnoyers wrote:
> Tracepoint proposal
> 
> - Tracepoint infrastructure
>   - In-kernel users
>   - Complete typing, verified by the compiler
>   - Dynamically linked and activated
> 
> - Marker infrastructure
>   - Exported API to userland
>   - Basic types only
> 
> - Dynamic vs static
>   - In-kernel probes are dynamically linked, dynamically activated, connected to
>     tracepoints. Type verification is done at compile-time. Those in-kernel
>     probes can be a probe extracting the information to put in a marker or a
>     specific in-kernel tracer such as ftrace.
>   - Information sinks (LTTng, SystemTAP) are dynamically connected to the
>     markers inserted in the probes and are dynamically activated.
> 
> - Near instrumentation site vs in a separate tracer module
> 
> A probe module, only if provided with the kernel tree, could connect to internal
> tracing sites. This argues for keeping the tracepoing probes near the
> instrumentation site code. However, if a tracer is general purpose and exports
> typing information to userspace through some mechanism, it should only export
> the "basic type" information and could be therefore shipped outside of the
> kernel tree.
> 
> In-kernel probes should be integrated to the kernel tree. They would be close to
> the instrumented kernel code and would translate between the in-kernel
> instrumentation and the "basic type" exports. Other in-kernel probes could
> provide a different output (statistics available through debugfs for instance).
> ftrace falls into this category.
> 
> Generic or specialized information "sinks" (LTTng, systemtap) could be connected
> to the markers put in tracepoint probes to extract the information to userspace.
> They would extract both typing information and the per-tracepoint execution
> information to userspace.
> 
> Therefore, the code would look like :
> 
> kernel/sched.c:
> 
> #include "sched-trace.h"
> 
> schedule()
> {
>   ...
>   trace_sched_switch(prev, next);
>   ...
> }

Once this is accepted you're going to add hundreds of such calls to every
core subsystem, right?

