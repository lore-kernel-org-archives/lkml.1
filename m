Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbZBQOY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbZBQOY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZBQOYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:24:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:37408 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZBQOYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:24:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=yBJh5SwIxO+JsLveX/DcRC5kxwCrJrUdZZT17K5NVfrLxGU2WUPFDa0XiPt7ujSOy+
         rsj1L+mDga74Kb7xmptlODJWFmJMikO1cwMIrByJdKjOOEdJo96Mpy7uqIuKDwMvx7nX
         EMnYww9bSU2STjf2zV78GHbjsc6Z886ROHe/0=
Date: Tue, 17 Feb 2009 15:24:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 00/15] [git pull] for tip/tracing/ftrace
Message-ID: <20090217142414.GA5888@nowhere>
References: <20090217051227.957864159@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217051227.957864159@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 12:12:27AM -0500, Steven Rostedt wrote:
> 
> Ingo,
> 
> This is a patch series that offers a variety of features.
> 
> The first is to add:
> 
>  #### all functions enabled ####
> 
> to set_ftrace_filter when all functions will be traced when function
> tracing is on.
> 
> The next is to add a :command: interface, and the module command:
> 
>  echo '*:mod:ext4' > set_ftrace_filter
> 
> Will select all functions in the ext4 module.
> 
>  echo '!*write*:mod:ext4' > set_ftrace_filter
> 
> will remove all functions with the characters 'write' and are
> in ext4.
> 
> Next we extend the :command: interface as well as add a way to
> hook tracers to specific functions. Instead of tracing all functions
> the same, this patch series adds a hash to be able to trace different
> functions differently.
> 
> I implement a 'traceon' and 'traceoff' to have a function start or
> stop tracing when it is hit. It also includes a counter for the
> number of times to implement the trace on/off.
> 
>  echo '*_lock:traceon:4' > set_ftrace_filter
>  echo '*_unlock:traceoff:5' > set_ftrace_filter

That's great!
I guess it could be useful to be able to pass it as a kernel parameter.
Something like that ftrace=function_tracer ftrace_filter='*_lock:traceon:4'


> This will have all functions that end with _lock turn on tracing
> and all that end with _unlock disable it, 4 times each.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/tracing/ftrace
> 
> 
> Steven Rostedt (15):
>       ftrace: state that all functions are enabled in set_ftrace_filter
>       ftrace: add do_for_each_ftrace_rec and while_for_each_ftrace_rec
>       ftrace: rename ftrace_match to ftrace_match_records
>       ftrace: break up ftrace_match_records into smaller components
>       ftrace: add module command function filter selection
>       ftrace: enable filtering only when a function is filtered on
>       ftrace: add command interface for function selection
>       ftrace: convert ftrace_lock from a spinlock to mutex
>       ftrace: consolidate mutexes
>       ftrace: trace different functions with a different tracer
>       ring-buffer: add tracing_is_on to test if ring buffer is enabled
>       ftrace: add traceon traceoff commands to enable/disable the buffers
>       ftrace: show selected functions in set_ftrace_filter
>       ftrace: add pretty print to selected fuction traces
>       ftrace: add pretty print function for traceon and traceoff hooks
> 
> ----
>  include/linux/ftrace.h         |   40 ++
>  include/linux/ring_buffer.h    |    2 +
>  kernel/trace/ftrace.c          |  929 +++++++++++++++++++++++++++++++---------
>  kernel/trace/ring_buffer.c     |    9 +
>  kernel/trace/trace_functions.c |  163 +++++++
>  5 files changed, 946 insertions(+), 197 deletions(-)
> -- 

