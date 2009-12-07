Return-Path: <linux-kernel-owner+w=401wt.eu-S964995AbZLGUxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964995AbZLGUxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964944AbZLGUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:53:38 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42150 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964928AbZLGUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:53:37 -0500
Date: Mon, 7 Dec 2009 15:53:41 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
	includes when defining CREATE_TRACE_POINTS
Message-ID: <20091207205341.GH8073@hmsreliant.think-freely.org>
References: <20091202191916.GA7589@hmsreliant.think-freely.org> <1259849726.12870.123.camel@gandalf.stny.rr.com> <20091203193549.GA18664@hmsreliant.think-freely.org> <1260216282.4845.3.camel@gandalf.stny.rr.com> <20091207201829.GG8073@hmsreliant.think-freely.org> <1260218831.3518.3.camel@gandalf.stny.rr.com> <1260218966.3518.4.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260218966.3518.4.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:49:26PM -0500, Steven Rostedt wrote:
> On Mon, 2009-12-07 at 15:47 -0500, Steven Rostedt wrote:
> 
> > > 
> > > Note this patch also converts the napi_poll tracepoint to a TRACE_EVENT.  This
> > > is done so that the TRACE_EVENT fix doesn't break the build, and because its
> > > rather pointless I think given the current tracing infrastructure to not have
> > > napi_poll be an independent event.
> > > 
> > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > 
> > Thanks, I'll give it a test. But because this now touches networking
> > code, I need an Acked-by from David Miller before I can pull it in.
> > 
> > -- Steve
> > 
> > 
> > 
> > > 
> > > 
> > > linux/tracepoint.h   |   45 +++++++++++++++++++++++----------------------
> > > trace/define_trace.h |    1 +
> > > trace/events/napi.h  |   25 ++++++++++++++++++++++---
> 
> Hmm, This really isn't networking code. But still, a patch that changes
> the way a networking trace point works, I would rather have an ack.
> 
> Thanks,
> 
Copy that, I agree an Ack from dave is called for here, but Just FYi, theres
only one user of this tracepoint currently in the tree (the drop monitor) and
this change has no bearing on it, as you can still hook the tracepoint with the
same register_trace_napi_poll call

Neil

> -- Steve
> 
> > > 3 files changed, 46 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > > index 2aac8a8..311abbf 100644
> > > --- a/include/linux/tracepoint.h
> > > +++ b/include/linux/tracepoint.h
> > > @@ -58,28 +58,6 @@ struct tracepoint {
> > >  		rcu_read_unlock_sched_notrace();			\
> > >  	} while (0)
> > >  
> 
> 
> 
