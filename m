Return-Path: <linux-kernel-owner+w=401wt.eu-S965007AbZLGUtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007AbZLGUtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935268AbZLGUtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:49:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935253AbZLGUtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:49:21 -0500
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
 includes when defining CREATE_TRACE_POINTS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1260218831.3518.3.camel@gandalf.stny.rr.com>
References: <20091202191916.GA7589@hmsreliant.think-freely.org>
	 <1259849726.12870.123.camel@gandalf.stny.rr.com>
	 <20091203193549.GA18664@hmsreliant.think-freely.org>
	 <1260216282.4845.3.camel@gandalf.stny.rr.com>
	 <20091207201829.GG8073@hmsreliant.think-freely.org>
	 <1260218831.3518.3.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 07 Dec 2009 15:49:26 -0500
Message-Id: <1260218966.3518.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 15:47 -0500, Steven Rostedt wrote:

> > 
> > Note this patch also converts the napi_poll tracepoint to a TRACE_EVENT.  This
> > is done so that the TRACE_EVENT fix doesn't break the build, and because its
> > rather pointless I think given the current tracing infrastructure to not have
> > napi_poll be an independent event.
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Thanks, I'll give it a test. But because this now touches networking
> code, I need an Acked-by from David Miller before I can pull it in.
> 
> -- Steve
> 
> 
> 
> > 
> > 
> > linux/tracepoint.h   |   45 +++++++++++++++++++++++----------------------
> > trace/define_trace.h |    1 +
> > trace/events/napi.h  |   25 ++++++++++++++++++++++---

Hmm, This really isn't networking code. But still, a patch that changes
the way a networking trace point works, I would rather have an ack.

Thanks,

-- Steve

> > 3 files changed, 46 insertions(+), 25 deletions(-)
> > 
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index 2aac8a8..311abbf 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -58,28 +58,6 @@ struct tracepoint {
> >  		rcu_read_unlock_sched_notrace();			\
> >  	} while (0)
> >  


