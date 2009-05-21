Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZEUBrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZEUBrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 21:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZEUBre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 21:47:34 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:48937 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbZEUBrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 21:47:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p3dBBW3BulJuBcKLoL/wZGCIaO1q4enfccU6FqUvPHxhTSdENFoj1ln4JlgZxlCDZE
         mis4tEkzuoKTjjPJJe6EIokRiw0NvSeucuOdSzh89lBJL2MksiU8VDqggfhg+pWMt+Ch
         qeLZNaeiNFAnMZ5wgONu+vE16b+nbbmPG9VvY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0905201433060.1080@gandalf.stny.rr.com>
References: <1242783552.31161.53.camel@centos51>
	 <49b7c2350905192150n4d6b710er571b8a1bd228198b@mail.gmail.com>
	 <alpine.DEB.2.00.0905201433060.1080@gandalf.stny.rr.com>
Date: Thu, 21 May 2009 10:47:32 +0900
Message-ID: <49b7c2350905201847l1ea97fcfvc3dd5067163e73f3@mail.gmail.com>
Subject: Re: [PATCH 0/1] sched: fix typo in sched-rt-group.txt file
From: GeunSik Lim <leemgs1@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       tglx <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 3:59 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 20 May 2009, GeunSik Lim wrote:
>
>> 2009/5/20 GeunSik Lim <leemgs1@gmail.com>:
>> >
>> >
>> > Dear Ingo,
>> >
>> >
>> > I made 2 patch files again about static prioriy levels according to ingo's advice
>> > and explanation. (Reference: http://marc.info/?t=124211992800003&r=1&w=2 archives. )
>> >
>> > Fix static priority related range and chart map(userspace/kernelspace) of ftrace.
>> >   - about chart map of static priority in  ftrace.txt file
>> >   - about static priority levels(range) in sched-rt-group.txt file
>> >
>> >
>> > commit d6af702008117ca489a2f5476239d1688a517e98
>> > Author: GeunSik,Lim <leemgs1@gmail.com>
>> > Date:   Tue May 12 17:20:32 2009 +0900
>> >
>> >    sched: fix typo in sched-rt-group.txt file
>> >
>> >    Fix typo about static priority's range.
>> >
>> >    * Kernel Space priority 0(high) to 99(low)   --> User Space RT priority 99(high) to 1(low)
>> >    * Kernel Space priority 100(high) to 139(low)--> User Space nice -20(high) to 19(low)
>> >
>>
>> Ingo,
>> I want to  change some descriptions according to below discussion.
>>
>> before) * Kernel Space priority 0(high) to 99(low)   --> User Space RT
>> priority 99(high) to 1(low)
>> after)    *  Kernel Space priority 0(high) to 98(low)   --> User Space
>> RT priority 99(high) to 1(low)
>>
>> I want to your advice and opinion about this changes.
>>
>> If I mistook, Please correct me.
>>
>> thks.
>>
>>
>>
>> Steven Rostedt:
>>   Shouldn't that be:
>>   Kernel priority: 0(high) to 98(low)    ==> user RT priority 99(high) to 1(low)
>>
>> GeunSik Lim :
>>   Thank you for your opinion.  I think about corrected expression for
>>   quick chart to map between kernel space and user space in ftrace .
>>
>> Steven Rostedt:
>>  100 items does not map to 99. Which begs the question, what can have
>>  internal kernel priority 99?
>>
>> GeunSik Lim :
>>   ok.  Below example is about  kernel (static) priority 99 that you said.
>>   please, refer
>>   to http://www.kernel.org/doc/man-pages/online/pages/man2/sched_setscheduler.2.html
>>  webpage.
>>
>>   For processes scheduled under one of the normal scheduling policies
>>   (SCHED_OTHER, SCHED_IDLE, SCHED_BATCH), sched_priority is not used in
>>   scheduling decisions (it must be specified as 0).
>>
>> int main (int argc, char **argv)
>> {     int pidnumber, ret;
>>       struct sched_param p;
>>       p.sched_priority = 0; <------ Kernel (static) priority.
>>       if (argc != 2) {
>>               printf("usage: setbatch <pid>\n");
>>               exit(-1);
>>       }
>>       pidnumber = atol(argv[1]);
>>          /* 3 = Number of SCHED_BATCH Constant */
>>       ret = sched_setscheduler(pidnumber, 3, &p);
>>       if (ret) {
>>               printf("could not set pid %d to SCHED_BATCH: err %d.\n", pid, ret);
>>               return -1;
>>       }
>>       printf("pid %d is SCHED_BATCH from now on.\n", pid);
>>       return 0;
>> }
>>
>>
>> >
>> >    Processes scheduled with SCHED_OTHER or SCHED_BATCH must be assigned
>> >    the static priority 0. Processes scheduled under SCHED_FIFO or SCHED_RR
>> >    can have a static priority in the range 1 to 99.
>> >    (reference: $> man 2 sched_setscheduler)
>> >
>> >    Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
>> >
>> > diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
>> > index 5ba4d3f..1537146 100644
>> > --- a/Documentation/scheduler/sched-rt-group.txt
>> > +++ b/Documentation/scheduler/sched-rt-group.txt
>> > @@ -169,7 +169,7 @@ get their allocated time.
>> >
>> >  Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
>> >  the biggest challenge as the current linux PI infrastructure is geared towards
>> > -the limited static priority levels 0-139. With deadline scheduling you need to
>> > +the limited static priority levels 0-99. With deadline scheduling you need to
>> >  do deadline inheritance (since priority is inversely proportional to the
>> >  deadline delta (deadline - now).
>
> Note, this document deals with internal kernel manipulations. The "prio"
> inside the kernel is indeed 0-139. Actually, if we count the idle task, it
> is 0-140. The PI code will also deal with non RT tasks so it is correct to
> say that the priority inheritance deals with 0-139 (I don't think the idle
> task ever touches anything needing PI).
>
> The sched_setscheduler user API uses a different priority mapping. I was
> looking at the code inside sched.c and I believe this is the mapping:
>
>
> 0 to 98 - maps to RT tasks 99 to 1 (SCHED_RR or SCHED_FIFO)
>
> 99 - maps to internal kernel threads that want to be lower than RT tasks
>     but higher than SCHED_OTHER tasks. Although I'm not sure if any
>     kernel thread actually uses this. I'm not even sure how this can be
>     set, because the internal sched_setscheduler function does not allow
>     for it.
Thank you for additional explanation about kernel-space static priority 99
in the map of priority values between kernel-space and user-space.

I will update like belows.

Kernel priority: 0(high) to 98(low)      ==> user RT priority 99(high)
to 1(low) with SCHED_RR or SCHED_FIFO
Kernel priority: 99                            ==> sched_priority is
not used in scheduling deci
sions (it must be specified as 0)
Kernel priority: 100(high) to 139(low) ==> user nice -20(high) to 19(low)
Kernel priority: 140                          ==> idle task priority


>
> 100 to 139 - maps nice levels -20 to 19. These are not set via
>    sched_setscheduler, but are set via the nice system call.
>
> 140 - reserved for idle tasks.
>
> -- Steve
>



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
