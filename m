Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbXLIUBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbXLIUBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 15:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXLIUBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 15:01:14 -0500
Received: from www.digitalsignage.messagenetsystems.com ([24.123.23.170]:35501
	"EHLO unifiedpaging.messagenetsystems.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbXLIUBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 15:01:12 -0500
X-Greylist: delayed 710 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 15:01:12 EST
Message-ID: <475C46BC.5020101@pagestation.com>
Date: Sun, 09 Dec 2007 14:49:16 -0500
From: Jerry Geis <geisj@pagestation.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel BUG in 2.6.23.9
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using centos 5.1, 2.6.23.9 kernel. Machine works great all day. Then sometime through the night the kernel dies,
the trace is below.

My machine is an AMD 6400+ X2, seagate 500G SATA, Nvidia 7100, 4 GIG RAM.
---------------------------
Linux version 2.6.23.9 (root@devcentos5x64.msgnet.com) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)) #1 SMP Mon Dec 3 10:20:13 EST 2007


If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux devcentos5x64.msgnet.com 2.6.23.9 #1 SMP Mon Dec 3 10:20:13 EST 2007 x86_64 x86_64 x86_64 GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50.0.6-5.el5
util-linux             2.13-pre7
mount                  2.13-pre7
module-init-tools      3.3-pre2
e2fsprogs              1.39
pcmciautils            014
quota-tools            3.13.
PPP                    2.4.4
isdn4k-utils           3.9
Linux C Library        2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.2
Sh-utils               5.97
udev                   095
wireless-tools         28
Modules Loaded         zttranscode nfsd exportfs lockd nfs_acl auth_rpcgss autofs4 hidp rfcomm l2cap bluetooth sunrpc wcusb wctdm wcfxo wcte11xp wct1xxp wcte12xp wct4xxp tor2 nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables cpufreq_ondemand dm_mirror dm_multipath dm_mod video output sbs battery ac ipv6 lp shpchp snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc nvidia sr_mod wctdm24xxp i2c_nforce2 i2c_core cdrom zaptel crc_ccitt forcedeth usb_storage button sg parport_pc parport serio_raw sata_nv libata sd_mod scsi_mod raid1 ext3 jbd ehci_hcd ohci_hcd uhci_hcd
[root@devcentos5x64 linux-2.6.23.9]# 



