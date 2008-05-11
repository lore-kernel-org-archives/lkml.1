Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYEKJar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYEKJar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 05:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYEKJa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 05:30:27 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:60226 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYEKJaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 05:30:25 -0400
Message-ID: <4826BCAC.2080707@free.fr>
Date: Sun, 11 May 2008 11:30:20 +0200
From: Pidoux <f6bvp@free.fr>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, bpidoux@free.fr
Subject: 2.6.25.3 WARNING swapper Not tainted at kernel/lockdep.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I still observe the following warning when booting kernel 2.6.25.3 SMP.

Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4388.98 BogoMIPS 
(lpj=8777969)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Duo CPU     E4500  @ 2.20GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2662 check_flags+0x18d/0x190()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.25.3-patched-ax25 #4

Call Trace:
  [<ffffffff8022fccf>] warn_on_slowpath+0x5f/0x80
  [<ffffffff80213a77>] ? native_sched_clock+0x57/0x80
  [<ffffffff8022acea>] ? hrtick_set+0x3a/0x120
  [<ffffffff80254eb5>] ? __lock_acquire+0x245/0x1070
  [<ffffffff8022ad6d>] ? hrtick_set+0xbd/0x120
  [<ffffffff80213a77>] ? native_sched_clock+0x57/0x80
  [<ffffffff8024b1c0>] ? __atomic_notifier_call_chain+0x0/0xa0
  [<ffffffff8025191d>] check_flags+0x18d/0x190
  [<ffffffff80255d43>] lock_acquire+0x63/0xd0
  [<ffffffff8024b211>] __atomic_notifier_call_chain+0x51/0xa0
  [<ffffffff8020b210>] ? mwait_idle+0x0/0x50
  [<ffffffff8020b0a0>] ? default_idle+0x0/0x80
  [<ffffffff8024b271>] atomic_notifier_call_chain+0x11/0x20
  [<ffffffff8020a849>] __exit_idle+0x29/0x30
  [<ffffffff8020b178>] cpu_idle+0x58/0xa0
  [<ffffffff80450d0e>] start_secondary+0x2fe/0x430

---[ end trace ca143223eefdc828 ]---
possible reason: unannotated irqs-on.
irq event stamp: 12
hardirqs last  enabled at (11): [<ffffffff80456a75>] 
_spin_unlock_irqrestore+0x55/0x60
hardirqs last disabled at (12): [<ffffffff8020b16c>] cpu_idle+0x4c/0xa0
softirqs last  enabled at (0): [<ffffffff8022db52>] 
copy_process+0x2d2/0x16a0
softirqs last disabled at (0): [<0000000000000000>] 0x0
khelper used greatest stack depth: 5920 bytes left
net_namespace: 1144 bytes



Bernard Pidoux
