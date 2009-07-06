Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZGFThw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZGFThw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZGFThp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:37:45 -0400
Received: from www.tglx.de ([62.245.132.106]:42092 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbZGFTho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:37:44 -0400
Date: Mon, 6 Jul 2009 21:37:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ftrace: add tracepoint for itimer
In-Reply-To: <20090706133108.GA7082@Krystal>
Message-ID: <alpine.LFD.2.00.0907062117590.19480@localhost.localdomain>
References: <4A51C5C2.20802@cn.fujitsu.com> <4A51C6F9.3080100@cn.fujitsu.com> <20090706133108.GA7082@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Mathieu Desnoyers wrote:
> * Xiao Guangrong (xiaoguangrong@cn.fujitsu.com) wrote:
> > +
> > +TRACE_EVENT(itimer_state,
> > +
> 
> Hrm, I'd reserve the use of the *_state namespace for something
> different if possible.

See below.

> In LTTng, we have the ability to list a set of data structures at trace
> start (we call this state dump). In this case, we could add a list of
> all active timers at trace start. This is useful if the trace started
> after timer inits.

Can you please spare us the gory details of LTTng. We already know
that it can do everything plus brewing coffee, so no need to advertise
it in every tracing related mail.

> So having "_state" without much meaning here might eventually be
> confusing.
> 
> "_action" or "_call" (like IPCs) might be more appropriate ?

Err, where is this an action or a call ? Care to look at the call site
of this tracepoint. It's at the end of do_setitimer() and records the
_state_ of the itimer _after_ the syscall was handled.

> Mathieu

Can you please remove the hundred lines you are not commenting on next
time ?
 
> > +	TP_PROTO(int which, struct itimerval *value, cputime_t expires),

Thanks,

	tglx
