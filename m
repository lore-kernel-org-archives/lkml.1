Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbYHZRXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbYHZRXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbYHZRXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:23:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:58015 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755899AbYHZRXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:23:33 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19ZP3VvmdhZv6DnNTaJZJ2Q65IxJ2muC3PbB6ilg3
	x2GT4UlIM7k+3f
Date: Tue, 26 Aug 2008 19:23:32 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: zippel@linux-m68k.org, linux-kernel@vger.kernel.org
Subject: [Patch] Check hfs_bnode_find return value
Message-ID: <20080826172332.GA22058@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.27-rc3 (x86_64)
X-Uptime: 19:21:30 up 7 days,  9:30,  4 users,  load average: 1.58, 0.52,
	0.25
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

another bug triggered with a corrupted image, this time running fsx on
it. 

[ 8898.458022] BUG: unable to handle kernel paging request at fffffff8
[ 8898.458022] IP: [<c023028c>] hfs_bnode_split+0x216/0x280
[ 8898.458022] *pde = 00008067 *pte = 00000000
[ 8898.458022] Oops: 0002 [#1] PREEMPT DEBUG_PAGEALLOC
[ 8898.458022] Modules linked in:
[ 8898.458022]
[ 8898.458022] Pid: 30558, comm: fsx Not tainted (2.6.27-rc4-00131-g83097ac-dirty #33)
[ 8898.458022] EIP: 0060:[<c023028c>] EFLAGS: 00010246 CPU: 0
[ 8898.458022] EIP is at hfs_bnode_split+0x216/0x280
[ 8898.458022] EAX: 00000002 EBX: fffffff4 ECX: 00000000 EDX: c6b48be6
[ 8898.458022] ESI: c6ac25a0 EDI: c6ac26c0 EBP: c6b48c00 ESP: c6b48bc4
[ 8898.458022]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 8898.458022] Process fsx (pid: 30558, ti=c6b48000 task=c6a06700 task.ti=c6b48000)
[ 8898.458022] Stack: c6a93950 00000010 00000fd8 00000fb8 00000830 000007ac 00000000 00000822
[ 8898.458022]        00000fb8 00000200 01ff0000 00001000 00000fb8 c6ac26c0 00000fb6 c6b48c4c
[ 8898.458022]        c02303ca 000000f8 c6b48c68 c6b48e70 0000000f c6ac26c0 c6a93950 00000000
[ 8898.458022] Call Trace:
[ 8898.458022]  [<c02303ca>] ? hfsplus_brec_insert+0xd4/0x2bc
[ 8898.458022]  [<c022d7be>] ? hfsplus_create_cat+0x30c/0x38f
[ 8898.458022]  [<c013dc3a>] ? trace_hardirqs_on+0xb/0xd
[ 8898.458022]  [<c017cd20>] ? check_bytes_and_report+0x21/0x8f
[ 8898.458022]  [<c017d8a3>] ? __slab_alloc+0xb1/0x503
[ 8898.458022]  [<c017dfc5>] ? kmem_cache_alloc+0x4e/0xba
[ 8898.458022]  [<c06ade04>] ? sub_preempt_count+0x9d/0xab
[ 8898.458022]  [<c013dc3a>] ? trace_hardirqs_on+0xb/0xd
[ 8898.458022]  [<c06abe19>] ? _spin_unlock+0x27/0x3c
[ 8898.458022]  [<c019ad34>] ? __mark_inode_dirty+0x12f/0x137
[ 8898.458022]  [<c06ade04>] ? sub_preempt_count+0x9d/0xab
[ 8898.458022]  [<c06abe19>] ? _spin_unlock+0x27/0x3c
[ 8898.458022]  [<c022e3db>] ? hfsplus_create+0x35/0x7a
[ 8898.458022]  [<c01889ee>] ? vfs_create+0xa6/0x114
[ 8898.458022]  [<c018ac61>] ? do_filp_open+0x1ad/0x62f
[ 8898.458022]  [<c06abe19>] ? _spin_unlock+0x27/0x3c
[ 8898.458022]  [<c0193632>] ? alloc_fd+0xbf/0xc9
[ 8898.458022]  [<c06ade04>] ? sub_preempt_count+0x9d/0xab
[ 8898.458022]  [<c0193632>] ? alloc_fd+0xbf/0xc9
[ 8898.458022]  [<c0180249>] ? do_sys_open+0x42/0xb8
[ 8898.458022]  [<c0180301>] ? sys_open+0x1e/0x26
[ 8898.458022]  [<c01038bd>] ? sysenter_do_call+0x12/0x31
[ 8898.458022]  =======================
[ 8898.458022] Code: c2 89 f8 66 89 55 f0 8d 55 e6 e8 63 ed ff ff 8b 56 0c 83 c4 14 85 d2 74 3f 8b 45 c4 e8 f5 f1 ff ff 31 c9 8d 55 e6 89 c3 8b 46 08 <89> 43 04 89 d8 6a 0e e8 1d ee ff ff 8b 43 04 8d 55 e6 0f c8 31
[ 8898.458022] EIP: [<c023028c>] hfs_bnode_split+0x216/0x280 SS:ESP 0068:c6b48bc4
[ 8898.458022] ---[ end trace 552e26de6e943a04 ]---


Problem is caused by not checking and propagating the return
valie of hfs_bnode_find()

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>

--- linux/fs/hfsplus/brec.c.orig	2008-08-26 19:18:56.000000000 +0200
+++ linux/fs/hfsplus/brec.c	2008-08-26 19:19:27.000000000 +0200
@@ -304,6 +304,8 @@ static struct hfs_bnode *hfs_bnode_split
 	/* update next bnode header */
 	if (new_node->next) {
 		struct hfs_bnode *next_node = hfs_bnode_find(tree, new_node->next);
+		if (IS_ERR(next_node))
+			return next_node;
 		next_node->prev = new_node->this;
 		hfs_bnode_read(next_node, &node_desc, 0, sizeof(node_desc));
 		node_desc.prev = cpu_to_be32(next_node->prev);
