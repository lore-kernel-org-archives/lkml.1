Return-Path: <linux-kernel-owner+w=401wt.eu-S935720AbXHHXm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935720AbXHHXm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760718AbXHHXmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:42:45 -0400
Received: from mail.suse.de ([195.135.220.2]:50055 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbXHHXmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:42:44 -0400
Message-ID: <46BA5523.7080808@suse.com>
Date: Wed, 08 Aug 2007 19:43:31 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: Tom Mortensen <tmmlkml@gmail.com>
Cc: tony@tvortex.net, linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: reiserfs fs/reiserfs/bitmap.c:1287
References: <15366.199.125.14.2.1184261266.squirrel@localmail-dr.mcsimons.com>	 <46967D7D.5090204@suse.com> <a52a95e30708081529i7cee02ddq61471378c2a12ffa@mail.gmail.com>
In-Reply-To: <a52a95e30708081529i7cee02ddq61471378c2a12ffa@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Tom Mortensen wrote:
> I'm wondering if any resolution to this particular bug?  I see this
> exact kernel bug in copying large data sets (40GB+), and can reproduce
> fairly well.  Running reiserfsck produces this message:
> 
> "Zero bit found in on-disk bitmap after the last valid bit."
> 
> Running reiserfsck with --fix-fixable does fix the file system, but
> with some file data corruptions (I guess due to cached blocks not
> getting written?).
> 
> I'm running 2.6.22.1

How large is the file system (larger than 8 TB?) and what version of
mkreiserfs was used to create it?

I do have patches that consider this (and other types of problems)
corruption, and will take the file system read-only instead of BUG'ing.
I've posted them on reiserfs-devel and they've seen some testing in the
openSUSE 10.3 alpha cycle, but I'd like to know how it's happening in
the first place.

- -Jeff


> 
> Below are details:
> 
> Aug  8 14:05:43 develop kernel: [1121369.437041] ------------[ cut
> here ]------------
> Aug  8 14:05:43 develop kernel: [1121369.437123] kernel BUG at
> fs/reiserfs/bitmap.c:1287!
> Aug  8 14:05:43 develop kernel: [1121369.437199] invalid opcode: 0000 [#1]
> Aug  8 14:05:43 develop kernel: [1121369.437271] Modules linked in:
> md_mod fuse jmicron sata_promise ahci ide_
> core libata e1000
> Aug  8 14:05:43 develop kernel: [1121369.437426] CPU:    0
> Aug  8 14:05:43 develop kernel: [1121369.437427] EIP:
> 0060:[<c017bb7f>]    Not tainted VLI
> Aug  8 14:05:43 develop kernel: [1121369.437428] EFLAGS: 00210246
> (2.6.22.1 #6)
> Aug  8 14:05:43 develop kernel: [1121369.438624] EIP is at
> reiserfs_cache_bitmap_metadata+0x74/0x7c
> Aug  8 14:05:43 develop kernel: [1121369.438703] eax: d566c000   ebx:
> f8a90014   ecx: ffffffff   edx: d566bffc
> Aug  8 14:05:43 develop kernel: [1121369.438786] esi: f1ac13c8   edi:
> 00000000   ebp: f8a90014   esp: ee95fc1c
> Aug  8 14:05:43 develop kernel: [1121369.438869] ds: 007b   es: 007b
> fs: 0000  gs: 0033  ss: 0068
> Aug  8 14:05:43 develop kernel: [1121369.438949] Process shfs (pid:
> 7950, ti=ee95e000 task=f7f9b070 task.ti=ee
> 95e000)
> Aug  8 14:05:43 develop kernel: [1121369.439033] Stack: f1ac13c8
> 00028000 f4569e00 c017bc37 00001000 00000110
> f4569e00 c019262d
> Aug  8 14:05:43 develop kernel: [1121369.439185]        00000005
> ee95fcac 00000254 f4569e00 c017a57f 00000000
> 00000001 00000000
> Aug  8 14:05:43 develop kernel: [1121369.439336]        00000000
> f8a90014 00000005 ee95fec4 00000000 f0727b80
> 00000005 f4569e00
> Aug  8 14:05:43 develop kernel: [1121369.439487] Call Trace:
> Aug  8 14:05:43 develop kernel: [1121369.439606]  [<c017bc37>]
> reiserfs_read_bitmap_block+0xb0/0xba
> Aug  8 14:05:43 develop kernel: [1121369.439687]  [<c019262d>]
> search_by_key+0x6e1/0xada
> Aug  8 14:05:43 develop kernel: [1121369.439765]  [<c017a57f>]
> scan_bitmap_block+0x63/0x22c
> Aug  8 14:05:43 develop kernel: [1121369.439844]  [<c017a9b0>]
> scan_bitmap+0x1a2/0x1fb
> Aug  8 14:05:43 develop kernel: [1121369.439921]  [<c017b9c5>]
> reiserfs_allocate_blocknrs+0x2cc/0x3d2
> Aug  8 14:05:43 develop kernel: [1121369.440003]  [<c0185a22>]
> reiserfs_allocate_blocks_for_region+0x1f0/0x114
> 1
> Aug  8 14:05:43 develop kernel: [1121369.440089]  [<c0192bb4>]
> search_for_position_by_key+0x18e/0x306
> Aug  8 14:05:43 develop kernel: [1121369.440171]  [<c0181020>]
> make_cpu_key+0x43/0x4a
> Aug  8 14:05:43 develop kernel: [1121369.440247]  [<c0191c39>]
> pathrelse+0x1b/0x26
> Aug  8 14:05:43 develop kernel: [1121369.440322]  [<c0187424>]
> reiserfs_prepare_file_region_for_write+0x4ad/0x
> 77d
> Aug  8 14:05:43 develop kernel: [1121369.440464]  [<c015a14e>]
> file_update_time+0x26/0x8b
> Aug  8 14:05:43 develop kernel: [1121369.440542]  [<c0187a4d>]
> reiserfs_file_write+0x359/0x4bc
> Aug  8 14:05:43 develop kernel: [1121369.440623]  [<c0124e9e>]
> autoremove_wake_function+0x0/0x33
> Aug  8 14:05:43 develop kernel: [1121369.440706]  [<c011adb4>]
> __do_softirq+0x35/0x73
> Aug  8 14:05:43 develop kernel: [1121369.440782]  [<c014b08d>]
> vfs_write+0x8b/0x106
> Aug  8 14:05:43 develop kernel: [1121369.440858]  [<c014b27d>]
> sys_pwrite64+0x48/0x5f
> Aug  8 14:05:43 develop kernel: [1121369.440930]  [<c0103a62>]
> syscall_call+0x7/0xb
> Aug  8 14:05:43 develop kernel: [1121369.441002]  =======================
> Aug  8 14:05:43 develop kernel: [1121369.441067] Code: 40 74 d2 b9 1f
> 00 00 00 0f a3 0a 19 c0 85 c0 75 0f 8d 0
> 4 0f 66 89 03 0f b7 43 02 40 66 89 43 02 49 79 e5 eb b0 66 83 3b 00 75
> 04 <0f> 0b eb fe 5b 5e 5f c3 55 89 d1 5
> 7 89 c7 56 53 83 ec 10 8b 58
> Aug  8 14:05:43 develop kernel: [1121369.441363] EIP: [<c017bb7f>]
> reiserfs_cache_bitmap_metadata+0x74/0x7c SS
> :ESP 0068:ee95fc1c
> Aug  8 14:05:43 develop kernel: [1121369.441793] WARNING: at
> kernel/exit.c:869 do_exit()
> Aug  8 14:05:43 develop kernel: [1121369.441886]  [<c0119210>]
> do_exit+0x41/0x300
> Aug  8 14:05:43 develop kernel: [1121369.442002]  [<c0104c12>] die+0x188/0x190
> Aug  8 14:05:43 develop kernel: [1121369.442115]  [<c0104e8c>]
> do_invalid_op+0x0/0x8a
> Aug  8 14:05:43 develop kernel: [1121369.442230]  [<c0104f0d>]
> do_invalid_op+0x81/0x8a
> Aug  8 14:05:43 develop kernel: [1121369.442345]  [<c017bb7f>]
> reiserfs_cache_bitmap_metadata+0x74/0x7c
> Aug  8 14:05:43 develop kernel: [1121369.442467]  [<c02bcfce>]
> io_schedule+0xe/0x16
> Aug  8 14:05:43 develop kernel: [1121369.442583]  [<c02bd0f2>]
> __wait_on_bit+0x4a/0x51
> Aug  8 14:05:43 develop kernel: [1121369.442698]  [<c02bd167>]
> out_of_line_wait_on_bit+0x6e/0x76
> Aug  8 14:05:43 develop kernel: [1121369.442816]  [<c0162fd3>]
> sync_buffer+0x0/0x2e
> Aug  8 14:05:43 develop kernel: [1121369.442932]  [<c0124ed1>]
> wake_bit_function+0x0/0x3c
> Aug  8 14:05:43 develop kernel: [1121369.443050]  [<c02bd8ea>]
> error_code+0x6a/0x70
> Aug  8 14:05:43 develop kernel: [1121369.443166]  [<c017bb7f>]
> reiserfs_cache_bitmap_metadata+0x74/0x7c
> Aug  8 14:05:43 develop kernel: [1121369.443287]  [<c017bc37>]
> reiserfs_read_bitmap_block+0xb0/0xba
> Aug  8 14:05:43 develop kernel: [1121369.443413]  [<c019262d>]
> search_by_key+0x6e1/0xada
> Aug  8 14:05:43 develop kernel: [1121369.443531]  [<c017a57f>]
> scan_bitmap_block+0x63/0x22c
> Aug  8 14:05:43 develop kernel: [1121369.443648]  [<c017a9b0>]
> scan_bitmap+0x1a2/0x1fb
> Aug  8 14:05:43 develop kernel: [1121369.443764]  [<c017b9c5>]
> reiserfs_allocate_blocknrs+0x2cc/0x3d2
> Aug  8 14:05:43 develop kernel: [1121369.443886]  [<c0185a22>]
> reiserfs_allocate_blocks_for_region+0x1f0/0x114
> 1
> Aug  8 14:05:43 develop kernel: [1121369.444011]  [<c0192bb4>]
> search_for_position_by_key+0x18e/0x306
> Aug  8 14:05:43 develop kernel: [1121369.444133]  [<c0181020>]
> make_cpu_key+0x43/0x4a
> Aug  8 14:05:43 develop kernel: [1121369.444249]  [<c0191c39>]
> pathrelse+0x1b/0x26
> Aug  8 14:05:43 develop kernel: [1121369.444362]  [<c0187424>]
> reiserfs_prepare_file_region_for_write+0x4ad/0x
> 77d
> Aug  8 14:05:43 develop kernel: [1121369.444540]  [<c015a14e>]
> file_update_time+0x26/0x8b
> Aug  8 14:05:43 develop kernel: [1121369.444657]  [<c0187a4d>]
> reiserfs_file_write+0x359/0x4bc
> Aug  8 14:05:43 develop kernel: [1121369.444778]  [<c0124e9e>]
> autoremove_wake_function+0x0/0x33
> Aug  8 14:05:43 develop kernel: [1121369.444897]  [<c011adb4>]
> __do_softirq+0x35/0x73
> Aug  8 14:05:43 develop kernel: [1121369.445012]  [<c014b08d>]
> vfs_write+0x8b/0x106
> Aug  8 14:05:43 develop kernel: [1121369.445127]  [<c014b27d>]
> sys_pwrite64+0x48/0x5f
> Aug  8 14:05:43 develop kernel: [1121369.445243]  [<c0103a62>]
> syscall_call+0x7/0xb
> Aug  8 14:05:43 develop kernel: [1121369.445358]  =======================
> 
> 
> On 7/12/07, Jeff Mahoney <jeffm@suse.com> wrote:
> Anthony Simons wrote:
>>>> Was decompressing a newly compiled kernel to my usb drive and received the
>>>> below error almost immediatly after I began.
>>>>
>>>> [tonys@squishy ~]$ uname -a
>>>> Linux squishy 2.6.21-1.3228.fc7 #1 SMP Tue Jun 12 15:37:31 EDT 2007 i686
>>>> i686 i386 GNU/Linux
>>>>
>>>> After I recive the error, a simple ls just won't work.
> That's expected. Locks that you'll need to acquire for the ls to
> complete were held by process that BUG()'d.
> 
> This error corresponds to this check in reiserfs_cache_bitmap_metadata():
> 
>         /* The first bit must ALWAYS be 1 */
>         BUG_ON(info->first_zero_hint == 0);
> 
> Bit 0 corresponds to the bitmap block itself, so it must *always* be set.
> 
> Can you run reiserfsck on the file system? I have a patch set in
> development that handles errors like these a bit more gracefully.
> 
> -Jeff
> 
>>>> ------------[ cut here ]------------
>>>> kernel BUG at fs/reiserfs/bitmap.c:1287!
>>>> invalid opcode: 0000 [#1]
>>>> SMP
>>>> last sysfs file: /block/sdb/size
>>>> Modules linked in: ext2 usb_storage nvidia(P)(U) autofs4 hidp rfcomm l2cap
>>>> bluetooth sunrpc cpufreq_ondemand acpi_cpufreq ext3 jbd mbcache dm_mirror
>>>> dm_multipath dm_mod video sbs i2c_ec button dock battery ac ipv6 lp loop
>>>> parport_pc parport arc4 ecb blkcipher rc80211_simple irda snd_intel8x0m
>>>> crc_ccitt bcm43xx_mac80211 ssb iTCO_wdt mac80211 snd_intel8x0
>>>> iTCO_vendor_support snd_ac97_codec serio_raw cfg80211 tg3 ac97_bus
>>>> snd_seq_dummy i2c_core snd_seq_oss fw_ohci fw_core sr_mod cdrom
>>>> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss joydev
>>>> snd_pcm snd_timer snd soundcore snd_page_alloc sg ata_generic ata_piix
>>>> libata sd_mod scsi_mod reiserfs ehci_hcd ohci_hcd uhci_hcd
>>>> CPU:    0
>>>> EIP:    0060:[<f88a306c>]    Tainted: P       VLI
>>>> EFLAGS: 00210246   (2.6.21-1.3228.fc7 #1)
>>>> EIP is at reiserfs_cache_bitmap_metadata+0x6c/0x74 [reiserfs]
>>>> eax: e6461000   ebx: f8896314   ecx: 00000000   edx: e6460ffc
>>>> esi: f5a54668   edi: 00000000   ebp: 000000c5   esp: e4a2dd78
>>>> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
>>>> Process tar (pid: 6860, ti=e4a2d000 task=e528e710 task.ti=e4a2d000)
>>>> Stack: f5a54668 0018a000 e4bede00 f88a313d 00000400 04040404 e4bede00
>>>> e4bede00
>>>>        f8896000 f8896314 e4bede00 d71cbe00 d71cbe60 f88a36d4 fffffff4
>>>> 000041ed
>>>>        00000000 f88adbde eab6be0c e6394950 00000001 e3af31d0 e4bede00
>>>> d71cbe60
>>>> Call Trace:
>>>>  [<f88a313d>] reiserfs_read_bitmap_block+0xc9/0xd3 [reiserfs]
>>>>  [<f88a36d4>] reiserfs_choose_packing+0x4a/0x78 [reiserfs]
>>>>  [<f88adbde>] reiserfs_new_inode+0xb8/0x826 [reiserfs]
>>>>  [<f88c35e7>] do_journal_begin_r+0x73/0x28d [reiserfs]
>>>>  [<c04850e3>] d_splice_alias+0xdd/0xe3
>>>>  [<f88c389a>] journal_begin+0x99/0xd0 [reiserfs]
>>>>  [<f88a9a79>] reiserfs_mkdir+0x183/0x2c2 [reiserfs]
>>>>  [<f88c6e0b>] reiserfs_permission+0x0/0x1e [reiserfs]
>>>>  [<c047bd7c>] vfs_mkdir+0xbd/0x125
>>>>  [<c047e226>] sys_mkdirat+0x88/0xba
>>>>  [<c0450fcd>] audit_syscall_exit+0x294/0x2b0
>>>>  [<c0450d0f>] audit_syscall_entry+0x10d/0x137
>>>>  [<c047e277>] sys_mkdir+0x1f/0x23
>>>>  [<c0404f70>] syscall_call+0x7/0xb
>>>>  =======================
>>>> Code: 00 00 0f a3 0a 19 c0 85 c0 75 0a 66 ff 43 02 8d 04 39 66 89 03 49 83
>>>> f9 ff 75 e7 8b 46 18 83 ea 04 39 c2 73 ba 66 83 3b 00 75 04 <0f> 0b eb fe
>>>> 5b 5e 5f c3 55 89 d5 57 89 c7 56 53 83 ec 14 8b 90
>>>> EIP: [<f88a306c>] reiserfs_cache_bitmap_metadata+0x6c/0x74 [reiserfs]
>>>> SS:ESP 0068:e4a2dd78
>>>> BUG: warning at kernel/exit.c:798/do_exit() (Tainted: P      )
>>>>  [<c04294f3>] do_exit+0x54/0x6d3
>>>>  [<c040655c>] die+0x21b/0x240
>>>>  [<c0406967>] do_invalid_op+0x0/0xab
>>>>  [<c0406a09>] do_invalid_op+0xa2/0xab
>>>>  [<f88a306c>] reiserfs_cache_bitmap_metadata+0x6c/0x74 [reiserfs]
>>>>  [<f88e378d>] scsi_request_fn+0x2d3/0x31d [scsi_mod]
>>>>  [<c04d9a27>] blk_remove_plug+0x58/0x64
>>>>  [<c042d6e7>] getnstimeofday+0x30/0xb6
>>>>  [<c04394c4>] ktime_get_ts+0x16/0x44
>>>>  [<c0454c38>] delayacct_end+0x70/0x77
>>>>  [<c0454d26>] __delayacct_blkio_end+0x5b/0x5e
>>>>  [<c0600b39>] __wait_on_bit+0x50/0x58
>>>>  [<c0601a84>] error_code+0x7c/0x84
>>>>  [<f88a306c>] reiserfs_cache_bitmap_metadata+0x6c/0x74 [reiserfs]
>>>>  [<f88a313d>] reiserfs_read_bitmap_block+0xc9/0xd3 [reiserfs]
>>>>  [<f88a36d4>] reiserfs_choose_packing+0x4a/0x78 [reiserfs]
>>>>  [<f88adbde>] reiserfs_new_inode+0xb8/0x826 [reiserfs]
>>>>  [<f88c35e7>] do_journal_begin_r+0x73/0x28d [reiserfs]
>>>>  [<c04850e3>] d_splice_alias+0xdd/0xe3
>>>>  [<f88c389a>] journal_begin+0x99/0xd0 [reiserfs]
>>>>  [<f88a9a79>] reiserfs_mkdir+0x183/0x2c2 [reiserfs]
>>>>  [<f88c6e0b>] reiserfs_permission+0x0/0x1e [reiserfs]
>>>>  [<c047bd7c>] vfs_mkdir+0xbd/0x125
>>>>  [<c047e226>] sys_mkdirat+0x88/0xba
>>>>  [<c0450fcd>] audit_syscall_exit+0x294/0x2b0
>>>>  [<c0450d0f>] audit_syscall_entry+0x10d/0x137
>>>>  [<c047e277>] sys_mkdir+0x1f/0x23
>>>>  [<c0404f70>] syscall_call+0x7/0xb
>>>>  =======================

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGulUjLPWxlyuTD7IRAhr8AJ4ocPTpg4P7FERRup1jIYkHO99kugCfecVf
BGkNHLywct+iMmoLGmMf1wc=
=UldS
-----END PGP SIGNATURE-----
