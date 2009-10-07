Return-Path: <linux-kernel-owner+w=401wt.eu-S933811AbZJGNUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811AbZJGNUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933714AbZJGNUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:20:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37591 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453AbZJGNUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:20:13 -0400
Subject: Re: [PATCH] fix a warning on kernel/trace/trace_branch.c
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "Helight.Xu" <helight.xu@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4ACC45B9.6070202@gmail.com>
References: <20091007063921.GA19756@helight>
	 <4ACC3C9D.9040106@cn.fujitsu.com>  <4ACC45B9.6070202@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 09:18:14 -0400
Message-Id: <1254921494.1696.133.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 15:39 +0800, Helight.Xu wrote:
> Li Zefan wrote:
> > Zhenwen Xu wrote:
> >   
> >> fix this warning:
> >>
> >> kernel/trace/trace_branch.c: In function ‘probe_likely_condition’:
> >> kernel/trace/trace_branch.c:58: warning: passing argument 1 of ‘
> >> trace_buffer_lock_reserve’ from incompatible pointer type
> >>
> >> The "tr" should be "(struct buffer *)tr" or "tr->buffer" here!!!
> >>
> >>     
> >
> > It's caused by the API change of trace_buffer_lock_reserve() by
> > commit e77405ad80f53966524b5c31244e13fbbbecbd84.
> >
> > Could you send an updated patch to also fix the same bug
> > in kernel/trace/trace_hw_branch.c ?
> >   
> Roger that!

Thanks!

I'll pull in this fix now. You can just send a separate patch with the
other fix.

-- Steve

> >   
> >> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
> >> ---
> >>  kernel/trace/trace_branch.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> >> index 7a7a9fd..216e2dd 100644
> >> --- a/kernel/trace/trace_branch.c
> >> +++ b/kernel/trace/trace_branch.c
> >> @@ -54,7 +54,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
> >>  		goto out;
> >>  
> >>  	pc = preempt_count();
> >> -	event = trace_buffer_lock_reserve(tr, TRACE_BRANCH,
> >> +	event = trace_buffer_lock_reserve(tr->buffer, TRACE_BRANCH,
> >>  					  sizeof(*entry), flags, pc);
> >>  	if (!event)
> >>  		goto out;
> >>     
> >
> >
> >   
> 
> 

