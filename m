Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbZIMRrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbZIMRrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 13:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbZIMRr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 13:47:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZIMRr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 13:47:26 -0400
Subject: Re: [PATCH 2/4] tracing/function-graph: x86_64 stack allocation
 cleanup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jiri Olsa <jolsa@redhat.com>
In-Reply-To: <20090913170517.GB4859@nowhere>
References: <20090913030543.204871396@goodmis.org>
	 <20090913030616.992539807@goodmis.org>  <20090913170517.GB4859@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sun, 13 Sep 2009 13:47:27 -0400
Message-Id: <1252864047.26049.923.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-13 at 19:05 +0200, Frederic Weisbecker wrote:
> On Sat, Sep 12, 2009 at 11:05:45PM -0400, Steven Rostedt wrote:
> > From: Jiri Olsa <jolsa@redhat.com>
> > 
> > Only 24 bytes needs to be reserved on the stack for the function graph
> > tracer on x86_64.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > LKML-Reference: <20090729085837.GB4998@jolsa.lab.eng.brq.redhat.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  arch/x86/kernel/entry_64.S |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index c251be7..d59fe32 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -146,7 +146,7 @@ ENTRY(ftrace_graph_caller)
> >  END(ftrace_graph_caller)
> >  
> >  GLOBAL(return_to_handler)
> > -	subq  $80, %rsp
> > +	subq  $24, %rsp
> 
> 
> That's theoretically a good fix.
> 
> But Steve, do you remember the weird issues we had while only
> saving the theoretically strict needed stack space here?
> 
> It made the function graph tracer crashing in x86-64, and we
> never found out why we needed to save more stack than needed.
> 
> Sorry that may sound like a FUD message but I can't explain
> the reason of this, and I fear we may met it again.
> 
> Well, at least that may help us finding out the real resons of
> such crashes, but...

I did not forget about them, and that's the reason that I did not apply
them in the beginning. But that was long ago, and we fixed lots of
issues. I remember hitting crashes with the patch too, but I've applied
this and ran it on those same machines and I no longer get those
crashes. Thus, my thinking is that we already fixed the bug that was
causing it.

Only way to know for sure is to apply it and let it out into the
wild ;-)

-- Steve


