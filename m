Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbZEOMoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbZEOMoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZEOMoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:44:20 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60939 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbZEOMoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:44:19 -0400
Date: Fri, 15 May 2009 14:44:16 +0200
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Michael Di Domenico <mdidomenico4@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel softlocks
Message-ID: <20090515124416.GA12245@gambetta>
References: <e75d22a90905150515u44860fbdm287f6ca17f1cf97c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e75d22a90905150515u44860fbdm287f6ca17f1cf97c@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

The behaviour of the soft lockup has been modified since 2.6.18 to match
the increasing RAM found on systems (flushing large amounts of RAM to
disk tend to keep the CPUs busy).

On recent kernels, the soft lockup threshold is set to 60s whereas 2.6.18
used a 10s threshold, IIRC.

So if you do have large amounts of RAM, you can safely ignore this
warning if you don't observe any other weird behaviour.

Regards,
Frederik

On Fri, May 15, 2009 at 08:15:13AM -0400, Michael Di Domenico wrote:
> I have a user application that seems to be soft locking the linux
> kernel, in this case 2.6.18
> 
> Can anyone narrow down whether this is a bug in the linux kernel (and
> perhaps if so, whether is was fixed in a later version) or not?
> 
> Or what this user application might have done to create this issue if
> its not a bug?
> 
> thanks
> - Michael
> 
> 
> 
> 
> BUG: soft lockup detected on CPU#33!
> 
> Call Trace:
>  [<a000000100013b20>] show_stack+0x40/0xa0
>                        sp=e00000ff000b73d0 bsp=e00000ff000b1818
>  [<a000000100013bb0>] dump_stack+0x30/0x60
>                        sp=e00000ff000b75a0 bsp=e00000ff000b1800
>  [<a0000001000e5fe0>] softlockup_tick+0x240/0x280
>                        sp=e00000ff000b75a0 bsp=e00000ff000b17b8
>  [<a000000100092df0>] run_local_timers+0x30/0x60
>                        sp=e00000ff000b75b0 bsp=e00000ff000b17a0
>  [<a000000100092ea0>] update_process_times+0x80/0x100
>                        sp=e00000ff000b75b0 bsp=e00000ff000b1770
>  [<a000000100037220>] timer_interrupt+0x180/0x360
>                        sp=e00000ff000b75b0 bsp=e00000ff000b1730
>  [<a0000001000e6650>] handle_IRQ_event+0x90/0x120
>                        sp=e00000ff000b75b0 bsp=e00000ff000b16f0
>  [<a0000001000e6810>] __do_IRQ+0x130/0x420
>                        sp=e00000ff000b75b0 bsp=e00000ff000b16a8
>  [<a000000100011630>] ia64_handle_irq+0xf0/0x1a0
>                        sp=e00000ff000b75b0 bsp=e00000ff000b1678
>  [<a00000010000c020>] __ia64_leave_kernel+0x0/0x280
>                        sp=e00000ff000b75b0 bsp=e00000ff000b1678
>  [<a000000100626b90>] _spin_unlock_irqrestore+0x30/0x60
>                        sp=e00000ff000b7780 bsp=e00000ff000b1660
>  [<a0000001000989d0>] force_sig_info+0x130/0x160
>                        sp=e00000ff000b7780 bsp=e00000ff000b1620
>  [<a00000010003c620>] ia64_handle_unaligned+0x2d00/0x2d20
>                        sp=e00000ff000b7780 bsp=e00000ff000b1580
>  [<a00000010000c630>] ia64_prepare_handle_unaligned+0x30/0x60
>                        sp=e00000ff000b7970 bsp=e00000ff000b1580
>  [<a00000010000c020>] __ia64_leave_kernel+0x0/0x280
>                        sp=e00000ff000b7b80 bsp=e00000ff000b1580
>  [<a0000001000b9150>] exit_robust_list+0x250/0x2e0
>                        sp=e00000ff000b7d50 bsp=e00000ff000b1518
>  [<a000000100081690>] do_exit+0x510/0x14a0
>                        sp=e00000ff000b7d60 bsp=e00000ff000b14c0
>  [<a000000100082770>] do_group_exit+0x150/0x160
>                        sp=e00000ff000b7d80 bsp=e00000ff000b1488
>  [<a000000100099a00>] get_signal_to_deliver+0x740/0x7c0
>                        sp=e00000ff000b7d80 bsp=e00000ff000b1438
>  [<a0000001000341d0>] ia64_do_signal+0x90/0xde0
>                        sp=e00000ff000b7d80 bsp=e00000ff000b1350
>  [<a0000001000139a0>] do_notify_resume_user+0x100/0x160
>                        sp=e00000ff000b7e20 bsp=e00000ff000b1320
>  [<a00000010000c500>] notify_resume_user+0x40/0x60
>                        sp=e00000ff000b7e20 bsp=e00000ff000b12d0
>  [<a00000010000c430>] skip_rbs_switch+0xe0/0x110
>                        sp=e00000ff000b7e30 bsp=e00000ff000b12d0
> 
> BUG: soft lockup detected on CPU#72!
> 
> Call Trace:
>  [<a000000100013b20>] show_stack+0x40/0xa0
>                        sp=e00000fbe5e3f3d0 bsp=e00000fbe5e39830
>  [<a000000100013bb0>] dump_stack+0x30/0x60
>                        sp=e00000fbe5e3f5a0 bsp=e00000fbe5e39818
>  [<a0000001000e5fe0>] softlockup_tick+0x240/0x280
>                        sp=e00000fbe5e3f5a0 bsp=e00000fbe5e397d0
>  [<a000000100092df0>] run_local_timers+0x30/0x60
>                        sp=e00000fbe5e3f5b0 bsp=e00000fbe5e397b8
>  [<a000000100092ea0>] update_process_times+0x80/0x100
>                        sp=e00000fbe5e3f5b0 bsp=e00000fbe5e39788
>  [<a000000100037220>] timer_interrupt+0x180/0x360
>                        sp=e00000fbe5e3f5b0 bsp=e00000fbe5e39748
>  [<a0000001000e6650>] handle_IRQ_event+0x90/0x120
>                        sp=e00000fbe5e3f5b0 bsp=e00000fbe5e39708
>  [<a0000001000e6810>] __do_IRQ+0x130/0x420
>                        sp=e00000fbe5e3f5b0 bsp=e00000fbe5e396c0
>  [<a000000100011630>] ia64_handle_irq+0xf0/0x1a0
>                        sp=e00000fbe5e3f5b0 bsp=e00000fbe5e39690
>  [<a00000010000c020>] __ia64_leave_kernel+0x0/0x280
>                        sp=e00000fbe5e3f5b0 bsp=e00000fbe5e39690
>  [<a000000100009100>] ia64_spinlock_contention+0x20/0x60
>                        sp=e00000fbe5e3f780 bsp=e00000fbe5e39690
>  [<a000000100626a20>] _spin_lock_irqsave+0x60/0x80
>                        sp=e00000fbe5e3f780 bsp=e00000fbe5e39688
>  [<a0000001000988d0>] force_sig_info+0x30/0x160
>                        sp=e00000fbe5e3f780 bsp=e00000fbe5e39648
>  [<a00000010003c620>] ia64_handle_unaligned+0x2d00/0x2d20
>                        sp=e00000fbe5e3f780 bsp=e00000fbe5e395a8
>  [<a00000010000c630>] ia64_prepare_handle_unaligned+0x30/0x60
>                        sp=e00000fbe5e3f970 bsp=e00000fbe5e395a8
>  [<a00000010000c020>] __ia64_leave_kernel+0x0/0x280
>                        sp=e00000fbe5e3fb80 bsp=e00000fbe5e395a8
>  [<a0000001000b4ff0>] handle_futex_death+0x90/0x1a0
>                        sp=e00000fbe5e3fd50 bsp=e00000fbe5e39568
>  [<a0000001000b90f0>] exit_robust_list+0x1f0/0x2e0
>                        sp=e00000fbe5e3fd50 bsp=e00000fbe5e39518
>  [<a000000100081690>] do_exit+0x510/0x14a0
>                        sp=e00000fbe5e3fd60 bsp=e00000fbe5e394c0
>  [<a000000100082770>] do_group_exit+0x150/0x160
>                        sp=e00000fbe5e3fd80 bsp=e00000fbe5e39488
>  [<a000000100099a00>] get_signal_to_deliver+0x740/0x7c0
>                        sp=e00000fbe5e3fd80 bsp=e00000fbe5e39438
>  [<a0000001000341d0>] ia64_do_signal+0x90/0xde0
>                        sp=e00000fbe5e3fd80 bsp=e00000fbe5e39350
>  [<a0000001000139a0>] do_notify_resume_user+0x100/0x160
>                        sp=e00000fbe5e3fe20 bsp=e00000fbe5e39320
>  [<a00000010000c500>] notify_resume_user+0x40/0x60
>                        sp=e00000fbe5e3fe20 bsp=e00000fbe5e392d0
>  [<a00000010000c430>] skip_rbs_switch+0xe0/0x110
>                        sp=e00000fbe5e3fe30 bsp=e00000fbe5e392d0
> 
> BUG: soft lockup detected on CPU#104!
> 
> Call Trace:
>  [<a000000100013b20>] show_stack+0x40/0xa0
>                        sp=e00000fc4b03f7d0 bsp=e00000fc4b039730
>  [<a000000100013bb0>] dump_stack+0x30/0x60
>                        sp=e00000fc4b03f9a0 bsp=e00000fc4b039718
>  [<a0000001000e5fe0>] softlockup_tick+0x240/0x280
>                        sp=e00000fc4b03f9a0 bsp=e00000fc4b0396d8
>  [<a000000100092df0>] run_local_timers+0x30/0x60
>                        sp=e00000fc4b03f9b0 bsp=e00000fc4b0396c0
>  [<a000000100092ea0>] update_process_times+0x80/0x100
>                        sp=e00000fc4b03f9b0 bsp=e00000fc4b039690
>  [<a000000100037220>] timer_interrupt+0x180/0x360
>                        sp=e00000fc4b03f9b0 bsp=e00000fc4b039650
>  [<a0000001000e6650>] handle_IRQ_event+0x90/0x120
>                        sp=e00000fc4b03f9b0 bsp=e00000fc4b039610
>  [<a0000001000e6810>] __do_IRQ+0x130/0x420
>                        sp=e00000fc4b03f9b0 bsp=e00000fc4b0395c0
>  [<a000000100011630>] ia64_handle_irq+0xf0/0x1a0
>                        sp=e00000fc4b03f9b0 bsp=e00000fc4b039590
>  [<a00000010000c020>] __ia64_leave_kernel+0x0/0x280
>                        sp=e00000fc4b03f9b0 bsp=e00000fc4b039590
>  [<a000000100004ac0>] dispatch_unaligned_handler+0x2a0/0x400
>                        sp=e00000fc4b03fb80 bsp=e00000fc4b039580
>  [<a0000001000b90f0>] exit_robust_list+0x1f0/0x2e0
>                        sp=e00000fc4b03fb80 bsp=e00000fc4b039530
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
