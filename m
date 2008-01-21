Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYAUC6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYAUC6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 21:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYAUC6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 21:58:08 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:16207 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYAUC6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 21:58:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XByApAyYLzpME7Y1aIrtlOwFE0UuwkM5Qz9FfygyjI31vHzhTybAi/DzDm50kytttQ4QRA2uhMPcPbhBNFGkwlTwGR8p2wg/wqOnLPmV3AW16JxG16LnMMRYjS1Ru7l2qzorV+4ujNOTVc5h1dsmAHa3tHsx66slsMHiASbHcXA=
Message-ID: <16de59c20801201858w21b13617w89c6a72f4ca66168@mail.gmail.com>
Date: Mon, 21 Jan 2008 15:58:04 +1300
From: "Uncle Gimpy" <unclegimpy@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at reiserfs fs/reiserfs/bitmap.c:1287
In-Reply-To: <16de59c20801201855l3872ee9bj9c4e2cb66c5e3d32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <16de59c20801201855l3872ee9bj9c4e2cb66c5e3d32@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
recently a reiserfs crapped out on me with a kernel bug, I found the
following related post:

http://lkml.org/lkml/2007/7/12/242

Hopefully I can supply a further data point for this problem.  Please
CC me in any replies, I'm not subscribed to the linux-kernel list.

~ # mkreiserfs -V
mkreiserfs 3.6.19 (2003 www.namesys.com)
~ # uname -a
Linux boron 2.6.20-gentoo-r8 #4 Fri Jul 20 10:18:57 NZST 2007 x86_64
AMD Athlon(tm) 64 Processor 3200+ AuthenticAMD GNU/Linux

I mounted a (roughly) 320GB partition over USB to do a backup.  This
drive and fs has been used successfully before for backups.  The
backup failed and the fs froze, leaving several unkillable process
that had been accessing it, ultimately I had to do a hard power-off
with fingers crossed.  When I ran fsck on the backup drive there were
lots of errors (sorry, no longer have these). The log of the initial
attempted backup is included below.  I've since reformatted the drive
with ext3 and taken a back-up, however I have an identical secondary
backup drive which I might be able to get diagnostic info from if
necessary, though it hasn't caused trouble (yet).

I also had a problem making a reiserfs on another drive (80GB) a while
back, I got something like 'accessed past end of drive'.  It looks
like that might be related to this problem... I just thought the drive
was bad at the time.



Anyways, if there is more info I could provide, please ask.

Bob.



