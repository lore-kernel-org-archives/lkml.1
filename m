Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbYF3KxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbYF3KxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYF3Kwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:52:54 -0400
Received: from po-out-1718.google.com ([72.14.252.156]:27915 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbYF3Kwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=JH1hnegHZO1UGLiOEjFzDXGjyoQJiuzoDvbQk218adPj5SIwbL5XTaaT0TgWYgvHfi
         AhQ/pg/eUZoJHcRNHkSJIVVp1/3H6Kn2y7Ax0F5Pe7woqyo/R0f3+1UYRIhcteMHk4bm
         q4v9bl7fy0hNv0NVEfzULdqA/1dP6rjWAIHso=
Message-ID: <c4e36d110806300352i51f76630p42abc44e1b15c68e@mail.gmail.com>
Date: Mon, 30 Jun 2008 12:52:52 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc8-slab INFO: possible circular locking dependency detected
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've made fresh compilation of  -rc8 kernel commit:
1702b52092e9a6d05398d3f9581ddc050ef00d06
Machine - T61,  2GB, C2D, x86_64

This appeared in my startup log:

----
iwl3945: Tuning to channel 3
iwl3945: Not a valid iwl3945_rxon_assoc_cmd field values
iwl3945: Invalid RXON configuration.  Not committing.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-rc8-slab #38
-------------------------------------------------------
nautilus/2988 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<ffffffff812f871d>] do_page_fault+0x11d/0xaf0

but task is already holding lock:
 (&dev->ev_mutex){--..}, at: [<ffffffff810ed39b>] inotify_read+0xdb/0x200

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&dev->ev_mutex){--..}:
       [<ffffffff81063ca9>] __lock_acquire+0x1149/0x11d0
       [<ffffffff81063dc6>] lock_acquire+0x96/0xe0
       [<ffffffff812f3250>] mutex_lock_nested+0xc0/0x330
       [<ffffffff810edaa1>] inotify_dev_queue_event+0x41/0x1b0
       [<ffffffff810ec95e>] inotify_inode_queue_event+0xbe/0x100
       [<ffffffff810c2f0e>] vfs_create+0xee/0x140
       [<ffffffff810c63fa>] do_filp_open+0x93a/0xa40
       [<ffffffff810b62a6>] do_sys_open+0x76/0x100
       [<ffffffff810b635b>] sys_open+0x1b/0x20
       [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #2 (&ih->mutex){--..}:
       [<ffffffff81063ca9>] __lock_acquire+0x1149/0x11d0
       [<ffffffff81063dc6>] lock_acquire+0x96/0xe0
       [<ffffffff812f3250>] mutex_lock_nested+0xc0/0x330
       [<ffffffff810ec70e>] inotify_find_update_watch+0x4e/0xd0
       [<ffffffff810ed664>] sys_inotify_add_watch+0x114/0x1e0
       [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&inode->inotify_mutex){--..}:
       [<ffffffff81063ca9>] __lock_acquire+0x1149/0x11d0
       [<ffffffff81063dc6>] lock_acquire+0x96/0xe0
       [<ffffffff812f3250>] mutex_lock_nested+0xc0/0x330
       [<ffffffff810ec8eb>] inotify_inode_queue_event+0x4b/0x100
       [<ffffffff810ed011>] inotify_dentry_parent_queue_event+0x91/0xb0
       [<ffffffff810b995a>] __fput+0x7a/0x1f0
       [<ffffffff810b9aed>] fput+0x1d/0x30
       [<ffffffff810a1ffa>] remove_vma+0x4a/0x80
       [<ffffffff810a3349>] do_munmap+0x2b9/0x320
       [<ffffffff810a3400>] sys_munmap+0x50/0x80
       [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&mm->mmap_sem){----}:
       [<ffffffff81063b45>] __lock_acquire+0xfe5/0x11d0
       [<ffffffff81063dc6>] lock_acquire+0x96/0xe0
       [<ffffffff812f3c4b>] down_read+0x3b/0x70
       [<ffffffff812f871d>] do_page_fault+0x11d/0xaf0
       [<ffffffff812f5fad>] error_exit+0x0/0xa9
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by nautilus/2988:
 #0:  (&dev->ev_mutex){--..}, at: [<ffffffff810ed39b>] inotify_read+0xdb/0x200

stack backtrace:
Pid: 2988, comm: nautilus Not tainted 2.6.26-rc8-slab #38

Call Trace:
 [<ffffffff810628a4>] print_circular_bug_tail+0x84/0x90
 [<ffffffff81062652>] ? print_circular_bug_entry+0x52/0x60
 [<ffffffff81063b45>] __lock_acquire+0xfe5/0x11d0
 [<ffffffff812f871d>] ? do_page_fault+0x11d/0xaf0
 [<ffffffff81063dc6>] lock_acquire+0x96/0xe0
 [<ffffffff812f871d>] ? do_page_fault+0x11d/0xaf0
 [<ffffffff812f3c4b>] down_read+0x3b/0x70
 [<ffffffff812f871d>] do_page_fault+0x11d/0xaf0
 [<ffffffff8109cd39>] ? do_wp_page+0x3b9/0x550
 [<ffffffff81013468>] ? native_sched_clock+0x78/0x80
 [<ffffffff81062ec4>] ? __lock_acquire+0x364/0x11d0
 [<ffffffff81062ec4>] ? __lock_acquire+0x364/0x11d0
 [<ffffffff812f5fad>] error_exit+0x0/0xa9
 [<ffffffff8117cf67>] ? copy_user_generic_string+0x17/0x40
 [<ffffffff810ed43d>] ? inotify_read+0x17d/0x200
 [<ffffffff81052ab0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81147361>] ? security_file_permission+0x11/0x20
 [<ffffffff810b8ff8>] ? vfs_read+0xc8/0x180
 [<ffffffff810b91a0>] ? sys_read+0x50/0x90
 [<ffffffff8100c50b>] ? system_call_after_swapgs+0x7b/0x80

kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal


----

Zdenek
