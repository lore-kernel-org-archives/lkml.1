Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbZEHLbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbZEHLbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZEHLbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:31:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZEHLbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:31:45 -0400
Date: Fri, 8 May 2009 13:31:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ring-buffer: change WARN_ON from checking
	preempt_count to preemptible
Message-ID: <20090508113136.GK11596@elte.hu>
References: <20090508043250.372421144@goodmis.org> <20090508043331.726786617@goodmis.org> <20090507215427.4256cc3c.akpm@linux-foundation.org> <alpine.DEB.2.00.0905080653110.28378@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905080653110.28378@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 
> On Thu, 7 May 2009, Andrew Morton wrote:
> 
> > On Fri, 08 May 2009 00:32:54 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > There's a WARN_ON in the ring buffer code that makes sure preemption
> > > is disabled. It checks "!preempt_count()". But when CONFIG_PREEMPT is not
> > > enabled, preempt_count() is always zero, and this will trigger the warning.
> > > 
> > > [ Impact: prevent false warning on non preemptible kernels ]
> > > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > ---
> > >  kernel/trace/ring_buffer.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > > index 3ae5ccf..3611706 100644
> > > --- a/kernel/trace/ring_buffer.c
> > > +++ b/kernel/trace/ring_buffer.c
> > > @@ -1688,7 +1688,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
> > >  	 * committed yet. Thus we can assume that preemption
> > >  	 * is still disabled.
> > >  	 */
> > > -	RB_WARN_ON(buffer, !preempt_count());
> > > +	RB_WARN_ON(buffer, preemptible());
> > >  
> > >  	cpu = smp_processor_id();
> > >  	cpu_buffer = buffer->buffers[cpu];
> > 
> > smp_processor_id() will warn too.
> > 
> 
> The difference is that RB_WARN_ON also disables the ring buffer.

Yes, it's a more robust form of warning, in this context.

	Ingo
