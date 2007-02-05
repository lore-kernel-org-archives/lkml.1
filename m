Return-Path: <linux-kernel-owner+w=401wt.eu-S933499AbXBEVvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499AbXBEVvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933493AbXBEVvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:51:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:53088 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497AbXBEVvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:51:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=iwdMdOw+lwVspSPGpJ9kI85ojsyQAGgjRjv3GdZ6rX1l3S3YDNBQ3z20QXVSt+Ynmr036N+uxV9RgFZKx+cMHXyV5WoM2iRHjeD3stw8KEyzyIdnyKSrP7EZTqQL2H7oPkpEi/HdmId0KrB2xhe/Z9QtcpQdAS0j1a0FONI595k=
Message-ID: <45C7A6B9.3080604@googlemail.com>
Date: Mon, 05 Feb 2007 22:50:49 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.20-rt1, yum/rpm
References: <20070205065636.GA1652@elte.hu>
In-Reply-To: <20070205065636.GA1652@elte.hu>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar napisał(a):
> i have released the v2.6.20-rt1 kernel, which can be downloaded from the 
> usual place:
> 
>   http://redhat.com/~mingo/realtime-preempt/
> 
> more info about the -rt patchset can be found in the RT wiki:

2.6.20-rt2

echo shutdown > /sys/power/disk; echo disk > /sys/power/state

Disabling non-boot CPUs ...
CPU1 playing dead
 [<c01041a3>] dump_trace+0x63/0x1eb
 [<c0104348>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a23>] show_trace+0x12/0x14
 [<c0104ab6>] dump_stack+0x16/0x18
 [<c01013a5>] cpu_idle+0x8d/0x11e
 [<c0112d05>] start_secondary+0x35a/0x362
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c010142b>] .... cpu_idle+0x113/0x11e
.....[<c0112d05>] ..   ( <= start_secondary+0x35a/0x362)

0xc010142b is in cpu_idle (arch/i386/kernel/process.c:204).
199                     tick_nohz_restart_sched_tick();
200                     local_irq_disable();
201                     __preempt_enable_no_resched();
202                     __schedule();
203                     preempt_disable();
204                     local_irq_enable();
205             }
206     }
207
208     void cpu_idle_wait(void)

0xc0112d05 is in start_secondary (arch/i386/kernel/smpboot.c:432).
427             /* We can take interrupts now: we're officially "up". */
428             local_irq_enable();
429
430             wmb();
431             cpu_idle();
432     }
433
434     /*
435      * Everything has been set up for the secondary
436      * CPUs - they just need to reload everything


lapic suspend on CPU#0
 [<c01041a3>] dump_trace+0x63/0x1eb
 [<c0104348>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a23>] show_trace+0x12/0x14
 [<c0104ab6>] dump_stack+0x16/0x18
 [<c0113ac8>] lapic_suspend+0xd8/0x101
 [<c02543c0>] sysdev_suspend+0x8d/0x1ee
 [<c0258117>] device_power_down+0x119/0x152
 [<c014ab42>] swsusp_suspend+0x17/0x67
 [<c014b2a1>] pm_suspend_disk+0x9a/0x161
 [<c014a169>] enter_state+0x52/0x1bb
 [<c014a358>] state_store+0x86/0x9c
 [<c01abed4>] subsys_attr_store+0x20/0x25
 [<c01ac176>] sysfs_write_file+0xa1/0xc2
 [<c0177962>] vfs_write+0xaf/0x163
 [<c0177fda>] sys_write+0x40/0x67
 [<c01030e0>] syscall_call+0x7/0xb
 [<b7f74410>] 0xb7f74410
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

swsusp: critical section:
swsusp: Need to copy 122686 pages
swsusp: Normal pages needed: 36485 + 1024 + 40, available pages: 192889
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
lapic resume on CPU#0
 [<c01041a3>] dump_trace+0x63/0x1eb
 [<c0104348>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a23>] show_trace+0x12/0x14
 [<c0104ab6>] dump_stack+0x16/0x18
 [<c0113b22>] lapic_resume+0x31/0x1c3
 [<c025404e>] __sysdev_resume+0x14/0x57
 [<c025453a>] sysdev_resume+0x19/0x54
 [<c02585a7>] device_power_up+0x8/0xf
 [<c014ab85>] swsusp_suspend+0x5a/0x67
 [<c014b2a1>] pm_suspend_disk+0x9a/0x161
 [<c014a169>] enter_state+0x52/0x1bb
 [<c014a358>] state_store+0x86/0x9c
 [<c01abed4>] subsys_attr_store+0x20/0x25
 [<c01ac176>] sysfs_write_file+0xa1/0xc2
 [<c0177962>] vfs_write+0xaf/0x163
 [<c0177fda>] sys_write+0x40/0x67
 [<c01030e0>] syscall_call+0x7/0xb
 [<b7f74410>] 0xb7f74410
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-rt2/rt-dmesg2
http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-rt2/rt-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
