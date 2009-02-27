Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbZB0KBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbZB0KBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZB0KB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:01:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44530 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZB0KB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:01:28 -0500
Subject: Re: i915 X lockup
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: airlied@linux.ie, eric@anholt.net, keithp@keithp.com,
       dri-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <49A7B253.906@gmail.com>
References: <49A7B253.906@gmail.com>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 11:01:07 +0100
Message-Id: <1235728867.24401.82.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 10:28 +0100, Jiri Slaby wrote:

> SysRq : Show Locks Held
> 
> Showing all locks held in the system:
> 3 locks held by events/0/10:
>   #0:  (events){+.+.+.}, at: [<ffffffff8025223d>] worker_thread+0x19d/0x340
>   #1:  (&(&dev_priv->mm.retire_work)->work){+.+...}, at: [<ffffffff8025223d>] worker_thread+0x19d/0x340
>   #2:  (&dev->struct_mutex){+.+.+.}, at: [<ffffffff804057ba>] i915_gem_retire_work_handler+0x3a/0x90

> 1 lock held by X/4007:
>   #0:  (&dev->struct_mutex){+.+.+.}, at: [<ffffffff8040563c>] i915_gem_throttle_ioctl+0x2c/0x60

> =============================================
> 
> INFO: task events/0:10 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> events/0      D 0000000000000000     0    10      2
>   ffff8801cb22fd60 0000000000000046 ffff8801cb22fcc0 ffffffff809d5cb0
>   0000000000010400 ffffffff804057ba ffff8801cb20a6d0 ffff8801cb20a080
>   ffff8801cb20a328 00000000802690a3 00000000ffff0ea1 0000000000000002
> Call Trace:
>   [<ffffffff804057ba>] ? i915_gem_retire_work_handler+0x3a/0x90
>   [<ffffffff8026804d>] ? mark_held_locks+0x6d/0x90
>   [<ffffffff80612fb5>] ? mutex_lock_nested+0x185/0x310
>   [<ffffffff80612f46>] mutex_lock_nested+0x116/0x310
>   [<ffffffff804057ba>] ? i915_gem_retire_work_handler+0x3a/0x90
>   [<ffffffff802690a3>] ? __lock_acquire+0xab3/0x12c0
>   [<ffffffff80405780>] ? i915_gem_retire_work_handler+0x0/0x90
>   [<ffffffff804057ba>] i915_gem_retire_work_handler+0x3a/0x90
>   [<ffffffff80252290>] worker_thread+0x1f0/0x340
>   [<ffffffff8025223d>] ? worker_thread+0x19d/0x340
>   [<ffffffff80614aff>] ? _spin_unlock_irqrestore+0x3f/0x60
>   [<ffffffff80256de0>] ? autoremove_wake_function+0x0/0x40
>   [<ffffffff8026838d>] ? trace_hardirqs_on+0xd/0x10
>   [<ffffffff802520a0>] ? worker_thread+0x0/0x340
>   [<ffffffff80256a2e>] kthread+0x9e/0xb0
>   [<ffffffff8020d51a>] child_rip+0xa/0x20
>   [<ffffffff8020cf3c>] ? restore_args+0x0/0x30
>   [<ffffffff80256990>] ? kthread+0x0/0xb0
>   [<ffffffff8020d510>] ? child_rip+0x0/0x20
> 3 locks held by events/0/10:
>   #0:  (events){+.+.+.}, at: [<ffffffff8025223d>] worker_thread+0x19d/0x340
>   #1:  (&(&dev_priv->mm.retire_work)->work){+.+...}, at: [<ffffffff8025223d>] worker_thread+0x19d/0x340
>   #2:  (&dev->struct_mutex){+.+.+.}, at: [<ffffffff804057ba>] i915_gem_retire_work_handler+0x3a/0x90


Looks like eventd blocking on X, would be good to have sysrq-w output
too, to see what X is up to (assuming it is blocked, and not spinning
like mad with a lock held).

