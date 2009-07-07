Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZGGOKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZGGOKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZGGOKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:10:12 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:56711 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754619AbZGGOKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:10:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtkEAL/xUkpMQWU3/2dsb2JhbACBUcxIhBMF
Date: Tue, 7 Jul 2009 10:06:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ftrace: add tracepoint for itimer
Message-ID: <20090707140600.GA5178@Krystal>
References: <4A51C5C2.20802@cn.fujitsu.com> <4A51C6F9.3080100@cn.fujitsu.com> <20090706133108.GA7082@Krystal> <alpine.LFD.2.00.0907062117590.19480@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907062117590.19480@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:52:03 up 129 days, 10:18,  3 users,  load average: 0.59, 0.79,
	0.80
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Mon, 6 Jul 2009, Mathieu Desnoyers wrote:
> > * Xiao Guangrong (xiaoguangrong@cn.fujitsu.com) wrote:
> > > +
> > > +TRACE_EVENT(itimer_state,
> > > +
> > 
> > Hrm, I'd reserve the use of the *_state namespace for something
> > different if possible.
> 
> See below.
> 
> > In LTTng, we have the ability to list a set of data structures at trace
> > start (we call this state dump). In this case, we could add a list of
> > all active timers at trace start. This is useful if the trace started
> > after timer inits.
> 
> Can you please spare us the gory details of LTTng. We already know
> that it can do everything plus brewing coffee, so no need to advertise
> it in every tracing related mail.
> 
> > So having "_state" without much meaning here might eventually be
> > confusing.
> > 
> > "_action" or "_call" (like IPCs) might be more appropriate ?
> 
> Err, where is this an action or a call ? Care to look at the call site
> of this tracepoint. It's at the end of do_setitimer() and records the
> _state_ of the itimer _after_ the syscall was handled.
> 

Hrm, right. The patch context misled me. I thought it was at the end of
it_real_fn(), but it's actually in do_setitimer().

OK, looking at it from it's actual context, it makes perfect sense to
name it that way.

And it could even be used as-is to iterate on all timers at trace start
as we do in this tracer I won't name. ;-)

BTW, I was merely pointing out the risk of a name clash here. And I
had to refer to the tree where this piece of code exists to support the
point. My intent was not to advertise anything.

> > Mathieu
> 
> Can you please remove the hundred lines you are not commenting on next
> time ?
>  

OK,

Thanks,

Mathieu

> > > +	TP_PROTO(int which, struct itimerval *value, cputime_t expires),
> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
