Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZJTGwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZJTGwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZJTGwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:52:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35757 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZJTGwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:52:23 -0400
Date: Tue, 20 Oct 2009 08:51:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
	probe and kprobe-tracer bugfixes
Message-ID: <20091020065151.GM8550@elte.hu>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <20091019110055.GA5549@nowhere> <20091019112125.GA12829@elte.hu> <4ADCC348.2020800@redhat.com> <4ADCEE1B.40003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADCEE1B.40003@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Masami Hiramatsu wrote:
> > Ingo Molnar wrote:
> >> For example you might want to probe the point within schedule that calls
> >> switch_mm() - this could be done via:
> >>
> >>    perf probe schedule@switch_mm
> >>
> >> Or the point where 'next' gets assigned? Sure, you dont need to even
> >> open the editor, if you know the rough outline of the function you can
> >> probe it via:
> >>
> >>    perf probe schedule@'next ='
> >>
> >> Note that i was able to specify both probes without having opened an
> >> editor - just based on the general knowledge of the scheduler.
> > 
> > It may be useful for return probe too :-)
> > 
> >  perf probe schedule@return
> 
> Hmm, IMHO,
> 
> >>    perf probe schedule@switch_mm
> 
> might be confused as 'probe schedule() called from switch_mm()'.
> 
> BTW, there might be several local/inline functions which have
> same name.
> I think we'd better provide a syntax for solving this issue.
> And current syntax uses @ for this purpose as below.
> 
>  perf probe localfunc@file
> 
> Maybe, we still can use % for special matching,
> 
>  perf probe schedule%switch_mm
> 
> These can be combined with each other, as below.
> 
>  perf probe schedule@kernel/sched.c%switch_mm
> 
> Or, supporting lazy string pattern matching
>  (reusing glob matching in ftrace?)
> 
>  perf probe schedule:'switch_mm(*);'
> 
> Just my thought.

I'm not attached to any particular form of syntax here (other than it 
should be simple and obvious) - we can try and see how it works out.

	Ingo
