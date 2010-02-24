Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0BXIVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:21:40 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:61543 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab0BXIVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:21:38 -0500
Message-ID: <4B84E173.9010608@oracle.com>
Date: Wed, 24 Feb 2010 16:21:07 +0800
From: Wenji Huang <wenji.huang@oracle.com>
Reply-To: wenji.huang@oracle.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH -tip 5/5] tracing: simplify memory recycle of trace_define_field
References: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com> <1266997226-6833-2-git-send-email-wenji.huang@oracle.com> <1266997226-6833-3-git-send-email-wenji.huang@oracle.com> <1266997226-6833-4-git-send-email-wenji.huang@oracle.com> <1266997226-6833-5-git-send-email-wenji.huang@oracle.com> <4B84DD84.60302@cn.fujitsu.com>
In-Reply-To: <4B84DD84.60302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B84E185.01A3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2010 04:04 PM, Li Zefan wrote:
> Wenji Huang wrote:
>> Discard freeing field->type since it's not necessary and may be hazard.
>>
>
> It's redundant, but it's safe, because if we run into this failure path,
> field->type is always NULL.

There are two entries to failure path, field->name == NULL or
field->type == NULL. And allocating for field->name is before field->type.

IMHO, field->type is not fixed after initialization, it's
not safe if field->name==NULL goes to failure path.

Regards,
Wenji
>
>> Signed-off-by: Wenji Huang<wenji.huang@oracle.com>
>
> Reviewed-by: Li Zefan<lizf@cn.fujitsu.com>
>
>> ---
>>   kernel/trace/trace_events.c |    4 +---
>>   1 files changed, 1 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index c2a3077..3f972ad 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -60,10 +60,8 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
>>   	return 0;
>>
>>   err:
>> -	if (field) {
>> +	if (field)
>>   		kfree(field->name);
>> -		kfree(field->type);
>> -	}
>>   	kfree(field);
>>
>>   	return -ENOMEM;

