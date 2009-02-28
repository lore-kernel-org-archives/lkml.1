Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZB1Cu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZB1Cu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZB1CuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:50:15 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:54164 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbZB1CuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:50:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Eo9xX9TH3ck3y3EiG7JCYHf2lzjlFohut1DiDuPs/HSHdKpWMupmeQ1ksPZwWvcZst
         oFmlacXUWTjKAATKKr7CxJ98RYEBuxvDoGNPYK5MSOhwc3hyV1wAsfsQGQWYXHe6oJNb
         /k1QQ6JDr+oKXP8OrO2zYx8cGV9lSS1IaBfys=
MIME-Version: 1.0
In-Reply-To: <20090226145346.8a778d98.akpm@linux-foundation.org>
References: <1235625475-21218-1-git-send-email-gustavo@las.ic.unicamp.br>
	 <20090226145346.8a778d98.akpm@linux-foundation.org>
Date: Fri, 27 Feb 2009 23:50:10 -0300
X-Google-Sender-Auth: 288bf67645452fa2
Message-ID: <6b53b1990902271850k743dba08y7f27ee884c28950@mail.gmail.com>
Subject: Re: [PATCH] kernel/fork.c: define reset_task_cputimes()
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 7:53 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 26 Feb 2009 02:17:55 -0300
> "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br> wrote:
>
>> Group all vars that receive cputime_zero in the same static function.
>> This also cleans the code.
>>
>> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
>> ---
>>  include/linux/sched.h |   11 +++++++++++
>>  kernel/fork.c         |    8 +-------
>>  2 files changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 8981e52..1a64587 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1595,6 +1595,17 @@ extern cputime_t task_utime(struct task_struct *p);
>>  extern cputime_t task_stime(struct task_struct *p);
>>  extern cputime_t task_gtime(struct task_struct *p);
>>
>> +static inline void reset_task_cputimes(struct task_struct *t)
>> +{
>> +     t->utime = cputime_zero;
>> +     t->stime = cputime_zero;
>> +     t->gtime = cputime_zero;
>> +     t->utimescaled = cputime_zero;
>> +     t->stimescaled = cputime_zero;
>> +     t->prev_utime = cputime_zero;
>> +     t->prev_stime = cputime_zero;
>> +}
>> +
>>  /*
>>   * Per process flags
>>   */
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index a66fbde..9856abe 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1031,13 +1031,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>       clear_tsk_thread_flag(p, TIF_SIGPENDING);
>>       init_sigpending(&p->pending);
>>
>> -     p->utime = cputime_zero;
>> -     p->stime = cputime_zero;
>> -     p->gtime = cputime_zero;
>> -     p->utimescaled = cputime_zero;
>> -     p->stimescaled = cputime_zero;
>> -     p->prev_utime = cputime_zero;
>> -     p->prev_stime = cputime_zero;
>> +     reset_task_cputimes(p);
>>
>>       p->default_timer_slack_ns = current->timer_slack_ns;
>>
>
> I cannot see much point in doing this, unless you have some other patch
> which adds a second caller of reset_task_cputimes()?

No. I don't have. So, cancel the patch.

>
>
>



-- 
Gustavo F. Padovan

Computer Engineering Student
Institute of Computing - IC
University of Campinas - UNICAMP

email: gustavo@las.ic.unicamp.br
gtalk: gfpadovan@gmail.com
mobile: +55 19 81030803
