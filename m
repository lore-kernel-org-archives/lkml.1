Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab0BYCRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 21:17:16 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:33652 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813Ab0BYCRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 21:17:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PZ+tUzwqcUP6TmMHQDeKFH6jc3qeik/q5Yh8G6Z1vGXsiF0Gyok5VxvI0zX+ijD6cx
         BQezCpUkOfgmtih5wnEMhn4LBA/x1gOB1JCe3hxo4AQ2IjRc6dlYQzdR7LiBREHGRVMD
         nkHvE8KZ7Dm3NQJWaTJ6Jy0rhBw1HuV4JnpUg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1002232249440.28195@bogon.housecafe.de>
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
	 <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de>
	 <dda83e781002232131i53b59c8eu7192257fc4e4f3e0@mail.gmail.com>
	 <alpine.DEB.2.01.1002232249440.28195@bogon.housecafe.de>
Date: Wed, 24 Feb 2010 18:17:08 -0800
Message-ID: <dda83e781002241817o6ce7c895g681900fe5d0c9302@mail.gmail.com>
Subject: Re: reiserfs issue with 2.6.32.8
From: Bret Towe <magnade@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 11:03 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Tue, 23 Feb 2010 at 21:31, Bret Towe wrote:
>> ok attached is strace log of cp on 2.6.32.9
>
> I've run cp through strace as well (copying something from an XFS
> partition to a reiserfs partition, I guess that's what you did too), and
> noticed a small difference at the end:
>
> < open("/home/foo/1", O_RDONLY)          = 3
> < fstat(3, {st_mode=S_IFREG|0640, st_size=755, ...}) = 0
> < open("2", O_WRONLY|O_CREAT|O_EXCL, 0640) = 4
>
> While your cp(1) did:
>
>> open("downloads/[DB]_Bleach_258_[27104F7A].avi", O_RDONLY) = 3
>> fstat(3, {st_mode=S_IFREG|0644, st_size=178308328, ...}) = 0
>> open("/mdhd/media/Episodes/unwatched/[DB]_Bleach_258_[27104F7A].avi", O_WRONLY|O_CREAT|O_EXCL, 0644) = -1 EINVAL (Invalid argument)
>
>
> And open(2) will return -EINVAL when:
>   - The implementation does not support synchronised I/O for this file.
>   - The value of the oflag argument is not valid.
>
> As we're not passing O_SYNC, it's the latter, if I read this correctly. Which
> still doesn't explain *why* (the filesystem?) returns "invalid flag".
>
>> now I've had a hd drop out of raid (running checks on it atm)
>
> Hm, maybe it's all hardware related after all, let's see what these checks
> turn up. Strange though, that nothing gets reported in dmesg...
>

perhaps related perhaps just more hardware issues
I desided to try making another reiserfs logical volume in the same
volume group as the xfs source file
just out of curiosity and when I tried to mount the filesystem i just
formated mount said Killed and
in dmesg I had the following appear

