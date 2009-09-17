Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbZIQJYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbZIQJYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZIQJYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:24:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52058 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZIQJYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:24:36 -0400
Message-ID: <4AB2000A.2030605@cn.fujitsu.com>
Date: Thu, 17 Sep 2009 17:23:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf tools: Increase MAX_EVENT_LENGTH
References: <4AB1F48F.4070807@cn.fujitsu.com> <4AB1F4AB.7050205@cn.fujitsu.com> <20090917090255.GC5184@nowhere> <1253178514.14935.4.camel@laptop> <20090917091345.GD5184@nowhere>
In-Reply-To: <20090917091345.GD5184@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> The name length of some trace events is longer than 30, like
>>>> sys_enter_sched_get_priority_max and ext4_mb_discard_preallocations.
>>>>
>>>> Passing those events to perf-record will fail, try:
>>>>
>>>>   # ./perf record -f -e syscalls:sys_enter_sched_get_priority_max -F 1 -a
>>>>
>>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>>> ---
>>>>  tools/perf/util/parse-events.c |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
>>>> index 034245e..c9ef944 100644
>>>> --- a/tools/perf/util/parse-events.c
>>>> +++ b/tools/perf/util/parse-events.c
>>>> @@ -145,7 +145,7 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
>>>>  	   (strcmp(evt_dirent.d_name, "..")) &&				       \
>>>>  	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
>>>>  
>>>> -#define MAX_EVENT_LENGTH 30
>>>> +#define MAX_EVENT_LENGTH 40
>> This is userspace, is there any reason to be cheap with memory like
>> this?
>>
>> Why not stick in 1024 and be done for a while?
>>
> 
> Indeed, we may need to go even further than 40 in the future.
> But I guess 512 would be already sufficient.
> 

We are not allocating memory for all tracepoints, but only
those to be profiled, so a larger limit is OK.

But as the sys_name:evnt_name will be displayed using perf-list
cmd, I don't think the names will be too long.

Anyway, we decide to make it 512? I'll resend the patch.

