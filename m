Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbZFSSPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbZFSSPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZFSSPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:15:08 -0400
Received: from [212.98.175.89] ([212.98.175.89]:48441 "EHLO localdomain.by"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752619AbZFSSPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:15:00 -0400
Date: Fri, 19 Jun 2009 21:15:29 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: BUG: scheduling while atomic
Message-ID: <20090619181529.GA3593@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.
I see lots of "BUG: scheduling while atomic" with current kernels (started with 2.6.30-git1, 2.6.30 is ok).
For example (2.6.30-git14):

kernel: [27404.945372] BUG: scheduling while atomic: pptpgw/4637/0x00000400
kernel: [27404.945378] INFO: lockdep is turned off.
kernel: [27404.945383] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse sbp2 loop snd_hda_codec_si3054 snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_pcm snd_seq_mi
di snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device pcspkr snd i2c_i801 psmouse serio_raw rng_core soundcore snd_page_alloc asus_laptop evdev usbhid hid sg sr_mod
cdrom sd_mod sdhci_pci sdhci mmc_co
re ohci1394 ata_generic pata_acpi ricoh_mmc uhci_hcd led_class ata_piix ieee1394 ide_pci_generic ehci_hcd usbcore r8169 mii
kernel: [27404.945532] 
kernel: [27404.945540] Pid: 4637, comm: pptpgw Not tainted (2.6.30-dbgnv-git14 #4) F3JC                
kernel: [27404.945549] EIP: 0060:[<c104a3d5>] EFLAGS: 00200246 CPU: 0
kernel: [27404.945559] EIP is at __tasklet_schedule+0x65/0xb0
kernel: [27404.945566] EAX: 00000000 EBX: f6077c6c ECX: 00000000 EDX: 00000000
kernel: [27404.945573] ESI: 00200246 EDI: 00000001 EBP: e2807e60 ESP: e2807e54
kernel: [27404.945581]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
kernel: [27404.945589] CR0: 8005003b CR2: b5f027ac CR3: 35993000 CR4: 000006d0
kernel: [27404.945596] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
kernel: [27404.945603] DR6: ffff0ff0 DR7: 00000400
kernel: [27404.945609] Call Trace:
kernel: [27404.945621]  [<f90be38b>] ppp_asynctty_wakeup+0x6b/0x80 [ppp_async]
kernel: [27404.945632]  [<c12de902>] tty_wakeup+0x72/0x90
kernel: [27404.945643]  [<c12e70d3>] pty_unthrottle+0x23/0x50
kernel: [27404.945653]  [<c12e3b22>] tty_unthrottle+0x42/0x70
kernel: [27404.945663]  [<c12e1c2f>] n_tty_read+0x48f/0x730
kernel: [27404.945676]  [<c103e150>] ? default_wake_function+0x0/0x40
kernel: [27404.945688]  [<c12dcc20>] tty_read+0xa0/0xe0
kernel: [27404.945698]  [<c12e17a0>] ? n_tty_read+0x0/0x730
kernel: [27404.945709]  [<c10faf2b>] vfs_read+0xbb/0x1c0
kernel: [27404.945720]  [<c12dcb80>] ? tty_read+0x0/0xe0
kernel: [27404.945730]  [<c10fb138>] sys_read+0x58/0xa0
kernel: [27404.945741]  [<c100325b>] sysenter_do_call+0x12/0x32

/USR/SBIN/CRON[10140]: CMD (fetchmail -sk -m '/usr/bin/procmail' > /dev/null 2>&1)

kernel: [27729.047046] BUG: spinlock lockup on CPU#1, pppd/4636, f5928dc0
kernel: [27729.047060] Pid: 4636, comm: pppd Not tainted 2.6.30-dbgnv-git14 #4
kernel: [27729.047067] Call Trace:
kernel: [27729.047084]  [<c141786b>] ? printk+0x23/0x36
kernel: [27729.047099]  [<c125da29>] _raw_spin_lock+0x159/0x170
kernel: [27729.047111]  [<c141b7f2>] _spin_lock_bh+0x62/0x90
kernel: [27729.047130]  [<f90aabe7>] ? ppp_channel_push+0x27/0xd0 [ppp_generic]
kernel: [27729.047145]  [<f90aabe7>] ppp_channel_push+0x27/0xd0 [ppp_generic]
kernel: [27729.047159]  [<f90aad67>] ppp_write+0xd7/0xe0 [ppp_generic]
kernel: [27729.047172]  [<c10fac1e>] vfs_write+0xbe/0x1c0
kernel: [27729.047186]  [<f90aac90>] ? ppp_write+0x0/0xe0 [ppp_generic]
kernel: [27729.047197]  [<c10fae28>] sys_write+0x58/0xa0
kernel: [27729.047209]  [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [27787.880283] SysRq : Keyboard mode set to system default

//Truncated. See attachment for details.

Hardware: ASUS F3Jc

Reported: http://bugzilla.kernel.org/show_bug.cgi?id=13522


Thanks,
	Sergey

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=syslog_bug_3

kernel: 4.187392]    [<c1195001>] ext3_truncate+0x8a1/0x990
kernel: [26234.187392]    [<c10dd250>] vmtruncate+0xe0/0x1a0
kernel: [26234.187392]    [<c1111e3f>] inode_setattr+0x6f/0x1b0
kernel: [26234.187392]    [<c1191991>] ext3_setattr+0x151/0x210
kernel: [26234.187392]    [<c11120ef>] notify_change+0x16f/0x370
kernel: [26234.187392]    [<c10f8de4>] do_truncate+0x74/0xb0
kernel: [26234.187392]    [<c1105bdd>] may_open+0x23d/0x2c0
kernel: [26234.187392]    [<c11082ab>] do_filp_open+0x1cb/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]     ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10fe532>] inode_sub_bytes+0x32/0xc0
kernel: [26234.187392]    [<c118d38d>] ext3_free_blocks+0x7d/0xf0
kernel: [26234.187392]    [<c11942ec>] ext3_clear_blocks+0x14c/0x180
kernel: [26234.187392]    [<c1194468>] ext3_free_data+0x148/0x1a0
kernel: [26234.187392]    [<c1195001>] ext3_truncate+0x8a1/0x990
kernel: [26234.187392]    [<c10dd250>] vmtruncate+0xe0/0x1a0
kernel: [26234.187392]    [<c1111e3f>] inode_setattr+0x6f/0x1b0
kernel: [26234.187392]    [<c1191991>] ext3_setattr+0x151/0x210
kernel: [26234.187392]    [<c11120ef>] notify_change+0x16f/0x370
kernel: [26234.187392]    [<c10f8de4>] do_truncate+0x74/0xb0
kernel: [26234.187392]    [<c1105bdd>] may_open+0x23d/0x2c0
kernel: [26234.187392]    [<c11082ab>] do_filp_open+0x1cb/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]     ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]    [<c10cd76a>] activate_page+0x3a/0x130
kernel: [26234.187392]    [<c10cd8b1>] mark_page_accessed+0x51/0x60
kernel: [26234.187392]    [<c1121b7c>] __find_get_block+0xbc/0x1d0
kernel: [26234.187392]    [<c1121cc3>] __getblk+0x33/0x390
kernel: [26234.187392]    [<c118cd07>] read_block_bitmap+0x47/0x1a0
kernel: [26234.187392]    [<c118de2c>] ext3_new_blocks+0x2cc/0x770
kernel: [26234.187392]    [<c1193546>] ext3_get_blocks_handle+0x2e6/0xa60
kernel: [26234.187392]    [<c1193d4b>] ext3_get_block+0x8b/0x140
kernel: [26234.187392]    [<c1123a94>] __block_prepare_write+0x1a4/0x440
kernel: [26234.187392]    [<c1123f44>] block_write_begin+0x84/0x140
kernel: [26234.187392]    [<c1192f53>] ext3_write_begin+0x133/0x2b0
kernel: [26234.187392]    [<c10c457b>] generic_file_buffered_write+0x13b/0x360
kernel: [26234.187392]    [<c10c4cc4>] __generic_file_aio_write_nolock+0x244/0x5c0
kernel: [26234.187392]    [<c10c5507>] generic_file_aio_write+0x77/0x100
kernel: [26234.187392]    [<c118f16b>] ext3_file_write+0x3b/0xe0
kernel: [26234.187392]    [<c10f9e2a>] do_sync_write+0xea/0x140
kernel: [26234.187392]    [<c10fac1e>] vfs_write+0xbe/0x1c0
kernel: [26234.187392]    [<c10fae28>] sys_write+0x58/0xa0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]     -> (&sbi->s_rsv_window_lock){+.+...} ops: 0 {
kernel: [26234.187392]        HARDIRQ-ON-W at:
kernel: [26234.187392]                                                [<c1077409>] __lock_acquire+0xaa9/0x1840
kernel: [26234.187392]                                                [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                                [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                                [<c118d872>] ext3_try_to_allocate_with_rsv+0x1e2/0x4d0
kernel: [26234.187392]                                                [<c118de76>] ext3_new_blocks+0x316/0x770
kernel: [26234.187392]                                                [<c1193546>] ext3_get_blocks_handle+0x2e6/0xa60
kernel: [26234.187392]                                                [<c1193d4b>] ext3_get_block+0x8b/0x140
kernel: [26234.187392]                                                [<c1123a94>] __block_prepare_write+0x1a4/0x440
kernel: [26234.187392]                                                [<c1123f44>] block_write_begin+0x84/0x140
kernel: [26234.187392]                                                [<c1192f53>] ext3_write_begin+0x133/0x2b0
kernel: [26234.187392]                                                [<c10c457b>] generic_file_buffered_write+0x13b/0x360
kernel: [26234.187392]                                                [<c10c4cc4>] __generic_file_aio_write_nolock+0x244/0x5c0
kernel: [26234.187392]                                                [<c10c5507>] generic_file_aio_write+0x77/0x100
kernel: [26234.187392]                                                [<c118f16b>] ext3_file_write+0x3b/0xe0
kernel: [26234.187392]                                                [<c10f9e2a>] do_sync_write+0xea/0x140
kernel: [26234.187392]                                                [<c10fac1e>] vfs_write+0xbe/0x1c0
kernel: [26234.187392]                                                [<c10fae28>] sys_write+0x58/0xa0
kernel: [26234.187392]                                                [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                                [<ffffffff>] 0xffffffff
kernel: [26234.187392]        SOFTIRQ-ON-W at:
kernel: [26234.187392]                                                [<c107742f>] __lock_acquire+0xacf/0x1840
kernel: [26234.187392]                                                [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                                [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                                [<c118d872>] ext3_try_to_allocate_with_rsv+0x1e2/0x4d0
kernel: [26234.187392]                                                [<c118de76>] ext3_new_blocks+0x316/0x770
kernel: [26234.187392]                                                [<c1193546>] ext3_get_blocks_handle+0x2e6/0xa60
kernel: [26234.187392]                                                [<c1193d4b>] ext3_get_block+0x8b/0x140
kernel: [26234.187392]                                                [<c1123a94>] __block_prepare_write+0x1a4/0x440
kernel: [26234.187392]                                                [<c1123f44>] block_write_begin+0x84/0x140
kernel: [26234.187392]                                                [<c1192f53>] ext3_write_begin+0x133/0x2b0
kernel: [26234.187392]                                                [<c10c457b>] generic_file_buffered_write+0x13b/0x360
kernel: [26234.187392]                                                [<c10c4cc4>] __generic_file_aio_write_nolock+0x244/0x5c0
kernel: [26234.187392]                                                [<c10c5507>] generic_file_aio_write+0x77/0x100
kernel: [26234.187392]                                                [<c118f16b>] ext3_file_write+0x3b/0xe0
kernel: [26234.187392]                                                [<c10f9e2a>] do_sync_write+0xea/0x140
kernel: [26234.187392]                                                [<c10fac1e>] vfs_write+0xbe/0x1c0
kernel: [26234.187392]                                                [<c10fae28>] sys_write+0x58/0xa0
kernel: [26234.187392]                                                [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                                [<ffffffff>] 0xffffffff
kernel: [26234.187392]        INITIAL USE at:
kernel: [26234.187392]                                               [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                               [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                               [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                               [<c118d872>] ext3_try_to_allocate_with_rsv+0x1e2/0x4d0
kernel: [26234.187392]                                               [<c118de76>] ext3_new_blocks+0x316/0x770
kernel: [26234.187392]                                               [<c1193546>] ext3_get_blocks_handle+0x2e6/0xa60
kernel: [26234.187392]                                               [<c1193d4b>] ext3_get_block+0x8b/0x140
kernel: [26234.187392]                                               [<c1123a94>] __block_prepare_write+0x1a4/0x440
kernel: [26234.187392]                                               [<c1123f44>] block_write_begin+0x84/0x140
kernel: [26234.187392]                                               [<c1192f53>] ext3_write_begin+0x133/0x2b0
kernel: [26234.187392]                                               [<c10c457b>] generic_file_buffered_write+0x13b/0x360
kernel: [26234.187392]                                               [<c10c4cc4>] __generic_file_aio_write_nolock+0x244/0x5c0
kernel: [26234.187392]                                               [<c10c5507>] generic_file_aio_write+0x77/0x100
kernel: [26234.187392]                                               [<c118f16b>] ext3_file_write+0x3b/0xe0
kernel: [26234.187392]                                               [<c10f9e2a>] do_sync_write+0xea/0x140
kernel: [26234.187392]                                               [<c10fac1e>] vfs_write+0xbe/0x1c0
kernel: [26234.187392]                                               [<c10fae28>] sys_write+0x58/0xa0
kernel: [26234.187392]                                               [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                               [<ffffffff>] 0xffffffff
kernel: [26234.187392]      }
kernel: [26234.187392]      ... key      at: [<c1cf8894>] __key.32358+0x0/0x8
kernel: [26234.187392]     ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c118d872>] ext3_try_to_allocate_with_rsv+0x1e2/0x4d0
kernel: [26234.187392]    [<c118de76>] ext3_new_blocks+0x316/0x770
kernel: [26234.187392]    [<c1193546>] ext3_get_blocks_handle+0x2e6/0xa60
kernel: [26234.187392]    [<c1193d4b>] ext3_get_block+0x8b/0x140
kernel: [26234.187392]    [<c1123a94>] __block_prepare_write+0x1a4/0x440
kernel: [26234.187392]    [<c1123f44>] block_write_begin+0x84/0x140
kernel: [26234.187392]    [<c1192f53>] ext3_write_begin+0x133/0x2b0
kernel: [26234.187392]    [<c10c457b>] generic_file_buffered_write+0x13b/0x360
kernel: [26234.187392]    [<c10c4cc4>] __generic_file_aio_write_nolock+0x244/0x5c0
kernel: [26234.187392]    [<c10c5507>] generic_file_aio_write+0x77/0x100
kernel: [26234.187392]    [<c118f16b>] ext3_file_write+0x3b/0xe0
kernel: [26234.187392]    [<c10f9e2a>] do_sync_write+0xea/0x140
kernel: [26234.187392]    [<c10fac1e>] vfs_write+0xbe/0x1c0
kernel: [26234.187392]    [<c10fae28>] sys_write+0x58/0xa0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]     ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c124c9f2>] cfq_set_request+0x222/0x2e0
kernel: [26234.187392]    [<c1232731>] elv_set_request+0x21/0x50
kernel: [26234.187392]    [<c123ac3d>] get_request+0x32d/0x390
kernel: [26234.187392]    [<c123b5fa>] get_request_wait+0x2a/0x170
kernel: [26234.187392]    [<c123ba40>] __make_request+0x80/0x3c0
kernel: [26234.187392]    [<c1238b20>] generic_make_request+0x390/0x580
kernel: [26234.187392]    [<c1238d7e>] submit_bio+0x6e/0x110
kernel: [26234.187392]    [<c1121225>] submit_bh+0x105/0x150
kernel: [26234.187392]    [<c1122c82>] bh_submit_read+0x32/0x90
kernel: [26234.187392]    [<c118cd40>] read_block_bitmap+0x80/0x1a0
kernel: [26234.187392]    [<c118cf98>] ext3_free_blocks_sb+0xc8/0x440
kernel: [26234.187392]    [<c118d34f>] ext3_free_blocks+0x3f/0xf0
kernel: [26234.187392]    [<c11942ec>] ext3_clear_blocks+0x14c/0x180
kernel: [26234.187392]    [<c1194468>] ext3_free_data+0x148/0x1a0
kernel: [26234.187392]    [<c1195001>] ext3_truncate+0x8a1/0x990
kernel: [26234.187392]    [<c10dd250>] vmtruncate+0xe0/0x1a0
kernel: [26234.187392]    [<c1111e3f>] inode_setattr+0x6f/0x1b0
kernel: [26234.187392]    [<c1191991>] ext3_setattr+0x151/0x210
kernel: [26234.187392]    [<c11120ef>] notify_change+0x16f/0x370
kernel: [26234.187392]    [<c10f8de4>] do_truncate+0x74/0xb0
kernel: [26234.187392]    [<c1105bdd>] may_open+0x23d/0x2c0
kernel: [26234.187392]    [<c11082ab>] do_filp_open+0x1cb/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]     ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c111bfe0>] __mark_inode_dirty+0x60/0x110
kernel: [26234.187392]    [<c118d399>] ext3_free_blocks+0x89/0xf0
kernel: [26234.187392]    [<c11942ec>] ext3_clear_blocks+0x14c/0x180
kernel: [26234.187392]    [<c1194468>] ext3_free_data+0x148/0x1a0
kernel: [26234.187392]    [<c1195001>] ext3_truncate+0x8a1/0x990
kernel: [26234.187392]    [<c10dd250>] vmtruncate+0xe0/0x1a0
kernel: [26234.187392]    [<c1111e3f>] inode_setattr+0x6f/0x1b0
kernel: [26234.187392]    [<c1191991>] ext3_setattr+0x151/0x210
kernel: [26234.187392]    [<c11120ef>] notify_change+0x16f/0x370
kernel: [26234.187392]    [<c10f8de4>] do_truncate+0x74/0xb0
kernel: [26234.187392]    [<c1105bdd>] may_open+0x23d/0x2c0
kernel: [26234.187392]    [<c11082ab>] do_filp_open+0x1cb/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]     ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10f32ff>] cache_alloc_refill+0x9f/0x6a0
kernel: [26234.187392]    [<c10f30a5>] kmem_cache_alloc+0x185/0x200
kernel: [26234.187392]    [<c1253965>] radix_tree_preload+0x35/0x90
kernel: [26234.187392]    [<c10c378d>] add_to_page_cache_locked+0x2d/0xc0
kernel: [26234.187392]    [<c10c3858>] add_to_page_cache_lru+0x38/0x90
kernel: [26234.187392]    [<c10c40fa>] find_or_create_page+0x6a/0xb0
kernel: [26234.187392]    [<c1121df1>] __getblk+0x161/0x390
kernel: [26234.187392]    [<c118cd07>] read_block_bitmap+0x47/0x1a0
kernel: [26234.187392]    [<c118cf98>] ext3_free_blocks_sb+0xc8/0x440
kernel: [26234.187392]    [<c118d34f>] ext3_free_blocks+0x3f/0xf0
kernel: [26234.187392]    [<c11942ec>] ext3_clear_blocks+0x14c/0x180
kernel: [26234.187392]    [<c1194468>] ext3_free_data+0x148/0x1a0
kernel: [26234.187392]    [<c1195001>] ext3_truncate+0x8a1/0x990
kernel: [26234.187392]    [<c11951ef>] ext3_delete_inode+0xff/0x110
kernel: [26234.187392]    [<c11112e4>] generic_delete_inode+0xb4/0x190
kernel: [26234.187392]    [<c1111537>] generic_drop_inode+0x177/0x200
kernel: [26234.187392]    [<c11101e5>] iput+0x55/0x70
kernel: [26234.187392]    [<c1107702>] do_unlinkat+0xf2/0x190
kernel: [26234.187392]    [<c1107904>] sys_unlinkat+0x34/0x60
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]     ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10c9784>] T.1313+0x34/0xa0
kernel: [26234.187392]    [<c10c9a28>] get_page_from_freelist+0x238/0x450
kernel: [26234.187392]    [<c10c9d2f>] __alloc_pages_nodemask+0xef/0x550
kernel: [26234.187392]    [<c10c40e2>] find_or_create_page+0x52/0xb0
kernel: [26234.187392]    [<c1121df1>] __getblk+0x161/0x390
kernel: [26234.187392]    [<c118cd07>] read_block_bitmap+0x47/0x1a0
kernel: [26234.187392]    [<c118cf98>] ext3_free_blocks_sb+0xc8/0x440
kernel: [26234.187392]    [<c118d34f>] ext3_free_blocks+0x3f/0xf0
kernel: [26234.187392]    [<c11942ec>] ext3_clear_blocks+0x14c/0x180
kernel: [26234.187392]    [<c1194468>] ext3_free_data+0x148/0x1a0
kernel: [26234.187392]    [<c1195001>] ext3_truncate+0x8a1/0x990
kernel: [26234.187392]    [<c11951ef>] ext3_delete_inode+0xff/0x110
kernel: [26234.187392]    [<c11112e4>] generic_delete_inode+0xb4/0x190
kernel: [26234.187392]    [<c1111537>] generic_drop_inode+0x177/0x200
kernel: [26234.187392]    [<c11101e5>] iput+0x55/0x70
kernel: [26234.187392]    [<c1107702>] do_unlinkat+0xf2/0x190
kernel: [26234.187392]    [<c1107904>] sys_unlinkat+0x34/0x60
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]     ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10f32ff>] cache_alloc_refill+0x9f/0x6a0
kernel: [26234.187392]    [<c10f30a5>] kmem_cache_alloc+0x185/0x200
kernel: [26234.187392]    [<c118d431>] ext3_init_block_alloc_info+0x31/0xf0
kernel: [26234.187392]    [<c1193892>] ext3_get_blocks_handle+0x632/0xa60
kernel: [26234.187392]    [<c1193d4b>] ext3_get_block+0x8b/0x140
kernel: [26234.187392]    [<c1123a94>] __block_prepare_write+0x1a4/0x440
kernel: [26234.187392]    [<c1123f44>] block_write_begin+0x84/0x140
kernel: [26234.187392]    [<c1192f53>] ext3_write_begin+0x133/0x2b0
kernel: [26234.187392]    [<c10c457b>] generic_file_buffered_write+0x13b/0x360
kernel: [26234.187392]    [<c10c4cc4>] __generic_file_aio_write_nolock+0x244/0x5c0
kernel: [26234.187392]    [<c10c5507>] generic_file_aio_write+0x77/0x100
kernel: [26234.187392]    [<c118f16b>] ext3_file_write+0x3b/0xe0
kernel: [26234.187392]    [<c10f9cf0>] do_sync_readv_writev+0xe0/0x130
kernel: [26234.187392]    [<c10fa5d3>] do_readv_writev+0xb3/0x1e0
kernel: [26234.187392]    [<c10fa762>] vfs_writev+0x62/0x80
kernel: [26234.187392]    [<c10fa8b8>] sys_writev+0x58/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]     -> (key#4){+.+...} ops: 0 {
kernel: [26234.187392]        HARDIRQ-ON-W at:
kernel: [26234.187392]                                                [<c1077409>] __lock_acquire+0xaa9/0x1840
kernel: [26234.187392]                                                [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                                [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                                [<c1260fdd>] __percpu_counter_sum+0x1d/0x90
kernel: [26234.187392]                                                [<c119a5c8>] ext3_statfs+0x68/0x230
kernel: [26234.187392]                                                [<c10f937d>] vfs_statfs+0x7d/0xa0
kernel: [26234.187392]                                                [<c10f94d1>] sys_statfs64+0x81/0xd0
kernel: [26234.187392]                                                [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                                [<ffffffff>] 0xffffffff
kernel: [26234.187392]        SOFTIRQ-ON-W at:
kernel: [26234.187392]                                                [<c107742f>] __lock_acquire+0xacf/0x1840
kernel: [26234.187392]                                                [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                                [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                                [<c1260fdd>] __percpu_counter_sum+0x1d/0x90
kernel: [26234.187392]                                                [<c119a5c8>] ext3_statfs+0x68/0x230
kernel: [26234.187392]                                                [<c10f937d>] vfs_statfs+0x7d/0xa0
kernel: [26234.187392]                                                [<c10f94d1>] sys_statfs64+0x81/0xd0
kernel: [26234.187392]                                                [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                                [<ffffffff>] 0xffffffff
kernel: [26234.187392]        INITIAL USE at:
kernel: [26234.187392]                                               [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                               [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                               [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                               [<c1260fdd>] __percpu_counter_sum+0x1d/0x90
kernel: [26234.187392]                                               [<c119a5c8>] ext3_statfs+0x68/0x230
kernel: [26234.187392]                                               [<c10f937d>] vfs_statfs+0x7d/0xa0
kernel: [26234.187392]                                               [<c10f94d1>] sys_statfs64+0x81/0xd0
kernel: [26234.187392]                                               [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                               [<ffffffff>] 0xffffffff
kernel: [26234.187392]      }
kernel: [26234.187392]      ... key      at: [<c1cf88ac>] __key.32351+0x0/0x8
kernel: [26234.187392]     ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1260f67>] __percpu_counter_add+0x97/0xf0
kernel: [26234.187392]    [<c118e1da>] ext3_new_blocks+0x67a/0x770
kernel: [26234.187392]    [<c1193546>] ext3_get_blocks_handle+0x2e6/0xa60
kernel: [26234.187392]    [<c1193d4b>] ext3_get_block+0x8b/0x140
kernel: [26234.187392]    [<c1123a94>] __block_prepare_write+0x1a4/0x440
kernel: [26234.187392]    [<c1123f44>] block_write_begin+0x84/0x140
kernel: [26234.187392]    [<c1192f53>] ext3_write_begin+0x133/0x2b0
kernel: [26234.187392]    [<c10c457b>] generic_file_buffered_write+0x13b/0x360
kernel: [26234.187392]    [<c10c4cc4>] __generic_file_aio_write_nolock+0x244/0x5c0
kernel: [26234.187392]    [<c10c5507>] generic_file_aio_write+0x77/0x100
kernel: [26234.187392]    [<c118f16b>] ext3_file_write+0x3b/0xe0
kernel: [26234.187392]    [<c10f9cf0>] do_sync_readv_writev+0xe0/0x130
kernel: [26234.187392]    [<c10fa5d3>] do_readv_writev+0xb3/0x1e0
kernel: [26234.187392]    [<c10fa762>] vfs_writev+0x62/0x80
kernel: [26234.187392]    [<c10fa8b8>] sys_writev+0x58/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]     ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c11eb9d1>] journal_extend+0x41/0xd0
kernel: [26234.187392]    [<c1191c1f>] try_to_extend_transaction+0x6f/0xa0
kernel: [26234.187392]    [<c11941e0>] ext3_clear_blocks+0x40/0x180
kernel: [26234.187392]    [<c1194468>] ext3_free_data+0x148/0x1a0
kernel: [26234.187392]    [<c1195001>] ext3_truncate+0x8a1/0x990
kernel: [26234.187392]    [<c10dd250>] vmtruncate+0xe0/0x1a0
kernel: [26234.187392]    [<c1111e3f>] inode_setattr+0x6f/0x1b0
kernel: [26234.187392]    [<c1191991>] ext3_setattr+0x151/0x210
kernel: [26234.187392]    [<c11120ef>] notify_change+0x16f/0x370
kernel: [26234.187392]    [<c10f8de4>] do_truncate+0x74/0xb0
kernel: [26234.187392]    [<c10f8f38>] do_sys_ftruncate+0x118/0x190
kernel: [26234.187392]    [<c10f9040>] sys_ftruncate+0x30/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141981c>] mutex_lock_nested+0x5c/0x2e0
kernel: [26234.187392]    [<c1194b9c>] ext3_truncate+0x43c/0x990
kernel: [26234.187392]    [<c10dd250>] vmtruncate+0xe0/0x1a0
kernel: [26234.187392]    [<c1111e3f>] inode_setattr+0x6f/0x1b0
kernel: [26234.187392]    [<c1191991>] ext3_setattr+0x151/0x210
kernel: [26234.187392]    [<c11120ef>] notify_change+0x16f/0x370
kernel: [26234.187392]    [<c10f8de4>] do_truncate+0x74/0xb0
kernel: [26234.187392]    [<c1105bdd>] may_open+0x23d/0x2c0
kernel: [26234.187392]    [<c11082ab>] do_filp_open+0x1cb/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1111b95>] new_inode+0x35/0xb0
kernel: [26234.187392]    [<c118f742>] ext3_new_inode+0x62/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]    [<c10c37b5>] add_to_page_cache_locked+0x55/0xc0
kernel: [26234.187392]    [<c10c3858>] add_to_page_cache_lru+0x38/0x90
kernel: [26234.187392]    [<c10c40fa>] find_or_create_page+0x6a/0xb0
kernel: [26234.187392]    [<c1121df1>] __getblk+0x161/0x390
kernel: [26234.187392]    [<c11257cf>] __bread+0x1f/0xc0
kernel: [26234.187392]    [<c118f426>] read_inode_bitmap+0x46/0xa0
kernel: [26234.187392]    [<c118f8b5>] ext3_new_inode+0x1d5/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1121ee5>] __getblk+0x255/0x390
kernel: [26234.187392]    [<c11257cf>] __bread+0x1f/0xc0
kernel: [26234.187392]    [<c118f426>] read_inode_bitmap+0x46/0xa0
kernel: [26234.187392]    [<c118f8b5>] ext3_new_inode+0x1d5/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]    [<c123ba05>] __make_request+0x45/0x3c0
kernel: [26234.187392]    [<c1238b20>] generic_make_request+0x390/0x580
kernel: [26234.187392]    [<c1238d7e>] submit_bio+0x6e/0x110
kernel: [26234.187392]    [<c1121225>] submit_bh+0x105/0x150
kernel: [26234.187392]    [<c1125819>] __bread+0x69/0xc0
kernel: [26234.187392]    [<c118f426>] read_inode_bitmap+0x46/0xa0
kernel: [26234.187392]    [<c118f8b5>] ext3_new_inode+0x1d5/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c124c9f2>] cfq_set_request+0x222/0x2e0
kernel: [26234.187392]    [<c1232731>] elv_set_request+0x21/0x50
kernel: [26234.187392]    [<c123ac3d>] get_request+0x32d/0x390
kernel: [26234.187392]    [<c123b5fa>] get_request_wait+0x2a/0x170
kernel: [26234.187392]    [<c123ba40>] __make_request+0x80/0x3c0
kernel: [26234.187392]    [<c1238b20>] generic_make_request+0x390/0x580
kernel: [26234.187392]    [<c1238d7e>] submit_bio+0x6e/0x110
kernel: [26234.187392]    [<c1121225>] submit_bh+0x105/0x150
kernel: [26234.187392]    [<c1125819>] __bread+0x69/0xc0
kernel: [26234.187392]    [<c118f426>] read_inode_bitmap+0x46/0xa0
kernel: [26234.187392]    [<c118f8b5>] ext3_new_inode+0x1d5/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c105f87a>] prepare_to_wait+0x2a/0x80
kernel: [26234.187392]    [<c141908a>] __wait_on_bit+0x4a/0xa0
kernel: [26234.187392]    [<c1419184>] out_of_line_wait_on_bit+0xa4/0xc0
kernel: [26234.187392]    [<c1122b0a>] __wait_on_buffer+0x2a/0x50
kernel: [26234.187392]    [<c1125832>] __bread+0x82/0xc0
kernel: [26234.187392]    [<c118f426>] read_inode_bitmap+0x46/0xa0
kernel: [26234.187392]    [<c118f8b5>] ext3_new_inode+0x1d5/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1324670>] scsi_request_fn+0x150/0x500
kernel: [26234.187392]    [<c123b5a9>] __generic_unplug_device+0x39/0x60
kernel: [26234.187392]    [<c123b89f>] generic_unplug_device+0x2f/0x60
kernel: [26234.187392]    [<c1237d71>] blk_unplug+0x31/0x70
kernel: [26234.187392]    [<c1237dca>] blk_backing_dev_unplug+0x1a/0x40
kernel: [26234.187392]    [<c1122bee>] sync_buffer+0x3e/0x60
kernel: [26234.187392]    [<c141909d>] __wait_on_bit+0x5d/0xa0
kernel: [26234.187392]    [<c1419184>] out_of_line_wait_on_bit+0xa4/0xc0
kernel: [26234.187392]    [<c1122b0a>] __wait_on_buffer+0x2a/0x50
kernel: [26234.187392]    [<c1125832>] __bread+0x82/0xc0
kernel: [26234.187392]    [<c118f426>] read_inode_bitmap+0x46/0xa0
kernel: [26234.187392]    [<c118f8b5>] ext3_new_inode+0x1d5/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1338506>] ata_scsi_queuecmd+0x36/0x250
kernel: [26234.187392]    [<c131d8b9>] scsi_dispatch_cmd+0x169/0x280
kernel: [26234.187392]    [<c13248b5>] scsi_request_fn+0x395/0x500
kernel: [26234.187392]    [<c123b5a9>] __generic_unplug_device+0x39/0x60
kernel: [26234.187392]    [<c123b89f>] generic_unplug_device+0x2f/0x60
kernel: [26234.187392]    [<c1237d71>] blk_unplug+0x31/0x70
kernel: [26234.187392]    [<c1237dca>] blk_backing_dev_unplug+0x1a/0x40
kernel: [26234.187392]    [<c1122bee>] sync_buffer+0x3e/0x60
kernel: [26234.187392]    [<c141909d>] __wait_on_bit+0x5d/0xa0
kernel: [26234.187392]    [<c1419184>] out_of_line_wait_on_bit+0xa4/0xc0
kernel: [26234.187392]    [<c1122b0a>] __wait_on_buffer+0x2a/0x50
kernel: [26234.187392]    [<c1125832>] __bread+0x82/0xc0
kernel: [26234.187392]    [<c118f426>] read_inode_bitmap+0x46/0xa0
kernel: [26234.187392]    [<c118f8b5>] ext3_new_inode+0x1d5/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]    [<c1417c81>] schedule+0xe1/0xc10
kernel: [26234.187392]    [<c141880b>] io_schedule+0x5b/0xb0
kernel: [26234.187392]    [<c1122bf5>] sync_buffer+0x45/0x60
kernel: [26234.187392]    [<c141909d>] __wait_on_bit+0x5d/0xa0
kernel: [26234.187392]    [<c1419184>] out_of_line_wait_on_bit+0xa4/0xc0
kernel: [26234.187392]    [<c1122b0a>] __wait_on_buffer+0x2a/0x50
kernel: [26234.187392]    [<c1125832>] __bread+0x82/0xc0
kernel: [26234.187392]    [<c118f426>] read_inode_bitmap+0x46/0xa0
kernel: [26234.187392]    [<c118f8b5>] ext3_new_inode+0x1d5/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c10a982e>] delayacct_end+0x7e/0xd0
kernel: [26234.187392]    [<c10a9908>] __delayacct_blkio_end+0x38/0x70
kernel: [26234.187392]    [<c1418827>] io_schedule+0x77/0xb0
kernel: [26234.187392]    [<c1122bf5>] sync_buffer+0x45/0x60
kernel: [26234.187392]    [<c141909d>] __wait_on_bit+0x5d/0xa0
kernel: [26234.187392]    [<c1419184>] out_of_line_wait_on_bit+0xa4/0xc0
kernel: [26234.187392]    [<c1122b0a>] __wait_on_buffer+0x2a/0x50
kernel: [26234.187392]    [<c1125832>] __bread+0x82/0xc0
kernel: [26234.187392]    [<c118f426>] read_inode_bitmap+0x46/0xa0
kernel: [26234.187392]    [<c118f8b5>] ext3_new_inode+0x1d5/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c118fdbe>] ext3_new_inode+0x6de/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    -> (&sbi->s_next_gen_lock){+.+...} ops: 0 {
kernel: [26234.187392]       HARDIRQ-ON-W at:
kernel: [26234.187392]                                              [<c1077409>] __lock_acquire+0xaa9/0x1840
kernel: [26234.187392]                                              [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                              [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                              [<c118ff9c>] ext3_new_inode+0x8bc/0xb00
kernel: [26234.187392]                                              [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]                                              [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]                                              [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]                                              [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]                                              [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]                                              [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                              [<ffffffff>] 0xffffffff
kernel: [26234.187392]       SOFTIRQ-ON-W at:
kernel: [26234.187392]                                              [<c107742f>] __lock_acquire+0xacf/0x1840
kernel: [26234.187392]                                              [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                              [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                              [<c118ff9c>] ext3_new_inode+0x8bc/0xb00
kernel: [26234.187392]                                              [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]                                              [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]                                              [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]                                              [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]                                              [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]                                              [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                              [<ffffffff>] 0xffffffff
kernel: [26234.187392]       INITIAL USE at:
kernel: [26234.187392]                                             [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                             [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                             [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                             [<c118ff9c>] ext3_new_inode+0x8bc/0xb00
kernel: [26234.187392]                                             [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]                                             [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]                                             [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]                                             [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]                                             [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]                                             [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                             [<ffffffff>] 0xffffffff
kernel: [26234.187392]     }
kernel: [26234.187392]     ... key      at: [<c1cf88b4>] __key.32350+0x0/0x8
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c118ff9c>] ext3_new_inode+0x8bc/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c11a322c>] ext3_get_acl+0x8c/0x3b0
kernel: [26234.187392]    [<c11a399c>] ext3_init_acl+0x14c/0x1b0
kernel: [26234.187392]    [<c119005b>] ext3_new_inode+0x97b/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    -> (&ei->xattr_sem){.+.+..} ops: 0 {
kernel: [26234.187392]       HARDIRQ-ON-R at:
kernel: [26234.187392]                                              [<c1076b1b>] __lock_acquire+0x1bb/0x1840
kernel: [26234.187392]                                              [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                              [<c141a226>] down_read+0x46/0xa0
kernel: [26234.187392]                                              [<c11a2357>] ext3_xattr_get+0x47/0x2d0
kernel: [26234.187392]                                              [<c11a3ba1>] ext3_xattr_security_get+0x51/0x70
kernel: [26234.187392]                                              [<c1118476>] generic_getxattr+0x96/0xc0
kernel: [26234.187392]                                              [<c121cbe0>] get_vfs_caps_from_disk+0x70/0x100
kernel: [26234.187392]                                              [<c121d578>] cap_bprm_set_creds+0x88/0x480
kernel: [26234.187392]                                              [<c121dd7b>] security_bprm_set_creds+0x1b/0x40
kernel: [26234.187392]                                              [<c1100fb9>] prepare_binprm+0x79/0x110
kernel: [26234.187392]                                              [<c11019ea>] do_execve+0x1da/0x340
kernel: [26234.187392]                                              [<c1001853>] sys_execve+0x33/0x70
kernel: [26234.187392]                                              [<c1003344>] syscall_call+0x7/0xb
kernel: [26234.187392]                                              [<ffffffff>] 0xffffffff
kernel: [26234.187392]       SOFTIRQ-ON-R at:
kernel: [26234.187392]                                              [<c107742f>] __lock_acquire+0xacf/0x1840
kernel: [26234.187392]                                              [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                              [<c141a226>] down_read+0x46/0xa0
kernel: [26234.187392]                                              [<c11a2357>] ext3_xattr_get+0x47/0x2d0
kernel: [26234.187392]                                              [<c11a3ba1>] ext3_xattr_security_get+0x51/0x70
kernel: [26234.187392]                                              [<c1118476>] generic_getxattr+0x96/0xc0
kernel: [26234.187392]                                              [<c121cbe0>] get_vfs_caps_from_disk+0x70/0x100
kernel: [26234.187392]                                              [<c121d578>] cap_bprm_set_creds+0x88/0x480
kernel: [26234.187392]                                              [<c121dd7b>] security_bprm_set_creds+0x1b/0x40
kernel: [26234.187392]                                              [<c1100fb9>] prepare_binprm+0x79/0x110
kernel: [26234.187392]                                              [<c11019ea>] do_execve+0x1da/0x340
kernel: [26234.187392]                                              [<c1001853>] sys_execve+0x33/0x70
kernel: [26234.187392]                                              [<c1003344>] syscall_call+0x7/0xb
kernel: [26234.187392]                                              [<ffffffff>] 0xffffffff
kernel: [26234.187392]       INITIAL USE at:
kernel: [26234.187392]                                             [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                             [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                             [<c141a226>] down_read+0x46/0xa0
kernel: [26234.187392]                                             [<c11a2357>] ext3_xattr_get+0x47/0x2d0
kernel: [26234.187392]                                             [<c11a3ba1>] ext3_xattr_security_get+0x51/0x70
kernel: [26234.187392]                                             [<c1118476>] generic_getxattr+0x96/0xc0
kernel: [26234.187392]                                             [<c121cbe0>] get_vfs_caps_from_disk+0x70/0x100
kernel: [26234.187392]                                             [<c121d578>] cap_bprm_set_creds+0x88/0x480
kernel: [26234.187392]                                             [<c121dd7b>] security_bprm_set_creds+0x1b/0x40
kernel: [26234.187392]                                             [<c1100fb9>] prepare_binprm+0x79/0x110
kernel: [26234.187392]                                             [<c11019ea>] do_execve+0x1da/0x340
kernel: [26234.187392]                                             [<c1001853>] sys_execve+0x33/0x70
kernel: [26234.187392]                                             [<c1003344>] syscall_call+0x7/0xb
kernel: [26234.187392]                                             [<ffffffff>] 0xffffffff
kernel: [26234.187392]     }
kernel: [26234.187392]     ... key      at: [<c1cf88cc>] __key.31426+0x0/0x8
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141a226>] down_read+0x46/0xa0
kernel: [26234.187392]    [<c11a2357>] ext3_xattr_get+0x47/0x2d0
kernel: [26234.187392]    [<c11a326b>] ext3_get_acl+0xcb/0x3b0
kernel: [26234.187392]    [<c11a399c>] ext3_init_acl+0x14c/0x1b0
kernel: [26234.187392]    [<c119005b>] ext3_new_inode+0x97b/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c110e2c9>] d_instantiate+0x29/0x70
kernel: [26234.187392]    [<c1197c83>] ext3_add_nondir+0x73/0x90
kernel: [26234.187392]    [<c119827d>] ext3_create+0xad/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]    [<c10cd76a>] activate_page+0x3a/0x130
kernel: [26234.187392]    [<c10cd8b1>] mark_page_accessed+0x51/0x60
kernel: [26234.187392]    [<c1121b7c>] __find_get_block+0xbc/0x1d0
kernel: [26234.187392]    [<c1121cc3>] __getblk+0x33/0x390
kernel: [26234.187392]    [<c11257cf>] __bread+0x1f/0xc0
kernel: [26234.187392]    [<c118f426>] read_inode_bitmap+0x46/0xa0
kernel: [26234.187392]    [<c1190340>] ext3_free_inode+0x160/0x360
kernel: [26234.187392]    [<c11951e1>] ext3_delete_inode+0xf1/0x110
kernel: [26234.187392]    [<c11112e4>] generic_delete_inode+0xb4/0x190
kernel: [26234.187392]    [<c1111537>] generic_drop_inode+0x177/0x200
kernel: [26234.187392]    [<c11101e5>] iput+0x55/0x70
kernel: [26234.187392]    [<c1107702>] do_unlinkat+0xf2/0x190
kernel: [26234.187392]    [<c11077be>] sys_unlink+0x1e/0x40
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c10293c6>] pgd_free+0x26/0x90
kernel: [26234.187392]    [<c1041456>] __mmdrop+0x26/0x60
kernel: [26234.187392]    [<c103a9f3>] finish_task_switch+0xf3/0x100
kernel: [26234.187392]    [<c1417fd3>] schedule+0x433/0xc10
kernel: [26234.187392]    [<c141880b>] io_schedule+0x5b/0xb0
kernel: [26234.187392]    [<c1122bf5>] sync_buffer+0x45/0x60
kernel: [26234.187392]    [<c141909d>] __wait_on_bit+0x5d/0xa0
kernel: [26234.187392]    [<c1419184>] out_of_line_wait_on_bit+0xa4/0xc0
kernel: [26234.187392]    [<c1122b0a>] __wait_on_buffer+0x2a/0x50
kernel: [26234.187392]    [<c1125832>] __bread+0x82/0xc0
kernel: [26234.187392]    [<c1191cec>] ext3_get_branch+0x9c/0x130
kernel: [26234.187392]    [<c1193337>] ext3_get_blocks_handle+0xd7/0xa60
kernel: [26234.187392]    [<c1193d4b>] ext3_get_block+0x8b/0x140
kernel: [26234.187392]    [<c1123a94>] __block_prepare_write+0x1a4/0x440
kernel: [26234.187392]    [<c1123f44>] block_write_begin+0x84/0x140
kernel: [26234.187392]    [<c1192f53>] ext3_write_begin+0x133/0x2b0
kernel: [26234.187392]    [<c10c457b>] generic_file_buffered_write+0x13b/0x360
kernel: [26234.187392]    [<c10c4cc4>] __generic_file_aio_write_nolock+0x244/0x5c0
kernel: [26234.187392]    [<c10c5507>] generic_file_aio_write+0x77/0x100
kernel: [26234.187392]    [<c118f16b>] ext3_file_write+0x3b/0xe0
kernel: [26234.187392]    [<c10f9e2a>] do_sync_write+0xea/0x140
kernel: [26234.187392]    [<c10fac1e>] vfs_write+0xbe/0x1c0
kernel: [26234.187392]    [<c10fae28>] sys_write+0x58/0xa0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c10da7cf>] page_address+0x9f/0x100
kernel: [26234.187392]    [<c1237a92>] blk_rq_bio_prep+0x82/0xa0
kernel: [26234.187392]    [<c1237cdf>] init_request_from_bio+0xaf/0x110
kernel: [26234.187392]    [<c123ba4d>] __make_request+0x8d/0x3c0
kernel: [26234.187392]    [<c1238b20>] generic_make_request+0x390/0x580
kernel: [26234.187392]    [<c1238d7e>] submit_bio+0x6e/0x110
kernel: [26234.187392]    [<c1121225>] submit_bh+0x105/0x150
kernel: [26234.187392]    [<c11233f2>] ll_rw_block+0x122/0x130
kernel: [26234.187392]    [<c1123aef>] __block_prepare_write+0x1ff/0x440
kernel: [26234.187392]    [<c1123f44>] block_write_begin+0x84/0x140
kernel: [26234.187392]    [<c1192f53>] ext3_write_begin+0x133/0x2b0
kernel: [26234.187392]    [<c10c457b>] generic_file_buffered_write+0x13b/0x360
kernel: [26234.187392]    [<c10c4cc4>] __generic_file_aio_write_nolock+0x244/0x5c0
kernel: [26234.187392]    [<c10c5507>] generic_file_aio_write+0x77/0x100
kernel: [26234.187392]    [<c118f16b>] ext3_file_write+0x3b/0xe0
kernel: [26234.187392]    [<c10f9e2a>] do_sync_write+0xea/0x140
kernel: [26234.187392]    [<c10fac1e>] vfs_write+0xbe/0x1c0
kernel: [26234.187392]    [<c10fae28>] sys_write+0x58/0xa0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10c9784>] T.1313+0x34/0xa0
kernel: [26234.187392]    [<c10c9a28>] get_page_from_freelist+0x238/0x450
kernel: [26234.187392]    [<c10c9d2f>] __alloc_pages_nodemask+0xef/0x550
kernel: [26234.187392]    [<c10f35e3>] cache_alloc_refill+0x383/0x6a0
kernel: [26234.187392]    [<c10f30a5>] kmem_cache_alloc+0x185/0x200
kernel: [26234.187392]    [<c119a8c0>] ext3_alloc_inode+0x20/0x70
kernel: [26234.187392]    [<c1111821>] alloc_inode+0x21/0x60
kernel: [26234.187392]    [<c1111b85>] new_inode+0x25/0xb0
kernel: [26234.187392]    [<c118f742>] ext3_new_inode+0x62/0xb00
kernel: [26234.187392]    [<c1198016>] ext3_mkdir+0x116/0x2d0
kernel: [26234.187392]    [<c1104c16>] vfs_mkdir+0xe6/0x190
kernel: [26234.187392]    [<c1107a66>] sys_mkdirat+0xf6/0x120
kernel: [26234.187392]    [<c1107abb>] sys_mkdir+0x2b/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c10638fc>] lock_hrtimer_base+0x2c/0x60
kernel: [26234.187392]    [<c1063abf>] __hrtimer_start_range_ns+0x3f/0x440
kernel: [26234.187392]    [<c1063f3e>] hrtimer_start_range_ns+0x2e/0x50
kernel: [26234.187392]    [<c1419eb6>] schedule_hrtimeout_range+0xd6/0x170
kernel: [26234.187392]    [<c1419f6b>] schedule_hrtimeout+0x1b/0x40
kernel: [26234.187392]    [<c11eabce>] journal_stop+0x24e/0x2f0
kernel: [26234.187392]    [<c11ec0c9>] journal_force_commit+0x29/0x50
kernel: [26234.187392]    [<c119b63a>] ext3_force_commit+0x2a/0x50
kernel: [26234.187392]    [<c1190e13>] ext3_write_inode+0x53/0x70
kernel: [26234.187392]    [<c111b451>] __writeback_single_inode+0x2d1/0x3f0
kernel: [26234.187392]    [<c111b59e>] sync_inode+0x2e/0x60
kernel: [26234.187392]    [<c118f2cd>] ext3_sync_file+0xbd/0xe0
kernel: [26234.187392]    [<c111f7b0>] vfs_fsync+0x90/0x110
kernel: [26234.187392]    [<c111f867>] do_fsync+0x37/0x60
kernel: [26234.187392]    [<c111f8eb>] sys_fsync+0x1b/0x40
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    -> (key#5){+.+...} ops: 0 {
kernel: [26234.187392]       HARDIRQ-ON-W at:
kernel: [26234.187392]                                              [<c1077409>] __lock_acquire+0xaa9/0x1840
kernel: [26234.187392]                                              [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                              [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                              [<c1260fdd>] __percpu_counter_sum+0x1d/0x90
kernel: [26234.187392]                                              [<c119a67f>] ext3_statfs+0x11f/0x230
kernel: [26234.187392]                                              [<c10f937d>] vfs_statfs+0x7d/0xa0
kernel: [26234.187392]                                              [<c10f94d1>] sys_statfs64+0x81/0xd0
kernel: [26234.187392]                                              [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                              [<ffffffff>] 0xffffffff
kernel: [26234.187392]       SOFTIRQ-ON-W at:
kernel: [26234.187392]                                              [<c107742f>] __lock_acquire+0xacf/0x1840
kernel: [26234.187392]                                              [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                              [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                              [<c1260fdd>] __percpu_counter_sum+0x1d/0x90
kernel: [26234.187392]                                              [<c119a67f>] ext3_statfs+0x11f/0x230
kernel: [26234.187392]                                              [<c10f937d>] vfs_statfs+0x7d/0xa0
kernel: [26234.187392]                                              [<c10f94d1>] sys_statfs64+0x81/0xd0
kernel: [26234.187392]                                              [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                              [<ffffffff>] 0xffffffff
kernel: [26234.187392]       INITIAL USE at:
kernel: [26234.187392]                                             [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                             [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                             [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                             [<c1260fdd>] __percpu_counter_sum+0x1d/0x90
kernel: [26234.187392]                                             [<c119a67f>] ext3_statfs+0x11f/0x230
kernel: [26234.187392]                                             [<c10f937d>] vfs_statfs+0x7d/0xa0
kernel: [26234.187392]                                             [<c10f94d1>] sys_statfs64+0x81/0xd0
kernel: [26234.187392]                                             [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                             [<ffffffff>] 0xffffffff
kernel: [26234.187392]     }
kernel: [26234.187392]     ... key      at: [<c1cf88a4>] __key.32353+0x0/0x8
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1260f67>] __percpu_counter_add+0x97/0xf0
kernel: [26234.187392]    [<c118fe20>] ext3_new_inode+0x740/0xb00
kernel: [26234.187392]    [<c119824f>] ext3_create+0x7f/0x100
kernel: [26234.187392]    [<c1104fa1>] vfs_create+0xf1/0x190
kernel: [26234.187392]    [<c110897d>] do_filp_open+0x89d/0x980
kernel: [26234.187392]    [<c10f7bed>] do_sys_open+0x5d/0x130
kernel: [26234.187392]    [<c10f7d54>] sys_open+0x34/0x50
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10f21f1>] cache_flusharray+0x51/0x150
kernel: [26234.187392]    [<c10f23f9>] kfree+0x109/0x160
kernel: [26234.187392]    [<c119a375>] ext3_clear_inode+0xb5/0xc0
kernel: [26234.187392]    [<c1110a9d>] clear_inode+0x6d/0x110
kernel: [26234.187392]    [<c119029b>] ext3_free_inode+0xbb/0x360
kernel: [26234.187392]    [<c11951e1>] ext3_delete_inode+0xf1/0x110
kernel: [26234.187392]    [<c11112e4>] generic_delete_inode+0xb4/0x190
kernel: [26234.187392]    [<c1111537>] generic_drop_inode+0x177/0x200
kernel: [26234.187392]    [<c11101e5>] iput+0x55/0x70
kernel: [26234.187392]    [<c110d0b7>] dentry_iput+0x87/0x110
kernel: [26234.187392]    [<c110d23b>] d_kill+0x3b/0x70
kernel: [26234.187392]    [<c110f22e>] dput+0x7e/0x150
kernel: [26234.187392]    [<c10fbb02>] __fput+0x172/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c1046055>] put_files_struct+0xb5/0xe0
kernel: [26234.187392]    [<c10460cb>] exit_files+0x4b/0x70
kernel: [26234.187392]    [<c1047be3>] do_exit+0x133/0x6d0
kernel: [26234.187392]    [<c10481c5>] do_group_exit+0x45/0xb0
kernel: [26234.187392]    [<c1048252>] sys_exit_group+0x22/0x40
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c11ec05e>] journal_start+0xfe/0x140
kernel: [26234.187392]    [<c119b864>] ext3_journal_start_sb+0x34/0x70
kernel: [26234.187392]    [<c11917d8>] ext3_dirty_inode+0x38/0xa0
kernel: [26234.187392]    [<c111bfb7>] __mark_inode_dirty+0x37/0x110
kernel: [26234.187392]    [<c111000d>] file_update_time+0xcd/0x100
kernel: [26234.187392]    [<c10dbe1a>] do_wp_page+0xfa/0x630
kernel: [26234.187392]    [<c10dd839>] handle_mm_fault+0x379/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   -> (mb_cache_spinlock){+.+.-.} ops: 0 {
kernel: [26234.187392]      HARDIRQ-ON-W at:
kernel: [26234.187392]                                            [<c1077409>] __lock_acquire+0xaa9/0x1840
kernel: [26234.187392]                                            [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                            [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                            [<c113e6c8>] mb_cache_create+0x138/0x1a0
kernel: [26234.187392]                                            [<c15fd841>] init_ext3_xattr+0x31/0x51
kernel: [26234.187392]                                            [<c15fd79e>] init_ext3_fs+0x17/0x89
kernel: [26234.187392]                                            [<c100115f>] do_one_initcall+0x3f/0x1a0
kernel: [26234.187392]                                            [<c15de4af>] kernel_init+0x13e/0x1a6
kernel: [26234.187392]                                            [<c1003edb>] kernel_thread_helper+0x7/0x1c
kernel: [26234.187392]                                            [<ffffffff>] 0xffffffff
kernel: [26234.187392]      SOFTIRQ-ON-W at:
kernel: [26234.187392]                                            [<c107742f>] __lock_acquire+0xacf/0x1840
kernel: [26234.187392]                                            [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                            [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                            [<c113e6c8>] mb_cache_create+0x138/0x1a0
kernel: [26234.187392]                                            [<c15fd841>] init_ext3_xattr+0x31/0x51
kernel: [26234.187392]                                            [<c15fd79e>] init_ext3_fs+0x17/0x89
kernel: [26234.187392]                                            [<c100115f>] do_one_initcall+0x3f/0x1a0
kernel: [26234.187392]                                            [<c15de4af>] kernel_init+0x13e/0x1a6
kernel: [26234.187392]                                            [<c1003edb>] kernel_thread_helper+0x7/0x1c
kernel: [26234.187392]                                            [<ffffffff>] 0xffffffff
kernel: [26234.187392]      IN-RECLAIM_FS-W at:
kernel: [26234.187392]                                               [<c1076b78>] __lock_acquire+0x218/0x1840
kernel: [26234.187392]                                               [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                               [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                               [<c113dc4c>] mb_cache_shrink_fn+0x2c/0x150
kernel: [26234.187392]                                               [<c10d0b40>] shrink_slab+0x80/0x1b0
kernel: [26234.187392]                                               [<c10d110a>] kswapd+0x49a/0x650
kernel: [26234.187392]                                               [<c105f244>] kthread+0x84/0x90
kernel: [26234.187392]                                               [<c1003edb>] kernel_thread_helper+0x7/0x1c
kernel: [26234.187392]                                               [<ffffffff>] 0xffffffff
kernel: [26234.187392]      INITIAL USE at:
kernel: [26234.187392]                                           [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                           [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                           [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                           [<c113e6c8>] mb_cache_create+0x138/0x1a0
kernel: [26234.187392]                                           [<c15fd841>] init_ext3_xattr+0x31/0x51
kernel: [26234.187392]                                           [<c15fd79e>] init_ext3_fs+0x17/0x89
kernel: [26234.187392]                                           [<c100115f>] do_one_initcall+0x3f/0x1a0
kernel: [26234.187392]                                           [<c15de4af>] kernel_init+0x13e/0x1a6
kernel: [26234.187392]                                           [<c1003edb>] kernel_thread_helper+0x7/0x1c
kernel: [26234.187392]                                           [<ffffffff>] 0xffffffff
kernel: [26234.187392]    }
kernel: [26234.187392]    ... key      at: [<c1599430>] mb_cache_spinlock+0x10/0x24
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c113dc4c>] mb_cache_shrink_fn+0x2c/0x150
kernel: [26234.187392]    [<c10d0b40>] shrink_slab+0x80/0x1b0
kernel: [26234.187392]    [<c10d182f>] try_to_free_pages+0x21f/0x3a0
kernel: [26234.187392]    [<c10c9f53>] __alloc_pages_nodemask+0x313/0x550
kernel: [26234.187392]    [<c10dd8eb>] handle_mm_fault+0x42b/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   -> (pdflush_lock){..-.-.} ops: 0 {
kernel: [26234.187392]      IN-SOFTIRQ-W at:
kernel: [26234.187392]                                            [<c10773ec>] __lock_acquire+0xa8c/0x1840
kernel: [26234.187392]                                            [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                            [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]                                            [<c10cc6b5>] pdflush_operation+0x35/0xc0
kernel: [26234.187392]                                            [<c10cb1ed>] wb_timer_fn+0x1d/0x60
kernel: [26234.187392]                                            [<c1050745>] run_timer_softirq+0x185/0x270
kernel: [26234.187392]                                            [<c104acca>] __do_softirq+0xaa/0x1f0
kernel: [26234.187392]                                            [<c104ae85>] do_softirq+0x75/0x90
kernel: [26234.187392]                                            [<c104b035>] irq_exit+0x85/0xa0
kernel: [26234.187392]                                            [<c100574c>] do_IRQ+0x5c/0xd0
kernel: [26234.187392]                                            [<c1003975>] common_interrupt+0x35/0x3c
kernel: [26234.187392]                                            [<c136898e>] cpuidle_idle_call+0x8e/0xf0
kernel: [26234.187392]                                            [<c10020a6>] cpu_idle+0xa6/0xf0
kernel: [26234.187392]                                            [<c1405a75>] rest_init+0x65/0x80
kernel: [26234.187392]                                            [<c15dea85>] start_kernel+0x353/0x36b
kernel: [26234.187392]                                            [<c15de088>] __init_begin+0x88/0xa1
kernel: [26234.187392]                                            [<ffffffff>] 0xffffffff
kernel: [26234.187392]      IN-RECLAIM_FS-W at:
kernel: [26234.187392]                                               [<c1076b78>] __lock_acquire+0x218/0x1840
kernel: [26234.187392]                                               [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                               [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]                                               [<c10cc6b5>] pdflush_operation+0x35/0xc0
kernel: [26234.187392]                                               [<c10cb2ab>] wakeup_pdflush+0x3b/0x60
kernel: [26234.187392]                                               [<c10d187c>] try_to_free_pages+0x26c/0x3a0
kernel: [26234.187392]                                               [<c10c9f53>] __alloc_pages_nodemask+0x313/0x550
kernel: [26234.187392]                                               [<c10dd8eb>] handle_mm_fault+0x42b/0x5d0
kernel: [26234.187392]                                               [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]                                               [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]                                               [<ffffffff>] 0xffffffff
kernel: [26234.187392]      INITIAL USE at:
kernel: [26234.187392]                                           [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                           [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                           [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]                                           [<c10cc4cf>] pdflush+0x7f/0x230
kernel: [26234.187392]                                           [<c105f244>] kthread+0x84/0x90
kernel: [26234.187392]                                           [<c1003edb>] kernel_thread_helper+0x7/0x1c
kernel: [26234.187392]                                           [<ffffffff>] 0xffffffff
kernel: [26234.187392]    }
kernel: [26234.187392]    ... key      at: [<c15971b0>] pdflush_lock+0x10/0x24
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1030f97>] task_rq_lock+0x47/0x90
kernel: [26234.187392]    [<c103de4d>] try_to_wake_up+0x8d/0x390
kernel: [26234.187392]    [<c103e1db>] wake_up_process+0x1b/0x40
kernel: [26234.187392]    [<c10cc6f6>] pdflush_operation+0x76/0xc0
kernel: [26234.187392]    [<c10cb1ed>] wb_timer_fn+0x1d/0x60
kernel: [26234.187392]    [<c1050745>] run_timer_softirq+0x185/0x270
kernel: [26234.187392]    [<c104acca>] __do_softirq+0xaa/0x1f0
kernel: [26234.187392]    [<c104ae85>] do_softirq+0x75/0x90
kernel: [26234.187392]    [<c104b035>] irq_exit+0x85/0xa0
kernel: [26234.187392]    [<c100574c>] do_IRQ+0x5c/0xd0
kernel: [26234.187392]    [<c1003975>] common_interrupt+0x35/0x3c
kernel: [26234.187392]    [<c136898e>] cpuidle_idle_call+0x8e/0xf0
kernel: [26234.187392]    [<c10020a6>] cpu_idle+0xa6/0xf0
kernel: [26234.187392]    [<c1405a75>] rest_init+0x65/0x80
kernel: [26234.187392]    [<c15dea85>] start_kernel+0x353/0x36b
kernel: [26234.187392]    [<c15de088>] __init_begin+0x88/0xa1
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c10cc6b5>] pdflush_operation+0x35/0xc0
kernel: [26234.187392]    [<c10cb2ab>] wakeup_pdflush+0x3b/0x60
kernel: [26234.187392]    [<c10d187c>] try_to_free_pages+0x26c/0x3a0
kernel: [26234.187392]    [<c10c9f53>] __alloc_pages_nodemask+0x313/0x550
kernel: [26234.187392]    [<c10dd8eb>] handle_mm_fault+0x42b/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c105f87a>] prepare_to_wait+0x2a/0x80
kernel: [26234.187392]    [<c10d9988>] congestion_wait+0x58/0x90
kernel: [26234.187392]    [<c10ca00a>] __alloc_pages_nodemask+0x3ca/0x550
kernel: [26234.187392]    [<c10dd8eb>] handle_mm_fault+0x42b/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c10509f2>] lock_timer_base+0x32/0x70
kernel: [26234.187392]    [<c1418cae>] schedule_timeout+0x7e/0x1e0
kernel: [26234.187392]    [<c1417b41>] io_schedule_timeout+0x61/0xc0
kernel: [26234.187392]    [<c10d998f>] congestion_wait+0x5f/0x90
kernel: [26234.187392]    [<c10ca00a>] __alloc_pages_nodemask+0x3ca/0x550
kernel: [26234.187392]    [<c10dd8eb>] handle_mm_fault+0x42b/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c105142b>] del_timer_sync+0x4b/0xb0
kernel: [26234.187392]    [<c1418d3c>] schedule_timeout+0x10c/0x1e0
kernel: [26234.187392]    [<c1417b41>] io_schedule_timeout+0x61/0xc0
kernel: [26234.187392]    [<c10d998f>] congestion_wait+0x5f/0x90
kernel: [26234.187392]    [<c10ca00a>] __alloc_pages_nodemask+0x3ca/0x550
kernel: [26234.187392]    [<c10dd8eb>] handle_mm_fault+0x42b/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   -> (&(REISERFS_I(inode)->i_mmap)#2){+.+...} ops: 0 {
kernel: [26234.187392]      HARDIRQ-ON-W at:
kernel: [26234.187392]                                            [<c1077409>] __lock_acquire+0xaa9/0x1840
kernel: [26234.187392]                                            [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                            [<c141981c>] mutex_lock_nested+0x5c/0x2e0
kernel: [26234.187392]                                            [<c116b7cb>] reiserfs_file_release+0x6b/0x400
kernel: [26234.187392]                                            [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]                                            [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]                                            [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]                                            [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]                                            [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                            [<ffffffff>] 0xffffffff
kernel: [26234.187392]      SOFTIRQ-ON-W at:
kernel: [26234.187392]                                            [<c107742f>] __lock_acquire+0xacf/0x1840
kernel: [26234.187392]                                            [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                            [<c141981c>] mutex_lock_nested+0x5c/0x2e0
kernel: [26234.187392]                                            [<c116b7cb>] reiserfs_file_release+0x6b/0x400
kernel: [26234.187392]                                            [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]                                            [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]                                            [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]                                            [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]                                            [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                            [<ffffffff>] 0xffffffff
kernel: [26234.187392]      INITIAL USE at:
kernel: [26234.187392]                                           [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                           [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                           [<c141981c>] mutex_lock_nested+0x5c/0x2e0
kernel: [26234.187392]                                           [<c116b7cb>] reiserfs_file_release+0x6b/0x400
kernel: [26234.187392]                                           [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]                                           [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]                                           [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]                                           [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]                                           [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                           [<ffffffff>] 0xffffffff
kernel: [26234.187392]    }
kernel: [26234.187392]    ... key      at: [<c1cf7620>] __key.29631+0x0/0x8
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141981c>] mutex_lock_nested+0x5c/0x2e0
kernel: [26234.187392]    [<c118558f>] do_journal_begin_r+0x7f/0x330
kernel: [26234.187392]    [<c11858ce>] journal_begin+0x8e/0x150
kernel: [26234.187392]    [<c116b7f4>] reiserfs_file_release+0x94/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10fe5f2>] inode_add_bytes+0x32/0xc0
kernel: [26234.187392]    [<c117bb19>] reiserfs_insert_item+0x139/0x3f0
kernel: [26234.187392]    [<c117ea1b>] indirect2direct+0x21b/0x2f0
kernel: [26234.187392]    [<c117d6f1>] reiserfs_cut_from_item+0x3e1/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c117eb5e>] reiserfs_unmap_buffer+0x6e/0xe0
kernel: [26234.187392]    [<c117d859>] reiserfs_cut_from_item+0x549/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]    [<c1417c81>] schedule+0xe1/0xc10
kernel: [26234.187392]    [<c103ea66>] __cond_resched+0x26/0x60
kernel: [26234.187392]    [<c1418902>] _cond_resched+0x42/0x50
kernel: [26234.187392]    [<c1121cca>] __getblk+0x3a/0x390
kernel: [26234.187392]    [<c11257cf>] __bread+0x1f/0xc0
kernel: [26234.187392]    [<c115cc8b>] reiserfs_read_bitmap_block+0x5b/0x140
kernel: [26234.187392]    [<c115db14>] T.464+0x74/0x340
kernel: [26234.187392]    [<c115e778>] reiserfs_allocate_blocknrs+0x998/0x1120
kernel: [26234.187392]    [<c116dee1>] get_empty_nodes+0x111/0x1a0
kernel: [26234.187392]    [<c116f1c8>] fix_nodes+0x468/0x1380
kernel: [26234.187392]    [<c117bc18>] reiserfs_insert_item+0x238/0x3f0
kernel: [26234.187392]    [<c117ea1b>] indirect2direct+0x21b/0x2f0
kernel: [26234.187392]    [<c117d6f1>] reiserfs_cut_from_item+0x3e1/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]    [<c10c37b5>] add_to_page_cache_locked+0x55/0xc0
kernel: [26234.187392]    [<c10c3858>] add_to_page_cache_lru+0x38/0x90
kernel: [26234.187392]    [<c10c40fa>] find_or_create_page+0x6a/0xb0
kernel: [26234.187392]    [<c1121df1>] __getblk+0x161/0x390
kernel: [26234.187392]    [<c116df1b>] get_empty_nodes+0x14b/0x1a0
kernel: [26234.187392]    [<c116f1c8>] fix_nodes+0x468/0x1380
kernel: [26234.187392]    [<c117bc18>] reiserfs_insert_item+0x238/0x3f0
kernel: [26234.187392]    [<c117ea1b>] indirect2direct+0x21b/0x2f0
kernel: [26234.187392]    [<c117d6f1>] reiserfs_cut_from_item+0x3e1/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]    [<c10cd5cb>] ____pagevec_lru_add+0xeb/0x160
kernel: [26234.187392]    [<c10cd6b8>] __lru_cache_add+0x78/0x90
kernel: [26234.187392]    [<c10c3873>] add_to_page_cache_lru+0x53/0x90
kernel: [26234.187392]    [<c10c40fa>] find_or_create_page+0x6a/0xb0
kernel: [26234.187392]    [<c1121df1>] __getblk+0x161/0x390
kernel: [26234.187392]    [<c116df1b>] get_empty_nodes+0x14b/0x1a0
kernel: [26234.187392]    [<c116f1c8>] fix_nodes+0x468/0x1380
kernel: [26234.187392]    [<c117bc18>] reiserfs_insert_item+0x238/0x3f0
kernel: [26234.187392]    [<c117ea1b>] indirect2direct+0x21b/0x2f0
kernel: [26234.187392]    [<c117d6f1>] reiserfs_cut_from_item+0x3e1/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1121ee5>] __getblk+0x255/0x390
kernel: [26234.187392]    [<c116df1b>] get_empty_nodes+0x14b/0x1a0
kernel: [26234.187392]    [<c116f1c8>] fix_nodes+0x468/0x1380
kernel: [26234.187392]    [<c117bc18>] reiserfs_insert_item+0x238/0x3f0
kernel: [26234.187392]    [<c117ea1b>] indirect2direct+0x21b/0x2f0
kernel: [26234.187392]    [<c117d6f1>] reiserfs_cut_from_item+0x3e1/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]    [<c123ba05>] __make_request+0x45/0x3c0
kernel: [26234.187392]    [<c1238b20>] generic_make_request+0x390/0x580
kernel: [26234.187392]    [<c1238d7e>] submit_bio+0x6e/0x110
kernel: [26234.187392]    [<c1121225>] submit_bh+0x105/0x150
kernel: [26234.187392]    [<c1125819>] __bread+0x69/0xc0
kernel: [26234.187392]    [<c116dd33>] get_neighbors+0x163/0x200
kernel: [26234.187392]    [<c116f1b7>] fix_nodes+0x457/0x1380
kernel: [26234.187392]    [<c117bc18>] reiserfs_insert_item+0x238/0x3f0
kernel: [26234.187392]    [<c117ea1b>] indirect2direct+0x21b/0x2f0
kernel: [26234.187392]    [<c117d6f1>] reiserfs_cut_from_item+0x3e1/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c105f87a>] prepare_to_wait+0x2a/0x80
kernel: [26234.187392]    [<c141908a>] __wait_on_bit+0x4a/0xa0
kernel: [26234.187392]    [<c1419184>] out_of_line_wait_on_bit+0xa4/0xc0
kernel: [26234.187392]    [<c1122b0a>] __wait_on_buffer+0x2a/0x50
kernel: [26234.187392]    [<c1125832>] __bread+0x82/0xc0
kernel: [26234.187392]    [<c116dd33>] get_neighbors+0x163/0x200
kernel: [26234.187392]    [<c116f1b7>] fix_nodes+0x457/0x1380
kernel: [26234.187392]    [<c117bc18>] reiserfs_insert_item+0x238/0x3f0
kernel: [26234.187392]    [<c117ea1b>] indirect2direct+0x21b/0x2f0
kernel: [26234.187392]    [<c117d6f1>] reiserfs_cut_from_item+0x3e1/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c10a982e>] delayacct_end+0x7e/0xd0
kernel: [26234.187392]    [<c10a9908>] __delayacct_blkio_end+0x38/0x70
kernel: [26234.187392]    [<c1418827>] io_schedule+0x77/0xb0
kernel: [26234.187392]    [<c1122bf5>] sync_buffer+0x45/0x60
kernel: [26234.187392]    [<c141909d>] __wait_on_bit+0x5d/0xa0
kernel: [26234.187392]    [<c1419184>] out_of_line_wait_on_bit+0xa4/0xc0
kernel: [26234.187392]    [<c1122b0a>] __wait_on_buffer+0x2a/0x50
kernel: [26234.187392]    [<c1125832>] __bread+0x82/0xc0
kernel: [26234.187392]    [<c116dd33>] get_neighbors+0x163/0x200
kernel: [26234.187392]    [<c116f1b7>] fix_nodes+0x457/0x1380
kernel: [26234.187392]    [<c117bc18>] reiserfs_insert_item+0x238/0x3f0
kernel: [26234.187392]    [<c117ea1b>] indirect2direct+0x21b/0x2f0
kernel: [26234.187392]    [<c117d6f1>] reiserfs_cut_from_item+0x3e1/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10f32ff>] cache_alloc_refill+0x9f/0x6a0
kernel: [26234.187392]    [<c10f3d2c>] __kmalloc+0x1ec/0x240
kernel: [26234.187392]    [<c116ee89>] fix_nodes+0x129/0x1380
kernel: [26234.187392]    [<c117d43a>] reiserfs_cut_from_item+0x12a/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10f32ff>] cache_alloc_refill+0x9f/0x6a0
kernel: [26234.187392]    [<c10f30a5>] kmem_cache_alloc+0x185/0x200
kernel: [26234.187392]    [<c1180c6b>] allocate_bitmap_node+0x2b/0xd0
kernel: [26234.187392]    [<c118531c>] journal_mark_freed+0x23c/0x300
kernel: [26234.187392]    [<c115da30>] reiserfs_free_block+0x60/0xd0
kernel: [26234.187392]    [<c117cc2f>] prepare_for_delete_or_cut+0x3ff/0x700
kernel: [26234.187392]    [<c117d406>] reiserfs_cut_from_item+0xf6/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10c9784>] T.1313+0x34/0xa0
kernel: [26234.187392]    [<c10c9a28>] get_page_from_freelist+0x238/0x450
kernel: [26234.187392]    [<c10c9d2f>] __alloc_pages_nodemask+0xef/0x550
kernel: [26234.187392]    [<c10f35e3>] cache_alloc_refill+0x383/0x6a0
kernel: [26234.187392]    [<c10f3d2c>] __kmalloc+0x1ec/0x240
kernel: [26234.187392]    [<c116ee89>] fix_nodes+0x129/0x1380
kernel: [26234.187392]    [<c117d43a>] reiserfs_cut_from_item+0x12a/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10da9bf>] kmap_high+0x1f/0x1d0
kernel: [26234.187392]    [<c102a9d7>] kmap+0x77/0x80
kernel: [26234.187392]    [<c117e8ef>] indirect2direct+0xef/0x2f0
kernel: [26234.187392]    [<c117d6f1>] reiserfs_cut_from_item+0x3e1/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1324670>] scsi_request_fn+0x150/0x500
kernel: [26234.187392]    [<c123b5a9>] __generic_unplug_device+0x39/0x60
kernel: [26234.187392]    [<c123b89f>] generic_unplug_device+0x2f/0x60
kernel: [26234.187392]    [<c1237d71>] blk_unplug+0x31/0x70
kernel: [26234.187392]    [<c1237dca>] blk_backing_dev_unplug+0x1a/0x40
kernel: [26234.187392]    [<c1122bee>] sync_buffer+0x3e/0x60
kernel: [26234.187392]    [<c141909d>] __wait_on_bit+0x5d/0xa0
kernel: [26234.187392]    [<c1419184>] out_of_line_wait_on_bit+0xa4/0xc0
kernel: [26234.187392]    [<c1122b0a>] __wait_on_buffer+0x2a/0x50
kernel: [26234.187392]    [<c1125832>] __bread+0x82/0xc0
kernel: [26234.187392]    [<c116dc95>] get_neighbors+0xc5/0x200
kernel: [26234.187392]    [<c116f1b7>] fix_nodes+0x457/0x1380
kernel: [26234.187392]    [<c117bc18>] reiserfs_insert_item+0x238/0x3f0
kernel: [26234.187392]    [<c117ea1b>] indirect2direct+0x21b/0x2f0
kernel: [26234.187392]    [<c117d6f1>] reiserfs_cut_from_item+0x3e1/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1338506>] ata_scsi_queuecmd+0x36/0x250
kernel: [26234.187392]    [<c131d8b9>] scsi_dispatch_cmd+0x169/0x280
kernel: [26234.187392]    [<c13248b5>] scsi_request_fn+0x395/0x500
kernel: [26234.187392]    [<c123b5a9>] __generic_unplug_device+0x39/0x60
kernel: [26234.187392]    [<c123b89f>] generic_unplug_device+0x2f/0x60
kernel: [26234.187392]    [<c1237d71>] blk_unplug+0x31/0x70
kernel: [26234.187392]    [<c1237dca>] blk_backing_dev_unplug+0x1a/0x40
kernel: [26234.187392]    [<c1122bee>] sync_buffer+0x3e/0x60
kernel: [26234.187392]    [<c141909d>] __wait_on_bit+0x5d/0xa0
kernel: [26234.187392]    [<c1419184>] out_of_line_wait_on_bit+0xa4/0xc0
kernel: [26234.187392]    [<c1122b0a>] __wait_on_buffer+0x2a/0x50
kernel: [26234.187392]    [<c1125832>] __bread+0x82/0xc0
kernel: [26234.187392]    [<c116dc95>] get_neighbors+0xc5/0x200
kernel: [26234.187392]    [<c116f1b7>] fix_nodes+0x457/0x1380
kernel: [26234.187392]    [<c117bc18>] reiserfs_insert_item+0x238/0x3f0
kernel: [26234.187392]    [<c117ea1b>] indirect2direct+0x21b/0x2f0
kernel: [26234.187392]    [<c117d6f1>] reiserfs_cut_from_item+0x3e1/0x880
kernel: [26234.187392]    [<c117df66>] reiserfs_do_truncate+0x3d6/0x6a0
kernel: [26234.187392]    [<c1166b15>] reiserfs_truncate_file+0x1c5/0x3f0
kernel: [26234.187392]    [<c116b977>] reiserfs_file_release+0x217/0x400
kernel: [26234.187392]    [<c10fba83>] __fput+0xf3/0x200
kernel: [26234.187392]    [<c10fbbb2>] fput+0x22/0x40
kernel: [26234.187392]    [<c10f7a79>] filp_close+0x49/0x90
kernel: [26234.187392]    [<c10f7b37>] sys_close+0x77/0xd0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141981c>] mutex_lock_nested+0x5c/0x2e0
kernel: [26234.187392]    [<c116bb9a>] reiserfs_file_mmap+0x3a/0x70
kernel: [26234.187392]    [<c10e2b90>] mmap_region+0x3b0/0x530
kernel: [26234.187392]    [<c10e2fcb>] do_mmap_pgoff+0x2bb/0x380
kernel: [26234.187392]    [<c10086ef>] sys_mmap2+0xef/0x110
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10e9442>] valid_swaphandles+0x62/0x170
kernel: [26234.187392]    [<c10e8ea9>] swapin_readahead+0x29/0xa0
kernel: [26234.187392]    [<c10dd9a6>] handle_mm_fault+0x4e6/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]    [<c10e8d0e>] add_to_swap_cache+0x4e/0xd0
kernel: [26234.187392]    [<c10e8df8>] read_swap_cache_async+0x68/0xf0
kernel: [26234.187392]    [<c10e8eed>] swapin_readahead+0x6d/0xa0
kernel: [26234.187392]    [<c10dd9a6>] handle_mm_fault+0x4e6/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   -> (swap_unplug_sem){.+.+..} ops: 0 {
kernel: [26234.187392]      HARDIRQ-ON-R at:
kernel: [26234.187392]                                            [<c1076b1b>] __lock_acquire+0x1bb/0x1840
kernel: [26234.187392]                                            [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                            [<c141a226>] down_read+0x46/0xa0
kernel: [26234.187392]                                            [<c10eca3f>] swap_unplug_io_fn+0x1f/0xa0
kernel: [26234.187392]                                            [<c1120ab5>] block_sync_page+0x45/0x70
kernel: [26234.187392]                                            [<c10c341d>] sync_page+0x3d/0x70
kernel: [26234.187392]                                            [<c1418f27>] __wait_on_bit_lock+0x57/0xb0
kernel: [26234.187392]                                            [<c10c338b>] __lock_page+0x7b/0xa0
kernel: [26234.187392]                                            [<c10dda88>] handle_mm_fault+0x5c8/0x5d0
kernel: [26234.187392]                                            [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]                                            [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]                                            [<ffffffff>] 0xffffffff
kernel: [26234.187392]      SOFTIRQ-ON-R at:
kernel: [26234.187392]                                            [<c107742f>] __lock_acquire+0xacf/0x1840
kernel: [26234.187392]                                            [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                            [<c141a226>] down_read+0x46/0xa0
kernel: [26234.187392]                                            [<c10eca3f>] swap_unplug_io_fn+0x1f/0xa0
kernel: [26234.187392]                                            [<c1120ab5>] block_sync_page+0x45/0x70
kernel: [26234.187392]                                            [<c10c341d>] sync_page+0x3d/0x70
kernel: [26234.187392]                                            [<c1418f27>] __wait_on_bit_lock+0x57/0xb0
kernel: [26234.187392]                                            [<c10c338b>] __lock_page+0x7b/0xa0
kernel: [26234.187392]                                            [<c10dda88>] handle_mm_fault+0x5c8/0x5d0
kernel: [26234.187392]                                            [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]                                            [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]                                            [<ffffffff>] 0xffffffff
kernel: [26234.187392]      INITIAL USE at:
kernel: [26234.187392]                                           [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                           [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                           [<c141a226>] down_read+0x46/0xa0
kernel: [26234.187392]                                           [<c10eca3f>] swap_unplug_io_fn+0x1f/0xa0
kernel: [26234.187392]                                           [<c1120ab5>] block_sync_page+0x45/0x70
kernel: [26234.187392]                                           [<c10c341d>] sync_page+0x3d/0x70
kernel: [26234.187392]                                           [<c1418f27>] __wait_on_bit_lock+0x57/0xb0
kernel: [26234.187392]                                           [<c10c338b>] __lock_page+0x7b/0xa0
kernel: [26234.187392]                                           [<c10dda88>] handle_mm_fault+0x5c8/0x5d0
kernel: [26234.187392]                                           [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]                                           [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]                                           [<ffffffff>] 0xffffffff
kernel: [26234.187392]    }
kernel: [26234.187392]    ... key      at: [<c1597e50>] swap_unplug_sem+0x30/0x60
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]    [<c123b898>] generic_unplug_device+0x28/0x60
kernel: [26234.187392]    [<c1237d71>] blk_unplug+0x31/0x70
kernel: [26234.187392]    [<c1237dca>] blk_backing_dev_unplug+0x1a/0x40
kernel: [26234.187392]    [<c10eca85>] swap_unplug_io_fn+0x65/0xa0
kernel: [26234.187392]    [<c1120ab5>] block_sync_page+0x45/0x70
kernel: [26234.187392]    [<c10c341d>] sync_page+0x3d/0x70
kernel: [26234.187392]    [<c1418f27>] __wait_on_bit_lock+0x57/0xb0
kernel: [26234.187392]    [<c10c338b>] __lock_page+0x7b/0xa0
kernel: [26234.187392]    [<c10dda88>] handle_mm_fault+0x5c8/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1324670>] scsi_request_fn+0x150/0x500
kernel: [26234.187392]    [<c123b5a9>] __generic_unplug_device+0x39/0x60
kernel: [26234.187392]    [<c123b89f>] generic_unplug_device+0x2f/0x60
kernel: [26234.187392]    [<c1237d71>] blk_unplug+0x31/0x70
kernel: [26234.187392]    [<c1237dca>] blk_backing_dev_unplug+0x1a/0x40
kernel: [26234.187392]    [<c10eca85>] swap_unplug_io_fn+0x65/0xa0
kernel: [26234.187392]    [<c1120ab5>] block_sync_page+0x45/0x70
kernel: [26234.187392]    [<c10c341d>] sync_page+0x3d/0x70
kernel: [26234.187392]    [<c1418f27>] __wait_on_bit_lock+0x57/0xb0
kernel: [26234.187392]    [<c10c338b>] __lock_page+0x7b/0xa0
kernel: [26234.187392]    [<c10dda88>] handle_mm_fault+0x5c8/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]    ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1338506>] ata_scsi_queuecmd+0x36/0x250
kernel: [26234.187392]    [<c131d8b9>] scsi_dispatch_cmd+0x169/0x280
kernel: [26234.187392]    [<c13248b5>] scsi_request_fn+0x395/0x500
kernel: [26234.187392]    [<c123b5a9>] __generic_unplug_device+0x39/0x60
kernel: [26234.187392]    [<c123b89f>] generic_unplug_device+0x2f/0x60
kernel: [26234.187392]    [<c1237d71>] blk_unplug+0x31/0x70
kernel: [26234.187392]    [<c1237dca>] blk_backing_dev_unplug+0x1a/0x40
kernel: [26234.187392]    [<c10eca85>] swap_unplug_io_fn+0x65/0xa0
kernel: [26234.187392]    [<c1120ab5>] block_sync_page+0x45/0x70
kernel: [26234.187392]    [<c10c341d>] sync_page+0x3d/0x70
kernel: [26234.187392]    [<c1418f27>] __wait_on_bit_lock+0x57/0xb0
kernel: [26234.187392]    [<c10c338b>] __lock_page+0x7b/0xa0
kernel: [26234.187392]    [<c10dda88>] handle_mm_fault+0x5c8/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141a226>] down_read+0x46/0xa0
kernel: [26234.187392]    [<c10eca3f>] swap_unplug_io_fn+0x1f/0xa0
kernel: [26234.187392]    [<c1120ab5>] block_sync_page+0x45/0x70
kernel: [26234.187392]    [<c10c341d>] sync_page+0x3d/0x70
kernel: [26234.187392]    [<c1418f27>] __wait_on_bit_lock+0x57/0xb0
kernel: [26234.187392]    [<c10c338b>] __lock_page+0x7b/0xa0
kernel: [26234.187392]    [<c10dda88>] handle_mm_fault+0x5c8/0x5d0
kernel: [26234.187392]    [<c10258c6>] do_page_fault+0xe6/0x260
kernel: [26234.187392]    [<c141c06f>] error_code+0x7f/0x84
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]  ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c10db1a4>] might_fault+0x74/0xb0
kernel: [26234.187392]    [<c1258a31>] copy_to_user+0x41/0x130
kernel: [26234.187392]    [<c12dee80>] tty_ioctl+0x370/0x8e0
kernel: [26234.187392]    [<c1109d24>] vfs_ioctl+0x24/0xa0
kernel: [26234.187392]    [<c1109e23>] do_vfs_ioctl+0x83/0x5e0
kernel: [26234.187392]    [<c110a3ff>] sys_ioctl+0x7f/0xa0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]  -> (&tty->ctrl_lock){......} ops: 0 {
kernel: [26234.187392]     INITIAL USE at:
kernel: [26234.187392]                                         [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                         [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                         [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]                                         [<c12dce53>] __proc_set_tty+0x33/0x130
kernel: [26234.187392]                                         [<c12df271>] tty_ioctl+0x761/0x8e0
kernel: [26234.187392]                                         [<c1109d24>] vfs_ioctl+0x24/0xa0
kernel: [26234.187392]                                         [<c1109e23>] do_vfs_ioctl+0x83/0x5e0
kernel: [26234.187392]                                         [<c110a3ff>] sys_ioctl+0x7f/0xa0
kernel: [26234.187392]                                         [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]                                         [<ffffffff>] 0xffffffff
kernel: [26234.187392]   }
kernel: [26234.187392]   ... key      at: [<c1cfce34>] __key.27619+0x0/0x8
kernel: [26234.187392]  ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c12ddebd>] tty_do_resize+0x7d/0xe0
kernel: [26234.187392]    [<c12df204>] tty_ioctl+0x6f4/0x8e0
kernel: [26234.187392]    [<c1109d24>] vfs_ioctl+0x24/0xa0
kernel: [26234.187392]    [<c1109e23>] do_vfs_ioctl+0x83/0x5e0
kernel: [26234.187392]    [<c110a3ff>] sys_ioctl+0x7f/0xa0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]  ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1030f97>] task_rq_lock+0x47/0x90
kernel: [26234.187392]    [<c103de4d>] try_to_wake_up+0x8d/0x390
kernel: [26234.187392]    [<c103e1db>] wake_up_process+0x1b/0x40
kernel: [26234.187392]    [<c104a15f>] wakeup_softirqd+0x2f/0x50
kernel: [26234.187392]    [<c104a405>] __tasklet_schedule+0x95/0xb0
kernel: [26234.187392]    [<f90be38b>] ppp_asynctty_wakeup+0x6b/0x80 [ppp_async]
kernel: [26234.187392]    [<c12de902>] tty_wakeup+0x72/0x90
kernel: [26234.187392]    [<c12e70d3>] pty_unthrottle+0x23/0x50
kernel: [26234.187392]    [<c12e3b22>] tty_unthrottle+0x42/0x70
kernel: [26234.187392]    [<c12e1c2f>] n_tty_read+0x48f/0x730
kernel: [26234.187392]    [<c12dcc20>] tty_read+0xa0/0xe0
kernel: [26234.187392]    [<c10faf2b>] vfs_read+0xbb/0x1c0
kernel: [26234.187392]    [<c10fb138>] sys_read+0x58/0xa0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]  -> (&sighand->siglock){-.-.-.} ops: 0 {
kernel: [26234.187392]     IN-HARDIRQ-W at:
kernel: [26234.187392]                                          [<c10774fd>] __lock_acquire+0xb9d/0x1840
kernel: [26234.187392]                                          [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                          [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]                                          [<c10533ac>] lock_task_sighand+0x6c/0xc0
kernel: [26234.187392]                                          [<c10546d1>] group_send_sig_info+0x41/0x90
kernel: [26234.187392]                                          [<c1054787>] kill_pid_info+0x67/0xb0
kernel: [26234.187392]                                          [<c10487f1>] it_real_fn+0x21/0x40
kernel: [26234.187392]                                          [<c106337f>] __run_hrtimer+0x6f/0xd0
kernel: [26234.187392]                                          [<c1064485>] hrtimer_interrupt+0x145/0x270
kernel: [26234.187392]                                          [<c106f590>] tick_do_broadcast+0x40/0x80
kernel: [26234.187392]                                          [<c106f6de>] tick_handle_oneshot_broadcast+0x10e/0x170
kernel: [26234.187392]                                          [<c10067ba>] timer_interrupt+0x4a/0x70
kernel: [26234.187392]                                          [<c10a3acc>] handle_IRQ_event+0x4c/0x160
kernel: [26234.187392]                                          [<c10a581b>] handle_edge_irq+0xbb/0x150
kernel: [26234.187392]                                          [<c10062b8>] handle_irq+0x28/0x50
kernel: [26234.187392]                                          [<c1005743>] do_IRQ+0x53/0xd0
kernel: [26234.187392]                                          [<c1003975>] common_interrupt+0x35/0x3c
kernel: [26234.187392]                                          [<c136898e>] cpuidle_idle_call+0x8e/0xf0
kernel: [26234.187392]                                          [<c10020a6>] cpu_idle+0xa6/0xf0
kernel: [26234.187392]                                          [<c1405a75>] rest_init+0x65/0x80
kernel: [26234.187392]                                          [<c15dea85>] start_kernel+0x353/0x36b
kernel: [26234.187392]                                          [<c15de088>] __init_begin+0x88/0xa1
kernel: [26234.187392]                                          [<ffffffff>] 0xffffffff
kernel: [26234.187392]     IN-SOFTIRQ-W at:
kernel: [26234.187392]                                          [<c10773ec>] __lock_acquire+0xa8c/0x1840
kernel: [26234.187392]                                          [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                          [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]                                          [<c10533ac>] lock_task_sighand+0x6c/0xc0
kernel: [26234.187392]                                          [<c10546d1>] group_send_sig_info+0x41/0x90
kernel: [26234.187392]                                          [<c1108f51>] send_sigio+0x181/0x280
kernel: [26234.187392]                                          [<c1109097>] __kill_fasync+0x47/0x80
kernel: [26234.187392]                                          [<c110910b>] kill_fasync+0x3b/0x70
kernel: [26234.187392]                                          [<c134d931>] mousedev_notify_readers+0x1f1/0x270
kernel: [26234.187392]                                          [<c134da6a>] mousedev_event+0xba/0x4c0
kernel: [26234.187392]                                          [<c134a2dc>] input_pass_event+0xdc/0xf0
kernel: [26234.187392]                                          [<c134ba31>] input_handle_event+0x91/0x450
kernel: [26234.187392]                                          [<c134bf4e>] input_event+0x7e/0x90
kernel: [26234.187392]                                          [<fd337e53>] hidinput_report_event+0x43/0x70 [hid]
kernel: [26234.187392]                                          [<fd335484>] hid_report_raw_event+0x324/0x4f0 [hid]
kernel: [26234.187392]                                          [<fd335744>] hid_input_report+0xf4/0x130 [hid]
kernel: [26234.187392]                                          [<fd3547b5>] hid_irq_in+0x1e5/0x230 [usbhid]
kernel: [26234.187392]                                          [<f90d5ce7>] usb_hcd_giveback_urb+0x57/0xe0 [usbcore]
kernel: [26234.187392]                                          [<fd22bb78>] uhci_giveback_urb+0x98/0x240 [uhci_hcd]
kernel: [26234.187392]                                          [<fd22c25d>] uhci_scan_schedule+0x3dd/0xa30 [uhci_hcd]
kernel: [26234.187392]                                          [<fd22d31f>] uhci_hub_status_data+0x3f/0x1b0 [uhci_hcd]
kernel: [26234.187392]                                          [<f90d6107>] usb_hcd_poll_rh_status+0x47/0x150 [usbcore]
kernel: [26234.187392]                                          [<f90d6837>] rh_timer_func+0x17/0x30 [usbcore]
kernel: [26234.187392]                                          [<c1050745>] run_timer_softirq+0x185/0x270
kernel: [26234.187392]                                          [<c104acca>] __do_softirq+0xaa/0x1f0
kernel: [26234.187392]                                          [<c104ae85>] do_softirq+0x75/0x90
kernel: [26234.187392]                                          [<c104b035>] irq_exit+0x85/0xa0
kernel: [26234.187392]                                          [<c101c161>] smp_apic_timer_interrupt+0x61/0xb0
kernel: [26234.187392]                                          [<c1003cf6>] apic_timer_interrupt+0x36/0x3c
kernel: [26234.187392]                                          [<c136898e>] cpuidle_idle_call+0x8e/0xf0
kernel: [26234.187392]                                          [<c10020a6>] cpu_idle+0xa6/0xf0
kernel: [26234.187392]                                          [<c14142f8>] start_secondary+0x1c5/0x1dc
kernel: [26234.187392]                                          [<ffffffff>] 0xffffffff
kernel: [26234.187392]     IN-RECLAIM_FS-W at:
kernel: [26234.187392]                                             [<c1076b78>] __lock_acquire+0x218/0x1840
kernel: [26234.187392]                                             [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                             [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]                                             [<c10533ac>] lock_task_sighand+0x6c/0xc0
kernel: [26234.187392]                                             [<c10546d1>] group_send_sig_info+0x41/0x90
kernel: [26234.187392]                                             [<c1054787>] kill_pid_info+0x67/0xb0
kernel: [26234.187392]                                             [<c10487f1>] it_real_fn+0x21/0x40
kernel: [26234.187392]                                             [<c106337f>] __run_hrtimer+0x6f/0xd0
kernel: [26234.187392]                                             [<c1064485>] hrtimer_interrupt+0x145/0x270
kernel: [26234.187392]                                             [<c101c15c>] smp_apic_timer_interrupt+0x5c/0xb0
kernel: [26234.187392]                                             [<c1003cf6>] apic_timer_interrupt+0x36/0x3c
kernel: [26234.187392]                                             [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]                                             [<c10e468b>] page_check_address+0x8b/0xe0
kernel: [26234.187392]                                             [<c10e4948>] page_referenced_one+0x58/0x100
kernel: [26234.187392]                                             [<c10e4a72>] page_referenced_file+0x82/0xc0
kernel: [26234.187392]                                             [<c10e5653>] page_referenced+0x133/0x150
kernel: [26234.187392]                                             [<c10cfb96>] shrink_page_list+0x176/0x7a0
kernel: [26234.187392]                                             [<c10d045f>] shrink_list+0x29f/0x5d0
kernel: [26234.187392]                                             [<c10d09b2>] shrink_zone+0x222/0x330
kernel: [26234.187392]                                             [<c10d1241>] kswapd+0x5d1/0x650
kernel: [26234.187392]                                             [<c105f244>] kthread+0x84/0x90
kernel: [26234.187392]                                             [<c1003edb>] kernel_thread_helper+0x7/0x1c
kernel: [26234.187392]                                             [<ffffffff>] 0xffffffff
kernel: [26234.187392]     INITIAL USE at:
kernel: [26234.187392]                                         [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                         [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                         [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]                                         [<c10535a9>] flush_signals+0x29/0x60
kernel: [26234.187392]                                         [<c1053616>] ignore_signals+0x36/0x50
kernel: [26234.187392]                                         [<c105f0d3>] kthreadd+0x33/0x120
kernel: [26234.187392]                                         [<c1003edb>] kernel_thread_helper+0x7/0x1c
kernel: [26234.187392]                                         [<ffffffff>] 0xffffffff
kernel: [26234.187392]   }
kernel: [26234.187392]   ... key      at: [<c1790674>] __key.42940+0x0/0x8
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c1030ae1>] __wake_up_sync_key+0x31/0x80
kernel: [26234.187392]    [<c1030b4f>] __wake_up_sync+0x1f/0x40
kernel: [26234.187392]    [<c10545cb>] do_notify_parent+0x18b/0x250
kernel: [26234.187392]    [<c1047ee2>] do_exit+0x432/0x6d0
kernel: [26234.187392]    [<c10586de>] ____call_usermodehelper+0x12e/0x140
kernel: [26234.187392]    [<c1003edb>] kernel_thread_helper+0x7/0x1c
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c1060be5>] thread_group_cputimer+0x35/0x110
kernel: [26234.187392]    [<c10626d0>] posix_cpu_timers_exit_group+0x20/0x70
kernel: [26234.187392]    [<c10468cf>] release_task+0x34f/0x450
kernel: [26234.187392]    [<c1047fa9>] do_exit+0x4f9/0x6d0
kernel: [26234.187392]    [<c10586de>] ____call_usermodehelper+0x12e/0x140
kernel: [26234.187392]    [<c1003edb>] kernel_thread_helper+0x7/0x1c
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   -> (pidmap_lock){......} ops: 0 {
kernel: [26234.187392]      INITIAL USE at:
kernel: [26234.187392]                                           [<c1076cec>] __lock_acquire+0x38c/0x1840
kernel: [26234.187392]                                           [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]                                           [<c141b867>] _spin_lock_irq+0x47/0x90
kernel: [26234.187392]                                           [<c105beb3>] alloc_pid+0x283/0x3d0
kernel: [26234.187392]                                           [<c104243e>] copy_process+0x84e/0x11e0
kernel: [26234.187392]                                           [<c1042e54>] do_fork+0x84/0x3a0
kernel: [26234.187392]                                           [<c1001986>] kernel_thread+0x96/0xc0
kernel: [26234.187392]                                           [<c1405a32>] rest_init+0x22/0x80
kernel: [26234.187392]                                           [<c15dea85>] start_kernel+0x353/0x36b
kernel: [26234.187392]                                           [<c15de088>] __init_begin+0x88/0xa1
kernel: [26234.187392]                                           [<ffffffff>] 0xffffffff
kernel: [26234.187392]    }
kernel: [26234.187392]    ... key      at: [<c15c5a90>] pidmap_lock+0x10/0x40
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c105c022>] free_pid+0x22/0xc0
kernel: [26234.187392]    [<c105c1fb>] detach_pid+0x6b/0x90
kernel: [26234.187392]    [<c10467c1>] release_task+0x241/0x450
kernel: [26234.187392]    [<c1047fa9>] do_exit+0x4f9/0x6d0
kernel: [26234.187392]    [<c10586de>] ____call_usermodehelper+0x12e/0x140
kernel: [26234.187392]    [<c1003edb>] kernel_thread_helper+0x7/0x1c
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10f32ff>] cache_alloc_refill+0x9f/0x6a0
kernel: [26234.187392]    [<c10f30a5>] kmem_cache_alloc+0x185/0x200
kernel: [26234.187392]    [<c1053011>] __sigqueue_alloc+0x31/0x90
kernel: [26234.187392]    [<c105395f>] __send_signal+0xcf/0x2a0
kernel: [26234.187392]    [<c1053b7a>] send_signal+0x4a/0xa0
kernel: [26234.187392]    [<c1053fef>] __group_send_sig_info+0x1f/0x40
kernel: [26234.187392]    [<c10545ad>] do_notify_parent+0x16d/0x250
kernel: [26234.187392]    [<c1047ee2>] do_exit+0x432/0x6d0
kernel: [26234.187392]    [<c10481c5>] do_group_exit+0x45/0xb0
kernel: [26234.187392]    [<c1048252>] sys_exit_group+0x22/0x40
kernel: [26234.187392]    [<c1003344>] syscall_call+0x7/0xb
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c10638fc>] lock_hrtimer_base+0x2c/0x60
kernel: [26234.187392]    [<c1063956>] hrtimer_get_remaining+0x26/0x70
kernel: [26234.187392]    [<c10482f3>] itimer_get_remtime+0x23/0x80
kernel: [26234.187392]    [<c10483f0>] do_setitimer+0xa0/0x320
kernel: [26234.187392]    [<c1048781>] alarm_setitimer+0x41/0x90
kernel: [26234.187392]    [<c1051039>] sys_alarm+0x19/0x40
kernel: [26234.187392]    [<c1003344>] syscall_call+0x7/0xb
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c1030f97>] task_rq_lock+0x47/0x90
kernel: [26234.187392]    [<c103de4d>] try_to_wake_up+0x8d/0x390
kernel: [26234.187392]    [<c103e1a7>] wake_up_state+0x17/0x30
kernel: [26234.187392]    [<c1053661>] signal_wake_up+0x31/0x60
kernel: [26234.187392]    [<c10537a0>] complete_signal+0x110/0x200
kernel: [26234.187392]    [<c10539e8>] __send_signal+0x158/0x2a0
kernel: [26234.187392]    [<c1053b7a>] send_signal+0x4a/0xa0
kernel: [26234.187392]    [<c1053fef>] __group_send_sig_info+0x1f/0x40
kernel: [26234.187392]    [<c10545ad>] do_notify_parent+0x16d/0x250
kernel: [26234.187392]    [<c1047ee2>] do_exit+0x432/0x6d0
kernel: [26234.187392]    [<c10481c5>] do_group_exit+0x45/0xb0
kernel: [26234.187392]    [<c1048252>] sys_exit_group+0x22/0x40
kernel: [26234.187392]    [<c1003344>] syscall_call+0x7/0xb
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c12dce53>] __proc_set_tty+0x33/0x130
kernel: [26234.187392]    [<c12df271>] tty_ioctl+0x761/0x8e0
kernel: [26234.187392]    [<c1109d24>] vfs_ioctl+0x24/0xa0
kernel: [26234.187392]    [<c1109e23>] do_vfs_ioctl+0x83/0x5e0
kernel: [26234.187392]    [<c110a3ff>] sys_ioctl+0x7f/0xa0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c10a9ba5>] __delayacct_add_tsk+0x1e5/0x3c0
kernel: [26234.187392]    [<c10aa7dd>] taskstats_exit+0x1dd/0x370
kernel: [26234.187392]    [<c1047bb7>] do_exit+0x107/0x6d0
kernel: [26234.187392]    [<c1048292>] sys_exit+0x22/0x30
kernel: [26234.187392]    [<c1003344>] syscall_call+0x7/0xb
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]   ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b751>] _spin_lock+0x41/0x80
kernel: [26234.187392]    [<c10c9784>] T.1313+0x34/0xa0
kernel: [26234.187392]    [<c10c9a28>] get_page_from_freelist+0x238/0x450
kernel: [26234.187392]    [<c10c9d2f>] __alloc_pages_nodemask+0xef/0x550
kernel: [26234.187392]    [<c10f35e3>] cache_alloc_refill+0x383/0x6a0
kernel: [26234.187392]    [<c10f30a5>] kmem_cache_alloc+0x185/0x200
kernel: [26234.187392]    [<c1053011>] __sigqueue_alloc+0x31/0x90
kernel: [26234.187392]    [<c105395f>] __send_signal+0xcf/0x2a0
kernel: [26234.187392]    [<c1053b7a>] send_signal+0x4a/0xa0
kernel: [26234.187392]    [<c1053fef>] __group_send_sig_info+0x1f/0x40
kernel: [26234.187392]    [<c10546e1>] group_send_sig_info+0x51/0x90
kernel: [26234.187392]    [<c1054787>] kill_pid_info+0x67/0xb0
kernel: [26234.187392]    [<c10487f1>] it_real_fn+0x21/0x40
kernel: [26234.187392]    [<c106337f>] __run_hrtimer+0x6f/0xd0
kernel: [26234.187392]    [<c1064485>] hrtimer_interrupt+0x145/0x270
kernel: [26234.187392]    [<c101c15c>] smp_apic_timer_interrupt+0x5c/0xb0
kernel: [26234.187392]    [<c1003cf6>] apic_timer_interrupt+0x36/0x3c
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392]  ... acquired at:
kernel: [26234.187392]    [<c1077a14>] __lock_acquire+0x10b4/0x1840
kernel: [26234.187392]    [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]    [<c141b900>] _spin_lock_irqsave+0x50/0xa0
kernel: [26234.187392]    [<c10533ac>] lock_task_sighand+0x6c/0xc0
kernel: [26234.187392]    [<c10546d1>] group_send_sig_info+0x41/0x90
kernel: [26234.187392]    [<c1054986>] __kill_pgrp_info+0x46/0x80
kernel: [26234.187392]    [<c10549fa>] kill_pgrp+0x3a/0x70
kernel: [26234.187392]    [<c12ddee4>] tty_do_resize+0xa4/0xe0
kernel: [26234.187392]    [<c12df204>] tty_ioctl+0x6f4/0x8e0
kernel: [26234.187392]    [<c1109d24>] vfs_ioctl+0x24/0xa0
kernel: [26234.187392]    [<c1109e23>] do_vfs_ioctl+0x83/0x5e0
kernel: [26234.187392]    [<c110a3ff>] sys_ioctl+0x7f/0xa0
kernel: [26234.187392]    [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [26234.187392]    [<ffffffff>] 0xffffffff
kernel: [26234.187392] 
kernel: [26234.187392] 
kernel: [26234.187392] stack backtrace:
kernel: [26234.187392] Pid: 9804, comm: rtorrent Not tainted 2.6.30-dbgnv-git14 #4
kernel: [26234.187392] Call Trace:
kernel: [26234.187392]  [<c141786b>] ? printk+0x23/0x36
kernel: [26234.187392]  [<c10767d0>] check_usage+0x380/0x420
kernel: [26234.187392]  [<c10768c9>] check_irq_usage+0x59/0xf0
kernel: [26234.187392]  [<c10777b4>] __lock_acquire+0xe54/0x1840
kernel: [26234.187392]  [<c1078241>] lock_acquire+0xa1/0x120
kernel: [26234.187392]  [<c12e3b75>] ? tty_throttle+0x25/0x70
kernel: [26234.187392]  [<c12e3b75>] ? tty_throttle+0x25/0x70
kernel: [26234.187392]  [<c141981c>] mutex_lock_nested+0x5c/0x2e0
kernel: [26234.187392]  [<c12e3b75>] ? tty_throttle+0x25/0x70
kernel: [26234.187392]  [<c12e3b75>] ? tty_throttle+0x25/0x70
kernel: [26234.187392]  [<c10759c8>] ? trace_hardirqs_on_caller+0x68/0x1a0
kernel: [26234.187392]  [<c12e3b75>] tty_throttle+0x25/0x70
kernel: [26234.187392]  [<c12e2477>] n_tty_receive_buf+0x407/0x1220
kernel: [26234.187392]  [<c1032be7>] ? __enqueue_entity+0xb7/0xf0
kernel: [26234.187392]  [<c1075778>] ? mark_held_locks+0x68/0xa0
kernel: [26234.187392]  [<c141b4ef>] ? _spin_unlock_irqrestore+0x3f/0x70
kernel: [26234.187392]  [<c10759c8>] ? trace_hardirqs_on_caller+0x68/0x1a0
kernel: [26234.187392]  [<c1075b19>] ? trace_hardirqs_on+0x19/0x40
kernel: [26234.187392]  [<c12e4af2>] ? tty_ldisc_try+0x42/0x60
kernel: [26234.187392]  [<c12e6fdd>] pty_write+0x7d/0x90
kernel: [26234.187392]  [<f90bec9a>] ppp_async_push+0x3da/0x4d0 [ppp_async]
kernel: [26234.187392]  [<f90bedd8>] ppp_async_send+0x48/0x70 [ppp_async]
kernel: [26234.187392]  [<f90a8996>] ppp_push+0x176/0x5f0 [ppp_generic]
kernel: [26234.187392]  [<c141b4ef>] ? _spin_unlock_irqrestore+0x3f/0x70
kernel: [26234.187392]  [<c10759c8>] ? trace_hardirqs_on_caller+0x68/0x1a0
kernel: [26234.187392]  [<c1075b19>] ? trace_hardirqs_on+0x19/0x40
kernel: [26234.187392]  [<c1379d63>] ? skb_dequeue+0x53/0x80
kernel: [26234.187392]  [<f90a97bd>] ppp_xmit_process+0x3dd/0x570 [ppp_generic]
kernel: [26234.187392]  [<c1075b19>] ? trace_hardirqs_on+0x19/0x40
kernel: [26234.187392]  [<c1379c11>] ? skb_queue_tail+0x41/0x60
kernel: [26234.187392]  [<f90a9ab7>] ppp_start_xmit+0x167/0x1b0 [ppp_generic]
kernel: [26234.187392]  [<c13998ca>] ? __qdisc_run+0x18a/0x250
kernel: [26234.187392]  [<c13846ac>] dev_hard_start_xmit+0x1ec/0x3b0
kernel: [26234.187392]  [<c141b777>] ? _spin_lock+0x67/0x80
kernel: [26234.187392]  [<c13998e4>] __qdisc_run+0x1a4/0x250
kernel: [26234.187392]  [<c1384d17>] dev_queue_xmit+0x377/0x4d0
kernel: [26234.187392]  [<c13849e0>] ? dev_queue_xmit+0x40/0x4d0
kernel: [26234.187392]  [<c13b261d>] ip_finish_output+0x1dd/0x2b0
kernel: [26234.187392]  [<c13b2752>] ip_output+0x62/0xd0
kernel: [26234.187392]  [<c13b1688>] ip_local_out+0x28/0x50
kernel: [26234.187392]  [<c13b1df4>] ip_queue_xmit+0x144/0x390
kernel: [26234.187392]  [<c141b54b>] ? _spin_unlock+0x2b/0x50
kernel: [26234.187392]  [<c10f34d5>] ? cache_alloc_refill+0x275/0x6a0
kernel: [26234.187392]  [<c13ca598>] ? tcp_v4_send_check+0x58/0x100
kernel: [26234.187392]  [<c13c6062>] tcp_transmit_skb+0x3b2/0x750
kernel: [26234.187392]  [<c13c6ac5>] ? tcp_connect+0x225/0x400
kernel: [26234.187392]  [<c13c6bd5>] tcp_connect+0x335/0x400
kernel: [26234.187392]  [<c13cdd1e>] tcp_v4_connect+0x3de/0x4b0
kernel: [26234.187392]  [<c13dbbb2>] inet_stream_connect+0x232/0x290
kernel: [26234.187392]  [<c10db173>] ? might_fault+0x43/0xb0
kernel: [26234.187392]  [<c1373659>] sys_connect+0xc9/0xf0
kernel: [26234.187392]  [<c10db173>] ? might_fault+0x43/0xb0
kernel: [26234.187392]  [<c10db173>] ? might_fault+0x43/0xb0
kernel: [26234.187392]  [<c10db1bf>] ? might_fault+0x8f/0xb0
kernel: [26234.187392]  [<c10db173>] ? might_fault+0x43/0xb0
kernel: [26234.187392]  [<c12588e1>] ? copy_from_user+0x41/0x150
kernel: [26234.187392]  [<c137426d>] sys_socketcall+0x24d/0x290
kernel: [26234.187392]  [<c100328a>] ? sysenter_exit+0xf/0x1a
kernel: [26234.187392]  [<c100325b>] sysenter_do_call+0x12/0x32
...
/USR/SBIN/CRON[9810]: CMD (fetchmail -sk -m '/usr/bin/procmail' > /dev/null 2>&1)
...
kernel: [26764.304211] BUG: scheduling while atomic: pptpgw/4637/0x10000500
kernel: [26764.304221] INFO: lockdep is turned off.
kernel: [26764.304227] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse sbp2 loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device pcspkr snd i2c_i801 psmouse serio_raw rng_core soundcore snd_page_alloc asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod sdhci_pci sdhci mmc_core ohci1394 ata_generic pata_acpi ricoh_mmc uhci_hcd led_class ata_piix ieee1394 ide_pci_generic ehci_hcd usbcore r8169 mii
kernel: [26764.304387] 
kernel: [26764.304398] Pid: 4637, comm: pptpgw Not tainted (2.6.30-dbgnv-git14 #4) F3JC                
kernel: [26764.304407] EIP: 0060:[<c104a3d5>] EFLAGS: 00200246 CPU: 0
kernel: [26764.304423] EIP is at __tasklet_schedule+0x65/0xb0
kernel: [26764.304430] EAX: 00000000 EBX: f6077c6c ECX: 00000000 EDX: 00000000
kernel: [26764.304438] ESI: 00200246 EDI: f6077b90 EBP: e2807e6c ESP: e2807e60
kernel: [26764.304446]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
kernel: [26764.304454] CR0: 8005003b CR2: 0806f740 CR3: 35993000 CR4: 000006d0
kernel: [26764.304461] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
kernel: [26764.304468] DR6: ffff0ff0 DR7: 00000400
kernel: [26764.304475] Call Trace:
kernel: [26764.304492]  [<f90be78e>] ppp_asynctty_receive+0x3ee/0x520 [ppp_async]
kernel: [26764.304507]  [<c12e6fdd>] pty_write+0x7d/0x90
kernel: [26764.304518]  [<c12e158b>] n_tty_write+0x30b/0x420
kernel: [26764.304532]  [<c103e150>] ? default_wake_function+0x0/0x40
kernel: [26764.304543]  [<c12de643>] tty_write+0x173/0x250
kernel: [26764.304554]  [<c10fa02f>] ? rw_verify_area+0x6f/0xf0
kernel: [26764.304564]  [<c12e1280>] ? n_tty_write+0x0/0x420
kernel: [26764.304575]  [<c10fac1e>] vfs_write+0xbe/0x1c0
kernel: [26764.304585]  [<c12de4d0>] ? tty_write+0x0/0x250
kernel: [26764.304596]  [<c10fae28>] sys_write+0x58/0xa0
kernel: [26764.304608]  [<c100325b>] sysenter_do_call+0x12/0x32
...
/USR/SBIN/CRON[10020]: CMD (fetchmail -sk -m '/usr/bin/procmail' > /dev/null 2>&1)
...
kernel: [27404.944948] BUG: scheduling while atomic: pptpgw/4637/0x10000400
kernel: [27404.944958] INFO: lockdep is turned off.
kernel: [27404.944964] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse sbp2 loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device pcspkr snd i2c_i801 psmouse serio_raw rng_core soundcore snd_page_alloc asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod sdhci_pci sdhci mmc_core ohci1394 ata_generic pata_acpi ricoh_mmc uhci_hcd led_class ata_piix ieee1394 ide_pci_generic ehci_hcd usbcore r8169 mii
kernel: [27404.945123] 
kernel: [27404.945134] Pid: 4637, comm: pptpgw Not tainted (2.6.30-dbgnv-git14 #4) F3JC                
kernel: [27404.945143] EIP: 0060:[<c104a3d5>] EFLAGS: 00200246 CPU: 0
kernel: [27404.945158] EIP is at __tasklet_schedule+0x65/0xb0
kernel: [27404.945166] EAX: 00000000 EBX: f6077c6c ECX: 00000000 EDX: 00000000
kernel: [27404.945174] ESI: 00200246 EDI: 00000001 EBP: e2807e60 ESP: e2807e54
kernel: [27404.945182]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
kernel: [27404.945189] CR0: 8005003b CR2: b5f027ac CR3: 35993000 CR4: 000006d0
kernel: [27404.945197] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
kernel: [27404.945204] DR6: ffff0ff0 DR7: 00000400
kernel: [27404.945210] Call Trace:
kernel: [27404.945227]  [<f90be38b>] ppp_asynctty_wakeup+0x6b/0x80 [ppp_async]
kernel: [27404.945240]  [<c12de902>] tty_wakeup+0x72/0x90
kernel: [27404.945251]  [<c12e70d3>] pty_unthrottle+0x23/0x50
kernel: [27404.945261]  [<c12e3b22>] tty_unthrottle+0x42/0x70
kernel: [27404.945272]  [<c12e1c2f>] n_tty_read+0x48f/0x730
kernel: [27404.945286]  [<c103e150>] ? default_wake_function+0x0/0x40
kernel: [27404.945299]  [<c12dcc20>] tty_read+0xa0/0xe0
kernel: [27404.945309]  [<c12e17a0>] ? n_tty_read+0x0/0x730
kernel: [27404.945321]  [<c10faf2b>] vfs_read+0xbb/0x1c0
kernel: [27404.945332]  [<c12dcb80>] ? tty_read+0x0/0xe0
kernel: [27404.945342]  [<c10fb138>] sys_read+0x58/0xa0
kernel: [27404.945354]  [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [27404.945372] BUG: scheduling while atomic: pptpgw/4637/0x00000400
kernel: [27404.945378] INFO: lockdep is turned off.
kernel: [27404.945383] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse sbp2 loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device pcspkr snd i2c_i801 psmouse serio_raw rng_core soundcore snd_page_alloc asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod sdhci_pci sdhci mmc_core ohci1394 ata_generic pata_acpi ricoh_mmc uhci_hcd led_class ata_piix ieee1394 ide_pci_generic ehci_hcd usbcore r8169 mii
kernel: [27404.945532] 
kernel: [27404.945540] Pid: 4637, comm: pptpgw Not tainted (2.6.30-dbgnv-git14 #4) F3JC                
kernel: [27404.945549] EIP: 0060:[<c104a3d5>] EFLAGS: 00200246 CPU: 0
kernel: [27404.945559] EIP is at __tasklet_schedule+0x65/0xb0
kernel: [27404.945566] EAX: 00000000 EBX: f6077c6c ECX: 00000000 EDX: 00000000
kernel: [27404.945573] ESI: 00200246 EDI: 00000001 EBP: e2807e60 ESP: e2807e54
kernel: [27404.945581]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
kernel: [27404.945589] CR0: 8005003b CR2: b5f027ac CR3: 35993000 CR4: 000006d0
kernel: [27404.945596] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
kernel: [27404.945603] DR6: ffff0ff0 DR7: 00000400
kernel: [27404.945609] Call Trace:
kernel: [27404.945621]  [<f90be38b>] ppp_asynctty_wakeup+0x6b/0x80 [ppp_async]
kernel: [27404.945632]  [<c12de902>] tty_wakeup+0x72/0x90
kernel: [27404.945643]  [<c12e70d3>] pty_unthrottle+0x23/0x50
kernel: [27404.945653]  [<c12e3b22>] tty_unthrottle+0x42/0x70
kernel: [27404.945663]  [<c12e1c2f>] n_tty_read+0x48f/0x730
kernel: [27404.945676]  [<c103e150>] ? default_wake_function+0x0/0x40
kernel: [27404.945688]  [<c12dcc20>] tty_read+0xa0/0xe0
kernel: [27404.945698]  [<c12e17a0>] ? n_tty_read+0x0/0x730
kernel: [27404.945709]  [<c10faf2b>] vfs_read+0xbb/0x1c0
kernel: [27404.945720]  [<c12dcb80>] ? tty_read+0x0/0xe0
kernel: [27404.945730]  [<c10fb138>] sys_read+0x58/0xa0
kernel: [27404.945741]  [<c100325b>] sysenter_do_call+0x12/0x32
/USR/SBIN/CRON[10140]: CMD (fetchmail -sk -m '/usr/bin/procmail' > /dev/null 2>&1)
kernel: [27729.047046] BUG: spinlock lockup on CPU#1, pppd/4636, f5928dc0
kernel: [27729.047060] Pid: 4636, comm: pppd Not tainted 2.6.30-dbgnv-git14 #4
kernel: [27729.047067] Call Trace:
kernel: [27729.047084]  [<c141786b>] ? printk+0x23/0x36
kernel: [27729.047099]  [<c125da29>] _raw_spin_lock+0x159/0x170
kernel: [27729.047111]  [<c141b7f2>] _spin_lock_bh+0x62/0x90
kernel: [27729.047130]  [<f90aabe7>] ? ppp_channel_push+0x27/0xd0 [ppp_generic]
kernel: [27729.047145]  [<f90aabe7>] ppp_channel_push+0x27/0xd0 [ppp_generic]
kernel: [27729.047159]  [<f90aad67>] ppp_write+0xd7/0xe0 [ppp_generic]
kernel: [27729.047172]  [<c10fac1e>] vfs_write+0xbe/0x1c0
kernel: [27729.047186]  [<f90aac90>] ? ppp_write+0x0/0xe0 [ppp_generic]
kernel: [27729.047197]  [<c10fae28>] sys_write+0x58/0xa0
kernel: [27729.047209]  [<c100325b>] sysenter_do_call+0x12/0x32
kernel: [27787.880283] SysRq : Keyboard mode set to system default
exiting on signal 15
syslogd 1.5.0#5: restart.
--fUYQa+Pmc3FrFX/N--
