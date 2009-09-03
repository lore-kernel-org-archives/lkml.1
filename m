Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbZICBwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbZICBwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 21:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZICBwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 21:52:43 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33772 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbZICBwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 21:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r3/Y4Td4TZX9TKTevsHdtKcMZSiBBRcuxBfk7wIc6p6ouHfEjq+f28E3vaV1wx2S3H
         /DO+Dcx7zYoXLykd4pVD4IRVEx/9pLnCaPHSZSEWqaLtnMW/8K+ziaaERe8CqzW5GQ1k
         BudcWT8HZSEQcxU7xZOQA6r6/lpnSuWPjVMzs=
Date: Thu, 3 Sep 2009 03:52:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       lizf@cn.fujitsu.com, efault@gmx.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf trace: Sample the CPU too
Message-ID: <20090903015239.GD6072@nowhere>
References: <tip-cd6feeeafddbef6abfe4d90fb26e42fd844d34ed@git.kernel.org> <20090902214449.GA6072@nowhere> <20090902215456.GA16857@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902215456.GA16857@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 11:54:56PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Wed, Sep 02, 2009 at 07:31:51PM +0000, tip-bot for Ingo Molnar wrote:
> > > Commit-ID:  cd6feeeafddbef6abfe4d90fb26e42fd844d34ed
> > > Gitweb:     http://git.kernel.org/tip/cd6feeeafddbef6abfe4d90fb26e42fd844d34ed
> > > Author:     Ingo Molnar <mingo@elte.hu>
> > > AuthorDate: Wed, 2 Sep 2009 20:20:38 +0200
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Wed, 2 Sep 2009 21:28:50 +0200
> > > 
> > > perf trace: Sample the CPU too
> > > 
> > > Sample, record, parse and print the CPU field - it had all zeroes before.
> > > 
> > > Before (watch the second column, the CPU values):
> > > 
> > >             perf-32685 [000]     0.000000: sched_wakeup_new: task perf:32686 [120] success=1 [011]
> > >             perf-32685 [000]     0.000000: sched_migrate_task: task perf:32685 [120] from: 1  to: 11
> > >             perf-32685 [000]     0.000000: sched_process_fork: parent perf:32685  child perf:32686
> > >             true-32686 [000]     0.000000: sched_wakeup: task migration/11:25 [0] success=1 [011]
> > >             true-32686 [000]     0.000000: sched_wakeup: task distccd:12793 [125] success=1 [015]
> > >             true-32686 [000]     0.000000: sched_wakeup: task distccd:12793 [125] success=1 [015]
> > >             perf-32685 [000]     0.000000: sched_switch: task perf:32685 [120] (S) ==> swapper:0 [140]
> > >             true-32686 [000]     0.000000: sched_switch: task perf:32686 [120] (R) ==> migration/11:25 [0]
> > >             true-32686 [000]     0.000000: sched_switch: task perf:32686 [120] (R) ==> distccd:12793 [125]
> > >             true-32686 [000]     0.000000: sched_switch: task true:32686 [120] (R) ==> distccd:12793 [125]
> > >             true-32686 [000]     0.000000: sched_process_exit: task true:32686 [120]
> > >             true-32686 [000]     0.000000: sched_stat_wait: task: distccd:12793 wait: 6767985949080 [ns]
> > >             true-32686 [000]     0.000000: sched_stat_wait: task: distccd:12793 wait: 6767986139446 [ns]
> > >             true-32686 [000]     0.000000: sched_stat_sleep: task: distccd:12793 sleep: 132844 [ns]
> > >             true-32686 [000]     0.000000: sched_stat_sleep: task: distccd:12793 sleep: 131724 [ns]
> > > 
> > > After:
> > > 
> > >             perf-32685 [001]     0.000000: sched_wakeup_new: task perf:32686 [120] success=1 [011]
> > >             perf-32685 [001]     0.000000: sched_migrate_task: task perf:32685 [120] from: 1  to: 11
> > >             perf-32685 [001]     0.000000: sched_process_fork: parent perf:32685  child perf:32686
> > >             true-32686 [011]     0.000000: sched_wakeup: task migration/11:25 [0] success=1 [011]
> > >             true-32686 [015]     0.000000: sched_wakeup: task distccd:12793 [125] success=1 [015]
> > >             true-32686 [015]     0.000000: sched_wakeup: task distccd:12793 [125] success=1 [015]
> > >             perf-32685 [001]     0.000000: sched_switch: task perf:32685 [120] (S) ==> swapper:0 [140]
> > >             true-32686 [011]     0.000000: sched_switch: task perf:32686 [120] (R) ==> migration/11:25 [0]
> > >             true-32686 [015]     0.000000: sched_switch: task perf:32686 [120] (R) ==> distccd:12793 [125]
> > >             true-32686 [015]     0.000000: sched_switch: task true:32686 [120] (R) ==> distccd:12793 [125]
> > >             true-32686 [015]     0.000000: sched_process_exit: task true:32686 [120]
> > >             true-32686 [015]     0.000000: sched_stat_wait: task: distccd:12793 wait: 6767985949080 [ns]
> > >             true-32686 [015]     0.000000: sched_stat_wait: task: distccd:12793 wait: 6767986139446 [ns]
> > >             true-32686 [015]     0.000000: sched_stat_sleep: task: distccd:12793 sleep: 132844 [ns]
> > >             true-32686 [015]     0.000000: sched_stat_sleep: task: distccd:12793 sleep: 131724 [ns]
> > > 
> > > So we can now see how this workload migrated between CPUs.
> > > 
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: Paul Mackerras <paulus@samba.org>
> > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > > Cc: Mike Galbraith <efault@gmx.de>
> > > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > LKML-Reference: <new-submission>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > 
> > > 
> > > ---
> > >  tools/perf/builtin-record.c |    4 +++-
> > >  tools/perf/builtin-trace.c  |    9 ++++++++-
> > >  2 files changed, 11 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > > index add514d..ff93f8e 100644
> > > --- a/tools/perf/builtin-record.c
> > > +++ b/tools/perf/builtin-record.c
> > > @@ -403,8 +403,10 @@ static void create_counter(int counter, int cpu, pid_t pid)
> > >  	if (call_graph)
> > >  		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
> > >  
> > > -	if (raw_samples)
> > > +	if (raw_samples) {
> > >  		attr->sample_type	|= PERF_SAMPLE_RAW;
> > > +		attr->sample_type	|= PERF_SAMPLE_CPU;
> > > +	}
> > >  
> > >  	attr->mmap		= track;
> > >  	attr->comm		= track;
> > > diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> > > index 8247fd0..bbe4c44 100644
> > > --- a/tools/perf/builtin-trace.c
> > > +++ b/tools/perf/builtin-trace.c
> > > @@ -58,12 +58,19 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
> > >  	struct dso *dso = NULL;
> > >  	struct thread *thread;
> > >  	u64 ip = event->ip.ip;
> > > +	u32 cpu = -1;
> > >  	u64 period = 1;
> > >  	void *more_data = event->ip.__more_data;
> > >  	int cpumode;
> > >  
> > >  	thread = threads__findnew(event->ip.pid, &threads, &last_match);
> > >  
> > > +	if (sample_type & PERF_SAMPLE_CPU) {
> > > +		cpu = *(u32 *)more_data;
> > > +		more_data += sizeof(u32);
> > > +		more_data += sizeof(u32); /* reserved */
> > > +	}
> > > +
> > 
> > 
> > Cool, I've searched an easy way to have the cpu and I wasn't even 
> > aware of this type of event :-)
> > 
> > 
> > What about the timestamp now? I guess a specific field should be 
> > filled for tracepoint raw samples. Or may be for every raw 
> > samples?
> 
> how about:
> 
>          *      { u64                   time;     } && PERF_SAMPLE_TIME
> 
> ?
> 
> Here's the full list of sample options btw:
> 
> 	/*
> 	 * struct {
> 	 *	struct perf_event_header	header;
> 	 *
> 	 *	{ u64			ip;	  } && PERF_SAMPLE_IP
> 	 *	{ u32			pid, tid; } && PERF_SAMPLE_TID
> 	 *	{ u64			time;     } && PERF_SAMPLE_TIME
> 	 *	{ u64			addr;     } && PERF_SAMPLE_ADDR
> 	 *	{ u64			id;	  } && PERF_SAMPLE_ID
> 	 *	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
> 	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
> 	 * 	{ u64			period;   } && PERF_SAMPLE_PERIOD
> 	 *
> 	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
> 	 *
> 	 *	{ u64			nr,
> 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
> 	 *
> 
> 	Ingo


Looks pretty good!

I'll implement that, thanks.

