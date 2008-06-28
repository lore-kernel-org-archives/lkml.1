Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbYF1EFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbYF1EFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 00:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYF1EF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 00:05:27 -0400
Received: from mx.sjtu.edu.cn ([202.112.26.52]:44892 "EHLO mx2.sjtu.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYF1EFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 00:05:25 -0400
Message-ID: <20080628120521.kjrvzpgpwwcc0g0c@webmail1.sjtu.edu.cn>
Date: Sat, 28 Jun 2008 12:05:21 +0800
From: xialiang <xiaiaxaxi@sjtu.edu.cn>
To: Robin Holt <holt@sgi.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: How can I migrate a currently running task?
References: <20080627211712.6cto2d1zks848c88@webmail1.sjtu.edu.cn>
	<e2e108260806270625o44ebe7a0u8250fa0bd5e976bd@mail.gmail.com>
	<20080627213805.jdqshto0ys4oookk@webmail1.sjtu.edu.cn>
	<20080627184815.GB10511@sgi.com>
In-Reply-To: <20080627184815.GB10511@sgi.com>
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

Quoting Robin Holt <holt@sgi.com>:

> On Fri, Jun 27, 2008 at 09:38:05PM +0800, xialiang wrote:
>> Quoting Bart Van Assche <bart.vanassche@gmail.com>:
>>
>>> On Fri, Jun 27, 2008 at 3:17 PM, одаа <xiaiaxaxi@sjtu.edu.cn> wrote:
>>>> I am working on Intel Duo Core with Linux OS 2.6.21, and I'd like to
>>>> migrate task from one cpu to another cpu.
>>>> In SMP systems, load_balance() function uses move_tasks() to move  
>>>>  processes
>>>> from source runqueue to local runqueue, but it does not move a currently
>>>> running task. If I want to migrate a currently running task from source
>>>> runqueue to local runqueue, how can I do? Any suggestion is preferred.
>>>
>>> Are you familiar with the glibc pthread_setaffinity_np() function
>>> and/or the sched_setaffinity() system call ?
>>>
>>> Bart.
>>>
>>
>> Yes. I know sched_setaffinity(), it sets cpu_mask of a task. I want to
>> use it in a timer interrupt( scheduler_tick() ), can I?
>
> Don't use it from a timer handler.  You can use migrate_task() to move the
> task, but your email from a couple days ago said you wanted to move the
> task at the head of the runqueue due to cpu heat or something like that.
> That is a very imprecise way to move the task as any unfortunate task
> that happens to be running when the timer tick occurs could get migrated,
> not the one generating the work.
>
> I think you really want to look at the other areas of the kernel which do
> stuff like throttling the cpu.  Just moving a task off the cpu does not
> prevent it from being used for another compute intesive load.  You could
> take the cpu offline.  I guess to do that, I would use schedule_work()
> or kthread_create() to get out of the timer context and into a regular
> thread context then take the cpu offline from there.
>
> Good Luck,
> Robin
>

       I would move a task at the head of the runqueue, but I already  
know which task creates the heat. I get the profile of tasks  
beforehand. So if I find the temperature of a cpu is much higher than  
that of the other, and coincidentally the currently running task of  
the cpu is what I want to migrate. Can I migrate it in the  
scheduler_tick()? Or where should I put the migration code? Thanks!

Best regards,
Liang

