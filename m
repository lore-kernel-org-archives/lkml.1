Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZGIDKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZGIDKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 23:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbZGIDKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 23:10:37 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:51249 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984AbZGIDKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 23:10:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jky2WuCQ06fJm9Jj/H83Fuh8yMk48vz2jUYHGBdQjnH+d8LswLF3/u3Rzga9Evgpgc
         kn8uME/c9OK2bMGw72epQ+5mvPCGMZxTtTGEkDwIAzZc2TTMmJ/fvqaPFwW9H+4/fK4P
         RELvmwKyU+EsC29kXmr4LTFY2+rMi31xw9BHo=
Date: Thu, 9 Jul 2009 05:10:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       a.p.zijlstra@chello.nl, rostedt@goodmis.org
Subject: Re: [PATCH 0/2] perf_counter: add tracepoint support
Message-ID: <20090709031032.GA6412@nowhere>
References: <cover.1246912068.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1246912068.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 05:11:53PM -0400, Jason Baron wrote:
> 
> hi,
> 
> The following two patches build on Peter's initial tracepoint perf counter work.
> The first patches enables the kernel side, and the second patch adds support to
> the 'perf' tool itself. The debugfs filesystem needs to be mounted to make this
> work and it is searched in the default location '/sys/kernel/debug'. We can
> add an optional parameter to search for it elsewhere if need be.
> 
> Below, I show the output of 'perf list', and 'perf stat' for a tbench run.
> 
[...] 
> >  perf stat  -a -e sched:sched_switch -e sched:sched_wakeup -e irq:irq_handler_entry tbench 4
> 
>  Performance counter stats for 'tbench 4':
> 
>       194658693  sched:sched_switch      
>        97479295  sched:sched_wakeup      
>            9122  irq:irq_handler_entry   
> 
>   720.171439729  seconds time elapsed
> 


Cool, now the next stage that would be nice would be to have the
events themselves and not only the counts so that we can sort the
stats using values from the fields.

I have some ideas about that. We shouldn't interfere with ftrace job
and then use a private buffer for ftrace events used by perf.
But still this private buffer should be a private instance of the
ring buffer implemented in kernel/trace/, which is already well adapted for
the ftrace events (handles recursion).

(RFD parenthesis: why not using the one in kernel/trace for all perf events?
Now that it is lockless, it would fit nicely inside: no fear about NMI
context).

Anyway, unless you are already working on it, I'll try to adapt the content
of these events with perfcounter.

Thanks,
Frederic.


> 
>   -add kernel tracepoint support
>   -add support for tracepoints to the perf tool
> 
>  init/Kconfig                   |    2 +-
>  kernel/perf_counter.c          |    6 +-
>  tools/perf/util/parse-events.c |  195 +++++++++++++++++++++++++++++++++++++++-
>  tools/perf/util/util.h         |    2 +
>  4 files changed, 200 insertions(+), 5 deletions(-)
> 

