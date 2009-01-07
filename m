Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbZAGCma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbZAGCma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZAGCmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:42:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZAGCmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:42:20 -0500
Date: Tue, 6 Jan 2009 21:42:17 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       roel.kluin@gmail.com, pq@iki.fi, srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: convert unsigned index to signed
In-Reply-To: <20090106145007.ceb20f16.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901062138520.25237@gandalf.stny.rr.com>
References: <20090106223337.677427397@goodmis.org> <20090106223405.302758015@goodmis.org> <20090106145007.ceb20f16.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 6 Jan 2009, Andrew Morton wrote:

> On Tue, 06 Jan 2009 17:33:38 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: fix to unsigned compared to less than zero
> > 
> > Roel Kluin pointed out that there is a compare of an unsigned number
> > to less than zero. A previous clean up had the unsigned index set
> > to -1 for certain cases, but never converted it to signed.
> > 
> > Frederic Weisbecker noticed that another index is used to compare
> > the above index to and it also needs to be converted to signed.
> > 
> > Reported-by: Roel Kluin <roel.kluin@gmail.com>
> > Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  kernel/trace/ftrace.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 2f32969..3576707 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -289,7 +289,7 @@ static DEFINE_MUTEX(ftrace_regex_lock);
> >  
> >  struct ftrace_page {
> >  	struct ftrace_page	*next;
> > -	unsigned long		index;
> > +	long			index;
> 
> Does that actually need to be a long type?

No, I think I just automatically typed "unsigned long" before, and here
I just removed the unsigned. It can also be an int. It only indexes what 
is on a page.


> 
> >  	struct dyn_ftrace	records[];
> >  };
> >  
> > @@ -786,7 +786,7 @@ enum {
> >  
> >  struct ftrace_iterator {
> >  	struct ftrace_page	*pg;
> > -	unsigned		idx;
> > +	int			idx;
> 
> because we have
> 
>         if (iter->idx >= iter->pg->index) {
> 
> Are 32-bit types actually more efficient than 64-bit types on any
> 64-bit hardware which we care about?  

They both should always be way less than 2^31, so they both can be int.

Thanks, I'll fix this one up. I don't think Ingo pulled it yet.

-- Steve

