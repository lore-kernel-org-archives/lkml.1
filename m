Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbXFZPTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbXFZPTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbXFZPTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:19:09 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48377 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459AbXFZPTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:19:08 -0400
Date: Tue, 26 Jun 2007 16:18:27 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Thomas Sattler <tsattler@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: held lock freed!
In-Reply-To: <4680EAB8.10703@gmx.de>
Message-ID: <Pine.LNX.4.64.0706261557320.30082@blonde.wat.veritas.com>
References: <4680EAB8.10703@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAAmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAdHNhdHRsZXJAZ214LmRlAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Thomas Sattler wrote:

> Hi there ...
> 
> I removed xfs from my system. The first reboot after replacing xfs with
> ext3 brought be

Perhaps this is a curse that falls on those who desert XFS ;)

> 
> Jun 26 08:43:17 pearl =========================
> Jun 26 08:43:17 pearl [ BUG: held lock freed! ]
> Jun 26 08:43:17 pearl -------------------------
> Jun 26 08:43:17 pearl udevd/3064 is freeing memory c16fbe40-c16fbe7f,
> with a lock still held there!
> Jun 26 08:43:17 pearl (&sbinfo->stat_lock){--..}, at: [<c0157eb1>]
> shmem_delete_inode+0xc1/0xda
> Jun 26 08:43:17 pearl 1 lock held by udevd/3064:
> Jun 26 08:43:17 pearl #0:  (&sbinfo->stat_lock){--..}, at: [<c0157eb1>]
> shmem_delete_inode+0xc1/0xda
> Jun 26 08:43:17 pearl
> Jun 26 08:43:17 pearl stack backtrace:
> Jun 26 08:43:17 pearl [<c0135331>] debug_check_no_locks_freed+0xe7/0x11a
> Jun 26 08:43:17 pearl [<c0158649>] kfree+0x45/0x7f
> Jun 26 08:43:17 pearl [<c016c3d2>] free_fdtable_rcu+0x3a/0x70
> Jun 26 08:43:17 pearl [<c012a95f>] __rcu_process_callbacks+0xfd/0x165
> Jun 26 08:43:17 pearl [<c012a9d6>] rcu_process_callbacks+0xf/0x1e
> Jun 26 08:43:17 pearl [<c0120c69>] tasklet_action+0x3d/0x68
> Jun 26 08:43:17 pearl [<c0120b9e>] __do_softirq+0x41/0x92
> Jun 26 08:43:17 pearl [<c0120c16>] do_softirq+0x27/0x3d
> Jun 26 08:43:17 pearl [<c0120fae>] irq_exit+0x35/0x64
> Jun 26 08:43:17 pearl [<c0106108>] do_IRQ+0x7e/0x92
> Jun 26 08:43:17 pearl [<c0104634>] common_interrupt+0x24/0x34
> Jun 26 08:43:17 pearl [<c010463e>] common_interrupt+0x2e/0x34
> Jun 26 08:43:17 pearl [<c0136513>] lock_acquire+0x68/0x6e
> Jun 26 08:43:17 pearl [<c0157eb1>] shmem_delete_inode+0xc1/0xda
> Jun 26 08:43:17 pearl [<c02e4daa>] _spin_lock+0x29/0x34
> Jun 26 08:43:17 pearl [<c0157eb1>] shmem_delete_inode+0xc1/0xda
> Jun 26 08:43:17 pearl [<c0157eb1>] shmem_delete_inode+0xc1/0xda
> Jun 26 08:43:17 pearl [<c0157df0>] shmem_delete_inode+0x0/0xda
> Jun 26 08:43:17 pearl [<c016b2a8>] generic_delete_inode+0x8c/0xf4
> Jun 26 08:43:17 pearl [<c016aa33>] iput+0x60/0x62
> Jun 26 08:43:17 pearl [<c01636d7>] do_unlinkat+0xbe/0x132
> Jun 26 08:43:17 pearl [<c0103bfa>] sysenter_past_esp+0x8f/0x99
> Jun 26 08:43:17 pearl [<c0135227>] trace_hardirqs_on+0x11e/0x141
> Jun 26 08:43:17 pearl [<c0103bca>] sysenter_past_esp+0x5f/0x99
> Jun 26 08:43:17 pearl =======================
> 
> But it only came once, several reboots after that were ok. I changed my
> kernel config today: e1000 is now "=y" (was "=m"), I removed PCMCIA as I
> do not use it and some other modules complained about it, and I added
> CONFIG_HIGHMEM4G=y (was CONFIG_NOHIGHMEM=y)
> 
> The running kernel is 2.6.22.5 +cfs +squashfs. My distribution is gentoo
> (x86), quite up to date, udev is 104-r12.
> 
> Please CC me as I'm not subscribed to the list.

Odd.  I can't see any error at the shmem_delete_inode end nor at the
free_fdtable_rcu end.  It seems to be some kind of corruption, whereby
free_fdtable_rcu is kfree'ing some memory (perhaps fdt->open_fds),
but the address kfreed is that of the shmem_sb_info in which it has
just acquired a spinlock at the top of the stack.

I've not found any kfreeing of uninitialized pointer in fs/file.c.

It could come about through a single-bit error, and I was going to
suggest that you give memtest86+ a good run overnight.  And still do
suggest that, though we seem to have rather too much of a coincidence
for it to be a likely explanation.  But I've no other ideas, sorry.

Hugh
