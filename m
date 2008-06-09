Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYFIIJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYFIIJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYFIIJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:09:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbYFIIJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:09:34 -0400
Date: Mon, 9 Jun 2008 01:09:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: lockdep internal warning in linux-next
Message-Id: <20080609010917.c00d5225.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I boot the 2-way using
http://userweb.kernel.org/~akpm/config-vmm.txt

I see:


Write protecting the kernel text: 2872k
Write protecting the kernel read-only data: 1012k
hostname used greatest stack depth: 6808 bytes left
mount used greatest stack depth: 6048 bytes left
hotplug used greatest stack depth: 5568 bytes left
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2680 check_flags+0x162/0x180()
Modules linked in:
Pid: 5, comm: watchdog/0 Not tainted 2.6.26-rc5 #3
 [<c0123484>] warn_on_slowpath+0x54/0x70
 [<c0141e3b>] ? trace_hardirqs_on+0xb/0x10
 [<c0141da4>] ? trace_hardirqs_on_caller+0xd4/0x160
 [<c0141e3b>] ? trace_hardirqs_on+0xb/0x10
 [<c03cc062>] ? _spin_unlock_irq+0x22/0x30
 [<c013b5bc>] ? sched_clock_cpu+0xbc/0x140
 [<c013f992>] check_flags+0x162/0x180
 [<c0143329>] lock_acquire+0x39/0xa0
 [<c03cbeac>] _read_lock+0x2c/0x40
 [<c0156ec1>] ? watchdog+0xb1/0x1d0
 [<c0156ec1>] watchdog+0xb1/0x1d0
 [<c011a0f6>] ? complete+0x46/0x60
 [<c0156e10>] ? watchdog+0x0/0x1d0
 [<c0136632>] kthread+0x42/0x70
 [<c01365f0>] ? kthread+0x0/0x70
 [<c0103ba3>] kernel_thread_helper+0x7/0x14
 =======================
---[ end trace 8151399cdd960ac9 ]---
possible reason: unannotated irqs-on.
irq event stamp: 14
hardirqs last  enabled at (13): [<c0141e3b>] trace_hardirqs_on+0xb/0x10
hardirqs last disabled at (14): [<c01403eb>] trace_hardirqs_off+0xb/0x10
softirqs last  enabled at (0): [<c0121a8c>] copy_process+0x27c/0x10b0
softirqs last disabled at (0): [<00000000>] 0x0
EXT3 FS on hdc2, internal journal
Adding 1020116k swap on /dev/hdc3.  Priority:-1 extents:1 across:1020116k

(but at least it all boots and runs - small blessings)
