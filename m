Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbYD0APk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbYD0APk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 20:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYD0APb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 20:15:31 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:32995 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbYD0APb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 20:15:31 -0400
From: Bernard Pidoux <bpidoux@free.fr>
To: linux-kernel@vger.kernel.org
Subject: Re: spinlock lockup on CPU#0
Date: Sun, 27 Apr 2008 02:15:23 +0200
User-Agent: KMail/1.9.9
References: <200804262333.39383.bpidoux@free.fr>
In-Reply-To: <200804262333.39383.bpidoux@free.fr>
Cc: Bernard Pidoux <bpidoux@free.fr>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bW8EI8hNfPeF5in"
Message-Id: <200804270215.23739.bpidoux@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_bW8EI8hNfPeF5in
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

cpu_idle bug is also present in 2.6.24.4 kernel.

I hope this helps.

Bernard Pidoux

 



--Boundary-00=_bW8EI8hNfPeF5in
Content-Type: text/plain;
  charset="utf-8";
  name="lockdep-2.6.24.4.idle.cpu"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lockdep-2.6.24.4.idle.cpu"


Apr 27 01:13:36 f6bvp-7 kernel: Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Apr 27 01:13:36 f6bvp-7 kernel: ... MAX_LOCKDEP_SUBCLASSES:    8
Apr 27 01:13:36 f6bvp-7 kernel: ... MAX_LOCK_DEPTH:          30
Apr 27 01:13:36 f6bvp-7 kernel: ... MAX_LOCKDEP_KEYS:        2048
Apr 27 01:13:36 f6bvp-7 kernel: ... CLASSHASH_SIZE:           1024
Apr 27 01:13:36 f6bvp-7 kernel: ... MAX_LOCKDEP_ENTRIES:     8192
Apr 27 01:13:36 f6bvp-7 kernel: ... MAX_LOCKDEP_CHAINS:      16384
Apr 27 01:13:36 f6bvp-7 kernel: ... CHAINHASH_SIZE:          8192
Apr 27 01:13:36 f6bvp-7 kernel:  memory used by lock dependency info: 1712 kB
Apr 27 01:13:36 f6bvp-7 kernel:  per task-struct memory footprint: 2160 bytes
Apr 27 01:13:36 f6bvp-7 kernel: Memory: 1018724k/1047424k available (2307k kernel code, 27920k reserved, 1174k data, 616k init)
Apr 27 01:13:36 f6bvp-7 kernel: Calibrating delay using timer specific routine.. 4396.25 BogoMIPS (lpj=8792506)
Apr 27 01:13:36 f6bvp-7 kernel: Mount-cache hash table entries: 256
Apr 27 01:13:36 f6bvp-7 kernel: lockdep: not fixing up alternatives.
Apr 27 01:13:36 f6bvp-7 kernel: lockdep: not fixing up alternatives.
Apr 27 01:13:36 f6bvp-7 kernel: Initializing CPU#1
Apr 27 01:13:36 f6bvp-7 kernel: Calibrating delay using timer specific routine.. 4388.97 BogoMIPS (lpj=8777957)
Apr 27 01:13:36 f6bvp-7 kernel: Intel(R) Core(TM)2 Duo CPU     E4500  @ 2.20GHz stepping 0d
Apr 27 01:13:36 f6bvp-7 kernel: WARNING: at kernel/lockdep.c:2662 check_flags()
Apr 27 01:13:36 f6bvp-7 kernel: Pid: 0, comm: swapper Not tainted 2.6.24.4patched #7
Apr 27 01:13:36 f6bvp-7 kernel: 
Apr 27 01:13:36 f6bvp-7 kernel: Call Trace:
Apr 27 01:13:36 f6bvp-7 kernel:  [<ffffffff8024d650>] __atomic_notifier_call_chain+0x0/0xa0
Apr 27 01:13:36 f6bvp-7 kernel:  [<ffffffff802537b2>] check_flags+0x1c2/0x1d0
Apr 27 01:13:36 f6bvp-7 kernel:  [<ffffffff80257e35>] lock_acquire+0x65/0xd0
Apr 27 01:13:36 f6bvp-7 kernel:  [<ffffffff8024d6a1>] __atomic_notifier_call_chain+0x51/0xa0
Apr 27 01:13:36 f6bvp-7 kernel:  [<ffffffff8020b510>] mwait_idle+0x0/0x60
Apr 27 01:13:36 f6bvp-7 kernel:  [<ffffffff8020b390>] default_idle+0x0/0x60
Apr 27 01:13:36 f6bvp-7 kernel:  [<ffffffff8024d701>] atomic_notifier_call_chain+0x11/0x20
Apr 27 01:13:36 f6bvp-7 kernel:  [<ffffffff8020ac49>] __exit_idle+0x29/0x30
Apr 27 01:13:36 f6bvp-7 kernel:  [<ffffffff8020b475>] cpu_idle+0x85/0xd0
Apr 27 01:13:36 f6bvp-7 kernel:  [<ffffffff8021eea8>] start_secondary+0x2f8/0x430
Apr 27 01:13:36 f6bvp-7 kernel: 
Apr 27 01:13:36 f6bvp-7 kernel: possible reason: unannotated irqs-on.
Apr 27 01:13:36 f6bvp-7 kernel: irq event stamp: 6
Apr 27 01:13:36 f6bvp-7 kernel: hardirqs last  enabled at (5): [<ffffffff8043fd15>] _spin_unlock_irqrestore+0x55/0x60
Apr 27 01:13:36 f6bvp-7 kernel: hardirqs last disabled at (6): [<ffffffff8020b461>] cpu_idle+0x71/0xd0
Apr 27 01:13:36 f6bvp-7 kernel: softirqs last  enabled at (0): [<ffffffff8022e8ae>] copy_process+0x2de/0x15d0
Apr 27 01:13:36 f6bvp-7 kernel: softirqs last disabled at (0): [<0000000000000000>] 0x0

--Boundary-00=_bW8EI8hNfPeF5in--
