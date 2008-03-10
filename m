Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbYCJMy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbYCJMy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 08:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYCJMyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 08:54:18 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:47496 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYCJMyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 08:54:17 -0400
Date: Mon, 10 Mar 2008 18:24:14 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86: Don't send RESCHEDULE_VECTOR to offlined cpus
Message-ID: <20080310125414.GE17646@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080310121403.GD17646@in.ibm.com> <20080310122418.GA12101@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310122418.GA12101@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 01:24:18PM +0100, Ingo Molnar wrote:
> 
> * Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > x86: Don't send RESCHEDULE_VECTOR to offlined cpus.
> > From: Gautham R Shenoy <ego@in.ibm.com>
> > 
> > In the x86 native_smp_send_reschedule_function(), don't send the IPI 
> > if the cpu has gone offline already. Warn nevertheless!!
> 
> have you seen this happen?

Yup, this afternoon while running
cpu-hotplug stress tests (http://lkml.org/lkml/2008/3/3/11)
in parallel with kern-bench, I got this on the serial console.

------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp_32.c:475 native_smp_send_reschedule+0x22/0x3f()
Modules linked in: dock
Pid: 4722, comm: kstopmachine Not tainted 2.6.25-rc3 #46
 [<c011f424>] warn_on_slowpath+0x41/0x51
 [<c013ac74>] ? __lock_acquire+0xaae/0xaf6
 [<c011a446>] ? resched_cpu+0x2c/0x6f
 [<c0111691>] native_smp_send_reschedule+0x22/0x3f
 [<c01186c7>] __resched_task+0x5f/0x63
 [<c011a479>] resched_cpu+0x5f/0x6f
 [<c011bb6d>] scheduler_tick+0x214/0x28f
 [<c012737b>] update_process_times+0x3d/0x49
 [<c013751d>] tick_sched_timer+0x6e/0xa6
 [<c01374af>] ? tick_sched_timer+0x0/0xa6
 [<c0131e8c>] __run_hrtimer+0x39/0x70
 [<c0132668>] hrtimer_interrupt+0xeb/0x154
 [<c01127bc>] smp_apic_timer_interrupt+0x6c/0x80
 [<c0143670>] ? stopmachine+0x0/0x98
 [<c0105553>] apic_timer_interrupt+0x33/0x38
 [<c0143670>] ? stopmachine+0x0/0x98
 [<c013007b>] ? sample_to_timespec+0x16/0x35
 [<c0143701>] ? stopmachine+0x91/0x98
 [<c01056eb>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 1016b68a0b60b50b ]---
------------[ cut here ]------------

> 
> 	Ingo

-- 
Thanks and Regards
gautham
