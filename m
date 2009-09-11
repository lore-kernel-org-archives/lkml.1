Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbZIKOMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbZIKOMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZIKOMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:12:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbZIKOML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:12:11 -0400
Subject: Re: [PATCH 2/3] tracing/profile: add ref count for registering
 profile events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <1252677861.7126.32.camel@laptop>
References: <20090911135452.866274568@goodmis.org>
	 <20090911135626.421489476@goodmis.org>  <1252677861.7126.32.camel@laptop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 10:12:13 -0400
Message-Id: <1252678333.18996.667.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 16:04 +0200, Peter Zijlstra wrote:
> On Fri, 2009-09-11 at 09:54 -0400, Steven Rostedt wrote:
> 
> > +#ifdef MODULE
> > +# define event_trace_up_ref()					\
> > +	do {							\
> > +		if (!try_module_get(THIS_MODULE)) {		\
> > +			atomic_dec(&event_call->profile_count);	\
> > +			return -ENOENT;				\
> > +		}						\
> > +	} while (0)
> > +# define event_trace_down_ref() module_put(THIS_MODULE)
> > +#else
> > +# define event_trace_up_ref() do { } while (0)
> > +# define event_trace_down_ref() do { } while (0)
> > +#endif
> 
> That's like truely gruesomely ugly.
> 
> At the very least write it like:
> 
> int event_trace_up_ref(struct ftrace_event_call *call)
> {
> 	if (!try_module_get(THIS_MODULE)) {
> 		atomic_dev(&call->profile_count);
> 		return -ENOENT;
> 	}
> 	return 0;
> }

OK, I'll replace the MACROS with static inline, rebase and resend.

Ingo, don't pull that yet.

-- Steve


