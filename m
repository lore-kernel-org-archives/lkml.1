Return-Path: <linux-kernel-owner+w=401wt.eu-S933207AbZLJIRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207AbZLJIRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760775AbZLJIRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:17:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760762AbZLJIRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:17:22 -0500
Message-ID: <4B20AE32.1090602@cn.fujitsu.com>
Date: Thu, 10 Dec 2009 16:15:46 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf sched: Add max delay time snapshot
References: <1260391208-6808-1-git-send-regression-fweisbec@gmail.com> <4B206A18.2030607@cn.fujitsu.com> <20091210072351.GF16874@elte.hu>
In-Reply-To: <20091210072351.GF16874@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
>> Frederic Weisbecker wrote:
>>
>>> When we have a maximum latency reported for a task, we need a 
>>> convenient way to find the matching location to the raw traces or to 
>>> perf sched map that shows where the task has been eventually 
>>> scheduled in. This gives a pointer to retrieve the events that 
>>> occured during this max latency.
>> Then, we can cooperate with ftrace's data to know what the cpu is 
>> doing at that time.
> 
> What do you mean by mixing it with ftrace data? These events ought to be 
> a full replacement for the sched and wakeup tracers. In the long run we 
> want a single stream of events and phase out most of the pretty-printing 
> ftrace plugins.

Hi Ingo,

I think sometimes perf tool cooperate with ftrace can do more
useful things, take this case for example:

By 'perf sched latency' we can get the schedule latency time,
if the time is abnormal, then we can run this command and enable
function tracer. 

After running, 'perf sched latency' can show us the timestamps
when the maximum latency(the worst case) occurs, then we can find
what the cpu is doing at this timestamps by reading function
tracer's output.

Thanks,
Xiao
