Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbYJMRyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbYJMRyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 13:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYJMRym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 13:54:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:54142 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbYJMRyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 13:54:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vRHQ7NXQheu5etrcg8GSiPd7ZX7+dvAMR7iCpgPejc7rX4Ubcqnc1hOjdURd8meXNv
         h9IKb9ywr7UFIeFSBSJFvcVfI9OvjjLIZrtO3iLTOQdDwhRRfSaxu6XaLI3SoFBdOuln
         RnpFIVWYs1q4Y71ety+cO8IrUJiokT83EZcxw=
Date: Mon, 13 Oct 2008 21:57:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: lockdep vs rmmod loop
Message-ID: <20081013175732.GA16390@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This exists for quite some time, IIRC.

	# rmmod loop

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 26915, comm: rmmod Not tainted 2.6.27-4480f15b3306f43bbb0310d461142b4e897ca45b #2
Call Trace:
 [<ffffffff80253fcc>] ? static_obj+0x8c/0xa0
 [<ffffffff80258a3d>] __lock_acquire+0x55d/0x9a0
 [<ffffffff80258ed8>] lock_acquire+0x58/0x80
 [<ffffffff80244755>] ? __cancel_work_timer+0x55/0x210
 [<ffffffff80244789>] __cancel_work_timer+0x89/0x210
 [<ffffffff80244755>] ? __cancel_work_timer+0x55/0x210
 [<ffffffff80256dad>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80256d19>] ? trace_hardirqs_on_caller+0xc9/0x150
 [<ffffffff80256dad>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80422482>] ? _spin_unlock_irqrestore+0x42/0x80
 [<ffffffff8023ce04>] ? try_to_del_timer_sync+0x44/0x90
 [<ffffffff8024492b>] cancel_work_sync+0xb/0x10
 [<ffffffff802fadb9>] kblockd_flush_work+0x9/0x10
 [<ffffffff802fc6a7>] blk_sync_queue+0x27/0x30
 [<ffffffff802fc6d1>] blk_cleanup_queue+0x21/0x60
 [<ffffffffa00820c8>] loop_free+0x18/0x40 [loop]
 [<ffffffffa008429b>] loop_exit+0x7b/0xc1 [loop]
 [<ffffffff8025fd67>] sys_delete_module+0x147/0x220
 [<ffffffff80256d19>] ? trace_hardirqs_on_caller+0xc9/0x150
 [<ffffffff804219a7>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020b64b>] system_call_fastpath+0x16/0x1b
