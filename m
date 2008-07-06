Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbYGFRWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbYGFRWD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYGFRVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:21:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:57757 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751691AbYGFRVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:21:50 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/INkZe++HIcsbMAfk/g6O2JDKu35XKBb8gCFkTcT
	47ptkkoA/M0u4v
Date: Sun, 6 Jul 2008 19:21:47 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-ntfs-dev@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: Oops with corrupted NTFS image
Message-ID: <20080706172147.GA19559@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26-rc8 (x86_64)
X-Uptime: 19:19:40 up  6:29,  1 user,  load average: 0.55, 0.42, 0.41
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

when mounting a corrupted ntfs image with errors=recover i get the following oops:

[  129.615116] NTFS-fs error (device loop0): check_mft_mirror(): $MFT and $MFTMirr (record 0) do not match.  Run ntfsfix or chkdsk.
[  129.627531] NTFS-fs error (device loop0): load_system_files(): $MFTMirr does not match $MFT.  Mounting read-only.  Run ntfsfix and/or chkdsk.
[  129.639941] NTFS-fs error (device loop0): map_mft_record_page(): Mft record 0xa is corrupt.  Run chkdsk.
[  129.640212] NTFS-fs error (device loop0): map_mft_record(): Failed with error code 5.
[  129.640388] NTFS-fs error (device loop0): ntfs_read_locked_inode(): Failed with error code -5.  Marking corrupt inode 0xa as bad.  Run chkdsk.
[  129.640623] NTFS-fs error (device loop0): load_and_init_upcase(): Failed to load $UpCase from the volume. Using default.
[  129.656112] BUG: unable to handle kernel paging request at c982e558
[  129.656372] IP: [<c030ad5c>] ntfs_read_locked_inode+0x16c/0x1520
[  129.656656] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  129.656999] Modules linked in: [last unloaded: rcutorture]
[  129.657014] 
[  129.657014] Pid: 4676, comm: mount Not tainted (2.6.26-rc8-00290-gb8a0b6c #3)
[  129.657014] EIP: 0060:[<c030ad5c>] EFLAGS: 00010296 CPU: 0
[  129.657014] EIP is at ntfs_read_locked_inode+0x16c/0x1520
[  129.657014] EAX: c982e550 EBX: 00000000 ECX: c9821000 EDX: c9821038
[  129.657014] ESI: 00000000 EDI: 00000000 EBP: c902ab50 ESP: c902aadc
[  129.657014]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  129.657014] Process mount (pid: 4676, ti=c902a000 task=c9053f80 task.ti=c902a000)
[  129.657014] Stack: 00000000 00000000 00000000 00000000 00000000 c9026000 c0cd58fc cbffad84 
[  129.657014]        c902ab14 c0976870 c0976870 c0976860 cb6e3a40 c9821000 c982e550 c9026000 
[  129.657014]        00000000 c902ab2c c0755667 cbffac00 c902ab50 c01a22f8 c902ab60 00000001 
[  129.657014] Call Trace:
[  129.657014]  [<c0755667>] ? _spin_unlock+0x27/0x50
[  129.657014]  [<c01a22f8>] ? iget5_locked+0x138/0x160
[  129.657014]  [<c030cc80>] ? ntfs_test_inode+0x0/0x70
[  129.657014]  [<c030c165>] ? ntfs_iget+0x55/0x80
[  129.657014]  [<c030ccf0>] ? ntfs_init_locked_inode+0x0/0xf0
[  129.657014]  [<c031861b>] ? load_and_init_attrdef+0x1b/0x270
[  129.657014]  [<c014678f>] ? lockdep_init_map+0x2f/0x480
[  129.657014]  [<c03021ad>] ? __ntfs_error+0x8d/0xd0
[  129.657014]  [<c0318c16>] ? load_system_files+0x3a6/0x1c50
[  129.657014]  [<c031cd4d>] ? generate_default_upcase+0x2d/0x110
[  129.657014]  [<c031cd4d>] ? generate_default_upcase+0x2d/0x110
[  129.657014]  [<c031cd4d>] ? generate_default_upcase+0x2d/0x110
[  129.657014]  [<c031bf6f>] ? ntfs_fill_super+0xccf/0x1420
[  129.657014]  [<c0190b5f>] ? get_sb_bdev+0xef/0x120
[  129.657014]  [<c01a5afd>] copy_mount_options+0x38/0x140
[  129.657014]  [<c01973ae>] ? getname+0x9e/0xd0
[  129.657014]  [<c01a6f7f>] ? sys_mount+0x6f/0xb0
[  129.657014]  [<c0103d79>] ? sysenter_past_esp+0x6a/0xb1
[  129.657014]  =======================
[  129.657014] Code: 0c 89 5c 24 04 c7 04 24 00 00 00 00 e8 ae 2b ff ff 85 c0 89 45 cc 0f 85 26 0c 00 00 8b 45 c8 8b 50 04 0f b7 42 14 01 d0 89 45 c4 <8b> 58 08 8b 70 0c 81 c3 00 80 c1 2a 81 d6 21 4e 62 fe 89 d8 89 
[  129.657014] EIP: [<c030ad5c>] ntfs_read_locked_inode+0x16c/0x1520 SS:ESP 0068:c902aadc
[  129.657014] ---[ end trace 9b1c4369310afb44 ]---

which corresponds to:

(gdb) l *(ntfs_read_locked_inode+0x16c)
0xc030ad5c is in ntfs_read_locked_inode (fs/ntfs/time.h:95).
90		u64 t = (u64)(sle64_to_cpu(time) - NTFS_TIME_OFFSET);
91		/*
92		 * Convert the time to 1-second intervals and the remainder to
93		 * 1-nano-second intervals.
94		 */
95		ts.tv_nsec = do_div(t, 10000000) * 100;
96		ts.tv_sec = t;
97		return ts;
98	}
99	

The image is available at www.cccmz.de/~snakebyte/ntfs.33.img.bz2
I can also reproduce this with -rc9 and without having run rcutortue
before.

Greetings, Eric
