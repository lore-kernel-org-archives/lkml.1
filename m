Return-Path: <linux-kernel-owner+w=401wt.eu-S934653AbZLPHqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934653AbZLPHqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbZLPHqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:46:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbZLPHqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:46:32 -0500
Date: Wed, 16 Dec 2009 08:46:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf_event: introduce 'perf timer' to analyze
	timer's behavior
Message-ID: <20091216074607.GB32713@elte.hu>
References: <4B27702F.1080507@cn.fujitsu.com>
 <20091215141533.GB5833@nowhere>
 <4B283596.2010801@cn.fujitsu.com>
 <20091216073248.GA32713@elte.hu>
 <4B288F04.5080108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B288F04.5080108@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> 
> 
> Ingo Molnar wrote:
> 
> >>>
> >> Yeah, it has different unit and looks ugly :-(
> >>
> >> but, the problem is we can't get HZ in userspace now, i'll export HZ by proc 
> >> or other way and rectify 'perf timer' output in my next work
> > 
> > We could export HZ as part of the ftrace event format file, in 
> > /debug/tracing/events/timers/ or so. Not sure what the best way would be to do 
> > it (without causing runtime overhead in event processing), but we should 
> > reduce our reliance on /proc and export such instrumentation information via a 
> > single, coherent interface.
> 
> Hi ingo,
> 
> Um, if we export this value in tracepoint format, it should add for every 
> timer's tracepoint.

Not if it's a special timer tracepoint 'HZ' dedicated for this. (We might even 
get events through it on dynticks kernels, or on dynamic-sched-tick systems 
[in the future] when the scheduler HZ value gets modified - or so.)

> > There's a couple of other 'system settings' values that would be useful to 
> > expose in such a way - for example the number of online CPUs. (in fact 
> > that could be exposed as a set of online/offline events plus a way to read 
> > the current count as well)
> 
> How about export those values in debugfs/tracing/*? perf tracepoint self 
> depend on this filesystem.

No - in the long run most of those APIs will go away, and what remains are the 
ftrace event format descriptors in essence. (Which we then might move to 
/proc/events/ or so.)

	Ingo
