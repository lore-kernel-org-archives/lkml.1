Return-Path: <linux-kernel-owner+w=401wt.eu-S934379AbZJMVQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379AbZJMVQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934368AbZJMVQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:16:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64518 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934366AbZJMVQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:16:50 -0400
Subject: Re: [PATCH 2/5] [PATCH 2/5] tracing: export symbols for kernel
 lock tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091013204345.GA5135@nowhere>
References: <20091013203349.814936710@goodmis.org>
	 <20091013203425.342967518@goodmis.org>  <20091013204345.GA5135@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 13 Oct 2009 17:14:51 -0400
Message-Id: <1255468491.7113.2409.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 22:43 +0200, Frederic Weisbecker wrote:
> On Tue, Oct 13, 2009 at 04:33:51PM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The big kernel lock tracepoints are used inside modules and they need
> > to be exported accordingly.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  lib/kernel_lock.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
> > index 4ebfa5a..76f05bc 100644
> > --- a/lib/kernel_lock.c
> > +++ b/lib/kernel_lock.c
> > @@ -139,3 +139,5 @@ void __lockfunc _unlock_kernel(const char *func, const char *file, int line)
> >  EXPORT_SYMBOL(_lock_kernel);
> >  EXPORT_SYMBOL(_unlock_kernel);
> >  
> > +EXPORT_TRACEPOINT_SYMBOL(lock_kernel);
> > +EXPORT_TRACEPOINT_SYMBOL(unlock_kernel);
> > -- 
> 
> 
> I remember when you showed me this patch, and it fixed a real
> issue because we had the tracepoint call in smp_lock.h:
> 
> #define lock_kernel()	\
> 	trace_lock_kernel(__FUNC__, __FILE__, __LINE__);	\
> 	_lock_kernel();						\
> 
> So indeed the modules needed this missing export. But I had
> to move the tracepoint calls to lib/kernel_lock.c instead,
> because we had very bad headers dependencies.
> 
> So it's not needed anymore.

Ah, I missed that change. I've had this queued up for a while.

Ingo, want me to rebase and remove this patch?

-- Steve


