Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbZHFOSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbZHFOSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZHFOSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:18:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZHFOSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:18:37 -0400
Date: Thu, 6 Aug 2009 10:17:44 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       acme <acme@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       roland <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: malloc() tracing in perf?
Message-ID: <20090806141744.GG18768@redhat.com>
References: <4A7A8ADD.4080208@cs.helsinki.fi> <1249546610.32113.35.camel@twins> <20090806112059.GD18768@redhat.com> <1249558094.32113.242.camel@twins> <20090806115527.GE18768@redhat.com> <1249563574.32113.358.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249563574.32113.358.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Aug 06, 2009 at 02:59:34PM +0200, Peter Zijlstra wrote:

> [...]  Yeah in plain sight where nobody looks, really I thought the
> idea was to get utrace upstream, this means posting to
> linux-kernel. Going on LKML posts [...]

I don't wish to get into arguing about how much lkml posting is
appropriate, or to editorialize about what happened when some of this
code did actually get posted.  I'm simply discussing the technology.
It's never been hard to find.


> [...]
> Does this also iterate the already existing tasks to find if it was
> already mmap()ed?

Yes.

> > This overview skims over issues related to return probes, tracing
> > buffer manipulations, and much other stuff.
> 
> Right, so you basically read the (dwarf2) debug info for a particular
> lib/symbol and generate a kernel module that knows about that and then
> insert that into the kernel to act as a uprobe handler?

Yes.

> Uprobe will then do the code rewrite on mmap() time to insert a trap
> much like kprobe does? What if its a JITed code section and the JIT
> rewrites it? Will uprobes detect that?

You mean if the uprobe is made to refer to code that was created by a
JIT?  That does not happen in the preceding scenario, since the
uprobes addresses were based on prior generated debugging data.

Putting uprobes into JIT code such as LLVM or JVM code is something
for the future.


> > All the code for this is hidden in plain sight in every systemtap
> > release, so please feel free to refer to that and/or ask more detailed
> > questions.
> 
> I thought the goal was to get stuff upstream, but if you want to
> continue living in la-la land and not bother with upstream Linux then so
> be it I guess :-(

It's not that simple, and you know it.


- FChE
