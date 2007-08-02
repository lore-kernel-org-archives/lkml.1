Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbXHBTlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbXHBTlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXHBTk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:40:56 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:21075 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754127AbXHBTkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:40:55 -0400
Message-ID: <46B2332F.8000400@interia.pl>
Date: Thu, 02 Aug 2007 21:40:31 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: JFFS2 BUG
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-EMID: 47bcacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can't find JFFS2 maintainer so I'm sending it to MTD 
maintainer. I don't have luck in this week :-(

Linux: 2.6.23-rc1-git3 (2.6.22.1 patched - that's why version is wrong)
Command which caused BUG(): chmod o+r *

ezri user.warn kernel: argh. node added in wrong place
ezri user.alert kernel: BUG: unable to handle kernel paging request at virtual address ffffffee
ezri user.alert kernel:  printing eip:
ezri user.warn kernel: c68375f4
ezri user.alert kernel: *pde = 00016067
ezri user.alert kernel: *pte = 00000000
ezri user.emerg kernel: Oops: 0000 [#1]
ezri user.warn kernel: Modules linked in: jffs2 mtdsuper block2mtd mtdpart mtdcore
ezri user.emerg kernel: CPU:    0
ezri user.emerg kernel: EIP:    0060:[<c68375f4>]    Not tainted VLI
ezri user.emerg kernel: EFLAGS: 00210246   (2.6.22.1 #6)
ezri user.emerg kernel: EIP is at jffs2_read_dnode+0x2c/0x2ee [jffs2]
ezri user.emerg kernel: eax: ffffffea   ebx: c200a000   ecx: 00000000   edx: c1040140
ezri user.emerg kernel: esi: c0d28990   edi: c0a41000   ebp: c0cde7b0   esp: c1a4dc70
ezri user.emerg kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
ezri user.emerg kernel: Process vsftpd (pid: 1324, ti=c1a4c000 task=c16da580 task.ti=c1a4c000)
ezri user.emerg kernel: Stack: 0000000c c1a4dcd8 c268ef9c c683f360 00000000 c056ed20 c5244600 00000000 
ezri user.emerg kernel:        fffffff4 0000000c 00000000 00010000 c0a41000 c0cde7b0 c68379b8 c0a41000 
ezri user.emerg kernel:        00001000 00000000 c6837d9f c0a41000 c056ed20 c5244600 00011000 00001000 
ezri user.emerg kernel: Call Trace:
ezri user.emerg kernel:  [<c683f360>] jffs2_flash_direct_write+0x22/0x2a [jffs2]
ezri user.emerg kernel:  [<c68379b8>] jffs2_read_inode_range+0x102/0x146 [jffs2]
ezri user.emerg kernel:  [<c6837d9f>] jffs2_mark_node_obsolete+0x353/0x40f [jffs2]
ezri user.emerg kernel:  [<c010fefc>] update_curr+0x232/0x253
ezri user.emerg kernel:  [<c68364b8>] jffs2_do_readpage_nolock+0x54/0x72 [jffs2]
ezri user.emerg kernel:  [<c6836930>] jffs2_prepare_write+0x24c/0x274 [jffs2]
ezri user.emerg kernel:  [<c0130e7a>] __alloc_pages+0x63/0x292
ezri user.emerg kernel:  [<c01f237b>] skb_copy_datagram_iovec+0x54/0x1d0
ezri user.emerg kernel:  [<c012e59f>] generic_file_buffered_write+0x260/0x5ba
ezri user.emerg kernel:  [<c01ed934>] release_sock+0xc/0x74
ezri user.emerg kernel:  [<c021fb65>] tcp_prequeue_process+0x4e/0x5b
ezri user.emerg kernel:  [<c012ed2d>] __generic_file_aio_write_nolock+0x434/0x482
ezri user.emerg kernel:  [<c01eb6df>] sock_aio_read+0xc0/0xc8
ezri user.emerg kernel:  [<c012edd9>] generic_file_aio_write+0x5e/0xbf
ezri user.emerg kernel:  [<c0142c67>] do_sync_write+0xc6/0x109
ezri user.emerg kernel:  [<c0120836>] autoremove_wake_function+0x0/0x33
ezri user.emerg kernel:  [<c0122741>] enqueue_hrtimer+0x5a/0x62
ezri user.emerg kernel:  [<c0142ba1>] do_sync_write+0x0/0x109
ezri user.emerg kernel:  [<c01433da>] vfs_write+0x8a/0x112
ezri user.emerg kernel:  [<c0143864>] sys_write+0x41/0x67
ezri user.emerg kernel:  [<c0103bd2>] syscall_call+0x7/0xb
ezri user.emerg kernel:  [<c0260000>] sctp_datamsg_from_user+0x297/0x2a7
ezri user.emerg kernel:  =======================
ezri user.emerg kernel: Code: 57 56 53 83 ec 28 89 ce 89 44 24 18 89 54 24 14 e8 47 ff ff ff 89 c3 c7 44 24 20 f4 ff ff ff 85 c0 0f 84 ba 02 00 00 8b 06 31 c9 <8b> 50 04 8d 44 24 24 83 e2 fc 89 44 24 04 8b 44 24 18 89 5c 24 
ezri user.emerg kernel: EIP: [<c68375f4>] jffs2_read_dnode+0x2c/0x2ee [jffs2] SS:ESP 0068:c1a4dc70
ezri user.warn kernel: Node totlen on flash (0x00001044) != totlen from node ref (0x00000044)
ezri user.warn kernel: argh. node added in wrong place
ezri user.alert kernel: BUG: unable to handle kernel paging request at virtual address ffffffee
ezri user.alert kernel:  printing eip:
ezri user.warn kernel: c6837a6c
ezri user.alert kernel: *pde = 00016067
ezri user.alert kernel: *pte = 00000000
ezri user.emerg kernel: Oops: 0000 [#2]
ezri user.warn kernel: Modules linked in: jffs2 mtdsuper block2mtd mtdpart mtdcore
ezri user.emerg kernel: CPU:    0
ezri user.emerg kernel: EIP:    0060:[<c6837a6c>]    Tainted: G      D VLI
ezri user.emerg kernel: EFLAGS: 00210282   (2.6.22.1 #6)
ezri user.emerg kernel: EIP is at jffs2_mark_node_obsolete+0x20/0x40f [jffs2]
ezri user.emerg kernel: eax: c5244600   ebx: 00000000   ecx: 00000000   edx: ffffffea
ezri user.emerg kernel: esi: c5244600   edi: c200a048   ebp: ffffffea   esp: c277fce4
ezri user.emerg kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
ezri user.emerg kernel: Process vsftpd (pid: 1327, ti=c277e000 task=c16db080 task.ti=c277e000)
ezri user.emerg kernel: Stack: c15133b0 00000000 c38e2450 c1de43f0 c68372c0 c15133b0 c5244600 c1de4404 
ezri user.emerg kernel:        00000000 c1de43f0 c200a048 c15133b0 c683a7d1 c0cd2800 00000327 00000003 
ezri user.emerg kernel:        00000000 c5244600 00000000 00000000 00000327 00000582 0000e958 c0cd2800 
ezri user.emerg kernel: Call Trace:
ezri user.emerg kernel:  [<c68372c0>] jffs2_add_full_dnode_to_inode+0x2a7/0x2d4 [jffs2]
ezri user.emerg kernel:  [<c683a7d1>] jffs2_write_inode_range+0x1dd/0x279 [jffs2]
ezri user.emerg kernel:  [<c68365e4>] jffs2_commit_write+0xdd/0x1a3 [jffs2]
ezri user.emerg kernel:  [<c012e73b>] generic_file_buffered_write+0x3fc/0x5ba
ezri user.emerg kernel:  [<c021fc45>] tcp_cleanup_rbuf+0xd3/0xf3
ezri user.emerg kernel:  [<c01ed934>] release_sock+0xc/0x74
ezri user.emerg kernel:  [<c021fb65>] tcp_prequeue_process+0x4e/0x5b
ezri user.emerg kernel:  [<c015832e>] __mark_inode_dirty+0x24/0x137
ezri user.emerg kernel:  [<c012ed2d>] __generic_file_aio_write_nolock+0x434/0x482
ezri user.emerg kernel:  [<c01eb6df>] sock_aio_read+0xc0/0xc8
ezri user.emerg kernel:  [<c012edd9>] generic_file_aio_write+0x5e/0xbf
ezri user.emerg kernel:  [<c0142c67>] do_sync_write+0xc6/0x109
ezri user.emerg kernel:  [<c0120836>] autoremove_wake_function+0x0/0x33
ezri user.emerg kernel:  [<c0122741>] enqueue_hrtimer+0x5a/0x62
ezri user.emerg kernel:  [<c0142ba1>] do_sync_write+0x0/0x109
ezri user.emerg kernel:  [<c01433da>] vfs_write+0x8a/0x112
ezri user.emerg kernel:  [<c0143864>] sys_write+0x41/0x67
ezri user.emerg kernel:  [<c0103bd2>] syscall_call+0x7/0xb
ezri user.emerg kernel:  [<c0260000>] sctp_datamsg_from_user+0x297/0x2a7
ezri user.emerg kernel:  =======================
ezri user.emerg kernel: Code: 0f b6 f0 89 f0 5a 5b 5e 5f 5d c3 55 57 56 53 83 ec 20 89 c6 89 d5 85 d2 75 11 c7 04 24 00 1d 84 c6 e8 94 c3 8d f9 e9 e7 03 00 00 <8b> 4a 04 89 c8 83 e0 03 48 0f 84 d8 03 00 00 31 d2 89 c8 f7 76 
ezri user.emerg kernel: EIP: [<c6837a6c>] jffs2_mark_node_obsolete+0x20/0x40f [jffs2] SS:ESP 0068:c277fce4
ezri user.warn kernel: argh. node added in wrong place
ezri user.alert kernel: BUG: unable to handle kernel paging request at virtual address ffffffee
ezri user.alert kernel:  printing eip:
ezri user.warn kernel: c6837a6c
ezri user.alert kernel: *pde = 00016067
ezri user.alert kernel: *pte = 00000000
ezri user.emerg kernel: Oops: 0000 [#3]
ezri user.warn kernel: Modules linked in: jffs2 mtdsuper block2mtd mtdpart mtdcore
ezri user.emerg kernel: CPU:    0
ezri user.emerg kernel: EIP:    0060:[<c6837a6c>]    Tainted: G      D VLI
ezri user.emerg kernel: EFLAGS: 00210282   (2.6.22.1 #6)
ezri user.emerg kernel: EIP is at jffs2_mark_node_obsolete+0x20/0x40f [jffs2]
ezri user.emerg kernel: eax: c5244600   ebx: 00000000   ecx: 00000000   edx: ffffffea
ezri user.emerg kernel: esi: c5244600   edi: c200a0d8   ebp: ffffffea   esp: c4b4dce4
ezri user.emerg kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
ezri user.emerg kernel: Process vsftpd (pid: 1335, ti=c4b4c000 task=c16da000 task.ti=c4b4c000)
ezri user.emerg kernel: Stack: c3706320 00000000 c1eb3b70 c2ee9930 c68372c0 c3706320 c5244600 c2ee9944 
ezri user.emerg kernel:        00000000 c2ee9930 c200a0d8 c3706320 c683a7d1 c3d1f000 00000327 00000003 
ezri user.emerg kernel:        00000000 c5244600 00000000 00000000 00000327 00000582 0000928c c3d1f000 
ezri user.emerg kernel: Call Trace:
ezri user.emerg kernel:  [<c68372c0>] jffs2_add_full_dnode_to_inode+0x2a7/0x2d4 [jffs2]
ezri user.emerg kernel:  [<c683a7d1>] jffs2_write_inode_range+0x1dd/0x279 [jffs2]
ezri user.emerg kernel:  [<c68365e4>] jffs2_commit_write+0xdd/0x1a3 [jffs2]
ezri user.emerg kernel:  [<c012e73b>] generic_file_buffered_write+0x3fc/0x5ba
ezri user.emerg kernel:  [<c021fc45>] tcp_cleanup_rbuf+0xd3/0xf3
ezri user.emerg kernel:  [<c01ed934>] release_sock+0xc/0x74
ezri user.emerg kernel:  [<c021fb65>] tcp_prequeue_process+0x4e/0x5b
ezri user.emerg kernel:  [<c015832e>] __mark_inode_dirty+0x24/0x137
ezri user.emerg kernel:  [<c012ed2d>] __generic_file_aio_write_nolock+0x434/0x482
ezri user.emerg kernel:  [<c01eb6df>] sock_aio_read+0xc0/0xc8
ezri user.emerg kernel:  [<c012edd9>] generic_file_aio_write+0x5e/0xbf
ezri user.emerg kernel:  [<c0142c67>] do_sync_write+0xc6/0x109
ezri user.emerg kernel:  [<c0120836>] autoremove_wake_function+0x0/0x33
ezri user.emerg kernel:  [<c0122741>] enqueue_hrtimer+0x5a/0x62
ezri user.emerg kernel:  [<c0142ba1>] do_sync_write+0x0/0x109
ezri user.emerg kernel:  [<c01433da>] vfs_write+0x8a/0x112
ezri user.emerg kernel:  [<c0143864>] sys_write+0x41/0x67
ezri user.emerg kernel:  [<c0103bd2>] syscall_call+0x7/0xb
ezri user.emerg kernel:  [<c0260000>] sctp_datamsg_from_user+0x297/0x2a7
ezri user.emerg kernel:  =======================
ezri user.emerg kernel: Code: 0f b6 f0 89 f0 5a 5b 5e 5f 5d c3 55 57 56 53 83 ec 20 89 c6 89 d5 85 d2 75 11 c7 04 24 00 1d 84 c6 e8 94 c3 8d f9 e9 e7 03 00 00 <8b> 4a 04 89 c8 83 e0 03 48 0f 84 d8 03 00 00 31 d2 89 c8 f7 76 

----------------------------------------------------------------------
Kobiety klamia o wiele skuteczniej niz mezczyzni.
Sprawdz, jak sie na nich poznac

>>>http://link.interia.pl/f1b16

