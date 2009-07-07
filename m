Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbZGGRkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbZGGRkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZGGRj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:39:56 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:56965 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZGGRjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UgFGPqFk4097eM+VN4KP2ATQISWuOxPBf9fVeAhEZ91XuQFUtzljZrBY9egP+Qcpk4
         4oBpf+KEFAr93APY2af28LfQyL/jBS9zzk3xeyRAzpiKoS4R4Xdu1Q/S0HqVHFhR5Mv8
         +3C6aVcl0nahRA8bk1aiRRDoasAph3bWuFV+4=
Date: Tue, 7 Jul 2009 19:39:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ftrace: add tracepoint for timer
Message-ID: <20090707173948.GC6184@nowhere>
References: <4A51C5C2.20802@cn.fujitsu.com> <4A51C653.4040401@cn.fujitsu.com> <alpine.LFD.2.00.0907062140010.19480@localhost.localdomain> <4A531532.4010803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A531532.4010803@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 05:28:18PM +0800, Xiao Guangrong wrote:
> 
> 
> Thomas Gleixner wrote:
> > On Mon, 6 Jul 2009, Xiao Guangrong wrote:
> >> Changelog v1->v2:
> >> 1: Add jiffies info into timer
> >> 2: Combine debugobjects and trace as Thomas's suggestion
> > 
> > I like it that way. Some minor nitpicks below.
> >  
> >> +TRACE_EVENT(timer_expire,
> >> +
> >> +	TP_PROTO(struct timer_list *timer),
> >> +
> >> +	TP_ARGS(timer),
> >> +
> >> +	TP_STRUCT__entry(
> >> +		__field( void *,	timer		)
> >> +		__field( void *,	function	)
> > 
> >   Do we really need the function here? It does not change between
> >   start and expiry.
> > 
> 
> Yeah, I'll fix.
> 
> >> +TRACE_EVENT(timer_cancel,
> >> +
> >> +	TP_PROTO(struct timer_list *timer),
> >> +
> >> +	TP_ARGS(timer),
> >> +
> >> +	TP_STRUCT__entry(
> >> +		__field( void *,	timer		)
> >> +		__field( void *,	function	)
> > 
> >   Ditto.
> > 
> 
> Will fix.
> 
> >> +
> >> +static inline void debug_and_trace_timer_expire(struct timer_list *timer)
> > 
> >   Technically not really necessary. The debug code does not care about
> >   it.
> > 
> 
> Will fix.
> 
> >>  			timer = list_first_entry(head, struct timer_list,entry);
> >> +			debug_and_trace_timer_expire(timer);
> >>  			fn = timer->function;
> >>  			data = timer->data;
> >>  
> > 
> > Can you please add the tracepoint which was suggested by Anton (IIRC)
> > which allows us to measure the execution time of the callback function
> > ? There is no need to dereference timer in the expiry tracepoint, we
> > just store the pointer. So we can safely move the tracepoints just
> > around the function call.
> > 
> >    trace_timer_expire(timer);
> >    fn(data);
> >    trace_timer_callback_done(timer);
> > 
> > Or whatever fancy name you come up with.
> > 
> 
> OK, I'll fix it base on your suggestion.
>  
> trace_timer_expire/trace_timer_callback_done are already in Frederic' tree
> but with different name, see below URL:
>  	http://marc.info/?l=linux-kernel&m=124331396919301&w=2
>  
> I'll modify those tracepoint's name to match ours.
>  
> Thank you very much!
>  
> Xiao


If you wish so, I can gather your patches with the one of Anton Blanchard
and send a pull request once it's acked.

Thanks,
Frederic.

