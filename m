Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbYJNLvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbYJNLvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbYJNLvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:51:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbYJNLvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:51:44 -0400
Subject: Re: lockdep vs rmmod loop
From: Peter Zijlstra <peterz@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20081013175732.GA16390@x200.localdomain>
References: <20081013175732.GA16390@x200.localdomain>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 13:51:38 +0200
Message-Id: <1223985098.9557.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 21:57 +0400, Alexey Dobriyan wrote:
> This exists for quite some time, IIRC.
> 
> 	# rmmod loop

I tried to reproduce with -git from today but failed.

v2.6.27-3976-g7591103

I build a x86_64 kernel with modular loop and lockdep enabled, then I
did: modprobe loop; rmmod loop

Is there anything else to reproducing this?

> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> Pid: 26915, comm: rmmod Not tainted 2.6.27-4480f15b3306f43bbb0310d461142b4e897ca45b #2
> Call Trace:
>  [<ffffffff80253fcc>] ? static_obj+0x8c/0xa0
>  [<ffffffff80258a3d>] __lock_acquire+0x55d/0x9a0
>  [<ffffffff80258ed8>] lock_acquire+0x58/0x80
>  [<ffffffff80244755>] ? __cancel_work_timer+0x55/0x210
>  [<ffffffff80244789>] __cancel_work_timer+0x89/0x210
>  [<ffffffff80244755>] ? __cancel_work_timer+0x55/0x210
>  [<ffffffff80256dad>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff80256d19>] ? trace_hardirqs_on_caller+0xc9/0x150
>  [<ffffffff80256dad>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff80422482>] ? _spin_unlock_irqrestore+0x42/0x80
>  [<ffffffff8023ce04>] ? try_to_del_timer_sync+0x44/0x90
>  [<ffffffff8024492b>] cancel_work_sync+0xb/0x10
>  [<ffffffff802fadb9>] kblockd_flush_work+0x9/0x10
>  [<ffffffff802fc6a7>] blk_sync_queue+0x27/0x30
>  [<ffffffff802fc6d1>] blk_cleanup_queue+0x21/0x60
>  [<ffffffffa00820c8>] loop_free+0x18/0x40 [loop]
>  [<ffffffffa008429b>] loop_exit+0x7b/0xc1 [loop]
>  [<ffffffff8025fd67>] sys_delete_module+0x147/0x220
>  [<ffffffff80256d19>] ? trace_hardirqs_on_caller+0xc9/0x150
>  [<ffffffff804219a7>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8020b64b>] system_call_fastpath+0x16/0x1b

