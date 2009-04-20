Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbZDTHsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbZDTHsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZDTHsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:48:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:19752 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZDTHsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=hGkoL+4jDHtmh+DA7fZSjRf/qK+HvzrNoz17xUBzE+/VO3uWERWv3b0orKbdDLd7NI
         Rk5YDd8EBNEKKHi/r+QWR5qNMfOoetZ9GVkmOAjx0iwK60Cct4YAj0A6NPrFFwKaRvpz
         OdXdHtugx/k/PDhQP8zZTWhUPAwFNQpq5/pt4=
MIME-Version: 1.0
In-Reply-To: <a4423d670904150543w3d6e1371i874618c6bd8bbd0e@mail.gmail.com>
References: <a4423d670904150543w3d6e1371i874618c6bd8bbd0e@mail.gmail.com>
Date: Mon, 20 Apr 2009 11:42:25 +0400
Message-ID: <a4423d670904200042r476aa2d2p9b8125fe3c8600ac@mail.gmail.com>
Subject: Re: 2.6.30-rc2: BUG: MAX_LOCKDEP_ENTRIES too low! when mounting 
	rootfs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/15 Alexander Beregalov <a.beregalov@gmail.com>:
> Hi
>
> bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex, receive &
> transmit flow control ON
> BUG: MAX_LOCKDEP_ENTRIES too low!
> turning off the locking correctness validator.
> Pid: 2382, comm: mount Tainted: G        W  2.6.30-rc2-dirty #121
> Call Trace:
>  [<ffffffff80280aa7>] add_lock_to_list+0xf7/0x110
>  [<ffffffff80282ad1>] ? check_irq_usage+0xb1/0x110
>  [<ffffffff802df73c>] ? lock_super+0x3c/0x60
>  [<ffffffff80284f20>] __lock_acquire+0xe80/0x12b0
>  [<ffffffff802df73c>] ? lock_super+0x3c/0x60
>  [<ffffffff802853f0>] lock_acquire+0xa0/0xe0
>  [<ffffffff802df73c>] ? lock_super+0x3c/0x60
>  [<ffffffff805f0b50>] ? usbfs_fill_super+0x0/0xe0
>  [<ffffffff806d9178>] __mutex_lock_common+0x68/0x500
>  [<ffffffff802df73c>] ? lock_super+0x3c/0x60
>  [<ffffffff802df73c>] ? lock_super+0x3c/0x60
>  [<ffffffff805f0b50>] ? usbfs_fill_super+0x0/0xe0
>  [<ffffffff806d9738>] mutex_lock_nested+0x48/0x70
>  [<ffffffff802df73c>] lock_super+0x3c/0x60
>  [<ffffffff802dfa7a>] __fsync_super+0x2a/0xa0
>  [<ffffffff802dfb10>] fsync_super+0x20/0x50
>  [<ffffffff802f1f70>] ? shrink_dcache_sb+0x20/0x40
>  [<ffffffff802dfb8c>] do_remount_sb+0x4c/0x250
>  [<ffffffff802e08a5>] get_sb_single+0x75/0x100
>  [<ffffffff805f02b9>] usb_get_sb+0x29/0x50
>  [<ffffffff802df0e7>] vfs_kern_mount+0x67/0xf0
>  [<ffffffff802f942d>] ? get_fs_type+0x4d/0xf0
>  [<ffffffff802df21d>] do_kern_mount+0x5d/0x130
>  [<ffffffff802fcd88>] do_mount+0x2e8/0x930
>  [<ffffffff802a996e>] ? __get_free_pages+0x2e/0x80
>  [<ffffffff802fd4b0>] sys_mount+0xe0/0x120
>  [<ffffffff8020ba6b>] system_call_fastpath+0x16/0x1b

Another one with XFS

BUG: MAX_LOCKDEP_ENTRIES too low!
turning off the locking correctness validator.
Pid: 1717, comm: mv Tainted: G        W  2.6.30-rc2-00429-gd91dfbb-dirty #38
Call Trace:
 [<ffffffff8027e4d7>] add_lock_to_list+0xf7/0x110
 [<ffffffff80280501>] ? check_irq_usage+0xb1/0x110
 [<ffffffff8041afa2>] ? xfs_mod_incore_sb_batch+0x42/0x180
 [<ffffffff80282930>] __lock_acquire+0xe60/0x1290
 [<ffffffff804dbf3e>] ? debug_check_no_obj_freed+0xae/0x210
 [<ffffffff80281da7>] ? __lock_acquire+0x2d7/0x1290
 [<ffffffff8041afa2>] ? xfs_mod_incore_sb_batch+0x42/0x180
 [<ffffffff80282e00>] lock_acquire+0xa0/0xe0
 [<ffffffff8041afa2>] ? xfs_mod_incore_sb_batch+0x42/0x180
 [<ffffffff804dc02c>] ? debug_check_no_obj_freed+0x19c/0x210
 [<ffffffff806d92db>] _spin_lock+0x4b/0xa0
 [<ffffffff8041afa2>] ? xfs_mod_incore_sb_batch+0x42/0x180
 [<ffffffff8027d800>] ? trace_hardirqs_off+0x20/0x40
 [<ffffffff8041afa2>] xfs_mod_incore_sb_batch+0x42/0x180
 [<ffffffff8041e9a0>] xfs_trans_unreserve_and_mod_sb+0x260/0x310
 [<ffffffff80281130>] ? trace_hardirqs_on+0x20/0x40
 [<ffffffff8040ceb7>] ? xfs_log_ticket_put+0x57/0x80
 [<ffffffff8040ceb7>] ? xfs_log_ticket_put+0x57/0x80
 [<ffffffff8040ffd9>] ? xfs_log_done+0x89/0xf0
 [<ffffffff8041f909>] _xfs_trans_commit+0x229/0x450
 [<ffffffff8041cd03>] xfs_rename+0x563/0x7c0
 [<ffffffff802810ad>] ? trace_hardirqs_on_caller+0x18d/0x1f0
 [<ffffffff802e648e>] ? vfs_rename+0x14e/0x410
 [<ffffffff80434dc4>] xfs_vn_rename+0x74/0xa0
 [<ffffffff802e64f8>] vfs_rename+0x1b8/0x410
 [<ffffffff806d9b4f>] ? _spin_unlock+0x3f/0x80
 [<ffffffff802e92db>] sys_renameat+0x23b/0x280
 [<ffffffff806d9ff5>] ? _spin_unlock_irqrestore+0x55/0xb0
 [<ffffffff804d0d10>] ? __up_read+0x90/0xd0
 [<ffffffff8020c4ad>] ? retint_swapgs+0xe/0x13
 [<ffffffff802810ad>] ? trace_hardirqs_on_caller+0x18d/0x1f0
 [<ffffffff802e9349>] sys_rename+0x29/0x50
 [<ffffffff8020ba6b>] system_call_fastpath+0x16/0x1b
