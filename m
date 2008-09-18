Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbYIRSZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbYIRSZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYIRSZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:25:29 -0400
Received: from pih-relay05.plus.net ([212.159.14.18]:35594 "EHLO
	pih-relay05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbYIRSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:25:28 -0400
Message-ID: <48D29D11.2030406@yahoo.com>
Date: Thu, 18 Sep 2008 19:25:21 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: How how latent should non-preemptive scheduling be?
References: <fa.vMKgvqjqmYnI2J40GHoTENeYm8U@ifi.uio.no>	 <fa.808p0ZtU9DCpeky4KfNS8Drdw9w@ifi.uio.no> <48D17B47.7080704@yahoo.com>	 <20080917145400.29d1809c@infradead.org> <1221705739.15314.20.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1221705739.15314.20.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 461a68c3170553fa5dbf5dbc8a0b2b03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> What you can do to investigate this, is use the sched_wakeup tracer from
> ftrace, that should give a function trace of the highest wakeup latency
> showing what the kernel is doing.

I struggled to find documentation of ftrace because it's quite new. I 
have come across 
http://www.redhat.com/docs/en-US/Red_Hat_Enterprise_MRG/1.0/html/Realtime_Tuning_Guide/sect-Realtime_Tuning_Guide-Realtime_Specific_Tuning-Using_the_ftrace_Utility_for_Tracing_Latencies.html 
and 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/ftrace.txt;h=d330fe3103da9c9a3cb8f888ac7255ce48e666d4;hb=45e9c0de2e86485f8b6633fd64ab19cfbff167f6 
  .

Thanks to those I started up the debugfs filesystem and went to the 
trace directories but the on tracers in available_tracers are
ftrace sched_switch none

I can't see anything in the code that would disable wakeup... Any ideas 
on what might be wrong? I'm using a 2.6.27rc6 kernel.

Additionally I think I found a trigger - unplugging the power cable from 
the EeePC and having it run on battery seems to then set off this 
periodic stall every 30 seconds... There's no CPU frequency scaling 
enabled either (Celeron M's seemingly don't have P states and support 
for cpufreq is configured out).

