Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZIAUbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZIAUbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZIAUbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:31:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41569 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbZIAUbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:31:03 -0400
Date: Tue, 1 Sep 2009 22:31:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: WARNING: at arch/x86/kernel/smp.c:117
	native_smp_send_reschedule+0x51/0x60()
Message-ID: <20090901203105.GH12579@kernel.dk>
References: <20090831204349.GE12579@kernel.dk> <20090901143942.GA5394@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090901143942.GA5394@hack>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01 2009, Américo Wang wrote:
> On Mon, Aug 31, 2009 at 10:43:49PM +0200, Jens Axboe wrote:
> >Hi,
> >
> >I get this on every reboot/kexec/halt:
> >
> >WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule+0x51/0x60()
> >Modules linked in: raid0 md_mod loop hid_apple usbhid mptsas mptscsih
> >mptbase scsi_transport_sas ehci_hcd uhci_hcd usbcore nls_base igb sg
> >sr_mod cdrom
> >Pid: 6998, comm: halt Not tainted 2.6.31-rc8 #105
> >Call Trace:
> > <IRQ>  [<ffffffff81023d38>] ? lapic_next_event+0x18/0x20
> > [<ffffffff810233e1>] ? native_smp_send_reschedule+0x51/0x60
> > [<ffffffff8104e7e8>] warn_slowpath_common+0x78/0xd0
> > [<ffffffff8104e84f>] warn_slowpath_null+0xf/0x20
> > [<ffffffff810233e1>] native_smp_send_reschedule+0x51/0x60
> > [<ffffffff81037ae8>] resched_task+0x68/0x80
> > [<ffffffff81041165>] resched_cpu+0x75/0x90
> > [<ffffffff8104a1db>] scheduler_tick+0x25b/0x290
> > [<ffffffff8105b8b6>] update_process_times+0x56/0x70
> > [<ffffffff81076cb6>] tick_sched_timer+0x66/0xc0
> > [<ffffffff81076c50>] ? tick_sched_timer+0x0/0xc0
> > [<ffffffff8106c351>] __run_hrtimer+0x51/0xc0
> > [<ffffffff8106d0a5>] hrtimer_interrupt+0xd5/0x1c0
> > [<ffffffff81024938>] smp_apic_timer_interrupt+0x68/0xa0
> > [<ffffffff8100ca23>] apic_timer_interrupt+0x13/0x20
> > <EOI>  [<ffffffff81028ffb>] ? x2apic_send_IPI_allbutself+0x9b/0xb0
> > [<ffffffff810234ac>] ? native_smp_send_stop+0x4c/0x90
> > [<ffffffff81022dfe>] ? native_machine_shutdown+0x5e/0x90
> > [<ffffffff81022a66>] ? native_machine_power_off+0x26/0x30
> > [<ffffffff81022a7a>] ? machine_power_off+0xa/0x10
> > [<ffffffff810619d4>] ? kernel_power_off+0x34/0x40
> > [<ffffffff81061cba>] ? sys_reboot+0x13a/0x210
> > [<ffffffff8105e83e>] ? group_send_sig_info+0x6e/0x90
> > [<ffffffff8105e8b0>] ? kill_pid_info+0x50/0xa0
> > [<ffffffff8105eb95>] ? sys_kill+0xa5/0x200
> > [<ffffffff8106d289>] ? up_read+0x9/0x10
> > [<ffffffff8102ede9>] ? do_page_fault+0x1a9/0x310
> > [<ffffffff8100bf6b>] ? system_call_fastpath+0x16/0x1b
> >
> 
> Hmm, maybe some race condition happens...
> 
> Add Ingo into Cc:.
> 
> Your .config and dmesg are appreciated.

I'll send in the .config tomorrow when the box is up again, but
unfortunately I cannot post a full dmesg from this box. If there's
anything specific you want to look, I can post that. Otherwise I'll
probably try poking at this a bit, when some idle time appears.

-- 
Jens Axboe

