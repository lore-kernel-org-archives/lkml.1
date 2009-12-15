Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbZLOEcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbZLOEcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZLOEcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:32:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61231 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbZLOEcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:32:43 -0500
Date: Mon, 14 Dec 2009 20:32:36 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Tim Blechmann <tim@klingt.org>
cc: LKML <linux-kernel@vger.kernel.org>, dieb13 <dieb13@klingt.org>,
       eparis@redhat.com
Subject: Re: WARNING: at fs/notify/inotify/inotify_fsnotify.c:129
In-Reply-To: <4B215C64.8050206@klingt.org>
Message-ID: <alpine.DEB.2.01.0912142025200.3483@bogon.housecafe.de>
References: <4B215C64.8050206@klingt.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19cSVLMv58a0KNcbl+hIQZ0CGTyXZ/Mun9h6Fg
 9Qu6PuQ3NnYjc9fehwRYxJoYr0GO4gEX+shRj3Dja+EKLeIL3r
 /gvUPIolsAnKNSDSCVwfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 at 21:39, Tim Blechmann wrote:
> Dec  9 00:37:37 es kernel: WARNING: at fs/notify/inotify/inotify_fsnotify.c:129 idr_callback+0x2a/0x4b()

I've got a similar message here too, with 2.6.32-rc8. However, I'm not 
sure how to reproduce this one...

@Eric, should we reopen #14090 or create a new bug?

Thanks,
Christian.

[0] http://bugzilla.kernel.org/show_bug.cgi?id=14090

------------[ cut here ]------------
WARNING: at /data/Scratch/scm/linux-2.6-git/fs/notify/inotify/inotify_fsnotify.c:129 idr_callback+0x36/0x60()
inotify closing but id=0 for entry=ffff88004f8a59a0 in group=ffff880003be0200 still in idr.  Probably leaking memory
Modules linked in: sit tunnel4 xfs sha256_generic aes_x86_64 aes_generic nfsd lockd auth_rpcgss sunrpc exportfs ipv6 tun jfs nls_base reiserfs fuse twofish_x86_64 twofish_common
Pid: 9740, comm: imap Not tainted 2.6.32-rc8 #4
Call Trace:
 [<ffffffff810ce906>] ? idr_callback+0x36/0x60
 [<ffffffff810ce906>] ? idr_callback+0x36/0x60
 [<ffffffff810352c9>] ? warn_slowpath_common+0x79/0xd0
 [<ffffffff81035381>] ? warn_slowpath_fmt+0x51/0x60
 [<ffffffff8120326c>] ? _spin_lock_irq+0xc/0x10
 [<ffffffff81200bcf>] ? wait_for_common+0x15f/0x1a0
 [<ffffffff8100e4b2>] ? check_events+0x12/0x20
 [<ffffffff810cd627>] ? fsnotify_flush_notify+0x97/0xc0
 [<ffffffff8100dd99>] ? xen_force_evtchn_callback+0x9/0x10
 [<ffffffff8100e4b2>] ? check_events+0x12/0x20
 [<ffffffff810ce906>] ? idr_callback+0x36/0x60
 [<ffffffff81138d04>] ? idr_for_each+0x84/0xe0
 [<ffffffff810ce8d0>] ? idr_callback+0x0/0x60
 [<ffffffff8100e49f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff81096a77>] ? kmem_cache_free+0x87/0xc0
 [<ffffffff810ce8ba>] ? inotify_free_group_priv+0x1a/0x30
 [<ffffffff810cd6cb>] ? fsnotify_final_destroy_group+0x1b/0x30
 [<ffffffff810ceb4c>] ? inotify_release+0x2c/0x50
 [<ffffffff8109e450>] ? __fput+0xc0/0x1f0
 [<ffffffff8109a9cb>] ? filp_close+0x5b/0x90
 [<ffffffff8109aab3>] ? sys_close+0xb3/0x120
 [<ffffffff81010d42>] ? system_call_fastpath+0x16/0x1b
---[ end trace 50bb54b8ed08a018 ]---
entry->group=(null) inode=(null) wd=4096

-- 
BOFH excuse #119:

evil hackers from Serbia.
