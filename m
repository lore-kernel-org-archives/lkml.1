Return-Path: <linux-kernel-owner+w=401wt.eu-S934673AbZLPHdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673AbZLPHdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934648AbZLPHdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:33:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45768 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934652AbZLPHdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:33:10 -0500
Date: Wed, 16 Dec 2009 08:32:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf_event: introduce 'perf timer' to analyze
	timer's behavior
Message-ID: <20091216073248.GA32713@elte.hu>
References: <4B27702F.1080507@cn.fujitsu.com>
 <20091215141533.GB5833@nowhere>
 <4B283596.2010801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B283596.2010801@cn.fujitsu.com>
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
> Frederic Weisbecker wrote:
> > On Tue, Dec 15, 2009 at 07:17:03PM +0800, Xiao Guangrong wrote:
> >> Hi,
> >>
> >> We introduce 'perf timer' in this patchset, it can analyze timer
> >> latency and timer function handle time, the usage and result is
> >> like below:
> >>
> >> # perf timer record
> >> # perf timer lat --print-lat --print-handle
> >> -------------------------------------------------------------------------------------------------------
> >> |   Timer            |   TYPE   |   Avg-latency  | Max-latency  |  Max-latency-at-TS |Max-lat-at-Task |
> >> |0xf7ad1f5c          |hrtimer   |996068.500    ns|1607650     ns|10270128658526      |init            |
> >> |0xf7903f04          |timer     |0.625         HZ|2           HZ|10270344082394      |swapper         |
> >> |0xf787a05c          |hrtimer   |200239.500    ns|359929      ns|10269316024808      |main            |
> >> |main      :[   PROF]|itimer    |0.000         HZ|0           HZ|10237021270557      |main            |
> >> |main      :[VIRTUAL]|itimer    |0.000         HZ|0           HZ|10257314773501      |main            |
> > 
> > 
> > 
> > Cool! This is really a good work and a good idea.
> > 
> > Just have some neats in mind. hrtimers and timers don't have the same latency and
> > granularity requirements.
> > 
> > As you show it, timers have an HZ granularity and hrtimers are about nanoseconds,
> > and mixing them up in the same array of latency report is too messy.
> > They don't have the same granularity/latency scope so they should
> > be reported separately.
> > 
> 
> Yeah, it has different unit and looks ugly :-(
> 
> but, the problem is we can't get HZ in userspace now, i'll export HZ by proc 
> or other way and rectify 'perf timer' output in my next work

We could export HZ as part of the ftrace event format file, in 
/debug/tracing/events/timers/ or so. Not sure what the best way would be to do 
it (without causing runtime overhead in event processing), but we should 
reduce our reliance on /proc and export such instrumentation information via a 
single, coherent interface.

There's a couple of other 'system settings' values that would be useful to 
expose in such a way - for example the number of online CPUs. (in fact that 
could be exposed as a set of online/offline events plus a way to read the 
current count as well)

	Ingo
