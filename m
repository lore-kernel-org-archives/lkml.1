Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYF0NiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYF0NiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbYF0NiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:38:11 -0400
Received: from mx.sjtu.edu.cn ([202.112.26.52]:53864 "EHLO mx2.sjtu.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYF0NiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:38:10 -0400
Message-ID: <20080627213805.jdqshto0ys4oookk@webmail1.sjtu.edu.cn>
Date: Fri, 27 Jun 2008 21:38:05 +0800
From: xialiang <xiaiaxaxi@sjtu.edu.cn>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How can I migrate a currently running task?
References: <20080627211712.6cto2d1zks848c88@webmail1.sjtu.edu.cn>
	<e2e108260806270625o44ebe7a0u8250fa0bd5e976bd@mail.gmail.com>
In-Reply-To: <e2e108260806270625o44ebe7a0u8250fa0bd5e976bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=GB2312;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bart Van Assche <bart.vanassche@gmail.com>:

> On Fri, Jun 27, 2008 at 3:17 PM, одаа <xiaiaxaxi@sjtu.edu.cn> wrote:
>> I am working on Intel Duo Core with Linux OS 2.6.21, and I'd like to
>> migrate task from one cpu to another cpu.
>> In SMP systems, load_balance() function uses move_tasks() to move processes
>> from source runqueue to local runqueue, but it does not move a currently
>> running task. If I want to migrate a currently running task from source
>> runqueue to local runqueue, how can I do? Any suggestion is preferred.
>
> Are you familiar with the glibc pthread_setaffinity_np() function
> and/or the sched_setaffinity() system call ?
>
> Bart.
>

Yes. I know sched_setaffinity(), it sets cpu_mask of a task. I want to  
use it in a timer interrupt( scheduler_tick() ), can I?

I use sched_getaffinity() in a timer interrupt, but it doesn't work.As  
following,

scheduler_tick()
{
     every 100ms, balance();
}

static int balance(void)
{
     Get temperature of two cpus.
     int ret;
     cpumask_t mask;

     If(one cpu is much hotter than another one){
         ret = sched_getaffinity(rq->curr->pid, &mask);
     }
}

If I comment sched_getaffinity, it works well.