Jan 18 18:30:06 boron SCSI device sde: 625142448 512-byte hdwr sectors
(320073 MB)
Jan 18 18:30:06 boron sde: Write Protect is off
Jan 18 18:30:06 boron sde: Mode Sense: 00 38 00 00
Jan 18 18:30:06 boron sde: assuming drive cache: write through
Jan 18 18:30:06 boron SCSI device sde: 625142448 512-byte hdwr sectors
(320073 MB)
Jan 18 18:30:06 boron sde: Write Protect is off
Jan 18 18:30:06 boron sde: Mode Sense: 00 38 00 00
Jan 18 18:30:06 boron sde: assuming drive cache: write through
Jan 18 18:30:06 boron sde: sde1
Jan 18 18:30:06 boron sd 6:0:0:0: Attached scsi disk sde
Jan 18 18:30:06 boron usb-storage: device scan complete
Jan 18 18:30:10 boron ReiserFS: sde1: found reiserfs format "3.6" with
standard journal
Jan 18 18:30:10 boron ReiserFS: sde1: using ordered data mode
Jan 18 18:30:10 boron ReiserFS: sde1: journal params: device sde1,
size 8192, journal first block 18, max trans len 1024, max batch 900,
max commit age 30, max trans age 30
Jan 18 18:30:10 boron ReiserFS: sde1: checking transaction log (sde1)
Jan 18 18:30:10 boron ReiserFS: sde1: Using r5 hash to sort names
Jan 18 18:30:10 boron hald: mounted /dev/sde1 on behalf of uid 1000
Jan 18 18:39:17 boron usb 1-2: reset high speed USB device using
ehci_hcd and address 4
Jan 18 18:39:28 boron usb 1-2: reset high speed USB device using
ehci_hcd and address 4
Jan 18 18:39:34 boron ReiserFS: warning: is_leaf: nr_item seems wrong:
level=1, nr_items=0, free_space=0 rdkey
Jan 18 18:39:34 boron ReiserFS: sde1: warning: vs-5150: search_by_key:
invalid format found in block 50553182. Fsck?
Jan 18 18:39:34 boron ReiserFS: sde1: warning: vs-13070:
reiserfs_read_locked_inode: i/o failure occurred trying to find stat
data of [22204 334512 0x0 SD]
Jan 18 18:39:34 boron ReiserFS: warning: is_tree_node: node level 2314
does not match to the expected one 1
Jan 18 18:39:34 boron ReiserFS: sde1: warning: vs-5150: search_by_key:
invalid format found in block 47023915. Fsck?
Jan 18 18:39:34 boron ReiserFS: sde1: warning: vs-13070:
reiserfs_read_locked_inode: i/o failure occurred trying to find stat
data of [22204 30192 0x0 SD]
Jan 18 18:39:34 boron ReiserFS: warning: is_tree_node: node level
27749 does not match to the expected one 1
.... plenty more
Jan 18 18:39:35 boron ReiserFS: sde1: warning: vs-13070:
reiserfs_read_locked_inode: i/o failure occurred trying to find stat
data of [22204 28758 0x0 SD]
Jan 18 18:39:35 boron ReiserFS: warning: is_tree_node: node level
25970 does not match to the expected one 1
Jan 18 18:39:35 boron ReiserFS: sde1: warning: vs-5150: search_by_key:
invalid format found in block 50556098. Fsck?
Jan 18 18:39:35 boron ReiserFS: sde1: warning: vs-13070:
reiserfs_read_locked_inode: i/o failure occurred trying to find stat
data of [22204 336140 0x0 SD]
Jan 18 18:39:35 boron ReiserFS: warning: is_leaf: nr_item seems wrong:
level=1, nr_items=0, free_space=0 rdkey
Jan 18 18:39:35 boron ReiserFS: sde1: warning: vs-5150: search_by_key:
invalid format found in block 66879833. Fsck?
Jan 18 18:39:35 boron ReiserFS: sde1: warning: vs-13070:
reiserfs_read_locked_inode: i/o failure occurred trying to find stat
data of [22204 23811 0x0 SD]
Jan 18 18:39:35 boron ReiserFS: warning: is_tree_node: node level 8240
does not match to the expected one 1
Jan 18 18:39:35 boron ReiserFS: sde1: warning: vs-5150: search_by_key:
invalid format found in block 47097046. Fsck?
Jan 18 18:39:35 boron ReiserFS: sde1: warning: vs-13070:
reiserfs_read_locked_inode: i/o failure occurred trying to find stat
data of [22204 237797 0x0 SD]
.... plenty more

