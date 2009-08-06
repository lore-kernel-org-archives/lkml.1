Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbZHFM7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbZHFM7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbZHFM7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:59:52 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:49377 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbZHFM7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:59:52 -0400
X-SourceIP: 213.93.53.227
Subject: Re: malloc() tracing in perf?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       acme <acme@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       roland <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090806115527.GE18768@redhat.com>
References: <4A7A8ADD.4080208@cs.helsinki.fi>
	 <1249546610.32113.35.camel@twins> <20090806112059.GD18768@redhat.com>
	 <1249558094.32113.242.camel@twins>  <20090806115527.GE18768@redhat.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 14:59:34 +0200
Message-Id: <1249563574.32113.358.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 07:55 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Thu, Aug 06, 2009 at 01:28:14PM +0200, Peter Zijlstra wrote:
> > [...]
> > > That work is ongoing, and being discussed on utrace-devel@redhat.com,
> > > since it is a prerequisite. 
> > 
> > Still hiding the discussion and the design never helped anybody.
> 
> I guess "hiding" is a matter of opinion.

Yeah in plain sight where nobody looks, really I thought the idea was to
get utrace upstream, this means posting to linux-kernel. Going on LKML
posts I'd say the utrace project was dead. Same goes for uprobe.

I've told this before and I'll say it again, post to LKML.

> > > While these deliberations are ongoing, you can use systemtap.  Probing
> > > random places in userspace is about as casual as probing the kernel:
> > 
> > Right, but that still doesn't tell us anything on how you're doing that,
> > does it?
> 
> Since you asked...  the probe process("/lib64/libc.so.6") points
> systemtap to a shared library file, whose symbol table & debug data
> gives us information about what functions & parameters are available.
> Among other things, we record a shared-library base-relative address
> for the function.
> 
> At run time, we monitor the entire system (or just a given process if
> -x PID/-c CMD was specified) to see when that shared library gets
> loaded.  (This in turn is done with a utrace-based hook of the mmap
> syscall - see "task_finder" in our sources). 

Does this also iterate the already existing tasks to find if it was
already mmap()ed?

> This overview skims over issues related to return probes, tracing
> buffer manipulations, and much other stuff.

Right, so you basically read the (dwarf2) debug info for a particular
lib/symbol and generate a kernel module that knows about that and then
insert that into the kernel to act as a uprobe handler?

Uprobe will then do the code rewrite on mmap() time to insert a trap
much like kprobe does? What if its a JITed code section and the JIT
rewrites it? Will uprobes detect that?

> All the code for this is hidden in plain sight in every systemtap
> release, so please feel free to refer to that and/or ask more detailed
> questions.

I thought the goal was to get stuff upstream, but if you want to
continue living in la-la land and not bother with upstream Linux then so
be it I guess :-(

