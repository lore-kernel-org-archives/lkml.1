Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZIKWHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZIKWHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZIKWHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:07:16 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:42470 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbZIKWHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:07:15 -0400
Date: Fri, 11 Sep 2009 23:07:16 +0100
From: Chris Webb <chris@arachsys.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: Re:  WARNING: at arch/x86/kernel/smp.c:117
Message-ID: <20090911220716.GK751@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831204349.GE12579@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> I get this on every reboot/kexec/halt:
>
> WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule+0x51/0x60()

I'm also seeing this following a system halt on the released 2.6.31 kernel
running in a qemu-kvm virtual machine, although there's no warning during
reboot there: 

  WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule+0x25/0x51()
  Hardware name:
  Modules linked in:
  Pid: 5256, comm: init Not tainted 2.6.31-elastic-lon-p #1
  Call Trace:
   <IRQ>  [<ffffffff812509b4>] ? vgacon_set_cursor_size+0xfd/0x109
   [<ffffffff8106220e>] warn_slowpath_common+0x77/0x8f
   [<ffffffff81062235>] warn_slowpath_null+0xf/0x11
   [<ffffffff8103ecb6>] native_smp_send_reschedule+0x25/0x51
   [<ffffffff810540bd>] resched_task+0x63/0x65
   [<ffffffff81058275>] resched_cpu+0x4a/0x5e
   [<ffffffff810820c0>] ? tick_sched_timer+0x0/0x94
   [<ffffffff8105e2ac>] scheduler_tick+0x182/0x232
   [<ffffffff810820c0>] ? tick_sched_timer+0x0/0x94
   [<ffffffff8106c3ba>] update_process_times+0x52/0x62
   [<ffffffff8108212a>] tick_sched_timer+0x6a/0x94
   [<ffffffff81079db1>] __run_hrtimer+0x52/0x86
   [<ffffffff8107a8e7>] hrtimer_interrupt+0xf1/0x15b
   [<ffffffff8103fb3b>] smp_apic_timer_interrupt+0x13/0x20
   [<ffffffff8102ca23>] apic_timer_interrupt+0x13/0x20
   <EOI>  [<ffffffff81237517>] ? delay_tsc+0x38/0xd1
   [<ffffffff81237425>] ? __delay+0xa/0xc
   [<ffffffff81237464>] ? __const_udelay+0x3d/0x3f
   [<ffffffff8103ed97>] ? native_smp_send_stop+0x51/0x79
   [<ffffffff8103e811>] ? native_machine_shutdown+0x49/0x60
   [<ffffffff8103e53e>] ? native_shutdown+0xa/0xc
   [<ffffffff8103e608>] ? native_machine_halt+0x9/0x12
   [<ffffffff8103e590>] ? machine_halt+0xa/0xc
   [<ffffffff81071612>] ? kernel_halt+0x26/0x28
   [<ffffffff8107174a>] ? sys_reboot+0xe6/0x152
   [<ffffffff810bfce1>] ? handle_mm_fault+0x34e/0x6e1
   [<ffffffff814b816f>] ? page_fault+0x1f/0x30
   [<ffffffff81234623>] ? __up_read+0x9c/0xa5
   [<ffffffff8107a9ff>] ? up_read+0x9/0xb
   [<ffffffff81046483>] ? do_page_fault+0x230/0x260
   [<ffffffff814b816f>] ? page_fault+0x1f/0x30
   [<ffffffff8102bf6b>] ? system_call_fastpath+0x16/0x1b

Is this likely to be a harmless warning or indicative of a more serious
problem with this kernel version (or config)?

Cheers,

Chris.
