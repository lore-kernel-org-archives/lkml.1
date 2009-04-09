Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbZDIVKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbZDIVKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZDIVKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:10:22 -0400
Received: from relay6.ptmail.sapo.pt ([212.55.154.26]:35342 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752433AbZDIVKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:10:21 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Thu, 9 Apr 2009 22:07:38 +0100
From: Luis Henriques <henrix@sapo.pt>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Problem with kvm on -tip
Message-ID: <20090409210738.GA4566@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since I am not sure if this problem has already been reported, here it goes.

My log gets the following messages in -tip tree.  I don't know for how long this
issue is around and whether the problem is on lockdep or on kvm.  After the
first lockdep message, I get a huge amount of BUGs from kvm (which stop only
when I kill kvm).  So, I believe issue is on kvm.

I am running on an AMD64.  Please let me know if more info is needed (config,
etc).

[ 3293.134688] BUG: MAX_LOCK_DEPTH too low!
[ 3293.134704] turning off the locking correctness validator.
[ 3293.134718] Pid: 5117, comm: kvm Not tainted 2.6.30-rc1-tip-01420-g58e70a8
#18
[ 3293.134727] Call Trace:
[ 3293.134749]  [<ffffffff802805f6>] __lock_acquire+0x4c6/0xbf0
[ 3293.134764]  [<ffffffff80280e2e>] lock_acquire+0x10e/0x160
[ 3293.134780]  [<ffffffff802f3760>] ? mm_take_all_locks+0x110/0x150
[ 3293.134798]  [<ffffffff80580c3b>] _spin_lock_nest_lock+0x3b/0x50
[ 3293.134811]  [<ffffffff802f3760>] ? mm_take_all_locks+0x110/0x150
[ 3293.134823]  [<ffffffff802f3760>] mm_take_all_locks+0x110/0x150
[ 3293.134838]  [<ffffffff803093af>] do_mmu_notifier_register+0xdf/0x1f0
[ 3293.134852]  [<ffffffff803094f3>] mmu_notifier_register+0x13/0x20
[ 3293.134899]  [<ffffffffa02edede>] kvm_dev_ioctl+0x1ae/0x360 [kvm]
[ 3293.134914]  [<ffffffff80327a16>] vfs_ioctl+0x36/0xb0
[ 3293.134927]  [<ffffffff80327b22>] do_vfs_ioctl+0x92/0x5c0
[ 3293.134942]  [<ffffffff80273d9b>] ? up_read+0x2b/0x40
[ 3293.134955]  [<ffffffff8032809f>] sys_ioctl+0x4f/0x80
[ 3293.134971]  [<ffffffff8020c1f2>] system_call_fastpath+0x16/0x1b request
[ 3297.598606] BUG: using smp_processor_id() in preemptible [00000000] code: kvm/5118
[ 3297.598630] caller is kvm_arch_vcpu_ioctl_run+0x61c/0xd10 [kvm]
[ 3297.598635] Pid: 5118, comm: kvm Not tainted 2.6.30-rc1-tip-01420-g58e70a8 #18
[ 3297.598638] Call Trace:
[ 3297.598647]  [<ffffffff803d9db3>] debug_smp_processor_id+0xe3/0xf0
[ 3297.598660]  [<ffffffffa02f684c>] kvm_arch_vcpu_ioctl_run+0x61c/0xd10 [kvm]
[ 3297.598667]  [<ffffffff8032de67>] ? file_update_time+0xc7/0x130
[ 3297.598672]  [<ffffffff802ed26b>] ? do_wp_page+0x1eb/0x7e0
[ 3297.598684]  [<ffffffffa02ebb23>] kvm_vcpu_ioctl+0x4b3/0x8f0 [kvm]
[ 3297.598691]  [<ffffffff805804d6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 3297.598696]  [<ffffffff80581a35>] ? do_IRQ+0x95/0x100
[ 3297.598702]  [<ffffffff8025c85a>] ? irq_exit+0x8a/0xc0
[ 3297.598707]  [<ffffffff80327a16>] vfs_ioctl+0x36/0xb0
[ 3297.598712]  [<ffffffff80327b22>] do_vfs_ioctl+0x92/0x5c0
[ 3297.598716]  [<ffffffff8032809f>] sys_ioctl+0x4f/0x80
[ 3297.598723]  [<ffffffff8020c1f2>] system_call_fastpath+0x16/0x1b

