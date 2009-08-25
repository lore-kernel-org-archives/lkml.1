Return-Path: <linux-kernel-owner+w=401wt.eu-S932294AbZHYW7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbZHYW7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 18:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932254AbZHYW7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 18:59:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62446 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248AbZHYW7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 18:59:50 -0400
Date: Tue, 25 Aug 2009 18:59:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Neil Horman <nhorman@tuxdriver.com>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] trace_events: fix the include file dependencies
In-Reply-To: <20090825133029.GB6114@nowhere>
Message-ID: <alpine.DEB.2.00.0908251856381.1763@gandalf.stny.rr.com>
References: <4A937EF5.4040505@cn.fujitsu.com> <4A937F5E.3020802@cn.fujitsu.com> <20090825133029.GB6114@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 25 Aug 2009, Frederic Weisbecker wrote:

> On Tue, Aug 25, 2009 at 02:06:22PM +0800, Xiao Guangrong wrote:
> > The TRACE_EVENT depend on the include/linux/tracepoint.h first
> > and include/trace/ftrace.h later, if we include the ftrace.h early,
> > It'll occur building error, like blow:
> > 
> > Both define TRACE_EVENT in trace_a.h and trace_b.h, if we include
> > those in .c file, like this:
> > 
> > #define CREATE_TRACE_POINTS
> > include <trace/events/trace_a.h>
> > include <trace/events/trace_b.h>
> > 
> > There are can't work,  because the TRACE_EVENT has re-defined by
> > the previous .h file
> > 
> > Reported-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > ---
> >  include/linux/tracepoint.h   |    3 +--
> >  include/trace/define_trace.h |    1 +
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index 5984ed0..8170985 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -180,6 +180,7 @@ static inline void tracepoint_synchronize_unregister(void)
> >  }
> >  
> >  #define PARAMS(args...) args
> > +#endif
> 
> 
> Please add a comment to explain what your endifs are closing, that helps
> for reviews. Especially while walking on such complicated header files,
> it's a crutch.
> 
> I guess this one closes _LINUX_TRACEPOINT_H, right?

This needs a lot more than a simple /* _LINUX_TRACEPOINT_H */ comment. It 
needs a nice explanation to why this is happening. This is a global header 
(located in include/linux), when it does something out of the norm, it 
needs a nice comment to explain why.

I'll pull this in and add a separate commit that adds the comment.

Thanks!

-- Steve

