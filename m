Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbZDKMI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbZDKMI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 08:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbZDKMIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 08:08:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39935 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496AbZDKMIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 08:08:47 -0400
Message-ID: <49E08857.2090503@redhat.com>
Date: Sat, 11 Apr 2009 15:08:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Problem with kvm on -tip
References: <20090409210738.GA4566@hades.domain.com>
In-Reply-To: <20090409210738.GA4566@hades.domain.com>
Content-Type: multipart/mixed;
 boundary="------------020002020300000309080502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020002020300000309080502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Luis Henriques wrote:
> Hi,
>
> Since I am not sure if this problem has already been reported, here it goes.
>
> My log gets the following messages in -tip tree.  I don't know for how long this
> issue is around and whether the problem is on lockdep or on kvm.  After the
> first lockdep message, I get a huge amount of BUGs from kvm (which stop only
> when I kill kvm).  So, I believe issue is on kvm.
>
> I am running on an AMD64.  Please let me know if more info is needed (config,
> etc).
>
> [ 3293.134688] BUG: MAX_LOCK_DEPTH too low!
>   

Looks like a genuine issue, need to increase MAX_LOCK_DEPTH.  Andrea?

> [ 3293.134704] turning off the locking correctness validator.
> [ 3293.134718] Pid: 5117, comm: kvm Not tainted 2.6.30-rc1-tip-01420-g58e70a8
> #18
> [ 3293.134727] Call Trace:
> [ 3293.134749]  [<ffffffff802805f6>] __lock_acquire+0x4c6/0xbf0
> [ 3293.134764]  [<ffffffff80280e2e>] lock_acquire+0x10e/0x160
> [ 3293.134780]  [<ffffffff802f3760>] ? mm_take_all_locks+0x110/0x150
> [ 3293.134798]  [<ffffffff80580c3b>] _spin_lock_nest_lock+0x3b/0x50
> [ 3293.134811]  [<ffffffff802f3760>] ? mm_take_all_locks+0x110/0x150
> [ 3293.134823]  [<ffffffff802f3760>] mm_take_all_locks+0x110/0x150
> [ 3293.134838]  [<ffffffff803093af>] do_mmu_notifier_register+0xdf/0x1f0
> [ 3293.134852]  [<ffffffff803094f3>] mmu_notifier_register+0x13/0x20
> [ 3293.134899]  [<ffffffffa02edede>] kvm_dev_ioctl+0x1ae/0x360 [kvm]
> [ 3293.134914]  [<ffffffff80327a16>] vfs_ioctl+0x36/0xb0
> [ 3293.134927]  [<ffffffff80327b22>] do_vfs_ioctl+0x92/0x5c0
> [ 3293.134942]  [<ffffffff80273d9b>] ? up_read+0x2b/0x40
> [ 3293.134955]  [<ffffffff8032809f>] sys_ioctl+0x4f/0x80
> [ 3293.134971]  [<ffffffff8020c1f2>] system_call_fastpath+0x16/0x1b request
>   


> [ 3297.598606] BUG: using smp_processor_id() in preemptible [00000000] code: kvm/5118
> [ 3297.598630] caller is kvm_arch_vcpu_ioctl_run+0x61c/0xd10 [kvm]
> [ 3297.598635] Pid: 5118, comm: kvm Not tainted 2.6.30-rc1-tip-01420-g58e70a8 #18
> [ 3297.598638] Call Trace:
> [ 3297.598647]  [<ffffffff803d9db3>] debug_smp_processor_id+0xe3/0xf0
> [ 3297.598660]  [<ffffffffa02f684c>] kvm_arch_vcpu_ioctl_run+0x61c/0xd10 [kvm]
> [ 3297.598667]  [<ffffffff8032de67>] ? file_update_time+0xc7/0x130
> [ 3297.598672]  [<ffffffff802ed26b>] ? do_wp_page+0x1eb/0x7e0
> [ 3297.598684]  [<ffffffffa02ebb23>] kvm_vcpu_ioctl+0x4b3/0x8f0 [kvm]
> [ 3297.598691]  [<ffffffff805804d6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 3297.598696]  [<ffffffff80581a35>] ? do_IRQ+0x95/0x100
> [ 3297.598702]  [<ffffffff8025c85a>] ? irq_exit+0x8a/0xc0
> [ 3297.598707]  [<ffffffff80327a16>] vfs_ioctl+0x36/0xb0
> [ 3297.598712]  [<ffffffff80327b22>] do_vfs_ioctl+0x92/0x5c0
> [ 3297.598716]  [<ffffffff8032809f>] sys_ioctl+0x4f/0x80
> [ 3297.598723]  [<ffffffff8020c1f2>] system_call_fastpath+0x16/0x1b
>   

This might be fixed by the attached patch.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


--------------020002020300000309080502
Content-Type: text/x-patch;
 name="0001-KVM-x86-silence-preempt-warning-on-kvm_write_guest.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-KVM-x86-silence-preempt-warning-on-kvm_write_guest.patc";
 filename*1="h"

>From 248a107e6d5d96fe276b48cef98daecec03804cf Mon Sep 17 00:00:00 2001
From: Matt T. Yourst <yourst@users.sourceforge.net>
Date: Tue, 24 Feb 2009 15:28:00 -0300
Subject: [PATCH] KVM: x86: silence preempt warning on kvm_write_guest_time

This issue just appeared in kvm-84 when running on 2.6.28.7 (x86-64)
with PREEMPT enabled.

We're getting syslog warnings like this many (but not all) times qemu
tells KVM to run the VCPU:

BUG: using smp_processor_id() in preemptible [00000000] code:
qemu-system-x86/28938
caller is kvm_arch_vcpu_ioctl_run+0x5d1/0xc70 [kvm]
Pid: 28938, comm: qemu-system-x86 2.6.28.7-mtyrel-64bit
Call Trace:
debug_smp_processor_id+0xf7/0x100
kvm_arch_vcpu_ioctl_run+0x5d1/0xc70 [kvm]
? __wake_up+0x4e/0x70
? wake_futex+0x27/0x40
kvm_vcpu_ioctl+0x2e9/0x5a0 [kvm]
enqueue_hrtimer+0x8a/0x110
_spin_unlock_irqrestore+0x27/0x50
vfs_ioctl+0x31/0xa0
do_vfs_ioctl+0x74/0x480
sys_futex+0xb4/0x140
sys_ioctl+0x99/0xa0
system_call_fastpath+0x16/0x1b

As it turns out, the call trace is messed up due to gcc's inlining, but
I isolated the problem anyway: kvm_write_guest_time() is being used in a
non-thread-safe manner on preemptable kernels.

Basically kvm_write_guest_time()'s body needs to be surrounded by
preempt_disable() and preempt_enable(), since the kernel won't let us
query any per-CPU data (indirectly using smp_processor_id()) without
preemption disabled. The attached patch fixes this issue by disabling
preemption inside kvm_write_guest_time().

[marcelo: surround only __get_cpu_var calls since the warning
is harmless]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1ecec5..b556b6a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -630,10 +630,12 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	if ((!vcpu->time_page))
 		return;
 
+	preempt_disable();
 	if (unlikely(vcpu->hv_clock_tsc_khz != __get_cpu_var(cpu_tsc_khz))) {
 		kvm_set_time_scale(__get_cpu_var(cpu_tsc_khz), &vcpu->hv_clock);
 		vcpu->hv_clock_tsc_khz = __get_cpu_var(cpu_tsc_khz);
 	}
+	preempt_enable();
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
-- 
1.6.1.1


--------------020002020300000309080502--
