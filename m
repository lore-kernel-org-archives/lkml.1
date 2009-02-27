Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbZB0J3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbZB0J3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbZB0J27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:28:59 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:54518 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbZB0J25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:28:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=thvK753f9sxd20Ra2V+roGPVTFSVusr7SB8noWfhkC4T4VR+byLDXfKwStK7l8RUva
         ydDMOAr1G6QySXjkYIngdx3YTS1LlST/U4qEbUOTuGNM7e6W+c2TKl6EEmyEXDCrAUkJ
         pq4diMpFL/Ie9Omwrhne62EHGdCOKT/BxIbCs=
Message-ID: <49A7B253.906@gmail.com>
Date: Fri, 27 Feb 2009 10:28:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-2.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: airlied@linux.ie
CC: eric@anholt.net, keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: i915 X lockup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

everytime I run X, it gets stuck. Currently running on mmotm 
2009-02-26-16-58, but I think this is wider problem. I had i915 disabled 
for a long time (until I noticed today).

SysRq : Show Locks Held

Showing all locks held in the system:
3 locks held by events/0/10:
  #0:  (events){+.+.+.}, at: [<ffffffff8025223d>] worker_thread+0x19d/0x340
  #1:  (&(&dev_priv->mm.retire_work)->work){+.+...}, at: 
[<ffffffff8025223d>] worker_thread+0x19d/0x340
  #2:  (&dev->struct_mutex){+.+.+.}, at: [<ffffffff804057ba>] 
i915_gem_retire_work_handler+0x3a/0x90
1 lock held by mingetty/3899:
  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff803cb5de>] 
n_tty_read+0x48e/0x8e0
1 lock held by mingetty/3900:
  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff803cb5de>] 
n_tty_read+0x48e/0x8e0
1 lock held by mingetty/3901:
  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff803cb5de>] 
n_tty_read+0x48e/0x8e0
1 lock held by X/4007:
  #0:  (&dev->struct_mutex){+.+.+.}, at: [<ffffffff8040563c>] 
i915_gem_throttle_ioctl+0x2c/0x60
2 locks held by bash/4105:
  #0:  (sysrq_key_table_lock){......}, at: [<ffffffff803de366>] 
__handle_sysrq+0x26/0x190
  #1:  (tasklist_lock){.+.+..}, at: [<ffffffff80266c1f>] 
debug_show_all_locks+0x3f/0x1c0

=============================================

INFO: task events/0:10 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
events/0      D 0000000000000000     0    10      2
  ffff8801cb22fd60 0000000000000046 ffff8801cb22fcc0 ffffffff809d5cb0
  0000000000010400 ffffffff804057ba ffff8801cb20a6d0 ffff8801cb20a080
  ffff8801cb20a328 00000000802690a3 00000000ffff0ea1 0000000000000002
Call Trace:
  [<ffffffff804057ba>] ? i915_gem_retire_work_handler+0x3a/0x90
  [<ffffffff8026804d>] ? mark_held_locks+0x6d/0x90
  [<ffffffff80612fb5>] ? mutex_lock_nested+0x185/0x310
  [<ffffffff80612f46>] mutex_lock_nested+0x116/0x310
  [<ffffffff804057ba>] ? i915_gem_retire_work_handler+0x3a/0x90
  [<ffffffff802690a3>] ? __lock_acquire+0xab3/0x12c0
  [<ffffffff80405780>] ? i915_gem_retire_work_handler+0x0/0x90
  [<ffffffff804057ba>] i915_gem_retire_work_handler+0x3a/0x90
  [<ffffffff80252290>] worker_thread+0x1f0/0x340
  [<ffffffff8025223d>] ? worker_thread+0x19d/0x340
  [<ffffffff80614aff>] ? _spin_unlock_irqrestore+0x3f/0x60
  [<ffffffff80256de0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff8026838d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff802520a0>] ? worker_thread+0x0/0x340
  [<ffffffff80256a2e>] kthread+0x9e/0xb0
  [<ffffffff8020d51a>] child_rip+0xa/0x20
  [<ffffffff8020cf3c>] ? restore_args+0x0/0x30
  [<ffffffff80256990>] ? kthread+0x0/0xb0
  [<ffffffff8020d510>] ? child_rip+0x0/0x20
3 locks held by events/0/10:
  #0:  (events){+.+.+.}, at: [<ffffffff8025223d>] worker_thread+0x19d/0x340
  #1:  (&(&dev_priv->mm.retire_work)->work){+.+...}, at: 
[<ffffffff8025223d>] worker_thread+0x19d/0x340
  #2:  (&dev->struct_mutex){+.+.+.}, at: [<ffffffff804057ba>] 
i915_gem_retire_work_handler+0x3a/0x90




Adapter is:
00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31 
Express Integrated Graphics Controller [8086:29c2] (rev 02) (prog-if 00 
[VGA controller])
         Subsystem: Intel Corporation 82G33/G31 Express Integrated 
Graphics Controller [8086:29c2]
         Flags: bus master, fast devsel, latency 0, IRQ 26
         Memory at ffa80000 (32-bit, non-prefetchable) [size=512K]
         I/O ports at ec00 [size=8]
         Memory at d0000000 (32-bit, prefetchable) [size=256M]
         Memory at ff900000 (32-bit, non-prefetchable) [size=1M]
         Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Count=1/1 Enable+
         Capabilities: [d0] Power Management version 2
         Kernel driver in use: i915



X server complains:
[mi] EQ overflowing. The server is probably stuck in an infinite loop.
[mi] mieqEnequeue: out-of-order valuator event; dropping.
