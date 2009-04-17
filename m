Return-Path: <linux-kernel-owner+w=401wt.eu-S1761957AbZDQQlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957AbZDQQlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761397AbZDQQlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:41:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64886 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbZDQQlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:41:35 -0400
Date: Fri, 17 Apr 2009 12:41:33 -0400 (EDT)
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
In-Reply-To: <49E8AF03.6070509@goop.org>
Message-ID: <alpine.DEB.2.00.0904171240450.14919@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416021928.467656424@goodmis.org> <alpine.DEB.2.00.0904171004210.14919@gandalf.stny.rr.com> <20090417161820.GA26479@mit.edu> <49E8AF03.6070509@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 17 Apr 2009, Jeremy Fitzhardinge wrote:

> Theodore Tso wrote:
> > I haven't been following all of the e-mail threads about the include
> > hell problem; what are the issues, exactly?  What's the problem with
> > simply including <linux/rcuupdate.h>, and any needed prequisites in
> > ftrace.h?
> 
> I'm adding tracing support to paravirt.h, which in turn gets included in
> various low-level arch/x86 headers.  If it starts including other high-level
> linux/ headers, we quickly get into deep #include recursion problems and
> undefined symbols.

I think our final solution of the:

#ifdef CREATE_FOO_TRACE_POINTS
#undef CREATE_FOO_TRACE_POINTS
#include <trace/define_trace.h>
#endif

would fix this for us.

-- Steve

