Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYJGQmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYJGQmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYJGQmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:42:35 -0400
Received: from mgate26.so-net.ne.jp ([202.238.84.126]:54951 "EHLO
	mgate26.so-net.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYJGQmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:42:35 -0400
X-Greylist: delayed 1536 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2008 12:42:34 EDT
Message-ID: <48EB8ACA.6030603@miraclelinux.com>
Date: Wed, 08 Oct 2008 01:14:02 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom_kill: fix calculation of the cpu_time and the run_time
References: <48EB3B44.3030202@miraclelinux.com> <20081007201309.5A71.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081007201309.5A71.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI-san

Thank you for quick reply and checking my patch.


> Have you seen any trouble?

No I haven't.

> in some architecture, shift-op outperfom divide-op largely.

Of course, but I think that the oom-killer doesn't need high performance.
Do you think oom-killer needs it ?

> why do you need this change?

Nothing special,
but I write a tips about oom-killer now.

The comments and the source code don't match.
so I think how to write about badness point now.

Therefore, I only think the source code should conform to the comments.


Regards,
Naohiro Ooiwa.


KOSAKI Motohiro さんは書きました:
>> Hi all
>>
>> The cpu-time is in tens of seconds
>> and the run-time is in thousands of secounds.
>>
>> but the source code doesn't follow it.
> 
> Have you seen any trouble?
> 
>> I fixed it and also some white-spaces.
>> Could you please check this patch.
>>
>>
>> Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
>> ---
>>  mm/oom_kill.c |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 64e5b4b..bddab74 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -100,14 +100,14 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>>
>>  	/*
>>  	 * CPU time is in tens of seconds and run time is in thousands
>> -         * of seconds. There is no particular reason for this other than
>> -         * that it turned out to work very well in practice.
>> +	 * of seconds. There is no particular reason for this other than
>> +	 * that it turned out to work very well in practice.
>>  	 */
>> -	cpu_time = (cputime_to_jiffies(p->utime) + cputime_to_jiffies(p->stime))
>> -		>> (SHIFT_HZ + 3);
>> +	cpu_time = ((cputime_to_jiffies(p->utime) + cputime_to_jiffies(p->stime))
>> +		>> SHIFT_HZ) / 10UL;
>>
>>  	if (uptime >= p->start_time.tv_sec)
>> -		run_time = (uptime - p->start_time.tv_sec) >> 10;
>> +		run_time = (uptime - p->start_time.tv_sec) / 1000UL;
>>  	else
>>  		run_time = 0;
> 
> in some architecture, shift-op outperfom divide-op largely.
> why do you need this change?
> 
> 
> 

