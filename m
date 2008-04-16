Return-Path: <linux-kernel-owner+w=401wt.eu-S1763247AbYDPUpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763247AbYDPUpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYDPUpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:45:04 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:57158 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYDPUpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:45:01 -0400
Date: Wed, 16 Apr 2008 22:45:00 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-kernel@vger.kernel.org
Subject: Re: APM lockups since 2.6.25
In-Reply-To: <Pine.LNX.4.64.0804162239560.25729@artax.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.64.0804162243550.25729@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz>
 <200803201131.25828.rjw@sisk.pl> <Pine.LNX.4.64.0803210059440.2540@artax.karlin.mff.cuni.cz>
 <200803210127.56437.rjw@sisk.pl> <Pine.LNX.4.64.0804162239560.25729@artax.karlin.mff.cuni.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So it didn't help, I just got this (2.6.25-rc8):
> 
> (I have turned lockdep on few days ago, and it seems to try to release a 
> lock that's not held ... and then reacquire that lock again and deadlock)

BTW. the first one message happened immediatelly after APM resume, the 
second message 2 minutes later.

APMD didn't set time after resume, it's completely locked up.

Mikulas

> =====================================
> [ BUG: bad unlock balance detected! ]
> -------------------------------------
> kapmd/1643 is trying to release lock (pm_sleep_rwsem) at:
> [<c01e3a75>] device_resume+0x129/0x12e
> but there are no more locks to release!
> 
> other info that might help us debug this:
> no locks held by kapmd/1643.
> 
> stack backtrace:
> Pid: 1643, comm: kapmd Not tainted 2.6.25-rc8 #5
>  [<c012f877>] print_unlock_inbalance_bug+0xd7/0xe1
>  [<c0241465>] ? _spin_unlock_irqrestore+0x36/0x58
>  [<c012e6d5>] ? trace_hardirqs_on+0xdf/0x100
>  [<c012e560>] ? mark_held_locks+0x4e/0x66
>  [<c024002c>] ? mutex_lock_nested+0x1f3/0x217
>  [<c012e6d5>] ? trace_hardirqs_on+0xdf/0x100
>  [<c01e3a75>] ? device_resume+0x129/0x12e
>  [<c012fa36>] lock_release+0x90/0x132
>  [<c0127f6c>] up_write+0x16/0x2a
>  [<c01e3a75>] device_resume+0x129/0x12e
>  [<c884e251>] apm+0x457/0x523 [apm]
>  [<c01110a1>] ? default_wake_function+0x0/0xd
>  [<c884ddfa>] ? apm+0x0/0x523 [apm]
>  [<c0124cd5>] kthread+0x39/0x5e
>  [<c0124c9c>] ? kthread+0x0/0x5e
>  [<c0102fdf>] kernel_thread_helper+0x7/0x10
>  =======================
> INFO: task apmd:1813 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> apmd          D c6cb0260  2320  1813      1
>        c7b06ea8 00000046 c6cb0000 c6cb0260 c003f081 0000a086 c6d13980 
> c6cb0260
>        c02e724c c02e724c ffffffff c79f1b60 c02e7248 c7b06ed0 c0240e71 
> c7b06ed8
>        c02e724c c02e7268 c6cb0000 c7b06eec c02e7248 c79f1b60 00000000 
> c7b06eec
> Call Trace:
>  [<c0240e71>] rwsem_down_failed_common+0x122/0x140
>  [<c0240eaa>] rwsem_down_write_failed+0x1b/0x23
>  [<c0240f2a>] call_rwsem_down_write_failed+0x6/0x8
>  [<c0240502>] ? down_write+0x3b/0x43
>  [<c01e3a9f>] ? device_suspend+0x25/0x1ac
>  [<c01e3a9f>] device_suspend+0x25/0x1ac
>  [<c884d624>] suspend+0x66/0x12e [apm]
>  [<c884d95a>] do_ioctl+0xd3/0x14b [apm]
>  [<c0161588>] vfs_ioctl+0x50/0x69
>  [<c01617e6>] do_vfs_ioctl+0x245/0x258
>  [<c0161825>] sys_ioctl+0x2c/0x47
>  [<c0102cd2>] syscall_call+0x7/0xb
>  =======================
> INFO: lockdep is turned off.
> 
> Mikulas
> 