[75435.452373] REISERFS (device dm-12): found reiserfs format "3.6"
with standard journal
[75435.452401] REISERFS (device dm-12): using ordered data mode
[75435.462446] REISERFS (device dm-12): journal params: device dm-12,
size 8192, journal first block 18, max trans len 1024, max batch 900,
max commit age 30, max trans age 30
[75435.464979] REISERFS (device dm-12): checking transaction log (dm-12)
[75436.068056] REISERFS (device dm-12): Using r5 hash to sort names
[75436.068139] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
[75436.068182] IP: [<ffffffff81155d4e>] reiserfs_security_init+0xfe/0x110
[75436.068219] PGD 8fa7067 PUD 396aa067 PMD 0
[75436.068243] Oops: 0000 [#1] SMP
[75436.068264] last sysfs file: /sys/devices/virtual/block/dm-12/range
[75436.068287] CPU 1
[75436.068304] Modules linked in: ipmi_msghandler i2c_nforce2 k8temp
psmouse serio_raw raid10 raid0 multipath linear r8169 mii pata_amd
forcedeth
[75436.068372] Pid: 11675, comm: mount Not tainted 2.6.32.9-server #49
[75436.068394] RIP: 0010:[<ffffffff81155d4e>]  [<ffffffff81155d4e>]
reiserfs_security_init+0xfe/0x110
[75436.068435] RSP: 0018:ffff880004639b58  EFLAGS: 00010246
[75436.068455] RAX: 0000000000000000 RBX: ffff880004639be8 RCX: ffff88002497d700
[75436.068479] RDX: 0000000000000002 RSI: 0000000000000002 RDI: ffff880025051400
[75436.068502] RBP: ffff880004639b78 R08: ffff880001b0dd20 R09: ffff880000b99280
[75436.068525] R10: 0000000000000000 R11: 000001f400000001 R12: ffff8800069bc600
[75436.068548] R13: 0000000000000000 R14: ffff880008e34cc0 R15: 00000000fffffff4
[75436.068572] FS:  00007f99bd9667d0(0000) GS:ffff880001b00000(0000)
knlGS:0000000000000000
[75436.068606] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[75436.068627] CR2: 0000000000000010 CR3: 000000003990c000 CR4: 00000000000006e0
[75436.068651] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[75436.068675] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[75436.068699] Process mount (pid: 11675, threadinfo ffff880004638000,
task ffff88001ae64230)
[75436.068732] Stack:
[75436.068747]  0000000e04639be8 ffff8800244f34c0 ffff8800069bc600
00000000000041c0
[75436.068774] <0> ffff880004639c38 ffffffff811340c4 fffffffffffffff4
0000000000000000
[75436.068812] <0> ffff880004639bc8 ffff880000000000 ffff880004639c38
ffff8800244f34c0
[75436.068862] Call Trace:
[75436.068886]  [<ffffffff811340c4>] reiserfs_mkdir+0xb4/0x2e0
[75436.068914]  [<ffffffff810d84ea>] ? __lookup_hash+0xfa/0x150
[75436.068936]  [<ffffffff8115417e>] T.421+0x1e/0x30
[75436.068958]  [<ffffffff81154e32>] reiserfs_xattr_init+0x162/0x260
[75436.068983]  [<ffffffff811419f6>] reiserfs_fill_super+0x8f6/0xb10
[75436.069007]  [<ffffffff810cf270>] ? test_bdev_super+0x0/0x20
[75436.069032]  [<ffffffff810d06f4>] get_sb_bdev+0x174/0x1b0
[75436.069054]  [<ffffffff81141100>] ? reiserfs_fill_super+0x0/0xb10
[75436.069078]  [<ffffffff8113f0b3>] get_super_block+0x13/0x20
[75436.069100]  [<ffffffff810d0196>] vfs_kern_mount+0x76/0x1a0
[75436.069123]  [<ffffffff810d032d>] do_kern_mount+0x4d/0x130
[75436.069147]  [<ffffffff810e8131>] do_mount+0x2d1/0x850
[75436.069172]  [<ffffffff810a978f>] ? strndup_user+0x5f/0xb0
[75436.069194]  [<ffffffff810e873b>] sys_mount+0x8b/0xe0
[75436.069221]  [<ffffffff8100beab>] system_call_fastpath+0x16/0x1b
[75436.069242] Code: 0f 44 c5 48 c7 43 10 00 00 00 00 e9 50 ff ff ff
0f 1f 44 00 00 49 8b bc 24 00 01 00 00 48 8b 8f 80 02 00 00 48 8b 81
d0 00 00 00 <48> 83 78 10 01 19 c0 83 e0 36 83 c0 6c e9 76 ff ff ff 48
8b 87
[75436.069405] RIP  [<ffffffff81155d4e>] reiserfs_security_init+0xfe/0x110
[75436.069431]  RSP <ffff880004639b58>
[75436.069448] CR2: 0000000000000010
[75436.069860] ---[ end trace d53dc3730bc1fcd2 ]---
