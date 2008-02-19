Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYBSAIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYBSAIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYBSAII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:08:08 -0500
Received: from simmts8-srv.bellnexxia.net ([206.47.199.166]:58925 "EHLO
	simmts8-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbYBSAIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:08:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CACatuUecIvdG/2dsb2JhbAAIih2CFaBw
Message-ID: <47BA1DE3.7030407@gmail.com>
Date: Mon, 18 Feb 2008 20:08:03 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080214)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc2-mm1
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
In-Reply-To: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> 
> - git-xfs is dropped due to git conflicts
> 
> - git-x86 is dropped due to too many changes to non-x86 code
> 
> - git-perfmon remains dropped due to rejects
> 
> - git-kgdb remains dropped due to rejects
> 
> - Added the slab/slub tree as git-slub.patch (Christoph Lameter)
> 
> 

I don't think I've seen anyone else report this, but if I'm wrong, I'm
sure someone will point me to the thread.  This is during boot up, and
doesn't seem to have any effect on the running system, that I can tell.

[    0.090840] ------------[ cut here ]------------
[    0.090920] WARNING: at kernel/lockdep.c:2677 check_flags+0x8d/0x12d()
[    0.090986] Pid: 1, comm: swapper Not tainted 2.6.25-rc2-mm1 #49
[    0.090986]  [<c011b92d>] warn_on_slowpath+0x41/0x72
[    0.090986]  [<c0136ff1>] ? __lock_acquire+0xb99/0xbb5
[    0.090986]  [<c0140632>] ? ftrace_record_ip+0x11e/0x17a
[    0.090986]  [<c0102bd0>] ? mcount_call+0x5/0x9
[    0.090986]  [<c01344f0>] ? check_chain_key+0xe/0x16a
[    0.090986]  [<c0140632>] ? ftrace_record_ip+0x11e/0x17a
[    0.090986]  [<c01dd1a8>] ? debug_locks_off+0x8/0x3c
[    0.090986]  [<c0102bd0>] ? mcount_call+0x5/0x9
[    0.090986]  [<c01182c4>] ? sub_preempt_count+0xa/0xb0
[    0.090986]  [<c03453bd>] ? _spin_unlock_irqrestore+0x47/0x5d
[    0.090986]  [<c0140632>] ? ftrace_record_ip+0x11e/0x17a
[    0.090986]  [<c0102bd0>] ? mcount_call+0x5/0x9
[    0.090986]  [<c0134442>] check_flags+0x8d/0x12d
[    0.090986]  [<c0137043>] lock_acquire+0x36/0x82
[    0.090986]  [<c03440c2>] down_write+0x2d/0x48
[    0.090986]  [<c015e91a>] ? kmem_cache_create+0x21/0x1a7
[    0.090986]  [<c015e91a>] kmem_cache_create+0x21/0x1a7
[    0.090986]  [<c0449642>] filelock_init+0x23/0x2c
[    0.090986]  [<c016d908>] ? init_once+0x0/0x11
[    0.090986]  [<c043d697>] kernel_init+0xb6/0x203
[    0.090986]  [<c0102dae>] ? restore_nocheck_notrace+0x0/0xe
[    0.090986]  [<c043d5e1>] ? kernel_init+0x0/0x203
[    0.090986]  [<c043d5e1>] ? kernel_init+0x0/0x203
[    0.090986]  [<c01038d3>] kernel_thread_helper+0x7/0x10
[    0.090986]  =======================
[    0.090986] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.090986] possible reason: unannotated irqs-on.
[    0.090986] irq event stamp: 1404
[    0.090986] hardirqs last  enabled at (1403): [<c01360a0>]
trace_hardirqs_on+0xb/0xd
[    0.090986] hardirqs last disabled at (1404): [<c0134c15>]
trace_hardirqs_off+0xb/0xd
[    0.090986] softirqs last  enabled at (1010): [<c011fc87>]
__do_softirq+0x9e/0xa3
[    0.090986] softirqs last disabled at (1003): [<c010508d>]
do_softirq+0x5d/0xad
