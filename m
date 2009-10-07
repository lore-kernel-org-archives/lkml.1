Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbZJGLm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbZJGLm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbZJGLm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:42:56 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:46804 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920AbZJGLm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:42:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mOCvyMudKnwf8mT7fPhw65gWC4bJAzwdLH2qeyw40oTY4sy2NLlvxUBwDywqo3bknF
         W8Y+grB+JgEL2JrHRmHHCeon/kkK6ssdwufV7ulPVfW961WGrwQMMmYpvCQh9wkrJPNj
         cofFW/YDET05jMWc/UBv3R1z8+r/jeS3rL7LM=
Message-ID: <4ACC7E35.4050001@gmail.com>
Date: Wed, 07 Oct 2009 19:40:37 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V2] fix a warning on kernel/trace/trace_branch.c and	trace_hw_branches.c
References: <20091007081946.GA25350@helight> <4ACC5715.4000201@cn.fujitsu.com>
In-Reply-To: <4ACC5715.4000201@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Zhenwen Xu wrote:
>   
>> fix warnings that caused the API change of trace_buffer_lock_reserve()
>> change files: kernel/trace/trace_hw_branch.c
>> 	      kernel/trace/trace_branch.c
>>
>>     
>
> Hmm, did you really compile trace_hw_branch.c while testing
> this patch?
>
> This change is necessary too:
>
> -	trace_buffer_unlock_commit(tr, event, 0, 0);
> +	trace_buffer_unlock_commit(tr->buffer, event, 0, 0);
>
> And use a varaible "buffer = tr->buffer" should be better.
>   
oh!   sorry for my careless!
>   
>> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
>> ---
>>  kernel/trace/trace_branch.c      |    2 +-
>>  kernel/trace/trace_hw_branches.c |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
>> index 7a7a9fd..216e2dd 100644
>> --- a/kernel/trace/trace_branch.c
>> +++ b/kernel/trace/trace_branch.c
>> @@ -54,7 +54,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>>  		goto out;
>>  
>>  	pc = preempt_count();
>> -	event = trace_buffer_lock_reserve(tr, TRACE_BRANCH,
>> +	event = trace_buffer_lock_reserve(tr->buffer, TRACE_BRANCH,
>>  					  sizeof(*entry), flags, pc);
>>  	if (!event)
>>  		goto out;
>> diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
>> index 23b6385..1cc17ca 100644
>> --- a/kernel/trace/trace_hw_branches.c
>> +++ b/kernel/trace/trace_hw_branches.c
>> @@ -180,7 +180,7 @@ void trace_hw_branch(u64 from, u64 to)
>>  	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
>>  		goto out;
>>  
>> -	event = trace_buffer_lock_reserve(tr, TRACE_HW_BRANCHES,
>> +	event = trace_buffer_lock_reserve(tr->buffer, TRACE_HW_BRANCHES,
>>  					  sizeof(*entry), 0, 0);
>>  	if (!event)
>>  		goto out;
>>     
>
>   


-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org

