Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbZBXRSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbZBXRSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbZBXRSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:18:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40342 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757364AbZBXRSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:18:24 -0500
Date: Tue, 24 Feb 2009 12:17:18 -0500
From: Jason Baron <jbaron@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/3] tracing/ftrace: ftrace_bprintk
Message-ID: <20090224171718.GA3189@redhat.com>
References: <20090224051618.GA5142@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224051618.GA5142@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 06:16:18AM +0100, Frederic Weisbecker wrote:
> Hi,
> 
> These three patches are part of a patchset posted by Lai Jiangshan in december 2008.
> They introduce a binary version of ftrace_printk() called ftrace_bprintk()
> 
> While having the same goal: print a generic message entry into the ring buffer,
> their approaches are very different.
> 
> - ftrace_printk() does the formatting job on tracing time, insert the whole resulting string
>   into the ring buffer, and then the string is printed on output time without a lot of modifications.
> 
> - ftrace_bprintk() does no formatting on tracing time. Instead, it looks at the format string
>   to find the types and the numbers of the arguments and directly stores them as-is into the
>   ring-buffer. Then the format string is stored into the ring-buffer too, but only by its address,
>   it is not copied. Then on output time only, the final string is formatted and sent to the user.
>   This gives a result about as fast as a traditional tracer with fixed fields types, except that
>   we can print random types and numbers of fields here.
> 
> 
> The first patch adds the generic support for binary formatting.
> The second adds the support for binary print types on ftrace
> and the last introduces ftrace_bprintk() which supports safely the modules
> by listening on the module loading/unloading notifier to keep track of
> unwanted freed format strings.
> 
> Lai Jiangshan (3):
>       add binary printf
>       ftrace: infrastructure for supporting binary record
>       ftrace: add ftrace_bprintk()
> 

hi,

this seems like a really valuable feature....I'm just wondering about a
couple of things....

If the 'brpintk tracer' in trace/trace_bprintk.c is just being used to
set an enabled flag for printing out these binary records, then are we
better off with just an option flag in the 'trace_options' file? 

Second, can we somehow combine ftrace_printk() and ftrace_bprintk(), so
that a developer can just use one interface? Perhaps, ftrace_printk
calls ftrace_bprintk if binary option flag is set, otherwise, it just
outputs things normally.

thanks,

-Jason 










