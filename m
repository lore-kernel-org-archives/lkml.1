Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbZDQPm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbZDQPm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbZDQPms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:42:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58171 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbZDQPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:42:47 -0400
Date: Fri, 17 Apr 2009 11:42:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 3/5] tracing/events: add rcu locking around trace event
 prints
In-Reply-To: <49E89E53.2010500@goop.org>
Message-ID: <alpine.DEB.2.00.0904171142010.14919@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416021928.467656424@goodmis.org> <alpine.DEB.2.00.0904171004210.14919@gandalf.stny.rr.com> <49E89E53.2010500@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 17 Apr 2009, Jeremy Fitzhardinge wrote:

> Steven Rostedt wrote:
> > Ted, is this patch still needed?
> > 
> > I'm starting to have second thoughts on this patch because it may require
> > adding: #include <linux/rcupdate.h> in include/trace/ftrace.h. Jeremy has
> > been struggling with include hell with these files.
> > 
> > Hmm, maybe this is not an issue because we undef CREATE_TRACE_POINTS before
> > calling this.
> > 
> > Jeremy,
> > 
> > Do you see a problem if we include linux/rcupdate.h in ftrace.h?
> > Remember, CREATE_TRACE_POINTS is undefined here.
> >   
> Hm, I don't think that matters; I'm seeing the #include problems when
> generating asm-offsets.h, which doesn't have CREATE_TRACE_POINTS set.
> 
> Or are you saying that you only need to include linux/rcupdate.h when
> CREATE_TRACE_POINTS is set?

Well, this part does not get called when CREATE_TRACE_POINTS is not set. 
And when it is called, it undefines it, so that other headers will not 
include this part.

-- Steve

