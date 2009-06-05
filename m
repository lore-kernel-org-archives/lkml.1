Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZFEIg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZFEIg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZFEIgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:36:17 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57170 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbZFEIgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:36:14 -0400
Date: Fri, 5 Jun 2009 14:06:13 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip v9 7/7] tracing: add kprobe-based event tracer
Message-ID: <20090605083613.GC4164@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090602003709.29255.48248.stgit@localhost.localdomain> <20090602003754.29255.37212.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602003754.29255.37212.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 08:37:54PM -0400, Masami Hiramatsu wrote:
> Add kprobes-based event tracer on ftrace.
> 
> This tracer is similar to the events tracer which is based on Tracepoint
> infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
> and kretprobe). It probes anywhere where kprobes can probe(this means, all
> functions body except for __kprobes functions).
> 
> Similar to the events tracer, this tracer doesn't need to be activated via
> current_tracer, instead of that, just set probe points via
> /sys/kernel/debug/tracing/kprobe_events. And you can set filters on each
> probe events via /sys/kernel/debug/tracing/events/kprobes/<EVENT>/filter.
> 
> This tracer supports following probe arguments for each probe.
> 
>   %REG  : Fetch register REG
>   sN    : Fetch Nth entry of stack (N >= 0)
>   @ADDR : Fetch memory at ADDR (ADDR should be in kernel)
>   @SYM[+|-offs] : Fetch memory at SYM +|- offs (SYM should be a data symbol)
>   aN    : Fetch function argument. (N >= 0)
>   rv    : Fetch return value.
>   ra    : Fetch return address.
>   +|-offs(FETCHARG) : fetch memory at FETCHARG +|- offs address.
> 
> See Documentation/trace/kprobes.txt for details.
> 
> Changes from v8:
>  - Fix wrong argument offsets in format.
>  - Remove EVENT_TRACING selection in Kconfig.
>  - Fix debugfs file path.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>

The kprobe usage look fine.

Tested on x86 and works fine too! Great work, Masami.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
