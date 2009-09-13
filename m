Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbZIMRzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbZIMRzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 13:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZIMRzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 13:55:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:58703 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZIMRzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 13:55:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GFp99faLMevuMsVXBp4vLR2NaqJtiAsmjQ2zcz3FFB4kniDCSHRr/omiybkOeLnKXt
         mLHJNclCQpGJILigrWOt7iP+1QXMN/g2dE+ne0HlD9AQ60mF9mi84JruCzg0EE930h6L
         Kz/z43BxdXLvi9ZWaUq0+c+YtCWg/bdXqdt2Y=
Date: Sun, 13 Sep 2009 19:55:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/4] tracing/function-graph: x86_64 stack allocation
	cleanup
Message-ID: <20090913175504.GC5030@nowhere>
References: <20090913030543.204871396@goodmis.org> <20090913030616.992539807@goodmis.org> <20090913170517.GB4859@nowhere> <1252864047.26049.923.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252864047.26049.923.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13, 2009 at 01:47:27PM -0400, Steven Rostedt wrote:
> On Sun, 2009-09-13 at 19:05 +0200, Frederic Weisbecker wrote:
> > On Sat, Sep 12, 2009 at 11:05:45PM -0400, Steven Rostedt wrote:
> > > From: Jiri Olsa <jolsa@redhat.com>
> > > 
> > > Only 24 bytes needs to be reserved on the stack for the function graph
> > > tracer on x86_64.
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > > LKML-Reference: <20090729085837.GB4998@jolsa.lab.eng.brq.redhat.com>
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > ---
> > >  arch/x86/kernel/entry_64.S |    6 +++---
> > >  1 files changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > > index c251be7..d59fe32 100644
> > > --- a/arch/x86/kernel/entry_64.S
> > > +++ b/arch/x86/kernel/entry_64.S
> > > @@ -146,7 +146,7 @@ ENTRY(ftrace_graph_caller)
> > >  END(ftrace_graph_caller)
> > >  
> > >  GLOBAL(return_to_handler)
> > > -	subq  $80, %rsp
> > > +	subq  $24, %rsp
> > 
> > 
> > That's theoretically a good fix.
> > 
> > But Steve, do you remember the weird issues we had while only
> > saving the theoretically strict needed stack space here?
> > 
> > It made the function graph tracer crashing in x86-64, and we
> > never found out why we needed to save more stack than needed.
> > 
> > Sorry that may sound like a FUD message but I can't explain
> > the reason of this, and I fear we may met it again.
> > 
> > Well, at least that may help us finding out the real resons of
> > such crashes, but...
> 
> I did not forget about them, and that's the reason that I did not apply
> them in the beginning. But that was long ago, and we fixed lots of
> issues. I remember hitting crashes with the patch too, but I've applied
> this and ran it on those same machines and I no longer get those
> crashes. Thus, my thinking is that we already fixed the bug that was
> causing it.
> 
> Only way to know for sure is to apply it and let it out into the
> wild ;-)


Ok, fine then :)

