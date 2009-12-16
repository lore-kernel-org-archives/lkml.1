Return-Path: <linux-kernel-owner+w=401wt.eu-S1759074AbZLPHmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbZLPHmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZLPHmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:42:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61520 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbZLPHmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:42:42 -0500
Message-ID: <4B288F04.5080108@cn.fujitsu.com>
Date: Wed, 16 Dec 2009 15:40:52 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf_event: introduce 'perf timer' to analyze	timer's
 behavior
References: <4B27702F.1080507@cn.fujitsu.com> <20091215141533.GB5833@nowhere> <4B283596.2010801@cn.fujitsu.com> <20091216073248.GA32713@elte.hu>
In-Reply-To: <20091216073248.GA32713@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:

>>>
>> Yeah, it has different unit and looks ugly :-(
>>
>> but, the problem is we can't get HZ in userspace now, i'll export HZ by proc 
>> or other way and rectify 'perf timer' output in my next work
> 
> We could export HZ as part of the ftrace event format file, in 
> /debug/tracing/events/timers/ or so. Not sure what the best way would be to do 
> it (without causing runtime overhead in event processing), but we should 
> reduce our reliance on /proc and export such instrumentation information via a 
> single, coherent interface.
> 

Hi ingo,

Um, if we export this value in tracepoint format, it should add for every timer's
tracepoint.

> There's a couple of other 'system settings' values that would be useful to 
> expose in such a way - for example the number of online CPUs. (in fact that 
> could be exposed as a set of online/offline events plus a way to read the 
> current count as well)
> 


How about export those values in debugfs/tracing/*? perf tracepoint self depend on
this filesystem. 

Thanks,
Xiao
