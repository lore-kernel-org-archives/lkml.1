Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbZD2DRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbZD2DRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 23:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZD2DRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 23:17:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbZD2DRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 23:17:07 -0400
Date: Tue, 28 Apr 2009 20:13:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>, David <david@unsolicited.net>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 2.6.30-rc3: reiserfs: WARNING: at fs/namei.c:1251
 lookup_one_len
Message-Id: <20090428201310.fd2c6c96.akpm@linux-foundation.org>
In-Reply-To: <a4423d670904261715q4510bdd3u2eb1ac3b90566fbc@mail.gmail.com>
References: <a4423d670904261715q4510bdd3u2eb1ac3b90566fbc@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 04:15:21 +0400 Alexander Beregalov <a.beregalov@gmail.com> wrote:

> Hi Jeff
> 
> REISERFS debug (device sda1): journal-1206: Starting replay from
> offset 6641050231768444, trans_id 1024
> REISERFS debug (device sda1): journal-1299: Setting newest_mount_id to 186
> REISERFS (device sda1): Using r5 hash to sort names
> ------------[ cut here ]------------
> WARNING: at fs/namei.c:1251 lookup_one_len+0xd6/0xf0()
> Hardware name:
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.30-rc3-00340-gce8a742 #3
> Call Trace:
>  [<c0445f82>] ? printk+0x18/0x1e
>  [<c01284e3>] warn_slowpath+0x73/0xd0
>  [<c014c7d2>] ? mark_held_locks+0x62/0x80
>  [<c0102f14>] ? restore_nocheck_notrace+0x0/0xe
>  [<c014cafc>] ? trace_hardirqs_on_caller+0x14c/0x1b0
>  [<c02c7fe4>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c012cfa7>] ? do_softirq+0x47/0x70
>  [<c0102f14>] ? restore_nocheck_notrace+0x0/0xe
>  [<c044939f>] ? _spin_unlock_irqrestore+0x2f/0x70
>  [<c012908d>] ? vprintk+0x27d/0x3c0
>  [<c0129097>] ? vprintk+0x287/0x3c0
>  [<c0192006>] lookup_one_len+0xd6/0xf0
>  [<c04490d7>] ? _spin_unlock+0x27/0x50
>  [<c02000b9>] reiserfs_xattr_init+0xb9/0x230
>  [<c0445f82>] ? printk+0x18/0x1e
>  [<c01e9207>] reiserfs_fill_super+0x9b7/0xf60
>  [<c02c60d4>] ? string+0x34/0xd0
>  [<c02c6b9b>] ? vsnprintf+0x2fb/0x890
>  [<c02c71ba>] ? snprintf+0x1a/0x20
>  [<c01c99b9>] ? disk_name+0x59/0xd0
>  [<c018bc43>] get_sb_bdev+0x133/0x160
>  [<c017079e>] ? kstrdup+0x2e/0x80
>  [<c01e6eb1>] get_super_block+0x21/0x30
> ohci_hcd 0000:00:02.0: auto-stop root hub
>  [<c01e8850>] ? reiserfs_fill_super+0x0/0xf60
>  [<c018a96a>] vfs_kern_mount+0x3a/0xa0
>  [<c018aa29>] do_kern_mount+0x39/0xd0
>  [<c01a0afb>] do_mount+0x3bb/0x7a0
>  [<c019ed6c>] ? copy_mount_options+0x3c/0x130
>  [<c01a0f69>] sys_mount+0x89/0xc0
>  [<c06fac5e>] mount_block_root+0xd1/0x25e
>  [<c0194397>] ? sys_mknod+0x27/0x30
>  [<c06fae44>] mount_root+0x59/0x5f
>  [<c06faf3a>] prepare_namespace+0xf0/0x16c
>  [<c0188320>] ? sys_access+0x20/0x30
>  [<c06fa503>] kernel_init+0xd0/0xe9
>  [<c06fa433>] ? kernel_init+0x0/0xe9
>  [<c0103677>] kernel_thread_helper+0x7/0x10
> ---[ end trace 98ddce1432d20cfb ]---
> VFS: Mounted root (reiserfs filesystem) readonly on device 8:1.

A number of people are reporting this.  Al Viro said

: Yeah, the sanity check had caught another place misusing lookup_one_len().
: I'd keep the warning in place for now; I think I know how to deal with
: reiserfs side of things, but if it turns out too invasive for post-rc3,
: we can always turn the check off just for -final.  For now I'd keep the
: check in place, just to see if anything else runs into it.

It would be nice to plug this sooner rather than later please, to save
a bit of bug-reporting bandwidth.

