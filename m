Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbXCEAJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbXCEAJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbXCEAJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:09:38 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49861 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752558AbXCEAJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:09:37 -0500
Date: Mon, 5 Mar 2007 01:09:38 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Matthew L Foster <mfoster167@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG 2.6.20-git14
Message-ID: <20070305000938.GJ3441@stusta.de>
References: <773330.46432.qm@web51006.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <773330.46432.qm@web51006.mail.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 07:18:45AM -0800, Matthew L Foster wrote:
> 
> Hi, is this a single bit error or something else? FYI this is with 2.6.20-git14

Is this still present with a recent -git?

> BUG: unable to handle kernel paging request at virtual address 04000000
>  printing eip:
> c0137464
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT 
> Modules linked in:
> CPU:    0
> EIP:    0060:[<c0137464>]    Not tainted VLI
> EFLAGS: 00210006   (2.6.20-git14 #1)
> EIP is at find_lock_page+0x27/0x85
> eax: 04000000   ebx: 00000000   ecx: d9bf4a00   edx: 00000000
> esi: 04000000   edi: d8c1bd1c   ebp: c22f5d50   esp: c22f5d40
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process gconftool-2 (pid: 2917, ti=c22f5000 task=d1018030 task.ti=c22f5000)
> Stack: 0000012e 00000000 0000012e 00001000 c22f5dec c013856f 00001000 00000001 
>        c22f5ed8 00000001 00001000 018b9800 d1070280 d8c1bd1c c02c8760 d8c1bbec 
>        00001000 00000000 b7d54000 00000000 c22f5f5c 00000000 c1032960 00000000 
> Call Trace:
>  [<c01044f5>] show_trace_log_lvl+0x1a/0x2f
>  [<c01045a5>] show_stack_log_lvl+0x9b/0xa3
>  [<c0104771>] show_registers+0x1c4/0x2da
>  [<c010498e>] die+0x107/0x206
>  [<c01107fe>] do_page_fault+0x43a/0x50c
>  [<c02c1fac>] error_code+0x74/0x7c
>  [<c013856f>] generic_file_buffered_write+0x134/0x575
>  [<c0138e16>] __generic_file_aio_write_nolock+0x466/0x4d3
>  [<c0138ed9>] generic_file_aio_write+0x56/0xb4
>  [<c0182453>] ext3_file_write+0x27/0x99
>  [<c014ceae>] do_sync_write+0xc2/0xff
>  [<c014d604>] vfs_write+0x90/0x119
>  [<c014dae3>] sys_write+0x3d/0x61
>  [<c0103e28>] sysenter_past_esp+0x5d/0x99
>  =======================
> Code: ff 5b c9 c3 55 89 e5 57 89 c7 8d 40 10 56 53 83 ec 04 89 55 f0 e8 12 a3 18 00 8b 55 f0 8d 47
> 04 e8 24 cc 08 00 85 c0 89 c6 74 4e <
> 0 89 f2 f6 c4 40 74 03 8b 56 0c ff 42 04 0f ba 2e 00 19 c0 
> EIP: [<c0137464>] find_lock_page+0x27/0x85 SS:ESP 0068:c22f5d40
> note: gconftool-2[2917] exited with preempt_count 1
> BUG: scheduling while atomic: gconftool-2/0x10000001/2917
> 2 locks held by gconftool-2/2917:
>  #0:  (&inode->i_mutex){--..}, at: [<c02c06a5>] mutex_lock+0x8/0xa
>  #1:  (&inode->i_data.tree_lock){++..}, at: [<c0137453>] find_lock_page+0x16/0x85
> irq event stamp: 171864
> hardirqs last  enabled at (171863): [<c02c0678>] __mutex_lock_slowpath+0x241/0x266
> hardirqs last disabled at (171864): [<c02c1774>] _read_lock_irq+0xf/0x48
> softirqs last  enabled at (171818): [<c0118f91>] __do_softirq+0x91/0x96
> softirqs last disabled at (171807): [<c0105b94>] do_softirq+0x50/0xb6
>  [<c01044f5>] show_trace_log_lvl+0x1a/0x2f
>  [<c0104b5f>] show_trace+0x12/0x14
>  [<c0104bfc>] dump_stack+0x16/0x18
>  [<c02bf0e1>] __sched_text_start+0x71/0x584
>  [<c0112191>] __cond_resched+0x16/0x34
>  [<c02bfbd9>] cond_resched+0x26/0x31
>  [<c0140c8c>] unmap_vmas+0x310/0x3e3
>  [<c0143275>] exit_mmap+0x68/0xe5
>  [<c0113023>] mmput+0x25/0x75
>  [<c01160d0>] exit_mm+0xbb/0xc1
>  [<c01173e0>] do_exit+0x1bb/0x6b4
>  [<c0104a67>] die+0x1e0/0x206
>  [<c01107fe>] do_page_fault+0x43a/0x50c
>  [<c02c1fac>] error_code+0x74/0x7c
>  [<c013856f>] generic_file_buffered_write+0x134/0x575
>  [<c0138e16>] __generic_file_aio_write_nolock+0x466/0x4d3
>  [<c0138ed9>] generic_file_aio_write+0x56/0xb4
>  [<c0182453>] ext3_file_write+0x27/0x99
>  [<c014ceae>] do_sync_write+0xc2/0xff
>  [<c014d604>] vfs_write+0x90/0x119
>  [<c014dae3>] sys_write+0x3d/0x61
>  [<c0103e28>] sysenter_past_esp+0x5d/0x99
>  =======================

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

