Return-Path: <linux-kernel-owner+w=401wt.eu-S932479AbZLPBVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbZLPBVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZLPBVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:21:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59579 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756092AbZLPBVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:21:04 -0500
Message-ID: <4B283596.2010801@cn.fujitsu.com>
Date: Wed, 16 Dec 2009 09:19:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf_event: introduce 'perf timer' to analyze	timer's
 behavior
References: <4B27702F.1080507@cn.fujitsu.com> <20091215141533.GB5833@nowhere>
In-Reply-To: <20091215141533.GB5833@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:
> On Tue, Dec 15, 2009 at 07:17:03PM +0800, Xiao Guangrong wrote:
>> Hi,
>>
>> We introduce 'perf timer' in this patchset, it can analyze timer
>> latency and timer function handle time, the usage and result is
>> like below:
>>
>> # perf timer record
>> # perf timer lat --print-lat --print-handle
>> -------------------------------------------------------------------------------------------------------
>> |   Timer            |   TYPE   |   Avg-latency  | Max-latency  |  Max-latency-at-TS |Max-lat-at-Task |
>> |0xf7ad1f5c          |hrtimer   |996068.500    ns|1607650     ns|10270128658526      |init            |
>> |0xf7903f04          |timer     |0.625         HZ|2           HZ|10270344082394      |swapper         |
>> |0xf787a05c          |hrtimer   |200239.500    ns|359929      ns|10269316024808      |main            |
>> |main      :[   PROF]|itimer    |0.000         HZ|0           HZ|10237021270557      |main            |
>> |main      :[VIRTUAL]|itimer    |0.000         HZ|0           HZ|10257314773501      |main            |
> 
> 
> 
> Cool! This is really a good work and a good idea.
> 
> Just have some neats in mind. hrtimers and timers don't have the same latency and
> granularity requirements.
> 
> As you show it, timers have an HZ granularity and hrtimers are about nanoseconds,
> and mixing them up in the same array of latency report is too messy.
> They don't have the same granularity/latency scope so they should
> be reported separately.
> 

Yeah, it has different unit and looks ugly :-(

but, the problem is we can't get HZ in userspace now, i'll export HZ by proc or other
way and rectify 'perf timer' output in my next work

Thanks,
Xiao