Dec  8 22:23:57 devcentos5x64 kernel: Assertion failure in journal_dirty_data() at fs/jbd/transaction.c:983: "jh->b_transaction == journal->j_committing_transaction"
Dec  8 22:23:57 devcentos5x64 kernel: ------------[ cut here ]------------
Dec  8 22:23:57 devcentos5x64 kernel: kernel BUG at fs/jbd/transaction.c:983!
Dec  8 22:23:57 devcentos5x64 kernel: invalid opcode: 0000 [1] SMP 
Dec  8 22:23:57 devcentos5x64 kernel: CPU 1 
Dec  8 22:23:57 devcentos5x64 kernel: Modules linked in: zttranscode nfsd exportfs lockd nfs_acl auth_rpcgss autofs4 hidp rfcomm l2cap bluetooth sunrpc wcusb wctdm wcfxo wcte11xp wct1xxp wcte12xp wct4xxp tor2 nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables cpufreq_ondemand dm_mirror dm_multipath dm_mod video output sbs battery ac ipv6 lp shpchp snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm nvidia(P) snd_timer wctdm24xxp snd zaptel soundcore sr_mod forcedeth sg parport_pc snd_page_alloc crc_ccitt serio_raw cdrom parport i2c_nforce2 usb_storage i2c_core button sata_nv libata sd_mod scsi_mod raid1 ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Dec  8 22:23:57 devcentos5x64 kernel: Pid: 5028, comm: rsync Tainted: P        2.6.23.9 #1
Dec  8 22:23:57 devcentos5x64 kernel: RIP: 0010:[<ffffffff88034a3b>]  [<ffffffff88034a3b>] :jbd:journal_dirty_data+0xad/0x1ed
Dec  8 22:23:57 devcentos5x64 kernel: RSP: 0018:ffff810095edd7e8  EFLAGS: 00010292
Dec  8 22:23:57 devcentos5x64 kernel: RAX: 0000000000000083 RBX: ffff81008e1f50c8 RCX: ffffffff81344c28
Dec  8 22:23:57 devcentos5x64 kernel: RDX: 0000000100000000 RSI: 0000000000000096 RDI: ffffffff81344c20
Dec  8 22:23:57 devcentos5x64 kernel: RBP: ffff81009b42fdf4 R08: ffffffff81344c28 R09: 00000002ffffffff
Dec  8 22:23:57 devcentos5x64 kernel: R10: 0000000000000046 R11: ffffffff813b8000 R12: ffff8100c082b348
Dec  8 22:23:58 devcentos5x64 kernel: R13: ffff81010ce3cc00 R14: 0000000000000000 R15: 0000000000000000
Dec  8 22:23:58 devcentos5x64 kernel: FS:  00002ae6d4b2b560(0000) GS:ffff81011fa9a6c0(0000) knlGS:00000000f7f009a0
Dec  8 22:23:58 devcentos5x64 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec  8 22:23:58 devcentos5x64 kernel: CR2: 00002aea6b0d30a8 CR3: 00000000959f0000 CR4: 00000000000006e0
Dec  8 22:23:58 devcentos5x64 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  8 22:23:58 devcentos5x64 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec  8 22:23:58 devcentos5x64 kernel: Process rsync (pid: 5028, threadinfo ffff810095edc000, task ffff8100ccc78000)
Dec  8 22:23:58 devcentos5x64 kernel: Stack:  0000000000001000 ffff8100c082b348 ffff81008e1f50c8 ffff81008e1f50c8
Dec  8 22:23:58 devcentos5x64 kernel:  ffff81008e1f50c8 ffffffff8804ff8f 0000000000001000 0000000000001000
Dec  8 22:23:58 devcentos5x64 kernel:  0000000000001000 ffffffff8804f437 ffffffff8804ffb4 0000000000001000
Dec  8 22:23:58 devcentos5x64 kernel: Call Trace:
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8804ff8f>] :ext3:ext3_journal_dirty_data+0xf/0x34
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8804f437>] :ext3:walk_page_buffers+0x65/0x8b
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8804ffb4>] :ext3:journal_dirty_data_fn+0x0/0xe
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff880521da>] :ext3:ext3_ordered_writepage+0x108/0x18c
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8106bf9a>] __writepage+0xa/0x23
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8106c4b8>] write_cache_pages+0x17b/0x2aa
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8106bf90>] __writepage+0x0/0x23
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8106c62a>] do_writepages+0x27/0x2d
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff810a8749>] __writeback_single_inode+0x1ba/0x332
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8805b7ea>] :ext3:__ext3_journal_dirty_metadata+0x1e/0x46
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff810a8c00>] sync_sb_inodes+0x1a3/0x261
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff810a9030>] writeback_inodes+0x82/0xd8
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8106c869>] balance_dirty_pages_ratelimited_nr+0x114/0x1f4
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff81068168>] generic_file_buffered_write+0x62d/0x751
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff810685c8>] __generic_file_aio_write_nolock+0x33c/0x3a6
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff811ec26b>] sock_aio_read+0x10c/0x124
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff81068693>] generic_file_aio_write+0x61/0xc1
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8804e1ae>] :ext3:ext3_file_write+0x16/0x94
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8108d950>] do_sync_write+0xc9/0x10c
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8104912d>] autoremove_wake_function+0x0/0x2e
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8108e118>] vfs_write+0xce/0x157
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8108e676>] sys_write+0x45/0x6e
Dec  8 22:23:58 devcentos5x64 kernel:  [<ffffffff8100bdfc>] tracesys+0xdc/0xe1
Dec  8 22:23:58 devcentos5x64 kernel: 
Dec  8 22:23:58 devcentos5x64 kernel: 
Dec  8 22:23:58 devcentos5x64 kernel: Code: 0f 0b eb fe 8b 45 0c 83 f8 01 76 09 83 f8 08 0f 85 eb 00 00 
Dec  8 22:23:58 devcentos5x64 kernel: RIP  [<ffffffff88034a3b>] :jbd:journal_dirty_data+0xad/0x1ed
Dec  8 22:23:58 devcentos5x64 kernel:  RSP <ffff810095edd7e8>

