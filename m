Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYBLWEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYBLWEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYBLWEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:04:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292AbYBLWEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:04:34 -0500
Date: Tue, 12 Feb 2008 14:04:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.24-sha1: RIP  [<ffffffff802596c8>]
 iov_iter_advance+0x38/0x70
Message-Id: <20080212140430.c85e6018.akpm@linux-foundation.org>
In-Reply-To: <20080210140031.GA1754@martell.zuzino.mipt.ru>
References: <20080210140031.GA1754@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 17:00:31 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> This happened during LTP. FWIW, modprobe/rmmod trivial empty module
> together with cat /proc/*/wchan and cat /proc/modules were also running.
> 
> Box is E6400, much debugging is on, config below.
> 
> 
> [ 4057.310000] BUG: unable to handle kernel paging request at ffff810101dbc008
> [ 4057.310000] IP: [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
> [ 4057.310000] PGD 8063 PUD c063 PMD 153baa163 PTE 8000000101dbc160
> [ 4057.310000] Oops: 0000 [1] SMP DEBUG_PAGEALLOC
> [ 4057.310000] CPU 0 
> [ 4057.310000] Modules linked in: [last unloaded: foo]

what is this foo.ko of which you speak, and did it wreck your kernel?

> [ 4057.310000] Pid: 7035, comm: ftest03 Not tainted 2.6.24-25f666300625d894ebe04bac2b4b3aadb907c861 #2
> [ 4057.310000] RIP: 0010:[<ffffffff802596c8>]  [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
> [ 4057.310000] RSP: 0018:ffff810110329b20  EFLAGS: 00010246
> [ 4057.310000] RAX: 0000000000000000 RBX: 0000000000000800 RCX: 0000000000000000
> [ 4057.310000] RDX: 0000000000000000 RSI: 0000000000000800 RDI: ffff810110329ba8
> [ 4057.310000] RBP: 0000000000000800 R08: 0000000000000000 R09: ffff810101dbc000
> [ 4057.310000] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000026000
> [ 4057.310000] R13: ffff81010d765c98 R14: 0000000000001000 R15: 0000000000000000
> [ 4057.310000] FS:  00007fee589146d0(0000) GS:ffffffff80501000(0000) knlGS:0000000000000000
> [ 4057.310000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 4057.310000] CR2: ffff810101dbc008 CR3: 00000001103da000 CR4: 00000000000006e0
> [ 4057.310000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 4057.310000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 4057.310000] Process ftest03 (pid: 7035, threadinfo ffff810110328000, task ffff810160b00000)
> [ 4057.310000] Stack:  ffffffff8025b413 ffff81010d765ab0 ffffffff804e6fd8 00000000001201d2
> [ 4057.310000]  ffff810110329db8 0000000000026000 ffff810110329d38 ffff81017b9fb500
> [ 4057.310000]  ffff81010d765c98 ffffffff804175e0 ffff81010d765ab0 0000000000000000
> [ 4057.310000] Call Trace:
> [ 4057.310000]  [<ffffffff8025b413>] ? generic_file_buffered_write+0x1e3/0x6f0
> [ 4057.310000]  [<ffffffff8022f4ae>] ? current_fs_time+0x1e/0x30
> [ 4057.310000]  [<ffffffff8025bbaf>] ? __generic_file_aio_write_nolock+0x28f/0x440
> [ 4057.310000]  [<ffffffff8025bdc3>] ? generic_file_aio_write+0x63/0xd0
> [ 4057.310000]  [<ffffffff802bfbc3>] ? ext3_file_write+0x23/0xc0
> [ 4057.310000]  [<ffffffff802bfba0>] ? ext3_file_write+0x0/0xc0
> [ 4057.310000]  [<ffffffff8027ebeb>] ? do_sync_readv_writev+0xcb/0x110
> [ 4057.310000]  [<ffffffff8023f2b0>] ? autoremove_wake_function+0x0/0x30
> [ 4057.310000]  [<ffffffff8024be8d>] ? debug_check_no_locks_freed+0x7d/0x130
> [ 4057.310000]  [<ffffffff8024bd8f>] ? trace_hardirqs_on+0xcf/0x150
> [ 4057.310000]  [<ffffffff8027c265>] ? __kmalloc+0x15/0xc0
> [ 4057.310000]  [<ffffffff8027ea4d>] ? rw_copy_check_uvector+0x9d/0x130
> [ 4057.310000]  [<ffffffff8027f330>] ? do_readv_writev+0xe0/0x170
> [ 4057.310000]  [<ffffffff803fb5e7>] ? mutex_lock_nested+0x1a7/0x280
> [ 4057.310000]  [<ffffffff8024bd8f>] ? trace_hardirqs_on+0xcf/0x150
> [ 4057.310000]  [<ffffffff803fb389>] ? __mutex_unlock_slowpath+0xc9/0x170
> [ 4057.310000]  [<ffffffff8024bd8f>] ? trace_hardirqs_on+0xcf/0x150
> [ 4057.310000]  [<ffffffff803fc6ba>] ? trace_hardirqs_on_thunk+0x35/0x3a
> [ 4057.310000]  [<ffffffff8027f7c3>] ? sys_writev+0x53/0x90
> [ 4057.310000]  [<ffffffff8020b39b>] ? system_call_after_swapgs+0x7b/0x80
> [ 4057.310000] 
> [ 4057.310000] 
> [ 4057.310000] Code: 48 01 77 10 48 29 77 18 c3 0f 0b eb fe 66 66 90 66 66 90 4c 8b 0f 48 8b 4f 10 49 89 f0 eb 07 66 66 66 90 49 29 c0 4d 85 c0 75 07 <49> 83 79 08 00 75 23 49 8b 51 08 48 89 d0 48 29 c8 49 39 c0 49 
> [ 4057.310000] RIP  [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
> [ 4057.310000]  RSP <ffff810110329b20>
> [ 4057.310000] CR2: ffff810101dbc008
> [ 4057.310000] Kernel panic - not syncing: Fatal exception

because this has me stumped.  It might need bisecting, please.

Nick, can you think of anything around there which we changed?
