Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZHFFQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZHFFQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZHFFQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:16:52 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:37642 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZHFFQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:16:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OdvVT3AAdJdD8+SJPpEZTAxlZ5KGjfpGDukDEzgvOdJgtnSBKRmNit+7qXFiwITH1+
         /KGpu5QTXg+wwMzQNI4NV67x/2vYAGXOdeFBX1m/VKxJ+zWHDcoNdl5BiXIfz2V0I4Us
         5CaT8cTYAStKNIOpZKd6vHMZ2wNlfGWtTqFqk=
MIME-Version: 1.0
In-Reply-To: <20090806013444.GA22095@redhat.com>
References: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
	 <20090804192514.6A40.A69D9226@jp.fujitsu.com>
	 <20090806013444.GA22095@redhat.com>
Date: Thu, 6 Aug 2009 14:16:51 +0900
X-Google-Sender-Auth: 1474db64bd2d1df5
Message-ID: <2f11576a0908052216i560b977by68c400020e786d47@mail.gmail.com>
Subject: Re: [PATCH 1/4] oom: move oom_adj to signal_struct
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/6 Oleg Nesterov <oleg@redhat.com>:
> Sorry for late reply. And sorry, I didn't read these patches carefully yet,
> probably missed something...
>
> On 08/04, KOSAKI Motohiro wrote:
>>
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -34,6 +34,31 @@ int sysctl_oom_dump_tasks;
>>  static DEFINE_SPINLOCK(zone_scan_lock);
>>  /* #define DEBUG */
>>
>> +int get_oom_adj(struct task_struct *tsk)
>
> is it used outside oom_kill.c ?

Good catch.
Will fix.


>> +{
>> +     unsigned long flags;
>> +     int oom_adj = OOM_DISABLE;
>> +
>> +     if (tsk->mm && lock_task_sighand(tsk, &flags)) {
>
> Minor nit. _Afaics_, unlike proc, oom_kill.c never needs lock_task_sighand()
> to access ->signal->oom_adj.
>
> If the task was found under tasklist_lock by for_each_process/do_each_thread
> it must have the valid ->signal != NULL and it can't go away.

Thanks good suggestion!
Will fix.



> With these patches I think mm-introduce-proc-pid-oom_adj_child.patch should
> be dropped. This is good ;)

I agree, It should be dropped.
