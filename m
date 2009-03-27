Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbZC0WI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbZC0WI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZC0WIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:08:07 -0400
Received: from www.tglx.de ([62.245.132.106]:33695 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZC0WIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:08:06 -0400
Date: Fri, 27 Mar 2009 23:05:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 6/9] LTTng instrumentation - timer
In-Reply-To: <20090324204719.GA24320@elte.hu>
Message-ID: <alpine.LFD.2.00.0903272303580.3397@localhost.localdomain>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.754766083@polymtl.ca> <20090324182122.GG31117@elte.hu> <alpine.LFD.2.00.0903242011520.29264@localhost.localdomain> <20090324204719.GA24320@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Mar 2009, Ingo Molnar wrote:

> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Tue, 24 Mar 2009, Ingo Molnar wrote:
> > > the init methods are missing from your patch entirely - and the rest 
> > > is partially incomplete as well.
> > > 
> > > Instrumentation of the del_timer() variants is missing. For a 
> > > complete lifetime analysis of timers this cannot be left out.
> > 
> > Look at the debugobjects hooks. They cover the complete timer life 
> > time already.
> > 
> > Piggypacking tracepoints on those would simplify maintenance and 
> > reduce the number of extra lines in the code.
> 
> makes sense. They dont cover itimers nor hrtimers though.

They cover all (hr)timers independent of the call site. And we really
do not need any freaking call site instrumented.

The CPU* timer stuff is a different playground and needs to be
instrumented separate.

Thanks,

	tglx
