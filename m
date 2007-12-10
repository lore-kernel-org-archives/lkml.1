Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbXLJPmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbXLJPmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXLJPme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:42:34 -0500
Received: from www.digitalsignage.messagenetsystems.com ([24.123.23.170]:51425
	"EHLO unifiedpaging.messagenetsystems.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbXLJPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:42:33 -0500
Message-ID: <475D5E5B.6000506@pagestation.com>
Date: Mon, 10 Dec 2007 10:42:19 -0500
From: Jerry Geis <geisj@pagestation.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Tarkan Erimer <tarkan@netone.net.tr>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Kernel BUG in 2.6.23.9
References: <475C46BC.5020101@pagestation.com>	<20071209134418.14c9f09d@laptopd505.fenrus.org>	<475D0387.1070609@netone.net.tr> <20071210064524.50d5b709@laptopd505.fenrus.org> <475D5D53.8070906@netone.net.tr>
In-Reply-To: <475D5D53.8070906@netone.net.tr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarkan Erimer wrote:
> Arjan van de Ven wrote:
>> well... try to get the oops message out; for many causes of crash 
>> that's a good way to find out what happened...
>> (not always, but it allows us to find patterns if nothing else)
>>
>>   
> Unfortunately, I couldn't get the oops message. Because when this 
> behavior happens, the machine hardly freezes and the SysRq 
> combinations do not work. Also, I checked the logs 
> (message,syslog,kern.log etc.) to see something suspicious. 
> Unfortunately, there was none. Just one thing I noticed  when 
> investigating on the logs: the kernel is doing its regular jobs. Like 
> cron etc. So, the kernel is not really dieing. Next time, I will try 
> to ssh to my machine to check what's going on, when this behavior 
> occurred.
>
I agree, the kernel is not completely dead. I could ping my box but 
nothing else.

This was the /var/log/messages I had:

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


