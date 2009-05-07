Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZEGNKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZEGNKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZEGNKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:10:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65516 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZEGNKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:10:31 -0400
Date: Thu, 7 May 2009 09:10:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] tracing/events: add rcu locking around trace event
 prints
In-Reply-To: <20090507113217.GK28398@elte.hu>
Message-ID: <alpine.DEB.2.00.0905070909020.32734@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416021928.467656424@goodmis.org> <alpine.DEB.2.00.0905062207370.24643@gandalf.stny.rr.com> <20090507113217.GK28398@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 7 May 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Somehow this patch got dropped. I believe Ted's work requires it.
> > 
> > I'm not sure if we need to include rcupdate.h or not to use 
> > rcu_read_lock. I think it may be fine to include it in ftrace.h. 
> > 
> > Jeremy, does this patch effect anything that you are doing?
> > 
> > >  									\
> > > +	rcu_read_lock();						\
> > >  	ret = trace_seq_printf(s, #call ": " print);			\
> > > +	rcu_read_unlock();						\
> > >  	if (!ret)							\
> > >  		return TRACE_TYPE_PARTIAL_LINE;				\
> 
> Hm, this patch adds usage for RCU primitives, but doesnt include 
> rcupdate.h.

Yeah, I thought that would be an issue. Including rcupdate here should not 
be an issue, since the ftrace.h file is only included once, and the 
CREATE_TRACE_POINTS is already undefined.

I'll write up a new patch.

Thanks,

-- Steve

