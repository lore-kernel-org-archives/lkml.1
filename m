Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbZHHMAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbZHHMAl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 08:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZHHMAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 08:00:40 -0400
Received: from thunk.org ([69.25.196.29]:59407 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZHHMAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 08:00:39 -0400
Date: Sat, 8 Aug 2009 08:00:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Subject: Re: [RT] Lockdep warning on boot with 2.6.31-rc5-rt1.1
Message-ID: <20090808120026.GA13183@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Clark Williams <williams@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	RT <linux-rt-users@vger.kernel.org>
References: <20090807094608.4b0efea1@torg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807094608.4b0efea1@torg>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 09:46:08AM -0500, Clark Williams wrote:
> Peter,
> 
> I'm getting this warning from lockdep when booting on my T60. 
> 
> The two addresses reported (0xffffffff812664a2 and 0xffffffff812664ae)
> actually bracket one call to mutex_lock() in driver_attach() so I'm not
> sure what the complaint is.

I'm getting a different lockdep warning when booting on my T400 using
2.6.31-rc5; not sure if it's related or not....

In any case, it's screwing up the ability for lockdep to find any
other problems.

[    0.297775] INFO: trying to register non-static key.
[    0.297775] the code is fine but needs lockdep annotation.
[    0.297775] turning off the locking correctness validator.
[    0.297775] Pid: 1, comm: swapper Not tainted 2.6.31-rc5-00256-gf124845 #4
[    0.297775] Call Trace:
[    0.297775]  [<c0511a2f>] ? printk+0x14/0x1d
[    0.297775]  [<c016de1f>] register_lock_class+0x5a/0x2a1
[    0.297775]  [<c016e932>] ? mark_lock+0x1e/0x1e4
[    0.297775]  [<c016f673>] __lock_acquire+0x9c/0xb1e
[    0.297775]  [<c01be910>] ? mod_zone_page_state+0x9f/0xaf
[    0.297775]  [<c016ed98>] ? trace_hardirqs_on_caller+0x103/0x124
[    0.297775]  [<c016e932>] ? mark_lock+0x1e/0x1e4
[    0.297775]  [<c016eb3b>] ? mark_held_locks+0x43/0x5b
[    0.297775]  [<c01d490f>] ? kmem_cache_alloc+0xaf/0x127
[    0.297775]  [<c016ed98>] ? trace_hardirqs_on_caller+0x103/0x124
[    0.297775]  [<c0170189>] lock_acquire+0x94/0xb7
[    0.297775]  [<c045d6bd>] ? alloc_netdev_mq+0x105/0x1cc
[    0.297775]  [<c0513f8d>] _spin_lock_bh+0x28/0x58
[    0.297775]  [<c045d6bd>] ? alloc_netdev_mq+0x105/0x1cc
[    0.297775]  [<c045d6bd>] alloc_netdev_mq+0x105/0x1cc
[    0.297775]  [<c03f7bbf>] ? loopback_setup+0x0/0x79
[    0.297775]  [<c03f7c6f>] loopback_net_init+0x25/0x68
[    0.297782]  [<c0457317>] register_pernet_operations+0x2f/0xa1
[    0.297832]  [<c0512fcd>] ? mutex_lock_nested+0x33/0x3b
[    0.297891]  [<c0457435>] register_pernet_device+0x24/0x4c
[    0.297951]  [<c0796a09>] net_dev_init+0x101/0x150
[    0.298010]  [<c0796908>] ? net_dev_init+0x0/0x150
[    0.298069]  [<c010115c>] do_one_initcall+0x6a/0x177
[    0.298127]  [<c016e932>] ? mark_lock+0x1e/0x1e4
[    0.298185]  [<c016e932>] ? mark_lock+0x1e/0x1e4
[    0.298244]  [<c01b371a>] ? get_page_from_freelist+0x28f/0x3be
[    0.298304]  [<c016ed98>] ? trace_hardirqs_on_caller+0x103/0x124
[    0.298364]  [<c016edc4>] ? trace_hardirqs_on+0xb/0xd
[    0.298423]  [<c016e932>] ? mark_lock+0x1e/0x1e4
[    0.298482]  [<c016e932>] ? mark_lock+0x1e/0x1e4
[    0.298540]  [<c016edc4>] ? trace_hardirqs_on+0xb/0xd
[    0.298600]  [<c03104ad>] ? ida_get_new_above+0x157/0x171
[    0.298660]  [<c0213468>] ? proc_register+0x14b/0x15c
[    0.298719]  [<c011e5f6>] ? sched_clock+0x8/0xb
[    0.298777]  [<c016d9b1>] ? lock_release_holdtime+0x30/0x131
[    0.298837]  [<c0213468>] ? proc_register+0x14b/0x15c
[    0.298896]  [<c0513dfb>] ? _spin_unlock+0x22/0x25
[    0.298954]  [<c0213468>] ? proc_register+0x14b/0x15c
[    0.299013]  [<c021359b>] ? create_proc_entry+0x80/0x96
[    0.299073]  [<c0191064>] ? register_irq_proc+0x91/0xad
[    0.299132]  [<c01910d8>] ? init_irq_proc+0x58/0x65
[    0.299191]  [<c0768301>] kernel_init+0x131/0x182
[    0.299249]  [<c07681d0>] ? kernel_init+0x0/0x182

							- Ted
