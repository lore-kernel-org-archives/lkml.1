Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYEEKQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYEEKQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYEEKQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:16:50 -0400
Received: from smtp1.Stanford.EDU ([171.67.22.28]:36755 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYEEKQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:16:49 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 May 2008 06:16:49 EDT
Subject: BUG: sleeping function called from invalid context (highmem_32.c:8)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Fernando Pablo Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Content-Type: text/plain
Date: Mon, 05 May 2008 12:03:26 +0200
Message-Id: <1209981806.4564.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, I'm testing a new realtime kernel and I'm getting tons of
these. I got two complete freezes (no sysrq response) since I started to
test yesterday, but I have no way of knowing whether these reports are
related to the freezes. 

Kernel i686: 2.6.24.6 + 2.6.24.4-rt4 (with three chunks tweaked to
patch) + almost all realtime mrg kernel revision 47 patches + compatible
fedora patches from 2.6.24.4-85. 

I'm including some of the "BUG" reports, let me know if you want more. 
(please cc me, I'm not reading the list right now)
-- Fernando

May  5 11:28:14 localhost kernel: BUG: sleeping function called from
invalid context nscd(2239) at arch/x86/mm/highmem_32.c:8
May  5 11:28:14 localhost kernel: in_atomic():0 [00000000],
irqs_disabled():1
May  5 11:28:14 localhost kernel: Pid: 2239, comm: nscd Not tainted
2.6.24.6-1.rt4.3.fc8.ccrmart #1
May  5 11:28:14 localhost kernel:  [<c0424351>] kmap+0x44/0x54
May  5 11:28:14 localhost kernel:  [<c0423be3>] gup_pte_range+0x4f/0xe0
May  5 11:28:14 localhost kernel:  [<c0423de8>] fast_gup+0xe2/0x18e
May  5 11:28:14 localhost kernel:  [<c044b277>] get_futex_key+0x6e/0xa1
May  5 11:28:14 localhost kernel:  [<c044b904>] futex_wake+0x3b/0xc2
May  5 11:28:14 localhost kernel:  [<c044c497>] do_futex+0x73/0x9e3
May  5 11:28:14 localhost kernel:  [<c042acc2>] finish_task_switch
+0x1f/0xc2
May  5 11:28:14 localhost kernel:  [<c041c7b3>] apic_wait_icr_idle
+0xe/0x15
May  5 11:28:14 localhost kernel:  [<c0426623>] enqueue_task_fair
+0x135/0x14a
May  5 11:28:14 localhost kernel:  [<c044cf05>] sys_futex+0xfe/0x111
May  5 11:28:14 localhost kernel:  [<c0428c27>] try_to_wake_up
+0x1b3/0x1bd
May  5 11:28:14 localhost kernel:  [<c042ea60>] mm_release+0x81/0x87
May  5 11:28:14 localhost kernel:  [<c0432725>] exit_mm+0x12/0xfc
May  5 11:28:14 localhost kernel:  [<c0433bfe>] do_exit+0x211/0x700
May  5 11:28:14 localhost kernel:  [<c044d4c1>] __rt_mutex_adjust_prio
+0x8/0x19
May  5 11:28:14 localhost kernel:  [<c043415a>] sys_exit_group+0x0/0xd
May  5 11:28:14 localhost kernel:  [<c04051c6>] syscall_call+0x7/0xb
May  5 11:28:14 localhost kernel:  =======================

----

May  5 11:28:14 localhost kernel: BUG: sleeping function called from
invalid context bonobo-activati(3214) at arch/x86/mm/highmem_32.c:8
May  5 11:28:14 localhost kernel: in_atomic():0 [00000000],
irqs_disabled():1
May  5 11:28:14 localhost kernel: Pid: 3214, comm: bonobo-activati Not
tainted 2.6.24.6-1.rt4.3.fc8.ccrmart #1
May  5 11:28:14 localhost kernel:  [<c0424351>] kmap+0x44/0x54
May  5 11:28:14 localhost kernel:  [<c0423be3>] gup_pte_range+0x4f/0xe0
May  5 11:28:14 localhost kernel:  [<c0423de8>] fast_gup+0xe2/0x18e
May  5 11:28:14 localhost kernel:  [<c044b277>] get_futex_key+0x6e/0xa1
May  5 11:28:14 localhost kernel:  [<c044b904>] futex_wake+0x3b/0xc2
May  5 11:28:14 localhost kernel:  [<c044c497>] do_futex+0x73/0x9e3
May  5 11:28:14 localhost kernel:  [<c0444c71>] hrtimer_wakeup+0x0/0x18
May  5 11:28:14 localhost kernel:  [<c0635a31>] __rt_spin_lock+0x21/0x5e
May  5 11:28:14 localhost kernel:  [<c044b981>] futex_wake+0xb8/0xc2
May  5 11:28:14 localhost kernel:  [<c044c497>] do_futex+0x73/0x9e3
May  5 11:28:14 localhost kernel:  [<c04422bd>] autoremove_wake_function
+0x0/0x35
May  5 11:28:14 localhost kernel:  [<c044cf05>] sys_futex+0xfe/0x111
May  5 11:28:14 localhost kernel:  [<c0468ab8>] __delayacct_add_tsk
+0x204/0x210
May  5 11:28:14 localhost kernel:  [<c042ea60>] mm_release+0x81/0x87
May  5 11:28:14 localhost kernel:  [<c0432725>] exit_mm+0x12/0xfc
May  5 11:28:14 localhost kernel:  [<c0433bfe>] do_exit+0x211/0x700
May  5 11:28:14 localhost kernel:  [<c0407d7e>] do_syscall_trace
+0x13c/0x182
May  5 11:28:14 localhost kernel:  [<c0434174>] complete_and_exit
+0x0/0x13
May  5 11:28:14 localhost kernel:  [<c04051c6>] syscall_call+0x7/0xb
May  5 11:28:14 localhost kernel:  =======================

----

May  5 11:39:19 localhost kernel: BUG: sleeping function called from
invalid context privoxy(3879) at arch/x86/mm/highmem_32.c:8
May  5 11:39:19 localhost kernel: in_atomic():0 [00000000],
irqs_disabled():1
May  5 11:39:19 localhost kernel: Pid: 3879, comm: privoxy Not tainted
2.6.24.6-1.rt4.3.fc8.ccrmart #1
May  5 11:39:19 localhost kernel:  [<c0424351>] kmap+0x44/0x54
May  5 11:39:19 localhost kernel:  [<c0423be3>] gup_pte_range+0x4f/0xe0
May  5 11:39:19 localhost kernel:  [<c0635a31>] __rt_spin_lock+0x21/0x5e
May  5 11:39:19 localhost kernel:  [<c0423de8>] fast_gup+0xe2/0x18e
May  5 11:39:19 localhost kernel:  [<c05d1993>] dev_queue_xmit
+0x274/0x299
May  5 11:39:19 localhost kernel:  [<c044b277>] get_futex_key+0x6e/0xa1
May  5 11:39:19 localhost kernel:  [<c05eea9c>] dst_output+0x0/0x7
May  5 11:39:19 localhost kernel:  [<c044b904>] futex_wake+0x3b/0xc2
May  5 11:39:19 localhost kernel:  [<c044c497>] do_futex+0x73/0x9e3
May  5 11:39:19 localhost kernel:  [<c05ff904>] tcp_transmit_skb
+0x6f2/0x725
May  5 11:39:19 localhost kernel:  [<c0635a31>] __rt_spin_lock+0x21/0x5e
May  5 11:39:19 localhost kernel:  [<c0438ecd>] lock_timer_base
+0x19/0x37
May  5 11:39:19 localhost kernel:  [<c04395da>] __mod_timer+0x9b/0xa4
May  5 11:39:19 localhost kernel:  [<c05c7171>] sk_reset_timer+0xc/0x16
May  5 11:39:19 localhost kernel:  [<c06013a3>]
__tcp_push_pending_frames+0x735/0x7d8
May  5 11:39:19 localhost kernel:  [<c0635a31>] __rt_spin_lock+0x21/0x5e
May  5 11:39:19 localhost kernel:  [<c0487481>] __kmalloc+0xab/0xdd
May  5 11:39:19 localhost kernel:  [<c044cf05>] sys_futex+0xfe/0x111
May  5 11:39:19 localhost kernel:  [<c0468ab8>] __delayacct_add_tsk
+0x204/0x210
May  5 11:39:19 localhost kernel:  [<c042ea60>] mm_release+0x81/0x87
May  5 11:39:19 localhost kernel:  [<c0432725>] exit_mm+0x12/0xfc
May  5 11:39:19 localhost kernel:  [<c0433bfe>] do_exit+0x211/0x700
May  5 11:39:19 localhost kernel:  [<c0407d7e>] do_syscall_trace
+0x13c/0x182
May  5 11:39:19 localhost kernel:  [<c0434174>] complete_and_exit
+0x0/0x13
May  5 11:39:19 localhost kernel:  [<c04051c6>] syscall_call+0x7/0xb
May  5 11:39:19 localhost kernel:  =======================

----

May  5 11:50:13 localhost kernel: BUG: sleeping function called from
invalid context firefox-bin(4470) at arch/x86/mm/highmem_32.c:8
May  5 11:50:13 localhost kernel: in_atomic():0 [00000000],
irqs_disabled():1
May  5 11:50:13 localhost kernel: Pid: 4470, comm: firefox-bin Not
tainted 2.6.24.6-1.rt4.3.fc8.ccrmart #1
May  5 11:50:13 localhost kernel:  [<c0424351>] kmap+0x44/0x54
May  5 11:50:13 localhost kernel:  [<c0423be3>] gup_pte_range+0x4f/0xe0
May  5 11:50:13 localhost kernel:  [<c0423de8>] fast_gup+0xe2/0x18e
May  5 11:50:13 localhost kernel:  [<c044b277>] get_futex_key+0x6e/0xa1
May  5 11:50:13 localhost kernel:  [<c044b904>] futex_wake+0x3b/0xc2
May  5 11:50:13 localhost kernel:  [<c044c497>] do_futex+0x73/0x9e3
May  5 11:50:13 localhost kernel:  [<c0444c71>] hrtimer_wakeup+0x0/0x18
May  5 11:50:13 localhost kernel:  [<c0635a31>] __rt_spin_lock+0x21/0x5e
May  5 11:50:13 localhost kernel:  [<c044b981>] futex_wake+0xb8/0xc2
May  5 11:50:13 localhost kernel:  [<c044c497>] do_futex+0x73/0x9e3
May  5 11:50:13 localhost kernel:  [<c048aa01>] do_sync_write+0xc7/0x10a
May  5 11:50:13 localhost kernel:  [<c044cf05>] sys_futex+0xfe/0x111
May  5 11:50:13 localhost kernel:  [<c0468ab8>] __delayacct_add_tsk
+0x204/0x210
May  5 11:50:13 localhost kernel:  [<c042ea60>] mm_release+0x81/0x87
May  5 11:50:13 localhost kernel:  [<c0432725>] exit_mm+0x12/0xfc
May  5 11:50:13 localhost kernel:  [<c0433bfe>] do_exit+0x211/0x700
May  5 11:50:13 localhost kernel:  [<c0407d7e>] do_syscall_trace
+0x13c/0x182
May  5 11:50:13 localhost kernel:  [<c0434174>] complete_and_exit
+0x0/0x13
May  5 11:50:13 localhost kernel:  [<c04051c6>] syscall_call+0x7/0xb
May  5 11:50:13 localhost kernel:  =======================

----

May  5 11:54:04 localhost kernel: BUG: sleeping function called from
invalid context evolution-data-(4741) at arch/x86/mm/highmem_32.c:8
May  5 11:54:04 localhost kernel: in_atomic():0 [00000000],
irqs_disabled():1
May  5 11:54:04 localhost kernel: Pid: 4741, comm: evolution-data- Not
tainted 2.6.24.6-1.rt4.3.fc8.ccrmart #1
May  5 11:54:04 localhost kernel:  [<c0424351>] kmap+0x44/0x54
May  5 11:54:04 localhost kernel:  [<c0423be3>] gup_pte_range+0x4f/0xe0
May  5 11:54:04 localhost kernel:  [<c0423de8>] fast_gup+0xe2/0x18e
May  5 11:54:04 localhost kernel:  [<c0635b74>] rt_read_unlock+0x38/0x40
May  5 11:54:04 localhost kernel:  [<c044b277>] get_futex_key+0x6e/0xa1
May  5 11:54:04 localhost kernel:  [<c044b904>] futex_wake+0x3b/0xc2
May  5 11:54:04 localhost kernel:  [<c044c497>] do_futex+0x73/0x9e3
May  5 11:54:04 localhost kernel:  [<c048a8fd>] do_sync_readv_writev
+0xc1/0xfe
May  5 11:54:04 localhost kernel:  [<c040a99e>] sched_clock+0x8/0x18
May  5 11:54:04 localhost kernel:  [<c0425a67>] __update_rq_clock
+0x19/0x156
May  5 11:54:04 localhost kernel:  [<c044cf05>] sys_futex+0xfe/0x111
May  5 11:54:04 localhost kernel:  [<c0468ab8>] __delayacct_add_tsk
+0x204/0x210
May  5 11:54:04 localhost kernel:  [<c0425a67>] __update_rq_clock
+0x19/0x156
May  5 11:54:04 localhost kernel:  [<c042ea60>] mm_release+0x81/0x87
May  5 11:54:04 localhost kernel:  [<c0432725>] exit_mm+0x12/0xfc
May  5 11:54:04 localhost kernel:  [<c0433bfe>] do_exit+0x211/0x700
May  5 11:54:04 localhost kernel:  [<c0407d7e>] do_syscall_trace
+0x13c/0x182
May  5 11:54:04 localhost kernel:  [<c0434174>] complete_and_exit
+0x0/0x13
May  5 11:54:04 localhost kernel:  [<c04051c6>] syscall_call+0x7/0xb
May  5 11:54:04 localhost kernel:  =======================


