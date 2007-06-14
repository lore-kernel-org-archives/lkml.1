Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbXFNAKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbXFNAKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 20:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbXFNAK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 20:10:27 -0400
Received: from mail.alkar.net ([195.248.191.95]:63817 "EHLO mail.alkar.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbXFNAK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 20:10:26 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 20:10:26 EDT
Message-ID: <46708E98.9070904@namesys.com>
Date: Thu, 14 Jun 2007 03:40:56 +0300
From: "Vladimir V. Saveliev" <vs@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.11) Gecko/20050727
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: reiserfs-devel@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc4-git5 reiserfs: null ptr deref.
References: <20070613160944.495ccff4.randy.dunlap@oracle.com>
In-Reply-To: <20070613160944.495ccff4.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Randy Dunlap wrote:
> while running fsx-linux on x86_64 system:
> 
thanks, I will take a look.

Is it reproducible? If yes, would you please try on some earlier kernel?

> [ 2213.064351] ReiserFS: sdb1: found reiserfs format "3.6" with standard journal
> [ 2213.071516] ReiserFS: sdb1: using journaled data mode
> [ 2213.083124] ReiserFS: sdb1: journal params: device sdb1, size 8192, journal first block 34, max trans len 512, max batch 450, max commit age 30, max trans age 30
> [ 2213.098843] ReiserFS: sdb1: checking transaction log (sdb1)
> [ 2213.362156] ReiserFS: sdb1: Using r5 hash to sort names
> [ 2228.264867] Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
> [ 2228.270363]  [<ffffffff88026e8d>] :reiserfs:do_journal_end+0x5de/0xced
> [ 2228.279370] PGD 114991067 PUD 105050067 PMD 0
> [ 2228.283865] Oops: 0000 [1] SMP
> [ 2228.287044] CPU 0
> [ 2228.289078] Modules linked in: reiserfs loop
> [ 2228.293401] Pid: 5280, comm: fsx-linux Not tainted 2.6.22-rc4-git5 #1
> [ 2228.299834] RIP: 0010:[<ffffffff88026e8d>]  [<ffffffff88026e8d>] :reiserfs:do_journal_end+0x5de/0xced
> [ 2228.309076] RSP: 0018:ffff810106c6da48  EFLAGS: 00010286
> [ 2228.314385] RAX: 0000000000000000 RBX: ffffc200102cdf10 RCX: ffff81011c861800
> [ 2228.321512] RDX: 0000000000000020 RSI: 0000000000000000 RDI: ffffc20010292220
> [ 2228.328639] RBP: ffff810106c6db18 R08: 0000000000000002 R09: 0000000000000000
> [ 2228.335767] R10: ffffc200102cdf10 R11: 0000000000000048 R12: ffffc200102cbc78
> [ 2228.342895] R13: ffffc200102cdf10 R14: ffffc20010282000 R15: ffff81011e5fe800
> [ 2228.350024] FS:  00002b02d6aa7ae0(0000) GS:ffffffff80721000(0000) knlGS:0000000000000000
> [ 2228.358102] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 2228.363844] CR2: 0000000000000000 CR3: 000000010b6ea000 CR4: 00000000000006e0
> [ 2228.370972] Process fsx-linux (pid: 5280, threadinfo ffff810106c6c000, task ffff81011db7c040)
> [ 2228.379483] Stack:  ffff8101143ae200 00000000000a9c2c ffff810106c6da68 ffffffff00000001
> [ 2228.387565]  ffff810106c6db38 0000000000000020 ffff81011c861800 ffff81011c5fd000
> [ 2228.395039]  ffff81010dc7c2d0 0000000000000001 0000000000000000 ffff810114b383c0
> [ 2228.402313] Call Trace:
> [ 2228.404963]  [<ffffffff80247f8b>] autoremove_wake_function+0x0/0x38
> [ 2228.411236]  [<ffffffff88027568>] :reiserfs:do_journal_end+0xcb9/0xced
> [ 2228.417766]  [<ffffffff88027951>] :reiserfs:do_journal_begin_r+0x260/0x335
> [ 2228.424643]  [<ffffffff88027ade>] :reiserfs:journal_begin+0xb8/0xf6
> [ 2228.430913]  [<ffffffff88022581>] :reiserfs:reiserfs_do_truncate+0x418/0x4be
> [ 2228.437961]  [<ffffffff8800f2e4>] :reiserfs:reiserfs_truncate_file+0x1a4/0x2b6
> [ 2228.445183]  [<ffffffff88012a42>] :reiserfs:reiserfs_vfs_truncate_file+0xe/0x10
> [ 2228.452492]  [<ffffffff802773b3>] vmtruncate+0xaf/0xd0
> [ 2228.457632]  [<ffffffff8029c66c>] inode_setattr+0x2b/0x125
> [ 2228.463120]  [<ffffffff88012136>] :reiserfs:reiserfs_setattr+0x191/0x1bf
> [ 2228.469818]  [<ffffffff80552279>] __down_write_nested+0x3d/0xa1
> [ 2228.475730]  [<ffffffff8029c88f>] notify_change+0x129/0x23a
> [ 2228.481300]  [<ffffffff80288289>] do_truncate+0x63/0x81
> [ 2228.486521]  [<ffffffff80288391>] sys_ftruncate+0xea/0x107
> [ 2228.492003]  [<ffffffff8020948e>] system_call+0x7e/0x83
> [ 2228.497223]
> [ 2228.498721]
> [ 2228.498722] Code: 8b 00 66 85 c0 0f 89 97 01 00 00 4c 89 ff 44 89 85 48 ff ff
> [ 2228.507806] RIP  [<ffffffff88026e8d>] :reiserfs:do_journal_end+0x5de/0xced
> [ 2228.514700]  RSP <ffff810106c6da48>
> [ 2228.518190] CR2: 0000000000000000
> [ 2228.521841] Kernel panic - not syncing: Fatal exception
> [ 2228.527080] Rebooting in 30 seconds..
> 
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> -
> To unsubscribe from this list: send the line "unsubscribe reiserfs-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

