Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYI0CbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYI0CbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 22:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYI0Cad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 22:30:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50465 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbYI0Caa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 22:30:30 -0400
Date: Fri, 26 Sep 2008 22:30:02 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: avi@qumranet.com
Subject: inconsistent lock state. (kvm)
Message-ID: <20080927023002.GA28250@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, avi@qumranet.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just triggered this with just modprobe kvm_intel ; rmmod kvm kvm_intel

	Dave

=================================
[ INFO: inconsistent lock state ]
2.6.26.3-29.fc9.x86_64.debug #1
---------------------------------
inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
Xorg/2680 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (kvm_lock){+-..}, at: [<ffffffffa0463ad6>] decache_vcpus_on_cpu+0x20/0xbd [kvm]
{hardirq-on-W} state was registered at:
  [<ffffffff81058ead>] __lock_acquire+0x62f/0xd89
  [<ffffffff8105969d>] lock_acquire+0x96/0xc3
  [<ffffffff812bd7b3>] _spin_lock+0x26/0x53
  [<ffffffffa046713d>] mmu_shrink+0x26/0x116 [kvm]
  [<ffffffff810912ed>] shrink_slab+0x70/0x158
  [<ffffffff810921d7>] try_to_free_pages+0x25c/0x365
  [<ffffffff8108c7fc>] __alloc_pages_internal+0x2ef/0x49c
  [<ffffffff8108c9b2>] __alloc_pages_nodemask+0x9/0xb
  [<ffffffff810a8aa3>] alloc_pages_current+0xb9/0xc2
  [<ffffffff8108bb47>] __get_free_pages+0xe/0x4d
  [<ffffffff810f9630>] proc_pid_attr_write+0x65/0xe4
  [<ffffffff810b6f89>] vfs_write+0xae/0x157
  [<ffffffff810b70f6>] sys_write+0x47/0x6f
  [<ffffffff8100c0fa>] system_call_after_swapgs+0x8a/0x8f
  [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 1251057442
hardirqs last  enabled at (1251057441): [<ffffffff812bd23a>] trace_hardirqs_on_thunk+0x35/0x3a
hardirqs last disabled at (1251057442): [<ffffffff812bd274>] trace_hardirqs_off_thunk+0x35/0x37
softirqs last  enabled at (1251057438): [<ffffffff8103d25d>] __do_softirq+0xf2/0x101
softirqs last disabled at (1251057433): [<ffffffff8100d64c>] call_softirq+0x1c/0x28

other info that might help us debug this:
no locks held by Xorg/2680.

stack backtrace:
Pid: 2680, comm: Xorg Not tainted 2.6.26.3-29.fc9.x86_64.debug #1

Call Trace:
 <IRQ>  [<ffffffff81057828>] print_usage_bug+0x15e/0x16f
 [<ffffffff81057d00>] mark_lock+0x126/0x463
 [<ffffffff81058e2f>] __lock_acquire+0x5b1/0xd89
 [<ffffffff81056741>] ? lock_release_holdtime+0x1e/0x109
 [<ffffffff812bd637>] ? _spin_unlock_irq+0x2b/0x37
 [<ffffffff8105969d>] lock_acquire+0x96/0xc3
 [<ffffffffa0463ad6>] ? :kvm:decache_vcpus_on_cpu+0x20/0xbd
 [<ffffffff812bd7b3>] _spin_lock+0x26/0x53
 [<ffffffffa045e8a1>] ? :kvm:hardware_disable+0x0/0x2f
 [<ffffffffa0463ad6>] :kvm:decache_vcpus_on_cpu+0x20/0xbd
 [<ffffffffa045e8a1>] ? :kvm:hardware_disable+0x0/0x2f
 [<ffffffffa045e8c7>] :kvm:hardware_disable+0x26/0x2f
 [<ffffffff8101a836>] smp_call_function_interrupt+0x45/0x6e
 [<ffffffff8100cf47>] call_function_interrupt+0x77/0x80
 <EOI> 


-- 
http://www.codemonkey.org.uk
