Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbZKCNeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbZKCNeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZKCNeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:34:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:8270 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZKCNeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:34:10 -0500
Message-ID: <4AF030EE.7050609@monstr.eu>
Date: Tue, 03 Nov 2009 14:32:30 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: mingo@elte.hu, srostedt@redhat.com
CC: linux-kernel@vger.kernel.org, John Williams <john.williams@petalogix.com>,
       linux-kernel@vger.kernel.org
Subject: Ftrace for Microblaze - notrace
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Ingo, Steven and others

I am working on ftrace support for Microblaze. I have done basic ftrace
support - initcall, kmemtrace and other.
Currently I am working on function trace support.  I did asm code as is
written in Documentation/trace/ftrace-design.txt.

I have two poins/questions.

I desided to use HAVE_FUNCTION_TRACE_MCOUNT_TEST - just test 
function_trace_stop in asm code - that shouldn't be a problem.

I disable -pg in main Makefile because not work for me (more info below) 
and I enable it just for two file in arch/microblaze (irq.c and intc.c) 
- recompile kernel and test. Log is below and you can see that I am able 
to see output for function. That's why I think that my mcount function 
should be correct. Am I right?

uclinux login: root
Password:
# cd ; mkdir /debug; mount -t debugfs none /debug; cat 
/debug/tracing/available_
tracers; echo function > /debug/tracing/current_tracer;echo 1 > 
/debug/tracing/t
racing_enabled;cat /debug/tracing/trace | head -n 10
wakeup_rt wakeup function sched_switch nop
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
               sh-52    [000]   184.940000: irq_call <-do_IRQ
               sh-52    [000]   184.940000: do_IRQ <-get_irq
               sh-52    [000]   184.940000: handle_level_irq <-intc_mask_ack
               sh-52    [000]   184.950000: handle_level_irq 
<-intc_enable_or_unmask
               sh-52    [000]   184.950000: do_IRQ <-get_irq
               sh-52    [000]   184.950000: handle_level_irq <-intc_mask_ack
#


When is used -pg flag kernel stops when I enable function tracer.
Interesting is that freeze than I setup function tracing (echo function 
 > .../current/tracer). Is it correct behavior? I think that trace 
should start after (echo 1>  .../tracing_enabled).


The next thing is about annotation notrace. I look at all arch. Is there 
any algorithm which function should use it? I think that this could be a 
  reason why I my kernel freeze when enable function tracer.

I tested to add -pg flag for process.c file and after it kernel freeze 
too. Is it mean that problem could be there?

Any other suggestion?


Thanks for your help,
Michal


