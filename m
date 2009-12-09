Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZLIOQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZLIOQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZLIOQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:16:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37704 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834AbZLIOQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:16:31 -0500
Date: Wed, 9 Dec 2009 15:16:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       srostedt@redhat.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] tracing: Add pipe_close interface
Message-ID: <20091209141619.GA21862@elte.hu>
References: <tip-c521efd1700a8c0f7ce26f011f5eaecca17fabfa@git.kernel.org>
 <20091209153204.F4CD.A69D9226@jp.fujitsu.com>
 <1260367720.2146.71.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260367720.2146.71.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2009-12-09 at 15:35 +0900, KOSAKI Motohiro wrote:
> 
> > > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > > index 874f289..f804b40 100644
> > > --- a/kernel/trace/trace.c
> > > +++ b/kernel/trace/trace.c
> > > @@ -2898,6 +2898,10 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
> > >  	else
> > >  		cpumask_clear_cpu(iter->cpu_file, tracing_reader_cpumask);
> > >  
> > > +
> > > +	if (iter->trace->pipe_open)
> > > +		iter->trace->pipe_close(iter);
> > > +
> > 
> > What's happen if pipe_close is NULL? Wny following straightforward check
> > is wrong?
> > I mean the above description explain pipe_close is only useful if plugin
> > allocate something at pipe_open. then allowing NULL seems natural.
> > 
> > 	if (iter->trace->pipe_close)
> > 		iter->trace->pipe_close(iter);
> 
> Ug, good point (stupid cut & paste should be illegal).
> 
> Ingo, I'll fix this up too in the next patch set. Want me to rebase it 
> or just start with this fix?

I'd suggest to start with a fix. Thanks,

	Ingo
