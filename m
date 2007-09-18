Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbXIRJSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbXIRJSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbXIRJSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:18:32 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:19251 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbXIRJSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:18:31 -0400
Date: Tue, 18 Sep 2007 13:17:28 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: nadia.derbey@bull.net, linux-kernel@vger.kernel.org
Subject: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070918091728.GA6766@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting tons of this, and X fails to start

CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_DEBUG_PREEMPT=y

BUG: sleeping function called from invalid context at kernel/rwsem.c:47
in_atomic():1, irqs_disabled():0
no locks held by X/5879.
 [<c012bcb1>] down_write+0x15/0x50
 [<c01b53af>] do_shmat+0x235/0x3a0
 [<c0106be2>] sys_ipc+0x146/0x263
 [<c0102892>] sysenter_past_esp+0xa7/0xb5
 [<c0102856>] sysenter_past_esp+0x6b/0xb5
 =======================
BUG: scheduling while atomic: X/5879/0x00000005
no locks held by X/5879.
irq event stamp: 401318
hardirqs last  enabled at (401317): [<c02d96c8>] __mutex_unlock_slowpath+0xb4/0x170
hardirqs last disabled at (401318): [<c010286f>] sysenter_past_esp+0x84/0xb5
softirqs last  enabled at (397628): [<c01051ce>] do_softirq+0xa6/0xf9
softirqs last disabled at (397585): [<c01051ce>] do_softirq+0xa6/0xf9
 [<c02d86fe>] __sched_text_start+0x2de/0x384
 [<c0106bf7>] sys_ipc+0x15b/0x263
 [<c01029ae>] work_resched+0x5/0x31
 =======================
note: X[5879] exited with preempt_count 7
BUG: scheduling while atomic: X/5879/0x10000008
no locks held by X/5879.
 [<c02d86fe>] __sched_text_start+0x2de/0x384
 [<c0114ad5>] __cond_resched+0x21/0x3b
 [<c02d8c21>] cond_resched+0x2a/0x31
 [<c014c877>] unmap_vmas+0x518/0x560
 [<c014f5d6>] exit_mmap+0x6f/0x104
 [<c0115d41>] mmput+0x3b/0xbe
 [<c011ae16>] do_exit+0x142/0x870
 [<c01114cb>] do_page_fault+0x0/0x675
 [<c011b569>] do_group_exit+0x25/0x6b
 [<c01114cb>] do_page_fault+0x0/0x675
 [<c01221c5>] get_signal_to_deliver+0x286/0x439
 [<c0120e00>] force_sig_info+0x80/0x8a
 [<c01114cb>] do_page_fault+0x0/0x675
 [<c0101e0e>] do_notify_resume+0x79/0x6bc
 [<c015025a>] vma_link+0x97/0xd5
 [<c015025a>] vma_link+0x97/0xd5
 [<c0111754>] do_page_fault+0x289/0x675
 [<c0102892>] sysenter_past_esp+0xa7/0xb5
 [<c01114cb>] do_page_fault+0x0/0x675
 [<c01029ed>] work_notifysig+0x13/0x1a

	...