Jan 18 18:39:53 boron ------------[ cut here ]------------
Jan 18 18:39:53 boron kernel BUG at fs/reiserfs/bitmap.c:1287!
Jan 18 18:39:53 boron invalid opcode: 0000 [1]
Jan 18 18:39:53 boron CPU 0
Jan 18 18:39:53 boron Modules linked in: usb_storage aes_x86_64 cbc
blkcipher cryptomgr crypto_algapi dm_crypt nfsd exportfs lockd sunrpc
it87 hwmon_vid hwmon eeprom i2c_isa snd_pcm_oss snd_mixer_oss
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device ohci_hcd
nvidia(P) snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd
snd_page_alloc i2c_nforce2 i2c_core ehci_hcd evdev
Jan 18 18:39:53 boron Pid: 10668, comm: cp Tainted: P      2.6.20-gentoo-r8 #4
Jan 18 18:39:53 boron RIP: 0010:[<ffffffff802d36fe>]
[<ffffffff802d36fe>] reiserfs_cache_bitmap_metadata+0x7e/0x90
Jan 18 18:39:53 boron RSP: 0018:ffff810027833c00  EFLAGS: 00010246
Jan 18 18:39:53 boron RAX: 0000000000000000 RBX: ffff810008d78268 RCX:
ffff810050c26000
Jan 18 18:39:53 boron RDX: ffffc20011bd2914 RSI: ffff810008d78268 RDI:
0000000000000000
Jan 18 18:39:53 boron RBP: 0000000003228000 R08: ffff810050c25ff8 R09:
0000000000000000
Jan 18 18:39:53 boron R10: 0000000000000002 R11: ffffffff8031a5d0 R12:
ffff81002113c000
Jan 18 18:39:53 boron R13: 0000000000000645 R14: ffffc20011bd1000 R15:
ffff81002113c000
Jan 18 18:39:53 boron FS:  00002ad52e4ed6f0(0000)
GS:ffffffff80585000(0000) knlGS:00000000f1835b90
Jan 18 18:39:53 boron CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 18 18:39:53 boron CR2: 00000000023df088 CR3: 000000006086f000 CR4:
00000000000006e0
Jan 18 18:39:53 boron Process cp (pid: 10668, threadinfo
ffff810027832000, task ffff8100518d2ec0)
Jan 18 18:39:53 boron Stack:  ffffffff802d37d7 ffff81002113c000
ffffc20011bd2914 ffff81001297c300
Jan 18 18:39:53 boron ffff810033819d88 ffff81004ae70cc0
ffffffff802d3e98 ffff81001297c368
Jan 18 18:39:53 boron 00000000000041c0 ffff810027833e18
ffffffff802dddee ffff810027833ca8
Jan 18 18:39:53 boron Call Trace:
Jan 18 18:39:53 boron [<ffffffff802d37d7>] reiserfs_read_bitmap_block+0xc7/0xe0
Jan 18 18:39:53 boron [<ffffffff802d3e98>] reiserfs_choose_packing+0x68/0xd0
Jan 18 18:39:53 boron [<ffffffff802dddee>] reiserfs_new_inode+0x6e/0x740
Jan 18 18:39:53 boron [<ffffffff8022e8e7>] d_splice_alias+0xc7/0xe0
Jan 18 18:39:53 boron [<ffffffff802f46f5>] do_journal_begin_r+0x55/0x300
Jan 18 18:39:53 boron [<ffffffff802d8f3a>] reiserfs_mkdir+0xea/0x1f0
Jan 18 18:39:53 boron [<ffffffff802adb09>] vfs_mkdir+0x79/0xd0
Jan 18 18:39:53 boron [<ffffffff802ae009>] sys_mkdirat+0xb9/0x130
Jan 18 18:39:53 boron [<ffffffff80259eae>] system_call+0x7e/0x83
Jan 18 18:39:53 boron
Jan 18 18:39:53 boron
Jan 18 18:39:53 boron Code: 0f 0b eb fe f3 c3 00 00 00 00 00 00 00 00
00 00 00 00 41 56
Jan 18 18:39:53 boron RIP  [<ffffffff802d36fe>]
reiserfs_cache_bitmap_metadata+0x7e/0x90
Jan 18 18:39:53 boron RSP <ffff810027833c00>
Jan 18 18:39:53 boron BUG: at kernel/exit.c:860 do_exit()
Jan 18 18:39:53 boron
Jan 18 18:39:53 boron Call Trace:
Jan 18 18:39:53 boron [<ffffffff802149bc>] do_exit+0x4c/0x7a0
Jan 18 18:39:53 boron [<ffffffff8033d4ac>] do_unblank_screen+0x7c/0x130
Jan 18 18:39:53 boron [<ffffffff802625f0>] kernel_math_error+0x0/0xb0
Jan 18 18:39:53 boron [<ffffffff80262fcd>] do_invalid_op+0xad/0xc0
Jan 18 18:39:53 boron [<ffffffff802d36fe>]
reiserfs_cache_bitmap_metadata+0x7e/0x90
Jan 18 18:39:53 boron [<ffffffff80214920>] sync_buffer+0x0/0x50
Jan 18 18:39:53 boron [<ffffffff8025e23d>] error_exit+0x0/0x84
Jan 18 18:39:53 boron [<ffffffff8031a5d0>] cfq_queue_empty+0x0/0x20
Jan 18 18:39:53 boron [<ffffffff802d36fe>]
reiserfs_cache_bitmap_metadata+0x7e/0x90
Jan 18 18:39:53 boron [<ffffffff802d37d7>] reiserfs_read_bitmap_block+0xc7/0xe0
Jan 18 18:39:53 boron [<ffffffff802d3e98>] reiserfs_choose_packing+0x68/0xd0
Jan 18 18:39:53 boron [<ffffffff802dddee>] reiserfs_new_inode+0x6e/0x740
Jan 18 18:39:53 boron [<ffffffff8022e8e7>] d_splice_alias+0xc7/0xe0
Jan 18 18:39:53 boron [<ffffffff802f46f5>] do_journal_begin_r+0x55/0x300
Jan 18 18:39:53 boron [<ffffffff802d8f3a>] reiserfs_mkdir+0xea/0x1f0
Jan 18 18:39:53 boron [<ffffffff802adb09>] vfs_mkdir+0x79/0xd0
Jan 18 18:39:53 boron [<ffffffff802ae009>] sys_mkdirat+0xb9/0x130
Jan 18 18:39:53 boron [<ffffffff80259eae>] system_call+0x7e/0x83
Jan 18 18:39:53 boron
