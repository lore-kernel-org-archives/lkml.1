Return-Path: <linux-kernel-owner+w=401wt.eu-S932356AbZJGHl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbZJGHl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbZJGHl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:41:59 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:45401 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbZJGHl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Oyd+hdzSfQ8lEw5P5Em98x8HHRqo+ak200VolhFz5EBu7qc5BAXymbbWtcXt2SdlGR
         DESDngUui7gN5fq3rHG8DR6xZ18sU0ek8WFkN1kAbzkFYSn4wqsyX8FFXg1HCcjKywbZ
         CmgvfmFiQtGZhGqgtt2k/QDMvVPa7/PrYyZRc=
Message-ID: <4ACC45B9.6070202@gmail.com>
Date: Wed, 07 Oct 2009 15:39:37 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] fix a warning on kernel/trace/trace_branch.c
References: <20091007063921.GA19756@helight> <4ACC3C9D.9040106@cn.fujitsu.com>
In-Reply-To: <4ACC3C9D.9040106@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Zhenwen Xu wrote:
>   
>> fix this warning:
>>
>> kernel/trace/trace_branch.c: In function ‘probe_likely_condition’:
>> kernel/trace/trace_branch.c:58: warning: passing argument 1 of ‘
>> trace_buffer_lock_reserve’ from incompatible pointer type
>>
>> The "tr" should be "(struct buffer *)tr" or "tr->buffer" here!!!
>>
>>     
>
> It's caused by the API change of trace_buffer_lock_reserve() by
> commit e77405ad80f53966524b5c31244e13fbbbecbd84.
>
> Could you send an updated patch to also fix the same bug
> in kernel/trace/trace_hw_branch.c ?
>   
Roger that!
>   
>> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
>> ---
>>  kernel/trace/trace_branch.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
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
>>     
>
>
>   


-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org

