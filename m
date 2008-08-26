Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbYHZM7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbYHZM7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 08:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbYHZM7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 08:59:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:49347 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752983AbYHZM7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 08:59:09 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+T+7NiQeiTT3sDtLxNJPXNEunuoxRyOiRRlPKizM
	lUeIjOxXkBg6aX
Date: Tue, 26 Aug 2008 14:59:09 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: zippel@linux-m68k.org, linux-kernel@vger.kernel.org
Subject: [Patch] Fix another bug in hfsplus when reading a corrupted image
Message-ID: <20080826125909.GA21266@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.27-rc3 (x86_64)
X-Uptime: 14:53:58 up 7 days,  5:03,  4 users,  load average: 0.13, 0.44,
	0.37
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

another bug that popped up when testing hfsplus with corrupted images.

[  144.632017] BUG: unable to handle kernel NULL pointer dereference at 00000034
[  144.633047] IP: [<c0230c55>] hfsplus_find_init+0x24/0x5a
[  144.633047] *pde = 00000000
[  144.633047] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  144.633047] Modules linked in:
[  144.633047]
[  144.633047] Pid: 4845, comm: mount Not tainted (2.6.27-rc4-00131-g83097ac-dirty #32)
[  144.633047] EIP: 0060:[<c0230c55>] EFLAGS: 00010202 CPU: 0
[  144.633047] EIP is at hfsplus_find_init+0x24/0x5a
[  144.633047] EAX: 0000001d EBX: c6eaca84 ECX: c011bf0c EDX: 000000d0
[  144.633047] ESI: 00000000 EDI: c6eb810c EBP: c6eaca74 ESP: c6eaca60
[  144.633047]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  144.633047] Process mount (pid: 4845, ti=c6eac000 task=c6e80000 task.ti=c6eac000)
[  144.633047] Stack: c0801a93 00000000 c6eaca84 c6eaca84 c6eb8000 c6eacab4 c022c900 00000000
[  144.633047]        c022ce68 00000000 c6eb8004 00000000 00000000 22222222 22222222 22222222
[  144.633047]        22222222 22222222 00000000 c1098a40 c6eb8000 c6eacae0 c022ce72 c6eb82ac
[  144.633047] Call Trace:
[  144.633047]  [<c022c900>] ? hfsplus_ext_read_extent+0x47/0x12a
[  144.633047]  [<c022ce68>] ? hfsplus_get_block+0xb3/0x19d
[  144.633047]  [<c022ce72>] ? hfsplus_get_block+0xbd/0x19d
[  144.633047]  [<c01a042d>] ? block_read_full_page+0x172/0x2b4
[  144.633047]  [<c022cdb5>] ? hfsplus_get_block+0x0/0x19d
[  144.633047]  [<c0161899>] ? add_to_page_cache_locked+0xa9/0xc4
[  144.633047]  [<c0168922>] ? lru_cache_add+0x53/0x69
[  144.633047]  [<c022b737>] ? hfsplus_readpage+0xf/0x11
[  144.633047]  [<c0161ad5>] ? read_cache_page_async+0x79/0x108
[  144.633047]  [<c022b728>] ? hfsplus_readpage+0x0/0x11
[  144.633048]  [<c0162d59>] ? read_cache_page+0xc/0x3f
[  144.633048]  [<c022e85b>] ? hfsplus_btree_open+0x104/0x267
[  144.633048]  [<c022b04a>] ? hfsplus_fill_super+0x211/0x447
[  144.633048]  [<c013bca3>] ? trace_hardirqs_off_caller+0x14/0x9b
[  144.633048]  [<c013bd35>] ? trace_hardirqs_off+0xb/0xd
[  144.633048]  [<c0107aa3>] ? native_sched_clock+0x82/0x96
[  144.633048]  [<c013dc3a>] ? trace_hardirqs_on+0xb/0xd
[  144.633048]  [<c013dc3a>] ? trace_hardirqs_on+0xb/0xd
[  144.633048]  [<c013dbf4>] ? trace_hardirqs_on_caller+0xf4/0x12f
[  144.633048]  [<c013dc3a>] ? trace_hardirqs_on+0xb/0xd
[  144.633048]  [<c06aa5c6>] ? mutex_unlock+0x8/0xa
[  144.633048]  [<c01a28da>] ? do_open+0x20b/0x280
[  144.633048]  [<c01a29cc>] ? __blkdev_get+0x7d/0x88
[  144.633048]  [<c041c9c4>] ? string+0x2b/0x74
[  144.633048]  [<c041ccf6>] ? vsnprintf+0x2e9/0x512
[  144.633048]  [<c010487a>] ? dump_trace+0xca/0xd6
[  144.633048]  [<c0109eaf>] ? save_stack_trace+0x1c/0x3a
[  144.633048]  [<c0109eaf>] ? save_stack_trace+0x1c/0x3a
[  144.633048]  [<c013b571>] ? save_trace+0x37/0x8d
[  144.633048]  [<c013b62e>] ? add_lock_to_list+0x67/0x8d
[  144.633048]  [<c013ea1c>] ? validate_chain+0x8a4/0x9f4
[  144.633048]  [<c01354d3>] ? up+0xc/0x2f
[  144.633048]  [<c013f1f6>] ? __lock_acquire+0x68a/0x6e0
[  144.633048]  [<c013bd35>] ? trace_hardirqs_off+0xb/0xd
[  144.633048]  [<c013bca3>] ? trace_hardirqs_off_caller+0x14/0x9b
[  144.633048]  [<c013bd35>] ? trace_hardirqs_off+0xb/0xd
[  144.633048]  [<c0107aa3>] ? native_sched_clock+0x82/0x96
[  144.633048]  [<c041cf97>] ? snprintf+0x1b/0x1d
[  144.633048]  [<c01ba466>] ? disk_name+0x25/0x67
[  144.633048]  [<c0183960>] ? get_sb_bdev+0xcd/0x10b
[  144.633048]  [<c016ad92>] ? kstrdup+0x2a/0x4c
[  144.633048]  [<c022a7b3>] ? hfsplus_get_sb+0x13/0x15
[  144.633048]  [<c022ae39>] ? hfsplus_fill_super+0x0/0x447
[  144.633048]  [<c0183583>] ? vfs_kern_mount+0x3b/0x76
[  144.633048]  [<c0183602>] ? do_kern_mount+0x32/0xba
[  144.633048]  [<c01960d4>] ? do_new_mount+0x46/0x74
[  144.633048]  [<c0196277>] ? do_mount+0x175/0x193
[  144.633048]  [<c013dbf4>] ? trace_hardirqs_on_caller+0xf4/0x12f
[  144.633048]  [<c01663b2>] ? __get_free_pages+0x1e/0x24
[  144.633048]  [<c06ac09b>] ? lock_kernel+0x19/0x8c
[  144.633048]  [<c01962e6>] ? sys_mount+0x51/0x9b
[  144.633048]  [<c01962f9>] ? sys_mount+0x64/0x9b
[  144.633048]  [<c01038bd>] ? sysenter_do_call+0x12/0x31
[  144.633048]  =======================
[  144.633048] Code: 00 00 00 00 5b 5d c3 55 89 e5 56 89 c6 53 89 d3 52 50 68 93 1a 80 c0 e8 f2 24 ef ff
ba d0 00 00 00 89 73 08 c7 43 0c 00 00 00 00 <8b> 46 34 8d 44 00 04 e8 f9 e0 f4 ff ba f4 ff ff ff 83 c4 0
c 85
[  144.633048] EIP: [<c0230c55>] hfsplus_find_init+0x24/0x5a SS:ESP 0068:c6eaca60
[  144.659114] ---[ end trace 3e5c566484eaaae5 ]---


Problem is that there is no ext_tree, causing the NULL-pointer
dereference in hfsplus_init(). This fixes the issue by checking the ext_tree in
hfsplus_get_block() and aborting early enoug.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>


--- linux/fs/hfsplus/extents.orig	2008-08-26 14:51:08.000000000 +0200
+++ linux/fs/hfsplus/extents.c	2008-08-26 14:51:48.000000000 +0200
@@ -199,6 +199,9 @@ int hfsplus_get_block(struct inode *inod
 		goto done;
 	}
 
+	if (HFSPLUS_SB(inode->i_sb).ext_tree == NULL)
+		return -EIO;
+
 	mutex_lock(&HFSPLUS_I(inode).extents_lock);
 	res = hfsplus_ext_read_extent(inode, ablock);
 	if (!res) {
