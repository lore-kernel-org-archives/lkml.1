Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab0BCTJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:09:04 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:43349 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab0BCTI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:08:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=Rlyb4gls5CUSZW1dCEVaGMiATl3jYtGZrJ39z++i1G0j/LTjanNZn8cPz0o54QWBhM
         j5c2PwBqk0PGGJPUKzDuabfyWSahka8ObC7TpoX4NFApwItHcwa9J1AaCHztEDoVV8IH
         7zFd3ds4hW3LGTs40G+noAA+Oa+mf79tzpmAA=
MIME-Version: 1.0
In-Reply-To: <a4423d671002031103r230f66cai4ab25236504bcf15@mail.gmail.com>
References: <a4423d671002031103r230f66cai4ab25236504bcf15@mail.gmail.com>
Date: Wed, 3 Feb 2010 22:08:57 +0300
Message-ID: <a4423d671002031108x6c2682edl9a147c35ac9c2815@mail.gmail.com>
Subject: Re: reiserfs deadlock
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 February 2010 22:03, Alexander Beregalov <a.beregalov@gmail.com> wrote:
> Hi Frederic
>
> I do not have previous messages and do not know how to reproduce it.
> Kernel was 2.6.33-rc5-00237-g9a3cbe3
>

Hm, I have the same after reboot.

Do you need me to do anything before I try to fsck ?


INFO: task metalog:1561 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
metalog       D f66768b0  5692  1561      1 0x00000000
 f6463d3c 00000046 00000007 f66768b0 c134e72d f6676b30 f66768b0 c104e4c4
 f7313c84 f7313c84 00000246 f66768b0 f6463d80 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313cac c1110ed8 f7313cc0 f3a19dc4 f3817d18 f66768b0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10f7152>] reiserfs_dirty_inode+0x22/0xc0
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c10ade0c>] __mark_inode_dirty+0x2c/0x130
 [<c10a48e2>] file_update_time+0xa2/0x110
 [<c106a199>] __generic_file_aio_write+0x1c9/0x4f0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c106a514>] generic_file_aio_write+0x54/0xb0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c109218c>] do_sync_write+0x9c/0xd0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c10f01d8>] reiserfs_file_write+0x88/0xa0
 [<c1092b5a>] vfs_write+0x9a/0x160
 [<c10f0150>] ? reiserfs_file_write+0x0/0xa0
 [<c1092ccd>] sys_write+0x3d/0x70
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by metalog/1561:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c106a501>]
generic_file_aio_write+0x41/0xb0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>]
reiserfs_write_lock_once+0x28/0x50

INFO: task svscan:1603 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
svscan        D f66da9e0  5248  1603      1 0x00000000
 f3a19da0 00000046 00000007 f66da9e0 c134e72d f66dac60 f66da9e0 c104e4c4
 f7313c84 f7313c84 00000246 f66da9e0 f3a19de4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313cac c1110f28 f7313cc0 f3b5ddc4 f6463d60 f66da9e0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by svscan/1603:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>]
vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40

INFO: task nfsd:1740 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D a741d0d1  5700  1740      2 0x00000000
 f6757a78 00000046 00000007 a741d0d1 00000010 f38d2c60 f38d29e0 c104e4c4
 f7313c84 f7313c84 00000246 f38d29e0 f6757abc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313cac c1110f28 f7313cc0 f3817d18 f7313cac f38d29e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c1102687>] search_by_key+0x247/0x21b0
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c105891b>] ? __module_text_address+0xb/0x50
 [<c1058968>] ? is_module_text_address+0x8/0x10
 [<c103b257>] ? __kernel_text_address+0x47/0x70
 [<c10051a1>] ? print_context_stack+0x41/0xb0
 [<c10042ff>] ? dump_trace+0x7f/0xd0
 [<c104bc52>] ? __bfs+0x102/0x200
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c10ebfdf>] reiserfs_read_locked_inode+0x5f/0x5a0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec5af>] reiserfs_iget+0x8f/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1740:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40

INFO: task agetty:1867 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
agetty        D f380d3c0  5444  1867      1 0x00000000
 f3805db4 00000046 00000007 f380d3c0 c134e72d f380d640 f380d3c0 c104e4c4
 f6dce118 f6dce118 00000246 f380d3c0 f3805df8 c134e6ba 00000000 00000002
 00000000 c109a4bb f6dce140 c109a4bb f6dce154 f6dce140 f3813dd8 f380d3c0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c109a4bb>] ? do_lookup+0xbb/0x1c0
 [<c109a4bb>] ? do_lookup+0xbb/0x1c0
 [<c109a4bb>] do_lookup+0xbb/0x1c0
 [<c1099eda>] ? generic_permission+0x1a/0xa0
 [<c109c06e>] link_path_walk+0x3be/0xc10
 [<c1042d1e>] ? cpu_clock+0x4e/0x60
 [<c109ca23>] path_walk+0x43/0xa0
 [<c109cb51>] do_path_lookup+0x51/0x60
 [<c109dc8a>] do_filp_open+0x4fa/0x9f0
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c10a739a>] ? alloc_fd+0xba/0xf0
 [<c11d6545>] ? strncpy_from_user+0x35/0x60
 [<c109060f>] do_sys_open+0x4f/0x110
 [<c13526a5>] ? do_page_fault+0x155/0x370
 [<c1090739>] sys_open+0x29/0x40
 [<c1002b10>] sysenter_do_call+0x12/0x36
1 lock held by agetty/1867:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109a4bb>]
do_lookup+0xbb/0x1c0

and so on...
