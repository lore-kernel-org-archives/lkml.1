Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYJFU52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYJFU52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYJFU5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:57:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:58971 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbYJFU5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:57:19 -0400
Date: Mon, 6 Oct 2008 13:57:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power
 optimization
Message-ID: <20081006135715.6a52e954@infradead.org>
In-Reply-To: <87y711moz2.fsf@basil.nowhere.org>
References: <20081006102640.481acd23@infradead.org>
	<87y711moz2.fsf@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Oct 2008 22:46:09 +0200
Andi Kleen <andi@firstfloor.org> wrote:
> >  
> > +	trace_power_mark(&it, POWER_PSTATE, next_perf_state);
> 
> Wouldn't that be better higher up in the cpufreq system?  It would
> seem bad to duplicate that in all low level cpufreq modules.

the problem is that higher up the actual P state isn't known.

> 
> Also I suspect some higher level format would be good here too.
> Just put the frequency in? 

the link between P states and frequency is... rather lose.
Especially with Turbo Mode it no longer is really relevant to list
frequencies.

> > +			ret = trace_seq_printf(s, "[%5ld.%09ld]
> > CSTATE: Going to C%i on cpu %i for %ld.%09ld\n",
> > +					  stamp.tv_sec,
> > +					  stamp.tv_nsec,
> > +					  it->state, iter->cpu,
> > +					  duration.tv_sec,
> > +					  duration.tv_nsec);
> > +		if (it->type == POWER_PSTATE)
> > +			ret = trace_seq_printf(s, "[%5ld.%09ld]
> > PSTATE: Going to P%i on cpu %i\n",
> > +					  stamp.tv_sec,
> > +					  stamp.tv_nsec,
> > +					  it->state, iter->cpu);
> 
> I suspect a less verbose output format would be better.
why?
It's fine as it is, and it's actually human readable as well.

> 
> > +{
> > +	if (!trace_power_enabled)
> > +		return;
> > +
> > +	memset(it, 0, sizeof(struct power_trace));
> 
> The memset seems redundant.

it's free and it initializes the datastructure cleanly; and only when
the tracer is in use.

> 

> Hmm, that does a unconditional wake_up() in idle. Doesn't this cause
> a loop on UP?
> 
> idle -> wakeup -> idle -> wakeup -> ... etc.
> 
> Am I missing something?

yes you're missing something ;-)
this code is called when going out of idle, not when going into idle.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
