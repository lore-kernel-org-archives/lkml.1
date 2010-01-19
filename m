Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121Ab0ASM7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0ASM7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590Ab0ASM7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:59:32 -0500
Received: from host36.ns3.it ([80.79.54.36]:59235 "EHLO opinioni.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab0ASM7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:59:31 -0500
Message-ID: <4B55ACAF.3060503@opinioni.net>
Date: Tue, 19 Jan 2010 13:59:27 +0100
From: Andrea Suisani <sickpig@opinioni.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Marcus Better <marcus@better.se>
CC: linux-kernel@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: NTFS: inconsistent lock state
References: <hj1j3v$apf$1@ger.gmane.org>
In-Reply-To: <hj1j3v$apf$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc:ed Trond Myklebust]

Marcus Better wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> I got this a couple of times with 2.6.31.6 and 2.6.32.3, with a read-only NTFS partition.
> 
> Jan 17 18:08:57 better kernel: =================================
> Jan 17 18:08:57 better kernel: [ INFO: inconsistent lock state ]
> Jan 17 18:08:57 better kernel: 2.6.32.3-melech #4
> Jan 17 18:08:57 better kernel: ---------------------------------
> Jan 17 18:08:57 better kernel: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> Jan 17 18:08:57 better kernel: kswapd0/294 [HC0[0]:SC0[0]:HE1:SE1] takes:
> Jan 17 18:08:57 better kernel: (&rl->lock){++++?.}, at: [<ffffffffa0490939>] __ntfs_clear_inode+0x19/0x150 [ntfs]
> Jan 17 18:08:57 better kernel: {RECLAIM_FS-ON-W} state was registered at:
> Jan 17 18:08:57 better kernel:  [<ffffffff810812fc>] mark_held_locks+0x6c/0x90
> Jan 17 18:08:57 better kernel:  [<ffffffff810813e5>] lockdep_trace_alloc+0xc5/0xd0
> Jan 17 18:08:57 better kernel:  [<ffffffff810d9245>] __alloc_pages_nodemask+0x75/0x740
> Jan 17 18:08:57 better kernel:  [<ffffffff810d2db6>] read_cache_page_async+0x56/0x190
> Jan 17 18:08:57 better kernel:  [<ffffffff810d2efe>] read_cache_page+0xe/0x70
> Jan 17 18:08:57 better kernel:  [<ffffffffa049424c>] map_mft_record+0x13c/0x220 [ntfs]
> Jan 17 18:08:57 better kernel:  [<ffffffffa0496dc1>] map_extent_mft_record+0xc1/0x2f0 [ntfs]
> Jan 17 18:08:57 better kernel:  [<ffffffffa0485844>] ntfs_attr_lookup+0x5e4/0x6a0 [ntfs]
> Jan 17 18:08:57 better kernel:  [<ffffffffa048752e>] ntfs_map_runlist_nolock+0x2fe/0x480 [ntfs]
> Jan 17 18:08:57 better kernel:  [<ffffffffa0487a32>] ntfs_map_runlist+0x52/0x80 [ntfs]
> Jan 17 18:08:57 better kernel:  [<ffffffffa0482ca2>] ntfs_readpage+0x882/0x910 [ntfs]
> Jan 17 18:08:57 better kernel:  [<ffffffff810d2de9>] read_cache_page_async+0x89/0x190
> Jan 17 18:08:57 better kernel:  [<ffffffff810d2efe>] read_cache_page+0xe/0x70
> Jan 17 18:08:57 better kernel:  [<ffffffffa048a858>] ntfs_lookup_inode_by_name+0x568/0xdd0 [ntfs]
> Jan 17 18:08:57 better kernel:  [<ffffffffa0498a48>] ntfs_lookup+0x68/0x510 [ntfs]
> Jan 17 18:08:57 better kernel:  [<ffffffff81114d6e>] do_lookup+0x1fe/0x250
> Jan 17 18:08:57 better kernel:  [<ffffffff8111759f>] __link_path_walk+0x73f/0x1040
> Jan 17 18:08:57 better kernel:  [<ffffffff8111812e>] path_walk+0x6e/0xe0
> Jan 17 18:08:57 better kernel:  [<ffffffff811181fb>] do_path_lookup+0x5b/0xa0
> Jan 17 18:08:57 better kernel:  [<ffffffff81118e8b>] user_path_at+0x7b/0xb0
> Jan 17 18:08:57 better kernel:  [<ffffffff8110f42c>] vfs_fstatat+0x3c/0x80
> Jan 17 18:08:57 better kernel:  [<ffffffff8110f4d9>] vfs_lstat+0x19/0x20
> Jan 17 18:08:57 better kernel:  [<ffffffff8110f4ff>] sys_newlstat+0x1f/0x50
> Jan 17 18:08:57 better kernel:  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
> Jan 17 18:08:57 better kernel: irq event stamp: 186821
> Jan 17 18:08:57 better kernel: hardirqs last  enabled at (186821): [<ffffffff810d8505>] free_hot_cold_page+0x295/0x310
> Jan 17 18:08:57 better kernel: hardirqs last disabled at (186820): [<ffffffff810d837d>] free_hot_cold_page+0x10d/0x310
> Jan 17 18:08:57 better kernel: softirqs last  enabled at (186222): [<ffffffff8105681c>] __do_softirq+0x20c/0x280
> Jan 17 18:08:57 better kernel: softirqs last disabled at (186207): [<ffffffff8100d15c>] call_softirq+0x1c/0x30
> Jan 17 18:08:57 better kernel:
> Jan 17 18:08:57 better kernel: other info that might help us debug this:
> Jan 17 18:08:57 better kernel: 2 locks held by kswapd0/294:
> Jan 17 18:08:57 better kernel: #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810e0132>] shrink_slab+0x32/0x1e0
> Jan 17 18:08:57 better kernel: #1:  (iprune_sem){.+.+.-}, at: [<ffffffff811228c2>] shrink_icache_memory+0x82/0x2e0
> Jan 17 18:08:57 better kernel:
> Jan 17 18:08:57 better kernel: stack backtrace:
> Jan 17 18:08:57 better kernel: Pid: 294, comm: kswapd0 Not tainted 2.6.32.3-melech #4
> Jan 17 18:08:57 better kernel: Call Trace:
> Jan 17 18:08:57 better kernel: [<ffffffff81080bdc>] print_usage_bug+0x18c/0x1e0
> Jan 17 18:08:57 better kernel: [<ffffffff8108109d>] mark_lock+0x46d/0x660
> Jan 17 18:08:57 better kernel: [<ffffffff81081cd0>] ? check_usage_forwards+0x0/0x100
> Jan 17 18:08:57 better kernel: [<ffffffff81082f1a>] __lock_acquire+0x79a/0x1d10
> Jan 17 18:08:57 better kernel: [<ffffffff810d864c>] ? __pagevec_free+0xcc/0x100
> Jan 17 18:08:57 better kernel: [<ffffffff810d2440>] ? find_get_pages+0x0/0x170
> Jan 17 18:08:57 better kernel: [<ffffffff810d256b>] ? find_get_pages+0x12b/0x170
> Jan 17 18:08:57 better kernel: [<ffffffff81084592>] lock_acquire+0x102/0x140
> Jan 17 18:08:57 better kernel: [<ffffffffa0490939>] ? __ntfs_clear_inode+0x19/0x150 [ntfs]
> Jan 17 18:08:57 better kernel: [<ffffffff81397c6f>] down_write+0x3f/0x50
> Jan 17 18:08:57 better kernel: [<ffffffffa0490939>] ? __ntfs_clear_inode+0x19/0x150 [ntfs]
> Jan 17 18:08:57 better kernel: [<ffffffffa0490939>] __ntfs_clear_inode+0x19/0x150 [ntfs]
> Jan 17 18:08:57 better kernel: [<ffffffffa0490b71>] ntfs_clear_big_inode+0x61/0x130 [ntfs]
> Jan 17 18:08:57 better kernel: [<ffffffff8112242d>] clear_inode+0x8d/0x140
> Jan 17 18:08:57 better kernel: [<ffffffff81122740>] dispose_list+0x30/0x130
> Jan 17 18:08:57 better kernel: [<ffffffff81122aa8>] shrink_icache_memory+0x268/0x2e0
> Jan 17 18:08:57 better kernel: [<ffffffff810e0232>] shrink_slab+0x132/0x1e0
> Jan 17 18:08:57 better kernel: [<ffffffff810e0824>] kswapd+0x544/0x770
> Jan 17 18:08:57 better kernel: [<ffffffff810dd990>] ? isolate_pages_global+0x0/0x230
> Jan 17 18:08:57 better kernel: [<ffffffff8106dfb0>] ? autoremove_wake_function+0x0/0x40
> Jan 17 18:08:57 better kernel: [<ffffffff810e02e0>] ? kswapd+0x0/0x770
> Jan 17 18:08:57 better kernel: [<ffffffff8106dbe6>] kthread+0x96/0xa0
> Jan 17 18:08:57 better kernel: [<ffffffff8100d05a>] child_rip+0xa/0x20
> Jan 17 18:08:57 better kernel: [<ffffffff8100c9c0>] ? restore_args+0x0/0x30
> Jan 17 18:08:57 better kernel: [<ffffffff8106db50>] ? kthread+0x0/0xa0
> Jan 17 18:08:57 better kernel: [<ffffffff8100d050>] ? child_rip+0x0/0x20
> 
> Cheers,
> 
> Marcus
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
> 
> iEYEARECAAYFAktUT7sACgkQXjXn6TzcAQl+wACg8nmdQSHC1fU8JTYNYXqOslgX
> 4nMAoLAa3/0p+midCJVbvHC4Imy9FWbO
> =rnrR
> -----END PGP SIGNATURE-----
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

