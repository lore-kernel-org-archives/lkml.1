Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZIHACX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZIHACX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 20:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbZIHACX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 20:02:23 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46439 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZIHACW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 20:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PiOaRhRl7yYX+McKvY4n+XQtABjyGQi9Pqw5SmvuovfyNnSQvbbpzxrOPqxysfkrVq
         zOG4sibLEJoewjbvdDV68haqpsFGNTGDq5YLE5W8Q2f7GAVoUahuFBweb7RM/ZL6RPa9
         be+tIVaqL+bk9cNn+vAakVshMv5DtWB9+/2oM=
Date: Tue, 8 Sep 2009 02:02:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] perf trace: Add filter support
Message-ID: <20090908000219.GB6312@nowhere>
References: <4AA4C04D.1050201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA4C04D.1050201@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 04:11:57PM +0800, Li Zefan wrote:
> This patchset adds filter support for perf counter, so not all
> profile events are recorded but only those match the filters
> we set.


Thanks a lot for this work!



> An example:
> 
>  #./perf record -f -e irq:irq_handler_entry:irq==18:record
>  or
>  #./perf record -f -e irq:irq_handler_entry:irq==18 -R
>  ^C



We may want to write complex filters. While looking at this patchset,
that seems possible this way, but the raw line may become unreadable:

perf record -f -e irq:irq_handler_entry:"irq==18 && (name == 'foo' || bar == 'blah')":record

May be we should add an option to let one also set the filters seperately then
we could do:

perf record -f -e -R irq:irq_handler_entry --filter "irq==18 && (name == 'foo' || bar == 'blah')"

Hmm.


>  # ./perf trace
>  version = 0.5
>             perf-4303  ... irq_handler_entry: irq=18 handler=eth0
>             init-0     ... irq_handler_entry: irq=18 handler=eth0
>             init-0     ... irq_handler_entry: irq=18 handler=eth0
>             init-0     ... irq_handler_entry: irq=18 handler=eth0
>             init-0     ... irq_handler_entry: irq=18 handler=eth0
> 
> ---
>  include/linux/ftrace_event.h       |   19 +++-
>  include/linux/perf_counter.h       |    1 +
>  include/linux/syscalls.h           |   14 ++-
>  include/trace/ftrace.h             |   10 +-
>  kernel/perf_counter.c              |   40 ++++++-
>  kernel/trace/trace.h               |    9 +-
>  kernel/trace/trace_event_profile.c |   18 +++
>  kernel/trace/trace_events_filter.c |  247 +++++++++++++++++++++---------------
>  kernel/trace/trace_syscalls.c      |    9 +-
>  tools/perf/builtin-record.c        |   12 ++
>  tools/perf/util/parse-events.c     |   48 ++++++-
>  tools/perf/util/parse-events.h     |    1 +
>  12 files changed, 303 insertions(+), 125 deletions(-)
> 

