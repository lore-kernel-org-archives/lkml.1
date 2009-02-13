Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbZBMF4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbZBMF4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 00:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZBMF4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 00:56:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZBMF4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 00:56:33 -0500
Date: Fri, 13 Feb 2009 00:56:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] trace: use the more accurate parameter.
In-Reply-To: <20090211120507.GD23873@elte.hu>
Message-ID: <alpine.DEB.1.10.0902130053210.15469@gandalf.stny.rr.com>
References: <1234225804-13314-1-git-send-email-wenji.huang@oracle.com> <20090210152624.GH5836@nowhere> <20090211120507.GD23873@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Feb 2009, Ingo Molnar wrote:

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Feb 09, 2009 at 07:30:04PM -0500, Wenji Huang wrote:
> > > Pass tsk to __update_max_tr instead of current to avoid latent hazard.
> > > 
> > > Impact: clean up
> > > 
> > > Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> > > ---
> > >  kernel/trace/trace.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > > index 5b1e9a9..c1592f1 100644
> > > --- a/kernel/trace/trace.c
> > > +++ b/kernel/trace/trace.c
> > > @@ -335,7 +335,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
> > >  	data->rt_priority = tsk->rt_priority;
> > >  
> > >  	/* record this tasks comm */
> > > -	tracing_record_cmdline(current);
> > > +	tracing_record_cmdline(tsk);
> > >  }
> > 
> > 
> > Indeed. At this stage, tsk is the next task in the middle of a context
> > switch. So I guess current is right, but this is more proper to use tsk.
> 
> Rename it to 'next' then please.

I'm sorry, I missed this comment, and only notice it because of Wenji's 
latest patches.

For the __update_max_tr used by irqsoff, this is not the case. The 
update_max_tr is just to make a snapshot of the latest max. The 
irq/preempt latency tracers do not use the sched switch to record comms, 
especially since it only cares when a new max happens. There is no concept 
of a 'next' task.

I think the proper name is 'task'.

-- Steve

