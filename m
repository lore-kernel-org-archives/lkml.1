Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbXEWXur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbXEWXur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbXEWXuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:50:39 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755439AbXEWXui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:50:38 -0400
Date: Wed, 23 May 2007 16:50:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com
Subject: Re: 2.6.22-rc2-mm1
Message-Id: <20070523165024.d7ee6de2.akpm@linux-foundation.org>
In-Reply-To: <1179962229.8575.4.camel@localhost>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<1179962229.8575.4.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 17:17:09 -0600
Zan Lynx <zlynx@acm.org> wrote:

> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.22-rc2-mm1 #1
> -------------------------------------------------------
> rhythmbox/6976 is trying to acquire lock:
>  (&mm->mmap_sem){----}, at: [<ffffffff80534f8c>] do_page_fault+0x17c/0x880
> 
> but task is already holding lock:
>  (&data->latch){----}, at: [<ffffffff8034a701>] get_exclusive_access+0x11/0x20
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&data->latch){----}:
>        [<ffffffff8025b8bc>] __lock_acquire+0xbfc/0x1030
>        [<ffffffff8025bd3b>] lock_acquire+0x4b/0x70
>        [<ffffffff8034a701>] get_exclusive_access+0x11/0x20
>        [<ffffffff80254c5f>] down_write+0x2f/0x40
>        [<ffffffff8034a701>] get_exclusive_access+0x11/0x20
>        [<ffffffff803498c8>] mmap_unix_file+0x58/0x140
>        [<ffffffff80292125>] mmap_region+0x195/0x540
>        [<ffffffff80292b2e>] do_mmap_pgoff+0x2fe/0x390
>        [<ffffffff80532b5f>] _spin_unlock_irq+0x2f/0x50
>        [<ffffffff802e2bca>] elf_map+0xfa/0x100
>        [<ffffffff802e5574>] load_elf_binary+0x1c14/0x2110
>        [<ffffffff80258a25>] add_lock_to_list+0x65/0xe0
>        [<ffffffff8025b98e>] __lock_acquire+0xcce/0x1030
>        [<ffffffff802820fe>] get_page_from_freelist+0x33e/0x520
>        [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
>        [<ffffffff80281fd5>] get_page_from_freelist+0x215/0x520
>        [<ffffffff8022f3d0>] load_aout_binary+0x0/0x980
>        [<ffffffff802e3960>] load_elf_binary+0x0/0x2110
>        [<ffffffff802ab3d6>] search_binary_handler+0xf6/0x290
>        [<ffffffff802ad05f>] do_execve+0x18f/0x250
>        [<ffffffff80208ab4>] sys_execve+0x44/0xb0
>        [<ffffffff8020a567>] stub_execve+0x67/0xb0
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #0 (&mm->mmap_sem){----}:
>        [<ffffffff80259b68>] print_circular_bug_header+0xe8/0xf0
>        [<ffffffff8025b6f2>] __lock_acquire+0xa32/0x1030
>        [<ffffffff80532b15>] _spin_unlock_irqrestore+0x65/0x80
>        [<ffffffff8025bd3b>] lock_acquire+0x4b/0x70
>        [<ffffffff80534f8c>] do_page_fault+0x17c/0x880
>        [<ffffffff80254b82>] down_read+0x32/0x40
>        [<ffffffff80534f8c>] do_page_fault+0x17c/0x880
>        [<ffffffff80532b54>] _spin_unlock_irq+0x24/0x50
>        [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
>        [<ffffffff80532b15>] _spin_unlock_irqrestore+0x65/0x80
>        [<ffffffff8053318d>] error_exit+0x0/0x96
>        [<ffffffff8027c464>] file_read_actor+0x44/0x1a0
>        [<ffffffff8027c74f>] __lock_page+0x5f/0x70
>        [<ffffffff8027ced3>] do_generic_mapping_read+0x233/0x560
>        [<ffffffff8027c420>] file_read_actor+0x0/0x1a0
>        [<ffffffff8027f136>] generic_file_aio_read+0x106/0x1a0
>        [<ffffffff802a6c09>] do_sync_read+0xd9/0x120
>        [<ffffffff80258495>] lockdep_init_map+0x55/0x4e0
>        [<ffffffff802515e0>] autoremove_wake_function+0x0/0x30
>        [<ffffffff805329e9>] _spin_unlock+0x29/0x50
>        [<ffffffff8032caec>] reiser4_grab+0x8c/0xd0
>        [<ffffffff80348af4>] read_unix_file+0x454/0x490
>        [<ffffffff802a7585>] vfs_read+0xc5/0x180
>        [<ffffffff802a7a83>] sys_read+0x53/0x90
>        [<ffffffff8020a16e>] system_call+0x7e/0x83
>        [<ffffffffffffffff>] 0xffffffffffffffff

This one is a reiser4 error.  cc added.
