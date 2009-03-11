Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZCKTpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZCKTpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZCKTpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:45:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49186 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZCKTpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:45:32 -0400
Subject: Re: [GIT PULL] tracing: use raw spinlocks for trace_vprintk
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0903111431080.3062@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903102125250.16494@gandalf.stny.rr.com>
	 <1236754764.22914.3680.camel@twins> <20090311182656.GA23739@elte.hu>
	 <alpine.DEB.2.00.0903111431080.3062@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 20:45:11 +0100
Message-Id: <1236800711.8192.707.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 14:32 -0400, Steven Rostedt wrote:
> On Wed, 11 Mar 2009, Ingo Molnar wrote:
> 
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Tue, 2009-03-10 at 21:26 -0400, Steven Rostedt wrote:
> > > 
> > > > commit 80370cb758e7ca2692cd9fb5e413d970b1f4b2b2
> > > > Author: Steven Rostedt <srostedt@redhat.com>
> > > > Date:   Tue Mar 10 17:16:35 2009 -0400
> > > > 
> > > >     tracing: use raw spinlocks for trace_vprintk
> > > >     
> > > >     Impact: prevent locking up by lockdep tracer
> > > >     
> > > >     The lockdep tracer uses trace_vprintk and thus trace_vprintk can not
> > > >     call back into lockdep without locking up.
> > > 
> > > Hmm, I did this when I posted the lockdep tracepoints, so someone then
> > > did a bad copy/paste job when renaming ftrace_printk or something?
> > > 
> > > See efed792d6738964f399a508ef9e831cd60fa4657
> > 
> > What's the conclusion in this thread? I'm holding the pull 
> > until there's agreement.
> 
> I believe the conclusion is that Peter's changes got removed when Frederic 
> removed the old printk version. But his new version did not have the 
> changes.
> 
> My changes are basically the same as Peter's except that I did not do 
> anything with the local_irq_save, since I do not think those are needed.
> 
> Peter,
> 
> Are you fine with the change? I guess it's up to you now.

Yeah, although I'd rather see the raw_local_irq_save() there too, but
the patch as it stands solves the problem.

