Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbYISIoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbYISIoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYISIo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:44:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34030 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYISIo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:44:26 -0400
Date: Fri, 19 Sep 2008 10:44:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
Message-ID: <20080919084412.GD17592@elte.hu>
References: <fa.vMKgvqjqmYnI2J40GHoTENeYm8U@ifi.uio.no> <fa.808p0ZtU9DCpeky4KfNS8Drdw9w@ifi.uio.no> <48D17B47.7080704@yahoo.com> <20080917145400.29d1809c@infradead.org> <1221705739.15314.20.camel@lappy.programming.kicks-ass.net> <48D29D11.2030406@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D29D11.2030406@yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> Peter Zijlstra wrote:
>> What you can do to investigate this, is use the sched_wakeup tracer from
>> ftrace, that should give a function trace of the highest wakeup latency
>> showing what the kernel is doing.
>
> I struggled to find documentation of ftrace because it's quite new. I  
> have come across  
> http://www.redhat.com/docs/en-US/Red_Hat_Enterprise_MRG/1.0/html/Realtime_Tuning_Guide/sect-Realtime_Tuning_Guide-Realtime_Specific_Tuning-Using_the_ftrace_Utility_for_Tracing_Latencies.html 
> and  
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/ftrace.txt;h=d330fe3103da9c9a3cb8f888ac7255ce48e666d4;hb=45e9c0de2e86485f8b6633fd64ab19cfbff167f6 
>  .
>
> Thanks to those I started up the debugfs filesystem and went to the  
> trace directories but the on tracers in available_tracers are
> ftrace sched_switch none
>
> I can't see anything in the code that would disable wakeup... Any ideas  
> on what might be wrong? I'm using a 2.6.27rc6 kernel.

here's two quick howtos:

  http://redhat.com/~mingo/sched-devel.git/readme-tracer.txt
  http://redhat.com/~mingo/sched-devel.git/howto-trace-latencies.txt

you need to enable:

  CONFIG_SCHED_TRACER=y
  CONFIG_CONTEXT_SWITCH_TRACER=y

it's not particularly well named though. Why doesnt it say 
LATENCY_TRACER or something?

> Additionally I think I found a trigger - unplugging the power cable 
> from the EeePC and having it run on battery seems to then set off this 
> periodic stall every 30 seconds... There's no CPU frequency scaling 
> enabled either (Celeron M's seemingly don't have P states and support 
> for cpufreq is configured out).

sounds like potential SMM triggered latencies.

	Ingo
