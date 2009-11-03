Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZKCQqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZKCQqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZKCQqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:46:44 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:39077 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZKCQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:46:44 -0500
Message-ID: <4AF05E0C.5090305@monstr.eu>
Date: Tue, 03 Nov 2009 17:45:00 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Ftrace for Microblaze - notrace
References: <4AF030EE.7050609@monstr.eu> <1257266154.31359.14.camel@localhost.localdomain>
In-Reply-To: <1257266154.31359.14.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 2009-11-03 at 14:32 +0100, Michal Simek wrote:
>> Hi Thomas, Ingo, Steven and others
>>
>> I am working on ftrace support for Microblaze. I have done basic ftrace
>> support - initcall, kmemtrace and other.
>> Currently I am working on function trace support.  I did asm code as is
>> written in Documentation/trace/ftrace-design.txt.
>>
>> I have two poins/questions.
>>
>> I desided to use HAVE_FUNCTION_TRACE_MCOUNT_TEST - just test 
>> function_trace_stop in asm code - that shouldn't be a problem.
> 
> Yeah, and if you don't have that, it is taken care of in the generic
> code too.

jj, I know - asm checking is just two instruction - that's why I use it.

> 
>> I disable -pg in main Makefile because not work for me (more info below) 
>> and I enable it just for two file in arch/microblaze (irq.c and intc.c) 
>> - recompile kernel and test. Log is below and you can see that I am able 
>> to see output for function. That's why I think that my mcount function 
>> should be correct. Am I right?
>>
>> uclinux login: root
>> Password:
>> # cd ; mkdir /debug; mount -t debugfs none /debug; cat 
>> /debug/tracing/available_
>> tracers; echo function > /debug/tracing/current_tracer;echo 1 > 
>> /debug/tracing/t
>> racing_enabled;cat /debug/tracing/trace | head -n 10
>> wakeup_rt wakeup function sched_switch nop
>> # tracer: function
>> #
>> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>> #              | |       |          |         |
>>                sh-52    [000]   184.940000: irq_call <-do_IRQ
>>                sh-52    [000]   184.940000: do_IRQ <-get_irq
>>                sh-52    [000]   184.940000: handle_level_irq <-intc_mask_ack
>>                sh-52    [000]   184.950000: handle_level_irq 
>> <-intc_enable_or_unmask
>>                sh-52    [000]   184.950000: do_IRQ <-get_irq
>>                sh-52    [000]   184.950000: handle_level_irq <-intc_mask_ack
>> #
>>
>>
>> When is used -pg flag kernel stops when I enable function tracer.
>> Interesting is that freeze than I setup function tracing (echo function 
>>  > .../current/tracer). Is it correct behavior? I think that trace 
>> should start after (echo 1>  .../tracing_enabled).
> 
> No, tracing_enabled is default on and should not be used (may go away).
> Tracing starts as soon as you echo function into current_tracer.

ok


> 
>>
>> The next thing is about annotation notrace. I look at all arch. Is there 
>> any algorithm which function should use it? I think that this could be a 
>>   reason why I my kernel freeze when enable function tracer.
>>
>> I tested to add -pg flag for process.c file and after it kernel freeze 
>> too. Is it mean that problem could be there?
> 
> Probably.

Is there any manual or instruction which functions are dangerous and 
especially why?


> 
>> Any other suggestion?
> 
> Just remember that -pg is very intrusive. I don't know your arch, nor
> have I seen the code you did to update it. You can disable the -pg from
> process.c by adding in the Makefile:
> 
> CFLAGS_REMOVE_process.o = -pg

jj, I know how to do it.

> 
> And that will keep the process.c from being compiled with it. There may
> be other files in the arch that should not have it. There's several in
> x86 and in PowerPC.

Do you know why they exclude it?

Can I use any special debug features? I mean I look at kernel.h and 
there are some trace_printk function - but they don't work for me. Is it 
possible to use them or not?

Thanks,
Michal

> 
> -- Steve
> 
> 

