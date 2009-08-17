Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZHQQ2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZHQQ2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 12:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZHQQ2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 12:28:15 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:64158 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZHQQ2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 12:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q7Lw73DbPaiPvIDAyTiVTTP2sdP924dbmaYRsl8gq8dZvzQyMuuCTgV5o43hRzo9f9
         IJFKXi1ecvddaU6FBC2Pb6lncY5jJFoPvvfuGzyZ245P0cXvVI7VK6D/4u6JISct1XZM
         j9NxOLcUKcrxCzciblsJKxUIhCChzp1shh0eg=
Date: Mon, 17 Aug 2009 18:28:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Jiaying Zhang <jiayingz@google.com>, Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 4/4] perf tools: Add perf trace
Message-ID: <20090817162807.GA4953@nowhere>
References: <1250518688-7207-1-git-send-email-fweisbec@gmail.com> <1250518688-7207-4-git-send-email-fweisbec@gmail.com> <20090817144007.GC3602@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817144007.GC3602@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 04:40:07PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > This adds perf trace into the set of perf tools. It is written to 
> > fetch the tracepoints samples from perf events and display them, 
> > according to the events informations given by the debugfs files 
> > through the util/trace* tools.
> > 
> > It is a rough first shot and doesn't yet handle the cpu, 
> > timestamps fields and some other things.
> > 
> > Example:
> > 
> > perf record -f -e workqueue:workqueue_execution:record -F 1 -a
> > perf trace
> > 
> >        kblockd/0-236   [000]     0.000000: workqueue_execution: thread=:236 func=cfq_kick_queue+0x0
> >      kondemand/0-360   [000]     0.000000: workqueue_execution: thread=:360 func=do_dbs_timer+0x0
> >      kondemand/0-360   [000]     0.000000: workqueue_execution: thread=:360 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> >      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
> 
> Nice!
> 
> > Todo:
> > 
> > - A lot of things!
> 
> heh :-)
> 
> To help this move forward i've put the patches into 
> tip:perfcounters/tracing. We might still rebase that branch, should 
> it become necessary, before merging it into perfcounters/core - but 
> it should give a first glimpse to people who want to try this.
> 
> A first bugreport:
> 
> took me some time to figure out that i need to pass in -R to create 
> a trace.info. I think we want to share the namespace anyway - 
> there's no real difference between perf.data and trace.info - both 
> contain trace records.



trace.info only contains the events descriptions and other ftrace things:

- formats, ftrace printk strings, ...

I plan to integrate that into perf.trace so that we have only one file
to move to perform offline analysis.

Concerning the -R thing (or ::record suffix), indeed I have yet to
warn the user from perf trace about that. Todo listed!

> 
> once i added -R i ran into this problem:
> 
> # perf record -R -f -e workqueue:workqueue_execution:record -F 1 -a
> ^C
> [ perf record: Captured and wrote 0.250 MB perf.data (~10928 samples) ]
> 
> aldebaran:/home/mingo/linux/linux/tools/perf> perf trace
>   Fatal: bad op token )


Oh!
Hmm, also I forgot to explain a detail, there is a little bug in ftrace
syscalls formats which reports the format is too big when a syscall takes
no parameter. It needs a trivial fix, I'll send it soon.

Anyway, that made me a very similar Fatal thing but not exactly the same.
Could you send me your config? May be you have tracepoint/ftrace plugins
I haven't built (well I should build all of them actually).


> version = 0.5
> 
> Some missing patch?



Soon :)


> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

