Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbZBKMFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbZBKMFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZBKMFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:05:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42748 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbZBKMFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:05:16 -0500
Date: Wed, 11 Feb 2009 13:05:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Wenji Huang <wenji.huang@oracle.com>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: [PATCH 1/1] trace: use the more accurate parameter.
Message-ID: <20090211120507.GD23873@elte.hu>
References: <1234225804-13314-1-git-send-email-wenji.huang@oracle.com> <20090210152624.GH5836@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210152624.GH5836@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Feb 09, 2009 at 07:30:04PM -0500, Wenji Huang wrote:
> > Pass tsk to __update_max_tr instead of current to avoid latent hazard.
> > 
> > Impact: clean up
> > 
> > Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> > ---
> >  kernel/trace/trace.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 5b1e9a9..c1592f1 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -335,7 +335,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
> >  	data->rt_priority = tsk->rt_priority;
> >  
> >  	/* record this tasks comm */
> > -	tracing_record_cmdline(current);
> > +	tracing_record_cmdline(tsk);
> >  }
> 
> 
> Indeed. At this stage, tsk is the next task in the middle of a context
> switch. So I guess current is right, but this is more proper to use tsk.

Rename it to 'next' then please.

	Ingo
