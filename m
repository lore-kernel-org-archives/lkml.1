Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZJVOm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZJVOm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbZJVOm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:42:28 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:42898 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbZJVOm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E/KSTMokk4NNQfGLkq1+yuC0Gc2+6KRdc7OCP6MmNwCl18ozTx3CUEd4oz7RI7u4Bb
         LIfK3kYO/AFCn60NEvRxhgMl1jsYWXLBSvlgusE7xfPAstjWFdGyjezMTzriXKzlm6Cv
         e+adgzDiKEhr0gl7X7Fkk7qZczxEkuiViPP8Q=
MIME-Version: 1.0
In-Reply-To: <1256198088.6700.76.camel@Palantir>
References: <e932a33e0910210833j1fab6129m23b55101c5978c4a@mail.gmail.com>
	 <e932a33e0910210838j3be9286bo3953c4cae3f0e12e@mail.gmail.com>
	 <1256198088.6700.76.camel@Palantir>
Date: Thu, 22 Oct 2009 20:12:31 +0530
Message-ID: <e932a33e0910220742v5d99adbere9fc9c31f72b6b95@mail.gmail.com>
Subject: Re: [PATCH] DRTL kernel 2.6.32-rc3 : SCHED_EDF, DI RT-Mutex, Deadline 
	Based Interrupt Handlers
From: Soumya K S <ssks.mt@gmail.com>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@gandalf.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 1:24 PM, Raistlin <raistlin@linux.it> wrote:
> On Wed, 2009-10-21 at 21:08 +0530, Soumya K S wrote:
>> Hello All,
>>
> Hi,
>
> I'm Dario, from Pisa (Italy), and I'm working on EDF scheduling for the
> Linux kernel as you do (don't know if you've seen the threads and the
> patches, all info here http://gitorious.org/sched_deadline/pages/Home).
>
Hi Dario, we needed a deadline based scheduler for DRTL and we zeroed
in upon SCHED_EDF. We see that the threads here are fairly new too :-P

>> The developed framework allows user to specify the real-time
>> strategies for a specific real-time scenario. User specifies
>> configurations like scheduling policy, Deadline-miss Fault-tolerance
>> limit, interrupt priorities, etc. Real-time applications use onetime
>> gateway to notify kernel that they require real-time response. All
>> applications use existing POSIX APIs. DRTL scheduler is time-aware and
>> uses EDF as the scheduling policy.
>>
> Nice, from here, it seemed we were working on very similar things, and I
> was wondering if we could somehow collaborate... :-)
>
Sure! That would be good :)

> Then I looked at the code and I saw our two designs are quite different,
> e.g., you don't constraint execution times, don't run any admission test
> to avoid oversubscription and you stop deadline missing tasks... Am I
> right?
> Even from the implementation point of view, I see you didn't used a new
> scheduling class.
>
A simple system where there a few real-time tasks and a few non-real
time tasks, the timelines can be architected out for each real-time
task in the system. In such a case, given the RT bandwidth in the
system, the task with the lowest deadline gets to be scheduled first
till it is there in the system.
In short, for such simple systems, we shifted the burden of admission
control to the architect and kept close to the existing code.

> However, I think there still would be room for collaboration, if you are
> interested in...
>
>> The patch consists of Time aware scheduler having SCHED_EDF as the
>> scheduling policy, Deadline based scheduling for Interrupt handlers,
>> Deadline Inheritance support for RT-Mutexes.
>>
> I was very curious on how you dealt with deadline inheritance in SMPs,
> than I saw this in your patch:
>
> diff -Naur linux-2.6.32-rc3/init/Kconfig linux-2.6.32-rc3-drtl/init/Kconfig
> +config SCHED_EDF
> +       bool "EDF Scheduler Support"
> +       default n
> +       depends on !GROUP_SCHED
> +       depends on !SMP
>
> :-P
>
> I'm right in the opposite situation, I've got SMP (partitioned for now,
> but we're working on migrations) and also CGROUPS support, but we are
> still wondering how deadline (or something more sophisticated, like
> bandwidth) inheritance could work in such a case...
>
That's right, we are still working on SMP and hope there are no
scalability issues in this patch w.r.t SMP.

> Again, I think I see collaboration possibilities, again, if you're
> interested in...
>
Definitely!

>> The patch is for the kernel version 2.6.32-rc3. It has been tested on
>> OMAP3530, ATMEL AT91SAM9261 and X86 platforms.
>>
> Ok... Are you also targeting (or plan to) preempt-rt kernels?
>
Yes, We do have the patches for preempt-rt kernel.

>> We look forward for support and feedback about
>> DRTL <http://docs.google.com/fileview?id=0BzLQtQ1qAO7uYjYyN2QwNGUtYWE2YS00MDc1LWExYWUtZTliNjNjNmZiZTZj&hl=en>
>> and the patch for its feasibility, scalability and performance.
>>
> Do you already have any numbers or testcase? I have some (well, a few!)
> of them... I'll try to find the time to give it a try to your patch with
> them...
>
We have tested Co-operative context switch time, Pre-emptive context
switch time and Interrupt Latency, all of them are of ~130us for
OMAP3530.

Regards,
Soumya
Shubhro
