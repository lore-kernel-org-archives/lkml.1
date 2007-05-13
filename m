Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbXEMSMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbXEMSMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXEMSLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:11:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:43590 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751042AbXEMSLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:11:54 -0400
X-Authenticated: #420190
X-Provags-ID: V01U2FsdGVkX18VB+w6548VLxtY2A9a7Te+vtYPzSiz6SDQ+2Xyu3
	zwujs4vlnOkHeu
Message-ID: <464754E7.8000109@gmx.net>
Date: Sun, 13 May 2007 20:11:51 +0200
From: Marko Macek <Marko.Macek@gmx.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.21.1-cfs-v11 #4
-------------------------------------------------------
tvtime/6360 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<f8a6a50a>] 
videobuf_dma_init_user+0xb6/0x14e [video_buf]
 
but task is already holding lock:
 (&q->lock#2){--..}, at: [<f8a6ac43>] videobuf_qbuf+0x10/0x288 [video_buf]
 
which lock already depends on the new lock.
 
 
the existing dependency chain (in reverse order) is:
 
-> #1 (&q->lock#2){--..}:
       [<c01437eb>] __lock_acquire+0x9de/0xb58
       [<f8a695fe>] videobuf_mmap_mapper+0x12/0x1ff [video_buf]
       [<c0143d19>] lock_acquire+0x56/0x6e
       [<f8a695fe>] videobuf_mmap_mapper+0x12/0x1ff [video_buf]
       [<c032579a>] __mutex_lock_slowpath+0xe3/0x23b
       [<f8a695fe>] videobuf_mmap_mapper+0x12/0x1ff [video_buf]
       [<f8a695fe>] videobuf_mmap_mapper+0x12/0x1ff [video_buf]
       [<c0173559>] kmem_cache_zalloc+0x69/0x97
       [<c0142a07>] trace_hardirqs_on+0x11e/0x141
       [<c0168eea>] do_mmap_pgoff+0x43e/0x714
       [<c0108adb>] sys_mmap2+0x9d/0xb7
       [<c0104d9e>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

-> #0 (&mm->mmap_sem){----}:
       [<c014170f>] print_circular_bug_entry+0x40/0x46
       [<c01436d7>] __lock_acquire+0x8ca/0xb58
       [<f8a6a50a>] videobuf_dma_init_user+0xb6/0x14e [video_buf]
       [<c0143d19>] lock_acquire+0x56/0x6e
       [<f8a6a50a>] videobuf_dma_init_user+0xb6/0x14e [video_buf]
       [<c013d082>] down_read+0x3d/0x4e
       [<f8a6a50a>] videobuf_dma_init_user+0xb6/0x14e [video_buf]
       [<f8a6a50a>] videobuf_dma_init_user+0xb6/0x14e [video_buf]
       [<f8a69ae7>] videobuf_waiton+0xdf/0xe9 [video_buf]
       [<f8a6a836>] videobuf_iolock+0x7f/0xdf [video_buf]
       [<f8a7fdb2>] buffer_prepare+0x174/0x1d8 [saa7134]
       [<c03258ea>] __mutex_lock_slowpath+0x233/0x23b
       [<f8a6ac43>] videobuf_qbuf+0x10/0x288 [video_buf]
       [<f8a6ae23>] videobuf_qbuf+0x1f0/0x288 [video_buf]
       [<c0159626>] find_get_page+0x40/0x45
       [<f8a8144d>] video_do_ioctl+0xd6f/0xec7 [saa7134]
       [<c0326a8a>] _spin_unlock+0x14/0x1c
       [<f8a0e946>] video_usercopy+0x172/0x237 [videodev]
       [<c0328621>] do_page_fault+0x202/0x5df
       [<f8a7ef74>] video_ioctl+0x18/0x1c [saa7134]
       [<f8a806de>] video_do_ioctl+0x0/0xec7 [saa7134]
       [<c0180ca0>] do_ioctl+0x4c/0x62
       [<c0180efa>] vfs_ioctl+0x244/0x256
       [<c0180f58>] sys_ioctl+0x4c/0x64
       [<c0104d9e>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by tvtime/6360:
 #0:  (&q->lock#2){--..}, at: [<f8a6ac43>] videobuf_qbuf+0x10/0x288 
[video_buf]

stack backtrace:
 [<c0141fa7>] print_circular_bug_tail+0x5f/0x67
 [<c014170f>] print_circular_bug_entry+0x40/0x46
 [<c01436d7>] __lock_acquire+0x8ca/0xb58
 [<f8a6a50a>] videobuf_dma_init_user+0xb6/0x14e [video_buf]
 [<c0143d19>] lock_acquire+0x56/0x6e
 [<f8a6a50a>] videobuf_dma_init_user+0xb6/0x14e [video_buf]
 [<c013d082>] down_read+0x3d/0x4e
 [<f8a6a50a>] videobuf_dma_init_user+0xb6/0x14e [video_buf]
 [<f8a6a50a>] videobuf_dma_init_user+0xb6/0x14e [video_buf]
 [<f8a69ae7>] videobuf_waiton+0xdf/0xe9 [video_buf]
 [<f8a6a836>] videobuf_iolock+0x7f/0xdf [video_buf]
 [<f8a7fdb2>] buffer_prepare+0x174/0x1d8 [saa7134]
 [<c03258ea>] __mutex_lock_slowpath+0x233/0x23b
 [<f8a6ac43>] videobuf_qbuf+0x10/0x288 [video_buf]
 [<f8a6ae23>] videobuf_qbuf+0x1f0/0x288 [video_buf]
 [<c0159626>] find_get_page+0x40/0x45
 [<f8a8144d>] video_do_ioctl+0xd6f/0xec7 [saa7134]
 [<c0326a8a>] _spin_unlock+0x14/0x1c
 [<f8a0e946>] video_usercopy+0x172/0x237 [videodev]
 [<c0328621>] do_page_fault+0x202/0x5df
 [<f8a7ef74>] video_ioctl+0x18/0x1c [saa7134]
 [<f8a806de>] video_do_ioctl+0x0/0xec7 [saa7134]
 [<c0180ca0>] do_ioctl+0x4c/0x62
 [<c0180efa>] vfs_ioctl+0x244/0x256
 [<c0180f58>] sys_ioctl+0x4c/0x64
 [<c0104d9e>] sysenter_past_esp+0x5f/0x99
 =======================


The TV card is saa7134.
Machine is AMD Athlon 64 X2. Fedora Core 6.

I get a lockup while watching TV about every month or two. Machine 
responds to ping, but nothing else.

Mark
