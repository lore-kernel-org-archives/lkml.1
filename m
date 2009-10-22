Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZJVJeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZJVJeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 05:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZJVJeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 05:34:10 -0400
Received: from aa002msb.fastweb.it ([85.18.95.81]:51275 "EHLO
	aa002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZJVJeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 05:34:09 -0400
Message-ID: <4AE026EE.9040909@evidence.eu.com>
Date: Thu, 22 Oct 2009 11:33:34 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Soumya K S <ssks.mt@gmail.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] DRTL kernel 2.6.32-rc3 : SCHED_EDF, DI RT-Mutex, Deadline
    Based Interrupt Handlers
References: <e932a33e0910210833j1fab6129m23b55101c5978c4a@mail.gmail.com> <e932a33e0910210838j3be9286bo3953c4cae3f0e12e@mail.gmail.com>
In-Reply-To: <e932a33e0910210838j3be9286bo3953c4cae3f0e12e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soumya K S ha scritto:
> Hello All,
> 
> We would like to present a patch on Deployment specific Real-Time
> Linux, topic discussed in LinuxCon 2009
> <http://events.linuxfoundation.org/lc09d17>
> 
> The developed framework allows user to specify the real-time
> strategies for a specific real-time scenario. User specifies
> configurations like scheduling policy, Deadline-miss Fault-tolerance
> limit, interrupt priorities, etc. Real-time applications use onetime
> gateway to notify kernel that they require real-time response. All
> applications use existing POSIX APIs. DRTL scheduler is time-aware and
> uses EDF as the scheduling policy.
> 
> The patch consists of Time aware scheduler having SCHED_EDF as the
> scheduling policy, Deadline based scheduling for Interrupt handlers,
> Deadline Inheritance support for RT-Mutexes.
> 
> The patch is for the kernel version 2.6.32-rc3. It has been tested on
> OMAP3530, ATMEL AT91SAM9261 and X86 platforms.
> 
> We look forward for support and feedback about
> DRTL <http://docs.google.com/fileview?id=0BzLQtQ1qAO7uYjYyN2QwNGUtYWE2YS00MDc1LWExYWUtZTliNjNjNmZiZTZj&hl=en>
> and the patch for its feasibility, scalability and performance.
> 
> Many Thanks,
> Soumya KS
> Shubhro Sinha

Hi,

    FYI, a patch to add EDF scheduling to Linux has been already 
proposed in September (see http://lkml.org/lkml/2009/9/22/186), 
discussed on mailing list and presented with a talk at the last 
Real-Time Linux Workshop (RTLWS - 
http://www.osadl.org/Dresden-2009.rtlws11-dresden-2009.0.html).

The patch was initially called "SCHED_EDF". Then, on suggestion of 
Peter, the name has been changed to "SCHED_DEADLINE" and the code moved 
to a public git repository 
(http://gitorious.org/sched_deadline/sched-deadline).

Recently, the patch has been re-submitted to LKML (see 
http://lkml.org/lkml/2009/10/16/161) with many issues fixed. Among them: 
a new behavior of fork(), a new syscall for periodic tasks, flags to 
signal deadline misses and budget overruns. All these changes come from 
the comments and the feedback got on mailing list and at the workshop.

At a first glance, your patch extends sched_param (which may lead to 
compatibility problems with old code), it does not support SMP 
platforms, and it changes the sched_rt code instead of adding a new 
scheduling class.

For the reasons above, I think that we should stick with SCHED_DEADLINE, 
eventually integrating some parts of your code into that project.

Best regards,

              Claudio


