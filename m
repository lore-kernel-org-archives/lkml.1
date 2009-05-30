Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbZE3Oqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbZE3Oqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbZE3Oqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:46:43 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:33283 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907AbZE3Oqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hxipwrmchd4xD60mUZENdHwyRCXXN9KaMgzKrFECn45xaRTedRBIcw5NFQ4WxyFz7m
         qTTKEte4anxmVUP0rqIrW/LG2zASAreRXtc0pH6lDohr1jSZtwWkQ7Y061fZFJSNgAQS
         bLO2Jtk6Ve1f/lAlhObjtKJ5V0LtIamRnoZUI=
MIME-Version: 1.0
In-Reply-To: <20090530133441.GA11337@alecto.austad.us>
References: <164c92d827cbee86ba2c5621716309e6@localhost>
	 <200904300939.31754.henrik@austad.us>
	 <49b7c2350905071935kbd2aa22v9d39cf41c537c24b@mail.gmail.com>
	 <20090508091052.GA10429@januz.myftp.org>
	 <49b7c2350905300438n6195de93la53bee3a309f71d@mail.gmail.com>
	 <20090530133441.GA11337@alecto.austad.us>
Date: Sat, 30 May 2009 23:46:43 +0900
Message-ID: <49b7c2350905300746v38d6597eu82b7fcc99813080f@mail.gmail.com>
Subject: Re: SCHED_EDF infos
From: GeunSik Lim <leemgs1@gmail.com>
To: Henrik Austad <henrik@austad.us>
Cc: finarfin@dreamos.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 10:34 PM, Henrik Austad <henrik@austad.us> wrote:
>> Can you share EDF that you implemented with P-fair for Multicore environments?
>> Especially, I wonder How do you keep posix compatibility with EDF scheduler.
>
> Well, what exactly do you mean by posix compatibility? What I'm doing, is adding
This means that We can use  realtime programming for EDF effectiveness with
current system call interface without new system call interface.

> another scheduling class on top of sched_rt so that sched_pfair will be polled
> before any other class. I was not aware that POSIX had an EDF standard?
POSIX describes common real-time specification  without EDF, RMS ,
Resource Reservation, etc.
Belows is the Linux Standard Base (LSB) specifications for Linux Distributions.
http://www.linuxfoundation.org/en/Specifications
>
>> For example,
>> sched_setscheduler(2), sched_getscheduler(2),
>> sched_get_priority_max(2), sched_get_priority_min(2),
>> sched_getaffinity(2), sched_setaffinity(2),
>> sched_getparam(2), sched_setparam(2),
>> setpriority(2), getpriority(2),
>> sched_yield(2), sched_rr_get_interval(2)
>
> I introduce 3 new syscalls for modifying the tasks.
>
>  sched_pfair_update()
>  - change an existing task into a pfair task, set attributes, calculate subjob
>   values etc
>
>  sched_pfair_release()
>  - release the task, i.e. enable it to run on a CPU.
>
>  sched_pfair_reweigh()
>  - change the attributes of the task. In a lot of ways, this is very similar to
>   pfair_update, but it introduces some problems when trying to reweigh a task
>   that is running, or if the new values lead to over-utilization of the system.
When we try to userspace realtime programming, How can we insert  systemcall api
with posix compatibility.
Um... In general, we use
sched_setscheduler    (struct task_struct *p, int policy,  struct
sched_param *param) api.

If we will make  EDF related u/s rt programming, How do we have to
insert deadline of tasks
for EDF performance?
sched_setscheduler_EDF(struct task_struct *p, int policy, period-time
, runtime)
or

struct sched_param {
       int sched_priority;
      <timespec edf-period-time>;
      <timespec edf-runtiome>;
};

I am not sue...

>
> At the moment, this is only for my own convenice, but I have tried to modify as
> little of the existing code as possible to avoid merge conflicts etc. So, none
> of the existing syscalls have been modified in any way.
>
> I'm a bit unsure as to what your question actually is, perhaps you could
> elaborate a bit about what you're concered about?
>
> henrik
>



-- 
Regards,
GeunSik Lim ( SAMSUNG ELECTRONICS)
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
