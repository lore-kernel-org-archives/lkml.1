Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZJHBje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZJHBje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbZJHBjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:39:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60515 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754292AbZJHBjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:39:33 -0400
Message-ID: <4ACD4266.2050902@cn.fujitsu.com>
Date: Thu, 08 Oct 2009 09:37:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Zhenwen Xu <helight.xu@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH V4] fix warning on kernel/trace/trace_branch.c andtrace_hw_branches.c
References: <20091007113915.GA5265@helight>  <20091008012146.GA4170@helight> <1254965540.1696.198.camel@gandalf.stny.rr.com>
In-Reply-To: <1254965540.1696.198.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
>> index 23b6385..52a5903 100644
>> --- a/kernel/trace/trace_hw_branches.c
>> +++ b/kernel/trace/trace_hw_branches.c
>> @@ -165,6 +165,7 @@ void trace_hw_branch(u64 from, u64 to)
>>  	struct ftrace_event_call *call = &event_hw_branch;
>>  	struct trace_array *tr = hw_branch_trace;
>>  	struct ring_buffer_event *event;
>> +	struct ring_buffer *buf;
>>  	struct hw_branch_entry *entry;
>>  	unsigned long irq1;
>>  	int cpu;
>> @@ -180,7 +181,8 @@ void trace_hw_branch(u64 from, u64 to)
>>  	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
>>  		goto out;
>>  
>> -	event = trace_buffer_lock_reserve(tr, TRACE_HW_BRANCHES,
>> +	buf = tr->buffer

And here won't compile..

>> +	event = trace_buffer_lock_reserve(buf, TRACE_HW_BRANCHES,
>>  					  sizeof(*entry), 0, 0);
